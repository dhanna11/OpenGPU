/*
 * Copyright © 2013 Intel Corporation
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

#include "util/ralloc.h"

#include "blorp_priv.h"
#include "brw_defines.h"

#include "compiler/nir/nir_builder.h"

#define FILE_DEBUG_FLAG DEBUG_BLORP

struct brw_blorp_const_color_prog_key
{
   bool use_simd16_replicated_data;
   bool pad[3];
};

static void
blorp_params_get_clear_kernel(struct blorp_context *blorp,
                              struct blorp_params *params,
                              bool use_replicated_data)
{
   struct brw_blorp_const_color_prog_key blorp_key;
   memset(&blorp_key, 0, sizeof(blorp_key));
   blorp_key.use_simd16_replicated_data = use_replicated_data;

   if (blorp->lookup_shader(blorp, &blorp_key, sizeof(blorp_key),
                            &params->wm_prog_kernel, &params->wm_prog_data))
      return;

   void *mem_ctx = ralloc_context(NULL);

   nir_builder b;
   nir_builder_init_simple_shader(&b, NULL, MESA_SHADER_FRAGMENT, NULL);
   b.shader->info.name = ralloc_strdup(b.shader, "BLORP-clear");

   nir_variable *v_color = nir_variable_create(b.shader, nir_var_shader_in,
                                               glsl_vec4_type(), "v_color");
   v_color->data.location = VARYING_SLOT_VAR0;
   v_color->data.interpolation = INTERP_MODE_FLAT;

   nir_variable *frag_color = nir_variable_create(b.shader, nir_var_shader_out,
                                                  glsl_vec4_type(),
                                                  "gl_FragColor");
   frag_color->data.location = FRAG_RESULT_COLOR;

   nir_copy_var(&b, frag_color, v_color);

   struct brw_wm_prog_key wm_key;
   brw_blorp_init_wm_prog_key(&wm_key);

   struct brw_blorp_prog_data prog_data;
   unsigned program_size;
   const unsigned *program =
      brw_blorp_compile_nir_shader(blorp, b.shader, &wm_key, use_replicated_data,
                                   &prog_data, &program_size);

   blorp->upload_shader(blorp, &blorp_key, sizeof(blorp_key),
                        program, program_size,
                        &prog_data, sizeof(prog_data),
                        &params->wm_prog_kernel, &params->wm_prog_data);

   ralloc_free(mem_ctx);
}

/* The x0, y0, x1, and y1 parameters must already be populated with the render
 * area of the framebuffer to be cleared.
 */
static void
get_fast_clear_rect(const struct isl_device *dev,
                    const struct isl_surf *aux_surf,
                    unsigned *x0, unsigned *y0,
                    unsigned *x1, unsigned *y1)
{
   unsigned int x_align, y_align;
   unsigned int x_scaledown, y_scaledown;

   /* Only single sampled surfaces need to (and actually can) be resolved. */
   if (aux_surf->usage == ISL_SURF_USAGE_CCS_BIT) {
      /* From the Ivy Bridge PRM, Vol2 Part1 11.7 "MCS Buffer for Render
       * Target(s)", beneath the "Fast Color Clear" bullet (p327):
       *
       *     Clear pass must have a clear rectangle that must follow
       *     alignment rules in terms of pixels and lines as shown in the
       *     table below. Further, the clear-rectangle height and width
       *     must be multiple of the following dimensions. If the height
       *     and width of the render target being cleared do not meet these
       *     requirements, an MCS buffer can be created such that it
       *     follows the requirement and covers the RT.
       *
       * The alignment size in the table that follows is related to the
       * alignment size that is baked into the CCS surface format but with X
       * alignment multiplied by 16 and Y alignment multiplied by 32.
       */
      x_align = isl_format_get_layout(aux_surf->format)->bw;
      y_align = isl_format_get_layout(aux_surf->format)->bh;

      x_align *= 16;

      /* SKL+ line alignment requirement for Y-tiled are half those of the prior
       * generations.
       */
      if (dev->info->gen >= 9)
         y_align *= 16;
      else
         y_align *= 32;

      /* From the Ivy Bridge PRM, Vol2 Part1 11.7 "MCS Buffer for Render
       * Target(s)", beneath the "Fast Color Clear" bullet (p327):
       *
       *     In order to optimize the performance MCS buffer (when bound to
       *     1X RT) clear similarly to MCS buffer clear for MSRT case,
       *     clear rect is required to be scaled by the following factors
       *     in the horizontal and vertical directions:
       *
       * The X and Y scale down factors in the table that follows are each
       * equal to half the alignment value computed above.
       */
      x_scaledown = x_align / 2;
      y_scaledown = y_align / 2;

      /* From BSpec: 3D-Media-GPGPU Engine > 3D Pipeline > Pixel > Pixel
       * Backend > MCS Buffer for Render Target(s) [DevIVB+] > Table "Color
       * Clear of Non-MultiSampled Render Target Restrictions":
       *
       *   Clear rectangle must be aligned to two times the number of
       *   pixels in the table shown below due to 16x16 hashing across the
       *   slice.
       */
      x_align *= 2;
      y_align *= 2;
   } else {
      assert(aux_surf->usage == ISL_SURF_USAGE_MCS_BIT);

      /* From the Ivy Bridge PRM, Vol2 Part1 11.7 "MCS Buffer for Render
       * Target(s)", beneath the "MSAA Compression" bullet (p326):
       *
       *     Clear pass for this case requires that scaled down primitive
       *     is sent down with upper left co-ordinate to coincide with
       *     actual rectangle being cleared. For MSAA, clear rectangle’s
       *     height and width need to as show in the following table in
       *     terms of (width,height) of the RT.
       *
       *     MSAA  Width of Clear Rect  Height of Clear Rect
       *      2X     Ceil(1/8*width)      Ceil(1/2*height)
       *      4X     Ceil(1/8*width)      Ceil(1/2*height)
       *      8X     Ceil(1/2*width)      Ceil(1/2*height)
       *     16X         width            Ceil(1/2*height)
       *
       * The text "with upper left co-ordinate to coincide with actual
       * rectangle being cleared" is a little confusing--it seems to imply
       * that to clear a rectangle from (x,y) to (x+w,y+h), one needs to
       * feed the pipeline using the rectangle (x,y) to
       * (x+Ceil(w/N),y+Ceil(h/2)), where N is either 2 or 8 depending on
       * the number of samples.  Experiments indicate that this is not
       * quite correct; actually, what the hardware appears to do is to
       * align whatever rectangle is sent down the pipeline to the nearest
       * multiple of 2x2 blocks, and then scale it up by a factor of N
       * horizontally and 2 vertically.  So the resulting alignment is 4
       * vertically and either 4 or 16 horizontally, and the scaledown
       * factor is 2 vertically and either 2 or 8 horizontally.
       */
      switch (aux_surf->format) {
      case ISL_FORMAT_MCS_2X:
      case ISL_FORMAT_MCS_4X:
         x_scaledown = 8;
         break;
      case ISL_FORMAT_MCS_8X:
         x_scaledown = 2;
         break;
      case ISL_FORMAT_MCS_16X:
         x_scaledown = 1;
         break;
      default:
         unreachable("Unexpected MCS format for fast clear");
      }
      y_scaledown = 2;
      x_align = x_scaledown * 2;
      y_align = y_scaledown * 2;
   }

   *x0 = ROUND_DOWN_TO(*x0,  x_align) / x_scaledown;
   *y0 = ROUND_DOWN_TO(*y0, y_align) / y_scaledown;
   *x1 = ALIGN(*x1, x_align) / x_scaledown;
   *y1 = ALIGN(*y1, y_align) / y_scaledown;
}

void
blorp_fast_clear(struct blorp_batch *batch,
                 const struct blorp_surf *surf,
                 uint32_t level, uint32_t layer, enum isl_format format,
                 uint32_t x0, uint32_t y0, uint32_t x1, uint32_t y1)
{
   struct blorp_params params;
   blorp_params_init(&params);

   params.x0 = x0;
   params.y0 = y0;
   params.x1 = x1;
   params.y1 = y1;

   memset(&params.wm_inputs, 0xff, 4*sizeof(float));
   params.fast_clear_op = BLORP_FAST_CLEAR_OP_CLEAR;

   get_fast_clear_rect(batch->blorp->isl_dev, surf->aux_surf,
                       &params.x0, &params.y0, &params.x1, &params.y1);

   blorp_params_get_clear_kernel(batch->blorp, &params, true);

   brw_blorp_surface_info_init(batch->blorp, &params.dst, surf, level, layer,
                               format, true);

   batch->blorp->exec(batch, &params);
}


void
blorp_clear(struct blorp_batch *batch,
            const struct blorp_surf *surf,
            uint32_t level, uint32_t layer,
            uint32_t x0, uint32_t y0, uint32_t x1, uint32_t y1,
            enum isl_format format, union isl_color_value clear_color,
            bool color_write_disable[4])
{
   struct blorp_params params;
   blorp_params_init(&params);

   params.x0 = x0;
   params.y0 = y0;
   params.x1 = x1;
   params.y1 = y1;

   memcpy(&params.wm_inputs, clear_color.f32, sizeof(float) * 4);

   bool use_simd16_replicated_data = true;

   /* From the SNB PRM (Vol4_Part1):
    *
    *     "Replicated data (Message Type = 111) is only supported when
    *      accessing tiled memory.  Using this Message Type to access linear
    *      (untiled) memory is UNDEFINED."
    */
   if (surf->surf->tiling == ISL_TILING_LINEAR)
      use_simd16_replicated_data = false;

   /* Constant color writes ignore everyting in blend and color calculator
    * state.  This is not documented.
    */
   for (unsigned i = 0; i < 4; i++) {
      params.color_write_disable[i] = color_write_disable[i];
      if (color_write_disable[i])
         use_simd16_replicated_data = false;
   }

   blorp_params_get_clear_kernel(batch->blorp, &params,
                                 use_simd16_replicated_data);

   brw_blorp_surface_info_init(batch->blorp, &params.dst, surf, level, layer,
                               format, true);

   batch->blorp->exec(batch, &params);
}

void
blorp_ccs_resolve(struct blorp_batch *batch,
                  struct blorp_surf *surf, enum isl_format format)
{
   struct blorp_params params;
   blorp_params_init(&params);

   brw_blorp_surface_info_init(batch->blorp, &params.dst, surf,
                               0 /* level */, 0 /* layer */, format, true);

   /* From the Ivy Bridge PRM, Vol2 Part1 11.9 "Render Target Resolve":
    *
    *     A rectangle primitive must be scaled down by the following factors
    *     with respect to render target being resolved.
    *
    * The scaledown factors in the table that follows are related to the block
    * size of the CCS format.  For IVB and HSW, we divide by two, for BDW we
    * multiply by 8 and 16. On Sky Lake, we multiply by 8.
    */
   const struct isl_format_layout *aux_fmtl =
      isl_format_get_layout(params.dst.aux_surf.format);
   assert(aux_fmtl->txc == ISL_TXC_CCS);

   unsigned x_scaledown, y_scaledown;
   if (ISL_DEV_GEN(batch->blorp->isl_dev) >= 9) {
      x_scaledown = aux_fmtl->bw * 8;
      y_scaledown = aux_fmtl->bh * 8;
   } else if (ISL_DEV_GEN(batch->blorp->isl_dev) >= 8) {
      x_scaledown = aux_fmtl->bw * 8;
      y_scaledown = aux_fmtl->bh * 16;
   } else {
      x_scaledown = aux_fmtl->bw / 2;
      y_scaledown = aux_fmtl->bh / 2;
   }
   params.x0 = params.y0 = 0;
   params.x1 = params.dst.aux_surf.logical_level0_px.width;
   params.y1 = params.dst.aux_surf.logical_level0_px.height;
   params.x1 = ALIGN(params.x1, x_scaledown) / x_scaledown;
   params.y1 = ALIGN(params.y1, y_scaledown) / y_scaledown;

   if (batch->blorp->isl_dev->info->gen >= 9) {
      if (params.dst.aux_usage == ISL_AUX_USAGE_CCS_E)
         params.fast_clear_op = BLORP_FAST_CLEAR_OP_RESOLVE_FULL;
      else
         params.fast_clear_op = BLORP_FAST_CLEAR_OP_RESOLVE_PARTIAL;
   } else {
      /* Broadwell and earlier do not have a partial resolve */
      params.fast_clear_op = BLORP_FAST_CLEAR_OP_RESOLVE_FULL;
   }

   /* Note: there is no need to initialize push constants because it doesn't
    * matter what data gets dispatched to the render target.  However, we must
    * ensure that the fragment shader delivers the data using the "replicated
    * color" message.
    */

   blorp_params_get_clear_kernel(batch->blorp, &params, true);

   batch->blorp->exec(batch, &params);
}
