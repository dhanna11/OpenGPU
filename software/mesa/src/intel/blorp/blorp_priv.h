/*
 * Copyright © 2012 Intel Corporation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice (including the next
 * paragraph) shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#pragma once

#include <stdint.h>

#include "compiler/nir/nir.h"
#include "brw_compiler.h"

#include "blorp.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Binding table indices used by BLORP.
 */
enum {
   BLORP_RENDERBUFFER_BT_INDEX,
   BLORP_TEXTURE_BT_INDEX,
   BLORP_NUM_BT_ENTRIES
};

enum blorp_fast_clear_op {
   BLORP_FAST_CLEAR_OP_NONE = 0,
   BLORP_FAST_CLEAR_OP_CLEAR,
   BLORP_FAST_CLEAR_OP_RESOLVE_PARTIAL,
   BLORP_FAST_CLEAR_OP_RESOLVE_FULL,
};

struct brw_blorp_surface_info
{
   struct isl_surf surf;
   struct blorp_address addr;

   struct isl_surf aux_surf;
   struct blorp_address aux_addr;
   enum isl_aux_usage aux_usage;

   union isl_color_value clear_color;

   struct isl_view view;

   /* Z offset into a 3-D texture or slice of a 2-D array texture. */
   uint32_t z_offset;

   uint32_t tile_x_sa, tile_y_sa;
};

void
brw_blorp_surface_info_init(struct blorp_context *blorp,
                            struct brw_blorp_surface_info *info,
                            const struct blorp_surf *surf,
                            unsigned int level, unsigned int layer,
                            enum isl_format format, bool is_render_target);


struct brw_blorp_coord_transform
{
   float multiplier;
   float offset;
};

/**
 * Bounding rectangle telling pixel discard which pixels are not to be
 * touched. This is needed in when surfaces are configured as something else
 * what they really are:
 *
 *    - writing W-tiled stencil as Y-tiled
 *    - writing interleaved multisampled as single sampled.
 *
 * See blorp_nir_discard_if_outside_rect().
 */
struct brw_blorp_discard_rect
{
   uint32_t x0;
   uint32_t x1;
   uint32_t y0;
   uint32_t y1;
};

/**
 * Grid needed for blended and scaled blits of integer formats, see
 * blorp_nir_manual_blend_bilinear().
 */
struct brw_blorp_rect_grid
{
   float x1;
   float y1;
   float pad[2];
};

struct brw_blorp_wm_inputs
{
   struct brw_blorp_discard_rect discard_rect;
   struct brw_blorp_rect_grid rect_grid;
   struct brw_blorp_coord_transform coord_transform[2];

   /* Minimum layer setting works for all the textures types but texture_3d
    * for which the setting has no effect. Use the z-coordinate instead.
    */
   uint32_t src_z;

   /* Pad out to an integral number of registers */
   uint32_t pad[3];
};

struct brw_blorp_prog_data
{
   bool dispatch_8;
   bool dispatch_16;

   uint8_t first_curbe_grf_0;
   uint8_t first_curbe_grf_2;

   uint32_t ksp_offset_2;

   /**
    * True if the WM program should be run in MSDISPMODE_PERSAMPLE with more
    * than one sample per pixel.
    */
   bool persample_msaa_dispatch;

   /**
    * Mask of which FS inputs are marked flat by the shader source.  This is
    * needed for setting up 3DSTATE_SF/SBE.
    */
   uint32_t flat_inputs;
   unsigned num_varying_inputs;
   uint64_t inputs_read;
};

static inline unsigned
brw_blorp_get_urb_length(const struct brw_blorp_prog_data *prog_data)
{
   if (prog_data == NULL)
      return 1;

   /* From the BSpec: 3D Pipeline - Strips and Fans - 3DSTATE_SBE
    *
    * read_length = ceiling((max_source_attr+1)/2)
    */
   return MAX2((prog_data->num_varying_inputs + 1) / 2, 1);
}

struct blorp_params
{
   uint32_t x0;
   uint32_t y0;
   uint32_t x1;
   uint32_t y1;
   struct brw_blorp_surface_info depth;
   uint32_t depth_format;
   struct brw_blorp_surface_info src;
   struct brw_blorp_surface_info dst;
   enum blorp_hiz_op hiz_op;
   enum blorp_fast_clear_op fast_clear_op;
   bool color_write_disable[4];
   struct brw_blorp_wm_inputs wm_inputs;
   unsigned num_draw_buffers;
   unsigned num_layers;
   uint32_t wm_prog_kernel;
   struct brw_blorp_prog_data *wm_prog_data;
};

void blorp_params_init(struct blorp_params *params);

struct brw_blorp_blit_prog_key
{
   /* Number of samples per pixel that have been configured in the surface
    * state for texturing from.
    */
   unsigned tex_samples;

   /* MSAA layout that has been configured in the surface state for texturing
    * from.
    */
   enum isl_msaa_layout tex_layout;

   enum isl_aux_usage tex_aux_usage;

   /* Actual number of samples per pixel in the source image. */
   unsigned src_samples;

   /* Actual MSAA layout used by the source image. */
   enum isl_msaa_layout src_layout;

   /* Number of samples per pixel that have been configured in the render
    * target.
    */
   unsigned rt_samples;

   /* MSAA layout that has been configured in the render target. */
   enum isl_msaa_layout rt_layout;

   /* Actual number of samples per pixel in the destination image. */
   unsigned dst_samples;

   /* Actual MSAA layout used by the destination image. */
   enum isl_msaa_layout dst_layout;

   /* Type of the data to be read from the texture (one of
    * nir_type_(int|uint|float)).
    */
   nir_alu_type texture_data_type;

   /* True if the source image is W tiled.  If true, the surface state for the
    * source image must be configured as Y tiled, and tex_samples must be 0.
    */
   bool src_tiled_w;

   /* True if the destination image is W tiled.  If true, the surface state
    * for the render target must be configured as Y tiled, and rt_samples must
    * be 0.
    */
   bool dst_tiled_w;

   /* True if all source samples should be blended together to produce each
    * destination pixel.  If true, src_tiled_w must be false, tex_samples must
    * equal src_samples, and tex_samples must be nonzero.
    */
   bool blend;

   /* True if the rectangle being sent through the rendering pipeline might be
    * larger than the destination rectangle, so the WM program should kill any
    * pixels that are outside the destination rectangle.
    */
   bool use_kill;

   /**
    * True if the WM program should be run in MSDISPMODE_PERSAMPLE with more
    * than one sample per pixel.
    */
   bool persample_msaa_dispatch;

   /* True for scaled blitting. */
   bool blit_scaled;

   /* Scale factors between the pixel grid and the grid of samples. We're
    * using grid of samples for bilinear filetring in multisample scaled blits.
    */
   float x_scale;
   float y_scale;

   /* True for blits with filter = GL_LINEAR. */
   bool bilinear_filter;
};

/**
 * \name BLORP internals
 * \{
 *
 * Used internally by gen6_blorp_exec() and gen7_blorp_exec().
 */

void brw_blorp_init_wm_prog_key(struct brw_wm_prog_key *wm_key);

const unsigned *
brw_blorp_compile_nir_shader(struct blorp_context *blorp, struct nir_shader *nir,
                             const struct brw_wm_prog_key *wm_key,
                             bool use_repclear,
                             struct brw_blorp_prog_data *prog_data,
                             unsigned *program_size);

/** \} */

#ifdef __cplusplus
} /* end extern "C" */
#endif /* __cplusplus */
