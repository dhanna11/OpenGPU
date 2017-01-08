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
#include <stdbool.h>

#include "isl/isl.h"

struct brw_context;
struct brw_wm_prog_key;

#ifdef __cplusplus
extern "C" {
#endif

struct blorp_batch;
struct blorp_params;

struct blorp_context {
   void *driver_ctx;

   const struct isl_device *isl_dev;

   const struct brw_compiler *compiler;

   struct {
      uint32_t tex;
      uint32_t rb;
      uint32_t vb;
   } mocs;

   bool (*lookup_shader)(struct blorp_context *blorp,
                         const void *key, uint32_t key_size,
                         uint32_t *kernel_out, void *prog_data_out);
   void (*upload_shader)(struct blorp_context *blorp,
                         const void *key, uint32_t key_size,
                         const void *kernel, uint32_t kernel_size,
                         const void *prog_data, uint32_t prog_data_size,
                         uint32_t *kernel_out, void *prog_data_out);
   void (*exec)(struct blorp_batch *batch, const struct blorp_params *params);
};

void blorp_init(struct blorp_context *blorp, void *driver_ctx,
                struct isl_device *isl_dev);
void blorp_finish(struct blorp_context *blorp);

struct blorp_batch {
   struct blorp_context *blorp;
   void *driver_batch;
};

void blorp_batch_init(struct blorp_context *blorp, struct blorp_batch *batch,
                      void *driver_batch);
void blorp_batch_finish(struct blorp_batch *batch);

struct blorp_address {
   void *buffer;
   uint32_t read_domains;
   uint32_t write_domain;
   uint32_t offset;
};

struct blorp_surf
{
   const struct isl_surf *surf;
   struct blorp_address addr;

   const struct isl_surf *aux_surf;
   struct blorp_address aux_addr;
   enum isl_aux_usage aux_usage;

   union isl_color_value clear_color;
};

void
blorp_blit(struct blorp_batch *batch,
           const struct blorp_surf *src_surf,
           unsigned src_level, unsigned src_layer,
           enum isl_format src_format, int src_swizzle,
           const struct blorp_surf *dst_surf,
           unsigned dst_level, unsigned dst_layer,
           enum isl_format dst_format,
           float src_x0, float src_y0,
           float src_x1, float src_y1,
           float dst_x0, float dst_y0,
           float dst_x1, float dst_y1,
           uint32_t filter, bool mirror_x, bool mirror_y);

void
blorp_fast_clear(struct blorp_batch *batch,
                 const struct blorp_surf *surf,
                 uint32_t level, uint32_t layer, enum isl_format format,
                 uint32_t x0, uint32_t y0, uint32_t x1, uint32_t y1);

void
blorp_clear(struct blorp_batch *batch,
            const struct blorp_surf *surf,
            uint32_t level, uint32_t layer,
            uint32_t x0, uint32_t y0, uint32_t x1, uint32_t y1,
            enum isl_format format, union isl_color_value clear_color,
            bool color_write_disable[4]);

void
blorp_ccs_resolve(struct blorp_batch *batch,
                  struct blorp_surf *surf, enum isl_format format);

/**
 * For an overview of the HiZ operations, see the following sections of the
 * Sandy Bridge PRM, Volume 1, Part2:
 *   - 7.5.3.1 Depth Buffer Clear
 *   - 7.5.3.2 Depth Buffer Resolve
 *   - 7.5.3.3 Hierarchical Depth Buffer Resolve
 *
 * Of these, two get entered in the resolve map as needing to be done to the
 * buffer: depth resolve and hiz resolve.
 */
enum blorp_hiz_op {
   BLORP_HIZ_OP_NONE,
   BLORP_HIZ_OP_DEPTH_CLEAR,
   BLORP_HIZ_OP_DEPTH_RESOLVE,
   BLORP_HIZ_OP_HIZ_RESOLVE,
};

void
blorp_gen6_hiz_op(struct blorp_batch *batch,
                  struct blorp_surf *surf, unsigned level, unsigned layer,
                  enum blorp_hiz_op op);

#ifdef __cplusplus
} /* end extern "C" */
#endif /* __cplusplus */
