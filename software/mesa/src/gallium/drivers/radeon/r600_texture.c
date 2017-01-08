/*
 * Copyright 2010 Jerome Glisse <glisse@freedesktop.org>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * on the rights to use, copy, modify, merge, publish, distribute, sub
 * license, and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice (including the next
 * paragraph) shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHOR(S) AND/OR THEIR SUPPLIERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
 * USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Authors:
 *      Jerome Glisse
 *      Corbin Simpson
 */
#include "r600_pipe_common.h"
#include "r600_cs.h"
#include "r600_query.h"
#include "util/u_format.h"
#include "util/u_memory.h"
#include "util/u_pack_color.h"
#include "util/u_surface.h"
#include "os/os_time.h"
#include <errno.h>
#include <inttypes.h>

static void r600_texture_discard_cmask(struct r600_common_screen *rscreen,
				       struct r600_texture *rtex);
static unsigned r600_choose_tiling(struct r600_common_screen *rscreen,
				   const struct pipe_resource *templ);


bool r600_prepare_for_dma_blit(struct r600_common_context *rctx,
			       struct r600_texture *rdst,
			       unsigned dst_level, unsigned dstx,
			       unsigned dsty, unsigned dstz,
			       struct r600_texture *rsrc,
			       unsigned src_level,
			       const struct pipe_box *src_box)
{
	if (!rctx->dma.cs)
		return false;

	if (util_format_get_blocksizebits(rdst->resource.b.b.format) !=
	    util_format_get_blocksizebits(rsrc->resource.b.b.format))
		return false;

	/* MSAA: Blits don't exist in the real world. */
	if (rsrc->resource.b.b.nr_samples > 1 ||
	    rdst->resource.b.b.nr_samples > 1)
		return false;

	/* Depth-stencil surfaces:
	 *   When dst is linear, the DB->CB copy preserves HTILE.
	 *   When dst is tiled, the 3D path must be used to update HTILE.
	 */
	if (rsrc->is_depth || rdst->is_depth)
		return false;

	/* DCC as:
	 *   src: Use the 3D path. DCC decompression is expensive.
	 *   dst: Use the 3D path to compress the pixels with DCC.
	 */
	if ((rsrc->dcc_offset && rsrc->surface.level[src_level].dcc_enabled) ||
	    (rdst->dcc_offset && rdst->surface.level[dst_level].dcc_enabled))
		return false;

	/* CMASK as:
	 *   src: Both texture and SDMA paths need decompression. Use SDMA.
	 *   dst: If overwriting the whole texture, discard CMASK and use
	 *        SDMA. Otherwise, use the 3D path.
	 */
	if (rdst->cmask.size && rdst->dirty_level_mask & (1 << dst_level)) {
		/* The CMASK clear is only enabled for the first level. */
		assert(dst_level == 0);
		if (!util_texrange_covers_whole_level(&rdst->resource.b.b, dst_level,
						      dstx, dsty, dstz, src_box->width,
						      src_box->height, src_box->depth))
			return false;

		r600_texture_discard_cmask(rctx->screen, rdst);
	}

	/* All requirements are met. Prepare textures for SDMA. */
	if (rsrc->cmask.size && rsrc->dirty_level_mask & (1 << src_level))
		rctx->b.flush_resource(&rctx->b, &rsrc->resource.b.b);

	assert(!(rsrc->dirty_level_mask & (1 << src_level)));
	assert(!(rdst->dirty_level_mask & (1 << dst_level)));

	return true;
}

/* Same as resource_copy_region, except that both upsampling and downsampling are allowed. */
static void r600_copy_region_with_blit(struct pipe_context *pipe,
				       struct pipe_resource *dst,
                                       unsigned dst_level,
                                       unsigned dstx, unsigned dsty, unsigned dstz,
                                       struct pipe_resource *src,
                                       unsigned src_level,
                                       const struct pipe_box *src_box)
{
	struct pipe_blit_info blit;

	memset(&blit, 0, sizeof(blit));
	blit.src.resource = src;
	blit.src.format = src->format;
	blit.src.level = src_level;
	blit.src.box = *src_box;
	blit.dst.resource = dst;
	blit.dst.format = dst->format;
	blit.dst.level = dst_level;
	blit.dst.box.x = dstx;
	blit.dst.box.y = dsty;
	blit.dst.box.z = dstz;
	blit.dst.box.width = src_box->width;
	blit.dst.box.height = src_box->height;
	blit.dst.box.depth = src_box->depth;
	blit.mask = util_format_get_mask(src->format) &
		    util_format_get_mask(dst->format);
	blit.filter = PIPE_TEX_FILTER_NEAREST;

	if (blit.mask) {
		pipe->blit(pipe, &blit);
	}
}

/* Copy from a full GPU texture to a transfer's staging one. */
static void r600_copy_to_staging_texture(struct pipe_context *ctx, struct r600_transfer *rtransfer)
{
	struct r600_common_context *rctx = (struct r600_common_context*)ctx;
	struct pipe_transfer *transfer = (struct pipe_transfer*)rtransfer;
	struct pipe_resource *dst = &rtransfer->staging->b.b;
	struct pipe_resource *src = transfer->resource;

	if (src->nr_samples > 1) {
		r600_copy_region_with_blit(ctx, dst, 0, 0, 0, 0,
					   src, transfer->level, &transfer->box);
		return;
	}

	rctx->dma_copy(ctx, dst, 0, 0, 0, 0, src, transfer->level,
		       &transfer->box);
}

/* Copy from a transfer's staging texture to a full GPU one. */
static void r600_copy_from_staging_texture(struct pipe_context *ctx, struct r600_transfer *rtransfer)
{
	struct r600_common_context *rctx = (struct r600_common_context*)ctx;
	struct pipe_transfer *transfer = (struct pipe_transfer*)rtransfer;
	struct pipe_resource *dst = transfer->resource;
	struct pipe_resource *src = &rtransfer->staging->b.b;
	struct pipe_box sbox;

	u_box_3d(0, 0, 0, transfer->box.width, transfer->box.height, transfer->box.depth, &sbox);

	if (dst->nr_samples > 1) {
		r600_copy_region_with_blit(ctx, dst, transfer->level,
					   transfer->box.x, transfer->box.y, transfer->box.z,
					   src, 0, &sbox);
		return;
	}

	rctx->dma_copy(ctx, dst, transfer->level,
		       transfer->box.x, transfer->box.y, transfer->box.z,
		       src, 0, &sbox);
}

static unsigned r600_texture_get_offset(struct r600_texture *rtex, unsigned level,
					const struct pipe_box *box)
{
	enum pipe_format format = rtex->resource.b.b.format;

	return rtex->surface.level[level].offset +
	       box->z * rtex->surface.level[level].slice_size +
	       box->y / util_format_get_blockheight(format) * rtex->surface.level[level].pitch_bytes +
	       box->x / util_format_get_blockwidth(format) * util_format_get_blocksize(format);
}

static int r600_init_surface(struct r600_common_screen *rscreen,
			     struct radeon_surf *surface,
			     const struct pipe_resource *ptex,
			     unsigned array_mode,
			     bool is_flushed_depth)
{
	const struct util_format_description *desc =
		util_format_description(ptex->format);
	bool is_depth, is_stencil;

	is_depth = util_format_has_depth(desc);
	is_stencil = util_format_has_stencil(desc);

	surface->npix_x = ptex->width0;
	surface->npix_y = ptex->height0;
	surface->npix_z = ptex->depth0;
	surface->blk_w = util_format_get_blockwidth(ptex->format);
	surface->blk_h = util_format_get_blockheight(ptex->format);
	surface->blk_d = 1;
	surface->array_size = 1;
	surface->last_level = ptex->last_level;

	if (rscreen->chip_class >= EVERGREEN && !is_flushed_depth &&
	    ptex->format == PIPE_FORMAT_Z32_FLOAT_S8X24_UINT) {
		surface->bpe = 4; /* stencil is allocated separately on evergreen */
	} else {
		surface->bpe = util_format_get_blocksize(ptex->format);
		/* align byte per element on dword */
		if (surface->bpe == 3) {
			surface->bpe = 4;
		}
	}

	surface->nsamples = ptex->nr_samples ? ptex->nr_samples : 1;
	surface->flags = RADEON_SURF_SET(array_mode, MODE);

	switch (ptex->target) {
	case PIPE_TEXTURE_1D:
		surface->flags |= RADEON_SURF_SET(RADEON_SURF_TYPE_1D, TYPE);
		break;
	case PIPE_TEXTURE_RECT:
	case PIPE_TEXTURE_2D:
		surface->flags |= RADEON_SURF_SET(RADEON_SURF_TYPE_2D, TYPE);
		break;
	case PIPE_TEXTURE_3D:
		surface->flags |= RADEON_SURF_SET(RADEON_SURF_TYPE_3D, TYPE);
		break;
	case PIPE_TEXTURE_1D_ARRAY:
		surface->flags |= RADEON_SURF_SET(RADEON_SURF_TYPE_1D_ARRAY, TYPE);
		surface->array_size = ptex->array_size;
		break;
	case PIPE_TEXTURE_CUBE_ARRAY: /* cube array layout like 2d array */
		assert(ptex->array_size % 6 == 0);
	case PIPE_TEXTURE_2D_ARRAY:
		surface->flags |= RADEON_SURF_SET(RADEON_SURF_TYPE_2D_ARRAY, TYPE);
		surface->array_size = ptex->array_size;
		break;
	case PIPE_TEXTURE_CUBE:
		surface->flags |= RADEON_SURF_SET(RADEON_SURF_TYPE_CUBEMAP, TYPE);
		break;
	case PIPE_BUFFER:
	default:
		return -EINVAL;
	}

	if (!is_flushed_depth && is_depth) {
		surface->flags |= RADEON_SURF_ZBUFFER;

		if (is_stencil) {
			surface->flags |= RADEON_SURF_SBUFFER |
					  RADEON_SURF_HAS_SBUFFER_MIPTREE;
		}
	}
	if (rscreen->chip_class >= SI) {
		surface->flags |= RADEON_SURF_HAS_TILE_MODE_INDEX;
	}

	if (rscreen->chip_class >= VI &&
	    (ptex->flags & R600_RESOURCE_FLAG_DISABLE_DCC ||
	     ptex->format == PIPE_FORMAT_R9G9B9E5_FLOAT))
		surface->flags |= RADEON_SURF_DISABLE_DCC;

	if (ptex->bind & PIPE_BIND_SCANOUT) {
		/* This should catch bugs in gallium users setting incorrect flags. */
		assert(surface->nsamples == 1 &&
		       surface->array_size == 1 &&
		       surface->npix_z == 1 &&
		       surface->last_level == 0 &&
		       !(surface->flags & RADEON_SURF_Z_OR_SBUFFER));

		surface->flags |= RADEON_SURF_SCANOUT;
	}
	return 0;
}

static int r600_setup_surface(struct pipe_screen *screen,
			      struct r600_texture *rtex,
			      unsigned pitch_in_bytes_override,
			      unsigned offset)
{
	struct r600_common_screen *rscreen = (struct r600_common_screen*)screen;
	unsigned i;
	int r;

	r = rscreen->ws->surface_init(rscreen->ws, &rtex->surface);
	if (r) {
		return r;
	}

	rtex->size = rtex->surface.bo_size;

	if (pitch_in_bytes_override && pitch_in_bytes_override != rtex->surface.level[0].pitch_bytes) {
		/* old ddx on evergreen over estimate alignment for 1d, only 1 level
		 * for those
		 */
		rtex->surface.level[0].nblk_x = pitch_in_bytes_override / rtex->surface.bpe;
		rtex->surface.level[0].pitch_bytes = pitch_in_bytes_override;
		rtex->surface.level[0].slice_size = pitch_in_bytes_override * rtex->surface.level[0].nblk_y;
	}

	if (offset) {
		for (i = 0; i < ARRAY_SIZE(rtex->surface.level); ++i)
			rtex->surface.level[i].offset += offset;
	}
	return 0;
}

static void r600_texture_init_metadata(struct r600_texture *rtex,
				       struct radeon_bo_metadata *metadata)
{
	struct radeon_surf *surface = &rtex->surface;

	memset(metadata, 0, sizeof(*metadata));
	metadata->microtile = surface->level[0].mode >= RADEON_SURF_MODE_1D ?
				   RADEON_LAYOUT_TILED : RADEON_LAYOUT_LINEAR;
	metadata->macrotile = surface->level[0].mode >= RADEON_SURF_MODE_2D ?
				   RADEON_LAYOUT_TILED : RADEON_LAYOUT_LINEAR;
	metadata->pipe_config = surface->pipe_config;
	metadata->bankw = surface->bankw;
	metadata->bankh = surface->bankh;
	metadata->tile_split = surface->tile_split;
	metadata->mtilea = surface->mtilea;
	metadata->num_banks = surface->num_banks;
	metadata->stride = surface->level[0].pitch_bytes;
	metadata->scanout = (surface->flags & RADEON_SURF_SCANOUT) != 0;
}

static void r600_dirty_all_framebuffer_states(struct r600_common_screen *rscreen)
{
	p_atomic_inc(&rscreen->dirty_fb_counter);
}

static void r600_eliminate_fast_color_clear(struct r600_common_screen *rscreen,
				      struct r600_texture *rtex)
{
	struct pipe_context *ctx = rscreen->aux_context;

	pipe_mutex_lock(rscreen->aux_context_lock);
	ctx->flush_resource(ctx, &rtex->resource.b.b);
	ctx->flush(ctx, NULL, 0);
	pipe_mutex_unlock(rscreen->aux_context_lock);
}

static void r600_texture_discard_cmask(struct r600_common_screen *rscreen,
				       struct r600_texture *rtex)
{
	if (!rtex->cmask.size)
		return;

	assert(rtex->resource.b.b.nr_samples <= 1);

	/* Disable CMASK. */
	memset(&rtex->cmask, 0, sizeof(rtex->cmask));
	rtex->cmask.base_address_reg = rtex->resource.gpu_address >> 8;
	rtex->dirty_level_mask = 0;

	if (rscreen->chip_class >= SI)
		rtex->cb_color_info &= ~SI_S_028C70_FAST_CLEAR(1);
	else
		rtex->cb_color_info &= ~EG_S_028C70_FAST_CLEAR(1);

	if (rtex->cmask_buffer != &rtex->resource)
	    r600_resource_reference(&rtex->cmask_buffer, NULL);

	/* Notify all contexts about the change. */
	r600_dirty_all_framebuffer_states(rscreen);
	p_atomic_inc(&rscreen->compressed_colortex_counter);
}

static bool r600_can_disable_dcc(struct r600_texture *rtex)
{
	/* We can't disable DCC if it can be written by another process. */
	return rtex->dcc_offset &&
	       (!rtex->resource.is_shared ||
		!(rtex->resource.external_usage & PIPE_HANDLE_USAGE_WRITE));
}

static bool r600_texture_discard_dcc(struct r600_common_screen *rscreen,
				     struct r600_texture *rtex)
{
	if (!r600_can_disable_dcc(rtex))
		return false;

	assert(rtex->dcc_separate_buffer == NULL);

	/* Disable DCC. */
	rtex->dcc_offset = 0;

	/* Notify all contexts about the change. */
	r600_dirty_all_framebuffer_states(rscreen);
	return true;
}

/**
 * Disable DCC for the texture. (first decompress, then discard metadata).
 *
 * There is unresolved multi-context synchronization issue between
 * screen::aux_context and the current context. If applications do this with
 * multiple contexts, it's already undefined behavior for them and we don't
 * have to worry about that. The scenario is:
 *
 * If context 1 disables DCC and context 2 has queued commands that write
 * to the texture via CB with DCC enabled, and the order of operations is
 * as follows:
 *   context 2 queues draw calls rendering to the texture, but doesn't flush
 *   context 1 disables DCC and flushes
 *   context 1 & 2 reset descriptors and FB state
 *   context 2 flushes (new compressed tiles written by the draw calls)
 *   context 1 & 2 read garbage, because DCC is disabled, yet there are
 *   compressed tiled
 *
 * \param rctx  the current context if you have one, or rscreen->aux_context
 *              if you don't.
 */
bool r600_texture_disable_dcc(struct r600_common_context *rctx,
			      struct r600_texture *rtex)
{
	struct r600_common_screen *rscreen = rctx->screen;

	if (!r600_can_disable_dcc(rtex))
		return false;

	if (&rctx->b == rscreen->aux_context)
		pipe_mutex_lock(rscreen->aux_context_lock);

	/* Decompress DCC. */
	rctx->decompress_dcc(&rctx->b, rtex);
	rctx->b.flush(&rctx->b, NULL, 0);

	if (&rctx->b == rscreen->aux_context)
		pipe_mutex_unlock(rscreen->aux_context_lock);

	return r600_texture_discard_dcc(rscreen, rtex);
}

static void r600_degrade_tile_mode_to_linear(struct r600_common_context *rctx,
					     struct r600_texture *rtex,
					     bool invalidate_storage)
{
	struct pipe_screen *screen = rctx->b.screen;
	struct r600_texture *new_tex;
	struct pipe_resource templ = rtex->resource.b.b;
	unsigned i;

	templ.bind |= PIPE_BIND_LINEAR;

	/* r600g doesn't react to dirty_tex_descriptor_counter */
	if (rctx->chip_class < SI)
		return;

	if (rtex->resource.is_shared ||
	    rtex->surface.level[0].mode == RADEON_SURF_MODE_LINEAR_ALIGNED)
		return;

	/* This fails with MSAA, depth, and compressed textures. */
	if (r600_choose_tiling(rctx->screen, &templ) !=
	    RADEON_SURF_MODE_LINEAR_ALIGNED)
		return;

	new_tex = (struct r600_texture*)screen->resource_create(screen, &templ);
	if (!new_tex)
		return;

	/* Copy the pixels to the new texture. */
	if (!invalidate_storage) {
		for (i = 0; i <= templ.last_level; i++) {
			struct pipe_box box;

			u_box_3d(0, 0, 0,
				 u_minify(templ.width0, i), u_minify(templ.height0, i),
				 util_max_layer(&templ, i) + 1, &box);

			rctx->dma_copy(&rctx->b, &new_tex->resource.b.b, i, 0, 0, 0,
				       &rtex->resource.b.b, i, &box);
		}
	}

	r600_texture_discard_cmask(rctx->screen, rtex);
	r600_texture_discard_dcc(rctx->screen, rtex);

	/* Replace the structure fields of rtex. */
	rtex->resource.b.b.bind = templ.bind;
	pb_reference(&rtex->resource.buf, new_tex->resource.buf);
	rtex->resource.gpu_address = new_tex->resource.gpu_address;
	rtex->resource.domains = new_tex->resource.domains;
	rtex->size = new_tex->size;
	rtex->surface = new_tex->surface;
	rtex->non_disp_tiling = new_tex->non_disp_tiling;
	rtex->cb_color_info = new_tex->cb_color_info;
	rtex->cmask = new_tex->cmask; /* needed even without CMASK */

	assert(!rtex->htile_buffer);
	assert(!rtex->cmask.size);
	assert(!rtex->fmask.size);
	assert(!rtex->dcc_offset);
	assert(!rtex->is_depth);

	r600_texture_reference(&new_tex, NULL);

	r600_dirty_all_framebuffer_states(rctx->screen);
	p_atomic_inc(&rctx->screen->dirty_tex_descriptor_counter);
}

static boolean r600_texture_get_handle(struct pipe_screen* screen,
				       struct pipe_context *ctx,
				       struct pipe_resource *resource,
				       struct winsys_handle *whandle,
                                       unsigned usage)
{
	struct r600_common_screen *rscreen = (struct r600_common_screen*)screen;
	struct r600_common_context *aux_context =
		(struct r600_common_context*)rscreen->aux_context;
	struct r600_resource *res = (struct r600_resource*)resource;
	struct r600_texture *rtex = (struct r600_texture*)resource;
	struct radeon_bo_metadata metadata;
	bool update_metadata = false;

	/* This is not supported now, but it might be required for OpenCL
	 * interop in the future.
	 */
	if (resource->target != PIPE_BUFFER &&
	    (resource->nr_samples > 1 || rtex->is_depth))
		return false;

	if (resource->target != PIPE_BUFFER) {
		/* Since shader image stores don't support DCC on VI,
		 * disable it for external clients that want write
		 * access.
		 */
		if (usage & PIPE_HANDLE_USAGE_WRITE && rtex->dcc_offset) {
			if (r600_texture_disable_dcc(aux_context, rtex))
				update_metadata = true;
		}

		if (!(usage & PIPE_HANDLE_USAGE_EXPLICIT_FLUSH) &&
		    rtex->cmask.size) {
			/* Eliminate fast clear (both CMASK and DCC) */
			r600_eliminate_fast_color_clear(rscreen, rtex);

			/* Disable CMASK if flush_resource isn't going
			 * to be called.
			 */
			r600_texture_discard_cmask(rscreen, rtex);
		}

		/* Set metadata. */
		if (!res->is_shared || update_metadata) {
			r600_texture_init_metadata(rtex, &metadata);
			if (rscreen->query_opaque_metadata)
				rscreen->query_opaque_metadata(rscreen, rtex,
							       &metadata);

			rscreen->ws->buffer_set_metadata(res->buf, &metadata);
		}
	}

	if (res->is_shared) {
		/* USAGE_EXPLICIT_FLUSH must be cleared if at least one user
		 * doesn't set it.
		 */
		res->external_usage |= usage & ~PIPE_HANDLE_USAGE_EXPLICIT_FLUSH;
		if (!(usage & PIPE_HANDLE_USAGE_EXPLICIT_FLUSH))
			res->external_usage &= ~PIPE_HANDLE_USAGE_EXPLICIT_FLUSH;
	} else {
		res->is_shared = true;
		res->external_usage = usage;
	}

	return rscreen->ws->buffer_get_handle(res->buf,
					      rtex->surface.level[0].pitch_bytes,
					      rtex->surface.level[0].offset,
					      rtex->surface.level[0].slice_size,
					      whandle);
}

static void r600_texture_destroy(struct pipe_screen *screen,
				 struct pipe_resource *ptex)
{
	struct r600_texture *rtex = (struct r600_texture*)ptex;
	struct r600_resource *resource = &rtex->resource;

	r600_texture_reference(&rtex->flushed_depth_texture, NULL);

	r600_resource_reference(&rtex->htile_buffer, NULL);
	if (rtex->cmask_buffer != &rtex->resource) {
	    r600_resource_reference(&rtex->cmask_buffer, NULL);
	}
	pb_reference(&resource->buf, NULL);
	r600_resource_reference(&rtex->dcc_separate_buffer, NULL);
	r600_resource_reference(&rtex->last_dcc_separate_buffer, NULL);
	FREE(rtex);
}

static const struct u_resource_vtbl r600_texture_vtbl;

/* The number of samples can be specified independently of the texture. */
void r600_texture_get_fmask_info(struct r600_common_screen *rscreen,
				 struct r600_texture *rtex,
				 unsigned nr_samples,
				 struct r600_fmask_info *out)
{
	/* FMASK is allocated like an ordinary texture. */
	struct radeon_surf fmask = rtex->surface;

	memset(out, 0, sizeof(*out));

	fmask.bo_alignment = 0;
	fmask.bo_size = 0;
	fmask.nsamples = 1;
	fmask.flags |= RADEON_SURF_FMASK;

	/* Force 2D tiling if it wasn't set. This may occur when creating
	 * FMASK for MSAA resolve on R6xx. On R6xx, the single-sample
	 * destination buffer must have an FMASK too. */
	fmask.flags = RADEON_SURF_CLR(fmask.flags, MODE);
	fmask.flags |= RADEON_SURF_SET(RADEON_SURF_MODE_2D, MODE);

	if (rscreen->chip_class >= SI) {
		fmask.flags |= RADEON_SURF_HAS_TILE_MODE_INDEX;
	}

	switch (nr_samples) {
	case 2:
	case 4:
		fmask.bpe = 1;
		if (rscreen->chip_class <= CAYMAN) {
			fmask.bankh = 4;
		}
		break;
	case 8:
		fmask.bpe = 4;
		break;
	default:
		R600_ERR("Invalid sample count for FMASK allocation.\n");
		return;
	}

	/* Overallocate FMASK on R600-R700 to fix colorbuffer corruption.
	 * This can be fixed by writing a separate FMASK allocator specifically
	 * for R600-R700 asics. */
	if (rscreen->chip_class <= R700) {
		fmask.bpe *= 2;
	}

	if (rscreen->ws->surface_init(rscreen->ws, &fmask)) {
		R600_ERR("Got error in surface_init while allocating FMASK.\n");
		return;
	}

	assert(fmask.level[0].mode == RADEON_SURF_MODE_2D);

	out->slice_tile_max = (fmask.level[0].nblk_x * fmask.level[0].nblk_y) / 64;
	if (out->slice_tile_max)
		out->slice_tile_max -= 1;

	out->tile_mode_index = fmask.tiling_index[0];
	out->pitch_in_pixels = fmask.level[0].nblk_x;
	out->bank_height = fmask.bankh;
	out->alignment = MAX2(256, fmask.bo_alignment);
	out->size = fmask.bo_size;
}

static void r600_texture_allocate_fmask(struct r600_common_screen *rscreen,
					struct r600_texture *rtex)
{
	r600_texture_get_fmask_info(rscreen, rtex,
				    rtex->resource.b.b.nr_samples, &rtex->fmask);

	rtex->fmask.offset = align64(rtex->size, rtex->fmask.alignment);
	rtex->size = rtex->fmask.offset + rtex->fmask.size;
}

void r600_texture_get_cmask_info(struct r600_common_screen *rscreen,
				 struct r600_texture *rtex,
				 struct r600_cmask_info *out)
{
	unsigned cmask_tile_width = 8;
	unsigned cmask_tile_height = 8;
	unsigned cmask_tile_elements = cmask_tile_width * cmask_tile_height;
	unsigned element_bits = 4;
	unsigned cmask_cache_bits = 1024;
	unsigned num_pipes = rscreen->info.num_tile_pipes;
	unsigned pipe_interleave_bytes = rscreen->info.pipe_interleave_bytes;

	unsigned elements_per_macro_tile = (cmask_cache_bits / element_bits) * num_pipes;
	unsigned pixels_per_macro_tile = elements_per_macro_tile * cmask_tile_elements;
	unsigned sqrt_pixels_per_macro_tile = sqrt(pixels_per_macro_tile);
	unsigned macro_tile_width = util_next_power_of_two(sqrt_pixels_per_macro_tile);
	unsigned macro_tile_height = pixels_per_macro_tile / macro_tile_width;

	unsigned pitch_elements = align(rtex->surface.npix_x, macro_tile_width);
	unsigned height = align(rtex->surface.npix_y, macro_tile_height);

	unsigned base_align = num_pipes * pipe_interleave_bytes;
	unsigned slice_bytes =
		((pitch_elements * height * element_bits + 7) / 8) / cmask_tile_elements;

	assert(macro_tile_width % 128 == 0);
	assert(macro_tile_height % 128 == 0);

	out->pitch = pitch_elements;
	out->height = height;
	out->xalign = macro_tile_width;
	out->yalign = macro_tile_height;
	out->slice_tile_max = ((pitch_elements * height) / (128*128)) - 1;
	out->alignment = MAX2(256, base_align);
	out->size = (util_max_layer(&rtex->resource.b.b, 0) + 1) *
		    align(slice_bytes, base_align);
}

static void si_texture_get_cmask_info(struct r600_common_screen *rscreen,
				      struct r600_texture *rtex,
				      struct r600_cmask_info *out)
{
	unsigned pipe_interleave_bytes = rscreen->info.pipe_interleave_bytes;
	unsigned num_pipes = rscreen->info.num_tile_pipes;
	unsigned cl_width, cl_height;

	switch (num_pipes) {
	case 2:
		cl_width = 32;
		cl_height = 16;
		break;
	case 4:
		cl_width = 32;
		cl_height = 32;
		break;
	case 8:
		cl_width = 64;
		cl_height = 32;
		break;
	case 16: /* Hawaii */
		cl_width = 64;
		cl_height = 64;
		break;
	default:
		assert(0);
		return;
	}

	unsigned base_align = num_pipes * pipe_interleave_bytes;

	unsigned width = align(rtex->surface.npix_x, cl_width*8);
	unsigned height = align(rtex->surface.npix_y, cl_height*8);
	unsigned slice_elements = (width * height) / (8*8);

	/* Each element of CMASK is a nibble. */
	unsigned slice_bytes = slice_elements / 2;

	out->pitch = width;
	out->height = height;
	out->xalign = cl_width * 8;
	out->yalign = cl_height * 8;
	out->slice_tile_max = (width * height) / (128*128);
	if (out->slice_tile_max)
		out->slice_tile_max -= 1;

	out->alignment = MAX2(256, base_align);
	out->size = (util_max_layer(&rtex->resource.b.b, 0) + 1) *
		    align(slice_bytes, base_align);
}

static void r600_texture_allocate_cmask(struct r600_common_screen *rscreen,
					struct r600_texture *rtex)
{
	if (rscreen->chip_class >= SI) {
		si_texture_get_cmask_info(rscreen, rtex, &rtex->cmask);
	} else {
		r600_texture_get_cmask_info(rscreen, rtex, &rtex->cmask);
	}

	rtex->cmask.offset = align64(rtex->size, rtex->cmask.alignment);
	rtex->size = rtex->cmask.offset + rtex->cmask.size;

	if (rscreen->chip_class >= SI)
		rtex->cb_color_info |= SI_S_028C70_FAST_CLEAR(1);
	else
		rtex->cb_color_info |= EG_S_028C70_FAST_CLEAR(1);
}

static void r600_texture_alloc_cmask_separate(struct r600_common_screen *rscreen,
					      struct r600_texture *rtex)
{
	if (rtex->cmask_buffer)
                return;

	assert(rtex->cmask.size == 0);

	if (rscreen->chip_class >= SI) {
		si_texture_get_cmask_info(rscreen, rtex, &rtex->cmask);
	} else {
		r600_texture_get_cmask_info(rscreen, rtex, &rtex->cmask);
	}

	rtex->cmask_buffer = (struct r600_resource *)
		pipe_buffer_create(&rscreen->b, PIPE_BIND_CUSTOM,
				   PIPE_USAGE_DEFAULT, rtex->cmask.size);
	if (rtex->cmask_buffer == NULL) {
		rtex->cmask.size = 0;
		return;
	}

	/* update colorbuffer state bits */
	rtex->cmask.base_address_reg = rtex->cmask_buffer->gpu_address >> 8;

	if (rscreen->chip_class >= SI)
		rtex->cb_color_info |= SI_S_028C70_FAST_CLEAR(1);
	else
		rtex->cb_color_info |= EG_S_028C70_FAST_CLEAR(1);

	p_atomic_inc(&rscreen->compressed_colortex_counter);
}

static unsigned r600_texture_get_htile_size(struct r600_common_screen *rscreen,
					    struct r600_texture *rtex)
{
	unsigned cl_width, cl_height, width, height;
	unsigned slice_elements, slice_bytes, pipe_interleave_bytes, base_align;
	unsigned num_pipes = rscreen->info.num_tile_pipes;

	if (rscreen->chip_class <= EVERGREEN &&
	    rscreen->info.drm_major == 2 && rscreen->info.drm_minor < 26)
		return 0;

	/* HW bug on R6xx. */
	if (rscreen->chip_class == R600 &&
	    (rtex->surface.level[0].npix_x > 7680 ||
	     rtex->surface.level[0].npix_y > 7680))
		return 0;

	/* HTILE is broken with 1D tiling on old kernels and CIK. */
	if (rscreen->chip_class >= CIK &&
	    rtex->surface.level[0].mode == RADEON_SURF_MODE_1D &&
	    rscreen->info.drm_major == 2 && rscreen->info.drm_minor < 38)
		return 0;

	/* Overalign HTILE on P2 configs to work around GPU hangs in
	 * piglit/depthstencil-render-miplevels 585.
	 *
	 * This has been confirmed to help Kabini & Stoney, where the hangs
	 * are always reproducible. I think I have seen the test hang
	 * on Carrizo too, though it was very rare there.
	 */
	if (rscreen->chip_class >= CIK && num_pipes < 4)
		num_pipes = 4;

	switch (num_pipes) {
	case 1:
		cl_width = 32;
		cl_height = 16;
		break;
	case 2:
		cl_width = 32;
		cl_height = 32;
		break;
	case 4:
		cl_width = 64;
		cl_height = 32;
		break;
	case 8:
		cl_width = 64;
		cl_height = 64;
		break;
	case 16:
		cl_width = 128;
		cl_height = 64;
		break;
	default:
		assert(0);
		return 0;
	}

	width = align(rtex->surface.npix_x, cl_width * 8);
	height = align(rtex->surface.npix_y, cl_height * 8);

	slice_elements = (width * height) / (8 * 8);
	slice_bytes = slice_elements * 4;

	pipe_interleave_bytes = rscreen->info.pipe_interleave_bytes;
	base_align = num_pipes * pipe_interleave_bytes;

	rtex->htile.pitch = width;
	rtex->htile.height = height;
	rtex->htile.xalign = cl_width * 8;
	rtex->htile.yalign = cl_height * 8;

	return (util_max_layer(&rtex->resource.b.b, 0) + 1) *
		align(slice_bytes, base_align);
}

static void r600_texture_allocate_htile(struct r600_common_screen *rscreen,
					struct r600_texture *rtex)
{
	unsigned htile_size = r600_texture_get_htile_size(rscreen, rtex);

	if (!htile_size)
		return;

	rtex->htile_buffer = (struct r600_resource*)
			     pipe_buffer_create(&rscreen->b, PIPE_BIND_CUSTOM,
						PIPE_USAGE_DEFAULT, htile_size);
	if (rtex->htile_buffer == NULL) {
		/* this is not a fatal error as we can still keep rendering
		 * without htile buffer */
		R600_ERR("Failed to create buffer object for htile buffer.\n");
	} else {
		r600_screen_clear_buffer(rscreen, &rtex->htile_buffer->b.b, 0,
					 htile_size, 0, R600_COHERENCY_NONE);
	}
}

void r600_print_texture_info(struct r600_texture *rtex, FILE *f)
{
	int i;

	fprintf(f, "  Info: npix_x=%u, npix_y=%u, npix_z=%u, blk_w=%u, "
		"blk_h=%u, blk_d=%u, array_size=%u, last_level=%u, "
		"bpe=%u, nsamples=%u, flags=0x%x, %s\n",
		rtex->surface.npix_x, rtex->surface.npix_y,
		rtex->surface.npix_z, rtex->surface.blk_w,
		rtex->surface.blk_h, rtex->surface.blk_d,
		rtex->surface.array_size, rtex->surface.last_level,
		rtex->surface.bpe, rtex->surface.nsamples,
		rtex->surface.flags, util_format_short_name(rtex->resource.b.b.format));

	fprintf(f, "  Layout: size=%"PRIu64", alignment=%"PRIu64", bankw=%u, "
		"bankh=%u, nbanks=%u, mtilea=%u, tilesplit=%u, pipeconfig=%u, scanout=%u\n",
		rtex->surface.bo_size, rtex->surface.bo_alignment, rtex->surface.bankw,
		rtex->surface.bankh, rtex->surface.num_banks, rtex->surface.mtilea,
		rtex->surface.tile_split, rtex->surface.pipe_config,
		(rtex->surface.flags & RADEON_SURF_SCANOUT) != 0);

	if (rtex->fmask.size)
		fprintf(f, "  FMask: offset=%"PRIu64", size=%"PRIu64", alignment=%u, pitch_in_pixels=%u, "
			"bankh=%u, slice_tile_max=%u, tile_mode_index=%u\n",
			rtex->fmask.offset, rtex->fmask.size, rtex->fmask.alignment,
			rtex->fmask.pitch_in_pixels, rtex->fmask.bank_height,
			rtex->fmask.slice_tile_max, rtex->fmask.tile_mode_index);

	if (rtex->cmask.size)
		fprintf(f, "  CMask: offset=%"PRIu64", size=%"PRIu64", alignment=%u, pitch=%u, "
			"height=%u, xalign=%u, yalign=%u, slice_tile_max=%u\n",
			rtex->cmask.offset, rtex->cmask.size, rtex->cmask.alignment,
			rtex->cmask.pitch, rtex->cmask.height, rtex->cmask.xalign,
			rtex->cmask.yalign, rtex->cmask.slice_tile_max);

	if (rtex->htile_buffer)
		fprintf(f, "  HTile: size=%u, alignment=%u, pitch=%u, height=%u, "
			"xalign=%u, yalign=%u\n",
			rtex->htile_buffer->b.b.width0,
			rtex->htile_buffer->buf->alignment, rtex->htile.pitch,
			rtex->htile.height, rtex->htile.xalign, rtex->htile.yalign);

	if (rtex->dcc_offset) {
		fprintf(f, "  DCC: offset=%"PRIu64", size=%"PRIu64", alignment=%"PRIu64"\n",
			rtex->dcc_offset, rtex->surface.dcc_size,
			rtex->surface.dcc_alignment);
		for (i = 0; i <= rtex->surface.last_level; i++)
			fprintf(f, "  DCCLevel[%i]: enabled=%u, offset=%"PRIu64", "
				"fast_clear_size=%"PRIu64"\n",
				i, rtex->surface.level[i].dcc_enabled,
				rtex->surface.level[i].dcc_offset,
				rtex->surface.level[i].dcc_fast_clear_size);
	}

	for (i = 0; i <= rtex->surface.last_level; i++)
		fprintf(f, "  Level[%i]: offset=%"PRIu64", slice_size=%"PRIu64", "
			"npix_x=%u, npix_y=%u, npix_z=%u, nblk_x=%u, nblk_y=%u, "
			"nblk_z=%u, pitch_bytes=%u, mode=%u\n",
			i, rtex->surface.level[i].offset,
			rtex->surface.level[i].slice_size,
			u_minify(rtex->resource.b.b.width0, i),
			u_minify(rtex->resource.b.b.height0, i),
			u_minify(rtex->resource.b.b.depth0, i),
			rtex->surface.level[i].nblk_x,
			rtex->surface.level[i].nblk_y,
			rtex->surface.level[i].nblk_z,
			rtex->surface.level[i].pitch_bytes,
			rtex->surface.level[i].mode);

	if (rtex->surface.flags & RADEON_SURF_SBUFFER) {
		fprintf(f, "  StencilLayout: tilesplit=%u\n",
			rtex->surface.stencil_tile_split);
		for (i = 0; i <= rtex->surface.last_level; i++) {
			fprintf(f, "  StencilLevel[%i]: offset=%"PRIu64", "
				"slice_size=%"PRIu64", npix_x=%u, "
				"npix_y=%u, npix_z=%u, nblk_x=%u, nblk_y=%u, "
				"nblk_z=%u, pitch_bytes=%u, mode=%u\n",
				i, rtex->surface.stencil_level[i].offset,
				rtex->surface.stencil_level[i].slice_size,
				u_minify(rtex->resource.b.b.width0, i),
				u_minify(rtex->resource.b.b.height0, i),
				u_minify(rtex->resource.b.b.depth0, i),
				rtex->surface.stencil_level[i].nblk_x,
				rtex->surface.stencil_level[i].nblk_y,
				rtex->surface.stencil_level[i].nblk_z,
				rtex->surface.stencil_level[i].pitch_bytes,
				rtex->surface.stencil_level[i].mode);
		}
	}
}

/* Common processing for r600_texture_create and r600_texture_from_handle */
static struct r600_texture *
r600_texture_create_object(struct pipe_screen *screen,
			   const struct pipe_resource *base,
			   unsigned pitch_in_bytes_override,
			   unsigned offset,
			   struct pb_buffer *buf,
			   struct radeon_surf *surface)
{
	struct r600_texture *rtex;
	struct r600_resource *resource;
	struct r600_common_screen *rscreen = (struct r600_common_screen*)screen;

	rtex = CALLOC_STRUCT(r600_texture);
	if (!rtex)
		return NULL;

	resource = &rtex->resource;
	resource->b.b = *base;
	resource->b.vtbl = &r600_texture_vtbl;
	pipe_reference_init(&resource->b.b.reference, 1);
	resource->b.b.screen = screen;

	/* don't include stencil-only formats which we don't support for rendering */
	rtex->is_depth = util_format_has_depth(util_format_description(rtex->resource.b.b.format));

	rtex->surface = *surface;
	if (r600_setup_surface(screen, rtex, pitch_in_bytes_override, offset)) {
		FREE(rtex);
		return NULL;
	}

	/* Tiled depth textures utilize the non-displayable tile order.
	 * This must be done after r600_setup_surface.
	 * Applies to R600-Cayman. */
	rtex->non_disp_tiling = rtex->is_depth && rtex->surface.level[0].mode >= RADEON_SURF_MODE_1D;
	/* Applies to GCN. */
	rtex->last_msaa_resolve_target_micro_mode = rtex->surface.micro_tile_mode;

	/* Disable separate DCC at the beginning. DRI2 doesn't reuse buffers
	 * between frames, so the only thing that can enable separate DCC
	 * with DRI2 is multiple slow clears within a frame.
	 */
	rtex->ps_draw_ratio = 0;

	if (rtex->is_depth) {
		if (base->flags & (R600_RESOURCE_FLAG_TRANSFER |
				   R600_RESOURCE_FLAG_FLUSHED_DEPTH) ||
		    rscreen->chip_class >= EVERGREEN) {
			rtex->can_sample_z = !rtex->surface.depth_adjusted;
			rtex->can_sample_s = !rtex->surface.stencil_adjusted;
		} else {
			if (rtex->resource.b.b.nr_samples <= 1 &&
			    (rtex->resource.b.b.format == PIPE_FORMAT_Z16_UNORM ||
			     rtex->resource.b.b.format == PIPE_FORMAT_Z32_FLOAT))
				rtex->can_sample_z = true;
		}

		if (!(base->flags & (R600_RESOURCE_FLAG_TRANSFER |
				     R600_RESOURCE_FLAG_FLUSHED_DEPTH))) {
			rtex->db_compatible = true;

			if (!(rscreen->debug_flags & DBG_NO_HYPERZ))
				r600_texture_allocate_htile(rscreen, rtex);
		}
	} else {
		if (base->nr_samples > 1) {
			if (!buf) {
				r600_texture_allocate_fmask(rscreen, rtex);
				r600_texture_allocate_cmask(rscreen, rtex);
				rtex->cmask_buffer = &rtex->resource;
			}
			if (!rtex->fmask.size || !rtex->cmask.size) {
				FREE(rtex);
				return NULL;
			}
		}

		/* Shared textures must always set up DCC here.
		 * If it's not present, it will be disabled by
		 * apply_opaque_metadata later.
		 */
		if (rtex->surface.dcc_size &&
		    (buf || !(rscreen->debug_flags & DBG_NO_DCC)) &&
		    !(rtex->surface.flags & RADEON_SURF_SCANOUT)) {
			/* Reserve space for the DCC buffer. */
			rtex->dcc_offset = align64(rtex->size, rtex->surface.dcc_alignment);
			rtex->size = rtex->dcc_offset + rtex->surface.dcc_size;
		}
	}

	/* Now create the backing buffer. */
	if (!buf) {
		if (!r600_init_resource(rscreen, resource, rtex->size,
					rtex->surface.bo_alignment)) {
			FREE(rtex);
			return NULL;
		}
	} else {
		resource->buf = buf;
		resource->gpu_address = rscreen->ws->buffer_get_virtual_address(resource->buf);
		resource->domains = rscreen->ws->buffer_get_initial_domain(resource->buf);
	}

	if (rtex->cmask.size) {
		/* Initialize the cmask to 0xCC (= compressed state). */
		r600_screen_clear_buffer(rscreen, &rtex->cmask_buffer->b.b,
					 rtex->cmask.offset, rtex->cmask.size,
					 0xCCCCCCCC, R600_COHERENCY_NONE);
	}

	/* Initialize DCC only if the texture is not being imported. */
	if (!buf && rtex->dcc_offset) {
		r600_screen_clear_buffer(rscreen, &rtex->resource.b.b,
					 rtex->dcc_offset,
					 rtex->surface.dcc_size,
					 0xFFFFFFFF, R600_COHERENCY_NONE);
	}

	/* Initialize the CMASK base register value. */
	rtex->cmask.base_address_reg =
		(rtex->resource.gpu_address + rtex->cmask.offset) >> 8;

	if (rscreen->debug_flags & DBG_VM) {
		fprintf(stderr, "VM start=0x%"PRIX64"  end=0x%"PRIX64" | Texture %ix%ix%i, %i levels, %i samples, %s\n",
			rtex->resource.gpu_address,
			rtex->resource.gpu_address + rtex->resource.buf->size,
			base->width0, base->height0, util_max_layer(base, 0)+1, base->last_level+1,
			base->nr_samples ? base->nr_samples : 1, util_format_short_name(base->format));
	}

	if (rscreen->debug_flags & DBG_TEX) {
		puts("Texture:");
		r600_print_texture_info(rtex, stdout);
		fflush(stdout);
	}

	return rtex;
}

static unsigned r600_choose_tiling(struct r600_common_screen *rscreen,
				   const struct pipe_resource *templ)
{
	const struct util_format_description *desc = util_format_description(templ->format);
	bool force_tiling = templ->flags & R600_RESOURCE_FLAG_FORCE_TILING;

	/* MSAA resources must be 2D tiled. */
	if (templ->nr_samples > 1)
		return RADEON_SURF_MODE_2D;

	/* Transfer resources should be linear. */
	if (templ->flags & R600_RESOURCE_FLAG_TRANSFER)
		return RADEON_SURF_MODE_LINEAR_ALIGNED;

	/* r600g: force tiling on TEXTURE_2D and TEXTURE_3D compute resources. */
	if (rscreen->chip_class >= R600 && rscreen->chip_class <= CAYMAN &&
	    (templ->bind & PIPE_BIND_COMPUTE_RESOURCE) &&
	    (templ->target == PIPE_TEXTURE_2D ||
	     templ->target == PIPE_TEXTURE_3D))
		force_tiling = true;

	/* Handle common candidates for the linear mode.
	 * Compressed textures and DB surfaces must always be tiled.
	 */
	if (!force_tiling && !util_format_is_compressed(templ->format) &&
	    (!util_format_is_depth_or_stencil(templ->format) ||
	     templ->flags & R600_RESOURCE_FLAG_FLUSHED_DEPTH)) {
		if (rscreen->debug_flags & DBG_NO_TILING)
			return RADEON_SURF_MODE_LINEAR_ALIGNED;

		/* Tiling doesn't work with the 422 (SUBSAMPLED) formats on R600+. */
		if (desc->layout == UTIL_FORMAT_LAYOUT_SUBSAMPLED)
			return RADEON_SURF_MODE_LINEAR_ALIGNED;

		/* Cursors are linear on SI.
		 * (XXX double-check, maybe also use RADEON_SURF_SCANOUT) */
		if (rscreen->chip_class >= SI &&
		    (templ->bind & PIPE_BIND_CURSOR))
			return RADEON_SURF_MODE_LINEAR_ALIGNED;

		if (templ->bind & PIPE_BIND_LINEAR)
			return RADEON_SURF_MODE_LINEAR_ALIGNED;

		/* Textures with a very small height are recommended to be linear. */
		if (templ->target == PIPE_TEXTURE_1D ||
		    templ->target == PIPE_TEXTURE_1D_ARRAY ||
		    templ->height0 <= 4)
			return RADEON_SURF_MODE_LINEAR_ALIGNED;

		/* Textures likely to be mapped often. */
		if (templ->usage == PIPE_USAGE_STAGING ||
		    templ->usage == PIPE_USAGE_STREAM)
			return RADEON_SURF_MODE_LINEAR_ALIGNED;
	}

	/* Make small textures 1D tiled. */
	if (templ->width0 <= 16 || templ->height0 <= 16 ||
	    (rscreen->debug_flags & DBG_NO_2D_TILING))
		return RADEON_SURF_MODE_1D;

	/* The allocator will switch to 1D if needed. */
	return RADEON_SURF_MODE_2D;
}

struct pipe_resource *r600_texture_create(struct pipe_screen *screen,
					  const struct pipe_resource *templ)
{
	struct r600_common_screen *rscreen = (struct r600_common_screen*)screen;
	struct radeon_surf surface = {0};
	int r;

	r = r600_init_surface(rscreen, &surface, templ,
			      r600_choose_tiling(rscreen, templ),
			      templ->flags & R600_RESOURCE_FLAG_FLUSHED_DEPTH);
	if (r) {
		return NULL;
	}
	r = rscreen->ws->surface_best(rscreen->ws, &surface);
	if (r) {
		return NULL;
	}
	return (struct pipe_resource *)r600_texture_create_object(screen, templ, 0,
								  0, NULL, &surface);
}

static struct pipe_resource *r600_texture_from_handle(struct pipe_screen *screen,
						      const struct pipe_resource *templ,
						      struct winsys_handle *whandle,
                                                      unsigned usage)
{
	struct r600_common_screen *rscreen = (struct r600_common_screen*)screen;
	struct pb_buffer *buf = NULL;
	unsigned stride = 0, offset = 0;
	unsigned array_mode;
	struct radeon_surf surface;
	int r;
	struct radeon_bo_metadata metadata = {};
	struct r600_texture *rtex;

	/* Support only 2D textures without mipmaps */
	if ((templ->target != PIPE_TEXTURE_2D && templ->target != PIPE_TEXTURE_RECT) ||
	      templ->depth0 != 1 || templ->last_level != 0)
		return NULL;

	buf = rscreen->ws->buffer_from_handle(rscreen->ws, whandle, &stride, &offset);
	if (!buf)
		return NULL;

	rscreen->ws->buffer_get_metadata(buf, &metadata);

	surface.pipe_config = metadata.pipe_config;
	surface.bankw = metadata.bankw;
	surface.bankh = metadata.bankh;
	surface.tile_split = metadata.tile_split;
	surface.mtilea = metadata.mtilea;
	surface.num_banks = metadata.num_banks;

	if (metadata.macrotile == RADEON_LAYOUT_TILED)
		array_mode = RADEON_SURF_MODE_2D;
	else if (metadata.microtile == RADEON_LAYOUT_TILED)
		array_mode = RADEON_SURF_MODE_1D;
	else
		array_mode = RADEON_SURF_MODE_LINEAR_ALIGNED;

	r = r600_init_surface(rscreen, &surface, templ, array_mode, false);
	if (r) {
		return NULL;
	}

	if (metadata.scanout)
		surface.flags |= RADEON_SURF_SCANOUT;

	rtex = r600_texture_create_object(screen, templ, stride,
					  offset, buf, &surface);
	if (!rtex)
		return NULL;

	rtex->resource.is_shared = true;
	rtex->resource.external_usage = usage;

	if (rscreen->apply_opaque_metadata)
		rscreen->apply_opaque_metadata(rscreen, rtex, &metadata);

	return &rtex->resource.b.b;
}

bool r600_init_flushed_depth_texture(struct pipe_context *ctx,
				     struct pipe_resource *texture,
				     struct r600_texture **staging)
{
	struct r600_texture *rtex = (struct r600_texture*)texture;
	struct pipe_resource resource;
	struct r600_texture **flushed_depth_texture = staging ?
			staging : &rtex->flushed_depth_texture;
	enum pipe_format pipe_format = texture->format;

	if (!staging) {
		if (rtex->flushed_depth_texture)
			return true; /* it's ready */

		if (!rtex->can_sample_z && rtex->can_sample_s) {
			switch (pipe_format) {
			case PIPE_FORMAT_Z32_FLOAT_S8X24_UINT:
				/* Save memory by not allocating the S plane. */
				pipe_format = PIPE_FORMAT_Z32_FLOAT;
				break;
			case PIPE_FORMAT_Z24_UNORM_S8_UINT:
			case PIPE_FORMAT_S8_UINT_Z24_UNORM:
				/* Save memory bandwidth by not copying the
				 * stencil part during flush.
				 *
				 * This potentially increases memory bandwidth
				 * if an application uses both Z and S texturing
				 * simultaneously (a flushed Z24S8 texture
				 * would be stored compactly), but how often
				 * does that really happen?
				 */
				pipe_format = PIPE_FORMAT_Z24X8_UNORM;
				break;
			default:;
			}
		} else if (!rtex->can_sample_s && rtex->can_sample_z) {
			assert(util_format_has_stencil(util_format_description(pipe_format)));

			/* DB->CB copies to an 8bpp surface don't work. */
			pipe_format = PIPE_FORMAT_X24S8_UINT;
		}
	}

	resource.target = texture->target;
	resource.format = pipe_format;
	resource.width0 = texture->width0;
	resource.height0 = texture->height0;
	resource.depth0 = texture->depth0;
	resource.array_size = texture->array_size;
	resource.last_level = texture->last_level;
	resource.nr_samples = texture->nr_samples;
	resource.usage = staging ? PIPE_USAGE_STAGING : PIPE_USAGE_DEFAULT;
	resource.bind = texture->bind & ~PIPE_BIND_DEPTH_STENCIL;
	resource.flags = texture->flags | R600_RESOURCE_FLAG_FLUSHED_DEPTH;

	if (staging)
		resource.flags |= R600_RESOURCE_FLAG_TRANSFER;

	*flushed_depth_texture = (struct r600_texture *)ctx->screen->resource_create(ctx->screen, &resource);
	if (*flushed_depth_texture == NULL) {
		R600_ERR("failed to create temporary texture to hold flushed depth\n");
		return false;
	}

	(*flushed_depth_texture)->non_disp_tiling = false;
	return true;
}

/**
 * Initialize the pipe_resource descriptor to be of the same size as the box,
 * which is supposed to hold a subregion of the texture "orig" at the given
 * mipmap level.
 */
static void r600_init_temp_resource_from_box(struct pipe_resource *res,
					     struct pipe_resource *orig,
					     const struct pipe_box *box,
					     unsigned level, unsigned flags)
{
	memset(res, 0, sizeof(*res));
	res->format = orig->format;
	res->width0 = box->width;
	res->height0 = box->height;
	res->depth0 = 1;
	res->array_size = 1;
	res->usage = flags & R600_RESOURCE_FLAG_TRANSFER ? PIPE_USAGE_STAGING : PIPE_USAGE_DEFAULT;
	res->flags = flags;

	/* We must set the correct texture target and dimensions for a 3D box. */
	if (box->depth > 1 && util_max_layer(orig, level) > 0) {
		res->target = PIPE_TEXTURE_2D_ARRAY;
		res->array_size = box->depth;
	} else {
		res->target = PIPE_TEXTURE_2D;
	}
}

static bool r600_can_invalidate_texture(struct r600_common_screen *rscreen,
					struct r600_texture *rtex,
					unsigned transfer_usage,
					const struct pipe_box *box)
{
	/* r600g doesn't react to dirty_tex_descriptor_counter */
	return rscreen->chip_class >= SI &&
		!rtex->resource.is_shared &&
		!(transfer_usage & PIPE_TRANSFER_READ) &&
		rtex->resource.b.b.last_level == 0 &&
		util_texrange_covers_whole_level(&rtex->resource.b.b, 0,
						 box->x, box->y, box->z,
						 box->width, box->height,
						 box->depth);
}

static void r600_texture_invalidate_storage(struct r600_common_context *rctx,
					    struct r600_texture *rtex)
{
	struct r600_common_screen *rscreen = rctx->screen;

	/* There is no point in discarding depth and tiled buffers. */
	assert(!rtex->is_depth);
	assert(rtex->surface.level[0].mode == RADEON_SURF_MODE_LINEAR_ALIGNED);

	/* Reallocate the buffer in the same pipe_resource. */
	r600_init_resource(rscreen, &rtex->resource, rtex->size,
			   rtex->surface.bo_alignment);

	/* Initialize the CMASK base address (needed even without CMASK). */
	rtex->cmask.base_address_reg =
		(rtex->resource.gpu_address + rtex->cmask.offset) >> 8;

	r600_dirty_all_framebuffer_states(rscreen);
	p_atomic_inc(&rscreen->dirty_tex_descriptor_counter);

	rctx->num_alloc_tex_transfer_bytes += rtex->size;
}

static void *r600_texture_transfer_map(struct pipe_context *ctx,
				       struct pipe_resource *texture,
				       unsigned level,
				       unsigned usage,
				       const struct pipe_box *box,
				       struct pipe_transfer **ptransfer)
{
	struct r600_common_context *rctx = (struct r600_common_context*)ctx;
	struct r600_texture *rtex = (struct r600_texture*)texture;
	struct r600_transfer *trans;
	struct r600_resource *buf;
	unsigned offset = 0;
	char *map;
	bool use_staging_texture = false;

	assert(!(texture->flags & R600_RESOURCE_FLAG_TRANSFER));

	/* Depth textures use staging unconditionally. */
	if (!rtex->is_depth) {
		/* Degrade the tile mode if we get too many transfers on APUs.
		 * On dGPUs, the staging texture is always faster.
		 * Only count uploads that are at least 4x4 pixels large.
		 */
		if (!rctx->screen->info.has_dedicated_vram &&
		    level == 0 &&
		    box->width >= 4 && box->height >= 4 &&
		    p_atomic_inc_return(&rtex->num_level0_transfers) == 10) {
			bool can_invalidate =
				r600_can_invalidate_texture(rctx->screen, rtex,
							    usage, box);

			r600_degrade_tile_mode_to_linear(rctx, rtex,
							 can_invalidate);
		}

		/* Tiled textures need to be converted into a linear texture for CPU
		 * access. The staging texture is always linear and is placed in GART.
		 *
		 * Reading from VRAM is slow, always use the staging texture in
		 * this case.
		 *
		 * Use the staging texture for uploads if the underlying BO
		 * is busy.
		 */
		if (rtex->surface.level[0].mode >= RADEON_SURF_MODE_1D)
			use_staging_texture = true;
		else if (usage & PIPE_TRANSFER_READ)
			use_staging_texture = (rtex->resource.domains &
					       RADEON_DOMAIN_VRAM) != 0;
		/* Write & linear only: */
		else if (r600_rings_is_buffer_referenced(rctx, rtex->resource.buf,
							 RADEON_USAGE_READWRITE) ||
			 !rctx->ws->buffer_wait(rtex->resource.buf, 0,
						RADEON_USAGE_READWRITE)) {
			/* It's busy. */
			if (r600_can_invalidate_texture(rctx->screen, rtex,
							usage, box))
				r600_texture_invalidate_storage(rctx, rtex);
			else
				use_staging_texture = true;
		}
	}

	trans = CALLOC_STRUCT(r600_transfer);
	if (!trans)
		return NULL;
	trans->transfer.resource = texture;
	trans->transfer.level = level;
	trans->transfer.usage = usage;
	trans->transfer.box = *box;

	if (rtex->is_depth) {
		struct r600_texture *staging_depth;

		if (rtex->resource.b.b.nr_samples > 1) {
			/* MSAA depth buffers need to be converted to single sample buffers.
			 *
			 * Mapping MSAA depth buffers can occur if ReadPixels is called
			 * with a multisample GLX visual.
			 *
			 * First downsample the depth buffer to a temporary texture,
			 * then decompress the temporary one to staging.
			 *
			 * Only the region being mapped is transfered.
			 */
			struct pipe_resource resource;

			r600_init_temp_resource_from_box(&resource, texture, box, level, 0);

			if (!r600_init_flushed_depth_texture(ctx, &resource, &staging_depth)) {
				R600_ERR("failed to create temporary texture to hold untiled copy\n");
				FREE(trans);
				return NULL;
			}

			if (usage & PIPE_TRANSFER_READ) {
				struct pipe_resource *temp = ctx->screen->resource_create(ctx->screen, &resource);
				if (!temp) {
					R600_ERR("failed to create a temporary depth texture\n");
					FREE(trans);
					return NULL;
				}

				r600_copy_region_with_blit(ctx, temp, 0, 0, 0, 0, texture, level, box);
				rctx->blit_decompress_depth(ctx, (struct r600_texture*)temp, staging_depth,
							    0, 0, 0, box->depth, 0, 0);
				pipe_resource_reference(&temp, NULL);
			}
		}
		else {
			/* XXX: only readback the rectangle which is being mapped? */
			/* XXX: when discard is true, no need to read back from depth texture */
			if (!r600_init_flushed_depth_texture(ctx, texture, &staging_depth)) {
				R600_ERR("failed to create temporary texture to hold untiled copy\n");
				FREE(trans);
				return NULL;
			}

			rctx->blit_decompress_depth(ctx, rtex, staging_depth,
						    level, level,
						    box->z, box->z + box->depth - 1,
						    0, 0);

			offset = r600_texture_get_offset(staging_depth, level, box);
		}

		trans->transfer.stride = staging_depth->surface.level[level].pitch_bytes;
		trans->transfer.layer_stride = staging_depth->surface.level[level].slice_size;
		trans->staging = (struct r600_resource*)staging_depth;
		buf = trans->staging;
	} else if (use_staging_texture) {
		struct pipe_resource resource;
		struct r600_texture *staging;

		r600_init_temp_resource_from_box(&resource, texture, box, level,
						 R600_RESOURCE_FLAG_TRANSFER);
		resource.usage = (usage & PIPE_TRANSFER_READ) ?
			PIPE_USAGE_STAGING : PIPE_USAGE_STREAM;

		/* Create the temporary texture. */
		staging = (struct r600_texture*)ctx->screen->resource_create(ctx->screen, &resource);
		if (!staging) {
			R600_ERR("failed to create temporary texture to hold untiled copy\n");
			FREE(trans);
			return NULL;
		}
		trans->staging = &staging->resource;
		trans->transfer.stride = staging->surface.level[0].pitch_bytes;
		trans->transfer.layer_stride = staging->surface.level[0].slice_size;

		if (usage & PIPE_TRANSFER_READ)
			r600_copy_to_staging_texture(ctx, trans);
		else
			usage |= PIPE_TRANSFER_UNSYNCHRONIZED;

		buf = trans->staging;
	} else {
		/* the resource is mapped directly */
		trans->transfer.stride = rtex->surface.level[level].pitch_bytes;
		trans->transfer.layer_stride = rtex->surface.level[level].slice_size;
		offset = r600_texture_get_offset(rtex, level, box);
		buf = &rtex->resource;
	}

	if (!(map = r600_buffer_map_sync_with_rings(rctx, buf, usage))) {
		r600_resource_reference(&trans->staging, NULL);
		FREE(trans);
		return NULL;
	}

	*ptransfer = &trans->transfer;
	return map + offset;
}

static void r600_texture_transfer_unmap(struct pipe_context *ctx,
					struct pipe_transfer* transfer)
{
	struct r600_common_context *rctx = (struct r600_common_context*)ctx;
	struct r600_transfer *rtransfer = (struct r600_transfer*)transfer;
	struct pipe_resource *texture = transfer->resource;
	struct r600_texture *rtex = (struct r600_texture*)texture;

	if ((transfer->usage & PIPE_TRANSFER_WRITE) && rtransfer->staging) {
		if (rtex->is_depth && rtex->resource.b.b.nr_samples <= 1) {
			ctx->resource_copy_region(ctx, texture, transfer->level,
						  transfer->box.x, transfer->box.y, transfer->box.z,
						  &rtransfer->staging->b.b, transfer->level,
						  &transfer->box);
		} else {
			r600_copy_from_staging_texture(ctx, rtransfer);
		}
	}

	if (rtransfer->staging) {
		rctx->num_alloc_tex_transfer_bytes += rtransfer->staging->buf->size;
		r600_resource_reference(&rtransfer->staging, NULL);
	}

	/* Heuristic for {upload, draw, upload, draw, ..}:
	 *
	 * Flush the gfx IB if we've allocated too much texture storage.
	 *
	 * The idea is that we don't want to build IBs that use too much
	 * memory and put pressure on the kernel memory manager and we also
	 * want to make temporary and invalidated buffers go idle ASAP to
	 * decrease the total memory usage or make them reusable. The memory
	 * usage will be slightly higher than given here because of the buffer
	 * cache in the winsys.
	 *
	 * The result is that the kernel memory manager is never a bottleneck.
	 */
	if (rctx->num_alloc_tex_transfer_bytes > rctx->screen->info.gart_size / 4) {
		rctx->gfx.flush(rctx, RADEON_FLUSH_ASYNC, NULL);
		rctx->num_alloc_tex_transfer_bytes = 0;
	}

	FREE(transfer);
}

static const struct u_resource_vtbl r600_texture_vtbl =
{
	NULL,				/* get_handle */
	r600_texture_destroy,		/* resource_destroy */
	r600_texture_transfer_map,	/* transfer_map */
	u_default_transfer_flush_region, /* transfer_flush_region */
	r600_texture_transfer_unmap,	/* transfer_unmap */
};

struct pipe_surface *r600_create_surface_custom(struct pipe_context *pipe,
						struct pipe_resource *texture,
						const struct pipe_surface *templ,
						unsigned width, unsigned height)
{
	struct r600_texture *rtex = (struct r600_texture*)texture;
	struct r600_surface *surface = CALLOC_STRUCT(r600_surface);

	if (!surface)
		return NULL;

	assert(templ->u.tex.first_layer <= util_max_layer(texture, templ->u.tex.level));
	assert(templ->u.tex.last_layer <= util_max_layer(texture, templ->u.tex.level));

	pipe_reference_init(&surface->base.reference, 1);
	pipe_resource_reference(&surface->base.texture, texture);
	surface->base.context = pipe;
	surface->base.format = templ->format;
	surface->base.width = width;
	surface->base.height = height;
	surface->base.u = templ->u;
	surface->level_info = &rtex->surface.level[templ->u.tex.level];
	return &surface->base;
}

static struct pipe_surface *r600_create_surface(struct pipe_context *pipe,
						struct pipe_resource *tex,
						const struct pipe_surface *templ)
{
	unsigned level = templ->u.tex.level;
	unsigned width = u_minify(tex->width0, level);
	unsigned height = u_minify(tex->height0, level);

	if (tex->target != PIPE_BUFFER && templ->format != tex->format) {
		const struct util_format_description *tex_desc
			= util_format_description(tex->format);
		const struct util_format_description *templ_desc
			= util_format_description(templ->format);

		assert(tex_desc->block.bits == templ_desc->block.bits);

		/* Adjust size of surface if and only if the block width or
		 * height is changed. */
		if (tex_desc->block.width != templ_desc->block.width ||
		    tex_desc->block.height != templ_desc->block.height) {
			unsigned nblks_x = util_format_get_nblocksx(tex->format, width);
			unsigned nblks_y = util_format_get_nblocksy(tex->format, height);

			width = nblks_x * templ_desc->block.width;
			height = nblks_y * templ_desc->block.height;
		}
	}

	return r600_create_surface_custom(pipe, tex, templ, width, height);
}

static void r600_surface_destroy(struct pipe_context *pipe,
				 struct pipe_surface *surface)
{
	struct r600_surface *surf = (struct r600_surface*)surface;
	r600_resource_reference(&surf->cb_buffer_fmask, NULL);
	r600_resource_reference(&surf->cb_buffer_cmask, NULL);
	pipe_resource_reference(&surface->texture, NULL);
	FREE(surface);
}

static void r600_clear_texture(struct pipe_context *pipe,
			       struct pipe_resource *tex,
			       unsigned level,
			       const struct pipe_box *box,
			       const void *data)
{
	struct pipe_screen *screen = pipe->screen;
	struct r600_texture *rtex = (struct r600_texture*)tex;
	struct pipe_surface tmpl = {{0}};
	struct pipe_surface *sf;
	const struct util_format_description *desc =
		util_format_description(tex->format);

	tmpl.format = tex->format;
	tmpl.u.tex.first_layer = box->z;
	tmpl.u.tex.last_layer = box->z + box->depth - 1;
	tmpl.u.tex.level = level;
	sf = pipe->create_surface(pipe, tex, &tmpl);
	if (!sf)
		return;

	if (rtex->is_depth) {
		unsigned clear;
		float depth;
		uint8_t stencil = 0;

		/* Depth is always present. */
		clear = PIPE_CLEAR_DEPTH;
		desc->unpack_z_float(&depth, 0, data, 0, 1, 1);

		if (rtex->surface.flags & RADEON_SURF_SBUFFER) {
			clear |= PIPE_CLEAR_STENCIL;
			desc->unpack_s_8uint(&stencil, 0, data, 0, 1, 1);
		}

		pipe->clear_depth_stencil(pipe, sf, clear, depth, stencil,
					  box->x, box->y,
					  box->width, box->height, false);
	} else {
		union pipe_color_union color;

		/* pipe_color_union requires the full vec4 representation. */
		if (util_format_is_pure_uint(tex->format))
			desc->unpack_rgba_uint(color.ui, 0, data, 0, 1, 1);
		else if (util_format_is_pure_sint(tex->format))
			desc->unpack_rgba_sint(color.i, 0, data, 0, 1, 1);
		else
			desc->unpack_rgba_float(color.f, 0, data, 0, 1, 1);

		if (screen->is_format_supported(screen, tex->format,
						tex->target, 0,
						PIPE_BIND_RENDER_TARGET)) {
			pipe->clear_render_target(pipe, sf, &color,
						  box->x, box->y,
						  box->width, box->height, false);
		} else {
			/* Software fallback - just for R9G9B9E5_FLOAT */
			util_clear_render_target(pipe, sf, &color,
						 box->x, box->y,
						 box->width, box->height);
		}
	}
	pipe_surface_reference(&sf, NULL);
}

unsigned r600_translate_colorswap(enum pipe_format format, bool do_endian_swap)
{
	const struct util_format_description *desc = util_format_description(format);

#define HAS_SWIZZLE(chan,swz) (desc->swizzle[chan] == PIPE_SWIZZLE_##swz)

	if (format == PIPE_FORMAT_R11G11B10_FLOAT) /* isn't plain */
		return V_0280A0_SWAP_STD;

	if (desc->layout != UTIL_FORMAT_LAYOUT_PLAIN)
		return ~0U;

	switch (desc->nr_channels) {
	case 1:
		if (HAS_SWIZZLE(0,X))
			return V_0280A0_SWAP_STD; /* X___ */
		else if (HAS_SWIZZLE(3,X))
			return V_0280A0_SWAP_ALT_REV; /* ___X */
		break;
	case 2:
		if ((HAS_SWIZZLE(0,X) && HAS_SWIZZLE(1,Y)) ||
		    (HAS_SWIZZLE(0,X) && HAS_SWIZZLE(1,NONE)) ||
		    (HAS_SWIZZLE(0,NONE) && HAS_SWIZZLE(1,Y)))
			return V_0280A0_SWAP_STD; /* XY__ */
		else if ((HAS_SWIZZLE(0,Y) && HAS_SWIZZLE(1,X)) ||
			 (HAS_SWIZZLE(0,Y) && HAS_SWIZZLE(1,NONE)) ||
		         (HAS_SWIZZLE(0,NONE) && HAS_SWIZZLE(1,X)))
			/* YX__ */
			return (do_endian_swap ? V_0280A0_SWAP_STD : V_0280A0_SWAP_STD_REV);
		else if (HAS_SWIZZLE(0,X) && HAS_SWIZZLE(3,Y))
			return V_0280A0_SWAP_ALT; /* X__Y */
		else if (HAS_SWIZZLE(0,Y) && HAS_SWIZZLE(3,X))
			return V_0280A0_SWAP_ALT_REV; /* Y__X */
		break;
	case 3:
		if (HAS_SWIZZLE(0,X))
			return (do_endian_swap ? V_0280A0_SWAP_STD_REV : V_0280A0_SWAP_STD);
		else if (HAS_SWIZZLE(0,Z))
			return V_0280A0_SWAP_STD_REV; /* ZYX */
		break;
	case 4:
		/* check the middle channels, the 1st and 4th channel can be NONE */
		if (HAS_SWIZZLE(1,Y) && HAS_SWIZZLE(2,Z)) {
			return V_0280A0_SWAP_STD; /* XYZW */
		} else if (HAS_SWIZZLE(1,Z) && HAS_SWIZZLE(2,Y)) {
			return V_0280A0_SWAP_STD_REV; /* WZYX */
		} else if (HAS_SWIZZLE(1,Y) && HAS_SWIZZLE(2,X)) {
			return V_0280A0_SWAP_ALT; /* ZYXW */
		} else if (HAS_SWIZZLE(1,Z) && HAS_SWIZZLE(2,W)) {
			/* YZWX */
			if (desc->is_array)
				return V_0280A0_SWAP_ALT_REV;
			else
				return (do_endian_swap ? V_0280A0_SWAP_ALT : V_0280A0_SWAP_ALT_REV);
		}
		break;
	}
	return ~0U;
}

/* PIPELINE_STAT-BASED DCC ENABLEMENT FOR DISPLAYABLE SURFACES */

static void vi_dcc_clean_up_context_slot(struct r600_common_context *rctx,
					 int slot)
{
	int i;

	if (rctx->dcc_stats[slot].query_active)
		vi_separate_dcc_stop_query(&rctx->b,
					   rctx->dcc_stats[slot].tex);

	for (i = 0; i < ARRAY_SIZE(rctx->dcc_stats[slot].ps_stats); i++)
		if (rctx->dcc_stats[slot].ps_stats[i]) {
			rctx->b.destroy_query(&rctx->b,
					      rctx->dcc_stats[slot].ps_stats[i]);
			rctx->dcc_stats[slot].ps_stats[i] = NULL;
		}

	r600_texture_reference(&rctx->dcc_stats[slot].tex, NULL);
}

/**
 * Return the per-context slot where DCC statistics queries for the texture live.
 */
static unsigned vi_get_context_dcc_stats_index(struct r600_common_context *rctx,
					       struct r600_texture *tex)
{
	int i, empty_slot = -1;

	/* Remove zombie textures (textures kept alive by this array only). */
	for (i = 0; i < ARRAY_SIZE(rctx->dcc_stats); i++)
		if (rctx->dcc_stats[i].tex &&
		    rctx->dcc_stats[i].tex->resource.b.b.reference.count == 1)
			vi_dcc_clean_up_context_slot(rctx, i);

	/* Find the texture. */
	for (i = 0; i < ARRAY_SIZE(rctx->dcc_stats); i++) {
		/* Return if found. */
		if (rctx->dcc_stats[i].tex == tex) {
			rctx->dcc_stats[i].last_use_timestamp = os_time_get();
			return i;
		}

		/* Record the first seen empty slot. */
		if (empty_slot == -1 && !rctx->dcc_stats[i].tex)
			empty_slot = i;
	}

	/* Not found. Remove the oldest member to make space in the array. */
	if (empty_slot == -1) {
		int oldest_slot = 0;

		/* Find the oldest slot. */
		for (i = 1; i < ARRAY_SIZE(rctx->dcc_stats); i++)
			if (rctx->dcc_stats[oldest_slot].last_use_timestamp >
			    rctx->dcc_stats[i].last_use_timestamp)
				oldest_slot = i;

		/* Clean up the oldest slot. */
		vi_dcc_clean_up_context_slot(rctx, oldest_slot);
		empty_slot = oldest_slot;
	}

	/* Add the texture to the new slot. */
	r600_texture_reference(&rctx->dcc_stats[empty_slot].tex, tex);
	rctx->dcc_stats[empty_slot].last_use_timestamp = os_time_get();
	return empty_slot;
}

static struct pipe_query *
vi_create_resuming_pipestats_query(struct pipe_context *ctx)
{
	struct r600_query_hw *query = (struct r600_query_hw*)
		ctx->create_query(ctx, PIPE_QUERY_PIPELINE_STATISTICS, 0);

	query->flags |= R600_QUERY_HW_FLAG_BEGIN_RESUMES;
	return (struct pipe_query*)query;
}

/**
 * Called when binding a color buffer.
 */
void vi_separate_dcc_start_query(struct pipe_context *ctx,
				 struct r600_texture *tex)
{
	struct r600_common_context *rctx = (struct r600_common_context*)ctx;
	unsigned i = vi_get_context_dcc_stats_index(rctx, tex);

	assert(!rctx->dcc_stats[i].query_active);

	if (!rctx->dcc_stats[i].ps_stats[0])
		rctx->dcc_stats[i].ps_stats[0] = vi_create_resuming_pipestats_query(ctx);

	/* begin or resume the query */
	ctx->begin_query(ctx, rctx->dcc_stats[i].ps_stats[0]);
	rctx->dcc_stats[i].query_active = true;
}

/**
 * Called when unbinding a color buffer.
 */
void vi_separate_dcc_stop_query(struct pipe_context *ctx,
				struct r600_texture *tex)
{
	struct r600_common_context *rctx = (struct r600_common_context*)ctx;
	unsigned i = vi_get_context_dcc_stats_index(rctx, tex);

	assert(rctx->dcc_stats[i].query_active);
	assert(rctx->dcc_stats[i].ps_stats[0]);

	/* pause or end the query */
	ctx->end_query(ctx, rctx->dcc_stats[i].ps_stats[0]);
	rctx->dcc_stats[i].query_active = false;
}

static bool vi_should_enable_separate_dcc(struct r600_texture *tex)
{
	/* The minimum number of fullscreen draws per frame that is required
	 * to enable DCC. */
	return tex->ps_draw_ratio + tex->num_slow_clears >= 5;
}

/* Called by fast clear. */
static void vi_separate_dcc_try_enable(struct r600_common_context *rctx,
				       struct r600_texture *tex)
{
	/* The intent is to use this with shared displayable back buffers,
	 * but it's not strictly limited only to them.
	 */
	if (!tex->resource.is_shared ||
	    !(tex->resource.external_usage & PIPE_HANDLE_USAGE_EXPLICIT_FLUSH) ||
	    tex->resource.b.b.target != PIPE_TEXTURE_2D ||
	    tex->surface.last_level > 0 ||
	    !tex->surface.dcc_size)
		return;

	if (tex->dcc_offset)
		return; /* already enabled */

	/* Enable the DCC stat gathering. */
	if (!tex->dcc_gather_statistics) {
		tex->dcc_gather_statistics = true;
		vi_separate_dcc_start_query(&rctx->b, tex);
	}

	if (!vi_should_enable_separate_dcc(tex))
		return; /* stats show that DCC decompression is too expensive */

	assert(tex->surface.level[0].dcc_enabled);
	assert(!tex->dcc_separate_buffer);

	r600_texture_discard_cmask(rctx->screen, tex);

	/* Get a DCC buffer. */
	if (tex->last_dcc_separate_buffer) {
		assert(tex->dcc_gather_statistics);
		assert(!tex->dcc_separate_buffer);
		tex->dcc_separate_buffer = tex->last_dcc_separate_buffer;
		tex->last_dcc_separate_buffer = NULL;
	} else {
		tex->dcc_separate_buffer = (struct r600_resource*)
			r600_aligned_buffer_create(rctx->b.screen, 0,
						   PIPE_USAGE_DEFAULT,
						   tex->surface.dcc_size,
						   tex->surface.dcc_alignment);
		if (!tex->dcc_separate_buffer)
			return;
	}

	/* dcc_offset is the absolute GPUVM address. */
	tex->dcc_offset = tex->dcc_separate_buffer->gpu_address;

	/* no need to flag anything since this is called by fast clear that
	 * flags framebuffer state
	 */
}

/**
 * Called by pipe_context::flush_resource, the place where DCC decompression
 * takes place.
 */
void vi_separate_dcc_process_and_reset_stats(struct pipe_context *ctx,
					     struct r600_texture *tex)
{
	struct r600_common_context *rctx = (struct r600_common_context*)ctx;
	struct pipe_query *tmp;
	unsigned i = vi_get_context_dcc_stats_index(rctx, tex);
	bool query_active = rctx->dcc_stats[i].query_active;
	bool disable = false;

	if (rctx->dcc_stats[i].ps_stats[2]) {
		union pipe_query_result result;

		/* Read the results. */
		ctx->get_query_result(ctx, rctx->dcc_stats[i].ps_stats[2],
				      true, &result);
		r600_query_hw_reset_buffers(rctx,
					    (struct r600_query_hw*)
					    rctx->dcc_stats[i].ps_stats[2]);

		/* Compute the approximate number of fullscreen draws. */
		tex->ps_draw_ratio =
			result.pipeline_statistics.ps_invocations /
			(tex->resource.b.b.width0 * tex->resource.b.b.height0);
		rctx->last_tex_ps_draw_ratio = tex->ps_draw_ratio;

		disable = tex->dcc_separate_buffer &&
			  !vi_should_enable_separate_dcc(tex);
	}

	tex->num_slow_clears = 0;

	/* stop the statistics query for ps_stats[0] */
	if (query_active)
		vi_separate_dcc_stop_query(ctx, tex);

	/* Move the queries in the queue by one. */
	tmp = rctx->dcc_stats[i].ps_stats[2];
	rctx->dcc_stats[i].ps_stats[2] = rctx->dcc_stats[i].ps_stats[1];
	rctx->dcc_stats[i].ps_stats[1] = rctx->dcc_stats[i].ps_stats[0];
	rctx->dcc_stats[i].ps_stats[0] = tmp;

	/* create and start a new query as ps_stats[0] */
	if (query_active)
		vi_separate_dcc_start_query(ctx, tex);

	if (disable) {
		assert(!tex->last_dcc_separate_buffer);
		tex->last_dcc_separate_buffer = tex->dcc_separate_buffer;
		tex->dcc_separate_buffer = NULL;
		tex->dcc_offset = 0;
		/* no need to flag anything since this is called after
		 * decompression that re-sets framebuffer state
		 */
	}
}

/* FAST COLOR CLEAR */

static void evergreen_set_clear_color(struct r600_texture *rtex,
				      enum pipe_format surface_format,
				      const union pipe_color_union *color)
{
	union util_color uc;

	memset(&uc, 0, sizeof(uc));

	if (util_format_is_pure_uint(surface_format)) {
		util_format_write_4ui(surface_format, color->ui, 0, &uc, 0, 0, 0, 1, 1);
	} else if (util_format_is_pure_sint(surface_format)) {
		util_format_write_4i(surface_format, color->i, 0, &uc, 0, 0, 0, 1, 1);
	} else {
		util_pack_color(color->f, surface_format, &uc);
	}

	memcpy(rtex->color_clear_value, &uc, 2 * sizeof(uint32_t));
}

static void vi_get_fast_clear_parameters(enum pipe_format surface_format,
					 const union pipe_color_union *color,
					 uint32_t* reset_value,
					 bool* clear_words_needed)
{
	bool values[4] = {};
	int i;
	bool main_value = false;
	bool extra_value = false;
	int extra_channel;
	const struct util_format_description *desc = util_format_description(surface_format);

	*clear_words_needed = true;
	*reset_value = 0x20202020U;

	/* If we want to clear without needing a fast clear eliminate step, we
	 * can set each channel to 0 or 1 (or 0/max for integer formats). We
	 * have two sets of flags, one for the last or first channel(extra) and
	 * one for the other channels(main).
	 */

	if (surface_format == PIPE_FORMAT_R11G11B10_FLOAT ||
	    surface_format == PIPE_FORMAT_B5G6R5_UNORM ||
	    surface_format == PIPE_FORMAT_B5G6R5_SRGB) {
		extra_channel = -1;
	} else if (desc->layout == UTIL_FORMAT_LAYOUT_PLAIN) {
		if(r600_translate_colorswap(surface_format, false) <= 1)
			extra_channel = desc->nr_channels - 1;
		else
			extra_channel = 0;
	} else
		return;

	for (i = 0; i < 4; ++i) {
		int index = desc->swizzle[i] - PIPE_SWIZZLE_X;

		if (desc->swizzle[i] < PIPE_SWIZZLE_X ||
		    desc->swizzle[i] > PIPE_SWIZZLE_W)
			continue;

		if (util_format_is_pure_sint(surface_format)) {
			values[i] = color->i[i] != 0;
			if (color->i[i] != 0 && color->i[i] != INT32_MAX)
				return;
		} else if (util_format_is_pure_uint(surface_format)) {
			values[i] = color->ui[i] != 0U;
			if (color->ui[i] != 0U && color->ui[i] != UINT32_MAX)
				return;
		} else {
			values[i] = color->f[i] != 0.0F;
			if (color->f[i] != 0.0F && color->f[i] != 1.0F)
				return;
		}

		if (index == extra_channel)
			extra_value = values[i];
		else
			main_value = values[i];
	}

	for (int i = 0; i < 4; ++i)
		if (values[i] != main_value &&
		    desc->swizzle[i] - PIPE_SWIZZLE_X != extra_channel &&
		    desc->swizzle[i] >= PIPE_SWIZZLE_X &&
		    desc->swizzle[i] <= PIPE_SWIZZLE_W)
			return;

	*clear_words_needed = false;
	if (main_value)
		*reset_value |= 0x80808080U;

	if (extra_value)
		*reset_value |= 0x40404040U;
}

void vi_dcc_clear_level(struct r600_common_context *rctx,
			struct r600_texture *rtex,
			unsigned level, unsigned clear_value)
{
	struct pipe_resource *dcc_buffer;
	uint64_t dcc_offset;

	assert(rtex->dcc_offset && rtex->surface.level[level].dcc_enabled);

	if (rtex->dcc_separate_buffer) {
		dcc_buffer = &rtex->dcc_separate_buffer->b.b;
		dcc_offset = 0;
	} else {
		dcc_buffer = &rtex->resource.b.b;
		dcc_offset = rtex->dcc_offset;
	}

	dcc_offset += rtex->surface.level[level].dcc_offset;

	rctx->clear_buffer(&rctx->b, dcc_buffer, dcc_offset,
			   rtex->surface.level[level].dcc_fast_clear_size,
			   clear_value, R600_COHERENCY_CB_META);
}

/* Set the same micro tile mode as the destination of the last MSAA resolve.
 * This allows hitting the MSAA resolve fast path, which requires that both
 * src and dst micro tile modes match.
 */
static void si_set_optimal_micro_tile_mode(struct r600_common_screen *rscreen,
					   struct r600_texture *rtex)
{
	if (rtex->resource.is_shared ||
	    rtex->surface.nsamples <= 1 ||
	    rtex->surface.micro_tile_mode == rtex->last_msaa_resolve_target_micro_mode)
		return;

	assert(rtex->surface.level[0].mode == RADEON_SURF_MODE_2D);
	assert(rtex->surface.last_level == 0);

	/* These magic numbers were copied from addrlib. It doesn't use any
	 * definitions for them either. They are all 2D_TILED_THIN1 modes with
	 * different bpp and micro tile mode.
	 */
	if (rscreen->chip_class >= CIK) {
		switch (rtex->last_msaa_resolve_target_micro_mode) {
		case 0: /* displayable */
			rtex->surface.tiling_index[0] = 10;
			break;
		case 1: /* thin */
			rtex->surface.tiling_index[0] = 14;
			break;
		case 3: /* rotated */
			rtex->surface.tiling_index[0] = 28;
			break;
		default: /* depth, thick */
			assert(!"unexpected micro mode");
			return;
		}
	} else { /* SI */
		switch (rtex->last_msaa_resolve_target_micro_mode) {
		case 0: /* displayable */
			switch (rtex->surface.bpe) {
			case 8:
                            rtex->surface.tiling_index[0] = 10;
                            break;
			case 16:
                            rtex->surface.tiling_index[0] = 11;
                            break;
			default: /* 32, 64 */
                            rtex->surface.tiling_index[0] = 12;
                            break;
			}
			break;
		case 1: /* thin */
			switch (rtex->surface.bpe) {
			case 8:
                                rtex->surface.tiling_index[0] = 14;
                                break;
			case 16:
                                rtex->surface.tiling_index[0] = 15;
                                break;
			case 32:
                                rtex->surface.tiling_index[0] = 16;
                                break;
			default: /* 64, 128 */
                                rtex->surface.tiling_index[0] = 17;
                                break;
			}
			break;
		default: /* depth, thick */
			assert(!"unexpected micro mode");
			return;
		}
	}

	rtex->surface.micro_tile_mode = rtex->last_msaa_resolve_target_micro_mode;

	p_atomic_inc(&rscreen->dirty_fb_counter);
	p_atomic_inc(&rscreen->dirty_tex_descriptor_counter);
}

void evergreen_do_fast_color_clear(struct r600_common_context *rctx,
				   struct pipe_framebuffer_state *fb,
				   struct r600_atom *fb_state,
				   unsigned *buffers, unsigned *dirty_cbufs,
				   const union pipe_color_union *color)
{
	int i;

	/* This function is broken in BE, so just disable this path for now */
#ifdef PIPE_ARCH_BIG_ENDIAN
	return;
#endif

	if (rctx->render_cond)
		return;

	for (i = 0; i < fb->nr_cbufs; i++) {
		struct r600_texture *tex;
		unsigned clear_bit = PIPE_CLEAR_COLOR0 << i;

		if (!fb->cbufs[i])
			continue;

		/* if this colorbuffer is not being cleared */
		if (!(*buffers & clear_bit))
			continue;

		tex = (struct r600_texture *)fb->cbufs[i]->texture;

		/* 128-bit formats are unusupported */
		if (util_format_get_blocksizebits(fb->cbufs[i]->format) > 64) {
			continue;
		}

		/* the clear is allowed if all layers are bound */
		if (fb->cbufs[i]->u.tex.first_layer != 0 ||
		    fb->cbufs[i]->u.tex.last_layer != util_max_layer(&tex->resource.b.b, 0)) {
			continue;
		}

		/* cannot clear mipmapped textures */
		if (fb->cbufs[i]->texture->last_level != 0) {
			continue;
		}

		/* only supported on tiled surfaces */
		if (tex->surface.level[0].mode < RADEON_SURF_MODE_1D) {
			continue;
		}

		/* shared textures can't use fast clear without an explicit flush,
		 * because there is no way to communicate the clear color among
		 * all clients
		 */
		if (tex->resource.is_shared &&
		    !(tex->resource.external_usage & PIPE_HANDLE_USAGE_EXPLICIT_FLUSH))
			continue;

		/* fast color clear with 1D tiling doesn't work on old kernels and CIK */
		if (tex->surface.level[0].mode == RADEON_SURF_MODE_1D &&
		    rctx->chip_class >= CIK &&
		    rctx->screen->info.drm_major == 2 &&
		    rctx->screen->info.drm_minor < 38) {
			continue;
		}

		/* Fast clear is the most appropriate place to enable DCC for
		 * displayable surfaces.
		 */
		if (rctx->chip_class >= VI &&
		    !(rctx->screen->debug_flags & DBG_NO_DCC_FB)) {
			vi_separate_dcc_try_enable(rctx, tex);

			/* Stoney can't do a CMASK-based clear, so all clears are
			 * considered to be hypothetically slow clears, which
			 * is weighed when determining to enable separate DCC.
			 */
			if (tex->dcc_gather_statistics &&
			    rctx->family == CHIP_STONEY)
				tex->num_slow_clears++;
		}

		/* Try to clear DCC first, otherwise try CMASK. */
		if (tex->dcc_offset && tex->surface.level[0].dcc_enabled) {
			uint32_t reset_value;
			bool clear_words_needed;

			if (rctx->screen->debug_flags & DBG_NO_DCC_CLEAR)
				continue;

			/* We can change the micro tile mode before a full clear. */
			if (rctx->screen->chip_class >= SI)
				si_set_optimal_micro_tile_mode(rctx->screen, tex);

			vi_get_fast_clear_parameters(fb->cbufs[i]->format, color, &reset_value, &clear_words_needed);
			vi_dcc_clear_level(rctx, tex, 0, reset_value);

			if (clear_words_needed)
				tex->dirty_level_mask |= 1 << fb->cbufs[i]->u.tex.level;
			tex->separate_dcc_dirty = true;
		} else {
			/* Stoney/RB+ doesn't work with CMASK fast clear. */
			if (rctx->family == CHIP_STONEY)
				continue;

			/* ensure CMASK is enabled */
			r600_texture_alloc_cmask_separate(rctx->screen, tex);
			if (tex->cmask.size == 0) {
				continue;
			}

			/* We can change the micro tile mode before a full clear. */
			if (rctx->screen->chip_class >= SI)
				si_set_optimal_micro_tile_mode(rctx->screen, tex);

			/* Do the fast clear. */
			rctx->clear_buffer(&rctx->b, &tex->cmask_buffer->b.b,
					   tex->cmask.offset, tex->cmask.size, 0,
					   R600_COHERENCY_CB_META);

			tex->dirty_level_mask |= 1 << fb->cbufs[i]->u.tex.level;
		}

		evergreen_set_clear_color(tex, fb->cbufs[i]->format, color);

		if (dirty_cbufs)
			*dirty_cbufs |= 1 << i;
		rctx->set_atom_dirty(rctx, fb_state, true);
		*buffers &= ~clear_bit;
	}
}

void r600_init_screen_texture_functions(struct r600_common_screen *rscreen)
{
	rscreen->b.resource_from_handle = r600_texture_from_handle;
	rscreen->b.resource_get_handle = r600_texture_get_handle;
}

void r600_init_context_texture_functions(struct r600_common_context *rctx)
{
	rctx->b.create_surface = r600_create_surface;
	rctx->b.surface_destroy = r600_surface_destroy;
	rctx->b.clear_texture = r600_clear_texture;
}
