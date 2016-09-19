/*
 * Copyright © 2016 Intel Corporation
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

struct gen_spec;
struct gen_group;
struct gen_field;

static inline uint32_t gen_make_gen(uint32_t major, uint32_t minor)
{
   return (major << 8) | minor;
}

struct gen_group *gen_spec_find_struct(struct gen_spec *spec, const char *name);
struct gen_spec *gen_spec_load(const char *filename);
uint32_t gen_spec_get_gen(struct gen_spec *spec);
struct gen_group *gen_spec_find_instruction(struct gen_spec *spec, const uint32_t *p);
int gen_group_get_length(struct gen_group *group, const uint32_t *p);
const char *gen_group_get_name(struct gen_group *group);
uint32_t gen_group_get_opcode(struct gen_group *group);

struct gen_field_iterator {
   struct gen_group *group;
   const char *name;
   char value[128];
   uint32_t *p;
   int i;
};

struct gen_group {
   char *name;
   int nfields;
   struct gen_field **fields;
   uint32_t group_offset, group_count;

   uint32_t opcode_mask;
   uint32_t opcode;
};

struct gen_type {
   enum {
      GEN_TYPE_UNKNOWN,
      GEN_TYPE_INT,
      GEN_TYPE_UINT,
      GEN_TYPE_BOOL,
      GEN_TYPE_FLOAT,
      GEN_TYPE_ADDRESS,
      GEN_TYPE_OFFSET,
      GEN_TYPE_STRUCT,
      GEN_TYPE_UFIXED,
      GEN_TYPE_SFIXED,
      GEN_TYPE_MBO
   } kind;

   /* Struct definition for  GEN_TYPE_STRUCT */
   struct gen_group *gen_struct;

   /* Integer and fractional sizes for GEN_TYPE_UFIXED and GEN_TYPE_SFIXED */
   int i, f;
};

struct gen_field {
   char *name;
   int start, end;
   struct gen_type type;
   bool has_default;
   uint32_t default_value;
};

void gen_field_iterator_init(struct gen_field_iterator *iter,
                             struct gen_group *group, const uint32_t *p);

bool gen_field_iterator_next(struct gen_field_iterator *iter);
