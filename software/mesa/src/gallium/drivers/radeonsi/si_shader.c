/*
 * Copyright 2012 Advanced Micro Devices, Inc.
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
 *	Tom Stellard <thomas.stellard@amd.com>
 *	Michel Dänzer <michel.daenzer@amd.com>
 *      Christian König <christian.koenig@amd.com>
 */

#include "gallivm/lp_bld_const.h"
#include "gallivm/lp_bld_gather.h"
#include "gallivm/lp_bld_intr.h"
#include "gallivm/lp_bld_logic.h"
#include "gallivm/lp_bld_arit.h"
#include "gallivm/lp_bld_bitarit.h"
#include "gallivm/lp_bld_flow.h"
#include "gallivm/lp_bld_misc.h"
#include "radeon/r600_cs.h"
#include "radeon/radeon_llvm.h"
#include "radeon/radeon_elf_util.h"
#include "radeon/radeon_llvm_emit.h"
#include "util/u_memory.h"
#include "util/u_string.h"
#include "tgsi/tgsi_parse.h"
#include "tgsi/tgsi_build.h"
#include "tgsi/tgsi_util.h"
#include "tgsi/tgsi_dump.h"

#include "si_pipe.h"
#include "si_shader.h"
#include "sid.h"

#include <errno.h>

static const char *scratch_rsrc_dword0_symbol =
	"SCRATCH_RSRC_DWORD0";

static const char *scratch_rsrc_dword1_symbol =
	"SCRATCH_RSRC_DWORD1";

struct si_shader_output_values
{
	LLVMValueRef values[4];
	unsigned name;
	unsigned sid;
};

struct si_shader_context
{
	struct radeon_llvm_context radeon_bld;
	struct si_shader *shader;
	struct si_screen *screen;

	unsigned type; /* PIPE_SHADER_* specifies the type of shader. */
	bool is_gs_copy_shader;

	/* Whether to generate the optimized shader variant compiled as a whole
	 * (without a prolog and epilog)
	 */
	bool is_monolithic;

	int param_streamout_config;
	int param_streamout_write_index;
	int param_streamout_offset[4];
	int param_vertex_id;
	int param_rel_auto_id;
	int param_vs_prim_id;
	int param_instance_id;
	int param_vertex_index0;
	int param_tes_u;
	int param_tes_v;
	int param_tes_rel_patch_id;
	int param_tes_patch_id;
	int param_es2gs_offset;
	int param_oc_lds;

	/* Sets a bit if the dynamic HS control word was 0x80000000. The bit is
	 * 0x800000 for VS, 0x1 for ES.
	 */
	int param_tess_offchip;

	LLVMTargetMachineRef tm;

	unsigned invariant_load_md_kind;
	unsigned range_md_kind;
	unsigned uniform_md_kind;
	LLVMValueRef empty_md;

	LLVMValueRef const_buffers[SI_NUM_CONST_BUFFERS];
	LLVMValueRef lds;
	LLVMValueRef *constants[SI_NUM_CONST_BUFFERS];
	LLVMValueRef shader_buffers[SI_NUM_SHADER_BUFFERS];
	LLVMValueRef sampler_views[SI_NUM_SAMPLERS];
	LLVMValueRef sampler_states[SI_NUM_SAMPLERS];
	LLVMValueRef fmasks[SI_NUM_SAMPLERS];
	LLVMValueRef images[SI_NUM_IMAGES];
	LLVMValueRef so_buffers[4];
	LLVMValueRef esgs_ring;
	LLVMValueRef gsvs_ring[4];
	LLVMValueRef gs_next_vertex[4];
	LLVMValueRef return_value;

	LLVMTypeRef voidt;
	LLVMTypeRef i1;
	LLVMTypeRef i8;
	LLVMTypeRef i32;
	LLVMTypeRef i64;
	LLVMTypeRef i128;
	LLVMTypeRef f32;
	LLVMTypeRef v16i8;
	LLVMTypeRef v2i32;
	LLVMTypeRef v4i32;
	LLVMTypeRef v4f32;
	LLVMTypeRef v8i32;

	LLVMValueRef shared_memory;
};

static struct si_shader_context *si_shader_context(
	struct lp_build_tgsi_context *bld_base)
{
	return (struct si_shader_context *)bld_base;
}

static void si_init_shader_ctx(struct si_shader_context *ctx,
			       struct si_screen *sscreen,
			       struct si_shader *shader,
			       LLVMTargetMachineRef tm);

static void si_llvm_emit_barrier(const struct lp_build_tgsi_action *action,
				 struct lp_build_tgsi_context *bld_base,
				 struct lp_build_emit_data *emit_data);

static void si_dump_shader_key(unsigned shader, union si_shader_key *key,
			       FILE *f);

/* Ideally pass the sample mask input to the PS epilog as v13, which
 * is its usual location, so that the shader doesn't have to add v_mov.
 */
#define PS_EPILOG_SAMPLEMASK_MIN_LOC 13

/* The VS location of the PrimitiveID input is the same in the epilog,
 * so that the main shader part doesn't have to move it.
 */
#define VS_EPILOG_PRIMID_LOC 2

#define PERSPECTIVE_BASE 0
#define LINEAR_BASE 9

#define SAMPLE_OFFSET 0
#define CENTER_OFFSET 2
#define CENTROID_OFSET 4

#define USE_SGPR_MAX_SUFFIX_LEN 5
#define CONST_ADDR_SPACE 2
#define LOCAL_ADDR_SPACE 3
#define USER_SGPR_ADDR_SPACE 8


#define SENDMSG_GS 2
#define SENDMSG_GS_DONE 3

#define SENDMSG_GS_OP_NOP      (0 << 4)
#define SENDMSG_GS_OP_CUT      (1 << 4)
#define SENDMSG_GS_OP_EMIT     (2 << 4)
#define SENDMSG_GS_OP_EMIT_CUT (3 << 4)

/**
 * Returns a unique index for a semantic name and index. The index must be
 * less than 64, so that a 64-bit bitmask of used inputs or outputs can be
 * calculated.
 */
unsigned si_shader_io_get_unique_index(unsigned semantic_name, unsigned index)
{
	switch (semantic_name) {
	case TGSI_SEMANTIC_POSITION:
		return 0;
	case TGSI_SEMANTIC_PSIZE:
		return 1;
	case TGSI_SEMANTIC_CLIPDIST:
		assert(index <= 1);
		return 2 + index;
	case TGSI_SEMANTIC_GENERIC:
		if (index <= 63-4)
			return 4 + index;
		else
			/* same explanation as in the default statement,
			 * the only user hitting this is st/nine.
			 */
			return 0;

	/* patch indices are completely separate and thus start from 0 */
	case TGSI_SEMANTIC_TESSOUTER:
		return 0;
	case TGSI_SEMANTIC_TESSINNER:
		return 1;
	case TGSI_SEMANTIC_PATCH:
		return 2 + index;

	default:
		/* Don't fail here. The result of this function is only used
		 * for LS, TCS, TES, and GS, where legacy GL semantics can't
		 * occur, but this function is called for all vertex shaders
		 * before it's known whether LS will be compiled or not.
		 */
		return 0;
	}
}

/**
 * Get the value of a shader input parameter and extract a bitfield.
 */
static LLVMValueRef unpack_param(struct si_shader_context *ctx,
				 unsigned param, unsigned rshift,
				 unsigned bitwidth)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMValueRef value = LLVMGetParam(ctx->radeon_bld.main_fn,
					  param);

	if (LLVMGetTypeKind(LLVMTypeOf(value)) == LLVMFloatTypeKind)
		value = bitcast(&ctx->radeon_bld.soa.bld_base,
				TGSI_TYPE_UNSIGNED, value);

	if (rshift)
		value = LLVMBuildLShr(gallivm->builder, value,
				      lp_build_const_int32(gallivm, rshift), "");

	if (rshift + bitwidth < 32) {
		unsigned mask = (1 << bitwidth) - 1;
		value = LLVMBuildAnd(gallivm->builder, value,
				     lp_build_const_int32(gallivm, mask), "");
	}

	return value;
}

static LLVMValueRef get_rel_patch_id(struct si_shader_context *ctx)
{
	switch (ctx->type) {
	case PIPE_SHADER_TESS_CTRL:
		return unpack_param(ctx, SI_PARAM_REL_IDS, 0, 8);

	case PIPE_SHADER_TESS_EVAL:
		return LLVMGetParam(ctx->radeon_bld.main_fn,
				    ctx->param_tes_rel_patch_id);

	default:
		assert(0);
		return NULL;
	}
}

/* Tessellation shaders pass outputs to the next shader using LDS.
 *
 * LS outputs = TCS inputs
 * TCS outputs = TES inputs
 *
 * The LDS layout is:
 * - TCS inputs for patch 0
 * - TCS inputs for patch 1
 * - TCS inputs for patch 2		= get_tcs_in_current_patch_offset (if RelPatchID==2)
 * - ...
 * - TCS outputs for patch 0            = get_tcs_out_patch0_offset
 * - Per-patch TCS outputs for patch 0  = get_tcs_out_patch0_patch_data_offset
 * - TCS outputs for patch 1
 * - Per-patch TCS outputs for patch 1
 * - TCS outputs for patch 2            = get_tcs_out_current_patch_offset (if RelPatchID==2)
 * - Per-patch TCS outputs for patch 2  = get_tcs_out_current_patch_data_offset (if RelPatchID==2)
 * - ...
 *
 * All three shaders VS(LS), TCS, TES share the same LDS space.
 */

static LLVMValueRef
get_tcs_in_patch_stride(struct si_shader_context *ctx)
{
	if (ctx->type == PIPE_SHADER_VERTEX)
		return unpack_param(ctx, SI_PARAM_LS_OUT_LAYOUT, 0, 13);
	else if (ctx->type == PIPE_SHADER_TESS_CTRL)
		return unpack_param(ctx, SI_PARAM_TCS_IN_LAYOUT, 0, 13);
	else {
		assert(0);
		return NULL;
	}
}

static LLVMValueRef
get_tcs_out_patch_stride(struct si_shader_context *ctx)
{
	return unpack_param(ctx, SI_PARAM_TCS_OUT_LAYOUT, 0, 13);
}

static LLVMValueRef
get_tcs_out_patch0_offset(struct si_shader_context *ctx)
{
	return lp_build_mul_imm(&ctx->radeon_bld.soa.bld_base.uint_bld,
				unpack_param(ctx,
					     SI_PARAM_TCS_OUT_OFFSETS,
					     0, 16),
				4);
}

static LLVMValueRef
get_tcs_out_patch0_patch_data_offset(struct si_shader_context *ctx)
{
	return lp_build_mul_imm(&ctx->radeon_bld.soa.bld_base.uint_bld,
				unpack_param(ctx,
					     SI_PARAM_TCS_OUT_OFFSETS,
					     16, 16),
				4);
}

static LLVMValueRef
get_tcs_in_current_patch_offset(struct si_shader_context *ctx)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMValueRef patch_stride = get_tcs_in_patch_stride(ctx);
	LLVMValueRef rel_patch_id = get_rel_patch_id(ctx);

	return LLVMBuildMul(gallivm->builder, patch_stride, rel_patch_id, "");
}

static LLVMValueRef
get_tcs_out_current_patch_offset(struct si_shader_context *ctx)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMValueRef patch0_offset = get_tcs_out_patch0_offset(ctx);
	LLVMValueRef patch_stride = get_tcs_out_patch_stride(ctx);
	LLVMValueRef rel_patch_id = get_rel_patch_id(ctx);

	return LLVMBuildAdd(gallivm->builder, patch0_offset,
			    LLVMBuildMul(gallivm->builder, patch_stride,
					 rel_patch_id, ""),
			    "");
}

static LLVMValueRef
get_tcs_out_current_patch_data_offset(struct si_shader_context *ctx)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMValueRef patch0_patch_data_offset =
		get_tcs_out_patch0_patch_data_offset(ctx);
	LLVMValueRef patch_stride = get_tcs_out_patch_stride(ctx);
	LLVMValueRef rel_patch_id = get_rel_patch_id(ctx);

	return LLVMBuildAdd(gallivm->builder, patch0_patch_data_offset,
			    LLVMBuildMul(gallivm->builder, patch_stride,
					 rel_patch_id, ""),
			    "");
}

static void build_indexed_store(struct si_shader_context *ctx,
				LLVMValueRef base_ptr, LLVMValueRef index,
				LLVMValueRef value)
{
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef indices[2], pointer;

	indices[0] = bld_base->uint_bld.zero;
	indices[1] = index;

	pointer = LLVMBuildGEP(gallivm->builder, base_ptr, indices, 2, "");
	LLVMBuildStore(gallivm->builder, value, pointer);
}

/**
 * Build an LLVM bytecode indexed load using LLVMBuildGEP + LLVMBuildLoad.
 * It's equivalent to doing a load from &base_ptr[index].
 *
 * \param base_ptr  Where the array starts.
 * \param index     The element index into the array.
 * \param uniform   Whether the base_ptr and index can be assumed to be
 *                  dynamically uniform
 */
static LLVMValueRef build_indexed_load(struct si_shader_context *ctx,
				       LLVMValueRef base_ptr, LLVMValueRef index,
				       bool uniform)
{
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef indices[2], pointer;

	indices[0] = bld_base->uint_bld.zero;
	indices[1] = index;

	pointer = LLVMBuildGEP(gallivm->builder, base_ptr, indices, 2, "");
	if (uniform)
		LLVMSetMetadata(pointer, ctx->uniform_md_kind, ctx->empty_md);
	return LLVMBuildLoad(gallivm->builder, pointer, "");
}

/**
 * Do a load from &base_ptr[index], but also add a flag that it's loading
 * a constant from a dynamically uniform index.
 */
static LLVMValueRef build_indexed_load_const(
	struct si_shader_context *ctx,
	LLVMValueRef base_ptr, LLVMValueRef index)
{
	LLVMValueRef result = build_indexed_load(ctx, base_ptr, index, true);
	LLVMSetMetadata(result, ctx->invariant_load_md_kind, ctx->empty_md);
	return result;
}

static LLVMValueRef get_instance_index_for_fetch(
	struct radeon_llvm_context *radeon_bld,
	unsigned param_start_instance, unsigned divisor)
{
	struct si_shader_context *ctx =
		si_shader_context(&radeon_bld->soa.bld_base);
	struct gallivm_state *gallivm = radeon_bld->soa.bld_base.base.gallivm;

	LLVMValueRef result = LLVMGetParam(radeon_bld->main_fn,
					   ctx->param_instance_id);

	/* The division must be done before START_INSTANCE is added. */
	if (divisor > 1)
		result = LLVMBuildUDiv(gallivm->builder, result,
				lp_build_const_int32(gallivm, divisor), "");

	return LLVMBuildAdd(gallivm->builder, result,
			    LLVMGetParam(radeon_bld->main_fn, param_start_instance), "");
}

static void declare_input_vs(
	struct radeon_llvm_context *radeon_bld,
	unsigned input_index,
	const struct tgsi_full_declaration *decl)
{
	struct lp_build_context *base = &radeon_bld->soa.bld_base.base;
	struct gallivm_state *gallivm = base->gallivm;
	struct si_shader_context *ctx =
		si_shader_context(&radeon_bld->soa.bld_base);
	unsigned divisor =
		ctx->shader->key.vs.prolog.instance_divisors[input_index];

	unsigned chan;

	LLVMValueRef t_list_ptr;
	LLVMValueRef t_offset;
	LLVMValueRef t_list;
	LLVMValueRef attribute_offset;
	LLVMValueRef buffer_index;
	LLVMValueRef args[3];
	LLVMValueRef input;

	/* Load the T list */
	t_list_ptr = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_VERTEX_BUFFERS);

	t_offset = lp_build_const_int32(gallivm, input_index);

	t_list = build_indexed_load_const(ctx, t_list_ptr, t_offset);

	/* Build the attribute offset */
	attribute_offset = lp_build_const_int32(gallivm, 0);

	if (!ctx->is_monolithic) {
		buffer_index = LLVMGetParam(radeon_bld->main_fn,
					    ctx->param_vertex_index0 +
					    input_index);
	} else if (divisor) {
		/* Build index from instance ID, start instance and divisor */
		ctx->shader->info.uses_instanceid = true;
		buffer_index = get_instance_index_for_fetch(&ctx->radeon_bld,
							    SI_PARAM_START_INSTANCE,
							    divisor);
	} else {
		/* Load the buffer index for vertices. */
		LLVMValueRef vertex_id = LLVMGetParam(ctx->radeon_bld.main_fn,
						      ctx->param_vertex_id);
		LLVMValueRef base_vertex = LLVMGetParam(radeon_bld->main_fn,
							SI_PARAM_BASE_VERTEX);
		buffer_index = LLVMBuildAdd(gallivm->builder, base_vertex, vertex_id, "");
	}

	args[0] = t_list;
	args[1] = attribute_offset;
	args[2] = buffer_index;
	input = lp_build_intrinsic(gallivm->builder,
		"llvm.SI.vs.load.input", ctx->v4f32, args, 3,
		LLVMReadNoneAttribute);

	/* Break up the vec4 into individual components */
	for (chan = 0; chan < 4; chan++) {
		LLVMValueRef llvm_chan = lp_build_const_int32(gallivm, chan);
		/* XXX: Use a helper function for this.  There is one in
 		 * tgsi_llvm.c. */
		ctx->radeon_bld.inputs[radeon_llvm_reg_index_soa(input_index, chan)] =
				LLVMBuildExtractElement(gallivm->builder,
				input, llvm_chan, "");
	}
}

static LLVMValueRef get_primitive_id(struct lp_build_tgsi_context *bld_base,
				     unsigned swizzle)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);

	if (swizzle > 0)
		return bld_base->uint_bld.zero;

	switch (ctx->type) {
	case PIPE_SHADER_VERTEX:
		return LLVMGetParam(ctx->radeon_bld.main_fn,
				    ctx->param_vs_prim_id);
	case PIPE_SHADER_TESS_CTRL:
		return LLVMGetParam(ctx->radeon_bld.main_fn,
				    SI_PARAM_PATCH_ID);
	case PIPE_SHADER_TESS_EVAL:
		return LLVMGetParam(ctx->radeon_bld.main_fn,
				    ctx->param_tes_patch_id);
	case PIPE_SHADER_GEOMETRY:
		return LLVMGetParam(ctx->radeon_bld.main_fn,
				    SI_PARAM_PRIMITIVE_ID);
	default:
		assert(0);
		return bld_base->uint_bld.zero;
	}
}

/**
 * Return the value of tgsi_ind_register for indexing.
 * This is the indirect index with the constant offset added to it.
 */
static LLVMValueRef get_indirect_index(struct si_shader_context *ctx,
				       const struct tgsi_ind_register *ind,
				       int rel_index)
{
	struct gallivm_state *gallivm = ctx->radeon_bld.soa.bld_base.base.gallivm;
	LLVMValueRef result;

	result = ctx->radeon_bld.soa.addr[ind->Index][ind->Swizzle];
	result = LLVMBuildLoad(gallivm->builder, result, "");
	result = LLVMBuildAdd(gallivm->builder, result,
			      lp_build_const_int32(gallivm, rel_index), "");
	return result;
}

/**
 * Like get_indirect_index, but restricts the return value to a (possibly
 * undefined) value inside [0..num).
 */
static LLVMValueRef get_bounded_indirect_index(struct si_shader_context *ctx,
					       const struct tgsi_ind_register *ind,
					       int rel_index, unsigned num)
{
	LLVMValueRef result = get_indirect_index(ctx, ind, rel_index);

	/* LLVM 3.8: If indirect resource indexing is used:
	 * - SI & CIK hang
	 * - VI crashes
	 */
	if (HAVE_LLVM <= 0x0308)
		return LLVMGetUndef(ctx->i32);

	return radeon_llvm_bound_index(&ctx->radeon_bld, result, num);
}


/**
 * Calculate a dword address given an input or output register and a stride.
 */
static LLVMValueRef get_dw_address(struct si_shader_context *ctx,
				   const struct tgsi_full_dst_register *dst,
				   const struct tgsi_full_src_register *src,
				   LLVMValueRef vertex_dw_stride,
				   LLVMValueRef base_addr)
{
	struct gallivm_state *gallivm = ctx->radeon_bld.soa.bld_base.base.gallivm;
	struct tgsi_shader_info *info = &ctx->shader->selector->info;
	ubyte *name, *index, *array_first;
	int first, param;
	struct tgsi_full_dst_register reg;

	/* Set the register description. The address computation is the same
	 * for sources and destinations. */
	if (src) {
		reg.Register.File = src->Register.File;
		reg.Register.Index = src->Register.Index;
		reg.Register.Indirect = src->Register.Indirect;
		reg.Register.Dimension = src->Register.Dimension;
		reg.Indirect = src->Indirect;
		reg.Dimension = src->Dimension;
		reg.DimIndirect = src->DimIndirect;
	} else
		reg = *dst;

	/* If the register is 2-dimensional (e.g. an array of vertices
	 * in a primitive), calculate the base address of the vertex. */
	if (reg.Register.Dimension) {
		LLVMValueRef index;

		if (reg.Dimension.Indirect)
			index = get_indirect_index(ctx, &reg.DimIndirect,
						   reg.Dimension.Index);
		else
			index = lp_build_const_int32(gallivm, reg.Dimension.Index);

		base_addr = LLVMBuildAdd(gallivm->builder, base_addr,
					 LLVMBuildMul(gallivm->builder, index,
						      vertex_dw_stride, ""), "");
	}

	/* Get information about the register. */
	if (reg.Register.File == TGSI_FILE_INPUT) {
		name = info->input_semantic_name;
		index = info->input_semantic_index;
		array_first = info->input_array_first;
	} else if (reg.Register.File == TGSI_FILE_OUTPUT) {
		name = info->output_semantic_name;
		index = info->output_semantic_index;
		array_first = info->output_array_first;
	} else {
		assert(0);
		return NULL;
	}

	if (reg.Register.Indirect) {
		/* Add the relative address of the element. */
		LLVMValueRef ind_index;

		if (reg.Indirect.ArrayID)
			first = array_first[reg.Indirect.ArrayID];
		else
			first = reg.Register.Index;

		ind_index = get_indirect_index(ctx, &reg.Indirect,
					   reg.Register.Index - first);

		base_addr = LLVMBuildAdd(gallivm->builder, base_addr,
				    LLVMBuildMul(gallivm->builder, ind_index,
						 lp_build_const_int32(gallivm, 4), ""), "");

		param = si_shader_io_get_unique_index(name[first], index[first]);
	} else {
		param = si_shader_io_get_unique_index(name[reg.Register.Index],
						      index[reg.Register.Index]);
	}

	/* Add the base address of the element. */
	return LLVMBuildAdd(gallivm->builder, base_addr,
			    lp_build_const_int32(gallivm, param * 4), "");
}

/* The offchip buffer layout for TCS->TES is
 *
 * - attribute 0 of patch 0 vertex 0
 * - attribute 0 of patch 0 vertex 1
 * - attribute 0 of patch 0 vertex 2
 *   ...
 * - attribute 0 of patch 1 vertex 0
 * - attribute 0 of patch 1 vertex 1
 *   ...
 * - attribute 1 of patch 0 vertex 0
 * - attribute 1 of patch 0 vertex 1
 *   ...
 * - per patch attribute 0 of patch 0
 * - per patch attribute 0 of patch 1
 *   ...
 *
 * Note that every attribute has 4 components.
 */
static LLVMValueRef get_tcs_tes_buffer_address(struct si_shader_context *ctx,
                                               LLVMValueRef vertex_index,
                                               LLVMValueRef param_index)
{
	struct gallivm_state *gallivm = ctx->radeon_bld.soa.bld_base.base.gallivm;
	LLVMValueRef base_addr, vertices_per_patch, num_patches, total_vertices;
	LLVMValueRef param_stride, constant16;

	vertices_per_patch = unpack_param(ctx, SI_PARAM_TCS_OFFCHIP_LAYOUT, 9, 6);
	num_patches = unpack_param(ctx, SI_PARAM_TCS_OFFCHIP_LAYOUT, 0, 9);
	total_vertices = LLVMBuildMul(gallivm->builder, vertices_per_patch,
	                              num_patches, "");

	constant16 = lp_build_const_int32(gallivm, 16);
	if (vertex_index) {
		base_addr = LLVMBuildMul(gallivm->builder, get_rel_patch_id(ctx),
		                         vertices_per_patch, "");

		base_addr = LLVMBuildAdd(gallivm->builder, base_addr,
		                         vertex_index, "");

		param_stride = total_vertices;
	} else {
		base_addr = get_rel_patch_id(ctx);
		param_stride = num_patches;
	}

	base_addr = LLVMBuildAdd(gallivm->builder, base_addr,
	                         LLVMBuildMul(gallivm->builder, param_index,
	                                      param_stride, ""), "");

	base_addr = LLVMBuildMul(gallivm->builder, base_addr, constant16, "");

	if (!vertex_index) {
		LLVMValueRef patch_data_offset =
		           unpack_param(ctx, SI_PARAM_TCS_OFFCHIP_LAYOUT, 16, 16);

		base_addr = LLVMBuildAdd(gallivm->builder, base_addr,
		                         patch_data_offset, "");
	}
	return base_addr;
}

static LLVMValueRef get_tcs_tes_buffer_address_from_reg(
                                       struct si_shader_context *ctx,
                                       const struct tgsi_full_dst_register *dst,
                                       const struct tgsi_full_src_register *src)
{
	struct gallivm_state *gallivm = ctx->radeon_bld.soa.bld_base.base.gallivm;
	struct tgsi_shader_info *info = &ctx->shader->selector->info;
	ubyte *name, *index, *array_first;
	struct tgsi_full_src_register reg;
	LLVMValueRef vertex_index = NULL;
	LLVMValueRef param_index = NULL;
	unsigned param_index_base, param_base;

	reg = src ? *src : tgsi_full_src_register_from_dst(dst);

	if (reg.Register.Dimension) {

		if (reg.Dimension.Indirect)
			vertex_index = get_indirect_index(ctx, &reg.DimIndirect,
			                                  reg.Dimension.Index);
		else
			vertex_index = lp_build_const_int32(gallivm,
			                                    reg.Dimension.Index);
	}

	/* Get information about the register. */
	if (reg.Register.File == TGSI_FILE_INPUT) {
		name = info->input_semantic_name;
		index = info->input_semantic_index;
		array_first = info->input_array_first;
	} else if (reg.Register.File == TGSI_FILE_OUTPUT) {
		name = info->output_semantic_name;
		index = info->output_semantic_index;
		array_first = info->output_array_first;
	} else {
		assert(0);
		return NULL;
	}

	if (reg.Register.Indirect) {
		if (reg.Indirect.ArrayID)
			param_base = array_first[reg.Indirect.ArrayID];
		else
			param_base = reg.Register.Index;

		param_index = get_indirect_index(ctx, &reg.Indirect,
		                                 reg.Register.Index - param_base);

	} else {
		param_base = reg.Register.Index;
		param_index = lp_build_const_int32(gallivm, 0);
	}

	param_index_base = si_shader_io_get_unique_index(name[param_base],
	                                                 index[param_base]);

	param_index = LLVMBuildAdd(gallivm->builder, param_index,
	                           lp_build_const_int32(gallivm, param_index_base),
	                           "");

	return get_tcs_tes_buffer_address(ctx, vertex_index, param_index);
}

/* TBUFFER_STORE_FORMAT_{X,XY,XYZ,XYZW} <- the suffix is selected by num_channels=1..4.
 * The type of vdata must be one of i32 (num_channels=1), v2i32 (num_channels=2),
 * or v4i32 (num_channels=3,4). */
static void build_tbuffer_store(struct si_shader_context *ctx,
				LLVMValueRef rsrc,
				LLVMValueRef vdata,
				unsigned num_channels,
				LLVMValueRef vaddr,
				LLVMValueRef soffset,
				unsigned inst_offset,
				unsigned dfmt,
				unsigned nfmt,
				unsigned offen,
				unsigned idxen,
				unsigned glc,
				unsigned slc,
				unsigned tfe)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMValueRef args[] = {
		rsrc,
		vdata,
		LLVMConstInt(ctx->i32, num_channels, 0),
		vaddr,
		soffset,
		LLVMConstInt(ctx->i32, inst_offset, 0),
		LLVMConstInt(ctx->i32, dfmt, 0),
		LLVMConstInt(ctx->i32, nfmt, 0),
		LLVMConstInt(ctx->i32, offen, 0),
		LLVMConstInt(ctx->i32, idxen, 0),
		LLVMConstInt(ctx->i32, glc, 0),
		LLVMConstInt(ctx->i32, slc, 0),
		LLVMConstInt(ctx->i32, tfe, 0)
	};

	/* The instruction offset field has 12 bits */
	assert(offen || inst_offset < (1 << 12));

	/* The intrinsic is overloaded, we need to add a type suffix for overloading to work. */
	unsigned func = CLAMP(num_channels, 1, 3) - 1;
	const char *types[] = {"i32", "v2i32", "v4i32"};
	char name[256];
	snprintf(name, sizeof(name), "llvm.SI.tbuffer.store.%s", types[func]);

	lp_build_intrinsic(gallivm->builder, name, ctx->voidt,
			   args, ARRAY_SIZE(args), 0);
}

static void build_tbuffer_store_dwords(struct si_shader_context *ctx,
				     LLVMValueRef rsrc,
				     LLVMValueRef vdata,
				     unsigned num_channels,
				     LLVMValueRef vaddr,
				     LLVMValueRef soffset,
				     unsigned inst_offset)
{
	static unsigned dfmt[] = {
		V_008F0C_BUF_DATA_FORMAT_32,
		V_008F0C_BUF_DATA_FORMAT_32_32,
		V_008F0C_BUF_DATA_FORMAT_32_32_32,
		V_008F0C_BUF_DATA_FORMAT_32_32_32_32
	};
	assert(num_channels >= 1 && num_channels <= 4);

	build_tbuffer_store(ctx, rsrc, vdata, num_channels, vaddr, soffset,
			    inst_offset, dfmt[num_channels-1],
			    V_008F0C_BUF_NUM_FORMAT_UINT, 1, 0, 1, 1, 0);
}

static LLVMValueRef build_buffer_load(struct si_shader_context *ctx,
                                      LLVMValueRef rsrc,
                                      int num_channels,
                                      LLVMValueRef vindex,
                                      LLVMValueRef voffset,
                                      LLVMValueRef soffset,
                                      unsigned inst_offset,
                                      unsigned glc,
                                      unsigned slc)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	unsigned func = CLAMP(num_channels, 1, 3) - 1;

	if (HAVE_LLVM >= 0x309) {
		LLVMValueRef args[] = {
			LLVMBuildBitCast(gallivm->builder, rsrc, ctx->v4i32, ""),
			vindex ? vindex : LLVMConstInt(ctx->i32, 0, 0),
			LLVMConstInt(ctx->i32, inst_offset, 0),
			LLVMConstInt(ctx->i1, glc, 0),
			LLVMConstInt(ctx->i1, slc, 0)
		};

		LLVMTypeRef types[] = {ctx->f32, LLVMVectorType(ctx->f32, 2),
		                       ctx->v4f32};
		const char *type_names[] = {"f32", "v2f32", "v4f32"};
		char name[256];

		if (voffset) {
			args[2] = LLVMBuildAdd(gallivm->builder, args[2], voffset,
			                       "");
		}

		if (soffset) {
			args[2] = LLVMBuildAdd(gallivm->builder, args[2], soffset,
			                       "");
		}

		snprintf(name, sizeof(name), "llvm.amdgcn.buffer.load.%s",
		         type_names[func]);

		return lp_build_intrinsic(gallivm->builder, name, types[func], args,
		                          ARRAY_SIZE(args), LLVMReadOnlyAttribute);
	} else {
		LLVMValueRef args[] = {
			LLVMBuildBitCast(gallivm->builder, rsrc, ctx->v16i8, ""),
			voffset ? voffset : vindex,
			soffset,
			LLVMConstInt(ctx->i32, inst_offset, 0),
			LLVMConstInt(ctx->i32, voffset ? 1 : 0, 0), // offen
			LLVMConstInt(ctx->i32, vindex ? 1 : 0, 0), //idxen
			LLVMConstInt(ctx->i32, glc, 0),
			LLVMConstInt(ctx->i32, slc, 0),
			LLVMConstInt(ctx->i32, 0, 0), // TFE
		};

		LLVMTypeRef types[] = {ctx->i32, LLVMVectorType(ctx->i32, 2),
		                       ctx->v4i32};
		const char *type_names[] = {"i32", "v2i32", "v4i32"};
		const char *arg_type = "i32";
		char name[256];

		if (voffset && vindex) {
			LLVMValueRef vaddr[] = {vindex, voffset};

			arg_type = "v2i32";
			args[1] = lp_build_gather_values(gallivm, vaddr, 2);
		}

		snprintf(name, sizeof(name), "llvm.SI.buffer.load.dword.%s.%s",
		         type_names[func], arg_type);

		return lp_build_intrinsic(gallivm->builder, name, types[func], args,
		                          ARRAY_SIZE(args), LLVMReadOnlyAttribute);
	}
}

static LLVMValueRef buffer_load(struct lp_build_tgsi_context *bld_base,
                                enum tgsi_opcode_type type, unsigned swizzle,
                                LLVMValueRef buffer, LLVMValueRef offset,
                                LLVMValueRef base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef value, value2;
	LLVMTypeRef llvm_type = tgsi2llvmtype(bld_base, type);
	LLVMTypeRef vec_type = LLVMVectorType(llvm_type, 4);

	if (swizzle == ~0) {
		value = build_buffer_load(ctx, buffer, 4, NULL, base, offset,
		                          0, 1, 0);

		return LLVMBuildBitCast(gallivm->builder, value, vec_type, "");
	}

	if (!tgsi_type_is_64bit(type)) {
		value = build_buffer_load(ctx, buffer, 4, NULL, base, offset,
		                          0, 1, 0);

		value = LLVMBuildBitCast(gallivm->builder, value, vec_type, "");
		return LLVMBuildExtractElement(gallivm->builder, value,
		                    lp_build_const_int32(gallivm, swizzle), "");
	}

	value = build_buffer_load(ctx, buffer, 1, NULL, base, offset,
	                          swizzle * 4, 1, 0);

	value2 = build_buffer_load(ctx, buffer, 1, NULL, base, offset,
	                           swizzle * 4 + 4, 1, 0);

	return radeon_llvm_emit_fetch_64bit(bld_base, type, value, value2);
}

/**
 * Load from LDS.
 *
 * \param type		output value type
 * \param swizzle	offset (typically 0..3); it can be ~0, which loads a vec4
 * \param dw_addr	address in dwords
 */
static LLVMValueRef lds_load(struct lp_build_tgsi_context *bld_base,
			     enum tgsi_opcode_type type, unsigned swizzle,
			     LLVMValueRef dw_addr)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef value;

	if (swizzle == ~0) {
		LLVMValueRef values[TGSI_NUM_CHANNELS];

		for (unsigned chan = 0; chan < TGSI_NUM_CHANNELS; chan++)
			values[chan] = lds_load(bld_base, type, chan, dw_addr);

		return lp_build_gather_values(bld_base->base.gallivm, values,
					      TGSI_NUM_CHANNELS);
	}

	dw_addr = lp_build_add(&bld_base->uint_bld, dw_addr,
			    lp_build_const_int32(gallivm, swizzle));

	value = build_indexed_load(ctx, ctx->lds, dw_addr, false);
	if (tgsi_type_is_64bit(type)) {
		LLVMValueRef value2;
		dw_addr = lp_build_add(&bld_base->uint_bld, dw_addr,
				       lp_build_const_int32(gallivm, swizzle + 1));
		value2 = build_indexed_load(ctx, ctx->lds, dw_addr, false);
		return radeon_llvm_emit_fetch_64bit(bld_base, type, value, value2);
	}

	return LLVMBuildBitCast(gallivm->builder, value,
				tgsi2llvmtype(bld_base, type), "");
}

/**
 * Store to LDS.
 *
 * \param swizzle	offset (typically 0..3)
 * \param dw_addr	address in dwords
 * \param value		value to store
 */
static void lds_store(struct lp_build_tgsi_context *bld_base,
		      unsigned swizzle, LLVMValueRef dw_addr,
		      LLVMValueRef value)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;

	dw_addr = lp_build_add(&bld_base->uint_bld, dw_addr,
			    lp_build_const_int32(gallivm, swizzle));

	value = LLVMBuildBitCast(gallivm->builder, value, ctx->i32, "");
	build_indexed_store(ctx, ctx->lds,
			    dw_addr, value);
}

static LLVMValueRef fetch_input_tcs(
	struct lp_build_tgsi_context *bld_base,
	const struct tgsi_full_src_register *reg,
	enum tgsi_opcode_type type, unsigned swizzle)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	LLVMValueRef dw_addr, stride;

	stride = unpack_param(ctx, SI_PARAM_TCS_IN_LAYOUT, 13, 8);
	dw_addr = get_tcs_in_current_patch_offset(ctx);
	dw_addr = get_dw_address(ctx, NULL, reg, stride, dw_addr);

	return lds_load(bld_base, type, swizzle, dw_addr);
}

static LLVMValueRef fetch_output_tcs(
		struct lp_build_tgsi_context *bld_base,
		const struct tgsi_full_src_register *reg,
		enum tgsi_opcode_type type, unsigned swizzle)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	LLVMValueRef dw_addr, stride;

	if (reg->Register.Dimension) {
		stride = unpack_param(ctx, SI_PARAM_TCS_OUT_LAYOUT, 13, 8);
		dw_addr = get_tcs_out_current_patch_offset(ctx);
		dw_addr = get_dw_address(ctx, NULL, reg, stride, dw_addr);
	} else {
		dw_addr = get_tcs_out_current_patch_data_offset(ctx);
		dw_addr = get_dw_address(ctx, NULL, reg, NULL, dw_addr);
	}

	return lds_load(bld_base, type, swizzle, dw_addr);
}

static LLVMValueRef fetch_input_tes(
	struct lp_build_tgsi_context *bld_base,
	const struct tgsi_full_src_register *reg,
	enum tgsi_opcode_type type, unsigned swizzle)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef rw_buffers, buffer, base, addr;

	rw_buffers = LLVMGetParam(ctx->radeon_bld.main_fn,
				  SI_PARAM_RW_BUFFERS);
	buffer = build_indexed_load_const(ctx, rw_buffers,
			lp_build_const_int32(gallivm, SI_HS_RING_TESS_OFFCHIP));

	base = LLVMGetParam(ctx->radeon_bld.main_fn, ctx->param_oc_lds);
	addr = get_tcs_tes_buffer_address_from_reg(ctx, NULL, reg);

	return buffer_load(bld_base, type, swizzle, buffer, base, addr);
}

static void store_output_tcs(struct lp_build_tgsi_context *bld_base,
			     const struct tgsi_full_instruction *inst,
			     const struct tgsi_opcode_info *info,
			     LLVMValueRef dst[4])
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	const struct tgsi_full_dst_register *reg = &inst->Dst[0];
	unsigned chan_index;
	LLVMValueRef dw_addr, stride;
	LLVMValueRef rw_buffers, buffer, base, buf_addr;
	LLVMValueRef values[4];

	/* Only handle per-patch and per-vertex outputs here.
	 * Vectors will be lowered to scalars and this function will be called again.
	 */
	if (reg->Register.File != TGSI_FILE_OUTPUT ||
	    (dst[0] && LLVMGetTypeKind(LLVMTypeOf(dst[0])) == LLVMVectorTypeKind)) {
		radeon_llvm_emit_store(bld_base, inst, info, dst);
		return;
	}

	if (reg->Register.Dimension) {
		stride = unpack_param(ctx, SI_PARAM_TCS_OUT_LAYOUT, 13, 8);
		dw_addr = get_tcs_out_current_patch_offset(ctx);
		dw_addr = get_dw_address(ctx, reg, NULL, stride, dw_addr);
	} else {
		dw_addr = get_tcs_out_current_patch_data_offset(ctx);
		dw_addr = get_dw_address(ctx, reg, NULL, NULL, dw_addr);
	}

	rw_buffers = LLVMGetParam(ctx->radeon_bld.main_fn,
				  SI_PARAM_RW_BUFFERS);
	buffer = build_indexed_load_const(ctx, rw_buffers,
			lp_build_const_int32(gallivm, SI_HS_RING_TESS_OFFCHIP));

	base = LLVMGetParam(ctx->radeon_bld.main_fn, ctx->param_oc_lds);
	buf_addr = get_tcs_tes_buffer_address_from_reg(ctx, reg, NULL);


	TGSI_FOR_EACH_DST0_ENABLED_CHANNEL(inst, chan_index) {
		LLVMValueRef value = dst[chan_index];

		if (inst->Instruction.Saturate)
			value = radeon_llvm_saturate(bld_base, value);

		lds_store(bld_base, chan_index, dw_addr, value);

		value = LLVMBuildBitCast(gallivm->builder, value, ctx->i32, "");
		values[chan_index] = value;

		if (inst->Dst[0].Register.WriteMask != 0xF) {
			build_tbuffer_store_dwords(ctx, buffer, value, 1,
			                           buf_addr, base,
			                           4 * chan_index);
		}
	}

	if (inst->Dst[0].Register.WriteMask == 0xF) {
		LLVMValueRef value = lp_build_gather_values(bld_base->base.gallivm,
		                                            values, 4);
		build_tbuffer_store_dwords(ctx, buffer, value, 4, buf_addr,
		                           base, 0);
	}
}

static LLVMValueRef fetch_input_gs(
	struct lp_build_tgsi_context *bld_base,
	const struct tgsi_full_src_register *reg,
	enum tgsi_opcode_type type,
	unsigned swizzle)
{
	struct lp_build_context *base = &bld_base->base;
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct si_shader *shader = ctx->shader;
	struct lp_build_context *uint =	&ctx->radeon_bld.soa.bld_base.uint_bld;
	struct gallivm_state *gallivm = base->gallivm;
	LLVMValueRef vtx_offset;
	LLVMValueRef args[9];
	unsigned vtx_offset_param;
	struct tgsi_shader_info *info = &shader->selector->info;
	unsigned semantic_name = info->input_semantic_name[reg->Register.Index];
	unsigned semantic_index = info->input_semantic_index[reg->Register.Index];
	unsigned param;
	LLVMValueRef value;

	if (swizzle != ~0 && semantic_name == TGSI_SEMANTIC_PRIMID)
		return get_primitive_id(bld_base, swizzle);

	if (!reg->Register.Dimension)
		return NULL;

	if (swizzle == ~0) {
		LLVMValueRef values[TGSI_NUM_CHANNELS];
		unsigned chan;
		for (chan = 0; chan < TGSI_NUM_CHANNELS; chan++) {
			values[chan] = fetch_input_gs(bld_base, reg, type, chan);
		}
		return lp_build_gather_values(bld_base->base.gallivm, values,
					      TGSI_NUM_CHANNELS);
	}

	/* Get the vertex offset parameter */
	vtx_offset_param = reg->Dimension.Index;
	if (vtx_offset_param < 2) {
		vtx_offset_param += SI_PARAM_VTX0_OFFSET;
	} else {
		assert(vtx_offset_param < 6);
		vtx_offset_param += SI_PARAM_VTX2_OFFSET - 2;
	}
	vtx_offset = lp_build_mul_imm(uint,
				      LLVMGetParam(ctx->radeon_bld.main_fn,
						   vtx_offset_param),
				      4);

	param = si_shader_io_get_unique_index(semantic_name, semantic_index);
	args[0] = ctx->esgs_ring;
	args[1] = vtx_offset;
	args[2] = lp_build_const_int32(gallivm, (param * 4 + swizzle) * 256);
	args[3] = uint->zero;
	args[4] = uint->one;  /* OFFEN */
	args[5] = uint->zero; /* IDXEN */
	args[6] = uint->one;  /* GLC */
	args[7] = uint->zero; /* SLC */
	args[8] = uint->zero; /* TFE */

	value = lp_build_intrinsic(gallivm->builder,
				   "llvm.SI.buffer.load.dword.i32.i32",
				   ctx->i32, args, 9,
				   LLVMReadOnlyAttribute);
	if (tgsi_type_is_64bit(type)) {
		LLVMValueRef value2;
		args[2] = lp_build_const_int32(gallivm, (param * 4 + swizzle + 1) * 256);
		value2 = lp_build_intrinsic(gallivm->builder,
					    "llvm.SI.buffer.load.dword.i32.i32",
					    ctx->i32, args, 9,
					    LLVMReadOnlyAttribute);
		return radeon_llvm_emit_fetch_64bit(bld_base, type,
						    value, value2);
	}
	return LLVMBuildBitCast(gallivm->builder,
				value,
				tgsi2llvmtype(bld_base, type), "");
}

static int lookup_interp_param_index(unsigned interpolate, unsigned location)
{
	switch (interpolate) {
	case TGSI_INTERPOLATE_CONSTANT:
		return 0;

	case TGSI_INTERPOLATE_LINEAR:
		if (location == TGSI_INTERPOLATE_LOC_SAMPLE)
			return SI_PARAM_LINEAR_SAMPLE;
		else if (location == TGSI_INTERPOLATE_LOC_CENTROID)
			return SI_PARAM_LINEAR_CENTROID;
		else
			return SI_PARAM_LINEAR_CENTER;
		break;
	case TGSI_INTERPOLATE_COLOR:
	case TGSI_INTERPOLATE_PERSPECTIVE:
		if (location == TGSI_INTERPOLATE_LOC_SAMPLE)
			return SI_PARAM_PERSP_SAMPLE;
		else if (location == TGSI_INTERPOLATE_LOC_CENTROID)
			return SI_PARAM_PERSP_CENTROID;
		else
			return SI_PARAM_PERSP_CENTER;
		break;
	default:
		fprintf(stderr, "Warning: Unhandled interpolation mode.\n");
		return -1;
	}
}

/* This shouldn't be used by explicit INTERP opcodes. */
static unsigned select_interp_param(struct si_shader_context *ctx,
				    unsigned param)
{
	if (!ctx->is_monolithic)
		return param;

	if (ctx->shader->key.ps.prolog.force_persp_sample_interp) {
		switch (param) {
		case SI_PARAM_PERSP_CENTROID:
		case SI_PARAM_PERSP_CENTER:
			return SI_PARAM_PERSP_SAMPLE;
		}
	}
	if (ctx->shader->key.ps.prolog.force_linear_sample_interp) {
		switch (param) {
		case SI_PARAM_LINEAR_CENTROID:
		case SI_PARAM_LINEAR_CENTER:
			return SI_PARAM_LINEAR_SAMPLE;
		}
	}
	if (ctx->shader->key.ps.prolog.force_persp_center_interp) {
		switch (param) {
		case SI_PARAM_PERSP_CENTROID:
		case SI_PARAM_PERSP_SAMPLE:
			return SI_PARAM_PERSP_CENTER;
		}
	}
	if (ctx->shader->key.ps.prolog.force_linear_center_interp) {
		switch (param) {
		case SI_PARAM_LINEAR_CENTROID:
		case SI_PARAM_LINEAR_SAMPLE:
			return SI_PARAM_LINEAR_CENTER;
		}
	}

	return param;
}

/**
 * Interpolate a fragment shader input.
 *
 * @param ctx		context
 * @param input_index		index of the input in hardware
 * @param semantic_name		TGSI_SEMANTIC_*
 * @param semantic_index	semantic index
 * @param num_interp_inputs	number of all interpolated inputs (= BCOLOR offset)
 * @param colors_read_mask	color components read (4 bits for each color, 8 bits in total)
 * @param interp_param		interpolation weights (i,j)
 * @param prim_mask		SI_PARAM_PRIM_MASK
 * @param face			SI_PARAM_FRONT_FACE
 * @param result		the return value (4 components)
 */
static void interp_fs_input(struct si_shader_context *ctx,
			    unsigned input_index,
			    unsigned semantic_name,
			    unsigned semantic_index,
			    unsigned num_interp_inputs,
			    unsigned colors_read_mask,
			    LLVMValueRef interp_param,
			    LLVMValueRef prim_mask,
			    LLVMValueRef face,
			    LLVMValueRef result[4])
{
	struct lp_build_context *base = &ctx->radeon_bld.soa.bld_base.base;
	struct lp_build_context *uint =	&ctx->radeon_bld.soa.bld_base.uint_bld;
	struct gallivm_state *gallivm = base->gallivm;
	const char *intr_name;
	LLVMValueRef attr_number;

	unsigned chan;

	attr_number = lp_build_const_int32(gallivm, input_index);

	/* fs.constant returns the param from the middle vertex, so it's not
	 * really useful for flat shading. It's meant to be used for custom
	 * interpolation (but the intrinsic can't fetch from the other two
	 * vertices).
	 *
	 * Luckily, it doesn't matter, because we rely on the FLAT_SHADE state
	 * to do the right thing. The only reason we use fs.constant is that
	 * fs.interp cannot be used on integers, because they can be equal
	 * to NaN.
	 */
	intr_name = interp_param ? "llvm.SI.fs.interp" : "llvm.SI.fs.constant";

	if (semantic_name == TGSI_SEMANTIC_COLOR &&
	    ctx->shader->key.ps.prolog.color_two_side) {
		LLVMValueRef args[4];
		LLVMValueRef is_face_positive;
		LLVMValueRef back_attr_number;

		/* If BCOLOR0 is used, BCOLOR1 is at offset "num_inputs + 1",
		 * otherwise it's at offset "num_inputs".
		 */
		unsigned back_attr_offset = num_interp_inputs;
		if (semantic_index == 1 && colors_read_mask & 0xf)
			back_attr_offset += 1;

		back_attr_number = lp_build_const_int32(gallivm, back_attr_offset);

		is_face_positive = LLVMBuildICmp(gallivm->builder, LLVMIntNE,
						 face, uint->zero, "");

		args[2] = prim_mask;
		args[3] = interp_param;
		for (chan = 0; chan < TGSI_NUM_CHANNELS; chan++) {
			LLVMValueRef llvm_chan = lp_build_const_int32(gallivm, chan);
			LLVMValueRef front, back;

			args[0] = llvm_chan;
			args[1] = attr_number;
			front = lp_build_intrinsic(gallivm->builder, intr_name,
						ctx->f32, args, args[3] ? 4 : 3,
						LLVMReadNoneAttribute);

			args[1] = back_attr_number;
			back = lp_build_intrinsic(gallivm->builder, intr_name,
					       ctx->f32, args, args[3] ? 4 : 3,
					       LLVMReadNoneAttribute);

			result[chan] = LLVMBuildSelect(gallivm->builder,
						is_face_positive,
						front,
						back,
						"");
		}
	} else if (semantic_name == TGSI_SEMANTIC_FOG) {
		LLVMValueRef args[4];

		args[0] = uint->zero;
		args[1] = attr_number;
		args[2] = prim_mask;
		args[3] = interp_param;
		result[0] = lp_build_intrinsic(gallivm->builder, intr_name,
					ctx->f32, args, args[3] ? 4 : 3,
					LLVMReadNoneAttribute);
		result[1] =
		result[2] = lp_build_const_float(gallivm, 0.0f);
		result[3] = lp_build_const_float(gallivm, 1.0f);
	} else {
		for (chan = 0; chan < TGSI_NUM_CHANNELS; chan++) {
			LLVMValueRef args[4];
			LLVMValueRef llvm_chan = lp_build_const_int32(gallivm, chan);

			args[0] = llvm_chan;
			args[1] = attr_number;
			args[2] = prim_mask;
			args[3] = interp_param;
			result[chan] = lp_build_intrinsic(gallivm->builder, intr_name,
						ctx->f32, args, args[3] ? 4 : 3,
						LLVMReadNoneAttribute);
		}
	}
}

/* LLVMGetParam with bc_optimize resolved. */
static LLVMValueRef get_interp_param(struct si_shader_context *ctx,
				     int interp_param_idx)
{
	LLVMBuilderRef builder = ctx->radeon_bld.gallivm.builder;
	LLVMValueRef main_fn = ctx->radeon_bld.main_fn;
	LLVMValueRef param = NULL;

	/* Handle PRIM_MASK[31] (bc_optimize). */
	if (ctx->is_monolithic &&
	    ((ctx->shader->key.ps.prolog.bc_optimize_for_persp &&
	      interp_param_idx == SI_PARAM_PERSP_CENTROID) ||
	     (ctx->shader->key.ps.prolog.bc_optimize_for_linear &&
	      interp_param_idx == SI_PARAM_LINEAR_CENTROID))) {
		/* The shader should do: if (PRIM_MASK[31]) CENTROID = CENTER;
		 * The hw doesn't compute CENTROID if the whole wave only
		 * contains fully-covered quads.
		 */
		LLVMValueRef bc_optimize =
			LLVMGetParam(main_fn, SI_PARAM_PRIM_MASK);
		bc_optimize = LLVMBuildLShr(builder,
					    bc_optimize,
					    LLVMConstInt(ctx->i32, 31, 0), "");
		bc_optimize = LLVMBuildTrunc(builder, bc_optimize, ctx->i1, "");

		if (ctx->shader->key.ps.prolog.bc_optimize_for_persp &&
		    interp_param_idx == SI_PARAM_PERSP_CENTROID) {
			param = LLVMBuildSelect(builder, bc_optimize,
						LLVMGetParam(main_fn,
							     SI_PARAM_PERSP_CENTER),
						LLVMGetParam(main_fn,
							     SI_PARAM_PERSP_CENTROID),
						"");
		}
		if (ctx->shader->key.ps.prolog.bc_optimize_for_linear &&
		    interp_param_idx == SI_PARAM_LINEAR_CENTROID) {
			param = LLVMBuildSelect(builder, bc_optimize,
						LLVMGetParam(main_fn,
							     SI_PARAM_LINEAR_CENTER),
						LLVMGetParam(main_fn,
							     SI_PARAM_LINEAR_CENTROID),
						"");
		}
	}

	if (!param)
		param = LLVMGetParam(main_fn, interp_param_idx);
	return param;
}

static void declare_input_fs(
	struct radeon_llvm_context *radeon_bld,
	unsigned input_index,
	const struct tgsi_full_declaration *decl)
{
	struct lp_build_context *base = &radeon_bld->soa.bld_base.base;
	struct si_shader_context *ctx =
		si_shader_context(&radeon_bld->soa.bld_base);
	struct si_shader *shader = ctx->shader;
	LLVMValueRef main_fn = radeon_bld->main_fn;
	LLVMValueRef interp_param = NULL;
	int interp_param_idx;

	/* Get colors from input VGPRs (set by the prolog). */
	if (!ctx->is_monolithic &&
	    decl->Semantic.Name == TGSI_SEMANTIC_COLOR) {
		unsigned i = decl->Semantic.Index;
		unsigned colors_read = shader->selector->info.colors_read;
		unsigned mask = colors_read >> (i * 4);
		unsigned offset = SI_PARAM_POS_FIXED_PT + 1 +
				  (i ? util_bitcount(colors_read & 0xf) : 0);

		radeon_bld->inputs[radeon_llvm_reg_index_soa(input_index, 0)] =
			mask & 0x1 ? LLVMGetParam(main_fn, offset++) : base->undef;
		radeon_bld->inputs[radeon_llvm_reg_index_soa(input_index, 1)] =
			mask & 0x2 ? LLVMGetParam(main_fn, offset++) : base->undef;
		radeon_bld->inputs[radeon_llvm_reg_index_soa(input_index, 2)] =
			mask & 0x4 ? LLVMGetParam(main_fn, offset++) : base->undef;
		radeon_bld->inputs[radeon_llvm_reg_index_soa(input_index, 3)] =
			mask & 0x8 ? LLVMGetParam(main_fn, offset++) : base->undef;
		return;
	}

	interp_param_idx = lookup_interp_param_index(decl->Interp.Interpolate,
						     decl->Interp.Location);
	if (interp_param_idx == -1)
		return;
	else if (interp_param_idx) {
		interp_param_idx = select_interp_param(ctx,
						       interp_param_idx);
		interp_param = get_interp_param(ctx, interp_param_idx);
	}

	if (decl->Semantic.Name == TGSI_SEMANTIC_COLOR &&
	    decl->Interp.Interpolate == TGSI_INTERPOLATE_COLOR &&
	    ctx->shader->key.ps.prolog.flatshade_colors)
		interp_param = NULL; /* load the constant color */

	interp_fs_input(ctx, input_index, decl->Semantic.Name,
			decl->Semantic.Index, shader->selector->info.num_inputs,
			shader->selector->info.colors_read, interp_param,
			LLVMGetParam(main_fn, SI_PARAM_PRIM_MASK),
			LLVMGetParam(main_fn, SI_PARAM_FRONT_FACE),
			&radeon_bld->inputs[radeon_llvm_reg_index_soa(input_index, 0)]);
}

static LLVMValueRef get_sample_id(struct radeon_llvm_context *radeon_bld)
{
	return unpack_param(si_shader_context(&radeon_bld->soa.bld_base),
			    SI_PARAM_ANCILLARY, 8, 4);
}

/**
 * Set range metadata on an instruction.  This can only be used on load and
 * call instructions.  If you know an instruction can only produce the values
 * 0, 1, 2, you would do set_range_metadata(value, 0, 3);
 * \p lo is the minimum value inclusive.
 * \p hi is the maximum value exclusive.
 */
static void set_range_metadata(struct si_shader_context *ctx,
			       LLVMValueRef value, unsigned lo, unsigned hi)
{
	LLVMValueRef range_md, md_args[2];
	LLVMTypeRef type = LLVMTypeOf(value);
	LLVMContextRef context = LLVMGetTypeContext(type);

	md_args[0] = LLVMConstInt(type, lo, false);
	md_args[1] = LLVMConstInt(type, hi, false);
	range_md = LLVMMDNodeInContext(context, md_args, 2);
	LLVMSetMetadata(value, ctx->range_md_kind, range_md);
}

static LLVMValueRef get_thread_id(struct si_shader_context *ctx)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMValueRef tid;

	if (HAVE_LLVM < 0x0308) {
		tid = lp_build_intrinsic(gallivm->builder, "llvm.SI.tid",
				ctx->i32,   NULL, 0, LLVMReadNoneAttribute);
	} else {
		LLVMValueRef tid_args[2];
		tid_args[0] = lp_build_const_int32(gallivm, 0xffffffff);
		tid_args[1] = lp_build_const_int32(gallivm, 0);
		tid_args[1] = lp_build_intrinsic(gallivm->builder,
					"llvm.amdgcn.mbcnt.lo", ctx->i32,
					tid_args, 2, LLVMReadNoneAttribute);

		tid = lp_build_intrinsic(gallivm->builder,
					"llvm.amdgcn.mbcnt.hi", ctx->i32,
					tid_args, 2, LLVMReadNoneAttribute);
	}
	set_range_metadata(ctx, tid, 0, 64);
	return tid;
}

/**
 * Load a dword from a constant buffer.
 */
static LLVMValueRef buffer_load_const(struct si_shader_context *ctx,
				      LLVMValueRef resource,
				      LLVMValueRef offset)
{
	LLVMBuilderRef builder = ctx->radeon_bld.gallivm.builder;
	LLVMValueRef args[2] = {resource, offset};

	return lp_build_intrinsic(builder, "llvm.SI.load.const", ctx->f32, args, 2,
			       LLVMReadNoneAttribute);
}

static LLVMValueRef load_sample_position(struct radeon_llvm_context *radeon_bld, LLVMValueRef sample_id)
{
	struct si_shader_context *ctx =
		si_shader_context(&radeon_bld->soa.bld_base);
	struct lp_build_context *uint_bld = &radeon_bld->soa.bld_base.uint_bld;
	struct gallivm_state *gallivm = &radeon_bld->gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	LLVMValueRef desc = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_RW_BUFFERS);
	LLVMValueRef buf_index = lp_build_const_int32(gallivm, SI_PS_CONST_SAMPLE_POSITIONS);
	LLVMValueRef resource = build_indexed_load_const(ctx, desc, buf_index);

	/* offset = sample_id * 8  (8 = 2 floats containing samplepos.xy) */
	LLVMValueRef offset0 = lp_build_mul_imm(uint_bld, sample_id, 8);
	LLVMValueRef offset1 = LLVMBuildAdd(builder, offset0, lp_build_const_int32(gallivm, 4), "");

	LLVMValueRef pos[4] = {
		buffer_load_const(ctx, resource, offset0),
		buffer_load_const(ctx, resource, offset1),
		lp_build_const_float(gallivm, 0),
		lp_build_const_float(gallivm, 0)
	};

	return lp_build_gather_values(gallivm, pos, 4);
}

static void declare_system_value(
	struct radeon_llvm_context *radeon_bld,
	unsigned index,
	const struct tgsi_full_declaration *decl)
{
	struct si_shader_context *ctx =
		si_shader_context(&radeon_bld->soa.bld_base);
	struct lp_build_context *bld = &radeon_bld->soa.bld_base.base;
	struct gallivm_state *gallivm = &radeon_bld->gallivm;
	LLVMValueRef value = 0;

	switch (decl->Semantic.Name) {
	case TGSI_SEMANTIC_INSTANCEID:
		value = LLVMGetParam(radeon_bld->main_fn,
				     ctx->param_instance_id);
		break;

	case TGSI_SEMANTIC_VERTEXID:
		value = LLVMBuildAdd(gallivm->builder,
				     LLVMGetParam(radeon_bld->main_fn,
						  ctx->param_vertex_id),
				     LLVMGetParam(radeon_bld->main_fn,
						  SI_PARAM_BASE_VERTEX), "");
		break;

	case TGSI_SEMANTIC_VERTEXID_NOBASE:
		value = LLVMGetParam(radeon_bld->main_fn,
				     ctx->param_vertex_id);
		break;

	case TGSI_SEMANTIC_BASEVERTEX:
		value = LLVMGetParam(radeon_bld->main_fn,
				     SI_PARAM_BASE_VERTEX);
		break;

	case TGSI_SEMANTIC_BASEINSTANCE:
		value = LLVMGetParam(radeon_bld->main_fn,
				     SI_PARAM_START_INSTANCE);
		break;

	case TGSI_SEMANTIC_DRAWID:
		value = LLVMGetParam(radeon_bld->main_fn,
				     SI_PARAM_DRAWID);
		break;

	case TGSI_SEMANTIC_INVOCATIONID:
		if (ctx->type == PIPE_SHADER_TESS_CTRL)
			value = unpack_param(ctx, SI_PARAM_REL_IDS, 8, 5);
		else if (ctx->type == PIPE_SHADER_GEOMETRY)
			value = LLVMGetParam(radeon_bld->main_fn,
					     SI_PARAM_GS_INSTANCE_ID);
		else
			assert(!"INVOCATIONID not implemented");
		break;

	case TGSI_SEMANTIC_POSITION:
	{
		LLVMValueRef pos[4] = {
			LLVMGetParam(radeon_bld->main_fn, SI_PARAM_POS_X_FLOAT),
			LLVMGetParam(radeon_bld->main_fn, SI_PARAM_POS_Y_FLOAT),
			LLVMGetParam(radeon_bld->main_fn, SI_PARAM_POS_Z_FLOAT),
			lp_build_emit_llvm_unary(&radeon_bld->soa.bld_base, TGSI_OPCODE_RCP,
						 LLVMGetParam(radeon_bld->main_fn,
							      SI_PARAM_POS_W_FLOAT)),
		};
		value = lp_build_gather_values(gallivm, pos, 4);
		break;
	}

	case TGSI_SEMANTIC_FACE:
		value = LLVMGetParam(radeon_bld->main_fn, SI_PARAM_FRONT_FACE);
		break;

	case TGSI_SEMANTIC_SAMPLEID:
		value = get_sample_id(radeon_bld);
		break;

	case TGSI_SEMANTIC_SAMPLEPOS: {
		LLVMValueRef pos[4] = {
			LLVMGetParam(radeon_bld->main_fn, SI_PARAM_POS_X_FLOAT),
			LLVMGetParam(radeon_bld->main_fn, SI_PARAM_POS_Y_FLOAT),
			lp_build_const_float(gallivm, 0),
			lp_build_const_float(gallivm, 0)
		};
		pos[0] = lp_build_emit_llvm_unary(&radeon_bld->soa.bld_base,
						  TGSI_OPCODE_FRC, pos[0]);
		pos[1] = lp_build_emit_llvm_unary(&radeon_bld->soa.bld_base,
						  TGSI_OPCODE_FRC, pos[1]);
		value = lp_build_gather_values(gallivm, pos, 4);
		break;
	}

	case TGSI_SEMANTIC_SAMPLEMASK:
		/* This can only occur with the OpenGL Core profile, which
		 * doesn't support smoothing.
		 */
		value = LLVMGetParam(radeon_bld->main_fn, SI_PARAM_SAMPLE_COVERAGE);
		break;

	case TGSI_SEMANTIC_TESSCOORD:
	{
		LLVMValueRef coord[4] = {
			LLVMGetParam(radeon_bld->main_fn, ctx->param_tes_u),
			LLVMGetParam(radeon_bld->main_fn, ctx->param_tes_v),
			bld->zero,
			bld->zero
		};

		/* For triangles, the vector should be (u, v, 1-u-v). */
		if (ctx->shader->selector->info.properties[TGSI_PROPERTY_TES_PRIM_MODE] ==
		    PIPE_PRIM_TRIANGLES)
			coord[2] = lp_build_sub(bld, bld->one,
						lp_build_add(bld, coord[0], coord[1]));

		value = lp_build_gather_values(gallivm, coord, 4);
		break;
	}

	case TGSI_SEMANTIC_VERTICESIN:
		value = unpack_param(ctx, SI_PARAM_TCS_OUT_LAYOUT, 26, 6);
		break;

	case TGSI_SEMANTIC_TESSINNER:
	case TGSI_SEMANTIC_TESSOUTER:
	{
		LLVMValueRef rw_buffers, buffer, base, addr;
		int param = si_shader_io_get_unique_index(decl->Semantic.Name, 0);

		rw_buffers = LLVMGetParam(ctx->radeon_bld.main_fn,
					SI_PARAM_RW_BUFFERS);
		buffer = build_indexed_load_const(ctx, rw_buffers,
		        lp_build_const_int32(gallivm, SI_HS_RING_TESS_OFFCHIP));

		base = LLVMGetParam(ctx->radeon_bld.main_fn, ctx->param_oc_lds);
		addr = get_tcs_tes_buffer_address(ctx, NULL,
		                          lp_build_const_int32(gallivm, param));

		value = buffer_load(&radeon_bld->soa.bld_base, TGSI_TYPE_FLOAT,
		                    ~0, buffer, base, addr);

		break;
	}

	case TGSI_SEMANTIC_DEFAULT_TESSOUTER_SI:
	case TGSI_SEMANTIC_DEFAULT_TESSINNER_SI:
	{
		LLVMValueRef buf, slot, val[4];
		int i, offset;

		slot = lp_build_const_int32(gallivm, SI_HS_CONST_DEFAULT_TESS_LEVELS);
		buf = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_RW_BUFFERS);
		buf = build_indexed_load_const(ctx, buf, slot);
		offset = decl->Semantic.Name == TGSI_SEMANTIC_DEFAULT_TESSINNER_SI ? 4 : 0;

		for (i = 0; i < 4; i++)
			val[i] = buffer_load_const(ctx, buf,
						   lp_build_const_int32(gallivm, (offset + i) * 4));
		value = lp_build_gather_values(gallivm, val, 4);
		break;
	}

	case TGSI_SEMANTIC_PRIMID:
		value = get_primitive_id(&radeon_bld->soa.bld_base, 0);
		break;

	case TGSI_SEMANTIC_GRID_SIZE:
		value = LLVMGetParam(radeon_bld->main_fn, SI_PARAM_GRID_SIZE);
		break;

	case TGSI_SEMANTIC_BLOCK_SIZE:
	{
		LLVMValueRef values[3];
		unsigned i;
		unsigned *properties = ctx->shader->selector->info.properties;
		unsigned sizes[3] = {
			properties[TGSI_PROPERTY_CS_FIXED_BLOCK_WIDTH],
			properties[TGSI_PROPERTY_CS_FIXED_BLOCK_HEIGHT],
			properties[TGSI_PROPERTY_CS_FIXED_BLOCK_DEPTH]
		};

		for (i = 0; i < 3; ++i)
			values[i] = lp_build_const_int32(gallivm, sizes[i]);

		value = lp_build_gather_values(gallivm, values, 3);
		break;
	}

	case TGSI_SEMANTIC_BLOCK_ID:
		value = LLVMGetParam(radeon_bld->main_fn, SI_PARAM_BLOCK_ID);
		break;

	case TGSI_SEMANTIC_THREAD_ID:
		value = LLVMGetParam(radeon_bld->main_fn, SI_PARAM_THREAD_ID);
		break;

#if HAVE_LLVM >= 0x0309
	case TGSI_SEMANTIC_HELPER_INVOCATION:
		value = lp_build_intrinsic(gallivm->builder,
					   "llvm.amdgcn.ps.live",
					   ctx->i1, NULL, 0,
					   LLVMReadNoneAttribute);
		value = LLVMBuildNot(gallivm->builder, value, "");
		value = LLVMBuildSExt(gallivm->builder, value, ctx->i32, "");
		break;
#endif

	default:
		assert(!"unknown system value");
		return;
	}

	radeon_bld->system_values[index] = value;
}

static void declare_compute_memory(struct radeon_llvm_context *radeon_bld,
                                   const struct tgsi_full_declaration *decl)
{
	struct si_shader_context *ctx =
		si_shader_context(&radeon_bld->soa.bld_base);
	struct si_shader_selector *sel = ctx->shader->selector;
	struct gallivm_state *gallivm = &radeon_bld->gallivm;

	LLVMTypeRef i8p = LLVMPointerType(ctx->i8, LOCAL_ADDR_SPACE);
	LLVMValueRef var;

	assert(decl->Declaration.MemType == TGSI_MEMORY_TYPE_SHARED);
	assert(decl->Range.First == decl->Range.Last);
	assert(!ctx->shared_memory);

	var = LLVMAddGlobalInAddressSpace(gallivm->module,
	                                  LLVMArrayType(ctx->i8, sel->local_size),
	                                  "compute_lds",
	                                  LOCAL_ADDR_SPACE);
	LLVMSetAlignment(var, 4);

	ctx->shared_memory = LLVMBuildBitCast(gallivm->builder, var, i8p, "");
}

static LLVMValueRef fetch_constant(
	struct lp_build_tgsi_context *bld_base,
	const struct tgsi_full_src_register *reg,
	enum tgsi_opcode_type type,
	unsigned swizzle)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct lp_build_context *base = &bld_base->base;
	const struct tgsi_ind_register *ireg = &reg->Indirect;
	unsigned buf, idx;

	LLVMValueRef addr, bufp;
	LLVMValueRef result;

	if (swizzle == LP_CHAN_ALL) {
		unsigned chan;
		LLVMValueRef values[4];
		for (chan = 0; chan < TGSI_NUM_CHANNELS; ++chan)
			values[chan] = fetch_constant(bld_base, reg, type, chan);

		return lp_build_gather_values(bld_base->base.gallivm, values, 4);
	}

	buf = reg->Register.Dimension ? reg->Dimension.Index : 0;
	idx = reg->Register.Index * 4 + swizzle;

	if (!reg->Register.Indirect && !reg->Dimension.Indirect) {
		if (!tgsi_type_is_64bit(type))
			return bitcast(bld_base, type, ctx->constants[buf][idx]);
		else {
			return radeon_llvm_emit_fetch_64bit(bld_base, type,
							    ctx->constants[buf][idx],
							    ctx->constants[buf][idx + 1]);
		}
	}

	if (reg->Register.Dimension && reg->Dimension.Indirect) {
		LLVMValueRef ptr = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_CONST_BUFFERS);
		LLVMValueRef index;
		index = get_bounded_indirect_index(ctx, &reg->DimIndirect,
						   reg->Dimension.Index,
						   SI_NUM_CONST_BUFFERS);
		bufp = build_indexed_load_const(ctx, ptr, index);
	} else
		bufp = ctx->const_buffers[buf];

	addr = ctx->radeon_bld.soa.addr[ireg->Index][ireg->Swizzle];
	addr = LLVMBuildLoad(base->gallivm->builder, addr, "load addr reg");
	addr = lp_build_mul_imm(&bld_base->uint_bld, addr, 16);
	addr = lp_build_add(&bld_base->uint_bld, addr,
			    lp_build_const_int32(base->gallivm, idx * 4));

	result = buffer_load_const(ctx, bufp, addr);

	if (!tgsi_type_is_64bit(type))
		result = bitcast(bld_base, type, result);
	else {
		LLVMValueRef addr2, result2;
		addr2 = ctx->radeon_bld.soa.addr[ireg->Index][ireg->Swizzle + 1];
		addr2 = LLVMBuildLoad(base->gallivm->builder, addr2, "load addr reg2");
		addr2 = lp_build_mul_imm(&bld_base->uint_bld, addr2, 16);
		addr2 = lp_build_add(&bld_base->uint_bld, addr2,
				     lp_build_const_int32(base->gallivm, idx * 4));

		result2 = buffer_load_const(ctx, ctx->const_buffers[buf],
					    addr2);

		result = radeon_llvm_emit_fetch_64bit(bld_base, type,
						      result, result2);
	}
	return result;
}

/* Upper 16 bits must be zero. */
static LLVMValueRef si_llvm_pack_two_int16(struct gallivm_state *gallivm,
					   LLVMValueRef val[2])
{
	return LLVMBuildOr(gallivm->builder, val[0],
			   LLVMBuildShl(gallivm->builder, val[1],
					lp_build_const_int32(gallivm, 16),
					""), "");
}

/* Upper 16 bits are ignored and will be dropped. */
static LLVMValueRef si_llvm_pack_two_int32_as_int16(struct gallivm_state *gallivm,
						    LLVMValueRef val[2])
{
	LLVMValueRef v[2] = {
		LLVMBuildAnd(gallivm->builder, val[0],
			     lp_build_const_int32(gallivm, 0xffff), ""),
		val[1],
	};
	return si_llvm_pack_two_int16(gallivm, v);
}

/* Initialize arguments for the shader export intrinsic */
static void si_llvm_init_export_args(struct lp_build_tgsi_context *bld_base,
				     LLVMValueRef *values,
				     unsigned target,
				     LLVMValueRef *args)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct lp_build_context *uint =
				&ctx->radeon_bld.soa.bld_base.uint_bld;
	struct lp_build_context *base = &bld_base->base;
	struct gallivm_state *gallivm = base->gallivm;
	LLVMBuilderRef builder = base->gallivm->builder;
	LLVMValueRef val[4];
	unsigned spi_shader_col_format = V_028714_SPI_SHADER_32_ABGR;
	unsigned chan;
	bool is_int8;

	/* Default is 0xf. Adjusted below depending on the format. */
	args[0] = lp_build_const_int32(base->gallivm, 0xf); /* writemask */

	/* Specify whether the EXEC mask represents the valid mask */
	args[1] = uint->zero;

	/* Specify whether this is the last export */
	args[2] = uint->zero;

	/* Specify the target we are exporting */
	args[3] = lp_build_const_int32(base->gallivm, target);

	if (ctx->type == PIPE_SHADER_FRAGMENT) {
		const union si_shader_key *key = &ctx->shader->key;
		unsigned col_formats = key->ps.epilog.spi_shader_col_format;
		int cbuf = target - V_008DFC_SQ_EXP_MRT;

		assert(cbuf >= 0 && cbuf < 8);
		spi_shader_col_format = (col_formats >> (cbuf * 4)) & 0xf;
		is_int8 = (key->ps.epilog.color_is_int8 >> cbuf) & 0x1;
	}

	args[4] = uint->zero; /* COMPR flag */
	args[5] = base->undef;
	args[6] = base->undef;
	args[7] = base->undef;
	args[8] = base->undef;

	switch (spi_shader_col_format) {
	case V_028714_SPI_SHADER_ZERO:
		args[0] = uint->zero; /* writemask */
		args[3] = lp_build_const_int32(base->gallivm, V_008DFC_SQ_EXP_NULL);
		break;

	case V_028714_SPI_SHADER_32_R:
		args[0] = uint->one; /* writemask */
		args[5] = values[0];
		break;

	case V_028714_SPI_SHADER_32_GR:
		args[0] = lp_build_const_int32(base->gallivm, 0x3); /* writemask */
		args[5] = values[0];
		args[6] = values[1];
		break;

	case V_028714_SPI_SHADER_32_AR:
		args[0] = lp_build_const_int32(base->gallivm, 0x9); /* writemask */
		args[5] = values[0];
		args[8] = values[3];
		break;

	case V_028714_SPI_SHADER_FP16_ABGR:
		args[4] = uint->one; /* COMPR flag */

		for (chan = 0; chan < 2; chan++) {
			LLVMValueRef pack_args[2] = {
				values[2 * chan],
				values[2 * chan + 1]
			};
			LLVMValueRef packed;

			packed = lp_build_intrinsic(base->gallivm->builder,
						    "llvm.SI.packf16",
						    ctx->i32, pack_args, 2,
						    LLVMReadNoneAttribute);
			args[chan + 5] =
				LLVMBuildBitCast(base->gallivm->builder,
						 packed, ctx->f32, "");
		}
		break;

	case V_028714_SPI_SHADER_UNORM16_ABGR:
		for (chan = 0; chan < 4; chan++) {
			val[chan] = radeon_llvm_saturate(bld_base, values[chan]);
			val[chan] = LLVMBuildFMul(builder, val[chan],
						  lp_build_const_float(gallivm, 65535), "");
			val[chan] = LLVMBuildFAdd(builder, val[chan],
						  lp_build_const_float(gallivm, 0.5), "");
			val[chan] = LLVMBuildFPToUI(builder, val[chan],
						    ctx->i32, "");
		}

		args[4] = uint->one; /* COMPR flag */
		args[5] = bitcast(bld_base, TGSI_TYPE_FLOAT,
				  si_llvm_pack_two_int16(gallivm, val));
		args[6] = bitcast(bld_base, TGSI_TYPE_FLOAT,
				  si_llvm_pack_two_int16(gallivm, val+2));
		break;

	case V_028714_SPI_SHADER_SNORM16_ABGR:
		for (chan = 0; chan < 4; chan++) {
			/* Clamp between [-1, 1]. */
			val[chan] = lp_build_emit_llvm_binary(bld_base, TGSI_OPCODE_MIN,
							      values[chan],
							      lp_build_const_float(gallivm, 1));
			val[chan] = lp_build_emit_llvm_binary(bld_base, TGSI_OPCODE_MAX,
							      val[chan],
							      lp_build_const_float(gallivm, -1));
			/* Convert to a signed integer in [-32767, 32767]. */
			val[chan] = LLVMBuildFMul(builder, val[chan],
						  lp_build_const_float(gallivm, 32767), "");
			/* If positive, add 0.5, else add -0.5. */
			val[chan] = LLVMBuildFAdd(builder, val[chan],
					LLVMBuildSelect(builder,
						LLVMBuildFCmp(builder, LLVMRealOGE,
							      val[chan], base->zero, ""),
						lp_build_const_float(gallivm, 0.5),
						lp_build_const_float(gallivm, -0.5), ""), "");
			val[chan] = LLVMBuildFPToSI(builder, val[chan], ctx->i32, "");
		}

		args[4] = uint->one; /* COMPR flag */
		args[5] = bitcast(bld_base, TGSI_TYPE_FLOAT,
				  si_llvm_pack_two_int32_as_int16(gallivm, val));
		args[6] = bitcast(bld_base, TGSI_TYPE_FLOAT,
				  si_llvm_pack_two_int32_as_int16(gallivm, val+2));
		break;

	case V_028714_SPI_SHADER_UINT16_ABGR: {
		LLVMValueRef max = lp_build_const_int32(gallivm, is_int8 ?
							255 : 65535);
		/* Clamp. */
		for (chan = 0; chan < 4; chan++) {
			val[chan] = bitcast(bld_base, TGSI_TYPE_UNSIGNED, values[chan]);
			val[chan] = lp_build_emit_llvm_binary(bld_base, TGSI_OPCODE_UMIN,
							      val[chan], max);
		}

		args[4] = uint->one; /* COMPR flag */
		args[5] = bitcast(bld_base, TGSI_TYPE_FLOAT,
				  si_llvm_pack_two_int16(gallivm, val));
		args[6] = bitcast(bld_base, TGSI_TYPE_FLOAT,
				  si_llvm_pack_two_int16(gallivm, val+2));
		break;
	}

	case V_028714_SPI_SHADER_SINT16_ABGR: {
		LLVMValueRef max = lp_build_const_int32(gallivm, is_int8 ?
							127 : 32767);
		LLVMValueRef min = lp_build_const_int32(gallivm, is_int8 ?
							-128 : -32768);
		/* Clamp. */
		for (chan = 0; chan < 4; chan++) {
			val[chan] = bitcast(bld_base, TGSI_TYPE_UNSIGNED, values[chan]);
			val[chan] = lp_build_emit_llvm_binary(bld_base,
							      TGSI_OPCODE_IMIN,
							      val[chan], max);
			val[chan] = lp_build_emit_llvm_binary(bld_base,
							      TGSI_OPCODE_IMAX,
							      val[chan], min);
		}

		args[4] = uint->one; /* COMPR flag */
		args[5] = bitcast(bld_base, TGSI_TYPE_FLOAT,
				  si_llvm_pack_two_int32_as_int16(gallivm, val));
		args[6] = bitcast(bld_base, TGSI_TYPE_FLOAT,
				  si_llvm_pack_two_int32_as_int16(gallivm, val+2));
		break;
	}

	case V_028714_SPI_SHADER_32_ABGR:
		memcpy(&args[5], values, sizeof(values[0]) * 4);
		break;
	}
}

static void si_alpha_test(struct lp_build_tgsi_context *bld_base,
			  LLVMValueRef alpha)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;

	if (ctx->shader->key.ps.epilog.alpha_func != PIPE_FUNC_NEVER) {
		LLVMValueRef alpha_ref = LLVMGetParam(ctx->radeon_bld.main_fn,
				SI_PARAM_ALPHA_REF);

		LLVMValueRef alpha_pass =
			lp_build_cmp(&bld_base->base,
				     ctx->shader->key.ps.epilog.alpha_func,
				     alpha, alpha_ref);
		LLVMValueRef arg =
			lp_build_select(&bld_base->base,
					alpha_pass,
					lp_build_const_float(gallivm, 1.0f),
					lp_build_const_float(gallivm, -1.0f));

		lp_build_intrinsic(gallivm->builder, "llvm.AMDGPU.kill",
				   ctx->voidt, &arg, 1, 0);
	} else {
		lp_build_intrinsic(gallivm->builder, "llvm.AMDGPU.kilp",
				   ctx->voidt, NULL, 0, 0);
	}
}

static LLVMValueRef si_scale_alpha_by_sample_mask(struct lp_build_tgsi_context *bld_base,
						  LLVMValueRef alpha,
						  unsigned samplemask_param)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef coverage;

	/* alpha = alpha * popcount(coverage) / SI_NUM_SMOOTH_AA_SAMPLES */
	coverage = LLVMGetParam(ctx->radeon_bld.main_fn,
				samplemask_param);
	coverage = bitcast(bld_base, TGSI_TYPE_SIGNED, coverage);

	coverage = lp_build_intrinsic(gallivm->builder, "llvm.ctpop.i32",
				   ctx->i32,
				   &coverage, 1, LLVMReadNoneAttribute);

	coverage = LLVMBuildUIToFP(gallivm->builder, coverage,
				   ctx->f32, "");

	coverage = LLVMBuildFMul(gallivm->builder, coverage,
				 lp_build_const_float(gallivm,
					1.0 / SI_NUM_SMOOTH_AA_SAMPLES), "");

	return LLVMBuildFMul(gallivm->builder, alpha, coverage, "");
}

static void si_llvm_emit_clipvertex(struct lp_build_tgsi_context *bld_base,
				    LLVMValueRef (*pos)[9], LLVMValueRef *out_elts)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct lp_build_context *base = &bld_base->base;
	struct lp_build_context *uint = &ctx->radeon_bld.soa.bld_base.uint_bld;
	unsigned reg_index;
	unsigned chan;
	unsigned const_chan;
	LLVMValueRef base_elt;
	LLVMValueRef ptr = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_RW_BUFFERS);
	LLVMValueRef constbuf_index = lp_build_const_int32(base->gallivm,
							   SI_VS_CONST_CLIP_PLANES);
	LLVMValueRef const_resource = build_indexed_load_const(ctx, ptr, constbuf_index);

	for (reg_index = 0; reg_index < 2; reg_index ++) {
		LLVMValueRef *args = pos[2 + reg_index];

		args[5] =
		args[6] =
		args[7] =
		args[8] = lp_build_const_float(base->gallivm, 0.0f);

		/* Compute dot products of position and user clip plane vectors */
		for (chan = 0; chan < TGSI_NUM_CHANNELS; chan++) {
			for (const_chan = 0; const_chan < TGSI_NUM_CHANNELS; const_chan++) {
				args[1] = lp_build_const_int32(base->gallivm,
							       ((reg_index * 4 + chan) * 4 +
								const_chan) * 4);
				base_elt = buffer_load_const(ctx, const_resource,
							     args[1]);
				args[5 + chan] =
					lp_build_add(base, args[5 + chan],
						     lp_build_mul(base, base_elt,
								  out_elts[const_chan]));
			}
		}

		args[0] = lp_build_const_int32(base->gallivm, 0xf);
		args[1] = uint->zero;
		args[2] = uint->zero;
		args[3] = lp_build_const_int32(base->gallivm,
					       V_008DFC_SQ_EXP_POS + 2 + reg_index);
		args[4] = uint->zero;
	}
}

static void si_dump_streamout(struct pipe_stream_output_info *so)
{
	unsigned i;

	if (so->num_outputs)
		fprintf(stderr, "STREAMOUT\n");

	for (i = 0; i < so->num_outputs; i++) {
		unsigned mask = ((1 << so->output[i].num_components) - 1) <<
				so->output[i].start_component;
		fprintf(stderr, "  %i: BUF%i[%i..%i] <- OUT[%i].%s%s%s%s\n",
			i, so->output[i].output_buffer,
			so->output[i].dst_offset, so->output[i].dst_offset + so->output[i].num_components - 1,
			so->output[i].register_index,
			mask & 1 ? "x" : "",
		        mask & 2 ? "y" : "",
		        mask & 4 ? "z" : "",
		        mask & 8 ? "w" : "");
	}
}

/* On SI, the vertex shader is responsible for writing streamout data
 * to buffers. */
static void si_llvm_emit_streamout(struct si_shader_context *ctx,
				   struct si_shader_output_values *outputs,
				   unsigned noutput)
{
	struct pipe_stream_output_info *so = &ctx->shader->selector->so;
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	int i, j;
	struct lp_build_if_state if_ctx;

	/* Get bits [22:16], i.e. (so_param >> 16) & 127; */
	LLVMValueRef so_vtx_count =
		unpack_param(ctx, ctx->param_streamout_config, 16, 7);

	LLVMValueRef tid = get_thread_id(ctx);

	/* can_emit = tid < so_vtx_count; */
	LLVMValueRef can_emit =
		LLVMBuildICmp(builder, LLVMIntULT, tid, so_vtx_count, "");

	LLVMValueRef stream_id =
		unpack_param(ctx, ctx->param_streamout_config, 24, 2);

	/* Emit the streamout code conditionally. This actually avoids
	 * out-of-bounds buffer access. The hw tells us via the SGPR
	 * (so_vtx_count) which threads are allowed to emit streamout data. */
	lp_build_if(&if_ctx, gallivm, can_emit);
	{
		/* The buffer offset is computed as follows:
		 *   ByteOffset = streamout_offset[buffer_id]*4 +
		 *                (streamout_write_index + thread_id)*stride[buffer_id] +
		 *                attrib_offset
                 */

		LLVMValueRef so_write_index =
			LLVMGetParam(ctx->radeon_bld.main_fn,
				     ctx->param_streamout_write_index);

		/* Compute (streamout_write_index + thread_id). */
		so_write_index = LLVMBuildAdd(builder, so_write_index, tid, "");

		/* Compute the write offset for each enabled buffer. */
		LLVMValueRef so_write_offset[4] = {};
		for (i = 0; i < 4; i++) {
			if (!so->stride[i])
				continue;

			LLVMValueRef so_offset = LLVMGetParam(ctx->radeon_bld.main_fn,
							      ctx->param_streamout_offset[i]);
			so_offset = LLVMBuildMul(builder, so_offset, LLVMConstInt(ctx->i32, 4, 0), "");

			so_write_offset[i] = LLVMBuildMul(builder, so_write_index,
							  LLVMConstInt(ctx->i32, so->stride[i]*4, 0), "");
			so_write_offset[i] = LLVMBuildAdd(builder, so_write_offset[i], so_offset, "");
		}

		/* Write streamout data. */
		for (i = 0; i < so->num_outputs; i++) {
			unsigned buf_idx = so->output[i].output_buffer;
			unsigned reg = so->output[i].register_index;
			unsigned start = so->output[i].start_component;
			unsigned num_comps = so->output[i].num_components;
			unsigned stream = so->output[i].stream;
			LLVMValueRef out[4];
			struct lp_build_if_state if_ctx_stream;

			assert(num_comps && num_comps <= 4);
			if (!num_comps || num_comps > 4)
				continue;

			if (reg >= noutput)
				continue;

			/* Load the output as int. */
			for (j = 0; j < num_comps; j++) {
				out[j] = LLVMBuildBitCast(builder,
							  outputs[reg].values[start+j],
						ctx->i32, "");
			}

			/* Pack the output. */
			LLVMValueRef vdata = NULL;

			switch (num_comps) {
			case 1: /* as i32 */
				vdata = out[0];
				break;
			case 2: /* as v2i32 */
			case 3: /* as v4i32 (aligned to 4) */
			case 4: /* as v4i32 */
				vdata = LLVMGetUndef(LLVMVectorType(ctx->i32, util_next_power_of_two(num_comps)));
				for (j = 0; j < num_comps; j++) {
					vdata = LLVMBuildInsertElement(builder, vdata, out[j],
								       LLVMConstInt(ctx->i32, j, 0), "");
				}
				break;
			}

			LLVMValueRef can_emit_stream =
				LLVMBuildICmp(builder, LLVMIntEQ,
					      stream_id,
					      lp_build_const_int32(gallivm, stream), "");

			lp_build_if(&if_ctx_stream, gallivm, can_emit_stream);
			build_tbuffer_store_dwords(ctx, ctx->so_buffers[buf_idx],
						   vdata, num_comps,
						   so_write_offset[buf_idx],
						   LLVMConstInt(ctx->i32, 0, 0),
						   so->output[i].dst_offset*4);
			lp_build_endif(&if_ctx_stream);
		}
	}
	lp_build_endif(&if_ctx);
}


/* Generate export instructions for hardware VS shader stage */
static void si_llvm_export_vs(struct lp_build_tgsi_context *bld_base,
			      struct si_shader_output_values *outputs,
			      unsigned noutput)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct si_shader *shader = ctx->shader;
	struct lp_build_context *base = &bld_base->base;
	struct lp_build_context *uint =
				&ctx->radeon_bld.soa.bld_base.uint_bld;
	LLVMValueRef args[9];
	LLVMValueRef pos_args[4][9] = { { 0 } };
	LLVMValueRef psize_value = NULL, edgeflag_value = NULL, layer_value = NULL, viewport_index_value = NULL;
	unsigned semantic_name, semantic_index;
	unsigned target;
	unsigned param_count = 0;
	unsigned pos_idx;
	int i;

	if (outputs && ctx->shader->selector->so.num_outputs) {
		si_llvm_emit_streamout(ctx, outputs, noutput);
	}

	for (i = 0; i < noutput; i++) {
		semantic_name = outputs[i].name;
		semantic_index = outputs[i].sid;

handle_semantic:
		/* Select the correct target */
		switch(semantic_name) {
		case TGSI_SEMANTIC_PSIZE:
			psize_value = outputs[i].values[0];
			continue;
		case TGSI_SEMANTIC_EDGEFLAG:
			edgeflag_value = outputs[i].values[0];
			continue;
		case TGSI_SEMANTIC_LAYER:
			layer_value = outputs[i].values[0];
			semantic_name = TGSI_SEMANTIC_GENERIC;
			goto handle_semantic;
		case TGSI_SEMANTIC_VIEWPORT_INDEX:
			viewport_index_value = outputs[i].values[0];
			semantic_name = TGSI_SEMANTIC_GENERIC;
			goto handle_semantic;
		case TGSI_SEMANTIC_POSITION:
			target = V_008DFC_SQ_EXP_POS;
			break;
		case TGSI_SEMANTIC_COLOR:
		case TGSI_SEMANTIC_BCOLOR:
			target = V_008DFC_SQ_EXP_PARAM + param_count;
			assert(i < ARRAY_SIZE(shader->info.vs_output_param_offset));
			shader->info.vs_output_param_offset[i] = param_count;
			param_count++;
			break;
		case TGSI_SEMANTIC_CLIPDIST:
			target = V_008DFC_SQ_EXP_POS + 2 + semantic_index;
			break;
		case TGSI_SEMANTIC_CLIPVERTEX:
			si_llvm_emit_clipvertex(bld_base, pos_args, outputs[i].values);
			continue;
		case TGSI_SEMANTIC_PRIMID:
		case TGSI_SEMANTIC_FOG:
		case TGSI_SEMANTIC_TEXCOORD:
		case TGSI_SEMANTIC_GENERIC:
			target = V_008DFC_SQ_EXP_PARAM + param_count;
			assert(i < ARRAY_SIZE(shader->info.vs_output_param_offset));
			shader->info.vs_output_param_offset[i] = param_count;
			param_count++;
			break;
		default:
			target = 0;
			fprintf(stderr,
				"Warning: SI unhandled vs output type:%d\n",
				semantic_name);
		}

		si_llvm_init_export_args(bld_base, outputs[i].values, target, args);

		if (target >= V_008DFC_SQ_EXP_POS &&
		    target <= (V_008DFC_SQ_EXP_POS + 3)) {
			memcpy(pos_args[target - V_008DFC_SQ_EXP_POS],
			       args, sizeof(args));
		} else {
			lp_build_intrinsic(base->gallivm->builder,
					   "llvm.SI.export", ctx->voidt,
					   args, 9, 0);
		}

		if (semantic_name == TGSI_SEMANTIC_CLIPDIST) {
			semantic_name = TGSI_SEMANTIC_GENERIC;
			goto handle_semantic;
		}
	}

	shader->info.nr_param_exports = param_count;

	/* We need to add the position output manually if it's missing. */
	if (!pos_args[0][0]) {
		pos_args[0][0] = lp_build_const_int32(base->gallivm, 0xf); /* writemask */
		pos_args[0][1] = uint->zero; /* EXEC mask */
		pos_args[0][2] = uint->zero; /* last export? */
		pos_args[0][3] = lp_build_const_int32(base->gallivm, V_008DFC_SQ_EXP_POS);
		pos_args[0][4] = uint->zero; /* COMPR flag */
		pos_args[0][5] = base->zero; /* X */
		pos_args[0][6] = base->zero; /* Y */
		pos_args[0][7] = base->zero; /* Z */
		pos_args[0][8] = base->one;  /* W */
	}

	/* Write the misc vector (point size, edgeflag, layer, viewport). */
	if (shader->selector->info.writes_psize ||
	    shader->selector->info.writes_edgeflag ||
	    shader->selector->info.writes_viewport_index ||
	    shader->selector->info.writes_layer) {
		pos_args[1][0] = lp_build_const_int32(base->gallivm, /* writemask */
						      shader->selector->info.writes_psize |
						      (shader->selector->info.writes_edgeflag << 1) |
						      (shader->selector->info.writes_layer << 2) |
						      (shader->selector->info.writes_viewport_index << 3));
		pos_args[1][1] = uint->zero; /* EXEC mask */
		pos_args[1][2] = uint->zero; /* last export? */
		pos_args[1][3] = lp_build_const_int32(base->gallivm, V_008DFC_SQ_EXP_POS + 1);
		pos_args[1][4] = uint->zero; /* COMPR flag */
		pos_args[1][5] = base->zero; /* X */
		pos_args[1][6] = base->zero; /* Y */
		pos_args[1][7] = base->zero; /* Z */
		pos_args[1][8] = base->zero; /* W */

		if (shader->selector->info.writes_psize)
			pos_args[1][5] = psize_value;

		if (shader->selector->info.writes_edgeflag) {
			/* The output is a float, but the hw expects an integer
			 * with the first bit containing the edge flag. */
			edgeflag_value = LLVMBuildFPToUI(base->gallivm->builder,
							 edgeflag_value,
							 ctx->i32, "");
			edgeflag_value = lp_build_min(&bld_base->int_bld,
						      edgeflag_value,
						      bld_base->int_bld.one);

			/* The LLVM intrinsic expects a float. */
			pos_args[1][6] = LLVMBuildBitCast(base->gallivm->builder,
							  edgeflag_value,
							  ctx->f32, "");
		}

		if (shader->selector->info.writes_layer)
			pos_args[1][7] = layer_value;

		if (shader->selector->info.writes_viewport_index)
			pos_args[1][8] = viewport_index_value;
	}

	for (i = 0; i < 4; i++)
		if (pos_args[i][0])
			shader->info.nr_pos_exports++;

	pos_idx = 0;
	for (i = 0; i < 4; i++) {
		if (!pos_args[i][0])
			continue;

		/* Specify the target we are exporting */
		pos_args[i][3] = lp_build_const_int32(base->gallivm, V_008DFC_SQ_EXP_POS + pos_idx++);

		if (pos_idx == shader->info.nr_pos_exports)
			/* Specify that this is the last export */
			pos_args[i][2] = uint->one;

		lp_build_intrinsic(base->gallivm->builder, "llvm.SI.export",
				   ctx->voidt, pos_args[i], 9, 0);
	}
}

static void si_copy_tcs_inputs(struct lp_build_tgsi_context *bld_base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef invocation_id, rw_buffers, buffer, buffer_offset;
	LLVMValueRef lds_vertex_stride, lds_vertex_offset, lds_base;
	uint64_t inputs;

	invocation_id = unpack_param(ctx, SI_PARAM_REL_IDS, 8, 5);

	rw_buffers = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_RW_BUFFERS);
	buffer = build_indexed_load_const(ctx, rw_buffers,
	                lp_build_const_int32(gallivm, SI_HS_RING_TESS_OFFCHIP));

	buffer_offset = LLVMGetParam(ctx->radeon_bld.main_fn, ctx->param_oc_lds);

	lds_vertex_stride = unpack_param(ctx, SI_PARAM_TCS_IN_LAYOUT, 13, 8);
	lds_vertex_offset = LLVMBuildMul(gallivm->builder, invocation_id,
	                                 lds_vertex_stride, "");
	lds_base = get_tcs_in_current_patch_offset(ctx);
	lds_base = LLVMBuildAdd(gallivm->builder, lds_base, lds_vertex_offset, "");

	inputs = ctx->shader->key.tcs.epilog.inputs_to_copy;
	while (inputs) {
		unsigned i = u_bit_scan64(&inputs);

		LLVMValueRef lds_ptr = LLVMBuildAdd(gallivm->builder, lds_base,
		                            lp_build_const_int32(gallivm, 4 * i),
		                             "");

		LLVMValueRef buffer_addr = get_tcs_tes_buffer_address(ctx,
		                              invocation_id,
		                              lp_build_const_int32(gallivm, i));

		LLVMValueRef value = lds_load(bld_base, TGSI_TYPE_SIGNED, ~0,
		                              lds_ptr);

		build_tbuffer_store_dwords(ctx, buffer, value, 4, buffer_addr,
		                           buffer_offset, 0);
	}
}

static void si_write_tess_factors(struct lp_build_tgsi_context *bld_base,
				  LLVMValueRef rel_patch_id,
				  LLVMValueRef invocation_id,
				  LLVMValueRef tcs_out_current_patch_data_offset)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	struct si_shader *shader = ctx->shader;
	unsigned tess_inner_index, tess_outer_index;
	LLVMValueRef lds_base, lds_inner, lds_outer, byteoffset, buffer;
	LLVMValueRef out[6], vec0, vec1, rw_buffers, tf_base;
	unsigned stride, outer_comps, inner_comps, i;
	struct lp_build_if_state if_ctx, inner_if_ctx;

	si_llvm_emit_barrier(NULL, bld_base, NULL);

	/* Do this only for invocation 0, because the tess levels are per-patch,
	 * not per-vertex.
	 *
	 * This can't jump, because invocation 0 executes this. It should
	 * at least mask out the loads and stores for other invocations.
	 */
	lp_build_if(&if_ctx, gallivm,
		    LLVMBuildICmp(gallivm->builder, LLVMIntEQ,
				  invocation_id, bld_base->uint_bld.zero, ""));

	/* Determine the layout of one tess factor element in the buffer. */
	switch (shader->key.tcs.epilog.prim_mode) {
	case PIPE_PRIM_LINES:
		stride = 2; /* 2 dwords, 1 vec2 store */
		outer_comps = 2;
		inner_comps = 0;
		break;
	case PIPE_PRIM_TRIANGLES:
		stride = 4; /* 4 dwords, 1 vec4 store */
		outer_comps = 3;
		inner_comps = 1;
		break;
	case PIPE_PRIM_QUADS:
		stride = 6; /* 6 dwords, 2 stores (vec4 + vec2) */
		outer_comps = 4;
		inner_comps = 2;
		break;
	default:
		assert(0);
		return;
	}

	/* Load tess_inner and tess_outer from LDS.
	 * Any invocation can write them, so we can't get them from a temporary.
	 */
	tess_inner_index = si_shader_io_get_unique_index(TGSI_SEMANTIC_TESSINNER, 0);
	tess_outer_index = si_shader_io_get_unique_index(TGSI_SEMANTIC_TESSOUTER, 0);

	lds_base = tcs_out_current_patch_data_offset;
	lds_inner = LLVMBuildAdd(gallivm->builder, lds_base,
				 lp_build_const_int32(gallivm,
						      tess_inner_index * 4), "");
	lds_outer = LLVMBuildAdd(gallivm->builder, lds_base,
				 lp_build_const_int32(gallivm,
						      tess_outer_index * 4), "");

	for (i = 0; i < outer_comps; i++)
		out[i] = lds_load(bld_base, TGSI_TYPE_SIGNED, i, lds_outer);
	for (i = 0; i < inner_comps; i++)
		out[outer_comps+i] = lds_load(bld_base, TGSI_TYPE_SIGNED, i, lds_inner);

	/* Convert the outputs to vectors for stores. */
	vec0 = lp_build_gather_values(gallivm, out, MIN2(stride, 4));
	vec1 = NULL;

	if (stride > 4)
		vec1 = lp_build_gather_values(gallivm, out+4, stride - 4);

	/* Get the buffer. */
	rw_buffers = LLVMGetParam(ctx->radeon_bld.main_fn,
				  SI_PARAM_RW_BUFFERS);
	buffer = build_indexed_load_const(ctx, rw_buffers,
			lp_build_const_int32(gallivm, SI_HS_RING_TESS_FACTOR));

	/* Get the offset. */
	tf_base = LLVMGetParam(ctx->radeon_bld.main_fn,
			       SI_PARAM_TESS_FACTOR_OFFSET);
	byteoffset = LLVMBuildMul(gallivm->builder, rel_patch_id,
				  lp_build_const_int32(gallivm, 4 * stride), "");

	lp_build_if(&inner_if_ctx, gallivm,
		    LLVMBuildICmp(gallivm->builder, LLVMIntEQ,
				  rel_patch_id, bld_base->uint_bld.zero, ""));

	/* Store the dynamic HS control word. */
	build_tbuffer_store_dwords(ctx, buffer,
	                           lp_build_const_int32(gallivm, 0x80000000),
	                           1, lp_build_const_int32(gallivm, 0), tf_base, 0);

	lp_build_endif(&inner_if_ctx);

	/* Store the tessellation factors. */
	build_tbuffer_store_dwords(ctx, buffer, vec0,
				   MIN2(stride, 4), byteoffset, tf_base, 4);
	if (vec1)
		build_tbuffer_store_dwords(ctx, buffer, vec1,
					   stride - 4, byteoffset, tf_base, 20);
	lp_build_endif(&if_ctx);
}

/* This only writes the tessellation factor levels. */
static void si_llvm_emit_tcs_epilogue(struct lp_build_tgsi_context *bld_base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	LLVMValueRef rel_patch_id, invocation_id, tf_lds_offset;

	rel_patch_id = get_rel_patch_id(ctx);
	invocation_id = unpack_param(ctx, SI_PARAM_REL_IDS, 8, 5);
	tf_lds_offset = get_tcs_out_current_patch_data_offset(ctx);

	if (!ctx->is_monolithic) {
		/* Return epilog parameters from this function. */
		LLVMBuilderRef builder = bld_base->base.gallivm->builder;
		LLVMValueRef ret = ctx->return_value;
		LLVMValueRef rw_buffers, rw0, rw1, tf_soffset;
		unsigned vgpr;

		/* RW_BUFFERS pointer */
		rw_buffers = LLVMGetParam(ctx->radeon_bld.main_fn,
					  SI_PARAM_RW_BUFFERS);
		rw_buffers = LLVMBuildPtrToInt(builder, rw_buffers, ctx->i64, "");
		rw_buffers = LLVMBuildBitCast(builder, rw_buffers, ctx->v2i32, "");
		rw0 = LLVMBuildExtractElement(builder, rw_buffers,
					      bld_base->uint_bld.zero, "");
		rw1 = LLVMBuildExtractElement(builder, rw_buffers,
					      bld_base->uint_bld.one, "");
		ret = LLVMBuildInsertValue(builder, ret, rw0, 0, "");
		ret = LLVMBuildInsertValue(builder, ret, rw1, 1, "");

		/* Tess factor buffer soffset is after user SGPRs. */
		tf_soffset = LLVMGetParam(ctx->radeon_bld.main_fn,
					  SI_PARAM_TESS_FACTOR_OFFSET);
		ret = LLVMBuildInsertValue(builder, ret, tf_soffset,
					   SI_TCS_NUM_USER_SGPR + 1, "");

		/* VGPRs */
		rel_patch_id = bitcast(bld_base, TGSI_TYPE_FLOAT, rel_patch_id);
		invocation_id = bitcast(bld_base, TGSI_TYPE_FLOAT, invocation_id);
		tf_lds_offset = bitcast(bld_base, TGSI_TYPE_FLOAT, tf_lds_offset);

		vgpr = SI_TCS_NUM_USER_SGPR + 2;
		ret = LLVMBuildInsertValue(builder, ret, rel_patch_id, vgpr++, "");
		ret = LLVMBuildInsertValue(builder, ret, invocation_id, vgpr++, "");
		ret = LLVMBuildInsertValue(builder, ret, tf_lds_offset, vgpr++, "");
		ctx->return_value = ret;
		return;
	}

	si_copy_tcs_inputs(bld_base);
	si_write_tess_factors(bld_base, rel_patch_id, invocation_id, tf_lds_offset);
}

static void si_llvm_emit_ls_epilogue(struct lp_build_tgsi_context *bld_base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct si_shader *shader = ctx->shader;
	struct tgsi_shader_info *info = &shader->selector->info;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	unsigned i, chan;
	LLVMValueRef vertex_id = LLVMGetParam(ctx->radeon_bld.main_fn,
					      ctx->param_rel_auto_id);
	LLVMValueRef vertex_dw_stride =
		unpack_param(ctx, SI_PARAM_LS_OUT_LAYOUT, 13, 8);
	LLVMValueRef base_dw_addr = LLVMBuildMul(gallivm->builder, vertex_id,
						 vertex_dw_stride, "");

	/* Write outputs to LDS. The next shader (TCS aka HS) will read
	 * its inputs from it. */
	for (i = 0; i < info->num_outputs; i++) {
		LLVMValueRef *out_ptr = ctx->radeon_bld.soa.outputs[i];
		unsigned name = info->output_semantic_name[i];
		unsigned index = info->output_semantic_index[i];
		int param = si_shader_io_get_unique_index(name, index);
		LLVMValueRef dw_addr = LLVMBuildAdd(gallivm->builder, base_dw_addr,
					lp_build_const_int32(gallivm, param * 4), "");

		for (chan = 0; chan < 4; chan++) {
			lds_store(bld_base, chan, dw_addr,
				  LLVMBuildLoad(gallivm->builder, out_ptr[chan], ""));
		}
	}
}

static void si_llvm_emit_es_epilogue(struct lp_build_tgsi_context *bld_base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	struct si_shader *es = ctx->shader;
	struct tgsi_shader_info *info = &es->selector->info;
	LLVMValueRef soffset = LLVMGetParam(ctx->radeon_bld.main_fn,
					    ctx->param_es2gs_offset);
	unsigned chan;
	int i;

	for (i = 0; i < info->num_outputs; i++) {
		LLVMValueRef *out_ptr =
			ctx->radeon_bld.soa.outputs[i];
		int param_index;

		if (info->output_semantic_name[i] == TGSI_SEMANTIC_VIEWPORT_INDEX ||
		    info->output_semantic_name[i] == TGSI_SEMANTIC_LAYER)
			continue;

		param_index = si_shader_io_get_unique_index(info->output_semantic_name[i],
							    info->output_semantic_index[i]);

		for (chan = 0; chan < 4; chan++) {
			LLVMValueRef out_val = LLVMBuildLoad(gallivm->builder, out_ptr[chan], "");
			out_val = LLVMBuildBitCast(gallivm->builder, out_val, ctx->i32, "");

			build_tbuffer_store(ctx,
					    ctx->esgs_ring,
					    out_val, 1,
					    LLVMGetUndef(ctx->i32), soffset,
					    (4 * param_index + chan) * 4,
					    V_008F0C_BUF_DATA_FORMAT_32,
					    V_008F0C_BUF_NUM_FORMAT_UINT,
					    0, 0, 1, 1, 0);
		}
	}
}

static void si_llvm_emit_gs_epilogue(struct lp_build_tgsi_context *bld_base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef args[2];

	args[0] = lp_build_const_int32(gallivm,	SENDMSG_GS_OP_NOP | SENDMSG_GS_DONE);
	args[1] = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_GS_WAVE_ID);
	lp_build_intrinsic(gallivm->builder, "llvm.SI.sendmsg",
			   ctx->voidt, args, 2, 0);
}

static void si_llvm_emit_vs_epilogue(struct lp_build_tgsi_context *bld_base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	struct tgsi_shader_info *info = &ctx->shader->selector->info;
	struct si_shader_output_values *outputs = NULL;
	int i,j;

	assert(!ctx->is_gs_copy_shader);

	outputs = MALLOC((info->num_outputs + 1) * sizeof(outputs[0]));

	/* Vertex color clamping.
	 *
	 * This uses a state constant loaded in a user data SGPR and
	 * an IF statement is added that clamps all colors if the constant
	 * is true.
	 */
	if (ctx->type == PIPE_SHADER_VERTEX) {
		struct lp_build_if_state if_ctx;
		LLVMValueRef cond = NULL;
		LLVMValueRef addr, val;

		for (i = 0; i < info->num_outputs; i++) {
			if (info->output_semantic_name[i] != TGSI_SEMANTIC_COLOR &&
			    info->output_semantic_name[i] != TGSI_SEMANTIC_BCOLOR)
				continue;

			/* We've found a color. */
			if (!cond) {
				/* The state is in the first bit of the user SGPR. */
				cond = LLVMGetParam(ctx->radeon_bld.main_fn,
						    SI_PARAM_VS_STATE_BITS);
				cond = LLVMBuildTrunc(gallivm->builder, cond,
						      ctx->i1, "");
				lp_build_if(&if_ctx, gallivm, cond);
			}

			for (j = 0; j < 4; j++) {
				addr = ctx->radeon_bld.soa.outputs[i][j];
				val = LLVMBuildLoad(gallivm->builder, addr, "");
				val = radeon_llvm_saturate(bld_base, val);
				LLVMBuildStore(gallivm->builder, val, addr);
			}
		}

		if (cond)
			lp_build_endif(&if_ctx);
	}

	for (i = 0; i < info->num_outputs; i++) {
		outputs[i].name = info->output_semantic_name[i];
		outputs[i].sid = info->output_semantic_index[i];

		for (j = 0; j < 4; j++)
			outputs[i].values[j] =
				LLVMBuildLoad(gallivm->builder,
					      ctx->radeon_bld.soa.outputs[i][j],
					      "");
	}

	if (ctx->is_monolithic) {
		/* Export PrimitiveID when PS needs it. */
		if (si_vs_exports_prim_id(ctx->shader)) {
			outputs[i].name = TGSI_SEMANTIC_PRIMID;
			outputs[i].sid = 0;
			outputs[i].values[0] = bitcast(bld_base, TGSI_TYPE_FLOAT,
						       get_primitive_id(bld_base, 0));
			outputs[i].values[1] = bld_base->base.undef;
			outputs[i].values[2] = bld_base->base.undef;
			outputs[i].values[3] = bld_base->base.undef;
			i++;
		}
	} else {
		/* Return the primitive ID from the LLVM function. */
		ctx->return_value =
			LLVMBuildInsertValue(gallivm->builder,
					     ctx->return_value,
					     bitcast(bld_base, TGSI_TYPE_FLOAT,
						     get_primitive_id(bld_base, 0)),
					     VS_EPILOG_PRIMID_LOC, "");
	}

	si_llvm_export_vs(bld_base, outputs, i);
	FREE(outputs);
}

struct si_ps_exports {
	unsigned num;
	LLVMValueRef args[10][9];
};

static void si_export_mrt_z(struct lp_build_tgsi_context *bld_base,
			    LLVMValueRef depth, LLVMValueRef stencil,
			    LLVMValueRef samplemask, struct si_ps_exports *exp)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct lp_build_context *base = &bld_base->base;
	struct lp_build_context *uint = &bld_base->uint_bld;
	LLVMValueRef args[9];
	unsigned mask = 0;

	assert(depth || stencil || samplemask);

	args[1] = uint->one; /* whether the EXEC mask is valid */
	args[2] = uint->one; /* DONE bit */

	/* Specify the target we are exporting */
	args[3] = lp_build_const_int32(base->gallivm, V_008DFC_SQ_EXP_MRTZ);

	args[4] = uint->zero; /* COMP flag */
	args[5] = base->undef; /* R, depth */
	args[6] = base->undef; /* G, stencil test value[0:7], stencil op value[8:15] */
	args[7] = base->undef; /* B, sample mask */
	args[8] = base->undef; /* A, alpha to mask */

	if (depth) {
		args[5] = depth;
		mask |= 0x1;
	}

	if (stencil) {
		args[6] = stencil;
		mask |= 0x2;
	}

	if (samplemask) {
		args[7] = samplemask;
		mask |= 0x4;
	}

	/* SI (except OLAND) has a bug that it only looks
	 * at the X writemask component. */
	if (ctx->screen->b.chip_class == SI &&
	    ctx->screen->b.family != CHIP_OLAND)
		mask |= 0x1;

	/* Specify which components to enable */
	args[0] = lp_build_const_int32(base->gallivm, mask);

	memcpy(exp->args[exp->num++], args, sizeof(args));
}

static void si_export_mrt_color(struct lp_build_tgsi_context *bld_base,
				LLVMValueRef *color, unsigned index,
				unsigned samplemask_param,
				bool is_last, struct si_ps_exports *exp)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct lp_build_context *base = &bld_base->base;
	int i;

	/* Clamp color */
	if (ctx->shader->key.ps.epilog.clamp_color)
		for (i = 0; i < 4; i++)
			color[i] = radeon_llvm_saturate(bld_base, color[i]);

	/* Alpha to one */
	if (ctx->shader->key.ps.epilog.alpha_to_one)
		color[3] = base->one;

	/* Alpha test */
	if (index == 0 &&
	    ctx->shader->key.ps.epilog.alpha_func != PIPE_FUNC_ALWAYS)
		si_alpha_test(bld_base, color[3]);

	/* Line & polygon smoothing */
	if (ctx->shader->key.ps.epilog.poly_line_smoothing)
		color[3] = si_scale_alpha_by_sample_mask(bld_base, color[3],
							 samplemask_param);

	/* If last_cbuf > 0, FS_COLOR0_WRITES_ALL_CBUFS is true. */
	if (ctx->shader->key.ps.epilog.last_cbuf > 0) {
		LLVMValueRef args[8][9];
		int c, last = -1;

		/* Get the export arguments, also find out what the last one is. */
		for (c = 0; c <= ctx->shader->key.ps.epilog.last_cbuf; c++) {
			si_llvm_init_export_args(bld_base, color,
						 V_008DFC_SQ_EXP_MRT + c, args[c]);
			if (args[c][0] != bld_base->uint_bld.zero)
				last = c;
		}

		/* Emit all exports. */
		for (c = 0; c <= ctx->shader->key.ps.epilog.last_cbuf; c++) {
			if (is_last && last == c) {
				args[c][1] = bld_base->uint_bld.one; /* whether the EXEC mask is valid */
				args[c][2] = bld_base->uint_bld.one; /* DONE bit */
			} else if (args[c][0] == bld_base->uint_bld.zero)
				continue; /* unnecessary NULL export */

			memcpy(exp->args[exp->num++], args[c], sizeof(args[c]));
		}
	} else {
		LLVMValueRef args[9];

		/* Export */
		si_llvm_init_export_args(bld_base, color, V_008DFC_SQ_EXP_MRT + index,
					 args);
		if (is_last) {
			args[1] = bld_base->uint_bld.one; /* whether the EXEC mask is valid */
			args[2] = bld_base->uint_bld.one; /* DONE bit */
		} else if (args[0] == bld_base->uint_bld.zero)
			return; /* unnecessary NULL export */

		memcpy(exp->args[exp->num++], args, sizeof(args));
	}
}

static void si_emit_ps_exports(struct si_shader_context *ctx,
			       struct si_ps_exports *exp)
{
	for (unsigned i = 0; i < exp->num; i++)
		lp_build_intrinsic(ctx->radeon_bld.gallivm.builder,
				   "llvm.SI.export", ctx->voidt,
				   exp->args[i], 9, 0);
}

static void si_export_null(struct lp_build_tgsi_context *bld_base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct lp_build_context *base = &bld_base->base;
	struct lp_build_context *uint = &bld_base->uint_bld;
	LLVMValueRef args[9];

	args[0] = lp_build_const_int32(base->gallivm, 0x0); /* enabled channels */
	args[1] = uint->one; /* whether the EXEC mask is valid */
	args[2] = uint->one; /* DONE bit */
	args[3] = lp_build_const_int32(base->gallivm, V_008DFC_SQ_EXP_NULL);
	args[4] = uint->zero; /* COMPR flag (0 = 32-bit export) */
	args[5] = uint->undef; /* R */
	args[6] = uint->undef; /* G */
	args[7] = uint->undef; /* B */
	args[8] = uint->undef; /* A */

	lp_build_intrinsic(base->gallivm->builder, "llvm.SI.export",
			   ctx->voidt, args, 9, 0);
}

static void si_llvm_emit_fs_epilogue(struct lp_build_tgsi_context *bld_base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct si_shader *shader = ctx->shader;
	struct lp_build_context *base = &bld_base->base;
	struct tgsi_shader_info *info = &shader->selector->info;
	LLVMBuilderRef builder = base->gallivm->builder;
	LLVMValueRef depth = NULL, stencil = NULL, samplemask = NULL;
	int last_color_export = -1;
	int i;
	struct si_ps_exports exp = {};

	/* Determine the last export. If MRTZ is present, it's always last.
	 * Otherwise, find the last color export.
	 */
	if (!info->writes_z && !info->writes_stencil && !info->writes_samplemask) {
		unsigned spi_format = shader->key.ps.epilog.spi_shader_col_format;

		/* Don't export NULL and return if alpha-test is enabled. */
		if (shader->key.ps.epilog.alpha_func != PIPE_FUNC_ALWAYS &&
		    shader->key.ps.epilog.alpha_func != PIPE_FUNC_NEVER &&
		    (spi_format & 0xf) == 0)
			spi_format |= V_028714_SPI_SHADER_32_AR;

		for (i = 0; i < info->num_outputs; i++) {
			unsigned index = info->output_semantic_index[i];

			if (info->output_semantic_name[i] != TGSI_SEMANTIC_COLOR)
				continue;

			/* If last_cbuf > 0, FS_COLOR0_WRITES_ALL_CBUFS is true. */
			if (shader->key.ps.epilog.last_cbuf > 0) {
				/* Just set this if any of the colorbuffers are enabled. */
				if (spi_format &
				    ((1llu << (4 * (shader->key.ps.epilog.last_cbuf + 1))) - 1))
					last_color_export = i;
				continue;
			}

			if ((spi_format >> (index * 4)) & 0xf)
				last_color_export = i;
		}

		/* If there are no outputs, export NULL. */
		if (last_color_export == -1) {
			si_export_null(bld_base);
			return;
		}
	}

	for (i = 0; i < info->num_outputs; i++) {
		unsigned semantic_name = info->output_semantic_name[i];
		unsigned semantic_index = info->output_semantic_index[i];
		unsigned j;
		LLVMValueRef color[4] = {};

		/* Select the correct target */
		switch (semantic_name) {
		case TGSI_SEMANTIC_POSITION:
			depth = LLVMBuildLoad(builder,
					      ctx->radeon_bld.soa.outputs[i][2], "");
			break;
		case TGSI_SEMANTIC_STENCIL:
			stencil = LLVMBuildLoad(builder,
						ctx->radeon_bld.soa.outputs[i][1], "");
			break;
		case TGSI_SEMANTIC_SAMPLEMASK:
			samplemask = LLVMBuildLoad(builder,
						   ctx->radeon_bld.soa.outputs[i][0], "");
			break;
		case TGSI_SEMANTIC_COLOR:
			for (j = 0; j < 4; j++)
				color[j] = LLVMBuildLoad(builder,
							 ctx->radeon_bld.soa.outputs[i][j], "");

			si_export_mrt_color(bld_base, color, semantic_index,
					    SI_PARAM_SAMPLE_COVERAGE,
					    last_color_export == i, &exp);
			break;
		default:
			fprintf(stderr,
				"Warning: SI unhandled fs output type:%d\n",
				semantic_name);
		}
	}

	if (depth || stencil || samplemask)
		si_export_mrt_z(bld_base, depth, stencil, samplemask, &exp);

	si_emit_ps_exports(ctx, &exp);
}

/**
 * Return PS outputs in this order:
 *
 * v[0:3] = color0.xyzw
 * v[4:7] = color1.xyzw
 * ...
 * vN+0 = Depth
 * vN+1 = Stencil
 * vN+2 = SampleMask
 * vN+3 = SampleMaskIn (used for OpenGL smoothing)
 *
 * The alpha-ref SGPR is returned via its original location.
 */
static void si_llvm_return_fs_outputs(struct lp_build_tgsi_context *bld_base)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct si_shader *shader = ctx->shader;
	struct lp_build_context *base = &bld_base->base;
	struct tgsi_shader_info *info = &shader->selector->info;
	LLVMBuilderRef builder = base->gallivm->builder;
	unsigned i, j, first_vgpr, vgpr;

	LLVMValueRef color[8][4] = {};
	LLVMValueRef depth = NULL, stencil = NULL, samplemask = NULL;
	LLVMValueRef ret;

	/* Read the output values. */
	for (i = 0; i < info->num_outputs; i++) {
		unsigned semantic_name = info->output_semantic_name[i];
		unsigned semantic_index = info->output_semantic_index[i];

		switch (semantic_name) {
		case TGSI_SEMANTIC_COLOR:
			assert(semantic_index < 8);
			for (j = 0; j < 4; j++) {
				LLVMValueRef ptr = ctx->radeon_bld.soa.outputs[i][j];
				LLVMValueRef result = LLVMBuildLoad(builder, ptr, "");
				color[semantic_index][j] = result;
			}
			break;
		case TGSI_SEMANTIC_POSITION:
			depth = LLVMBuildLoad(builder,
					      ctx->radeon_bld.soa.outputs[i][2], "");
			break;
		case TGSI_SEMANTIC_STENCIL:
			stencil = LLVMBuildLoad(builder,
						ctx->radeon_bld.soa.outputs[i][1], "");
			break;
		case TGSI_SEMANTIC_SAMPLEMASK:
			samplemask = LLVMBuildLoad(builder,
						   ctx->radeon_bld.soa.outputs[i][0], "");
			break;
		default:
			fprintf(stderr, "Warning: SI unhandled fs output type:%d\n",
				semantic_name);
		}
	}

	/* Fill the return structure. */
	ret = ctx->return_value;

	/* Set SGPRs. */
	ret = LLVMBuildInsertValue(builder, ret,
				   bitcast(bld_base, TGSI_TYPE_SIGNED,
					   LLVMGetParam(ctx->radeon_bld.main_fn,
							SI_PARAM_ALPHA_REF)),
				   SI_SGPR_ALPHA_REF, "");

	/* Set VGPRs */
	first_vgpr = vgpr = SI_SGPR_ALPHA_REF + 1;
	for (i = 0; i < ARRAY_SIZE(color); i++) {
		if (!color[i][0])
			continue;

		for (j = 0; j < 4; j++)
			ret = LLVMBuildInsertValue(builder, ret, color[i][j], vgpr++, "");
	}
	if (depth)
		ret = LLVMBuildInsertValue(builder, ret, depth, vgpr++, "");
	if (stencil)
		ret = LLVMBuildInsertValue(builder, ret, stencil, vgpr++, "");
	if (samplemask)
		ret = LLVMBuildInsertValue(builder, ret, samplemask, vgpr++, "");

	/* Add the input sample mask for smoothing at the end. */
	if (vgpr < first_vgpr + PS_EPILOG_SAMPLEMASK_MIN_LOC)
		vgpr = first_vgpr + PS_EPILOG_SAMPLEMASK_MIN_LOC;
	ret = LLVMBuildInsertValue(builder, ret,
				   LLVMGetParam(ctx->radeon_bld.main_fn,
						SI_PARAM_SAMPLE_COVERAGE), vgpr++, "");

	ctx->return_value = ret;
}

/**
 * Given a v8i32 resource descriptor for a buffer, extract the size of the
 * buffer in number of elements and return it as an i32.
 */
static LLVMValueRef get_buffer_size(
	struct lp_build_tgsi_context *bld_base,
	LLVMValueRef descriptor)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	LLVMValueRef size =
		LLVMBuildExtractElement(builder, descriptor,
					lp_build_const_int32(gallivm, 6), "");

	if (ctx->screen->b.chip_class >= VI) {
		/* On VI, the descriptor contains the size in bytes,
		 * but TXQ must return the size in elements.
		 * The stride is always non-zero for resources using TXQ.
		 */
		LLVMValueRef stride =
			LLVMBuildExtractElement(builder, descriptor,
						lp_build_const_int32(gallivm, 5), "");
		stride = LLVMBuildLShr(builder, stride,
				       lp_build_const_int32(gallivm, 16), "");
		stride = LLVMBuildAnd(builder, stride,
				      lp_build_const_int32(gallivm, 0x3FFF), "");

		size = LLVMBuildUDiv(builder, size, stride, "");
	}

	return size;
}

/**
 * Given the i32 or vNi32 \p type, generate the textual name (e.g. for use with
 * intrinsic names).
 */
static void build_int_type_name(
	LLVMTypeRef type,
	char *buf, unsigned bufsize)
{
	assert(bufsize >= 6);

	if (LLVMGetTypeKind(type) == LLVMVectorTypeKind)
		snprintf(buf, bufsize, "v%ui32",
			 LLVMGetVectorSize(type));
	else
		strcpy(buf, "i32");
}

static void build_tex_intrinsic(const struct lp_build_tgsi_action *action,
				struct lp_build_tgsi_context *bld_base,
				struct lp_build_emit_data *emit_data);

/* Prevent optimizations (at least of memory accesses) across the current
 * point in the program by emitting empty inline assembly that is marked as
 * having side effects.
 */
static void emit_optimization_barrier(struct si_shader_context *ctx)
{
	LLVMBuilderRef builder = ctx->radeon_bld.gallivm.builder;
	LLVMTypeRef ftype = LLVMFunctionType(ctx->voidt, NULL, 0, false);
	LLVMValueRef inlineasm = LLVMConstInlineAsm(ftype, "", "", true, false);
	LLVMBuildCall(builder, inlineasm, NULL, 0, "");
}

static void emit_waitcnt(struct si_shader_context *ctx)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	LLVMValueRef args[1] = {
		lp_build_const_int32(gallivm, 0xf70)
	};
	lp_build_intrinsic(builder, "llvm.amdgcn.s.waitcnt",
			   ctx->voidt, args, 1, 0);
}

static void membar_emit(
		const struct lp_build_tgsi_action *action,
		struct lp_build_tgsi_context *bld_base,
		struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);

	emit_waitcnt(ctx);
}

static LLVMValueRef
shader_buffer_fetch_rsrc(struct si_shader_context *ctx,
			 const struct tgsi_full_src_register *reg)
{
	LLVMValueRef ind_index;
	LLVMValueRef rsrc_ptr;

	if (!reg->Register.Indirect)
		return ctx->shader_buffers[reg->Register.Index];

	ind_index = get_bounded_indirect_index(ctx, &reg->Indirect,
					       reg->Register.Index,
					       SI_NUM_SHADER_BUFFERS);

	rsrc_ptr = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_SHADER_BUFFERS);
	return build_indexed_load_const(ctx, rsrc_ptr, ind_index);
}

static bool tgsi_is_array_sampler(unsigned target)
{
	return target == TGSI_TEXTURE_1D_ARRAY ||
	       target == TGSI_TEXTURE_SHADOW1D_ARRAY ||
	       target == TGSI_TEXTURE_2D_ARRAY ||
	       target == TGSI_TEXTURE_SHADOW2D_ARRAY ||
	       target == TGSI_TEXTURE_CUBE_ARRAY ||
	       target == TGSI_TEXTURE_SHADOWCUBE_ARRAY ||
	       target == TGSI_TEXTURE_2D_ARRAY_MSAA;
}

static bool tgsi_is_array_image(unsigned target)
{
	return target == TGSI_TEXTURE_3D ||
	       target == TGSI_TEXTURE_CUBE ||
	       target == TGSI_TEXTURE_1D_ARRAY ||
	       target == TGSI_TEXTURE_2D_ARRAY ||
	       target == TGSI_TEXTURE_CUBE_ARRAY ||
	       target == TGSI_TEXTURE_2D_ARRAY_MSAA;
}

/**
 * Given a 256-bit resource descriptor, force the DCC enable bit to off.
 *
 * At least on Tonga, executing image stores on images with DCC enabled and
 * non-trivial can eventually lead to lockups. This can occur when an
 * application binds an image as read-only but then uses a shader that writes
 * to it. The OpenGL spec allows almost arbitrarily bad behavior (including
 * program termination) in this case, but it doesn't cost much to be a bit
 * nicer: disabling DCC in the shader still leads to undefined results but
 * avoids the lockup.
 */
static LLVMValueRef force_dcc_off(struct si_shader_context *ctx,
				  LLVMValueRef rsrc)
{
	if (ctx->screen->b.chip_class <= CIK) {
		return rsrc;
	} else {
		LLVMBuilderRef builder = ctx->radeon_bld.gallivm.builder;
		LLVMValueRef i32_6 = LLVMConstInt(ctx->i32, 6, 0);
		LLVMValueRef i32_C = LLVMConstInt(ctx->i32, C_008F28_COMPRESSION_EN, 0);
		LLVMValueRef tmp;

		tmp = LLVMBuildExtractElement(builder, rsrc, i32_6, "");
		tmp = LLVMBuildAnd(builder, tmp, i32_C, "");
		return LLVMBuildInsertElement(builder, rsrc, tmp, i32_6, "");
	}
}

/**
 * Load the resource descriptor for \p image.
 */
static void
image_fetch_rsrc(
	struct lp_build_tgsi_context *bld_base,
	const struct tgsi_full_src_register *image,
	bool dcc_off,
	LLVMValueRef *rsrc)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);

	assert(image->Register.File == TGSI_FILE_IMAGE);

	if (!image->Register.Indirect) {
		/* Fast path: use preloaded resources */
		*rsrc = ctx->images[image->Register.Index];
	} else {
		/* Indexing and manual load */
		LLVMValueRef ind_index;
		LLVMValueRef rsrc_ptr;
		LLVMValueRef tmp;

		/* From the GL_ARB_shader_image_load_store extension spec:
		 *
		 *    If a shader performs an image load, store, or atomic
		 *    operation using an image variable declared as an array,
		 *    and if the index used to select an individual element is
		 *    negative or greater than or equal to the size of the
		 *    array, the results of the operation are undefined but may
		 *    not lead to termination.
		 */
		ind_index = get_bounded_indirect_index(ctx, &image->Indirect,
						       image->Register.Index,
						       SI_NUM_IMAGES);

		rsrc_ptr = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_IMAGES);
		tmp = build_indexed_load_const(ctx, rsrc_ptr, ind_index);
		if (dcc_off)
			tmp = force_dcc_off(ctx, tmp);
		*rsrc = tmp;
	}
}

static LLVMValueRef image_fetch_coords(
		struct lp_build_tgsi_context *bld_base,
		const struct tgsi_full_instruction *inst,
		unsigned src)
{
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	unsigned target = inst->Memory.Texture;
	unsigned num_coords = tgsi_util_get_texture_coord_dim(target);
	LLVMValueRef coords[4];
	LLVMValueRef tmp;
	int chan;

	for (chan = 0; chan < num_coords; ++chan) {
		tmp = lp_build_emit_fetch(bld_base, inst, src, chan);
		tmp = LLVMBuildBitCast(builder, tmp, bld_base->uint_bld.elem_type, "");
		coords[chan] = tmp;
	}

	if (num_coords == 1)
		return coords[0];

	if (num_coords == 3) {
		/* LLVM has difficulties lowering 3-element vectors. */
		coords[3] = bld_base->uint_bld.undef;
		num_coords = 4;
	}

	return lp_build_gather_values(gallivm, coords, num_coords);
}

/**
 * Append the extra mode bits that are used by image load and store.
 */
static void image_append_args(
		struct si_shader_context *ctx,
		struct lp_build_emit_data * emit_data,
		unsigned target,
		bool atomic)
{
	const struct tgsi_full_instruction *inst = emit_data->inst;
	LLVMValueRef i1false = LLVMConstInt(ctx->i1, 0, 0);
	LLVMValueRef i1true = LLVMConstInt(ctx->i1, 1, 0);

	emit_data->args[emit_data->arg_count++] = i1false; /* r128 */
	emit_data->args[emit_data->arg_count++] =
		tgsi_is_array_image(target) ? i1true : i1false; /* da */
	if (!atomic) {
		emit_data->args[emit_data->arg_count++] =
			inst->Memory.Qualifier & (TGSI_MEMORY_COHERENT | TGSI_MEMORY_VOLATILE) ?
			i1true : i1false; /* glc */
	}
	emit_data->args[emit_data->arg_count++] = i1false; /* slc */
}

/**
 * Given a 256 bit resource, extract the top half (which stores the buffer
 * resource in the case of textures and images).
 */
static LLVMValueRef extract_rsrc_top_half(
		struct si_shader_context *ctx,
		LLVMValueRef rsrc)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	LLVMTypeRef v2i128 = LLVMVectorType(ctx->i128, 2);

	rsrc = LLVMBuildBitCast(gallivm->builder, rsrc, v2i128, "");
	rsrc = LLVMBuildExtractElement(gallivm->builder, rsrc, bld_base->uint_bld.one, "");
	rsrc = LLVMBuildBitCast(gallivm->builder, rsrc, ctx->v4i32, "");

	return rsrc;
}

/**
 * Append the resource and indexing arguments for buffer intrinsics.
 *
 * \param rsrc the v4i32 buffer resource
 * \param index index into the buffer (stride-based)
 * \param offset byte offset into the buffer
 */
static void buffer_append_args(
		struct si_shader_context *ctx,
		struct lp_build_emit_data *emit_data,
		LLVMValueRef rsrc,
		LLVMValueRef index,
		LLVMValueRef offset,
		bool atomic)
{
	const struct tgsi_full_instruction *inst = emit_data->inst;
	LLVMValueRef i1false = LLVMConstInt(ctx->i1, 0, 0);
	LLVMValueRef i1true = LLVMConstInt(ctx->i1, 1, 0);

	emit_data->args[emit_data->arg_count++] = rsrc;
	emit_data->args[emit_data->arg_count++] = index; /* vindex */
	emit_data->args[emit_data->arg_count++] = offset; /* voffset */
	if (!atomic) {
		emit_data->args[emit_data->arg_count++] =
			inst->Memory.Qualifier & (TGSI_MEMORY_COHERENT | TGSI_MEMORY_VOLATILE) ?
			i1true : i1false; /* glc */
	}
	emit_data->args[emit_data->arg_count++] = i1false; /* slc */
}

static void load_fetch_args(
		struct lp_build_tgsi_context * bld_base,
		struct lp_build_emit_data * emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	const struct tgsi_full_instruction * inst = emit_data->inst;
	unsigned target = inst->Memory.Texture;
	LLVMValueRef rsrc;

	emit_data->dst_type = LLVMVectorType(bld_base->base.elem_type, 4);

	if (inst->Src[0].Register.File == TGSI_FILE_BUFFER) {
		LLVMBuilderRef builder = gallivm->builder;
		LLVMValueRef offset;
		LLVMValueRef tmp;

		rsrc = shader_buffer_fetch_rsrc(ctx, &inst->Src[0]);

		tmp = lp_build_emit_fetch(bld_base, inst, 1, 0);
		offset = LLVMBuildBitCast(builder, tmp, bld_base->uint_bld.elem_type, "");

		buffer_append_args(ctx, emit_data, rsrc, bld_base->uint_bld.zero,
				   offset, false);
	} else if (inst->Src[0].Register.File == TGSI_FILE_IMAGE) {
		LLVMValueRef coords;

		image_fetch_rsrc(bld_base, &inst->Src[0], false, &rsrc);
		coords = image_fetch_coords(bld_base, inst, 1);

		if (target == TGSI_TEXTURE_BUFFER) {
			rsrc = extract_rsrc_top_half(ctx, rsrc);
			buffer_append_args(ctx, emit_data, rsrc, coords,
					bld_base->uint_bld.zero, false);
		} else {
			emit_data->args[0] = coords;
			emit_data->args[1] = rsrc;
			emit_data->args[2] = lp_build_const_int32(gallivm, 15); /* dmask */
			emit_data->arg_count = 3;

			image_append_args(ctx, emit_data, target, false);
		}
	}
}

static void load_emit_buffer(struct si_shader_context *ctx,
			     struct lp_build_emit_data *emit_data)
{
	const struct tgsi_full_instruction *inst = emit_data->inst;
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	uint writemask = inst->Dst[0].Register.WriteMask;
	uint count = util_last_bit(writemask);
	const char *intrinsic_name;
	LLVMTypeRef dst_type;

	switch (count) {
	case 1:
		intrinsic_name = "llvm.amdgcn.buffer.load.f32";
		dst_type = ctx->f32;
		break;
	case 2:
		intrinsic_name = "llvm.amdgcn.buffer.load.v2f32";
		dst_type = LLVMVectorType(ctx->f32, 2);
		break;
	default: // 3 & 4
		intrinsic_name = "llvm.amdgcn.buffer.load.v4f32";
		dst_type = ctx->v4f32;
		count = 4;
	}

	emit_data->output[emit_data->chan] = lp_build_intrinsic(
			builder, intrinsic_name, dst_type,
			emit_data->args, emit_data->arg_count,
			LLVMReadOnlyAttribute);
}

static LLVMValueRef get_memory_ptr(struct si_shader_context *ctx,
                                   const struct tgsi_full_instruction *inst,
                                   LLVMTypeRef type, int arg)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	LLVMValueRef offset, ptr;
	int addr_space;

	offset = lp_build_emit_fetch(&ctx->radeon_bld.soa.bld_base, inst, arg, 0);
	offset = LLVMBuildBitCast(builder, offset, ctx->i32, "");

	ptr = ctx->shared_memory;
	ptr = LLVMBuildGEP(builder, ptr, &offset, 1, "");
	addr_space = LLVMGetPointerAddressSpace(LLVMTypeOf(ptr));
	ptr = LLVMBuildBitCast(builder, ptr, LLVMPointerType(type, addr_space), "");

	return ptr;
}

static void load_emit_memory(
		struct si_shader_context *ctx,
		struct lp_build_emit_data *emit_data)
{
	const struct tgsi_full_instruction *inst = emit_data->inst;
	struct lp_build_context *base = &ctx->radeon_bld.soa.bld_base.base;
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	unsigned writemask = inst->Dst[0].Register.WriteMask;
	LLVMValueRef channels[4], ptr, derived_ptr, index;
	int chan;

	ptr = get_memory_ptr(ctx, inst, base->elem_type, 1);

	for (chan = 0; chan < 4; ++chan) {
		if (!(writemask & (1 << chan))) {
			channels[chan] = LLVMGetUndef(base->elem_type);
			continue;
		}

		index = lp_build_const_int32(gallivm, chan);
		derived_ptr = LLVMBuildGEP(builder, ptr, &index, 1, "");
		channels[chan] = LLVMBuildLoad(builder, derived_ptr, "");
	}
	emit_data->output[emit_data->chan] = lp_build_gather_values(gallivm, channels, 4);
}

static void load_emit(
		const struct lp_build_tgsi_action *action,
		struct lp_build_tgsi_context *bld_base,
		struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	const struct tgsi_full_instruction * inst = emit_data->inst;
	char intrinsic_name[32];
	char coords_type[8];

	if (inst->Src[0].Register.File == TGSI_FILE_MEMORY) {
		load_emit_memory(ctx, emit_data);
		return;
	}

	if (inst->Memory.Qualifier & TGSI_MEMORY_VOLATILE)
		emit_waitcnt(ctx);

	if (inst->Src[0].Register.File == TGSI_FILE_BUFFER) {
		load_emit_buffer(ctx, emit_data);
		return;
	}

	if (inst->Memory.Texture == TGSI_TEXTURE_BUFFER) {
		emit_data->output[emit_data->chan] =
			lp_build_intrinsic(
				builder, "llvm.amdgcn.buffer.load.format.v4f32", emit_data->dst_type,
				emit_data->args, emit_data->arg_count,
				LLVMReadOnlyAttribute);
	} else {
		build_int_type_name(LLVMTypeOf(emit_data->args[0]),
				    coords_type, sizeof(coords_type));

		snprintf(intrinsic_name, sizeof(intrinsic_name),
			 "llvm.amdgcn.image.load.%s", coords_type);

		emit_data->output[emit_data->chan] =
			lp_build_intrinsic(
				builder, intrinsic_name, emit_data->dst_type,
				emit_data->args, emit_data->arg_count,
				LLVMReadOnlyAttribute);
	}
}

static void store_fetch_args(
		struct lp_build_tgsi_context * bld_base,
		struct lp_build_emit_data * emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	const struct tgsi_full_instruction * inst = emit_data->inst;
	struct tgsi_full_src_register memory;
	LLVMValueRef chans[4];
	LLVMValueRef data;
	LLVMValueRef rsrc;
	unsigned chan;

	emit_data->dst_type = LLVMVoidTypeInContext(gallivm->context);

	for (chan = 0; chan < 4; ++chan) {
		chans[chan] = lp_build_emit_fetch(bld_base, inst, 1, chan);
	}
	data = lp_build_gather_values(gallivm, chans, 4);

	emit_data->args[emit_data->arg_count++] = data;

	memory = tgsi_full_src_register_from_dst(&inst->Dst[0]);

	if (inst->Dst[0].Register.File == TGSI_FILE_BUFFER) {
		LLVMValueRef offset;
		LLVMValueRef tmp;

		rsrc = shader_buffer_fetch_rsrc(ctx, &memory);

		tmp = lp_build_emit_fetch(bld_base, inst, 0, 0);
		offset = LLVMBuildBitCast(builder, tmp, bld_base->uint_bld.elem_type, "");

		buffer_append_args(ctx, emit_data, rsrc, bld_base->uint_bld.zero,
				   offset, false);
	} else if (inst->Dst[0].Register.File == TGSI_FILE_IMAGE) {
		unsigned target = inst->Memory.Texture;
		LLVMValueRef coords;

		coords = image_fetch_coords(bld_base, inst, 0);

		if (target == TGSI_TEXTURE_BUFFER) {
			image_fetch_rsrc(bld_base, &memory, false, &rsrc);

			rsrc = extract_rsrc_top_half(ctx, rsrc);
			buffer_append_args(ctx, emit_data, rsrc, coords,
					bld_base->uint_bld.zero, false);
		} else {
			emit_data->args[1] = coords;
			image_fetch_rsrc(bld_base, &memory, true, &emit_data->args[2]);
			emit_data->args[3] = lp_build_const_int32(gallivm, 15); /* dmask */
			emit_data->arg_count = 4;

			image_append_args(ctx, emit_data, target, false);
		}
	}
}

static void store_emit_buffer(
		struct si_shader_context *ctx,
		struct lp_build_emit_data *emit_data)
{
	const struct tgsi_full_instruction *inst = emit_data->inst;
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	struct lp_build_context *uint_bld = &ctx->radeon_bld.soa.bld_base.uint_bld;
	LLVMValueRef base_data = emit_data->args[0];
	LLVMValueRef base_offset = emit_data->args[3];
	unsigned writemask = inst->Dst[0].Register.WriteMask;

	while (writemask) {
		int start, count;
		const char *intrinsic_name;
		LLVMValueRef data;
		LLVMValueRef offset;
		LLVMValueRef tmp;

		u_bit_scan_consecutive_range(&writemask, &start, &count);

		/* Due to an LLVM limitation, split 3-element writes
		 * into a 2-element and a 1-element write. */
		if (count == 3) {
			writemask |= 1 << (start + 2);
			count = 2;
		}

		if (count == 4) {
			data = base_data;
			intrinsic_name = "llvm.amdgcn.buffer.store.v4f32";
		} else if (count == 2) {
			LLVMTypeRef v2f32 = LLVMVectorType(ctx->f32, 2);

			tmp = LLVMBuildExtractElement(
				builder, base_data,
				lp_build_const_int32(gallivm, start), "");
			data = LLVMBuildInsertElement(
				builder, LLVMGetUndef(v2f32), tmp,
				uint_bld->zero, "");

			tmp = LLVMBuildExtractElement(
				builder, base_data,
				lp_build_const_int32(gallivm, start + 1), "");
			data = LLVMBuildInsertElement(
				builder, data, tmp, uint_bld->one, "");

			intrinsic_name = "llvm.amdgcn.buffer.store.v2f32";
		} else {
			assert(count == 1);
			data = LLVMBuildExtractElement(
				builder, base_data,
				lp_build_const_int32(gallivm, start), "");
			intrinsic_name = "llvm.amdgcn.buffer.store.f32";
		}

		offset = base_offset;
		if (start != 0) {
			offset = LLVMBuildAdd(
				builder, offset,
				lp_build_const_int32(gallivm, start * 4), "");
		}

		emit_data->args[0] = data;
		emit_data->args[3] = offset;

		lp_build_intrinsic(
			builder, intrinsic_name, emit_data->dst_type,
			emit_data->args, emit_data->arg_count, 0);
	}
}

static void store_emit_memory(
		struct si_shader_context *ctx,
		struct lp_build_emit_data *emit_data)
{
	const struct tgsi_full_instruction *inst = emit_data->inst;
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	struct lp_build_context *base = &ctx->radeon_bld.soa.bld_base.base;
	LLVMBuilderRef builder = gallivm->builder;
	unsigned writemask = inst->Dst[0].Register.WriteMask;
	LLVMValueRef ptr, derived_ptr, data, index;
	int chan;

	ptr = get_memory_ptr(ctx, inst, base->elem_type, 0);

	for (chan = 0; chan < 4; ++chan) {
		if (!(writemask & (1 << chan))) {
			continue;
		}
		data = lp_build_emit_fetch(&ctx->radeon_bld.soa.bld_base, inst, 1, chan);
		index = lp_build_const_int32(gallivm, chan);
		derived_ptr = LLVMBuildGEP(builder, ptr, &index, 1, "");
		LLVMBuildStore(builder, data, derived_ptr);
	}
}

static void store_emit(
		const struct lp_build_tgsi_action *action,
		struct lp_build_tgsi_context *bld_base,
		struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	const struct tgsi_full_instruction * inst = emit_data->inst;
	unsigned target = inst->Memory.Texture;
	char intrinsic_name[32];
	char coords_type[8];

	if (inst->Dst[0].Register.File == TGSI_FILE_MEMORY) {
		store_emit_memory(ctx, emit_data);
		return;
	}

	if (inst->Memory.Qualifier & TGSI_MEMORY_VOLATILE)
		emit_waitcnt(ctx);

	if (inst->Dst[0].Register.File == TGSI_FILE_BUFFER) {
		store_emit_buffer(ctx, emit_data);
		return;
	}

	if (target == TGSI_TEXTURE_BUFFER) {
		emit_data->output[emit_data->chan] = lp_build_intrinsic(
			builder, "llvm.amdgcn.buffer.store.format.v4f32",
			emit_data->dst_type, emit_data->args,
			emit_data->arg_count, 0);
	} else {
		build_int_type_name(LLVMTypeOf(emit_data->args[1]),
				    coords_type, sizeof(coords_type));
		snprintf(intrinsic_name, sizeof(intrinsic_name),
			 "llvm.amdgcn.image.store.%s", coords_type);

		emit_data->output[emit_data->chan] =
			lp_build_intrinsic(
				builder, intrinsic_name, emit_data->dst_type,
				emit_data->args, emit_data->arg_count, 0);
	}
}

static void atomic_fetch_args(
		struct lp_build_tgsi_context * bld_base,
		struct lp_build_emit_data * emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	const struct tgsi_full_instruction * inst = emit_data->inst;
	LLVMValueRef data1, data2;
	LLVMValueRef rsrc;
	LLVMValueRef tmp;

	emit_data->dst_type = bld_base->base.elem_type;

	tmp = lp_build_emit_fetch(bld_base, inst, 2, 0);
	data1 = LLVMBuildBitCast(builder, tmp, bld_base->uint_bld.elem_type, "");

	if (inst->Instruction.Opcode == TGSI_OPCODE_ATOMCAS) {
		tmp = lp_build_emit_fetch(bld_base, inst, 3, 0);
		data2 = LLVMBuildBitCast(builder, tmp, bld_base->uint_bld.elem_type, "");
	}

	/* llvm.amdgcn.image/buffer.atomic.cmpswap reflect the hardware order
	 * of arguments, which is reversed relative to TGSI (and GLSL)
	 */
	if (inst->Instruction.Opcode == TGSI_OPCODE_ATOMCAS)
		emit_data->args[emit_data->arg_count++] = data2;
	emit_data->args[emit_data->arg_count++] = data1;

	if (inst->Src[0].Register.File == TGSI_FILE_BUFFER) {
		LLVMValueRef offset;

		rsrc = shader_buffer_fetch_rsrc(ctx, &inst->Src[0]);

		tmp = lp_build_emit_fetch(bld_base, inst, 1, 0);
		offset = LLVMBuildBitCast(builder, tmp, bld_base->uint_bld.elem_type, "");

		buffer_append_args(ctx, emit_data, rsrc, bld_base->uint_bld.zero,
				   offset, true);
	} else if (inst->Src[0].Register.File == TGSI_FILE_IMAGE) {
		unsigned target = inst->Memory.Texture;
		LLVMValueRef coords;

		image_fetch_rsrc(bld_base, &inst->Src[0],
				 target != TGSI_TEXTURE_BUFFER, &rsrc);
		coords = image_fetch_coords(bld_base, inst, 1);

		if (target == TGSI_TEXTURE_BUFFER) {
			rsrc = extract_rsrc_top_half(ctx, rsrc);
			buffer_append_args(ctx, emit_data, rsrc, coords,
					   bld_base->uint_bld.zero, true);
		} else {
			emit_data->args[emit_data->arg_count++] = coords;
			emit_data->args[emit_data->arg_count++] = rsrc;

			image_append_args(ctx, emit_data, target, true);
		}
	}
}

static void atomic_emit_memory(struct si_shader_context *ctx,
                               struct lp_build_emit_data *emit_data) {
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	const struct tgsi_full_instruction * inst = emit_data->inst;
	LLVMValueRef ptr, result, arg;

	ptr = get_memory_ptr(ctx, inst, ctx->i32, 1);

	arg = lp_build_emit_fetch(&ctx->radeon_bld.soa.bld_base, inst, 2, 0);
	arg = LLVMBuildBitCast(builder, arg, ctx->i32, "");

	if (inst->Instruction.Opcode == TGSI_OPCODE_ATOMCAS) {
		LLVMValueRef new_data;
		new_data = lp_build_emit_fetch(&ctx->radeon_bld.soa.bld_base,
		                               inst, 3, 0);

		new_data = LLVMBuildBitCast(builder, new_data, ctx->i32, "");

#if HAVE_LLVM >= 0x309
		result = LLVMBuildAtomicCmpXchg(builder, ptr, arg, new_data,
		                       LLVMAtomicOrderingSequentiallyConsistent,
		                       LLVMAtomicOrderingSequentiallyConsistent,
		                       false);
#endif

		result = LLVMBuildExtractValue(builder, result, 0, "");
	} else {
		LLVMAtomicRMWBinOp op;

		switch(inst->Instruction.Opcode) {
			case TGSI_OPCODE_ATOMUADD:
				op = LLVMAtomicRMWBinOpAdd;
				break;
			case TGSI_OPCODE_ATOMXCHG:
				op = LLVMAtomicRMWBinOpXchg;
				break;
			case TGSI_OPCODE_ATOMAND:
				op = LLVMAtomicRMWBinOpAnd;
				break;
			case TGSI_OPCODE_ATOMOR:
				op = LLVMAtomicRMWBinOpOr;
				break;
			case TGSI_OPCODE_ATOMXOR:
				op = LLVMAtomicRMWBinOpXor;
				break;
			case TGSI_OPCODE_ATOMUMIN:
				op = LLVMAtomicRMWBinOpUMin;
				break;
			case TGSI_OPCODE_ATOMUMAX:
				op = LLVMAtomicRMWBinOpUMax;
				break;
			case TGSI_OPCODE_ATOMIMIN:
				op = LLVMAtomicRMWBinOpMin;
				break;
			case TGSI_OPCODE_ATOMIMAX:
				op = LLVMAtomicRMWBinOpMax;
				break;
			default:
				unreachable("unknown atomic opcode");
		}

		result = LLVMBuildAtomicRMW(builder, op, ptr, arg,
		                       LLVMAtomicOrderingSequentiallyConsistent,
		                       false);
	}
	emit_data->output[emit_data->chan] = LLVMBuildBitCast(builder, result, emit_data->dst_type, "");
}

static void atomic_emit(
		const struct lp_build_tgsi_action *action,
		struct lp_build_tgsi_context *bld_base,
		struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	const struct tgsi_full_instruction * inst = emit_data->inst;
	char intrinsic_name[40];
	LLVMValueRef tmp;

	if (inst->Src[0].Register.File == TGSI_FILE_MEMORY) {
		atomic_emit_memory(ctx, emit_data);
		return;
	}

	if (inst->Src[0].Register.File == TGSI_FILE_BUFFER ||
	    inst->Memory.Texture == TGSI_TEXTURE_BUFFER) {
		snprintf(intrinsic_name, sizeof(intrinsic_name),
			 "llvm.amdgcn.buffer.atomic.%s", action->intr_name);
	} else {
		char coords_type[8];

		build_int_type_name(LLVMTypeOf(emit_data->args[1]),
				    coords_type, sizeof(coords_type));
		snprintf(intrinsic_name, sizeof(intrinsic_name),
			 "llvm.amdgcn.image.atomic.%s.%s",
			 action->intr_name, coords_type);
	}

	tmp = lp_build_intrinsic(
		builder, intrinsic_name, bld_base->uint_bld.elem_type,
		emit_data->args, emit_data->arg_count, 0);
	emit_data->output[emit_data->chan] =
		LLVMBuildBitCast(builder, tmp, bld_base->base.elem_type, "");
}

static void resq_fetch_args(
		struct lp_build_tgsi_context * bld_base,
		struct lp_build_emit_data * emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	const struct tgsi_full_instruction *inst = emit_data->inst;
	const struct tgsi_full_src_register *reg = &inst->Src[0];

	emit_data->dst_type = LLVMVectorType(bld_base->base.elem_type, 4);

	if (reg->Register.File == TGSI_FILE_BUFFER) {
		emit_data->args[0] = shader_buffer_fetch_rsrc(ctx, reg);
		emit_data->arg_count = 1;
	} else if (inst->Memory.Texture == TGSI_TEXTURE_BUFFER) {
		image_fetch_rsrc(bld_base, reg, false, &emit_data->args[0]);
		emit_data->arg_count = 1;
	} else {
		emit_data->args[0] = bld_base->uint_bld.zero; /* mip level */
		image_fetch_rsrc(bld_base, reg, false, &emit_data->args[1]);
		emit_data->args[2] = lp_build_const_int32(gallivm, 15); /* dmask */
		emit_data->args[3] = bld_base->uint_bld.zero; /* unorm */
		emit_data->args[4] = bld_base->uint_bld.zero; /* r128 */
		emit_data->args[5] = tgsi_is_array_image(inst->Memory.Texture) ?
			bld_base->uint_bld.one : bld_base->uint_bld.zero; /* da */
		emit_data->args[6] = bld_base->uint_bld.zero; /* glc */
		emit_data->args[7] = bld_base->uint_bld.zero; /* slc */
		emit_data->args[8] = bld_base->uint_bld.zero; /* tfe */
		emit_data->args[9] = bld_base->uint_bld.zero; /* lwe */
		emit_data->arg_count = 10;
	}
}

static void resq_emit(
		const struct lp_build_tgsi_action *action,
		struct lp_build_tgsi_context *bld_base,
		struct lp_build_emit_data *emit_data)
{
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	const struct tgsi_full_instruction *inst = emit_data->inst;
	LLVMValueRef out;

	if (inst->Src[0].Register.File == TGSI_FILE_BUFFER) {
		out = LLVMBuildExtractElement(builder, emit_data->args[0],
					      lp_build_const_int32(gallivm, 2), "");
	} else if (inst->Memory.Texture == TGSI_TEXTURE_BUFFER) {
		out = get_buffer_size(bld_base, emit_data->args[0]);
	} else {
		out = lp_build_intrinsic(
			builder, "llvm.SI.getresinfo.i32", emit_data->dst_type,
			emit_data->args, emit_data->arg_count,
			LLVMReadNoneAttribute);

		/* Divide the number of layers by 6 to get the number of cubes. */
		if (inst->Memory.Texture == TGSI_TEXTURE_CUBE_ARRAY) {
			LLVMValueRef imm2 = lp_build_const_int32(gallivm, 2);
			LLVMValueRef imm6 = lp_build_const_int32(gallivm, 6);

			LLVMValueRef z = LLVMBuildExtractElement(builder, out, imm2, "");
			z = LLVMBuildBitCast(builder, z, bld_base->uint_bld.elem_type, "");
			z = LLVMBuildSDiv(builder, z, imm6, "");
			z = LLVMBuildBitCast(builder, z, bld_base->base.elem_type, "");
			out = LLVMBuildInsertElement(builder, out, z, imm2, "");
		}
	}

	emit_data->output[emit_data->chan] = out;
}

static void set_tex_fetch_args(struct si_shader_context *ctx,
			       struct lp_build_emit_data *emit_data,
			       unsigned opcode, unsigned target,
			       LLVMValueRef res_ptr, LLVMValueRef samp_ptr,
			       LLVMValueRef *param, unsigned count,
			       unsigned dmask)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	unsigned num_args;
	unsigned is_rect = target == TGSI_TEXTURE_RECT;

	/* Pad to power of two vector */
	while (count < util_next_power_of_two(count))
		param[count++] = LLVMGetUndef(ctx->i32);

	/* Texture coordinates. */
	if (count > 1)
		emit_data->args[0] = lp_build_gather_values(gallivm, param, count);
	else
		emit_data->args[0] = param[0];

	/* Resource. */
	emit_data->args[1] = res_ptr;
	num_args = 2;

	if (opcode == TGSI_OPCODE_TXF || opcode == TGSI_OPCODE_TXQ)
		emit_data->dst_type = ctx->v4i32;
	else {
		emit_data->dst_type = ctx->v4f32;

		emit_data->args[num_args++] = samp_ptr;
	}

	emit_data->args[num_args++] = lp_build_const_int32(gallivm, dmask);
	emit_data->args[num_args++] = lp_build_const_int32(gallivm, is_rect); /* unorm */
	emit_data->args[num_args++] = lp_build_const_int32(gallivm, 0); /* r128 */
	emit_data->args[num_args++] = lp_build_const_int32(gallivm,
					tgsi_is_array_sampler(target)); /* da */
	emit_data->args[num_args++] = lp_build_const_int32(gallivm, 0); /* glc */
	emit_data->args[num_args++] = lp_build_const_int32(gallivm, 0); /* slc */
	emit_data->args[num_args++] = lp_build_const_int32(gallivm, 0); /* tfe */
	emit_data->args[num_args++] = lp_build_const_int32(gallivm, 0); /* lwe */

	emit_data->arg_count = num_args;
}

static const struct lp_build_tgsi_action tex_action;

enum desc_type {
	DESC_IMAGE,
	DESC_FMASK,
	DESC_SAMPLER
};

static LLVMTypeRef const_array(LLVMTypeRef elem_type, int num_elements)
{
	return LLVMPointerType(LLVMArrayType(elem_type, num_elements),
			       CONST_ADDR_SPACE);
}

/**
 * Load an image view, fmask view. or sampler state descriptor.
 */
static LLVMValueRef get_sampler_desc_custom(struct si_shader_context *ctx,
					    LLVMValueRef list, LLVMValueRef index,
					    enum desc_type type)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMBuilderRef builder = gallivm->builder;

	switch (type) {
	case DESC_IMAGE:
		/* The image is at [0:7]. */
		index = LLVMBuildMul(builder, index, LLVMConstInt(ctx->i32, 2, 0), "");
		break;
	case DESC_FMASK:
		/* The FMASK is at [8:15]. */
		index = LLVMBuildMul(builder, index, LLVMConstInt(ctx->i32, 2, 0), "");
		index = LLVMBuildAdd(builder, index, LLVMConstInt(ctx->i32, 1, 0), "");
		break;
	case DESC_SAMPLER:
		/* The sampler state is at [12:15]. */
		index = LLVMBuildMul(builder, index, LLVMConstInt(ctx->i32, 4, 0), "");
		index = LLVMBuildAdd(builder, index, LLVMConstInt(ctx->i32, 3, 0), "");
		list = LLVMBuildPointerCast(builder, list,
					    const_array(ctx->v4i32, 0), "");
		break;
	}

	return build_indexed_load_const(ctx, list, index);
}

static LLVMValueRef get_sampler_desc(struct si_shader_context *ctx,
				     LLVMValueRef index, enum desc_type type)
{
	LLVMValueRef list = LLVMGetParam(ctx->radeon_bld.main_fn,
					 SI_PARAM_SAMPLERS);

	return get_sampler_desc_custom(ctx, list, index, type);
}

/* Disable anisotropic filtering if BASE_LEVEL == LAST_LEVEL.
 *
 * SI-CI:
 *   If BASE_LEVEL == LAST_LEVEL, the shader must disable anisotropic
 *   filtering manually. The driver sets img7 to a mask clearing
 *   MAX_ANISO_RATIO if BASE_LEVEL == LAST_LEVEL. The shader must do:
 *     s_and_b32 samp0, samp0, img7
 *
 * VI:
 *   The ANISO_OVERRIDE sampler field enables this fix in TA.
 */
static LLVMValueRef sici_fix_sampler_aniso(struct si_shader_context *ctx,
					   LLVMValueRef res, LLVMValueRef samp)
{
	LLVMBuilderRef builder = ctx->radeon_bld.gallivm.builder;
	LLVMValueRef img7, samp0;

	if (ctx->screen->b.chip_class >= VI)
		return samp;

	img7 = LLVMBuildExtractElement(builder, res,
				       LLVMConstInt(ctx->i32, 7, 0), "");
	samp0 = LLVMBuildExtractElement(builder, samp,
					LLVMConstInt(ctx->i32, 0, 0), "");
	samp0 = LLVMBuildAnd(builder, samp0, img7, "");
	return LLVMBuildInsertElement(builder, samp, samp0,
				      LLVMConstInt(ctx->i32, 0, 0), "");
}

static void tex_fetch_ptrs(
	struct lp_build_tgsi_context *bld_base,
	struct lp_build_emit_data *emit_data,
	LLVMValueRef *res_ptr, LLVMValueRef *samp_ptr, LLVMValueRef *fmask_ptr)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	const struct tgsi_full_instruction *inst = emit_data->inst;
	unsigned target = inst->Texture.Texture;
	unsigned sampler_src;
	unsigned sampler_index;

	sampler_src = emit_data->inst->Instruction.NumSrcRegs - 1;
	sampler_index = emit_data->inst->Src[sampler_src].Register.Index;

	if (emit_data->inst->Src[sampler_src].Register.Indirect) {
		const struct tgsi_full_src_register *reg = &emit_data->inst->Src[sampler_src];
		LLVMValueRef ind_index;

		ind_index = get_bounded_indirect_index(ctx,
						       &reg->Indirect,
						       reg->Register.Index,
						       SI_NUM_SAMPLERS);

		*res_ptr = get_sampler_desc(ctx, ind_index, DESC_IMAGE);

		if (target == TGSI_TEXTURE_2D_MSAA ||
		    target == TGSI_TEXTURE_2D_ARRAY_MSAA) {
			if (samp_ptr)
				*samp_ptr = NULL;
			if (fmask_ptr)
				*fmask_ptr = get_sampler_desc(ctx, ind_index, DESC_FMASK);
		} else {
			if (samp_ptr) {
				*samp_ptr = get_sampler_desc(ctx, ind_index, DESC_SAMPLER);
				*samp_ptr = sici_fix_sampler_aniso(ctx, *res_ptr, *samp_ptr);
			}
			if (fmask_ptr)
				*fmask_ptr = NULL;
		}
	} else {
		*res_ptr = ctx->sampler_views[sampler_index];
		if (samp_ptr)
			*samp_ptr = ctx->sampler_states[sampler_index];
		if (fmask_ptr)
			*fmask_ptr = ctx->fmasks[sampler_index];
	}
}

static void txq_fetch_args(
	struct lp_build_tgsi_context *bld_base,
	struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	const struct tgsi_full_instruction *inst = emit_data->inst;
	unsigned target = inst->Texture.Texture;
	LLVMValueRef res_ptr;
	LLVMValueRef address;

	tex_fetch_ptrs(bld_base, emit_data, &res_ptr, NULL, NULL);

	if (target == TGSI_TEXTURE_BUFFER) {
		/* Read the size from the buffer descriptor directly. */
		LLVMValueRef res = LLVMBuildBitCast(builder, res_ptr, ctx->v8i32, "");
		emit_data->args[0] = get_buffer_size(bld_base, res);
		return;
	}

	/* Textures - set the mip level. */
	address = lp_build_emit_fetch(bld_base, inst, 0, TGSI_CHAN_X);

	set_tex_fetch_args(ctx, emit_data, TGSI_OPCODE_TXQ, target, res_ptr,
			   NULL, &address, 1, 0xf);
}

static void txq_emit(const struct lp_build_tgsi_action *action,
		     struct lp_build_tgsi_context *bld_base,
		     struct lp_build_emit_data *emit_data)
{
	struct lp_build_context *base = &bld_base->base;
	unsigned target = emit_data->inst->Texture.Texture;

	if (target == TGSI_TEXTURE_BUFFER) {
		/* Just return the buffer size. */
		emit_data->output[emit_data->chan] = emit_data->args[0];
		return;
	}

	emit_data->output[emit_data->chan] = lp_build_intrinsic(
		base->gallivm->builder, "llvm.SI.getresinfo.i32",
		emit_data->dst_type, emit_data->args, emit_data->arg_count,
		LLVMReadNoneAttribute);

	/* Divide the number of layers by 6 to get the number of cubes. */
	if (target == TGSI_TEXTURE_CUBE_ARRAY ||
	    target == TGSI_TEXTURE_SHADOWCUBE_ARRAY) {
		LLVMBuilderRef builder = bld_base->base.gallivm->builder;
		LLVMValueRef two = lp_build_const_int32(bld_base->base.gallivm, 2);
		LLVMValueRef six = lp_build_const_int32(bld_base->base.gallivm, 6);

		LLVMValueRef v4 = emit_data->output[emit_data->chan];
		LLVMValueRef z = LLVMBuildExtractElement(builder, v4, two, "");
		z = LLVMBuildSDiv(builder, z, six, "");

		emit_data->output[emit_data->chan] =
			LLVMBuildInsertElement(builder, v4, z, two, "");
	}
}

static void tex_fetch_args(
	struct lp_build_tgsi_context *bld_base,
	struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	const struct tgsi_full_instruction *inst = emit_data->inst;
	unsigned opcode = inst->Instruction.Opcode;
	unsigned target = inst->Texture.Texture;
	LLVMValueRef coords[5], derivs[6];
	LLVMValueRef address[16];
	unsigned num_coords = tgsi_util_get_texture_coord_dim(target);
	int ref_pos = tgsi_util_get_shadow_ref_src_index(target);
	unsigned count = 0;
	unsigned chan;
	unsigned num_deriv_channels = 0;
	bool has_offset = inst->Texture.NumOffsets > 0;
	LLVMValueRef res_ptr, samp_ptr, fmask_ptr = NULL;
	unsigned dmask = 0xf;

	tex_fetch_ptrs(bld_base, emit_data, &res_ptr, &samp_ptr, &fmask_ptr);

	if (target == TGSI_TEXTURE_BUFFER) {
		LLVMTypeRef v2i128 = LLVMVectorType(ctx->i128, 2);

		/* Bitcast and truncate v8i32 to v16i8. */
		LLVMValueRef res = res_ptr;
		res = LLVMBuildBitCast(gallivm->builder, res, v2i128, "");
		res = LLVMBuildExtractElement(gallivm->builder, res, bld_base->uint_bld.one, "");
		res = LLVMBuildBitCast(gallivm->builder, res, ctx->v16i8, "");

		emit_data->dst_type = ctx->v4f32;
		emit_data->args[0] = res;
		emit_data->args[1] = bld_base->uint_bld.zero;
		emit_data->args[2] = lp_build_emit_fetch(bld_base, emit_data->inst, 0, TGSI_CHAN_X);
		emit_data->arg_count = 3;
		return;
	}

	/* Fetch and project texture coordinates */
	coords[3] = lp_build_emit_fetch(bld_base, emit_data->inst, 0, TGSI_CHAN_W);
	for (chan = 0; chan < 3; chan++ ) {
		coords[chan] = lp_build_emit_fetch(bld_base,
						   emit_data->inst, 0,
						   chan);
		if (opcode == TGSI_OPCODE_TXP)
			coords[chan] = lp_build_emit_llvm_binary(bld_base,
								 TGSI_OPCODE_DIV,
								 coords[chan],
								 coords[3]);
	}

	if (opcode == TGSI_OPCODE_TXP)
		coords[3] = bld_base->base.one;

	/* Pack offsets. */
	if (has_offset && opcode != TGSI_OPCODE_TXF) {
		/* The offsets are six-bit signed integers packed like this:
		 *   X=[5:0], Y=[13:8], and Z=[21:16].
		 */
		LLVMValueRef offset[3], pack;

		assert(inst->Texture.NumOffsets == 1);

		for (chan = 0; chan < 3; chan++) {
			offset[chan] = lp_build_emit_fetch_texoffset(bld_base,
								     emit_data->inst, 0, chan);
			offset[chan] = LLVMBuildAnd(gallivm->builder, offset[chan],
						    lp_build_const_int32(gallivm, 0x3f), "");
			if (chan)
				offset[chan] = LLVMBuildShl(gallivm->builder, offset[chan],
							    lp_build_const_int32(gallivm, chan*8), "");
		}

		pack = LLVMBuildOr(gallivm->builder, offset[0], offset[1], "");
		pack = LLVMBuildOr(gallivm->builder, pack, offset[2], "");
		address[count++] = pack;
	}

	/* Pack LOD bias value */
	if (opcode == TGSI_OPCODE_TXB)
		address[count++] = coords[3];
	if (opcode == TGSI_OPCODE_TXB2)
		address[count++] = lp_build_emit_fetch(bld_base, inst, 1, TGSI_CHAN_X);

	/* Pack depth comparison value */
	if (tgsi_is_shadow_target(target) && opcode != TGSI_OPCODE_LODQ) {
		if (target == TGSI_TEXTURE_SHADOWCUBE_ARRAY) {
			address[count++] = lp_build_emit_fetch(bld_base, inst, 1, TGSI_CHAN_X);
		} else {
			assert(ref_pos >= 0);
			address[count++] = coords[ref_pos];
		}
	}

	/* Pack user derivatives */
	if (opcode == TGSI_OPCODE_TXD) {
		int param, num_src_deriv_channels;

		switch (target) {
		case TGSI_TEXTURE_3D:
			num_src_deriv_channels = 3;
			num_deriv_channels = 3;
			break;
		case TGSI_TEXTURE_2D:
		case TGSI_TEXTURE_SHADOW2D:
		case TGSI_TEXTURE_RECT:
		case TGSI_TEXTURE_SHADOWRECT:
		case TGSI_TEXTURE_2D_ARRAY:
		case TGSI_TEXTURE_SHADOW2D_ARRAY:
			num_src_deriv_channels = 2;
			num_deriv_channels = 2;
			break;
		case TGSI_TEXTURE_CUBE:
		case TGSI_TEXTURE_SHADOWCUBE:
		case TGSI_TEXTURE_CUBE_ARRAY:
		case TGSI_TEXTURE_SHADOWCUBE_ARRAY:
			/* Cube derivatives will be converted to 2D. */
			num_src_deriv_channels = 3;
			num_deriv_channels = 2;
			break;
		case TGSI_TEXTURE_1D:
		case TGSI_TEXTURE_SHADOW1D:
		case TGSI_TEXTURE_1D_ARRAY:
		case TGSI_TEXTURE_SHADOW1D_ARRAY:
			num_src_deriv_channels = 1;
			num_deriv_channels = 1;
			break;
		default:
			unreachable("invalid target");
		}

		for (param = 0; param < 2; param++)
			for (chan = 0; chan < num_src_deriv_channels; chan++)
				derivs[param * num_src_deriv_channels + chan] =
					lp_build_emit_fetch(bld_base, inst, param+1, chan);
	}

	if (target == TGSI_TEXTURE_CUBE ||
	    target == TGSI_TEXTURE_CUBE_ARRAY ||
	    target == TGSI_TEXTURE_SHADOWCUBE ||
	    target == TGSI_TEXTURE_SHADOWCUBE_ARRAY)
		radeon_llvm_emit_prepare_cube_coords(bld_base, emit_data, coords, derivs);

	if (opcode == TGSI_OPCODE_TXD)
		for (int i = 0; i < num_deriv_channels * 2; i++)
			address[count++] = derivs[i];

	/* Pack texture coordinates */
	address[count++] = coords[0];
	if (num_coords > 1)
		address[count++] = coords[1];
	if (num_coords > 2)
		address[count++] = coords[2];

	/* Pack LOD or sample index */
	if (opcode == TGSI_OPCODE_TXL || opcode == TGSI_OPCODE_TXF)
		address[count++] = coords[3];
	else if (opcode == TGSI_OPCODE_TXL2)
		address[count++] = lp_build_emit_fetch(bld_base, inst, 1, TGSI_CHAN_X);

	if (count > 16) {
		assert(!"Cannot handle more than 16 texture address parameters");
		count = 16;
	}

	for (chan = 0; chan < count; chan++ ) {
		address[chan] = LLVMBuildBitCast(gallivm->builder,
						 address[chan], ctx->i32, "");
	}

	/* Adjust the sample index according to FMASK.
	 *
	 * For uncompressed MSAA surfaces, FMASK should return 0x76543210,
	 * which is the identity mapping. Each nibble says which physical sample
	 * should be fetched to get that sample.
	 *
	 * For example, 0x11111100 means there are only 2 samples stored and
	 * the second sample covers 3/4 of the pixel. When reading samples 0
	 * and 1, return physical sample 0 (determined by the first two 0s
	 * in FMASK), otherwise return physical sample 1.
	 *
	 * The sample index should be adjusted as follows:
	 *   sample_index = (fmask >> (sample_index * 4)) & 0xF;
	 */
	if (target == TGSI_TEXTURE_2D_MSAA ||
	    target == TGSI_TEXTURE_2D_ARRAY_MSAA) {
		struct lp_build_context *uint_bld = &bld_base->uint_bld;
		struct lp_build_emit_data txf_emit_data = *emit_data;
		LLVMValueRef txf_address[4];
		unsigned txf_count = count;
		struct tgsi_full_instruction inst = {};

		memcpy(txf_address, address, sizeof(txf_address));

		if (target == TGSI_TEXTURE_2D_MSAA) {
			txf_address[2] = bld_base->uint_bld.zero;
		}
		txf_address[3] = bld_base->uint_bld.zero;

		/* Read FMASK using TXF. */
		inst.Instruction.Opcode = TGSI_OPCODE_TXF;
		inst.Texture.Texture = target;
		txf_emit_data.inst = &inst;
		txf_emit_data.chan = 0;
		set_tex_fetch_args(ctx, &txf_emit_data, TGSI_OPCODE_TXF,
				   target, fmask_ptr, NULL,
				   txf_address, txf_count, 0xf);
		build_tex_intrinsic(&tex_action, bld_base, &txf_emit_data);

		/* Initialize some constants. */
		LLVMValueRef four = LLVMConstInt(ctx->i32, 4, 0);
		LLVMValueRef F = LLVMConstInt(ctx->i32, 0xF, 0);

		/* Apply the formula. */
		LLVMValueRef fmask =
			LLVMBuildExtractElement(gallivm->builder,
						txf_emit_data.output[0],
						uint_bld->zero, "");

		unsigned sample_chan = target == TGSI_TEXTURE_2D_MSAA ? 2 : 3;

		LLVMValueRef sample_index4 =
			LLVMBuildMul(gallivm->builder, address[sample_chan], four, "");

		LLVMValueRef shifted_fmask =
			LLVMBuildLShr(gallivm->builder, fmask, sample_index4, "");

		LLVMValueRef final_sample =
			LLVMBuildAnd(gallivm->builder, shifted_fmask, F, "");

		/* Don't rewrite the sample index if WORD1.DATA_FORMAT of the FMASK
		 * resource descriptor is 0 (invalid),
		 */
		LLVMValueRef fmask_desc =
			LLVMBuildBitCast(gallivm->builder, fmask_ptr,
					 ctx->v8i32, "");

		LLVMValueRef fmask_word1 =
			LLVMBuildExtractElement(gallivm->builder, fmask_desc,
						uint_bld->one, "");

		LLVMValueRef word1_is_nonzero =
			LLVMBuildICmp(gallivm->builder, LLVMIntNE,
				      fmask_word1, uint_bld->zero, "");

		/* Replace the MSAA sample index. */
		address[sample_chan] =
			LLVMBuildSelect(gallivm->builder, word1_is_nonzero,
					final_sample, address[sample_chan], "");
	}

	if (opcode == TGSI_OPCODE_TXF) {
		/* add tex offsets */
		if (inst->Texture.NumOffsets) {
			struct lp_build_context *uint_bld = &bld_base->uint_bld;
			struct lp_build_tgsi_soa_context *bld = lp_soa_context(bld_base);
			const struct tgsi_texture_offset *off = inst->TexOffsets;

			assert(inst->Texture.NumOffsets == 1);

			switch (target) {
			case TGSI_TEXTURE_3D:
				address[2] = lp_build_add(uint_bld, address[2],
						bld->immediates[off->Index][off->SwizzleZ]);
				/* fall through */
			case TGSI_TEXTURE_2D:
			case TGSI_TEXTURE_SHADOW2D:
			case TGSI_TEXTURE_RECT:
			case TGSI_TEXTURE_SHADOWRECT:
			case TGSI_TEXTURE_2D_ARRAY:
			case TGSI_TEXTURE_SHADOW2D_ARRAY:
				address[1] =
					lp_build_add(uint_bld, address[1],
						bld->immediates[off->Index][off->SwizzleY]);
				/* fall through */
			case TGSI_TEXTURE_1D:
			case TGSI_TEXTURE_SHADOW1D:
			case TGSI_TEXTURE_1D_ARRAY:
			case TGSI_TEXTURE_SHADOW1D_ARRAY:
				address[0] =
					lp_build_add(uint_bld, address[0],
						bld->immediates[off->Index][off->SwizzleX]);
				break;
				/* texture offsets do not apply to other texture targets */
			}
		}
	}

	if (opcode == TGSI_OPCODE_TG4) {
		unsigned gather_comp = 0;

		/* DMASK was repurposed for GATHER4. 4 components are always
		 * returned and DMASK works like a swizzle - it selects
		 * the component to fetch. The only valid DMASK values are
		 * 1=red, 2=green, 4=blue, 8=alpha. (e.g. 1 returns
		 * (red,red,red,red) etc.) The ISA document doesn't mention
		 * this.
		 */

		/* Get the component index from src1.x for Gather4. */
		if (!tgsi_is_shadow_target(target)) {
			LLVMValueRef (*imms)[4] = lp_soa_context(bld_base)->immediates;
			LLVMValueRef comp_imm;
			struct tgsi_src_register src1 = inst->Src[1].Register;

			assert(src1.File == TGSI_FILE_IMMEDIATE);

			comp_imm = imms[src1.Index][src1.SwizzleX];
			gather_comp = LLVMConstIntGetZExtValue(comp_imm);
			gather_comp = CLAMP(gather_comp, 0, 3);
		}

		dmask = 1 << gather_comp;
	}

	set_tex_fetch_args(ctx, emit_data, opcode, target, res_ptr,
			   samp_ptr, address, count, dmask);
}

static void build_tex_intrinsic(const struct lp_build_tgsi_action *action,
				struct lp_build_tgsi_context *bld_base,
				struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct lp_build_context *base = &bld_base->base;
	unsigned opcode = emit_data->inst->Instruction.Opcode;
	unsigned target = emit_data->inst->Texture.Texture;
	char intr_name[127];
	bool has_offset = emit_data->inst->Texture.NumOffsets > 0;
	bool is_shadow = tgsi_is_shadow_target(target);
	char type[64];
	const char *name = "llvm.SI.image.sample";
	const char *infix = "";

	if (target == TGSI_TEXTURE_BUFFER) {
		emit_data->output[emit_data->chan] = lp_build_intrinsic(
			base->gallivm->builder,
			"llvm.SI.vs.load.input", emit_data->dst_type,
			emit_data->args, emit_data->arg_count,
			LLVMReadNoneAttribute);
		return;
	}

	switch (opcode) {
	case TGSI_OPCODE_TXF:
		name = target == TGSI_TEXTURE_2D_MSAA ||
		       target == TGSI_TEXTURE_2D_ARRAY_MSAA ?
			       "llvm.SI.image.load" :
			       "llvm.SI.image.load.mip";
		is_shadow = false;
		has_offset = false;
		break;
	case TGSI_OPCODE_LODQ:
		name = "llvm.SI.getlod";
		is_shadow = false;
		has_offset = false;
		break;
	case TGSI_OPCODE_TEX:
	case TGSI_OPCODE_TEX2:
	case TGSI_OPCODE_TXP:
		if (ctx->type != PIPE_SHADER_FRAGMENT)
			infix = ".lz";
		break;
	case TGSI_OPCODE_TXB:
	case TGSI_OPCODE_TXB2:
		assert(ctx->type == PIPE_SHADER_FRAGMENT);
		infix = ".b";
		break;
	case TGSI_OPCODE_TXL:
	case TGSI_OPCODE_TXL2:
		infix = ".l";
		break;
	case TGSI_OPCODE_TXD:
		infix = ".d";
		break;
	case TGSI_OPCODE_TG4:
		name = "llvm.SI.gather4";
		infix = ".lz";
		break;
	default:
		assert(0);
		return;
	}

	/* Add the type and suffixes .c, .o if needed. */
	build_int_type_name(LLVMTypeOf(emit_data->args[0]), type, sizeof(type));
	sprintf(intr_name, "%s%s%s%s.%s",
		name, is_shadow ? ".c" : "", infix,
		has_offset ? ".o" : "", type);

	emit_data->output[emit_data->chan] = lp_build_intrinsic(
		base->gallivm->builder, intr_name, emit_data->dst_type,
		emit_data->args, emit_data->arg_count,
		LLVMReadNoneAttribute);
}

static void si_llvm_emit_txqs(
	const struct lp_build_tgsi_action *action,
	struct lp_build_tgsi_context *bld_base,
	struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	LLVMValueRef res, samples;
	LLVMValueRef res_ptr, samp_ptr, fmask_ptr = NULL;

	tex_fetch_ptrs(bld_base, emit_data, &res_ptr, &samp_ptr, &fmask_ptr);


	/* Read the samples from the descriptor directly. */
	res = LLVMBuildBitCast(builder, res_ptr, ctx->v8i32, "");
	samples = LLVMBuildExtractElement(
		builder, res,
		lp_build_const_int32(gallivm, 3), "");
	samples = LLVMBuildLShr(builder, samples,
				lp_build_const_int32(gallivm, 16), "");
	samples = LLVMBuildAnd(builder, samples,
			       lp_build_const_int32(gallivm, 0xf), "");
	samples = LLVMBuildShl(builder, lp_build_const_int32(gallivm, 1),
			       samples, "");

	emit_data->output[emit_data->chan] = samples;
}

/*
 * SI implements derivatives using the local data store (LDS)
 * All writes to the LDS happen in all executing threads at
 * the same time. TID is the Thread ID for the current
 * thread and is a value between 0 and 63, representing
 * the thread's position in the wavefront.
 *
 * For the pixel shader threads are grouped into quads of four pixels.
 * The TIDs of the pixels of a quad are:
 *
 *  +------+------+
 *  |4n + 0|4n + 1|
 *  +------+------+
 *  |4n + 2|4n + 3|
 *  +------+------+
 *
 * So, masking the TID with 0xfffffffc yields the TID of the top left pixel
 * of the quad, masking with 0xfffffffd yields the TID of the top pixel of
 * the current pixel's column, and masking with 0xfffffffe yields the TID
 * of the left pixel of the current pixel's row.
 *
 * Adding 1 yields the TID of the pixel to the right of the left pixel, and
 * adding 2 yields the TID of the pixel below the top pixel.
 */
/* masks for thread ID. */
#define TID_MASK_TOP_LEFT 0xfffffffc
#define TID_MASK_TOP      0xfffffffd
#define TID_MASK_LEFT     0xfffffffe

static void si_llvm_emit_ddxy(
	const struct lp_build_tgsi_action *action,
	struct lp_build_tgsi_context *bld_base,
	struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	const struct tgsi_full_instruction *inst = emit_data->inst;
	unsigned opcode = inst->Instruction.Opcode;
	LLVMValueRef indices[2];
	LLVMValueRef store_ptr, load_ptr0, load_ptr1;
	LLVMValueRef tl, trbl, result[4];
	LLVMValueRef tl_tid, trbl_tid;
	unsigned swizzle[4];
	unsigned c;
	int idx;
	unsigned mask;

	indices[0] = bld_base->uint_bld.zero;
	indices[1] = get_thread_id(ctx);
	store_ptr = LLVMBuildGEP(gallivm->builder, ctx->lds,
				 indices, 2, "");

	if (opcode == TGSI_OPCODE_DDX_FINE)
		mask = TID_MASK_LEFT;
	else if (opcode == TGSI_OPCODE_DDY_FINE)
		mask = TID_MASK_TOP;
	else
		mask = TID_MASK_TOP_LEFT;

	tl_tid = LLVMBuildAnd(gallivm->builder, indices[1],
				lp_build_const_int32(gallivm, mask), "");
	indices[1] = tl_tid;
	load_ptr0 = LLVMBuildGEP(gallivm->builder, ctx->lds,
				 indices, 2, "");

	/* for DDX we want to next X pixel, DDY next Y pixel. */
	idx = (opcode == TGSI_OPCODE_DDX || opcode == TGSI_OPCODE_DDX_FINE) ? 1 : 2;
	trbl_tid = LLVMBuildAdd(gallivm->builder, indices[1],
				  lp_build_const_int32(gallivm, idx), "");
	indices[1] = trbl_tid;
	load_ptr1 = LLVMBuildGEP(gallivm->builder, ctx->lds,
				 indices, 2, "");

	for (c = 0; c < 4; ++c) {
		unsigned i;
		LLVMValueRef val;
		LLVMValueRef args[2];

		swizzle[c] = tgsi_util_get_full_src_register_swizzle(&inst->Src[0], c);
		for (i = 0; i < c; ++i) {
			if (swizzle[i] == swizzle[c]) {
				result[c] = result[i];
				break;
			}
		}
		if (i != c)
			continue;

		val = LLVMBuildBitCast(gallivm->builder,
				lp_build_emit_fetch(bld_base, inst, 0, c),
						ctx->i32, "");

		if ((HAVE_LLVM >= 0x0309) && ctx->screen->b.family >= CHIP_TONGA) {

	                args[0] = LLVMBuildMul(gallivm->builder, tl_tid,
                                        lp_build_const_int32(gallivm, 4), "");
			args[1] = val;
			tl = lp_build_intrinsic(gallivm->builder,
					"llvm.amdgcn.ds.bpermute", ctx->i32,
					args, 2, LLVMReadNoneAttribute);

	                args[0] = LLVMBuildMul(gallivm->builder, trbl_tid,
                                        lp_build_const_int32(gallivm, 4), "");
			trbl = lp_build_intrinsic(gallivm->builder,
					"llvm.amdgcn.ds.bpermute", ctx->i32,
					args, 2, LLVMReadNoneAttribute);
		} else {
			LLVMBuildStore(gallivm->builder, val, store_ptr);
			tl = LLVMBuildLoad(gallivm->builder, load_ptr0, "");
			trbl = LLVMBuildLoad(gallivm->builder, load_ptr1, "");
		}
		tl = LLVMBuildBitCast(gallivm->builder, tl, ctx->f32, "");
		trbl = LLVMBuildBitCast(gallivm->builder, trbl,	ctx->f32, "");
		result[c] = LLVMBuildFSub(gallivm->builder, trbl, tl, "");
	}

	emit_data->output[0] = lp_build_gather_values(gallivm, result, 4);
}

/*
 * this takes an I,J coordinate pair,
 * and works out the X and Y derivatives.
 * it returns DDX(I), DDX(J), DDY(I), DDY(J).
 */
static LLVMValueRef si_llvm_emit_ddxy_interp(
	struct lp_build_tgsi_context *bld_base,
	LLVMValueRef interp_ij)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef indices[2];
	LLVMValueRef store_ptr, load_ptr_x, load_ptr_y, load_ptr_ddx, load_ptr_ddy, temp, temp2;
	LLVMValueRef tl, tr, bl, result[4];
	unsigned c;

	indices[0] = bld_base->uint_bld.zero;
	indices[1] = get_thread_id(ctx);
	store_ptr = LLVMBuildGEP(gallivm->builder, ctx->lds,
				 indices, 2, "");

	temp = LLVMBuildAnd(gallivm->builder, indices[1],
			    lp_build_const_int32(gallivm, TID_MASK_LEFT), "");

	temp2 = LLVMBuildAnd(gallivm->builder, indices[1],
			     lp_build_const_int32(gallivm, TID_MASK_TOP), "");

	indices[1] = temp;
	load_ptr_x = LLVMBuildGEP(gallivm->builder, ctx->lds,
				  indices, 2, "");

	indices[1] = temp2;
	load_ptr_y = LLVMBuildGEP(gallivm->builder, ctx->lds,
				  indices, 2, "");

	indices[1] = LLVMBuildAdd(gallivm->builder, temp,
				  lp_build_const_int32(gallivm, 1), "");
	load_ptr_ddx = LLVMBuildGEP(gallivm->builder, ctx->lds,
				   indices, 2, "");

	indices[1] = LLVMBuildAdd(gallivm->builder, temp2,
				  lp_build_const_int32(gallivm, 2), "");
	load_ptr_ddy = LLVMBuildGEP(gallivm->builder, ctx->lds,
				   indices, 2, "");

	for (c = 0; c < 2; ++c) {
		LLVMValueRef store_val;
		LLVMValueRef c_ll = lp_build_const_int32(gallivm, c);

		store_val = LLVMBuildExtractElement(gallivm->builder,
						    interp_ij, c_ll, "");
		LLVMBuildStore(gallivm->builder,
			       store_val,
			       store_ptr);

		tl = LLVMBuildLoad(gallivm->builder, load_ptr_x, "");
		tl = LLVMBuildBitCast(gallivm->builder, tl, ctx->f32, "");

		tr = LLVMBuildLoad(gallivm->builder, load_ptr_ddx, "");
		tr = LLVMBuildBitCast(gallivm->builder, tr, ctx->f32, "");

		result[c] = LLVMBuildFSub(gallivm->builder, tr, tl, "");

		tl = LLVMBuildLoad(gallivm->builder, load_ptr_y, "");
		tl = LLVMBuildBitCast(gallivm->builder, tl, ctx->f32, "");

		bl = LLVMBuildLoad(gallivm->builder, load_ptr_ddy, "");
		bl = LLVMBuildBitCast(gallivm->builder, bl, ctx->f32, "");

		result[c + 2] = LLVMBuildFSub(gallivm->builder, bl, tl, "");
	}

	return lp_build_gather_values(gallivm, result, 4);
}

static void interp_fetch_args(
	struct lp_build_tgsi_context *bld_base,
	struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	const struct tgsi_full_instruction *inst = emit_data->inst;

	if (inst->Instruction.Opcode == TGSI_OPCODE_INTERP_OFFSET) {
		/* offset is in second src, first two channels */
		emit_data->args[0] = lp_build_emit_fetch(bld_base,
							 emit_data->inst, 1,
							 TGSI_CHAN_X);
		emit_data->args[1] = lp_build_emit_fetch(bld_base,
							 emit_data->inst, 1,
							 TGSI_CHAN_Y);
		emit_data->arg_count = 2;
	} else if (inst->Instruction.Opcode == TGSI_OPCODE_INTERP_SAMPLE) {
		LLVMValueRef sample_position;
		LLVMValueRef sample_id;
		LLVMValueRef halfval = lp_build_const_float(gallivm, 0.5f);

		/* fetch sample ID, then fetch its sample position,
		 * and place into first two channels.
		 */
		sample_id = lp_build_emit_fetch(bld_base,
						emit_data->inst, 1, TGSI_CHAN_X);
		sample_id = LLVMBuildBitCast(gallivm->builder, sample_id,
					     ctx->i32, "");
		sample_position = load_sample_position(&ctx->radeon_bld, sample_id);

		emit_data->args[0] = LLVMBuildExtractElement(gallivm->builder,
							     sample_position,
							     lp_build_const_int32(gallivm, 0), "");

		emit_data->args[0] = LLVMBuildFSub(gallivm->builder, emit_data->args[0], halfval, "");
		emit_data->args[1] = LLVMBuildExtractElement(gallivm->builder,
							     sample_position,
							     lp_build_const_int32(gallivm, 1), "");
		emit_data->args[1] = LLVMBuildFSub(gallivm->builder, emit_data->args[1], halfval, "");
		emit_data->arg_count = 2;
	}
}

static void build_interp_intrinsic(const struct lp_build_tgsi_action *action,
				struct lp_build_tgsi_context *bld_base,
				struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct si_shader *shader = ctx->shader;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef interp_param;
	const struct tgsi_full_instruction *inst = emit_data->inst;
	const char *intr_name;
	int input_index = inst->Src[0].Register.Index;
	int chan;
	int i;
	LLVMValueRef attr_number;
	LLVMValueRef params = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_PRIM_MASK);
	int interp_param_idx;
	unsigned interp = shader->selector->info.input_interpolate[input_index];
	unsigned location;

	assert(inst->Src[0].Register.File == TGSI_FILE_INPUT);

	if (inst->Instruction.Opcode == TGSI_OPCODE_INTERP_OFFSET ||
	    inst->Instruction.Opcode == TGSI_OPCODE_INTERP_SAMPLE)
		location = TGSI_INTERPOLATE_LOC_CENTER;
	else
		location = TGSI_INTERPOLATE_LOC_CENTROID;

	interp_param_idx = lookup_interp_param_index(interp, location);
	if (interp_param_idx == -1)
		return;
	else if (interp_param_idx)
		interp_param = get_interp_param(ctx, interp_param_idx);
	else
		interp_param = NULL;

	attr_number = lp_build_const_int32(gallivm, input_index);

	if (inst->Instruction.Opcode == TGSI_OPCODE_INTERP_OFFSET ||
	    inst->Instruction.Opcode == TGSI_OPCODE_INTERP_SAMPLE) {
		LLVMValueRef ij_out[2];
		LLVMValueRef ddxy_out = si_llvm_emit_ddxy_interp(bld_base, interp_param);

		/*
		 * take the I then J parameters, and the DDX/Y for it, and
		 * calculate the IJ inputs for the interpolator.
		 * temp1 = ddx * offset/sample.x + I;
		 * interp_param.I = ddy * offset/sample.y + temp1;
		 * temp1 = ddx * offset/sample.x + J;
		 * interp_param.J = ddy * offset/sample.y + temp1;
		 */
		for (i = 0; i < 2; i++) {
			LLVMValueRef ix_ll = lp_build_const_int32(gallivm, i);
			LLVMValueRef iy_ll = lp_build_const_int32(gallivm, i + 2);
			LLVMValueRef ddx_el = LLVMBuildExtractElement(gallivm->builder,
								      ddxy_out, ix_ll, "");
			LLVMValueRef ddy_el = LLVMBuildExtractElement(gallivm->builder,
								      ddxy_out, iy_ll, "");
			LLVMValueRef interp_el = LLVMBuildExtractElement(gallivm->builder,
									 interp_param, ix_ll, "");
			LLVMValueRef temp1, temp2;

			interp_el = LLVMBuildBitCast(gallivm->builder, interp_el,
						     ctx->f32, "");

			temp1 = LLVMBuildFMul(gallivm->builder, ddx_el, emit_data->args[0], "");

			temp1 = LLVMBuildFAdd(gallivm->builder, temp1, interp_el, "");

			temp2 = LLVMBuildFMul(gallivm->builder, ddy_el, emit_data->args[1], "");

			temp2 = LLVMBuildFAdd(gallivm->builder, temp2, temp1, "");

			ij_out[i] = LLVMBuildBitCast(gallivm->builder,
						     temp2, ctx->i32, "");
		}
		interp_param = lp_build_gather_values(bld_base->base.gallivm, ij_out, 2);
	}

	intr_name = interp_param ? "llvm.SI.fs.interp" : "llvm.SI.fs.constant";
	for (chan = 0; chan < 2; chan++) {
		LLVMValueRef args[4];
		LLVMValueRef llvm_chan;
		unsigned schan;

		schan = tgsi_util_get_full_src_register_swizzle(&inst->Src[0], chan);
		llvm_chan = lp_build_const_int32(gallivm, schan);

		args[0] = llvm_chan;
		args[1] = attr_number;
		args[2] = params;
		args[3] = interp_param;

		emit_data->output[chan] =
			lp_build_intrinsic(gallivm->builder, intr_name,
					   ctx->f32, args, args[3] ? 4 : 3,
					   LLVMReadNoneAttribute);
	}
}

static unsigned si_llvm_get_stream(struct lp_build_tgsi_context *bld_base,
				       struct lp_build_emit_data *emit_data)
{
	LLVMValueRef (*imms)[4] = lp_soa_context(bld_base)->immediates;
	struct tgsi_src_register src0 = emit_data->inst->Src[0].Register;
	unsigned stream;

	assert(src0.File == TGSI_FILE_IMMEDIATE);

	stream = LLVMConstIntGetZExtValue(imms[src0.Index][src0.SwizzleX]) & 0x3;
	return stream;
}

/* Emit one vertex from the geometry shader */
static void si_llvm_emit_vertex(
	const struct lp_build_tgsi_action *action,
	struct lp_build_tgsi_context *bld_base,
	struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct lp_build_context *uint = &bld_base->uint_bld;
	struct si_shader *shader = ctx->shader;
	struct tgsi_shader_info *info = &shader->selector->info;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef soffset = LLVMGetParam(ctx->radeon_bld.main_fn,
					    SI_PARAM_GS2VS_OFFSET);
	LLVMValueRef gs_next_vertex;
	LLVMValueRef can_emit, kill;
	LLVMValueRef args[2];
	unsigned chan;
	int i;
	unsigned stream;

	stream = si_llvm_get_stream(bld_base, emit_data);

	/* Write vertex attribute values to GSVS ring */
	gs_next_vertex = LLVMBuildLoad(gallivm->builder,
				       ctx->gs_next_vertex[stream],
				       "");

	/* If this thread has already emitted the declared maximum number of
	 * vertices, kill it: excessive vertex emissions are not supposed to
	 * have any effect, and GS threads have no externally observable
	 * effects other than emitting vertices.
	 */
	can_emit = LLVMBuildICmp(gallivm->builder, LLVMIntULE, gs_next_vertex,
				 lp_build_const_int32(gallivm,
						      shader->selector->gs_max_out_vertices), "");
	kill = lp_build_select(&bld_base->base, can_emit,
			       lp_build_const_float(gallivm, 1.0f),
			       lp_build_const_float(gallivm, -1.0f));

	lp_build_intrinsic(gallivm->builder, "llvm.AMDGPU.kill",
			   ctx->voidt, &kill, 1, 0);

	for (i = 0; i < info->num_outputs; i++) {
		LLVMValueRef *out_ptr =
			ctx->radeon_bld.soa.outputs[i];

		for (chan = 0; chan < 4; chan++) {
			LLVMValueRef out_val = LLVMBuildLoad(gallivm->builder, out_ptr[chan], "");
			LLVMValueRef voffset =
				lp_build_const_int32(gallivm, (i * 4 + chan) *
						     shader->selector->gs_max_out_vertices);

			voffset = lp_build_add(uint, voffset, gs_next_vertex);
			voffset = lp_build_mul_imm(uint, voffset, 4);

			out_val = LLVMBuildBitCast(gallivm->builder, out_val, ctx->i32, "");

			build_tbuffer_store(ctx,
					    ctx->gsvs_ring[stream],
					    out_val, 1,
					    voffset, soffset, 0,
					    V_008F0C_BUF_DATA_FORMAT_32,
					    V_008F0C_BUF_NUM_FORMAT_UINT,
					    1, 0, 1, 1, 0);
		}
	}
	gs_next_vertex = lp_build_add(uint, gs_next_vertex,
				      lp_build_const_int32(gallivm, 1));

	LLVMBuildStore(gallivm->builder, gs_next_vertex, ctx->gs_next_vertex[stream]);

	/* Signal vertex emission */
	args[0] = lp_build_const_int32(gallivm, SENDMSG_GS_OP_EMIT | SENDMSG_GS | (stream << 8));
	args[1] = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_GS_WAVE_ID);
	lp_build_intrinsic(gallivm->builder, "llvm.SI.sendmsg",
			   ctx->voidt, args, 2, 0);
}

/* Cut one primitive from the geometry shader */
static void si_llvm_emit_primitive(
	const struct lp_build_tgsi_action *action,
	struct lp_build_tgsi_context *bld_base,
	struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMValueRef args[2];
	unsigned stream;

	/* Signal primitive cut */
	stream = si_llvm_get_stream(bld_base, emit_data);
	args[0] = lp_build_const_int32(gallivm,	SENDMSG_GS_OP_CUT | SENDMSG_GS | (stream << 8));
	args[1] = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_GS_WAVE_ID);
	lp_build_intrinsic(gallivm->builder, "llvm.SI.sendmsg",
			   ctx->voidt, args, 2, 0);
}

static void si_llvm_emit_barrier(const struct lp_build_tgsi_action *action,
				 struct lp_build_tgsi_context *bld_base,
				 struct lp_build_emit_data *emit_data)
{
	struct si_shader_context *ctx = si_shader_context(bld_base);
	struct gallivm_state *gallivm = bld_base->base.gallivm;

	/* The real barrier instruction isn’t needed, because an entire patch
	 * always fits into a single wave.
	 */
	if (ctx->type == PIPE_SHADER_TESS_CTRL) {
		emit_optimization_barrier(ctx);
		return;
	}

	lp_build_intrinsic(gallivm->builder,
			   HAVE_LLVM >= 0x0309 ? "llvm.amdgcn.s.barrier"
					       : "llvm.AMDGPU.barrier.local",
			   ctx->voidt, NULL, 0, 0);
}

static const struct lp_build_tgsi_action tex_action = {
	.fetch_args = tex_fetch_args,
	.emit = build_tex_intrinsic,
};

static const struct lp_build_tgsi_action interp_action = {
	.fetch_args = interp_fetch_args,
	.emit = build_interp_intrinsic,
};

static void si_create_function(struct si_shader_context *ctx,
			       LLVMTypeRef *returns, unsigned num_returns,
			       LLVMTypeRef *params, unsigned num_params,
			       int last_sgpr)
{
	int i;

	radeon_llvm_create_func(&ctx->radeon_bld, returns, num_returns,
				params, num_params);
	radeon_llvm_shader_type(ctx->radeon_bld.main_fn, ctx->type);
	ctx->return_value = LLVMGetUndef(ctx->radeon_bld.return_type);

	for (i = 0; i <= last_sgpr; ++i) {
		LLVMValueRef P = LLVMGetParam(ctx->radeon_bld.main_fn, i);

		/* The combination of:
		 * - ByVal
		 * - dereferenceable
		 * - invariant.load
		 * allows the optimization passes to move loads and reduces
		 * SGPR spilling significantly.
		 */
		if (LLVMGetTypeKind(LLVMTypeOf(P)) == LLVMPointerTypeKind) {
			LLVMAddAttribute(P, LLVMByValAttribute);
			lp_add_attr_dereferenceable(P, UINT64_MAX);
		} else
			LLVMAddAttribute(P, LLVMInRegAttribute);
	}

	if (ctx->screen->b.debug_flags & DBG_UNSAFE_MATH) {
		/* These were copied from some LLVM test. */
		LLVMAddTargetDependentFunctionAttr(ctx->radeon_bld.main_fn,
						   "less-precise-fpmad",
						   "true");
		LLVMAddTargetDependentFunctionAttr(ctx->radeon_bld.main_fn,
						   "no-infs-fp-math",
						   "true");
		LLVMAddTargetDependentFunctionAttr(ctx->radeon_bld.main_fn,
						   "no-nans-fp-math",
						   "true");
		LLVMAddTargetDependentFunctionAttr(ctx->radeon_bld.main_fn,
						   "unsafe-fp-math",
						   "true");
	}
}

static void create_meta_data(struct si_shader_context *ctx)
{
	struct gallivm_state *gallivm = ctx->radeon_bld.soa.bld_base.base.gallivm;

	ctx->invariant_load_md_kind = LLVMGetMDKindIDInContext(gallivm->context,
							       "invariant.load", 14);
	ctx->range_md_kind = LLVMGetMDKindIDInContext(gallivm->context,
						     "range", 5);
	ctx->uniform_md_kind = LLVMGetMDKindIDInContext(gallivm->context,
							"amdgpu.uniform", 14);

	ctx->empty_md = LLVMMDNodeInContext(gallivm->context, NULL, 0);
}

static void declare_streamout_params(struct si_shader_context *ctx,
				     struct pipe_stream_output_info *so,
				     LLVMTypeRef *params, LLVMTypeRef i32,
				     unsigned *num_params)
{
	int i;

	/* Streamout SGPRs. */
	if (so->num_outputs) {
		if (ctx->type != PIPE_SHADER_TESS_EVAL)
			params[ctx->param_streamout_config = (*num_params)++] = i32;
		else
			ctx->param_streamout_config = ctx->param_tess_offchip;

		params[ctx->param_streamout_write_index = (*num_params)++] = i32;
	}
	/* A streamout buffer offset is loaded if the stride is non-zero. */
	for (i = 0; i < 4; i++) {
		if (!so->stride[i])
			continue;

		params[ctx->param_streamout_offset[i] = (*num_params)++] = i32;
	}
}

static unsigned llvm_get_type_size(LLVMTypeRef type)
{
	LLVMTypeKind kind = LLVMGetTypeKind(type);

	switch (kind) {
	case LLVMIntegerTypeKind:
		return LLVMGetIntTypeWidth(type) / 8;
	case LLVMFloatTypeKind:
		return 4;
	case LLVMPointerTypeKind:
		return 8;
	case LLVMVectorTypeKind:
		return LLVMGetVectorSize(type) *
		       llvm_get_type_size(LLVMGetElementType(type));
	default:
		assert(0);
		return 0;
	}
}

static void declare_tess_lds(struct si_shader_context *ctx)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	struct lp_build_context *uint = &bld_base->uint_bld;

	unsigned lds_size = ctx->screen->b.chip_class >= CIK ? 65536 : 32768;
	ctx->lds = LLVMBuildIntToPtr(gallivm->builder, uint->zero,
		LLVMPointerType(LLVMArrayType(ctx->i32, lds_size / 4), LOCAL_ADDR_SPACE),
		"tess_lds");
}

static void create_function(struct si_shader_context *ctx)
{
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	struct si_shader *shader = ctx->shader;
	LLVMTypeRef params[SI_NUM_PARAMS + SI_NUM_VERTEX_BUFFERS], v3i32;
	LLVMTypeRef returns[16+32*4];
	unsigned i, last_sgpr, num_params, num_return_sgprs;
	unsigned num_returns = 0;

	v3i32 = LLVMVectorType(ctx->i32, 3);

	params[SI_PARAM_RW_BUFFERS] = const_array(ctx->v16i8, SI_NUM_RW_BUFFERS);
	params[SI_PARAM_CONST_BUFFERS] = const_array(ctx->v16i8, SI_NUM_CONST_BUFFERS);
	params[SI_PARAM_SAMPLERS] = const_array(ctx->v8i32, SI_NUM_SAMPLERS);
	params[SI_PARAM_IMAGES] = const_array(ctx->v8i32, SI_NUM_IMAGES);
	params[SI_PARAM_SHADER_BUFFERS] = const_array(ctx->v4i32, SI_NUM_SHADER_BUFFERS);

	switch (ctx->type) {
	case PIPE_SHADER_VERTEX:
		params[SI_PARAM_VERTEX_BUFFERS] = const_array(ctx->v16i8, SI_NUM_VERTEX_BUFFERS);
		params[SI_PARAM_BASE_VERTEX] = ctx->i32;
		params[SI_PARAM_START_INSTANCE] = ctx->i32;
		params[SI_PARAM_DRAWID] = ctx->i32;
		num_params = SI_PARAM_DRAWID+1;

		if (shader->key.vs.as_es) {
			params[ctx->param_es2gs_offset = num_params++] = ctx->i32;
		} else if (shader->key.vs.as_ls) {
			params[SI_PARAM_LS_OUT_LAYOUT] = ctx->i32;
			num_params = SI_PARAM_LS_OUT_LAYOUT+1;
		} else {
			if (ctx->is_gs_copy_shader) {
				num_params = SI_PARAM_RW_BUFFERS+1;
			} else {
				params[SI_PARAM_VS_STATE_BITS] = ctx->i32;
				num_params = SI_PARAM_VS_STATE_BITS+1;
			}

			/* The locations of the other parameters are assigned dynamically. */
			declare_streamout_params(ctx, &shader->selector->so,
						 params, ctx->i32, &num_params);
		}

		last_sgpr = num_params-1;

		/* VGPRs */
		params[ctx->param_vertex_id = num_params++] = ctx->i32;
		params[ctx->param_rel_auto_id = num_params++] = ctx->i32;
		params[ctx->param_vs_prim_id = num_params++] = ctx->i32;
		params[ctx->param_instance_id = num_params++] = ctx->i32;

		if (!ctx->is_monolithic &&
		    !ctx->is_gs_copy_shader) {
			/* Vertex load indices. */
			ctx->param_vertex_index0 = num_params;

			for (i = 0; i < shader->selector->info.num_inputs; i++)
				params[num_params++] = ctx->i32;

			/* PrimitiveID output. */
			if (!shader->key.vs.as_es && !shader->key.vs.as_ls)
				for (i = 0; i <= VS_EPILOG_PRIMID_LOC; i++)
					returns[num_returns++] = ctx->f32;
		}
		break;

	case PIPE_SHADER_TESS_CTRL:
		params[SI_PARAM_TCS_OFFCHIP_LAYOUT] = ctx->i32;
		params[SI_PARAM_TCS_OUT_OFFSETS] = ctx->i32;
		params[SI_PARAM_TCS_OUT_LAYOUT] = ctx->i32;
		params[SI_PARAM_TCS_IN_LAYOUT] = ctx->i32;
		params[ctx->param_oc_lds = SI_PARAM_TCS_OC_LDS] = ctx->i32;
		params[SI_PARAM_TESS_FACTOR_OFFSET] = ctx->i32;
		last_sgpr = SI_PARAM_TESS_FACTOR_OFFSET;

		/* VGPRs */
		params[SI_PARAM_PATCH_ID] = ctx->i32;
		params[SI_PARAM_REL_IDS] = ctx->i32;
		num_params = SI_PARAM_REL_IDS+1;

		if (!ctx->is_monolithic) {
			/* SI_PARAM_TCS_OC_LDS and PARAM_TESS_FACTOR_OFFSET are
			 * placed after the user SGPRs.
			 */
			for (i = 0; i < SI_TCS_NUM_USER_SGPR + 2; i++)
				returns[num_returns++] = ctx->i32; /* SGPRs */

			for (i = 0; i < 3; i++)
				returns[num_returns++] = ctx->f32; /* VGPRs */
		}
		break;

	case PIPE_SHADER_TESS_EVAL:
		params[SI_PARAM_TCS_OFFCHIP_LAYOUT] = ctx->i32;
		num_params = SI_PARAM_TCS_OFFCHIP_LAYOUT+1;

		if (shader->key.tes.as_es) {
			params[ctx->param_oc_lds = num_params++] = ctx->i32;
			params[ctx->param_tess_offchip = num_params++] = ctx->i32;
			params[ctx->param_es2gs_offset = num_params++] = ctx->i32;
		} else {
			params[ctx->param_tess_offchip = num_params++] = ctx->i32;
			declare_streamout_params(ctx, &shader->selector->so,
						 params, ctx->i32, &num_params);
			params[ctx->param_oc_lds = num_params++] = ctx->i32;
		}
		last_sgpr = num_params - 1;

		/* VGPRs */
		params[ctx->param_tes_u = num_params++] = ctx->f32;
		params[ctx->param_tes_v = num_params++] = ctx->f32;
		params[ctx->param_tes_rel_patch_id = num_params++] = ctx->i32;
		params[ctx->param_tes_patch_id = num_params++] = ctx->i32;

		/* PrimitiveID output. */
		if (!ctx->is_monolithic && !shader->key.tes.as_es)
			for (i = 0; i <= VS_EPILOG_PRIMID_LOC; i++)
				returns[num_returns++] = ctx->f32;
		break;

	case PIPE_SHADER_GEOMETRY:
		params[SI_PARAM_GS2VS_OFFSET] = ctx->i32;
		params[SI_PARAM_GS_WAVE_ID] = ctx->i32;
		last_sgpr = SI_PARAM_GS_WAVE_ID;

		/* VGPRs */
		params[SI_PARAM_VTX0_OFFSET] = ctx->i32;
		params[SI_PARAM_VTX1_OFFSET] = ctx->i32;
		params[SI_PARAM_PRIMITIVE_ID] = ctx->i32;
		params[SI_PARAM_VTX2_OFFSET] = ctx->i32;
		params[SI_PARAM_VTX3_OFFSET] = ctx->i32;
		params[SI_PARAM_VTX4_OFFSET] = ctx->i32;
		params[SI_PARAM_VTX5_OFFSET] = ctx->i32;
		params[SI_PARAM_GS_INSTANCE_ID] = ctx->i32;
		num_params = SI_PARAM_GS_INSTANCE_ID+1;
		break;

	case PIPE_SHADER_FRAGMENT:
		params[SI_PARAM_ALPHA_REF] = ctx->f32;
		params[SI_PARAM_PRIM_MASK] = ctx->i32;
		last_sgpr = SI_PARAM_PRIM_MASK;
		params[SI_PARAM_PERSP_SAMPLE] = ctx->v2i32;
		params[SI_PARAM_PERSP_CENTER] = ctx->v2i32;
		params[SI_PARAM_PERSP_CENTROID] = ctx->v2i32;
		params[SI_PARAM_PERSP_PULL_MODEL] = v3i32;
		params[SI_PARAM_LINEAR_SAMPLE] = ctx->v2i32;
		params[SI_PARAM_LINEAR_CENTER] = ctx->v2i32;
		params[SI_PARAM_LINEAR_CENTROID] = ctx->v2i32;
		params[SI_PARAM_LINE_STIPPLE_TEX] = ctx->f32;
		params[SI_PARAM_POS_X_FLOAT] = ctx->f32;
		params[SI_PARAM_POS_Y_FLOAT] = ctx->f32;
		params[SI_PARAM_POS_Z_FLOAT] = ctx->f32;
		params[SI_PARAM_POS_W_FLOAT] = ctx->f32;
		params[SI_PARAM_FRONT_FACE] = ctx->i32;
		params[SI_PARAM_ANCILLARY] = ctx->i32;
		params[SI_PARAM_SAMPLE_COVERAGE] = ctx->f32;
		params[SI_PARAM_POS_FIXED_PT] = ctx->i32;
		num_params = SI_PARAM_POS_FIXED_PT+1;

		if (!ctx->is_monolithic) {
			/* Color inputs from the prolog. */
			if (shader->selector->info.colors_read) {
				unsigned num_color_elements =
					util_bitcount(shader->selector->info.colors_read);

				assert(num_params + num_color_elements <= ARRAY_SIZE(params));
				for (i = 0; i < num_color_elements; i++)
					params[num_params++] = ctx->f32;
			}

			/* Outputs for the epilog. */
			num_return_sgprs = SI_SGPR_ALPHA_REF + 1;
			num_returns =
				num_return_sgprs +
				util_bitcount(shader->selector->info.colors_written) * 4 +
				shader->selector->info.writes_z +
				shader->selector->info.writes_stencil +
				shader->selector->info.writes_samplemask +
				1 /* SampleMaskIn */;

			num_returns = MAX2(num_returns,
					   num_return_sgprs +
					   PS_EPILOG_SAMPLEMASK_MIN_LOC + 1);

			for (i = 0; i < num_return_sgprs; i++)
				returns[i] = ctx->i32;
			for (; i < num_returns; i++)
				returns[i] = ctx->f32;
		}
		break;

	case PIPE_SHADER_COMPUTE:
		params[SI_PARAM_GRID_SIZE] = v3i32;
		params[SI_PARAM_BLOCK_ID] = v3i32;
		last_sgpr = SI_PARAM_BLOCK_ID;

		params[SI_PARAM_THREAD_ID] = v3i32;
		num_params = SI_PARAM_THREAD_ID + 1;
		break;
	default:
		assert(0 && "unimplemented shader");
		return;
	}

	assert(num_params <= ARRAY_SIZE(params));

	si_create_function(ctx, returns, num_returns, params,
			   num_params, last_sgpr);

	/* Reserve register locations for VGPR inputs the PS prolog may need. */
	if (ctx->type == PIPE_SHADER_FRAGMENT &&
	    !ctx->is_monolithic) {
		radeon_llvm_add_attribute(ctx->radeon_bld.main_fn,
					  "InitialPSInputAddr",
					  S_0286D0_PERSP_SAMPLE_ENA(1) |
					  S_0286D0_PERSP_CENTER_ENA(1) |
					  S_0286D0_PERSP_CENTROID_ENA(1) |
					  S_0286D0_LINEAR_SAMPLE_ENA(1) |
					  S_0286D0_LINEAR_CENTER_ENA(1) |
					  S_0286D0_LINEAR_CENTROID_ENA(1) |
					  S_0286D0_FRONT_FACE_ENA(1) |
					  S_0286D0_POS_FIXED_PT_ENA(1));
	} else if (ctx->type == PIPE_SHADER_COMPUTE) {
		const unsigned *properties = shader->selector->info.properties;
		unsigned max_work_group_size =
		               properties[TGSI_PROPERTY_CS_FIXED_BLOCK_WIDTH] *
		               properties[TGSI_PROPERTY_CS_FIXED_BLOCK_HEIGHT] *
		               properties[TGSI_PROPERTY_CS_FIXED_BLOCK_DEPTH];

		assert(max_work_group_size);

		radeon_llvm_add_attribute(ctx->radeon_bld.main_fn,
		                          "amdgpu-max-work-group-size",
		                          max_work_group_size);
	}

	shader->info.num_input_sgprs = 0;
	shader->info.num_input_vgprs = 0;

	for (i = 0; i <= last_sgpr; ++i)
		shader->info.num_input_sgprs += llvm_get_type_size(params[i]) / 4;

	/* Unused fragment shader inputs are eliminated by the compiler,
	 * so we don't know yet how many there will be.
	 */
	if (ctx->type != PIPE_SHADER_FRAGMENT)
		for (; i < num_params; ++i)
			shader->info.num_input_vgprs += llvm_get_type_size(params[i]) / 4;

	if (bld_base->info &&
	    (bld_base->info->opcode_count[TGSI_OPCODE_DDX] > 0 ||
	     bld_base->info->opcode_count[TGSI_OPCODE_DDY] > 0 ||
	     bld_base->info->opcode_count[TGSI_OPCODE_DDX_FINE] > 0 ||
	     bld_base->info->opcode_count[TGSI_OPCODE_DDY_FINE] > 0 ||
	     bld_base->info->opcode_count[TGSI_OPCODE_INTERP_OFFSET] > 0 ||
	     bld_base->info->opcode_count[TGSI_OPCODE_INTERP_SAMPLE] > 0))
		ctx->lds =
			LLVMAddGlobalInAddressSpace(gallivm->module,
						    LLVMArrayType(ctx->i32, 64),
						    "ddxy_lds",
						    LOCAL_ADDR_SPACE);

	if ((ctx->type == PIPE_SHADER_VERTEX && shader->key.vs.as_ls) ||
	    ctx->type == PIPE_SHADER_TESS_CTRL ||
	    ctx->type == PIPE_SHADER_TESS_EVAL)
		declare_tess_lds(ctx);
}

static void preload_constants(struct si_shader_context *ctx)
{
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	const struct tgsi_shader_info *info = bld_base->info;
	unsigned buf;
	LLVMValueRef ptr = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_CONST_BUFFERS);

	for (buf = 0; buf < SI_NUM_CONST_BUFFERS; buf++) {
		unsigned i, num_const = info->const_file_max[buf] + 1;

		if (num_const == 0)
			continue;

		/* Allocate space for the constant values */
		ctx->constants[buf] = CALLOC(num_const * 4, sizeof(LLVMValueRef));

		/* Load the resource descriptor */
		ctx->const_buffers[buf] =
			build_indexed_load_const(ctx, ptr, lp_build_const_int32(gallivm, buf));

		/* Load the constants, we rely on the code sinking to do the rest */
		for (i = 0; i < num_const * 4; ++i) {
			ctx->constants[buf][i] =
				buffer_load_const(ctx,
					ctx->const_buffers[buf],
					lp_build_const_int32(gallivm, i * 4));
		}
	}
}

static void preload_shader_buffers(struct si_shader_context *ctx)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	LLVMValueRef ptr = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_SHADER_BUFFERS);
	int buf, maxbuf;

	maxbuf = MIN2(ctx->shader->selector->info.file_max[TGSI_FILE_BUFFER],
		      SI_NUM_SHADER_BUFFERS - 1);
	for (buf = 0; buf <= maxbuf; ++buf) {
		ctx->shader_buffers[buf] =
			build_indexed_load_const(
				ctx, ptr, lp_build_const_int32(gallivm, buf));
	}
}

static void preload_samplers(struct si_shader_context *ctx)
{
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	const struct tgsi_shader_info *info = bld_base->info;
	unsigned i, num_samplers = info->file_max[TGSI_FILE_SAMPLER] + 1;
	LLVMValueRef offset;

	if (num_samplers == 0)
		return;

	/* Load the resources and samplers, we rely on the code sinking to do the rest */
	for (i = 0; i < num_samplers; ++i) {
		/* Resource */
		offset = lp_build_const_int32(gallivm, i);
		ctx->sampler_views[i] =
			get_sampler_desc(ctx, offset, DESC_IMAGE);

		/* FMASK resource */
		if (info->is_msaa_sampler[i])
			ctx->fmasks[i] =
				get_sampler_desc(ctx, offset, DESC_FMASK);
		else {
			ctx->sampler_states[i] =
				get_sampler_desc(ctx, offset, DESC_SAMPLER);
			ctx->sampler_states[i] =
				sici_fix_sampler_aniso(ctx, ctx->sampler_views[i],
						       ctx->sampler_states[i]);
		}
	}
}

static void preload_images(struct si_shader_context *ctx)
{
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	struct tgsi_shader_info *info = &ctx->shader->selector->info;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	unsigned num_images = bld_base->info->file_max[TGSI_FILE_IMAGE] + 1;
	LLVMValueRef res_ptr;
	unsigned i;

	if (num_images == 0)
		return;

	res_ptr = LLVMGetParam(ctx->radeon_bld.main_fn, SI_PARAM_IMAGES);

	for (i = 0; i < num_images; ++i) {
		/* Rely on LLVM to shrink the load for buffer resources. */
		LLVMValueRef rsrc =
			build_indexed_load_const(ctx, res_ptr,
						 lp_build_const_int32(gallivm, i));

		if (info->images_writemask & (1 << i) &&
		    !(info->images_buffers & (1 << i)))
			rsrc = force_dcc_off(ctx, rsrc);

		ctx->images[i] = rsrc;
	}
}

static void preload_streamout_buffers(struct si_shader_context *ctx)
{
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	unsigned i;

	/* Streamout can only be used if the shader is compiled as VS. */
	if (!ctx->shader->selector->so.num_outputs ||
	    (ctx->type == PIPE_SHADER_VERTEX &&
	     (ctx->shader->key.vs.as_es ||
	      ctx->shader->key.vs.as_ls)) ||
	    (ctx->type == PIPE_SHADER_TESS_EVAL &&
	     ctx->shader->key.tes.as_es))
		return;

	LLVMValueRef buf_ptr = LLVMGetParam(ctx->radeon_bld.main_fn,
					    SI_PARAM_RW_BUFFERS);

	/* Load the resources, we rely on the code sinking to do the rest */
	for (i = 0; i < 4; ++i) {
		if (ctx->shader->selector->so.stride[i]) {
			LLVMValueRef offset = lp_build_const_int32(gallivm,
								   SI_VS_STREAMOUT_BUF0 + i);

			ctx->so_buffers[i] = build_indexed_load_const(ctx, buf_ptr, offset);
		}
	}
}

/**
 * Load ESGS and GSVS ring buffer resource descriptors and save the variables
 * for later use.
 */
static void preload_ring_buffers(struct si_shader_context *ctx)
{
	struct gallivm_state *gallivm =
		ctx->radeon_bld.soa.bld_base.base.gallivm;

	LLVMValueRef buf_ptr = LLVMGetParam(ctx->radeon_bld.main_fn,
					    SI_PARAM_RW_BUFFERS);

	if ((ctx->type == PIPE_SHADER_VERTEX &&
	     ctx->shader->key.vs.as_es) ||
	    (ctx->type == PIPE_SHADER_TESS_EVAL &&
	     ctx->shader->key.tes.as_es) ||
	    ctx->type == PIPE_SHADER_GEOMETRY) {
		unsigned ring =
			ctx->type == PIPE_SHADER_GEOMETRY ? SI_GS_RING_ESGS
							     : SI_ES_RING_ESGS;
		LLVMValueRef offset = lp_build_const_int32(gallivm, ring);

		ctx->esgs_ring =
			build_indexed_load_const(ctx, buf_ptr, offset);
	}

	if (ctx->is_gs_copy_shader) {
		LLVMValueRef offset = lp_build_const_int32(gallivm, SI_VS_RING_GSVS);

		ctx->gsvs_ring[0] =
			build_indexed_load_const(ctx, buf_ptr, offset);
	}
	if (ctx->type == PIPE_SHADER_GEOMETRY) {
		int i;
		for (i = 0; i < 4; i++) {
			LLVMValueRef offset = lp_build_const_int32(gallivm, SI_GS_RING_GSVS0 + i);

			ctx->gsvs_ring[i] =
				build_indexed_load_const(ctx, buf_ptr, offset);
		}
	}
}

static void si_llvm_emit_polygon_stipple(struct si_shader_context *ctx,
					 LLVMValueRef param_rw_buffers,
					 unsigned param_pos_fixed_pt)
{
	struct lp_build_tgsi_context *bld_base =
		&ctx->radeon_bld.soa.bld_base;
	struct gallivm_state *gallivm = bld_base->base.gallivm;
	LLVMBuilderRef builder = gallivm->builder;
	LLVMValueRef slot, desc, offset, row, bit, address[2];

	/* Use the fixed-point gl_FragCoord input.
	 * Since the stipple pattern is 32x32 and it repeats, just get 5 bits
	 * per coordinate to get the repeating effect.
	 */
	address[0] = unpack_param(ctx, param_pos_fixed_pt, 0, 5);
	address[1] = unpack_param(ctx, param_pos_fixed_pt, 16, 5);

	/* Load the buffer descriptor. */
	slot = lp_build_const_int32(gallivm, SI_PS_CONST_POLY_STIPPLE);
	desc = build_indexed_load_const(ctx, param_rw_buffers, slot);

	/* The stipple pattern is 32x32, each row has 32 bits. */
	offset = LLVMBuildMul(builder, address[1],
			      LLVMConstInt(ctx->i32, 4, 0), "");
	row = buffer_load_const(ctx, desc, offset);
	row = LLVMBuildBitCast(builder, row, ctx->i32, "");
	bit = LLVMBuildLShr(builder, row, address[0], "");
	bit = LLVMBuildTrunc(builder, bit, ctx->i1, "");

	/* The intrinsic kills the thread if arg < 0. */
	bit = LLVMBuildSelect(builder, bit, LLVMConstReal(ctx->f32, 0),
			      LLVMConstReal(ctx->f32, -1), "");
	lp_build_intrinsic(builder, "llvm.AMDGPU.kill", ctx->voidt, &bit, 1, 0);
}

void si_shader_binary_read_config(struct radeon_shader_binary *binary,
				  struct si_shader_config *conf,
				  unsigned symbol_offset)
{
	unsigned i;
	const unsigned char *config =
		radeon_shader_binary_config_start(binary, symbol_offset);
	bool really_needs_scratch = false;

	/* LLVM adds SGPR spills to the scratch size.
	 * Find out if we really need the scratch buffer.
	 */
	for (i = 0; i < binary->reloc_count; i++) {
		const struct radeon_shader_reloc *reloc = &binary->relocs[i];

		if (!strcmp(scratch_rsrc_dword0_symbol, reloc->name) ||
		    !strcmp(scratch_rsrc_dword1_symbol, reloc->name)) {
			really_needs_scratch = true;
			break;
		}
	}

	/* XXX: We may be able to emit some of these values directly rather than
	 * extracting fields to be emitted later.
	 */

	for (i = 0; i < binary->config_size_per_symbol; i+= 8) {
		unsigned reg = util_le32_to_cpu(*(uint32_t*)(config + i));
		unsigned value = util_le32_to_cpu(*(uint32_t*)(config + i + 4));
		switch (reg) {
		case R_00B028_SPI_SHADER_PGM_RSRC1_PS:
		case R_00B128_SPI_SHADER_PGM_RSRC1_VS:
		case R_00B228_SPI_SHADER_PGM_RSRC1_GS:
		case R_00B848_COMPUTE_PGM_RSRC1:
			conf->num_sgprs = MAX2(conf->num_sgprs, (G_00B028_SGPRS(value) + 1) * 8);
			conf->num_vgprs = MAX2(conf->num_vgprs, (G_00B028_VGPRS(value) + 1) * 4);
			conf->float_mode =  G_00B028_FLOAT_MODE(value);
			conf->rsrc1 = value;
			break;
		case R_00B02C_SPI_SHADER_PGM_RSRC2_PS:
			conf->lds_size = MAX2(conf->lds_size, G_00B02C_EXTRA_LDS_SIZE(value));
			break;
		case R_00B84C_COMPUTE_PGM_RSRC2:
			conf->lds_size = MAX2(conf->lds_size, G_00B84C_LDS_SIZE(value));
			conf->rsrc2 = value;
			break;
		case R_0286CC_SPI_PS_INPUT_ENA:
			conf->spi_ps_input_ena = value;
			break;
		case R_0286D0_SPI_PS_INPUT_ADDR:
			conf->spi_ps_input_addr = value;
			break;
		case R_0286E8_SPI_TMPRING_SIZE:
		case R_00B860_COMPUTE_TMPRING_SIZE:
			/* WAVESIZE is in units of 256 dwords. */
			if (really_needs_scratch)
				conf->scratch_bytes_per_wave =
					G_00B860_WAVESIZE(value) * 256 * 4;
			break;
		case 0x4: /* SPILLED_SGPRS */
			conf->spilled_sgprs = value;
			break;
		case 0x8: /* SPILLED_VGPRS */
			conf->spilled_vgprs = value;
			break;
		default:
			{
				static bool printed;

				if (!printed) {
					fprintf(stderr, "Warning: LLVM emitted unknown "
						"config register: 0x%x\n", reg);
					printed = true;
				}
			}
			break;
		}
	}

	if (!conf->spi_ps_input_addr)
		conf->spi_ps_input_addr = conf->spi_ps_input_ena;
}

void si_shader_apply_scratch_relocs(struct si_context *sctx,
			struct si_shader *shader,
			struct si_shader_config *config,
			uint64_t scratch_va)
{
	unsigned i;
	uint32_t scratch_rsrc_dword0 = scratch_va;
	uint32_t scratch_rsrc_dword1 =
		S_008F04_BASE_ADDRESS_HI(scratch_va >> 32);

	/* Enable scratch coalescing if LLVM sets ELEMENT_SIZE & INDEX_STRIDE
	 * correctly.
	 */
	if (HAVE_LLVM >= 0x0309)
		scratch_rsrc_dword1 |= S_008F04_SWIZZLE_ENABLE(1);
	else
		scratch_rsrc_dword1 |=
			S_008F04_STRIDE(config->scratch_bytes_per_wave / 64);

	for (i = 0 ; i < shader->binary.reloc_count; i++) {
		const struct radeon_shader_reloc *reloc =
					&shader->binary.relocs[i];
		if (!strcmp(scratch_rsrc_dword0_symbol, reloc->name)) {
			util_memcpy_cpu_to_le32(shader->binary.code + reloc->offset,
			&scratch_rsrc_dword0, 4);
		} else if (!strcmp(scratch_rsrc_dword1_symbol, reloc->name)) {
			util_memcpy_cpu_to_le32(shader->binary.code + reloc->offset,
			&scratch_rsrc_dword1, 4);
		}
	}
}

static unsigned si_get_shader_binary_size(struct si_shader *shader)
{
	unsigned size = shader->binary.code_size;

	if (shader->prolog)
		size += shader->prolog->binary.code_size;
	if (shader->epilog)
		size += shader->epilog->binary.code_size;
	return size;
}

int si_shader_binary_upload(struct si_screen *sscreen, struct si_shader *shader)
{
	const struct radeon_shader_binary *prolog =
		shader->prolog ? &shader->prolog->binary : NULL;
	const struct radeon_shader_binary *epilog =
		shader->epilog ? &shader->epilog->binary : NULL;
	const struct radeon_shader_binary *mainb = &shader->binary;
	unsigned bo_size = si_get_shader_binary_size(shader) +
			   (!epilog ? mainb->rodata_size : 0);
	unsigned char *ptr;

	assert(!prolog || !prolog->rodata_size);
	assert((!prolog && !epilog) || !mainb->rodata_size);
	assert(!epilog || !epilog->rodata_size);

	r600_resource_reference(&shader->bo, NULL);
	shader->bo = si_resource_create_custom(&sscreen->b.b,
					       PIPE_USAGE_IMMUTABLE,
					       bo_size);
	if (!shader->bo)
		return -ENOMEM;

	/* Upload. */
	ptr = sscreen->b.ws->buffer_map(shader->bo->buf, NULL,
					PIPE_TRANSFER_READ_WRITE);

	if (prolog) {
		util_memcpy_cpu_to_le32(ptr, prolog->code, prolog->code_size);
		ptr += prolog->code_size;
	}

	util_memcpy_cpu_to_le32(ptr, mainb->code, mainb->code_size);
	ptr += mainb->code_size;

	if (epilog)
		util_memcpy_cpu_to_le32(ptr, epilog->code, epilog->code_size);
	else if (mainb->rodata_size > 0)
		util_memcpy_cpu_to_le32(ptr, mainb->rodata, mainb->rodata_size);

	sscreen->b.ws->buffer_unmap(shader->bo->buf);
	return 0;
}

static void si_shader_dump_disassembly(const struct radeon_shader_binary *binary,
				       struct pipe_debug_callback *debug,
				       const char *name, FILE *file)
{
	char *line, *p;
	unsigned i, count;

	if (binary->disasm_string) {
		fprintf(file, "Shader %s disassembly:\n", name);
		fprintf(file, "%s", binary->disasm_string);

		if (debug && debug->debug_message) {
			/* Very long debug messages are cut off, so send the
			 * disassembly one line at a time. This causes more
			 * overhead, but on the plus side it simplifies
			 * parsing of resulting logs.
			 */
			pipe_debug_message(debug, SHADER_INFO,
					   "Shader Disassembly Begin");

			line = binary->disasm_string;
			while (*line) {
				p = util_strchrnul(line, '\n');
				count = p - line;

				if (count) {
					pipe_debug_message(debug, SHADER_INFO,
							   "%.*s", count, line);
				}

				if (!*p)
					break;
				line = p + 1;
			}

			pipe_debug_message(debug, SHADER_INFO,
					   "Shader Disassembly End");
		}
	} else {
		fprintf(file, "Shader %s binary:\n", name);
		for (i = 0; i < binary->code_size; i += 4) {
			fprintf(file, "@0x%x: %02x%02x%02x%02x\n", i,
				binary->code[i + 3], binary->code[i + 2],
				binary->code[i + 1], binary->code[i]);
		}
	}
}

static void si_shader_dump_stats(struct si_screen *sscreen,
			         struct si_shader_config *conf,
				 unsigned num_inputs,
				 unsigned code_size,
			         struct pipe_debug_callback *debug,
			         unsigned processor,
				 FILE *file)
{
	unsigned lds_increment = sscreen->b.chip_class >= CIK ? 512 : 256;
	unsigned lds_per_wave = 0;
	unsigned max_simd_waves = 10;

	/* Compute LDS usage for PS. */
	if (processor == PIPE_SHADER_FRAGMENT) {
		/* The minimum usage per wave is (num_inputs * 48). The maximum
		 * usage is (num_inputs * 48 * 16).
		 * We can get anything in between and it varies between waves.
		 *
		 * The 48 bytes per input for a single primitive is equal to
		 * 4 bytes/component * 4 components/input * 3 points.
		 *
		 * Other stages don't know the size at compile time or don't
		 * allocate LDS per wave, but instead they do it per thread group.
		 */
		lds_per_wave = conf->lds_size * lds_increment +
			       align(num_inputs * 48, lds_increment);
	}

	/* Compute the per-SIMD wave counts. */
	if (conf->num_sgprs) {
		if (sscreen->b.chip_class >= VI)
			max_simd_waves = MIN2(max_simd_waves, 800 / conf->num_sgprs);
		else
			max_simd_waves = MIN2(max_simd_waves, 512 / conf->num_sgprs);
	}

	if (conf->num_vgprs)
		max_simd_waves = MIN2(max_simd_waves, 256 / conf->num_vgprs);

	/* LDS is 64KB per CU (4 SIMDs), divided into 16KB blocks per SIMD
	 * that PS can use.
	 */
	if (lds_per_wave)
		max_simd_waves = MIN2(max_simd_waves, 16384 / lds_per_wave);

	if (file != stderr ||
	    r600_can_dump_shader(&sscreen->b, processor)) {
		if (processor == PIPE_SHADER_FRAGMENT) {
			fprintf(file, "*** SHADER CONFIG ***\n"
				"SPI_PS_INPUT_ADDR = 0x%04x\n"
				"SPI_PS_INPUT_ENA  = 0x%04x\n",
				conf->spi_ps_input_addr, conf->spi_ps_input_ena);
		}

		fprintf(file, "*** SHADER STATS ***\n"
			"SGPRS: %d\n"
			"VGPRS: %d\n"
		        "Spilled SGPRs: %d\n"
			"Spilled VGPRs: %d\n"
			"Code Size: %d bytes\n"
			"LDS: %d blocks\n"
			"Scratch: %d bytes per wave\n"
			"Max Waves: %d\n"
			"********************\n\n\n",
			conf->num_sgprs, conf->num_vgprs,
			conf->spilled_sgprs, conf->spilled_vgprs, code_size,
			conf->lds_size, conf->scratch_bytes_per_wave,
			max_simd_waves);
	}

	pipe_debug_message(debug, SHADER_INFO,
			   "Shader Stats: SGPRS: %d VGPRS: %d Code Size: %d "
			   "LDS: %d Scratch: %d Max Waves: %d Spilled SGPRs: %d "
			   "Spilled VGPRs: %d",
			   conf->num_sgprs, conf->num_vgprs, code_size,
			   conf->lds_size, conf->scratch_bytes_per_wave,
			   max_simd_waves, conf->spilled_sgprs,
			   conf->spilled_vgprs);
}

static const char *si_get_shader_name(struct si_shader *shader,
				      unsigned processor)
{
	switch (processor) {
	case PIPE_SHADER_VERTEX:
		if (shader->key.vs.as_es)
			return "Vertex Shader as ES";
		else if (shader->key.vs.as_ls)
			return "Vertex Shader as LS";
		else
			return "Vertex Shader as VS";
	case PIPE_SHADER_TESS_CTRL:
		return "Tessellation Control Shader";
	case PIPE_SHADER_TESS_EVAL:
		if (shader->key.tes.as_es)
			return "Tessellation Evaluation Shader as ES";
		else
			return "Tessellation Evaluation Shader as VS";
	case PIPE_SHADER_GEOMETRY:
		if (shader->gs_copy_shader == NULL)
			return "GS Copy Shader as VS";
		else
			return "Geometry Shader";
	case PIPE_SHADER_FRAGMENT:
		return "Pixel Shader";
	case PIPE_SHADER_COMPUTE:
		return "Compute Shader";
	default:
		return "Unknown Shader";
	}
}

void si_shader_dump(struct si_screen *sscreen, struct si_shader *shader,
		    struct pipe_debug_callback *debug, unsigned processor,
		    FILE *file)
{
	if (file != stderr ||
	    r600_can_dump_shader(&sscreen->b, processor))
		si_dump_shader_key(processor, &shader->key, file);

	if (file != stderr && shader->binary.llvm_ir_string) {
		fprintf(file, "\n%s - main shader part - LLVM IR:\n\n",
			si_get_shader_name(shader, processor));
		fprintf(file, "%s\n", shader->binary.llvm_ir_string);
	}

	if (file != stderr ||
	    (r600_can_dump_shader(&sscreen->b, processor) &&
	     !(sscreen->b.debug_flags & DBG_NO_ASM))) {
		fprintf(file, "\n%s:\n", si_get_shader_name(shader, processor));

		if (shader->prolog)
			si_shader_dump_disassembly(&shader->prolog->binary,
						   debug, "prolog", file);

		si_shader_dump_disassembly(&shader->binary, debug, "main", file);

		if (shader->epilog)
			si_shader_dump_disassembly(&shader->epilog->binary,
						   debug, "epilog", file);
		fprintf(file, "\n");
	}

	si_shader_dump_stats(sscreen, &shader->config,
			     shader->selector ? shader->selector->info.num_inputs : 0,
			     si_get_shader_binary_size(shader), debug, processor,
			     file);
}

int si_compile_llvm(struct si_screen *sscreen,
		    struct radeon_shader_binary *binary,
		    struct si_shader_config *conf,
		    LLVMTargetMachineRef tm,
		    LLVMModuleRef mod,
		    struct pipe_debug_callback *debug,
		    unsigned processor,
		    const char *name)
{
	int r = 0;
	unsigned count = p_atomic_inc_return(&sscreen->b.num_compilations);

	if (r600_can_dump_shader(&sscreen->b, processor)) {
		fprintf(stderr, "radeonsi: Compiling shader %d\n", count);

		if (!(sscreen->b.debug_flags & (DBG_NO_IR | DBG_PREOPT_IR))) {
			fprintf(stderr, "%s LLVM IR:\n\n", name);
			LLVMDumpModule(mod);
			fprintf(stderr, "\n");
		}
	}

	if (sscreen->record_llvm_ir) {
		char *ir = LLVMPrintModuleToString(mod);
		binary->llvm_ir_string = strdup(ir);
		LLVMDisposeMessage(ir);
	}

	if (!si_replace_shader(count, binary)) {
		r = radeon_llvm_compile(mod, binary, tm, debug);
		if (r)
			return r;
	}

	si_shader_binary_read_config(binary, conf, 0);

	/* Enable 64-bit and 16-bit denormals, because there is no performance
	 * cost.
	 *
	 * If denormals are enabled, all floating-point output modifiers are
	 * ignored.
	 *
	 * Don't enable denormals for 32-bit floats, because:
	 * - Floating-point output modifiers would be ignored by the hw.
	 * - Some opcodes don't support denormals, such as v_mad_f32. We would
	 *   have to stop using those.
	 * - SI & CI would be very slow.
	 */
	conf->float_mode |= V_00B028_FP_64_DENORMS;

	FREE(binary->config);
	FREE(binary->global_symbol_offsets);
	binary->config = NULL;
	binary->global_symbol_offsets = NULL;

	/* Some shaders can't have rodata because their binaries can be
	 * concatenated.
	 */
	if (binary->rodata_size &&
	    (processor == PIPE_SHADER_VERTEX ||
	     processor == PIPE_SHADER_TESS_CTRL ||
	     processor == PIPE_SHADER_TESS_EVAL ||
	     processor == PIPE_SHADER_FRAGMENT)) {
		fprintf(stderr, "radeonsi: The shader can't have rodata.");
		return -EINVAL;
	}

	return r;
}

static void si_llvm_build_ret(struct si_shader_context *ctx, LLVMValueRef ret)
{
	if (LLVMGetTypeKind(LLVMTypeOf(ret)) == LLVMVoidTypeKind)
		LLVMBuildRetVoid(ctx->radeon_bld.gallivm.builder);
	else
		LLVMBuildRet(ctx->radeon_bld.gallivm.builder, ret);
}

/* Generate code for the hardware VS shader stage to go with a geometry shader */
static int si_generate_gs_copy_shader(struct si_screen *sscreen,
				      struct si_shader_context *ctx,
				      struct si_shader *gs,
				      struct pipe_debug_callback *debug)
{
	struct gallivm_state *gallivm = &ctx->radeon_bld.gallivm;
	struct lp_build_tgsi_context *bld_base = &ctx->radeon_bld.soa.bld_base;
	struct lp_build_context *uint = &bld_base->uint_bld;
	struct si_shader_output_values *outputs;
	struct tgsi_shader_info *gsinfo = &gs->selector->info;
	LLVMValueRef args[9];
	int i, r;

	outputs = MALLOC(gsinfo->num_outputs * sizeof(outputs[0]));

	si_init_shader_ctx(ctx, sscreen, ctx->shader, ctx->tm);
	ctx->type = PIPE_SHADER_VERTEX;
	ctx->is_gs_copy_shader = true;

	create_meta_data(ctx);
	create_function(ctx);
	preload_streamout_buffers(ctx);
	preload_ring_buffers(ctx);

	args[0] = ctx->gsvs_ring[0];
	args[1] = lp_build_mul_imm(uint,
				   LLVMGetParam(ctx->radeon_bld.main_fn,
						ctx->param_vertex_id),
				   4);
	args[3] = uint->zero;
	args[4] = uint->one;  /* OFFEN */
	args[5] = uint->zero; /* IDXEN */
	args[6] = uint->one;  /* GLC */
	args[7] = uint->one;  /* SLC */
	args[8] = uint->zero; /* TFE */

	/* Fetch vertex data from GSVS ring */
	for (i = 0; i < gsinfo->num_outputs; ++i) {
		unsigned chan;

		outputs[i].name = gsinfo->output_semantic_name[i];
		outputs[i].sid = gsinfo->output_semantic_index[i];

		for (chan = 0; chan < 4; chan++) {
			args[2] = lp_build_const_int32(gallivm,
						       (i * 4 + chan) *
						       gs->selector->gs_max_out_vertices * 16 * 4);

			outputs[i].values[chan] =
				LLVMBuildBitCast(gallivm->builder,
						 lp_build_intrinsic(gallivm->builder,
								 "llvm.SI.buffer.load.dword.i32.i32",
								 ctx->i32, args, 9,
								 LLVMReadOnlyAttribute),
						 ctx->f32, "");
		}
	}

	si_llvm_export_vs(bld_base, outputs, gsinfo->num_outputs);

	LLVMBuildRetVoid(gallivm->builder);

	/* Dump LLVM IR before any optimization passes */
	if (sscreen->b.debug_flags & DBG_PREOPT_IR &&
	    r600_can_dump_shader(&sscreen->b, PIPE_SHADER_GEOMETRY))
		LLVMDumpModule(bld_base->base.gallivm->module);

	radeon_llvm_finalize_module(&ctx->radeon_bld);

	r = si_compile_llvm(sscreen, &ctx->shader->binary,
			    &ctx->shader->config, ctx->tm,
			    bld_base->base.gallivm->module,
			    debug, PIPE_SHADER_GEOMETRY,
			    "GS Copy Shader");
	if (!r) {
		if (r600_can_dump_shader(&sscreen->b, PIPE_SHADER_GEOMETRY))
			fprintf(stderr, "GS Copy Shader:\n");
		si_shader_dump(sscreen, ctx->shader, debug,
			       PIPE_SHADER_GEOMETRY, stderr);
		r = si_shader_binary_upload(sscreen, ctx->shader);
	}

	radeon_llvm_dispose(&ctx->radeon_bld);

	FREE(outputs);
	return r;
}

static void si_dump_shader_key(unsigned shader, union si_shader_key *key,
			       FILE *f)
{
	int i;

	fprintf(f, "SHADER KEY\n");

	switch (shader) {
	case PIPE_SHADER_VERTEX:
		fprintf(f, "  instance_divisors = {");
		for (i = 0; i < ARRAY_SIZE(key->vs.prolog.instance_divisors); i++)
			fprintf(f, !i ? "%u" : ", %u",
				key->vs.prolog.instance_divisors[i]);
		fprintf(f, "}\n");
		fprintf(f, "  as_es = %u\n", key->vs.as_es);
		fprintf(f, "  as_ls = %u\n", key->vs.as_ls);
		fprintf(f, "  export_prim_id = %u\n", key->vs.epilog.export_prim_id);
		break;

	case PIPE_SHADER_TESS_CTRL:
		fprintf(f, "  prim_mode = %u\n", key->tcs.epilog.prim_mode);
		break;

	case PIPE_SHADER_TESS_EVAL:
		fprintf(f, "  as_es = %u\n", key->tes.as_es);
		fprintf(f, "  export_prim_id = %u\n", key->tes.epilog.export_prim_id);
		break;

	case PIPE_SHADER_GEOMETRY:
	case PIPE_SHADER_COMPUTE:
		break;

	case PIPE_SHADER_FRAGMENT:
		fprintf(f, "  prolog.color_two_side = %u\n", key->ps.prolog.color_two_side);
		fprintf(f, "  prolog.flatshade_colors = %u\n", key->ps.prolog.flatshade_colors);
		fprintf(f, "  prolog.poly_stipple = %u\n", key->ps.prolog.poly_stipple);
		fprintf(f, "  prolog.force_persp_sample_interp = %u\n", key->ps.prolog.force_persp_sample_interp);
		fprintf(f, "  prolog.force_linear_sample_interp = %u\n", key->ps.prolog.force_linear_sample_interp);
		fprintf(f, "  prolog.force_persp_center_interp = %u\n", key->ps.prolog.force_persp_center_interp);
		fprintf(f, "  prolog.force_linear_center_interp = %u\n", key->ps.prolog.force_linear_center_interp);
		fprintf(f, "  prolog.bc_optimize_for_persp = %u\n", key->ps.prolog.bc_optimize_for_persp);
		fprintf(f, "  prolog.bc_optimize_for_linear = %u\n", key->ps.prolog.bc_optimize_for_linear);
		fprintf(f, "  epilog.spi_shader_col_format = 0x%x\n", key->ps.epilog.spi_shader_col_format);
		fprintf(f, "  epilog.color_is_int8 = 0x%X\n", key->ps.epilog.color_is_int8);
		fprintf(f, "  epilog.last_cbuf = %u\n", key->ps.epilog.last_cbuf);
		fprintf(f, "  epilog.alpha_func = %u\n", key->ps.epilog.alpha_func);
		fprintf(f, "  epilog.alpha_to_one = %u\n", key->ps.epilog.alpha_to_one);
		fprintf(f, "  epilog.poly_line_smoothing = %u\n", key->ps.epilog.poly_line_smoothing);
		fprintf(f, "  epilog.clamp_color = %u\n", key->ps.epilog.clamp_color);
		break;

	default:
		assert(0);
	}
}

static void si_init_shader_ctx(struct si_shader_context *ctx,
			       struct si_screen *sscreen,
			       struct si_shader *shader,
			       LLVMTargetMachineRef tm)
{
	struct lp_build_tgsi_context *bld_base;
	struct lp_build_tgsi_action tmpl = {};

	memset(ctx, 0, sizeof(*ctx));
	radeon_llvm_context_init(
		&ctx->radeon_bld, "amdgcn--",
		(shader && shader->selector) ? &shader->selector->info : NULL,
		(shader && shader->selector) ? shader->selector->tokens : NULL);
	ctx->tm = tm;
	ctx->screen = sscreen;
	if (shader && shader->selector)
		ctx->type = shader->selector->info.processor;
	else
		ctx->type = -1;
	ctx->shader = shader;

	ctx->voidt = LLVMVoidTypeInContext(ctx->radeon_bld.gallivm.context);
	ctx->i1 = LLVMInt1TypeInContext(ctx->radeon_bld.gallivm.context);
	ctx->i8 = LLVMInt8TypeInContext(ctx->radeon_bld.gallivm.context);
	ctx->i32 = LLVMInt32TypeInContext(ctx->radeon_bld.gallivm.context);
	ctx->i64 = LLVMInt64TypeInContext(ctx->radeon_bld.gallivm.context);
	ctx->i128 = LLVMIntTypeInContext(ctx->radeon_bld.gallivm.context, 128);
	ctx->f32 = LLVMFloatTypeInContext(ctx->radeon_bld.gallivm.context);
	ctx->v16i8 = LLVMVectorType(ctx->i8, 16);
	ctx->v2i32 = LLVMVectorType(ctx->i32, 2);
	ctx->v4i32 = LLVMVectorType(ctx->i32, 4);
	ctx->v4f32 = LLVMVectorType(ctx->f32, 4);
	ctx->v8i32 = LLVMVectorType(ctx->i32, 8);

	bld_base = &ctx->radeon_bld.soa.bld_base;
	bld_base->emit_fetch_funcs[TGSI_FILE_CONSTANT] = fetch_constant;

	bld_base->op_actions[TGSI_OPCODE_INTERP_CENTROID] = interp_action;
	bld_base->op_actions[TGSI_OPCODE_INTERP_SAMPLE] = interp_action;
	bld_base->op_actions[TGSI_OPCODE_INTERP_OFFSET] = interp_action;

	bld_base->op_actions[TGSI_OPCODE_TEX] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TEX2] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TXB] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TXB2] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TXD] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TXF] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TXL] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TXL2] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TXP] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TXQ].fetch_args = txq_fetch_args;
	bld_base->op_actions[TGSI_OPCODE_TXQ].emit = txq_emit;
	bld_base->op_actions[TGSI_OPCODE_TG4] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_LODQ] = tex_action;
	bld_base->op_actions[TGSI_OPCODE_TXQS].emit = si_llvm_emit_txqs;

	bld_base->op_actions[TGSI_OPCODE_LOAD].fetch_args = load_fetch_args;
	bld_base->op_actions[TGSI_OPCODE_LOAD].emit = load_emit;
	bld_base->op_actions[TGSI_OPCODE_STORE].fetch_args = store_fetch_args;
	bld_base->op_actions[TGSI_OPCODE_STORE].emit = store_emit;
	bld_base->op_actions[TGSI_OPCODE_RESQ].fetch_args = resq_fetch_args;
	bld_base->op_actions[TGSI_OPCODE_RESQ].emit = resq_emit;

	tmpl.fetch_args = atomic_fetch_args;
	tmpl.emit = atomic_emit;
	bld_base->op_actions[TGSI_OPCODE_ATOMUADD] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMUADD].intr_name = "add";
	bld_base->op_actions[TGSI_OPCODE_ATOMXCHG] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMXCHG].intr_name = "swap";
	bld_base->op_actions[TGSI_OPCODE_ATOMCAS] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMCAS].intr_name = "cmpswap";
	bld_base->op_actions[TGSI_OPCODE_ATOMAND] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMAND].intr_name = "and";
	bld_base->op_actions[TGSI_OPCODE_ATOMOR] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMOR].intr_name = "or";
	bld_base->op_actions[TGSI_OPCODE_ATOMXOR] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMXOR].intr_name = "xor";
	bld_base->op_actions[TGSI_OPCODE_ATOMUMIN] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMUMIN].intr_name = "umin";
	bld_base->op_actions[TGSI_OPCODE_ATOMUMAX] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMUMAX].intr_name = "umax";
	bld_base->op_actions[TGSI_OPCODE_ATOMIMIN] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMIMIN].intr_name = "smin";
	bld_base->op_actions[TGSI_OPCODE_ATOMIMAX] = tmpl;
	bld_base->op_actions[TGSI_OPCODE_ATOMIMAX].intr_name = "smax";

	bld_base->op_actions[TGSI_OPCODE_MEMBAR].emit = membar_emit;

	bld_base->op_actions[TGSI_OPCODE_DDX].emit = si_llvm_emit_ddxy;
	bld_base->op_actions[TGSI_OPCODE_DDY].emit = si_llvm_emit_ddxy;
	bld_base->op_actions[TGSI_OPCODE_DDX_FINE].emit = si_llvm_emit_ddxy;
	bld_base->op_actions[TGSI_OPCODE_DDY_FINE].emit = si_llvm_emit_ddxy;

	bld_base->op_actions[TGSI_OPCODE_EMIT].emit = si_llvm_emit_vertex;
	bld_base->op_actions[TGSI_OPCODE_ENDPRIM].emit = si_llvm_emit_primitive;
	bld_base->op_actions[TGSI_OPCODE_BARRIER].emit = si_llvm_emit_barrier;

	bld_base->op_actions[TGSI_OPCODE_MAX].emit = build_tgsi_intrinsic_nomem;
	bld_base->op_actions[TGSI_OPCODE_MAX].intr_name = "llvm.maxnum.f32";
	bld_base->op_actions[TGSI_OPCODE_MIN].emit = build_tgsi_intrinsic_nomem;
	bld_base->op_actions[TGSI_OPCODE_MIN].intr_name = "llvm.minnum.f32";
}

int si_compile_tgsi_shader(struct si_screen *sscreen,
			   LLVMTargetMachineRef tm,
			   struct si_shader *shader,
			   bool is_monolithic,
			   struct pipe_debug_callback *debug)
{
	struct si_shader_selector *sel = shader->selector;
	struct si_shader_context ctx;
	struct lp_build_tgsi_context *bld_base;
	LLVMModuleRef mod;
	int r = 0;

	/* Dump TGSI code before doing TGSI->LLVM conversion in case the
	 * conversion fails. */
	if (r600_can_dump_shader(&sscreen->b, sel->info.processor) &&
	    !(sscreen->b.debug_flags & DBG_NO_TGSI)) {
		tgsi_dump(sel->tokens, 0);
		si_dump_streamout(&sel->so);
	}

	si_init_shader_ctx(&ctx, sscreen, shader, tm);
	ctx.is_monolithic = is_monolithic;

	shader->info.uses_instanceid = sel->info.uses_instanceid;

	bld_base = &ctx.radeon_bld.soa.bld_base;
	ctx.radeon_bld.load_system_value = declare_system_value;

	switch (ctx.type) {
	case PIPE_SHADER_VERTEX:
		ctx.radeon_bld.load_input = declare_input_vs;
		if (shader->key.vs.as_ls)
			bld_base->emit_epilogue = si_llvm_emit_ls_epilogue;
		else if (shader->key.vs.as_es)
			bld_base->emit_epilogue = si_llvm_emit_es_epilogue;
		else
			bld_base->emit_epilogue = si_llvm_emit_vs_epilogue;
		break;
	case PIPE_SHADER_TESS_CTRL:
		bld_base->emit_fetch_funcs[TGSI_FILE_INPUT] = fetch_input_tcs;
		bld_base->emit_fetch_funcs[TGSI_FILE_OUTPUT] = fetch_output_tcs;
		bld_base->emit_store = store_output_tcs;
		bld_base->emit_epilogue = si_llvm_emit_tcs_epilogue;
		break;
	case PIPE_SHADER_TESS_EVAL:
		bld_base->emit_fetch_funcs[TGSI_FILE_INPUT] = fetch_input_tes;
		if (shader->key.tes.as_es)
			bld_base->emit_epilogue = si_llvm_emit_es_epilogue;
		else
			bld_base->emit_epilogue = si_llvm_emit_vs_epilogue;
		break;
	case PIPE_SHADER_GEOMETRY:
		bld_base->emit_fetch_funcs[TGSI_FILE_INPUT] = fetch_input_gs;
		bld_base->emit_epilogue = si_llvm_emit_gs_epilogue;
		break;
	case PIPE_SHADER_FRAGMENT:
		ctx.radeon_bld.load_input = declare_input_fs;
		if (is_monolithic)
			bld_base->emit_epilogue = si_llvm_emit_fs_epilogue;
		else
			bld_base->emit_epilogue = si_llvm_return_fs_outputs;
		break;
	case PIPE_SHADER_COMPUTE:
		ctx.radeon_bld.declare_memory_region = declare_compute_memory;
		break;
	default:
		assert(!"Unsupported shader type");
		return -1;
	}

	create_meta_data(&ctx);
	create_function(&ctx);
	preload_constants(&ctx);
	preload_shader_buffers(&ctx);
	preload_samplers(&ctx);
	preload_images(&ctx);
	preload_streamout_buffers(&ctx);
	preload_ring_buffers(&ctx);

	if (ctx.is_monolithic && sel->type == PIPE_SHADER_FRAGMENT &&
	    shader->key.ps.prolog.poly_stipple) {
		LLVMValueRef list = LLVMGetParam(ctx.radeon_bld.main_fn,
						 SI_PARAM_RW_BUFFERS);
		si_llvm_emit_polygon_stipple(&ctx, list,
					     SI_PARAM_POS_FIXED_PT);
	}

	if (ctx.type == PIPE_SHADER_GEOMETRY) {
		int i;
		for (i = 0; i < 4; i++) {
			ctx.gs_next_vertex[i] =
				lp_build_alloca(bld_base->base.gallivm,
						ctx.i32, "");
		}
	}

	if (!lp_build_tgsi_llvm(bld_base, sel->tokens)) {
		fprintf(stderr, "Failed to translate shader from TGSI to LLVM\n");
		goto out;
	}

	si_llvm_build_ret(&ctx, ctx.return_value);
	mod = bld_base->base.gallivm->module;

	/* Dump LLVM IR before any optimization passes */
	if (sscreen->b.debug_flags & DBG_PREOPT_IR &&
	    r600_can_dump_shader(&sscreen->b, ctx.type))
		LLVMDumpModule(mod);

	radeon_llvm_finalize_module(&ctx.radeon_bld);

	r = si_compile_llvm(sscreen, &shader->binary, &shader->config, tm,
			    mod, debug, ctx.type, "TGSI shader");
	if (r) {
		fprintf(stderr, "LLVM failed to compile shader\n");
		goto out;
	}

	radeon_llvm_dispose(&ctx.radeon_bld);

	/* Validate SGPR and VGPR usage for compute to detect compiler bugs.
	 * LLVM 3.9svn has this bug.
	 */
	if (sel->type == PIPE_SHADER_COMPUTE) {
		unsigned *props = sel->info.properties;
		unsigned wave_size = 64;
		unsigned max_vgprs = 256;
		unsigned max_sgprs = sscreen->b.chip_class >= VI ? 800 : 512;
		unsigned max_sgprs_per_wave = 128;
		unsigned min_waves_per_cu =
			DIV_ROUND_UP(props[TGSI_PROPERTY_CS_FIXED_BLOCK_WIDTH] *
				     props[TGSI_PROPERTY_CS_FIXED_BLOCK_HEIGHT] *
				     props[TGSI_PROPERTY_CS_FIXED_BLOCK_DEPTH],
				     wave_size);
		unsigned min_waves_per_simd = DIV_ROUND_UP(min_waves_per_cu, 4);

		max_vgprs = max_vgprs / min_waves_per_simd;
		max_sgprs = MIN2(max_sgprs / min_waves_per_simd, max_sgprs_per_wave);

		if (shader->config.num_sgprs > max_sgprs ||
		    shader->config.num_vgprs > max_vgprs) {
			fprintf(stderr, "LLVM failed to compile a shader correctly: "
				"SGPR:VGPR usage is %u:%u, but the hw limit is %u:%u\n",
				shader->config.num_sgprs, shader->config.num_vgprs,
				max_sgprs, max_vgprs);

			/* Just terminate the process, because dependent
			 * shaders can hang due to bad input data, but use
			 * the env var to allow shader-db to work.
			 */
			if (!debug_get_bool_option("SI_PASS_BAD_SHADERS", false))
				abort();
		}
	}

	/* Add the scratch offset to input SGPRs. */
	if (shader->config.scratch_bytes_per_wave)
		shader->info.num_input_sgprs += 1; /* scratch byte offset */

	/* Calculate the number of fragment input VGPRs. */
	if (ctx.type == PIPE_SHADER_FRAGMENT) {
		shader->info.num_input_vgprs = 0;
		shader->info.face_vgpr_index = -1;

		if (G_0286CC_PERSP_SAMPLE_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 2;
		if (G_0286CC_PERSP_CENTER_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 2;
		if (G_0286CC_PERSP_CENTROID_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 2;
		if (G_0286CC_PERSP_PULL_MODEL_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 3;
		if (G_0286CC_LINEAR_SAMPLE_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 2;
		if (G_0286CC_LINEAR_CENTER_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 2;
		if (G_0286CC_LINEAR_CENTROID_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 2;
		if (G_0286CC_LINE_STIPPLE_TEX_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 1;
		if (G_0286CC_POS_X_FLOAT_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 1;
		if (G_0286CC_POS_Y_FLOAT_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 1;
		if (G_0286CC_POS_Z_FLOAT_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 1;
		if (G_0286CC_POS_W_FLOAT_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 1;
		if (G_0286CC_FRONT_FACE_ENA(shader->config.spi_ps_input_addr)) {
			shader->info.face_vgpr_index = shader->info.num_input_vgprs;
			shader->info.num_input_vgprs += 1;
		}
		if (G_0286CC_ANCILLARY_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 1;
		if (G_0286CC_SAMPLE_COVERAGE_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 1;
		if (G_0286CC_POS_FIXED_PT_ENA(shader->config.spi_ps_input_addr))
			shader->info.num_input_vgprs += 1;
	}

	if (ctx.type == PIPE_SHADER_GEOMETRY) {
		shader->gs_copy_shader = CALLOC_STRUCT(si_shader);
		shader->gs_copy_shader->selector = shader->selector;
		ctx.shader = shader->gs_copy_shader;
		if ((r = si_generate_gs_copy_shader(sscreen, &ctx,
						    shader, debug))) {
			free(shader->gs_copy_shader);
			shader->gs_copy_shader = NULL;
			goto out;
		}
	}

out:
	for (int i = 0; i < SI_NUM_CONST_BUFFERS; i++)
		FREE(ctx.constants[i]);
	return r;
}

/**
 * Create, compile and return a shader part (prolog or epilog).
 *
 * \param sscreen	screen
 * \param list		list of shader parts of the same category
 * \param key		shader part key
 * \param tm		LLVM target machine
 * \param debug		debug callback
 * \param compile	the callback responsible for compilation
 * \return		non-NULL on success
 */
static struct si_shader_part *
si_get_shader_part(struct si_screen *sscreen,
		   struct si_shader_part **list,
		   union si_shader_part_key *key,
		   LLVMTargetMachineRef tm,
		   struct pipe_debug_callback *debug,
		   bool (*compile)(struct si_screen *,
				   LLVMTargetMachineRef,
				   struct pipe_debug_callback *,
				   struct si_shader_part *))
{
	struct si_shader_part *result;

	pipe_mutex_lock(sscreen->shader_parts_mutex);

	/* Find existing. */
	for (result = *list; result; result = result->next) {
		if (memcmp(&result->key, key, sizeof(*key)) == 0) {
			pipe_mutex_unlock(sscreen->shader_parts_mutex);
			return result;
		}
	}

	/* Compile a new one. */
	result = CALLOC_STRUCT(si_shader_part);
	result->key = *key;
	if (!compile(sscreen, tm, debug, result)) {
		FREE(result);
		pipe_mutex_unlock(sscreen->shader_parts_mutex);
		return NULL;
	}

	result->next = *list;
	*list = result;
	pipe_mutex_unlock(sscreen->shader_parts_mutex);
	return result;
}

/**
 * Create a vertex shader prolog.
 *
 * The inputs are the same as VS (a lot of SGPRs and 4 VGPR system values).
 * All inputs are returned unmodified. The vertex load indices are
 * stored after them, which will used by the API VS for fetching inputs.
 *
 * For example, the expected outputs for instance_divisors[] = {0, 1, 2} are:
 *   input_v0,
 *   input_v1,
 *   input_v2,
 *   input_v3,
 *   (VertexID + BaseVertex),
 *   (InstanceID + StartInstance),
 *   (InstanceID / 2 + StartInstance)
 */
static bool si_compile_vs_prolog(struct si_screen *sscreen,
				 LLVMTargetMachineRef tm,
				 struct pipe_debug_callback *debug,
				 struct si_shader_part *out)
{
	union si_shader_part_key *key = &out->key;
	struct si_shader shader = {};
	struct si_shader_context ctx;
	struct gallivm_state *gallivm = &ctx.radeon_bld.gallivm;
	LLVMTypeRef *params, *returns;
	LLVMValueRef ret, func;
	int last_sgpr, num_params, num_returns, i;
	bool status = true;

	si_init_shader_ctx(&ctx, sscreen, &shader, tm);
	ctx.type = PIPE_SHADER_VERTEX;
	ctx.param_vertex_id = key->vs_prolog.num_input_sgprs;
	ctx.param_instance_id = key->vs_prolog.num_input_sgprs + 3;

	/* 4 preloaded VGPRs + vertex load indices as prolog outputs */
	params = alloca((key->vs_prolog.num_input_sgprs + 4) *
			sizeof(LLVMTypeRef));
	returns = alloca((key->vs_prolog.num_input_sgprs + 4 +
			  key->vs_prolog.last_input + 1) *
			 sizeof(LLVMTypeRef));
	num_params = 0;
	num_returns = 0;

	/* Declare input and output SGPRs. */
	num_params = 0;
	for (i = 0; i < key->vs_prolog.num_input_sgprs; i++) {
		params[num_params++] = ctx.i32;
		returns[num_returns++] = ctx.i32;
	}
	last_sgpr = num_params - 1;

	/* 4 preloaded VGPRs (outputs must be floats) */
	for (i = 0; i < 4; i++) {
		params[num_params++] = ctx.i32;
		returns[num_returns++] = ctx.f32;
	}

	/* Vertex load indices. */
	for (i = 0; i <= key->vs_prolog.last_input; i++)
		returns[num_returns++] = ctx.f32;

	/* Create the function. */
	si_create_function(&ctx, returns, num_returns, params,
			   num_params, last_sgpr);
	func = ctx.radeon_bld.main_fn;

	/* Copy inputs to outputs. This should be no-op, as the registers match,
	 * but it will prevent the compiler from overwriting them unintentionally.
	 */
	ret = ctx.return_value;
	for (i = 0; i < key->vs_prolog.num_input_sgprs; i++) {
		LLVMValueRef p = LLVMGetParam(func, i);
		ret = LLVMBuildInsertValue(gallivm->builder, ret, p, i, "");
	}
	for (i = num_params - 4; i < num_params; i++) {
		LLVMValueRef p = LLVMGetParam(func, i);
		p = LLVMBuildBitCast(gallivm->builder, p, ctx.f32, "");
		ret = LLVMBuildInsertValue(gallivm->builder, ret, p, i, "");
	}

	/* Compute vertex load indices from instance divisors. */
	for (i = 0; i <= key->vs_prolog.last_input; i++) {
		unsigned divisor = key->vs_prolog.states.instance_divisors[i];
		LLVMValueRef index;

		if (divisor) {
			/* InstanceID / Divisor + StartInstance */
			index = get_instance_index_for_fetch(&ctx.radeon_bld,
							     SI_SGPR_START_INSTANCE,
							     divisor);
		} else {
			/* VertexID + BaseVertex */
			index = LLVMBuildAdd(gallivm->builder,
					     LLVMGetParam(func, ctx.param_vertex_id),
					     LLVMGetParam(func, SI_SGPR_BASE_VERTEX), "");
		}

		index = LLVMBuildBitCast(gallivm->builder, index, ctx.f32, "");
		ret = LLVMBuildInsertValue(gallivm->builder, ret, index,
					   num_params++, "");
	}

	/* Compile. */
	si_llvm_build_ret(&ctx, ret);
	radeon_llvm_finalize_module(&ctx.radeon_bld);

	if (si_compile_llvm(sscreen, &out->binary, &out->config, tm,
			    gallivm->module, debug, ctx.type,
			    "Vertex Shader Prolog"))
		status = false;

	radeon_llvm_dispose(&ctx.radeon_bld);
	return status;
}

/**
 * Compile the vertex shader epilog. This is also used by the tessellation
 * evaluation shader compiled as VS.
 *
 * The input is PrimitiveID.
 *
 * If PrimitiveID is required by the pixel shader, export it.
 * Otherwise, do nothing.
 */
static bool si_compile_vs_epilog(struct si_screen *sscreen,
				 LLVMTargetMachineRef tm,
				 struct pipe_debug_callback *debug,
				 struct si_shader_part *out)
{
	union si_shader_part_key *key = &out->key;
	struct si_shader_context ctx;
	struct gallivm_state *gallivm = &ctx.radeon_bld.gallivm;
	struct lp_build_tgsi_context *bld_base = &ctx.radeon_bld.soa.bld_base;
	LLVMTypeRef params[5];
	int num_params, i;
	bool status = true;

	si_init_shader_ctx(&ctx, sscreen, NULL, tm);
	ctx.type = PIPE_SHADER_VERTEX;

	/* Declare input VGPRs. */
	num_params = key->vs_epilog.states.export_prim_id ?
			   (VS_EPILOG_PRIMID_LOC + 1) : 0;
	assert(num_params <= ARRAY_SIZE(params));

	for (i = 0; i < num_params; i++)
		params[i] = ctx.f32;

	/* Create the function. */
	si_create_function(&ctx, NULL, 0, params, num_params, -1);

	/* Emit exports. */
	if (key->vs_epilog.states.export_prim_id) {
		struct lp_build_context *base = &bld_base->base;
		struct lp_build_context *uint = &bld_base->uint_bld;
		LLVMValueRef args[9];

		args[0] = lp_build_const_int32(base->gallivm, 0x0); /* enabled channels */
		args[1] = uint->zero; /* whether the EXEC mask is valid */
		args[2] = uint->zero; /* DONE bit */
		args[3] = lp_build_const_int32(base->gallivm, V_008DFC_SQ_EXP_PARAM +
					       key->vs_epilog.prim_id_param_offset);
		args[4] = uint->zero; /* COMPR flag (0 = 32-bit export) */
		args[5] = LLVMGetParam(ctx.radeon_bld.main_fn,
				       VS_EPILOG_PRIMID_LOC); /* X */
		args[6] = uint->undef; /* Y */
		args[7] = uint->undef; /* Z */
		args[8] = uint->undef; /* W */

		lp_build_intrinsic(base->gallivm->builder, "llvm.SI.export",
				   LLVMVoidTypeInContext(base->gallivm->context),
				   args, 9, 0);
	}

	/* Compile. */
	LLVMBuildRetVoid(gallivm->builder);
	radeon_llvm_finalize_module(&ctx.radeon_bld);

	if (si_compile_llvm(sscreen, &out->binary, &out->config, tm,
			    gallivm->module, debug, ctx.type,
			    "Vertex Shader Epilog"))
		status = false;

	radeon_llvm_dispose(&ctx.radeon_bld);
	return status;
}

/**
 * Create & compile a vertex shader epilog. This a helper used by VS and TES.
 */
static bool si_get_vs_epilog(struct si_screen *sscreen,
			     LLVMTargetMachineRef tm,
		             struct si_shader *shader,
		             struct pipe_debug_callback *debug,
			     struct si_vs_epilog_bits *states)
{
	union si_shader_part_key epilog_key;

	memset(&epilog_key, 0, sizeof(epilog_key));
	epilog_key.vs_epilog.states = *states;

	/* Set up the PrimitiveID output. */
	if (shader->key.vs.epilog.export_prim_id) {
		unsigned index = shader->selector->info.num_outputs;
		unsigned offset = shader->info.nr_param_exports++;

		epilog_key.vs_epilog.prim_id_param_offset = offset;
		assert(index < ARRAY_SIZE(shader->info.vs_output_param_offset));
		shader->info.vs_output_param_offset[index] = offset;
	}

	shader->epilog = si_get_shader_part(sscreen, &sscreen->vs_epilogs,
					    &epilog_key, tm, debug,
					    si_compile_vs_epilog);
	return shader->epilog != NULL;
}

/**
 * Select and compile (or reuse) vertex shader parts (prolog & epilog).
 */
static bool si_shader_select_vs_parts(struct si_screen *sscreen,
				      LLVMTargetMachineRef tm,
				      struct si_shader *shader,
				      struct pipe_debug_callback *debug)
{
	struct tgsi_shader_info *info = &shader->selector->info;
	union si_shader_part_key prolog_key;
	unsigned i;

	/* Get the prolog. */
	memset(&prolog_key, 0, sizeof(prolog_key));
	prolog_key.vs_prolog.states = shader->key.vs.prolog;
	prolog_key.vs_prolog.num_input_sgprs = shader->info.num_input_sgprs;
	prolog_key.vs_prolog.last_input = MAX2(1, info->num_inputs) - 1;

	/* The prolog is a no-op if there are no inputs. */
	if (info->num_inputs) {
		shader->prolog =
			si_get_shader_part(sscreen, &sscreen->vs_prologs,
					   &prolog_key, tm, debug,
					   si_compile_vs_prolog);
		if (!shader->prolog)
			return false;
	}

	/* Get the epilog. */
	if (!shader->key.vs.as_es && !shader->key.vs.as_ls &&
	    !si_get_vs_epilog(sscreen, tm, shader, debug,
			      &shader->key.vs.epilog))
		return false;

	/* Set the instanceID flag. */
	for (i = 0; i < info->num_inputs; i++)
		if (prolog_key.vs_prolog.states.instance_divisors[i])
			shader->info.uses_instanceid = true;

	return true;
}

/**
 * Select and compile (or reuse) TES parts (epilog).
 */
static bool si_shader_select_tes_parts(struct si_screen *sscreen,
				       LLVMTargetMachineRef tm,
				       struct si_shader *shader,
				       struct pipe_debug_callback *debug)
{
	if (shader->key.tes.as_es)
		return true;

	/* TES compiled as VS. */
	return si_get_vs_epilog(sscreen, tm, shader, debug,
				&shader->key.tes.epilog);
}

/**
 * Compile the TCS epilog. This writes tesselation factors to memory based on
 * the output primitive type of the tesselator (determined by TES).
 */
static bool si_compile_tcs_epilog(struct si_screen *sscreen,
				  LLVMTargetMachineRef tm,
				  struct pipe_debug_callback *debug,
				  struct si_shader_part *out)
{
	union si_shader_part_key *key = &out->key;
	struct si_shader shader = {};
	struct si_shader_context ctx;
	struct gallivm_state *gallivm = &ctx.radeon_bld.gallivm;
	struct lp_build_tgsi_context *bld_base = &ctx.radeon_bld.soa.bld_base;
	LLVMTypeRef params[16];
	LLVMValueRef func;
	int last_sgpr, num_params;
	bool status = true;

	si_init_shader_ctx(&ctx, sscreen, &shader, tm);
	ctx.type = PIPE_SHADER_TESS_CTRL;
	shader.key.tcs.epilog = key->tcs_epilog.states;

	/* Declare inputs. Only RW_BUFFERS and TESS_FACTOR_OFFSET are used. */
	params[SI_PARAM_RW_BUFFERS] = const_array(ctx.v16i8, SI_NUM_RW_BUFFERS);
	params[SI_PARAM_CONST_BUFFERS] = ctx.i64;
	params[SI_PARAM_SAMPLERS] = ctx.i64;
	params[SI_PARAM_IMAGES] = ctx.i64;
	params[SI_PARAM_SHADER_BUFFERS] = ctx.i64;
	params[SI_PARAM_TCS_OFFCHIP_LAYOUT] = ctx.i32;
	params[SI_PARAM_TCS_OUT_OFFSETS] = ctx.i32;
	params[SI_PARAM_TCS_OUT_LAYOUT] = ctx.i32;
	params[SI_PARAM_TCS_IN_LAYOUT] = ctx.i32;
	params[ctx.param_oc_lds = SI_PARAM_TCS_OC_LDS] = ctx.i32;
	params[SI_PARAM_TESS_FACTOR_OFFSET] = ctx.i32;
	last_sgpr = SI_PARAM_TESS_FACTOR_OFFSET;
	num_params = last_sgpr + 1;

	params[num_params++] = ctx.i32; /* patch index within the wave (REL_PATCH_ID) */
	params[num_params++] = ctx.i32; /* invocation ID within the patch */
	params[num_params++] = ctx.i32; /* LDS offset where tess factors should be loaded from */

	/* Create the function. */
	si_create_function(&ctx, NULL, 0, params, num_params, last_sgpr);
	declare_tess_lds(&ctx);
	func = ctx.radeon_bld.main_fn;

	si_write_tess_factors(bld_base,
			      LLVMGetParam(func, last_sgpr + 1),
			      LLVMGetParam(func, last_sgpr + 2),
			      LLVMGetParam(func, last_sgpr + 3));

	/* Compile. */
	LLVMBuildRetVoid(gallivm->builder);
	radeon_llvm_finalize_module(&ctx.radeon_bld);

	if (si_compile_llvm(sscreen, &out->binary, &out->config, tm,
			    gallivm->module, debug, ctx.type,
			    "Tessellation Control Shader Epilog"))
		status = false;

	radeon_llvm_dispose(&ctx.radeon_bld);
	return status;
}

/**
 * Select and compile (or reuse) TCS parts (epilog).
 */
static bool si_shader_select_tcs_parts(struct si_screen *sscreen,
				       LLVMTargetMachineRef tm,
				       struct si_shader *shader,
				       struct pipe_debug_callback *debug)
{
	union si_shader_part_key epilog_key;

	/* Get the epilog. */
	memset(&epilog_key, 0, sizeof(epilog_key));
	epilog_key.tcs_epilog.states = shader->key.tcs.epilog;

	shader->epilog = si_get_shader_part(sscreen, &sscreen->tcs_epilogs,
					    &epilog_key, tm, debug,
					    si_compile_tcs_epilog);
	return shader->epilog != NULL;
}

/**
 * Compile the pixel shader prolog. This handles:
 * - two-side color selection and interpolation
 * - overriding interpolation parameters for the API PS
 * - polygon stippling
 *
 * All preloaded SGPRs and VGPRs are passed through unmodified unless they are
 * overriden by other states. (e.g. per-sample interpolation)
 * Interpolated colors are stored after the preloaded VGPRs.
 */
static bool si_compile_ps_prolog(struct si_screen *sscreen,
				 LLVMTargetMachineRef tm,
				 struct pipe_debug_callback *debug,
				 struct si_shader_part *out)
{
	union si_shader_part_key *key = &out->key;
	struct si_shader shader = {};
	struct si_shader_context ctx;
	struct gallivm_state *gallivm = &ctx.radeon_bld.gallivm;
	LLVMTypeRef *params;
	LLVMValueRef ret, func;
	int last_sgpr, num_params, num_returns, i, num_color_channels;
	bool status = true;

	si_init_shader_ctx(&ctx, sscreen, &shader, tm);
	ctx.type = PIPE_SHADER_FRAGMENT;
	shader.key.ps.prolog = key->ps_prolog.states;

	/* Number of inputs + 8 color elements. */
	params = alloca((key->ps_prolog.num_input_sgprs +
			 key->ps_prolog.num_input_vgprs + 8) *
			sizeof(LLVMTypeRef));

	/* Declare inputs. */
	num_params = 0;
	for (i = 0; i < key->ps_prolog.num_input_sgprs; i++)
		params[num_params++] = ctx.i32;
	last_sgpr = num_params - 1;

	for (i = 0; i < key->ps_prolog.num_input_vgprs; i++)
		params[num_params++] = ctx.f32;

	/* Declare outputs (same as inputs + add colors if needed) */
	num_returns = num_params;
	num_color_channels = util_bitcount(key->ps_prolog.colors_read);
	for (i = 0; i < num_color_channels; i++)
		params[num_returns++] = ctx.f32;

	/* Create the function. */
	si_create_function(&ctx, params, num_returns, params,
			   num_params, last_sgpr);
	func = ctx.radeon_bld.main_fn;

	/* Copy inputs to outputs. This should be no-op, as the registers match,
	 * but it will prevent the compiler from overwriting them unintentionally.
	 */
	ret = ctx.return_value;
	for (i = 0; i < num_params; i++) {
		LLVMValueRef p = LLVMGetParam(func, i);
		ret = LLVMBuildInsertValue(gallivm->builder, ret, p, i, "");
	}

	/* Polygon stippling. */
	if (key->ps_prolog.states.poly_stipple) {
		/* POS_FIXED_PT is always last. */
		unsigned pos = key->ps_prolog.num_input_sgprs +
			       key->ps_prolog.num_input_vgprs - 1;
		LLVMValueRef ptr[2], list;

		/* Get the pointer to rw buffers. */
		ptr[0] = LLVMGetParam(func, SI_SGPR_RW_BUFFERS);
		ptr[1] = LLVMGetParam(func, SI_SGPR_RW_BUFFERS_HI);
		list = lp_build_gather_values(gallivm, ptr, 2);
		list = LLVMBuildBitCast(gallivm->builder, list, ctx.i64, "");
		list = LLVMBuildIntToPtr(gallivm->builder, list,
					  const_array(ctx.v16i8, SI_NUM_RW_BUFFERS), "");

		si_llvm_emit_polygon_stipple(&ctx, list, pos);
	}

	if (key->ps_prolog.states.bc_optimize_for_persp ||
	    key->ps_prolog.states.bc_optimize_for_linear) {
		unsigned i, base = key->ps_prolog.num_input_sgprs;
		LLVMValueRef center[2], centroid[2], tmp, bc_optimize;

		/* The shader should do: if (PRIM_MASK[31]) CENTROID = CENTER;
		 * The hw doesn't compute CENTROID if the whole wave only
		 * contains fully-covered quads.
		 *
		 * PRIM_MASK is after user SGPRs.
		 */
		bc_optimize = LLVMGetParam(func, SI_PS_NUM_USER_SGPR);
		bc_optimize = LLVMBuildLShr(gallivm->builder, bc_optimize,
					    LLVMConstInt(ctx.i32, 31, 0), "");
		bc_optimize = LLVMBuildTrunc(gallivm->builder, bc_optimize,
					     ctx.i1, "");

		if (key->ps_prolog.states.bc_optimize_for_persp) {
			/* Read PERSP_CENTER. */
			for (i = 0; i < 2; i++)
				center[i] = LLVMGetParam(func, base + 2 + i);
			/* Read PERSP_CENTROID. */
			for (i = 0; i < 2; i++)
				centroid[i] = LLVMGetParam(func, base + 4 + i);
			/* Select PERSP_CENTROID. */
			for (i = 0; i < 2; i++) {
				tmp = LLVMBuildSelect(gallivm->builder, bc_optimize,
						      center[i], centroid[i], "");
				ret = LLVMBuildInsertValue(gallivm->builder, ret,
							   tmp, base + 4 + i, "");
			}
		}
		if (key->ps_prolog.states.bc_optimize_for_linear) {
			/* Read LINEAR_CENTER. */
			for (i = 0; i < 2; i++)
				center[i] = LLVMGetParam(func, base + 8 + i);
			/* Read LINEAR_CENTROID. */
			for (i = 0; i < 2; i++)
				centroid[i] = LLVMGetParam(func, base + 10 + i);
			/* Select LINEAR_CENTROID. */
			for (i = 0; i < 2; i++) {
				tmp = LLVMBuildSelect(gallivm->builder, bc_optimize,
						      center[i], centroid[i], "");
				ret = LLVMBuildInsertValue(gallivm->builder, ret,
							   tmp, base + 10 + i, "");
			}
		}
	}

	/* Interpolate colors. */
	for (i = 0; i < 2; i++) {
		unsigned writemask = (key->ps_prolog.colors_read >> (i * 4)) & 0xf;
		unsigned face_vgpr = key->ps_prolog.num_input_sgprs +
				     key->ps_prolog.face_vgpr_index;
		LLVMValueRef interp[2], color[4];
		LLVMValueRef interp_ij = NULL, prim_mask = NULL, face = NULL;

		if (!writemask)
			continue;

		/* If the interpolation qualifier is not CONSTANT (-1). */
		if (key->ps_prolog.color_interp_vgpr_index[i] != -1) {
			unsigned interp_vgpr = key->ps_prolog.num_input_sgprs +
					       key->ps_prolog.color_interp_vgpr_index[i];

			/* Get the (i,j) updated by bc_optimize handling. */
			interp[0] = LLVMBuildExtractValue(gallivm->builder, ret,
							  interp_vgpr, "");
			interp[1] = LLVMBuildExtractValue(gallivm->builder, ret,
							  interp_vgpr + 1, "");
			interp_ij = lp_build_gather_values(gallivm, interp, 2);
			interp_ij = LLVMBuildBitCast(gallivm->builder, interp_ij,
						     ctx.v2i32, "");
		}

		/* Use the absolute location of the input. */
		prim_mask = LLVMGetParam(func, SI_PS_NUM_USER_SGPR);

		if (key->ps_prolog.states.color_two_side) {
			face = LLVMGetParam(func, face_vgpr);
			face = LLVMBuildBitCast(gallivm->builder, face, ctx.i32, "");
		}

		interp_fs_input(&ctx,
				key->ps_prolog.color_attr_index[i],
				TGSI_SEMANTIC_COLOR, i,
				key->ps_prolog.num_interp_inputs,
				key->ps_prolog.colors_read, interp_ij,
				prim_mask, face, color);

		while (writemask) {
			unsigned chan = u_bit_scan(&writemask);
			ret = LLVMBuildInsertValue(gallivm->builder, ret, color[chan],
						   num_params++, "");
		}
	}

	/* Force per-sample interpolation. */
	if (key->ps_prolog.states.force_persp_sample_interp) {
		unsigned i, base = key->ps_prolog.num_input_sgprs;
		LLVMValueRef persp_sample[2];

		/* Read PERSP_SAMPLE. */
		for (i = 0; i < 2; i++)
			persp_sample[i] = LLVMGetParam(func, base + i);
		/* Overwrite PERSP_CENTER. */
		for (i = 0; i < 2; i++)
			ret = LLVMBuildInsertValue(gallivm->builder, ret,
						   persp_sample[i], base + 2 + i, "");
		/* Overwrite PERSP_CENTROID. */
		for (i = 0; i < 2; i++)
			ret = LLVMBuildInsertValue(gallivm->builder, ret,
						   persp_sample[i], base + 4 + i, "");
	}
	if (key->ps_prolog.states.force_linear_sample_interp) {
		unsigned i, base = key->ps_prolog.num_input_sgprs;
		LLVMValueRef linear_sample[2];

		/* Read LINEAR_SAMPLE. */
		for (i = 0; i < 2; i++)
			linear_sample[i] = LLVMGetParam(func, base + 6 + i);
		/* Overwrite LINEAR_CENTER. */
		for (i = 0; i < 2; i++)
			ret = LLVMBuildInsertValue(gallivm->builder, ret,
						   linear_sample[i], base + 8 + i, "");
		/* Overwrite LINEAR_CENTROID. */
		for (i = 0; i < 2; i++)
			ret = LLVMBuildInsertValue(gallivm->builder, ret,
						   linear_sample[i], base + 10 + i, "");
	}

	/* Force center interpolation. */
	if (key->ps_prolog.states.force_persp_center_interp) {
		unsigned i, base = key->ps_prolog.num_input_sgprs;
		LLVMValueRef persp_center[2];

		/* Read PERSP_CENTER. */
		for (i = 0; i < 2; i++)
			persp_center[i] = LLVMGetParam(func, base + 2 + i);
		/* Overwrite PERSP_SAMPLE. */
		for (i = 0; i < 2; i++)
			ret = LLVMBuildInsertValue(gallivm->builder, ret,
						   persp_center[i], base + i, "");
		/* Overwrite PERSP_CENTROID. */
		for (i = 0; i < 2; i++)
			ret = LLVMBuildInsertValue(gallivm->builder, ret,
						   persp_center[i], base + 4 + i, "");
	}
	if (key->ps_prolog.states.force_linear_center_interp) {
		unsigned i, base = key->ps_prolog.num_input_sgprs;
		LLVMValueRef linear_center[2];

		/* Read LINEAR_CENTER. */
		for (i = 0; i < 2; i++)
			linear_center[i] = LLVMGetParam(func, base + 8 + i);
		/* Overwrite LINEAR_SAMPLE. */
		for (i = 0; i < 2; i++)
			ret = LLVMBuildInsertValue(gallivm->builder, ret,
						   linear_center[i], base + 6 + i, "");
		/* Overwrite LINEAR_CENTROID. */
		for (i = 0; i < 2; i++)
			ret = LLVMBuildInsertValue(gallivm->builder, ret,
						   linear_center[i], base + 10 + i, "");
	}

	/* Tell LLVM to insert WQM instruction sequence when needed. */
	if (key->ps_prolog.wqm) {
		LLVMAddTargetDependentFunctionAttr(func,
						   "amdgpu-ps-wqm-outputs", "");
	}

	/* Compile. */
	si_llvm_build_ret(&ctx, ret);
	radeon_llvm_finalize_module(&ctx.radeon_bld);

	if (si_compile_llvm(sscreen, &out->binary, &out->config, tm,
			    gallivm->module, debug, ctx.type,
			    "Fragment Shader Prolog"))
		status = false;

	radeon_llvm_dispose(&ctx.radeon_bld);
	return status;
}

/**
 * Compile the pixel shader epilog. This handles everything that must be
 * emulated for pixel shader exports. (alpha-test, format conversions, etc)
 */
static bool si_compile_ps_epilog(struct si_screen *sscreen,
				 LLVMTargetMachineRef tm,
				 struct pipe_debug_callback *debug,
				 struct si_shader_part *out)
{
	union si_shader_part_key *key = &out->key;
	struct si_shader shader = {};
	struct si_shader_context ctx;
	struct gallivm_state *gallivm = &ctx.radeon_bld.gallivm;
	struct lp_build_tgsi_context *bld_base = &ctx.radeon_bld.soa.bld_base;
	LLVMTypeRef params[16+8*4+3];
	LLVMValueRef depth = NULL, stencil = NULL, samplemask = NULL;
	int last_sgpr, num_params, i;
	bool status = true;
	struct si_ps_exports exp = {};

	si_init_shader_ctx(&ctx, sscreen, &shader, tm);
	ctx.type = PIPE_SHADER_FRAGMENT;
	shader.key.ps.epilog = key->ps_epilog.states;

	/* Declare input SGPRs. */
	params[SI_PARAM_RW_BUFFERS] = ctx.i64;
	params[SI_PARAM_CONST_BUFFERS] = ctx.i64;
	params[SI_PARAM_SAMPLERS] = ctx.i64;
	params[SI_PARAM_IMAGES] = ctx.i64;
	params[SI_PARAM_SHADER_BUFFERS] = ctx.i64;
	params[SI_PARAM_ALPHA_REF] = ctx.f32;
	last_sgpr = SI_PARAM_ALPHA_REF;

	/* Declare input VGPRs. */
	num_params = (last_sgpr + 1) +
		     util_bitcount(key->ps_epilog.colors_written) * 4 +
		     key->ps_epilog.writes_z +
		     key->ps_epilog.writes_stencil +
		     key->ps_epilog.writes_samplemask;

	num_params = MAX2(num_params,
			  last_sgpr + 1 + PS_EPILOG_SAMPLEMASK_MIN_LOC + 1);

	assert(num_params <= ARRAY_SIZE(params));

	for (i = last_sgpr + 1; i < num_params; i++)
		params[i] = ctx.f32;

	/* Create the function. */
	si_create_function(&ctx, NULL, 0, params, num_params, last_sgpr);
	/* Disable elimination of unused inputs. */
	radeon_llvm_add_attribute(ctx.radeon_bld.main_fn,
				  "InitialPSInputAddr", 0xffffff);

	/* Process colors. */
	unsigned vgpr = last_sgpr + 1;
	unsigned colors_written = key->ps_epilog.colors_written;
	int last_color_export = -1;

	/* Find the last color export. */
	if (!key->ps_epilog.writes_z &&
	    !key->ps_epilog.writes_stencil &&
	    !key->ps_epilog.writes_samplemask) {
		unsigned spi_format = key->ps_epilog.states.spi_shader_col_format;

		/* If last_cbuf > 0, FS_COLOR0_WRITES_ALL_CBUFS is true. */
		if (colors_written == 0x1 && key->ps_epilog.states.last_cbuf > 0) {
			/* Just set this if any of the colorbuffers are enabled. */
			if (spi_format &
			    ((1llu << (4 * (key->ps_epilog.states.last_cbuf + 1))) - 1))
				last_color_export = 0;
		} else {
			for (i = 0; i < 8; i++)
				if (colors_written & (1 << i) &&
				    (spi_format >> (i * 4)) & 0xf)
					last_color_export = i;
		}
	}

	while (colors_written) {
		LLVMValueRef color[4];
		int mrt = u_bit_scan(&colors_written);

		for (i = 0; i < 4; i++)
			color[i] = LLVMGetParam(ctx.radeon_bld.main_fn, vgpr++);

		si_export_mrt_color(bld_base, color, mrt,
				    num_params - 1,
				    mrt == last_color_export, &exp);
	}

	/* Process depth, stencil, samplemask. */
	if (key->ps_epilog.writes_z)
		depth = LLVMGetParam(ctx.radeon_bld.main_fn, vgpr++);
	if (key->ps_epilog.writes_stencil)
		stencil = LLVMGetParam(ctx.radeon_bld.main_fn, vgpr++);
	if (key->ps_epilog.writes_samplemask)
		samplemask = LLVMGetParam(ctx.radeon_bld.main_fn, vgpr++);

	if (depth || stencil || samplemask)
		si_export_mrt_z(bld_base, depth, stencil, samplemask, &exp);
	else if (last_color_export == -1)
		si_export_null(bld_base);

	if (exp.num)
		si_emit_ps_exports(&ctx, &exp);

	/* Compile. */
	LLVMBuildRetVoid(gallivm->builder);
	radeon_llvm_finalize_module(&ctx.radeon_bld);

	if (si_compile_llvm(sscreen, &out->binary, &out->config, tm,
			    gallivm->module, debug, ctx.type,
			    "Fragment Shader Epilog"))
		status = false;

	radeon_llvm_dispose(&ctx.radeon_bld);
	return status;
}

/**
 * Select and compile (or reuse) pixel shader parts (prolog & epilog).
 */
static bool si_shader_select_ps_parts(struct si_screen *sscreen,
				      LLVMTargetMachineRef tm,
				      struct si_shader *shader,
				      struct pipe_debug_callback *debug)
{
	struct tgsi_shader_info *info = &shader->selector->info;
	union si_shader_part_key prolog_key;
	union si_shader_part_key epilog_key;
	unsigned i;

	/* Get the prolog. */
	memset(&prolog_key, 0, sizeof(prolog_key));
	prolog_key.ps_prolog.states = shader->key.ps.prolog;
	prolog_key.ps_prolog.colors_read = info->colors_read;
	prolog_key.ps_prolog.num_input_sgprs = shader->info.num_input_sgprs;
	prolog_key.ps_prolog.num_input_vgprs = shader->info.num_input_vgprs;
	prolog_key.ps_prolog.wqm = info->uses_derivatives &&
		(prolog_key.ps_prolog.colors_read ||
		 prolog_key.ps_prolog.states.force_persp_sample_interp ||
		 prolog_key.ps_prolog.states.force_linear_sample_interp ||
		 prolog_key.ps_prolog.states.force_persp_center_interp ||
		 prolog_key.ps_prolog.states.force_linear_center_interp ||
		 prolog_key.ps_prolog.states.bc_optimize_for_persp ||
		 prolog_key.ps_prolog.states.bc_optimize_for_linear);

	if (info->colors_read) {
		unsigned *color = shader->selector->color_attr_index;

		if (shader->key.ps.prolog.color_two_side) {
			/* BCOLORs are stored after the last input. */
			prolog_key.ps_prolog.num_interp_inputs = info->num_inputs;
			prolog_key.ps_prolog.face_vgpr_index = shader->info.face_vgpr_index;
			shader->config.spi_ps_input_ena |= S_0286CC_FRONT_FACE_ENA(1);
		}

		for (i = 0; i < 2; i++) {
			unsigned interp = info->input_interpolate[color[i]];
			unsigned location = info->input_interpolate_loc[color[i]];

			if (!(info->colors_read & (0xf << i*4)))
				continue;

			prolog_key.ps_prolog.color_attr_index[i] = color[i];

			if (shader->key.ps.prolog.flatshade_colors &&
			    interp == TGSI_INTERPOLATE_COLOR)
				interp = TGSI_INTERPOLATE_CONSTANT;

			switch (interp) {
			case TGSI_INTERPOLATE_CONSTANT:
				prolog_key.ps_prolog.color_interp_vgpr_index[i] = -1;
				break;
			case TGSI_INTERPOLATE_PERSPECTIVE:
			case TGSI_INTERPOLATE_COLOR:
				/* Force the interpolation location for colors here. */
				if (shader->key.ps.prolog.force_persp_sample_interp)
					location = TGSI_INTERPOLATE_LOC_SAMPLE;
				if (shader->key.ps.prolog.force_persp_center_interp)
					location = TGSI_INTERPOLATE_LOC_CENTER;

				switch (location) {
				case TGSI_INTERPOLATE_LOC_SAMPLE:
					prolog_key.ps_prolog.color_interp_vgpr_index[i] = 0;
					shader->config.spi_ps_input_ena |=
						S_0286CC_PERSP_SAMPLE_ENA(1);
					break;
				case TGSI_INTERPOLATE_LOC_CENTER:
					prolog_key.ps_prolog.color_interp_vgpr_index[i] = 2;
					shader->config.spi_ps_input_ena |=
						S_0286CC_PERSP_CENTER_ENA(1);
					break;
				case TGSI_INTERPOLATE_LOC_CENTROID:
					prolog_key.ps_prolog.color_interp_vgpr_index[i] = 4;
					shader->config.spi_ps_input_ena |=
						S_0286CC_PERSP_CENTROID_ENA(1);
					break;
				default:
					assert(0);
				}
				break;
			case TGSI_INTERPOLATE_LINEAR:
				/* Force the interpolation location for colors here. */
				if (shader->key.ps.prolog.force_linear_sample_interp)
					location = TGSI_INTERPOLATE_LOC_SAMPLE;
				if (shader->key.ps.prolog.force_linear_center_interp)
					location = TGSI_INTERPOLATE_LOC_CENTER;

				switch (location) {
				case TGSI_INTERPOLATE_LOC_SAMPLE:
					prolog_key.ps_prolog.color_interp_vgpr_index[i] = 6;
					shader->config.spi_ps_input_ena |=
						S_0286CC_LINEAR_SAMPLE_ENA(1);
					break;
				case TGSI_INTERPOLATE_LOC_CENTER:
					prolog_key.ps_prolog.color_interp_vgpr_index[i] = 8;
					shader->config.spi_ps_input_ena |=
						S_0286CC_LINEAR_CENTER_ENA(1);
					break;
				case TGSI_INTERPOLATE_LOC_CENTROID:
					prolog_key.ps_prolog.color_interp_vgpr_index[i] = 10;
					shader->config.spi_ps_input_ena |=
						S_0286CC_LINEAR_CENTROID_ENA(1);
					break;
				default:
					assert(0);
				}
				break;
			default:
				assert(0);
			}
		}
	}

	/* The prolog is a no-op if these aren't set. */
	if (prolog_key.ps_prolog.colors_read ||
	    prolog_key.ps_prolog.states.force_persp_sample_interp ||
	    prolog_key.ps_prolog.states.force_linear_sample_interp ||
	    prolog_key.ps_prolog.states.force_persp_center_interp ||
	    prolog_key.ps_prolog.states.force_linear_center_interp ||
	    prolog_key.ps_prolog.states.bc_optimize_for_persp ||
	    prolog_key.ps_prolog.states.bc_optimize_for_linear ||
	    prolog_key.ps_prolog.states.poly_stipple) {
		shader->prolog =
			si_get_shader_part(sscreen, &sscreen->ps_prologs,
					   &prolog_key, tm, debug,
					   si_compile_ps_prolog);
		if (!shader->prolog)
			return false;
	}

	/* Get the epilog. */
	memset(&epilog_key, 0, sizeof(epilog_key));
	epilog_key.ps_epilog.colors_written = info->colors_written;
	epilog_key.ps_epilog.writes_z = info->writes_z;
	epilog_key.ps_epilog.writes_stencil = info->writes_stencil;
	epilog_key.ps_epilog.writes_samplemask = info->writes_samplemask;
	epilog_key.ps_epilog.states = shader->key.ps.epilog;

	shader->epilog =
		si_get_shader_part(sscreen, &sscreen->ps_epilogs,
				   &epilog_key, tm, debug,
				   si_compile_ps_epilog);
	if (!shader->epilog)
		return false;

	/* Enable POS_FIXED_PT if polygon stippling is enabled. */
	if (shader->key.ps.prolog.poly_stipple) {
		shader->config.spi_ps_input_ena |= S_0286CC_POS_FIXED_PT_ENA(1);
		assert(G_0286CC_POS_FIXED_PT_ENA(shader->config.spi_ps_input_addr));
	}

	/* Set up the enable bits for per-sample shading if needed. */
	if (shader->key.ps.prolog.force_persp_sample_interp &&
	    (G_0286CC_PERSP_CENTER_ENA(shader->config.spi_ps_input_ena) ||
	     G_0286CC_PERSP_CENTROID_ENA(shader->config.spi_ps_input_ena))) {
		shader->config.spi_ps_input_ena &= C_0286CC_PERSP_CENTER_ENA;
		shader->config.spi_ps_input_ena &= C_0286CC_PERSP_CENTROID_ENA;
		shader->config.spi_ps_input_ena |= S_0286CC_PERSP_SAMPLE_ENA(1);
	}
	if (shader->key.ps.prolog.force_linear_sample_interp &&
	    (G_0286CC_LINEAR_CENTER_ENA(shader->config.spi_ps_input_ena) ||
	     G_0286CC_LINEAR_CENTROID_ENA(shader->config.spi_ps_input_ena))) {
		shader->config.spi_ps_input_ena &= C_0286CC_LINEAR_CENTER_ENA;
		shader->config.spi_ps_input_ena &= C_0286CC_LINEAR_CENTROID_ENA;
		shader->config.spi_ps_input_ena |= S_0286CC_LINEAR_SAMPLE_ENA(1);
	}
	if (shader->key.ps.prolog.force_persp_center_interp &&
	    (G_0286CC_PERSP_SAMPLE_ENA(shader->config.spi_ps_input_ena) ||
	     G_0286CC_PERSP_CENTROID_ENA(shader->config.spi_ps_input_ena))) {
		shader->config.spi_ps_input_ena &= C_0286CC_PERSP_SAMPLE_ENA;
		shader->config.spi_ps_input_ena &= C_0286CC_PERSP_CENTROID_ENA;
		shader->config.spi_ps_input_ena |= S_0286CC_PERSP_CENTER_ENA(1);
	}
	if (shader->key.ps.prolog.force_linear_center_interp &&
	    (G_0286CC_LINEAR_SAMPLE_ENA(shader->config.spi_ps_input_ena) ||
	     G_0286CC_LINEAR_CENTROID_ENA(shader->config.spi_ps_input_ena))) {
		shader->config.spi_ps_input_ena &= C_0286CC_LINEAR_SAMPLE_ENA;
		shader->config.spi_ps_input_ena &= C_0286CC_LINEAR_CENTROID_ENA;
		shader->config.spi_ps_input_ena |= S_0286CC_LINEAR_CENTER_ENA(1);
	}

	/* POW_W_FLOAT requires that one of the perspective weights is enabled. */
	if (G_0286CC_POS_W_FLOAT_ENA(shader->config.spi_ps_input_ena) &&
	    !(shader->config.spi_ps_input_ena & 0xf)) {
		shader->config.spi_ps_input_ena |= S_0286CC_PERSP_CENTER_ENA(1);
		assert(G_0286CC_PERSP_CENTER_ENA(shader->config.spi_ps_input_addr));
	}

	/* At least one pair of interpolation weights must be enabled. */
	if (!(shader->config.spi_ps_input_ena & 0x7f)) {
		shader->config.spi_ps_input_ena |= S_0286CC_LINEAR_CENTER_ENA(1);
		assert(G_0286CC_LINEAR_CENTER_ENA(shader->config.spi_ps_input_addr));
	}

	/* The sample mask input is always enabled, because the API shader always
	 * passes it through to the epilog. Disable it here if it's unused.
	 */
	if (!shader->key.ps.epilog.poly_line_smoothing &&
	    !shader->selector->info.reads_samplemask)
		shader->config.spi_ps_input_ena &= C_0286CC_SAMPLE_COVERAGE_ENA;

	return true;
}

static void si_fix_num_sgprs(struct si_shader *shader)
{
	unsigned min_sgprs = shader->info.num_input_sgprs + 2; /* VCC */

	shader->config.num_sgprs = MAX2(shader->config.num_sgprs, min_sgprs);
}

int si_shader_create(struct si_screen *sscreen, LLVMTargetMachineRef tm,
		     struct si_shader *shader,
		     struct pipe_debug_callback *debug)
{
	struct si_shader *mainp = shader->selector->main_shader_part;
	int r;

	/* LS, ES, VS are compiled on demand if the main part hasn't been
	 * compiled for that stage.
	 */
	if (!mainp ||
	    (shader->selector->type == PIPE_SHADER_VERTEX &&
	     (shader->key.vs.as_es != mainp->key.vs.as_es ||
	      shader->key.vs.as_ls != mainp->key.vs.as_ls)) ||
	    (shader->selector->type == PIPE_SHADER_TESS_EVAL &&
	     shader->key.tes.as_es != mainp->key.tes.as_es) ||
	    (shader->selector->type == PIPE_SHADER_TESS_CTRL &&
	     shader->key.tcs.epilog.inputs_to_copy) ||
	    shader->selector->type == PIPE_SHADER_COMPUTE) {
		/* Monolithic shader (compiled as a whole, has many variants,
		 * may take a long time to compile).
		 */
		r = si_compile_tgsi_shader(sscreen, tm, shader, true, debug);
		if (r)
			return r;
	} else {
		/* The shader consists of 2-3 parts:
		 *
		 * - the middle part is the user shader, it has 1 variant only
		 *   and it was compiled during the creation of the shader
		 *   selector
		 * - the prolog part is inserted at the beginning
		 * - the epilog part is inserted at the end
		 *
		 * The prolog and epilog have many (but simple) variants.
		 */

		/* Copy the compiled TGSI shader data over. */
		shader->is_binary_shared = true;
		shader->binary = mainp->binary;
		shader->config = mainp->config;
		shader->info.num_input_sgprs = mainp->info.num_input_sgprs;
		shader->info.num_input_vgprs = mainp->info.num_input_vgprs;
		shader->info.face_vgpr_index = mainp->info.face_vgpr_index;
		memcpy(shader->info.vs_output_param_offset,
		       mainp->info.vs_output_param_offset,
		       sizeof(mainp->info.vs_output_param_offset));
		shader->info.uses_instanceid = mainp->info.uses_instanceid;
		shader->info.nr_pos_exports = mainp->info.nr_pos_exports;
		shader->info.nr_param_exports = mainp->info.nr_param_exports;

		/* Select prologs and/or epilogs. */
		switch (shader->selector->type) {
		case PIPE_SHADER_VERTEX:
			if (!si_shader_select_vs_parts(sscreen, tm, shader, debug))
				return -1;
			break;
		case PIPE_SHADER_TESS_CTRL:
			if (!si_shader_select_tcs_parts(sscreen, tm, shader, debug))
				return -1;
			break;
		case PIPE_SHADER_TESS_EVAL:
			if (!si_shader_select_tes_parts(sscreen, tm, shader, debug))
				return -1;
			break;
		case PIPE_SHADER_FRAGMENT:
			if (!si_shader_select_ps_parts(sscreen, tm, shader, debug))
				return -1;

			/* Make sure we have at least as many VGPRs as there
			 * are allocated inputs.
			 */
			shader->config.num_vgprs = MAX2(shader->config.num_vgprs,
							shader->info.num_input_vgprs);
			break;
		}

		/* Update SGPR and VGPR counts. */
		if (shader->prolog) {
			shader->config.num_sgprs = MAX2(shader->config.num_sgprs,
							shader->prolog->config.num_sgprs);
			shader->config.num_vgprs = MAX2(shader->config.num_vgprs,
							shader->prolog->config.num_vgprs);
		}
		if (shader->epilog) {
			shader->config.num_sgprs = MAX2(shader->config.num_sgprs,
							shader->epilog->config.num_sgprs);
			shader->config.num_vgprs = MAX2(shader->config.num_vgprs,
							shader->epilog->config.num_vgprs);
		}
	}

	si_fix_num_sgprs(shader);
	si_shader_dump(sscreen, shader, debug, shader->selector->info.processor,
		       stderr);

	/* Upload. */
	r = si_shader_binary_upload(sscreen, shader);
	if (r) {
		fprintf(stderr, "LLVM failed to upload shader\n");
		return r;
	}

	return 0;
}

void si_shader_destroy(struct si_shader *shader)
{
	if (shader->gs_copy_shader) {
		si_shader_destroy(shader->gs_copy_shader);
		FREE(shader->gs_copy_shader);
	}

	if (shader->scratch_bo)
		r600_resource_reference(&shader->scratch_bo, NULL);

	r600_resource_reference(&shader->bo, NULL);

	if (!shader->is_binary_shared)
		radeon_shader_binary_clean(&shader->binary);

	free(shader->shader_log);
}
