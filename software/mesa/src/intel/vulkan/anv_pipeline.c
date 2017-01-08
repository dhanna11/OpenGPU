/*
 * Copyright © 2015 Intel Corporation
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

#include <assert.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#include "util/mesa-sha1.h"
#include "anv_private.h"
#include "brw_nir.h"
#include "anv_nir.h"
#include "spirv/nir_spirv.h"

/* Needed for SWIZZLE macros */
#include "program/prog_instruction.h"

// Shader functions

VkResult anv_CreateShaderModule(
    VkDevice                                    _device,
    const VkShaderModuleCreateInfo*             pCreateInfo,
    const VkAllocationCallbacks*                pAllocator,
    VkShaderModule*                             pShaderModule)
{
   ANV_FROM_HANDLE(anv_device, device, _device);
   struct anv_shader_module *module;

   assert(pCreateInfo->sType == VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO);
   assert(pCreateInfo->flags == 0);

   module = anv_alloc2(&device->alloc, pAllocator,
                       sizeof(*module) + pCreateInfo->codeSize, 8,
                       VK_SYSTEM_ALLOCATION_SCOPE_OBJECT);
   if (module == NULL)
      return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);

   module->nir = NULL;
   module->size = pCreateInfo->codeSize;
   memcpy(module->data, pCreateInfo->pCode, module->size);

   _mesa_sha1_compute(module->data, module->size, module->sha1);

   *pShaderModule = anv_shader_module_to_handle(module);

   return VK_SUCCESS;
}

void anv_DestroyShaderModule(
    VkDevice                                    _device,
    VkShaderModule                              _module,
    const VkAllocationCallbacks*                pAllocator)
{
   ANV_FROM_HANDLE(anv_device, device, _device);
   ANV_FROM_HANDLE(anv_shader_module, module, _module);

   anv_free2(&device->alloc, pAllocator, module);
}

#define SPIR_V_MAGIC_NUMBER 0x07230203

/* Eventually, this will become part of anv_CreateShader.  Unfortunately,
 * we can't do that yet because we don't have the ability to copy nir.
 */
static nir_shader *
anv_shader_compile_to_nir(struct anv_device *device,
                          struct anv_shader_module *module,
                          const char *entrypoint_name,
                          gl_shader_stage stage,
                          const VkSpecializationInfo *spec_info)
{
   if (strcmp(entrypoint_name, "main") != 0) {
      anv_finishme("Multiple shaders per module not really supported");
   }

   const struct brw_compiler *compiler =
      device->instance->physicalDevice.compiler;
   const nir_shader_compiler_options *nir_options =
      compiler->glsl_compiler_options[stage].NirOptions;

   nir_shader *nir;
   nir_function *entry_point;
   if (module->nir) {
      /* Some things such as our meta clear/blit code will give us a NIR
       * shader directly.  In that case, we just ignore the SPIR-V entirely
       * and just use the NIR shader */
      nir = module->nir;
      nir->options = nir_options;
      nir_validate_shader(nir);

      assert(exec_list_length(&nir->functions) == 1);
      struct exec_node *node = exec_list_get_head(&nir->functions);
      entry_point = exec_node_data(nir_function, node, node);
   } else {
      uint32_t *spirv = (uint32_t *) module->data;
      assert(spirv[0] == SPIR_V_MAGIC_NUMBER);
      assert(module->size % 4 == 0);

      uint32_t num_spec_entries = 0;
      struct nir_spirv_specialization *spec_entries = NULL;
      if (spec_info && spec_info->mapEntryCount > 0) {
         num_spec_entries = spec_info->mapEntryCount;
         spec_entries = malloc(num_spec_entries * sizeof(*spec_entries));
         for (uint32_t i = 0; i < num_spec_entries; i++) {
            VkSpecializationMapEntry entry = spec_info->pMapEntries[i];
            const void *data = spec_info->pData + entry.offset;
            assert(data + entry.size <= spec_info->pData + spec_info->dataSize);

            spec_entries[i].id = spec_info->pMapEntries[i].constantID;
            spec_entries[i].data = *(const uint32_t *)data;
         }
      }

      entry_point = spirv_to_nir(spirv, module->size / 4,
                                 spec_entries, num_spec_entries,
                                 stage, entrypoint_name, nir_options);
      nir = entry_point->shader;
      assert(nir->stage == stage);
      nir_validate_shader(nir);

      free(spec_entries);

      if (stage == MESA_SHADER_FRAGMENT) {
         nir_lower_wpos_center(nir);
         nir_validate_shader(nir);
      }

      nir_lower_returns(nir);
      nir_validate_shader(nir);

      nir_inline_functions(nir);
      nir_validate_shader(nir);

      /* Pick off the single entrypoint that we want */
      foreach_list_typed_safe(nir_function, func, node, &nir->functions) {
         if (func != entry_point)
            exec_node_remove(&func->node);
      }
      assert(exec_list_length(&nir->functions) == 1);
      entry_point->name = ralloc_strdup(entry_point, "main");

      nir_remove_dead_variables(nir, nir_var_shader_in);
      nir_remove_dead_variables(nir, nir_var_shader_out);
      nir_remove_dead_variables(nir, nir_var_system_value);
      nir_validate_shader(nir);

      nir_propagate_invariant(nir);
      nir_validate_shader(nir);

      nir_lower_io_to_temporaries(entry_point->shader, entry_point->impl,
                                  true, false);

      nir_lower_system_values(nir);
      nir_validate_shader(nir);
   }

   /* Vulkan uses the separate-shader linking model */
   nir->info.separate_shader = true;

   nir = brw_preprocess_nir(compiler, nir);

   nir_shader_gather_info(nir, entry_point->impl);

   nir_variable_mode indirect_mask = 0;
   if (compiler->glsl_compiler_options[stage].EmitNoIndirectInput)
      indirect_mask |= nir_var_shader_in;
   if (compiler->glsl_compiler_options[stage].EmitNoIndirectTemp)
      indirect_mask |= nir_var_local;

   nir_lower_indirect_derefs(nir, indirect_mask);

   return nir;
}

void anv_DestroyPipeline(
    VkDevice                                    _device,
    VkPipeline                                  _pipeline,
    const VkAllocationCallbacks*                pAllocator)
{
   ANV_FROM_HANDLE(anv_device, device, _device);
   ANV_FROM_HANDLE(anv_pipeline, pipeline, _pipeline);

   anv_reloc_list_finish(&pipeline->batch_relocs,
                         pAllocator ? pAllocator : &device->alloc);
   if (pipeline->blend_state.map)
      anv_state_pool_free(&device->dynamic_state_pool, pipeline->blend_state);

   for (unsigned s = 0; s < MESA_SHADER_STAGES; s++) {
      if (pipeline->shaders[s])
         anv_shader_bin_unref(device, pipeline->shaders[s]);
   }

   anv_free2(&device->alloc, pAllocator, pipeline);
}

static const uint32_t vk_to_gen_primitive_type[] = {
   [VK_PRIMITIVE_TOPOLOGY_POINT_LIST]                    = _3DPRIM_POINTLIST,
   [VK_PRIMITIVE_TOPOLOGY_LINE_LIST]                     = _3DPRIM_LINELIST,
   [VK_PRIMITIVE_TOPOLOGY_LINE_STRIP]                    = _3DPRIM_LINESTRIP,
   [VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST]                 = _3DPRIM_TRILIST,
   [VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP]                = _3DPRIM_TRISTRIP,
   [VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN]                  = _3DPRIM_TRIFAN,
   [VK_PRIMITIVE_TOPOLOGY_LINE_LIST_WITH_ADJACENCY]      = _3DPRIM_LINELIST_ADJ,
   [VK_PRIMITIVE_TOPOLOGY_LINE_STRIP_WITH_ADJACENCY]     = _3DPRIM_LINESTRIP_ADJ,
   [VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST_WITH_ADJACENCY]  = _3DPRIM_TRILIST_ADJ,
   [VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP_WITH_ADJACENCY] = _3DPRIM_TRISTRIP_ADJ,
/*   [VK_PRIMITIVE_TOPOLOGY_PATCH_LIST]                = _3DPRIM_PATCHLIST_1 */
};

static void
populate_sampler_prog_key(const struct brw_device_info *devinfo,
                          struct brw_sampler_prog_key_data *key)
{
   /* XXX: Handle texture swizzle on HSW- */
   for (int i = 0; i < MAX_SAMPLERS; i++) {
      /* Assume color sampler, no swizzling. (Works for BDW+) */
      key->swizzles[i] = SWIZZLE_XYZW;
   }
}

static void
populate_vs_prog_key(const struct brw_device_info *devinfo,
                     struct brw_vs_prog_key *key)
{
   memset(key, 0, sizeof(*key));

   populate_sampler_prog_key(devinfo, &key->tex);

   /* XXX: Handle vertex input work-arounds */

   /* XXX: Handle sampler_prog_key */
}

static void
populate_gs_prog_key(const struct brw_device_info *devinfo,
                     struct brw_gs_prog_key *key)
{
   memset(key, 0, sizeof(*key));

   populate_sampler_prog_key(devinfo, &key->tex);
}

static void
populate_wm_prog_key(const struct brw_device_info *devinfo,
                     const VkGraphicsPipelineCreateInfo *info,
                     const struct anv_graphics_pipeline_create_info *extra,
                     struct brw_wm_prog_key *key)
{
   ANV_FROM_HANDLE(anv_render_pass, render_pass, info->renderPass);

   memset(key, 0, sizeof(*key));

   populate_sampler_prog_key(devinfo, &key->tex);

   /* TODO: Fill out key->input_slots_valid */

   /* Vulkan doesn't specify a default */
   key->high_quality_derivatives = false;

   /* XXX Vulkan doesn't appear to specify */
   key->clamp_fragment_color = false;

   if (extra && extra->color_attachment_count >= 0) {
      key->nr_color_regions = extra->color_attachment_count;
   } else {
      key->nr_color_regions =
         render_pass->subpasses[info->subpass].color_count;
   }

   key->replicate_alpha = key->nr_color_regions > 1 &&
                          info->pMultisampleState &&
                          info->pMultisampleState->alphaToCoverageEnable;

   if (info->pMultisampleState && info->pMultisampleState->rasterizationSamples > 1) {
      /* We should probably pull this out of the shader, but it's fairly
       * harmless to compute it and then let dead-code take care of it.
       */
      key->persample_interp =
         (info->pMultisampleState->minSampleShading *
          info->pMultisampleState->rasterizationSamples) > 1;
      key->multisample_fbo = true;
   }
}

static void
populate_cs_prog_key(const struct brw_device_info *devinfo,
                     struct brw_cs_prog_key *key)
{
   memset(key, 0, sizeof(*key));

   populate_sampler_prog_key(devinfo, &key->tex);
}

static nir_shader *
anv_pipeline_compile(struct anv_pipeline *pipeline,
                     struct anv_shader_module *module,
                     const char *entrypoint,
                     gl_shader_stage stage,
                     const VkSpecializationInfo *spec_info,
                     struct brw_stage_prog_data *prog_data,
                     struct anv_pipeline_bind_map *map)
{
   nir_shader *nir = anv_shader_compile_to_nir(pipeline->device,
                                               module, entrypoint, stage,
                                               spec_info);
   if (nir == NULL)
      return NULL;

   anv_nir_lower_push_constants(nir);

   /* Figure out the number of parameters */
   prog_data->nr_params = 0;

   if (nir->num_uniforms > 0) {
      /* If the shader uses any push constants at all, we'll just give
       * them the maximum possible number
       */
      assert(nir->num_uniforms <= MAX_PUSH_CONSTANTS_SIZE);
      prog_data->nr_params += MAX_PUSH_CONSTANTS_SIZE / sizeof(float);
   }

   if (pipeline->layout && pipeline->layout->stage[stage].has_dynamic_offsets)
      prog_data->nr_params += MAX_DYNAMIC_BUFFERS * 2;

   if (nir->info.num_images > 0) {
      prog_data->nr_params += nir->info.num_images * BRW_IMAGE_PARAM_SIZE;
      pipeline->needs_data_cache = true;
   }

   if (stage == MESA_SHADER_COMPUTE)
      ((struct brw_cs_prog_data *)prog_data)->thread_local_id_index =
         prog_data->nr_params++; /* The CS Thread ID uniform */

   if (nir->info.num_ssbos > 0)
      pipeline->needs_data_cache = true;

   if (prog_data->nr_params > 0) {
      /* XXX: I think we're leaking this */
      prog_data->param = (const union gl_constant_value **)
         malloc(prog_data->nr_params * sizeof(union gl_constant_value *));

      /* We now set the param values to be offsets into a
       * anv_push_constant_data structure.  Since the compiler doesn't
       * actually dereference any of the gl_constant_value pointers in the
       * params array, it doesn't really matter what we put here.
       */
      struct anv_push_constants *null_data = NULL;
      if (nir->num_uniforms > 0) {
         /* Fill out the push constants section of the param array */
         for (unsigned i = 0; i < MAX_PUSH_CONSTANTS_SIZE / sizeof(float); i++)
            prog_data->param[i] = (const union gl_constant_value *)
               &null_data->client_data[i * sizeof(float)];
      }
   }

   /* Set up dynamic offsets */
   anv_nir_apply_dynamic_offsets(pipeline, nir, prog_data);

   /* Apply the actual pipeline layout to UBOs, SSBOs, and textures */
   if (pipeline->layout)
      anv_nir_apply_pipeline_layout(pipeline, nir, prog_data, map);

   /* nir_lower_io will only handle the push constants; we need to set this
    * to the full number of possible uniforms.
    */
   nir->num_uniforms = prog_data->nr_params * 4;

   return nir;
}

static void
anv_fill_binding_table(struct brw_stage_prog_data *prog_data, unsigned bias)
{
   prog_data->binding_table.size_bytes = 0;
   prog_data->binding_table.texture_start = bias;
   prog_data->binding_table.gather_texture_start = bias;
   prog_data->binding_table.ubo_start = bias;
   prog_data->binding_table.ssbo_start = bias;
   prog_data->binding_table.image_start = bias;
}

static struct anv_shader_bin *
anv_pipeline_upload_kernel(struct anv_pipeline *pipeline,
                           struct anv_pipeline_cache *cache,
                           const void *key_data, uint32_t key_size,
                           const void *kernel_data, uint32_t kernel_size,
                           const void *prog_data, uint32_t prog_data_size,
                           const struct anv_pipeline_bind_map *bind_map)
{
   if (cache) {
      return anv_pipeline_cache_upload_kernel(cache, key_data, key_size,
                                              kernel_data, kernel_size,
                                              prog_data, prog_data_size,
                                              bind_map);
   } else {
      return anv_shader_bin_create(pipeline->device, key_data, key_size,
                                   kernel_data, kernel_size,
                                   prog_data, prog_data_size, bind_map);
   }
}


static void
anv_pipeline_add_compiled_stage(struct anv_pipeline *pipeline,
                                gl_shader_stage stage,
                                struct anv_shader_bin *shader)
{
   pipeline->shaders[stage] = shader;
   pipeline->active_stages |= mesa_to_vk_shader_stage(stage);
}

static VkResult
anv_pipeline_compile_vs(struct anv_pipeline *pipeline,
                        struct anv_pipeline_cache *cache,
                        const VkGraphicsPipelineCreateInfo *info,
                        struct anv_shader_module *module,
                        const char *entrypoint,
                        const VkSpecializationInfo *spec_info)
{
   const struct brw_compiler *compiler =
      pipeline->device->instance->physicalDevice.compiler;
   struct anv_pipeline_bind_map map;
   struct brw_vs_prog_key key;
   struct anv_shader_bin *bin = NULL;
   unsigned char sha1[20];

   populate_vs_prog_key(&pipeline->device->info, &key);

   if (cache) {
      anv_hash_shader(sha1, &key, sizeof(key), module, entrypoint,
                      pipeline->layout, spec_info);
      bin = anv_pipeline_cache_search(cache, sha1, 20);
   }

   if (bin == NULL) {
      struct brw_vs_prog_data prog_data = { 0, };
      struct anv_pipeline_binding surface_to_descriptor[256];
      struct anv_pipeline_binding sampler_to_descriptor[256];

      map = (struct anv_pipeline_bind_map) {
         .surface_to_descriptor = surface_to_descriptor,
         .sampler_to_descriptor = sampler_to_descriptor
      };

      nir_shader *nir = anv_pipeline_compile(pipeline, module, entrypoint,
                                             MESA_SHADER_VERTEX, spec_info,
                                             &prog_data.base.base, &map);
      if (nir == NULL)
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);

      anv_fill_binding_table(&prog_data.base.base, 0);

      void *mem_ctx = ralloc_context(NULL);

      if (module->nir == NULL)
         ralloc_steal(mem_ctx, nir);

      prog_data.inputs_read = nir->info.inputs_read;

      brw_compute_vue_map(&pipeline->device->info,
                          &prog_data.base.vue_map,
                          nir->info.outputs_written,
                          nir->info.separate_shader);

      unsigned code_size;
      const unsigned *shader_code =
         brw_compile_vs(compiler, NULL, mem_ctx, &key, &prog_data, nir,
                        NULL, false, -1, &code_size, NULL);
      if (shader_code == NULL) {
         ralloc_free(mem_ctx);
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);
      }

      bin = anv_pipeline_upload_kernel(pipeline, cache, sha1, 20,
                                       shader_code, code_size,
                                       &prog_data, sizeof(prog_data), &map);
      if (!bin) {
         ralloc_free(mem_ctx);
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);
      }

      ralloc_free(mem_ctx);
   }

   const struct brw_vs_prog_data *vs_prog_data =
      (const struct brw_vs_prog_data *)anv_shader_bin_get_prog_data(bin);

   if (vs_prog_data->base.dispatch_mode == DISPATCH_MODE_SIMD8) {
      pipeline->vs_simd8 = bin->kernel.offset;
      pipeline->vs_vec4 = NO_KERNEL;
   } else {
      pipeline->vs_simd8 = NO_KERNEL;
      pipeline->vs_vec4 = bin->kernel.offset;
   }

   anv_pipeline_add_compiled_stage(pipeline, MESA_SHADER_VERTEX, bin);

   return VK_SUCCESS;
}

static VkResult
anv_pipeline_compile_gs(struct anv_pipeline *pipeline,
                        struct anv_pipeline_cache *cache,
                        const VkGraphicsPipelineCreateInfo *info,
                        struct anv_shader_module *module,
                        const char *entrypoint,
                        const VkSpecializationInfo *spec_info)
{
   const struct brw_compiler *compiler =
      pipeline->device->instance->physicalDevice.compiler;
   struct anv_pipeline_bind_map map;
   struct brw_gs_prog_key key;
   struct anv_shader_bin *bin = NULL;
   unsigned char sha1[20];

   populate_gs_prog_key(&pipeline->device->info, &key);

   if (cache) {
      anv_hash_shader(sha1, &key, sizeof(key), module, entrypoint,
                      pipeline->layout, spec_info);
      bin = anv_pipeline_cache_search(cache, sha1, 20);
   }

   if (bin == NULL) {
      struct brw_gs_prog_data prog_data = { 0, };
      struct anv_pipeline_binding surface_to_descriptor[256];
      struct anv_pipeline_binding sampler_to_descriptor[256];

      map = (struct anv_pipeline_bind_map) {
         .surface_to_descriptor = surface_to_descriptor,
         .sampler_to_descriptor = sampler_to_descriptor
      };

      nir_shader *nir = anv_pipeline_compile(pipeline, module, entrypoint,
                                             MESA_SHADER_GEOMETRY, spec_info,
                                             &prog_data.base.base, &map);
      if (nir == NULL)
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);

      anv_fill_binding_table(&prog_data.base.base, 0);

      void *mem_ctx = ralloc_context(NULL);

      if (module->nir == NULL)
         ralloc_steal(mem_ctx, nir);

      brw_compute_vue_map(&pipeline->device->info,
                          &prog_data.base.vue_map,
                          nir->info.outputs_written,
                          nir->info.separate_shader);

      unsigned code_size;
      const unsigned *shader_code =
         brw_compile_gs(compiler, NULL, mem_ctx, &key, &prog_data, nir,
                        NULL, -1, &code_size, NULL);
      if (shader_code == NULL) {
         ralloc_free(mem_ctx);
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);
      }

      /* TODO: SIMD8 GS */
      bin = anv_pipeline_upload_kernel(pipeline, cache, sha1, 20,
                                       shader_code, code_size,
                                       &prog_data, sizeof(prog_data), &map);
      if (!bin) {
         ralloc_free(mem_ctx);
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);
      }

      ralloc_free(mem_ctx);
   }

   pipeline->gs_kernel = bin->kernel.offset;

   anv_pipeline_add_compiled_stage(pipeline, MESA_SHADER_GEOMETRY, bin);

   return VK_SUCCESS;
}

static VkResult
anv_pipeline_compile_fs(struct anv_pipeline *pipeline,
                        struct anv_pipeline_cache *cache,
                        const VkGraphicsPipelineCreateInfo *info,
                        const struct anv_graphics_pipeline_create_info *extra,
                        struct anv_shader_module *module,
                        const char *entrypoint,
                        const VkSpecializationInfo *spec_info)
{
   const struct brw_compiler *compiler =
      pipeline->device->instance->physicalDevice.compiler;
   struct anv_pipeline_bind_map map;
   struct brw_wm_prog_key key;
   struct anv_shader_bin *bin = NULL;
   unsigned char sha1[20];

   populate_wm_prog_key(&pipeline->device->info, info, extra, &key);

   if (cache) {
      anv_hash_shader(sha1, &key, sizeof(key), module, entrypoint,
                      pipeline->layout, spec_info);
      bin = anv_pipeline_cache_search(cache, sha1, 20);
   }

   if (bin == NULL) {
      struct brw_wm_prog_data prog_data = { 0, };
      struct anv_pipeline_binding surface_to_descriptor[256];
      struct anv_pipeline_binding sampler_to_descriptor[256];

      map = (struct anv_pipeline_bind_map) {
         .surface_to_descriptor = surface_to_descriptor + 8,
         .sampler_to_descriptor = sampler_to_descriptor
      };

      nir_shader *nir = anv_pipeline_compile(pipeline, module, entrypoint,
                                             MESA_SHADER_FRAGMENT, spec_info,
                                             &prog_data.base, &map);
      if (nir == NULL)
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);

      unsigned num_rts = 0;
      struct anv_pipeline_binding rt_bindings[8];
      nir_function_impl *impl = nir_shader_get_entrypoint(nir);
      nir_foreach_variable_safe(var, &nir->outputs) {
         if (var->data.location < FRAG_RESULT_DATA0)
            continue;

         unsigned rt = var->data.location - FRAG_RESULT_DATA0;
         if (rt >= key.nr_color_regions) {
            /* Out-of-bounds, throw it away */
            var->data.mode = nir_var_local;
            exec_node_remove(&var->node);
            exec_list_push_tail(&impl->locals, &var->node);
            continue;
         }

         /* Give it a new, compacted, location */
         var->data.location = FRAG_RESULT_DATA0 + num_rts;

         unsigned array_len =
            glsl_type_is_array(var->type) ? glsl_get_length(var->type) : 1;
         assert(num_rts + array_len <= 8);

         for (unsigned i = 0; i < array_len; i++) {
            rt_bindings[num_rts + i] = (struct anv_pipeline_binding) {
               .set = ANV_DESCRIPTOR_SET_COLOR_ATTACHMENTS,
               .binding = 0,
               .index = rt + i,
            };
         }

         num_rts += array_len;
      }

      if (pipeline->use_repclear) {
         assert(num_rts == 1);
         key.nr_color_regions = 1;
      }

      if (num_rts == 0) {
         /* If we have no render targets, we need a null render target */
         rt_bindings[0] = (struct anv_pipeline_binding) {
            .set = ANV_DESCRIPTOR_SET_COLOR_ATTACHMENTS,
            .binding = 0,
            .index = UINT8_MAX,
         };
         num_rts = 1;
      }

      assert(num_rts <= 8);
      map.surface_to_descriptor -= num_rts;
      map.surface_count += num_rts;
      assert(map.surface_count <= 256);
      memcpy(map.surface_to_descriptor, rt_bindings,
             num_rts * sizeof(*rt_bindings));

      anv_fill_binding_table(&prog_data.base, num_rts);

      void *mem_ctx = ralloc_context(NULL);

      if (module->nir == NULL)
         ralloc_steal(mem_ctx, nir);

      unsigned code_size;
      const unsigned *shader_code =
         brw_compile_fs(compiler, NULL, mem_ctx, &key, &prog_data, nir,
                        NULL, -1, -1, true, pipeline->use_repclear,
                        &code_size, NULL);
      if (shader_code == NULL) {
         ralloc_free(mem_ctx);
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);
      }

      bin = anv_pipeline_upload_kernel(pipeline, cache, sha1, 20,
                                       shader_code, code_size,
                                       &prog_data, sizeof(prog_data), &map);
      if (!bin) {
         ralloc_free(mem_ctx);
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);
      }

      ralloc_free(mem_ctx);
   }

   pipeline->ps_ksp0 = bin->kernel.offset;

   anv_pipeline_add_compiled_stage(pipeline, MESA_SHADER_FRAGMENT, bin);

   return VK_SUCCESS;
}

VkResult
anv_pipeline_compile_cs(struct anv_pipeline *pipeline,
                        struct anv_pipeline_cache *cache,
                        const VkComputePipelineCreateInfo *info,
                        struct anv_shader_module *module,
                        const char *entrypoint,
                        const VkSpecializationInfo *spec_info)
{
   const struct brw_compiler *compiler =
      pipeline->device->instance->physicalDevice.compiler;
   struct anv_pipeline_bind_map map;
   struct brw_cs_prog_key key;
   struct anv_shader_bin *bin = NULL;
   unsigned char sha1[20];

   populate_cs_prog_key(&pipeline->device->info, &key);

   if (cache) {
      anv_hash_shader(sha1, &key, sizeof(key), module, entrypoint,
                      pipeline->layout, spec_info);
      bin = anv_pipeline_cache_search(cache, sha1, 20);
   }

   if (bin == NULL) {
      struct brw_cs_prog_data prog_data = { 0, };
      struct anv_pipeline_binding surface_to_descriptor[256];
      struct anv_pipeline_binding sampler_to_descriptor[256];

      map = (struct anv_pipeline_bind_map) {
         .surface_to_descriptor = surface_to_descriptor,
         .sampler_to_descriptor = sampler_to_descriptor
      };

      nir_shader *nir = anv_pipeline_compile(pipeline, module, entrypoint,
                                             MESA_SHADER_COMPUTE, spec_info,
                                             &prog_data.base, &map);
      if (nir == NULL)
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);

      anv_fill_binding_table(&prog_data.base, 1);

      void *mem_ctx = ralloc_context(NULL);

      if (module->nir == NULL)
         ralloc_steal(mem_ctx, nir);

      unsigned code_size;
      const unsigned *shader_code =
         brw_compile_cs(compiler, NULL, mem_ctx, &key, &prog_data, nir,
                        -1, &code_size, NULL);
      if (shader_code == NULL) {
         ralloc_free(mem_ctx);
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);
      }

      bin = anv_pipeline_upload_kernel(pipeline, cache, sha1, 20,
                                       shader_code, code_size,
                                       &prog_data, sizeof(prog_data), &map);
      if (!bin) {
         ralloc_free(mem_ctx);
         return vk_error(VK_ERROR_OUT_OF_HOST_MEMORY);
      }

      ralloc_free(mem_ctx);
   }

   pipeline->cs_simd = bin->kernel.offset;

   anv_pipeline_add_compiled_stage(pipeline, MESA_SHADER_COMPUTE, bin);

   return VK_SUCCESS;
}


void
anv_setup_pipeline_l3_config(struct anv_pipeline *pipeline)
{
   const struct brw_device_info *devinfo = &pipeline->device->info;
   switch (devinfo->gen) {
   case 7:
      if (devinfo->is_haswell)
         gen75_setup_pipeline_l3_config(pipeline);
      else
         gen7_setup_pipeline_l3_config(pipeline);
      break;
   case 8:
      gen8_setup_pipeline_l3_config(pipeline);
      break;
   case 9:
      gen9_setup_pipeline_l3_config(pipeline);
      break;
   default:
      unreachable("unsupported gen\n");
   }
}

void
anv_compute_urb_partition(struct anv_pipeline *pipeline)
{
   const struct brw_device_info *devinfo = &pipeline->device->info;

   bool vs_present = pipeline->active_stages & VK_SHADER_STAGE_VERTEX_BIT;
   unsigned vs_size = vs_present ?
      get_vs_prog_data(pipeline)->base.urb_entry_size : 1;
   unsigned vs_entry_size_bytes = vs_size * 64;
   bool gs_present = pipeline->active_stages & VK_SHADER_STAGE_GEOMETRY_BIT;
   unsigned gs_size = gs_present ?
      get_gs_prog_data(pipeline)->base.urb_entry_size : 1;
   unsigned gs_entry_size_bytes = gs_size * 64;

   /* From p35 of the Ivy Bridge PRM (section 1.7.1: 3DSTATE_URB_GS):
    *
    *     VS Number of URB Entries must be divisible by 8 if the VS URB Entry
    *     Allocation Size is less than 9 512-bit URB entries.
    *
    * Similar text exists for GS.
    */
   unsigned vs_granularity = (vs_size < 9) ? 8 : 1;
   unsigned gs_granularity = (gs_size < 9) ? 8 : 1;

   /* URB allocations must be done in 8k chunks. */
   unsigned chunk_size_bytes = 8192;

   /* Determine the size of the URB in chunks. */
   unsigned urb_chunks = pipeline->urb.total_size * 1024 / chunk_size_bytes;

   /* Reserve space for push constants */
   unsigned push_constant_kb;
   if (pipeline->device->info.gen >= 8)
      push_constant_kb = 32;
   else if (pipeline->device->info.is_haswell)
      push_constant_kb = pipeline->device->info.gt == 3 ? 32 : 16;
   else
      push_constant_kb = 16;

   unsigned push_constant_bytes = push_constant_kb * 1024;
   unsigned push_constant_chunks =
      push_constant_bytes / chunk_size_bytes;

   /* Initially, assign each stage the minimum amount of URB space it needs,
    * and make a note of how much additional space it "wants" (the amount of
    * additional space it could actually make use of).
    */

   /* VS has a lower limit on the number of URB entries */
   unsigned vs_chunks =
      ALIGN(devinfo->urb.min_vs_entries * vs_entry_size_bytes,
            chunk_size_bytes) / chunk_size_bytes;
   unsigned vs_wants =
      ALIGN(devinfo->urb.max_vs_entries * vs_entry_size_bytes,
            chunk_size_bytes) / chunk_size_bytes - vs_chunks;

   unsigned gs_chunks = 0;
   unsigned gs_wants = 0;
   if (gs_present) {
      /* There are two constraints on the minimum amount of URB space we can
       * allocate:
       *
       * (1) We need room for at least 2 URB entries, since we always operate
       * the GS in DUAL_OBJECT mode.
       *
       * (2) We can't allocate less than nr_gs_entries_granularity.
       */
      gs_chunks = ALIGN(MAX2(gs_granularity, 2) * gs_entry_size_bytes,
                        chunk_size_bytes) / chunk_size_bytes;
      gs_wants =
         ALIGN(devinfo->urb.max_gs_entries * gs_entry_size_bytes,
               chunk_size_bytes) / chunk_size_bytes - gs_chunks;
   }

   /* There should always be enough URB space to satisfy the minimum
    * requirements of each stage.
    */
   unsigned total_needs = push_constant_chunks + vs_chunks + gs_chunks;
   assert(total_needs <= urb_chunks);

   /* Mete out remaining space (if any) in proportion to "wants". */
   unsigned total_wants = vs_wants + gs_wants;
   unsigned remaining_space = urb_chunks - total_needs;
   if (remaining_space > total_wants)
      remaining_space = total_wants;
   if (remaining_space > 0) {
      unsigned vs_additional = (unsigned)
         round(vs_wants * (((double) remaining_space) / total_wants));
      vs_chunks += vs_additional;
      remaining_space -= vs_additional;
      gs_chunks += remaining_space;
   }

   /* Sanity check that we haven't over-allocated. */
   assert(push_constant_chunks + vs_chunks + gs_chunks <= urb_chunks);

   /* Finally, compute the number of entries that can fit in the space
    * allocated to each stage.
    */
   unsigned nr_vs_entries = vs_chunks * chunk_size_bytes / vs_entry_size_bytes;
   unsigned nr_gs_entries = gs_chunks * chunk_size_bytes / gs_entry_size_bytes;

   /* Since we rounded up when computing *_wants, this may be slightly more
    * than the maximum allowed amount, so correct for that.
    */
   nr_vs_entries = MIN2(nr_vs_entries, devinfo->urb.max_vs_entries);
   nr_gs_entries = MIN2(nr_gs_entries, devinfo->urb.max_gs_entries);

   /* Ensure that we program a multiple of the granularity. */
   nr_vs_entries = ROUND_DOWN_TO(nr_vs_entries, vs_granularity);
   nr_gs_entries = ROUND_DOWN_TO(nr_gs_entries, gs_granularity);

   /* Finally, sanity check to make sure we have at least the minimum number
    * of entries needed for each stage.
    */
   assert(nr_vs_entries >= devinfo->urb.min_vs_entries);
   if (gs_present)
      assert(nr_gs_entries >= 2);

   /* Lay out the URB in the following order:
    * - push constants
    * - VS
    * - GS
    */
   pipeline->urb.start[MESA_SHADER_VERTEX] = push_constant_chunks;
   pipeline->urb.size[MESA_SHADER_VERTEX] = vs_size;
   pipeline->urb.entries[MESA_SHADER_VERTEX] = nr_vs_entries;

   pipeline->urb.start[MESA_SHADER_GEOMETRY] = push_constant_chunks + vs_chunks;
   pipeline->urb.size[MESA_SHADER_GEOMETRY] = gs_size;
   pipeline->urb.entries[MESA_SHADER_GEOMETRY] = nr_gs_entries;

   pipeline->urb.start[MESA_SHADER_TESS_CTRL] = push_constant_chunks;
   pipeline->urb.size[MESA_SHADER_TESS_CTRL] = 1;
   pipeline->urb.entries[MESA_SHADER_TESS_CTRL] = 0;

   pipeline->urb.start[MESA_SHADER_TESS_EVAL] = push_constant_chunks;
   pipeline->urb.size[MESA_SHADER_TESS_EVAL] = 1;
   pipeline->urb.entries[MESA_SHADER_TESS_EVAL] = 0;
}

/**
 * Copy pipeline state not marked as dynamic.
 * Dynamic state is pipeline state which hasn't been provided at pipeline
 * creation time, but is dynamically provided afterwards using various
 * vkCmdSet* functions.
 *
 * The set of state considered "non_dynamic" is determined by the pieces of
 * state that have their corresponding VkDynamicState enums omitted from
 * VkPipelineDynamicStateCreateInfo::pDynamicStates.
 *
 * @param[out] pipeline    Destination non_dynamic state.
 * @param[in]  pCreateInfo Source of non_dynamic state to be copied.
 */
static void
copy_non_dynamic_state(struct anv_pipeline *pipeline,
                       const VkGraphicsPipelineCreateInfo *pCreateInfo)
{
   anv_cmd_dirty_mask_t states = ANV_CMD_DIRTY_DYNAMIC_ALL;
   ANV_FROM_HANDLE(anv_render_pass, pass, pCreateInfo->renderPass);
   struct anv_subpass *subpass = &pass->subpasses[pCreateInfo->subpass];

   pipeline->dynamic_state = default_dynamic_state;

   if (pCreateInfo->pDynamicState) {
      /* Remove all of the states that are marked as dynamic */
      uint32_t count = pCreateInfo->pDynamicState->dynamicStateCount;
      for (uint32_t s = 0; s < count; s++)
         states &= ~(1 << pCreateInfo->pDynamicState->pDynamicStates[s]);
   }

   struct anv_dynamic_state *dynamic = &pipeline->dynamic_state;

   /* Section 9.2 of the Vulkan 1.0.15 spec says:
    *
    *    pViewportState is [...] NULL if the pipeline
    *    has rasterization disabled.
    */
   if (!pCreateInfo->pRasterizationState->rasterizerDiscardEnable) {
      assert(pCreateInfo->pViewportState);

      dynamic->viewport.count = pCreateInfo->pViewportState->viewportCount;
      if (states & (1 << VK_DYNAMIC_STATE_VIEWPORT)) {
         typed_memcpy(dynamic->viewport.viewports,
                     pCreateInfo->pViewportState->pViewports,
                     pCreateInfo->pViewportState->viewportCount);
      }

      dynamic->scissor.count = pCreateInfo->pViewportState->scissorCount;
      if (states & (1 << VK_DYNAMIC_STATE_SCISSOR)) {
         typed_memcpy(dynamic->scissor.scissors,
                     pCreateInfo->pViewportState->pScissors,
                     pCreateInfo->pViewportState->scissorCount);
      }
   }

   if (states & (1 << VK_DYNAMIC_STATE_LINE_WIDTH)) {
      assert(pCreateInfo->pRasterizationState);
      dynamic->line_width = pCreateInfo->pRasterizationState->lineWidth;
   }

   if (states & (1 << VK_DYNAMIC_STATE_DEPTH_BIAS)) {
      assert(pCreateInfo->pRasterizationState);
      dynamic->depth_bias.bias =
         pCreateInfo->pRasterizationState->depthBiasConstantFactor;
      dynamic->depth_bias.clamp =
         pCreateInfo->pRasterizationState->depthBiasClamp;
      dynamic->depth_bias.slope =
         pCreateInfo->pRasterizationState->depthBiasSlopeFactor;
   }

   /* Section 9.2 of the Vulkan 1.0.15 spec says:
    *
    *    pColorBlendState is [...] NULL if the pipeline has rasterization
    *    disabled or if the subpass of the render pass the pipeline is
    *    created against does not use any color attachments.
    */
   bool uses_color_att = false;
   for (unsigned i = 0; i < subpass->color_count; ++i) {
      if (subpass->color_attachments[i] != VK_ATTACHMENT_UNUSED) {
         uses_color_att = true;
         break;
      }
   }

   if (uses_color_att &&
       !pCreateInfo->pRasterizationState->rasterizerDiscardEnable) {
      assert(pCreateInfo->pColorBlendState);

      if (states & (1 << VK_DYNAMIC_STATE_BLEND_CONSTANTS))
         typed_memcpy(dynamic->blend_constants,
                     pCreateInfo->pColorBlendState->blendConstants, 4);
   }

   /* If there is no depthstencil attachment, then don't read
    * pDepthStencilState. The Vulkan spec states that pDepthStencilState may
    * be NULL in this case. Even if pDepthStencilState is non-NULL, there is
    * no need to override the depthstencil defaults in
    * anv_pipeline::dynamic_state when there is no depthstencil attachment.
    *
    * Section 9.2 of the Vulkan 1.0.15 spec says:
    *
    *    pDepthStencilState is [...] NULL if the pipeline has rasterization
    *    disabled or if the subpass of the render pass the pipeline is created
    *    against does not use a depth/stencil attachment.
    */
   if (!pCreateInfo->pRasterizationState->rasterizerDiscardEnable &&
       subpass->depth_stencil_attachment != VK_ATTACHMENT_UNUSED) {
      assert(pCreateInfo->pDepthStencilState);

      if (states & (1 << VK_DYNAMIC_STATE_DEPTH_BOUNDS)) {
         dynamic->depth_bounds.min =
            pCreateInfo->pDepthStencilState->minDepthBounds;
         dynamic->depth_bounds.max =
            pCreateInfo->pDepthStencilState->maxDepthBounds;
      }

      if (states & (1 << VK_DYNAMIC_STATE_STENCIL_COMPARE_MASK)) {
         dynamic->stencil_compare_mask.front =
            pCreateInfo->pDepthStencilState->front.compareMask;
         dynamic->stencil_compare_mask.back =
            pCreateInfo->pDepthStencilState->back.compareMask;
      }

      if (states & (1 << VK_DYNAMIC_STATE_STENCIL_WRITE_MASK)) {
         dynamic->stencil_write_mask.front =
            pCreateInfo->pDepthStencilState->front.writeMask;
         dynamic->stencil_write_mask.back =
            pCreateInfo->pDepthStencilState->back.writeMask;
      }

      if (states & (1 << VK_DYNAMIC_STATE_STENCIL_REFERENCE)) {
         dynamic->stencil_reference.front =
            pCreateInfo->pDepthStencilState->front.reference;
         dynamic->stencil_reference.back =
            pCreateInfo->pDepthStencilState->back.reference;
      }
   }

   pipeline->dynamic_state_mask = states;
}

static void
anv_pipeline_validate_create_info(const VkGraphicsPipelineCreateInfo *info)
{
   struct anv_render_pass *renderpass = NULL;
   struct anv_subpass *subpass = NULL;

   /* Assert that all required members of VkGraphicsPipelineCreateInfo are
    * present, as explained by the Vulkan (20 Oct 2015, git-aa308cb), Section
    * 4.2 Graphics Pipeline.
    */
   assert(info->sType == VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO);

   renderpass = anv_render_pass_from_handle(info->renderPass);
   assert(renderpass);

   if (renderpass != &anv_meta_dummy_renderpass) {
      assert(info->subpass < renderpass->subpass_count);
      subpass = &renderpass->subpasses[info->subpass];
   }

   assert(info->stageCount >= 1);
   assert(info->pVertexInputState);
   assert(info->pInputAssemblyState);
   assert(info->pViewportState);
   assert(info->pRasterizationState);

   if (subpass && subpass->depth_stencil_attachment != VK_ATTACHMENT_UNUSED)
      assert(info->pDepthStencilState);

   if (subpass && subpass->color_count > 0)
      assert(info->pColorBlendState);

   for (uint32_t i = 0; i < info->stageCount; ++i) {
      switch (info->pStages[i].stage) {
      case VK_SHADER_STAGE_TESSELLATION_CONTROL_BIT:
      case VK_SHADER_STAGE_TESSELLATION_EVALUATION_BIT:
         assert(info->pTessellationState);
         break;
      default:
         break;
      }
   }
}

VkResult
anv_pipeline_init(struct anv_pipeline *pipeline,
                  struct anv_device *device,
                  struct anv_pipeline_cache *cache,
                  const VkGraphicsPipelineCreateInfo *pCreateInfo,
                  const struct anv_graphics_pipeline_create_info *extra,
                  const VkAllocationCallbacks *alloc)
{
   VkResult result;

   anv_validate {
      anv_pipeline_validate_create_info(pCreateInfo);
   }

   if (alloc == NULL)
      alloc = &device->alloc;

   pipeline->device = device;
   pipeline->layout = anv_pipeline_layout_from_handle(pCreateInfo->layout);

   result = anv_reloc_list_init(&pipeline->batch_relocs, alloc);
   if (result != VK_SUCCESS)
      return result;

   pipeline->batch.alloc = alloc;
   pipeline->batch.next = pipeline->batch.start = pipeline->batch_data;
   pipeline->batch.end = pipeline->batch.start + sizeof(pipeline->batch_data);
   pipeline->batch.relocs = &pipeline->batch_relocs;

   copy_non_dynamic_state(pipeline, pCreateInfo);
   pipeline->depth_clamp_enable = pCreateInfo->pRasterizationState &&
                                  pCreateInfo->pRasterizationState->depthClampEnable;

   pipeline->use_repclear = extra && extra->use_repclear;

   pipeline->needs_data_cache = false;

   /* When we free the pipeline, we detect stages based on the NULL status
    * of various prog_data pointers.  Make them NULL by default.
    */
   memset(pipeline->shaders, 0, sizeof(pipeline->shaders));

   pipeline->vs_simd8 = NO_KERNEL;
   pipeline->vs_vec4 = NO_KERNEL;
   pipeline->gs_kernel = NO_KERNEL;
   pipeline->ps_ksp0 = NO_KERNEL;

   pipeline->active_stages = 0;

   const VkPipelineShaderStageCreateInfo *pStages[MESA_SHADER_STAGES] = { 0, };
   struct anv_shader_module *modules[MESA_SHADER_STAGES] = { 0, };
   for (uint32_t i = 0; i < pCreateInfo->stageCount; i++) {
      gl_shader_stage stage = ffs(pCreateInfo->pStages[i].stage) - 1;
      pStages[stage] = &pCreateInfo->pStages[i];
      modules[stage] = anv_shader_module_from_handle(pStages[stage]->module);
   }

   if (modules[MESA_SHADER_VERTEX]) {
      result = anv_pipeline_compile_vs(pipeline, cache, pCreateInfo,
                                       modules[MESA_SHADER_VERTEX],
                                       pStages[MESA_SHADER_VERTEX]->pName,
                                       pStages[MESA_SHADER_VERTEX]->pSpecializationInfo);
      if (result != VK_SUCCESS)
         goto compile_fail;
   }

   if (modules[MESA_SHADER_TESS_CTRL] || modules[MESA_SHADER_TESS_EVAL])
      anv_finishme("no tessellation support");

   if (modules[MESA_SHADER_GEOMETRY]) {
      result = anv_pipeline_compile_gs(pipeline, cache, pCreateInfo,
                                       modules[MESA_SHADER_GEOMETRY],
                                       pStages[MESA_SHADER_GEOMETRY]->pName,
                                       pStages[MESA_SHADER_GEOMETRY]->pSpecializationInfo);
      if (result != VK_SUCCESS)
         goto compile_fail;
   }

   if (modules[MESA_SHADER_FRAGMENT]) {
      result = anv_pipeline_compile_fs(pipeline, cache, pCreateInfo, extra,
                                       modules[MESA_SHADER_FRAGMENT],
                                       pStages[MESA_SHADER_FRAGMENT]->pName,
                                       pStages[MESA_SHADER_FRAGMENT]->pSpecializationInfo);
      if (result != VK_SUCCESS)
         goto compile_fail;
   }

   if (!(pipeline->active_stages & VK_SHADER_STAGE_VERTEX_BIT)) {
      /* Vertex is only optional if disable_vs is set */
      assert(extra->disable_vs);
   }

   anv_setup_pipeline_l3_config(pipeline);
   anv_compute_urb_partition(pipeline);

   const VkPipelineVertexInputStateCreateInfo *vi_info =
      pCreateInfo->pVertexInputState;

   uint64_t inputs_read;
   if (extra && extra->disable_vs) {
      /* If the VS is disabled, just assume the user knows what they're
       * doing and apply the layout blindly.  This can only come from
       * meta, so this *should* be safe.
       */
      inputs_read = ~0ull;
   } else {
      inputs_read = get_vs_prog_data(pipeline)->inputs_read;
   }

   pipeline->vb_used = 0;
   for (uint32_t i = 0; i < vi_info->vertexAttributeDescriptionCount; i++) {
      const VkVertexInputAttributeDescription *desc =
         &vi_info->pVertexAttributeDescriptions[i];

      if (inputs_read & (1 << (VERT_ATTRIB_GENERIC0 + desc->location)))
         pipeline->vb_used |= 1 << desc->binding;
   }

   for (uint32_t i = 0; i < vi_info->vertexBindingDescriptionCount; i++) {
      const VkVertexInputBindingDescription *desc =
         &vi_info->pVertexBindingDescriptions[i];

      pipeline->binding_stride[desc->binding] = desc->stride;

      /* Step rate is programmed per vertex element (attribute), not
       * binding. Set up a map of which bindings step per instance, for
       * reference by vertex element setup. */
      switch (desc->inputRate) {
      default:
      case VK_VERTEX_INPUT_RATE_VERTEX:
         pipeline->instancing_enable[desc->binding] = false;
         break;
      case VK_VERTEX_INPUT_RATE_INSTANCE:
         pipeline->instancing_enable[desc->binding] = true;
         break;
      }
   }

   const VkPipelineInputAssemblyStateCreateInfo *ia_info =
      pCreateInfo->pInputAssemblyState;
   pipeline->primitive_restart = ia_info->primitiveRestartEnable;
   pipeline->topology = vk_to_gen_primitive_type[ia_info->topology];

   if (extra && extra->use_rectlist)
      pipeline->topology = _3DPRIM_RECTLIST;

   return VK_SUCCESS;

compile_fail:
   for (unsigned s = 0; s < MESA_SHADER_STAGES; s++) {
      if (pipeline->shaders[s])
         anv_shader_bin_unref(device, pipeline->shaders[s]);
   }

   anv_reloc_list_finish(&pipeline->batch_relocs, alloc);

   return result;
}

VkResult
anv_graphics_pipeline_create(
   VkDevice _device,
   VkPipelineCache _cache,
   const VkGraphicsPipelineCreateInfo *pCreateInfo,
   const struct anv_graphics_pipeline_create_info *extra,
   const VkAllocationCallbacks *pAllocator,
   VkPipeline *pPipeline)
{
   ANV_FROM_HANDLE(anv_device, device, _device);
   ANV_FROM_HANDLE(anv_pipeline_cache, cache, _cache);

   switch (device->info.gen) {
   case 7:
      if (device->info.is_haswell)
         return gen75_graphics_pipeline_create(_device, cache, pCreateInfo, extra, pAllocator, pPipeline);
      else
         return gen7_graphics_pipeline_create(_device, cache, pCreateInfo, extra, pAllocator, pPipeline);
   case 8:
      return gen8_graphics_pipeline_create(_device, cache, pCreateInfo, extra, pAllocator, pPipeline);
   case 9:
      return gen9_graphics_pipeline_create(_device, cache, pCreateInfo, extra, pAllocator, pPipeline);
   default:
      unreachable("unsupported gen\n");
   }
}

VkResult anv_CreateGraphicsPipelines(
    VkDevice                                    _device,
    VkPipelineCache                             pipelineCache,
    uint32_t                                    count,
    const VkGraphicsPipelineCreateInfo*         pCreateInfos,
    const VkAllocationCallbacks*                pAllocator,
    VkPipeline*                                 pPipelines)
{
   VkResult result = VK_SUCCESS;

   unsigned i = 0;
   for (; i < count; i++) {
      result = anv_graphics_pipeline_create(_device,
                                            pipelineCache,
                                            &pCreateInfos[i],
                                            NULL, pAllocator, &pPipelines[i]);
      if (result != VK_SUCCESS) {
         for (unsigned j = 0; j < i; j++) {
            anv_DestroyPipeline(_device, pPipelines[j], pAllocator);
         }

         return result;
      }
   }

   return VK_SUCCESS;
}

static VkResult anv_compute_pipeline_create(
    VkDevice                                    _device,
    VkPipelineCache                             _cache,
    const VkComputePipelineCreateInfo*          pCreateInfo,
    const VkAllocationCallbacks*                pAllocator,
    VkPipeline*                                 pPipeline)
{
   ANV_FROM_HANDLE(anv_device, device, _device);
   ANV_FROM_HANDLE(anv_pipeline_cache, cache, _cache);

   switch (device->info.gen) {
   case 7:
      if (device->info.is_haswell)
         return gen75_compute_pipeline_create(_device, cache, pCreateInfo, pAllocator, pPipeline);
      else
         return gen7_compute_pipeline_create(_device, cache, pCreateInfo, pAllocator, pPipeline);
   case 8:
      return gen8_compute_pipeline_create(_device, cache, pCreateInfo, pAllocator, pPipeline);
   case 9:
      return gen9_compute_pipeline_create(_device, cache, pCreateInfo, pAllocator, pPipeline);
   default:
      unreachable("unsupported gen\n");
   }
}

VkResult anv_CreateComputePipelines(
    VkDevice                                    _device,
    VkPipelineCache                             pipelineCache,
    uint32_t                                    count,
    const VkComputePipelineCreateInfo*          pCreateInfos,
    const VkAllocationCallbacks*                pAllocator,
    VkPipeline*                                 pPipelines)
{
   VkResult result = VK_SUCCESS;

   unsigned i = 0;
   for (; i < count; i++) {
      result = anv_compute_pipeline_create(_device, pipelineCache,
                                           &pCreateInfos[i],
                                           pAllocator, &pPipelines[i]);
      if (result != VK_SUCCESS) {
         for (unsigned j = 0; j < i; j++) {
            anv_DestroyPipeline(_device, pPipelines[j], pAllocator);
         }

         return result;
      }
   }

   return VK_SUCCESS;
}
