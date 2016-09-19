/*
 * Copyright © 2011 Marek Olšák <maraeo@gmail.com>
 * All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sub license, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS, AUTHORS
 * AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
 * USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * The above copyright notice and this permission notice (including the
 * next paragraph) shall be included in all copies or substantial portions
 * of the Software.
 */

#include "radeon_drm_cs.h"

#include "util/u_hash_table.h"
#include "util/u_memory.h"
#include "util/simple_list.h"
#include "os/os_thread.h"
#include "os/os_mman.h"
#include "os/os_time.h"

#include "state_tracker/drm_driver.h"

#include <sys/ioctl.h>
#include <xf86drm.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <inttypes.h>

static inline struct radeon_bo *radeon_bo(struct pb_buffer *bo)
{
    return (struct radeon_bo *)bo;
}

struct radeon_bo_va_hole {
    struct list_head list;
    uint64_t         offset;
    uint64_t         size;
};

static bool radeon_bo_is_busy(struct radeon_bo *bo)
{
    struct drm_radeon_gem_busy args = {0};

    args.handle = bo->handle;
    return drmCommandWriteRead(bo->rws->fd, DRM_RADEON_GEM_BUSY,
                               &args, sizeof(args)) != 0;
}

static void radeon_bo_wait_idle(struct radeon_bo *bo)
{
    struct drm_radeon_gem_wait_idle args = {0};

    args.handle = bo->handle;
    while (drmCommandWrite(bo->rws->fd, DRM_RADEON_GEM_WAIT_IDLE,
                           &args, sizeof(args)) == -EBUSY);
}

static bool radeon_bo_wait(struct pb_buffer *_buf, uint64_t timeout,
                           enum radeon_bo_usage usage)
{
    struct radeon_bo *bo = radeon_bo(_buf);
    int64_t abs_timeout;

    /* No timeout. Just query. */
    if (timeout == 0)
        return !bo->num_active_ioctls && !radeon_bo_is_busy(bo);

    abs_timeout = os_time_get_absolute_timeout(timeout);

    /* Wait if any ioctl is being submitted with this buffer. */
    if (!os_wait_until_zero_abs_timeout(&bo->num_active_ioctls, abs_timeout))
        return false;

    /* Infinite timeout. */
    if (abs_timeout == PIPE_TIMEOUT_INFINITE) {
        radeon_bo_wait_idle(bo);
        return true;
    }

    /* Other timeouts need to be emulated with a loop. */
    while (radeon_bo_is_busy(bo)) {
       if (os_time_get_nano() >= abs_timeout)
          return false;
       os_time_sleep(10);
    }

    return true;
}

static enum radeon_bo_domain get_valid_domain(enum radeon_bo_domain domain)
{
    /* Zero domains the driver doesn't understand. */
    domain &= RADEON_DOMAIN_VRAM_GTT;

    /* If no domain is set, we must set something... */
    if (!domain)
        domain = RADEON_DOMAIN_VRAM_GTT;

    return domain;
}

static enum radeon_bo_domain radeon_bo_get_initial_domain(
		struct pb_buffer *buf)
{
    struct radeon_bo *bo = (struct radeon_bo*)buf;
    struct drm_radeon_gem_op args;

    if (bo->rws->info.drm_minor < 38)
        return RADEON_DOMAIN_VRAM_GTT;

    memset(&args, 0, sizeof(args));
    args.handle = bo->handle;
    args.op = RADEON_GEM_OP_GET_INITIAL_DOMAIN;

    drmCommandWriteRead(bo->rws->fd, DRM_RADEON_GEM_OP,
                        &args, sizeof(args));

    /* GEM domains and winsys domains are defined the same. */
    return get_valid_domain(args.value);
}

static uint64_t radeon_bomgr_find_va(struct radeon_drm_winsys *rws,
                                     uint64_t size, uint64_t alignment)
{
    struct radeon_bo_va_hole *hole, *n;
    uint64_t offset = 0, waste = 0;

    /* All VM address space holes will implicitly start aligned to the
     * size alignment, so we don't need to sanitize the alignment here
     */
    size = align(size, rws->info.gart_page_size);

    pipe_mutex_lock(rws->bo_va_mutex);
    /* first look for a hole */
    LIST_FOR_EACH_ENTRY_SAFE(hole, n, &rws->va_holes, list) {
        offset = hole->offset;
        waste = offset % alignment;
        waste = waste ? alignment - waste : 0;
        offset += waste;
        if (offset >= (hole->offset + hole->size)) {
            continue;
        }
        if (!waste && hole->size == size) {
            offset = hole->offset;
            list_del(&hole->list);
            FREE(hole);
            pipe_mutex_unlock(rws->bo_va_mutex);
            return offset;
        }
        if ((hole->size - waste) > size) {
            if (waste) {
                n = CALLOC_STRUCT(radeon_bo_va_hole);
                n->size = waste;
                n->offset = hole->offset;
                list_add(&n->list, &hole->list);
            }
            hole->size -= (size + waste);
            hole->offset += size + waste;
            pipe_mutex_unlock(rws->bo_va_mutex);
            return offset;
        }
        if ((hole->size - waste) == size) {
            hole->size = waste;
            pipe_mutex_unlock(rws->bo_va_mutex);
            return offset;
        }
    }

    offset = rws->va_offset;
    waste = offset % alignment;
    waste = waste ? alignment - waste : 0;
    if (waste) {
        n = CALLOC_STRUCT(radeon_bo_va_hole);
        n->size = waste;
        n->offset = offset;
        list_add(&n->list, &rws->va_holes);
    }
    offset += waste;
    rws->va_offset += size + waste;
    pipe_mutex_unlock(rws->bo_va_mutex);
    return offset;
}

static void radeon_bomgr_free_va(struct radeon_drm_winsys *rws,
                                 uint64_t va, uint64_t size)
{
    struct radeon_bo_va_hole *hole;

    size = align(size, rws->info.gart_page_size);

    pipe_mutex_lock(rws->bo_va_mutex);
    if ((va + size) == rws->va_offset) {
        rws->va_offset = va;
        /* Delete uppermost hole if it reaches the new top */
        if (!LIST_IS_EMPTY(&rws->va_holes)) {
            hole = container_of(rws->va_holes.next, hole, list);
            if ((hole->offset + hole->size) == va) {
                rws->va_offset = hole->offset;
                list_del(&hole->list);
                FREE(hole);
            }
        }
    } else {
        struct radeon_bo_va_hole *next;

        hole = container_of(&rws->va_holes, hole, list);
        LIST_FOR_EACH_ENTRY(next, &rws->va_holes, list) {
	    if (next->offset < va)
	        break;
            hole = next;
        }

        if (&hole->list != &rws->va_holes) {
            /* Grow upper hole if it's adjacent */
            if (hole->offset == (va + size)) {
                hole->offset = va;
                hole->size += size;
                /* Merge lower hole if it's adjacent */
                if (next != hole && &next->list != &rws->va_holes &&
                    (next->offset + next->size) == va) {
                    next->size += hole->size;
                    list_del(&hole->list);
                    FREE(hole);
                }
                goto out;
            }
        }

        /* Grow lower hole if it's adjacent */
        if (next != hole && &next->list != &rws->va_holes &&
            (next->offset + next->size) == va) {
            next->size += size;
            goto out;
        }

        /* FIXME on allocation failure we just lose virtual address space
         * maybe print a warning
         */
        next = CALLOC_STRUCT(radeon_bo_va_hole);
        if (next) {
            next->size = size;
            next->offset = va;
            list_add(&next->list, &hole->list);
        }
    }
out:
    pipe_mutex_unlock(rws->bo_va_mutex);
}

void radeon_bo_destroy(struct pb_buffer *_buf)
{
    struct radeon_bo *bo = radeon_bo(_buf);
    struct radeon_drm_winsys *rws = bo->rws;
    struct drm_gem_close args;

    memset(&args, 0, sizeof(args));

    pipe_mutex_lock(rws->bo_handles_mutex);
    util_hash_table_remove(rws->bo_handles, (void*)(uintptr_t)bo->handle);
    if (bo->flink_name) {
        util_hash_table_remove(rws->bo_names,
                               (void*)(uintptr_t)bo->flink_name);
    }
    pipe_mutex_unlock(rws->bo_handles_mutex);

    if (bo->ptr)
        os_munmap(bo->ptr, bo->base.size);

    if (rws->info.has_virtual_memory) {
        if (rws->va_unmap_working) {
            struct drm_radeon_gem_va va;

            va.handle = bo->handle;
            va.vm_id = 0;
            va.operation = RADEON_VA_UNMAP;
            va.flags = RADEON_VM_PAGE_READABLE |
                       RADEON_VM_PAGE_WRITEABLE |
                       RADEON_VM_PAGE_SNOOPED;
            va.offset = bo->va;

            if (drmCommandWriteRead(rws->fd, DRM_RADEON_GEM_VA, &va,
				    sizeof(va)) != 0 &&
		va.operation == RADEON_VA_RESULT_ERROR) {
                fprintf(stderr, "radeon: Failed to deallocate virtual address for buffer:\n");
                fprintf(stderr, "radeon:    size      : %"PRIu64" bytes\n", bo->base.size);
                fprintf(stderr, "radeon:    va        : 0x%"PRIx64"\n", bo->va);
            }
	}

	radeon_bomgr_free_va(rws, bo->va, bo->base.size);
    }

    /* Close object. */
    args.handle = bo->handle;
    drmIoctl(rws->fd, DRM_IOCTL_GEM_CLOSE, &args);

    pipe_mutex_destroy(bo->map_mutex);

    if (bo->initial_domain & RADEON_DOMAIN_VRAM)
        rws->allocated_vram -= align(bo->base.size, rws->info.gart_page_size);
    else if (bo->initial_domain & RADEON_DOMAIN_GTT)
        rws->allocated_gtt -= align(bo->base.size, rws->info.gart_page_size);
    FREE(bo);
}

static void radeon_bo_destroy_or_cache(struct pb_buffer *_buf)
{
   struct radeon_bo *bo = radeon_bo(_buf);

   if (bo->use_reusable_pool)
      pb_cache_add_buffer(&bo->cache_entry);
   else
      radeon_bo_destroy(_buf);
}

void *radeon_bo_do_map(struct radeon_bo *bo)
{
    struct drm_radeon_gem_mmap args = {0};
    void *ptr;

    /* If the buffer is created from user memory, return the user pointer. */
    if (bo->user_ptr)
        return bo->user_ptr;

    /* Map the buffer. */
    pipe_mutex_lock(bo->map_mutex);
    /* Return the pointer if it's already mapped. */
    if (bo->ptr) {
        bo->map_count++;
        pipe_mutex_unlock(bo->map_mutex);
        return bo->ptr;
    }
    args.handle = bo->handle;
    args.offset = 0;
    args.size = (uint64_t)bo->base.size;
    if (drmCommandWriteRead(bo->rws->fd,
                            DRM_RADEON_GEM_MMAP,
                            &args,
                            sizeof(args))) {
        pipe_mutex_unlock(bo->map_mutex);
        fprintf(stderr, "radeon: gem_mmap failed: %p 0x%08X\n",
                bo, bo->handle);
        return NULL;
    }

    ptr = os_mmap(0, args.size, PROT_READ|PROT_WRITE, MAP_SHARED,
               bo->rws->fd, args.addr_ptr);
    if (ptr == MAP_FAILED) {
        /* Clear the cache and try again. */
        pb_cache_release_all_buffers(&bo->rws->bo_cache);

        ptr = os_mmap(0, args.size, PROT_READ|PROT_WRITE, MAP_SHARED,
                      bo->rws->fd, args.addr_ptr);
        if (ptr == MAP_FAILED) {
            pipe_mutex_unlock(bo->map_mutex);
            fprintf(stderr, "radeon: mmap failed, errno: %i\n", errno);
            return NULL;
        }
    }
    bo->ptr = ptr;
    bo->map_count = 1;

    if (bo->initial_domain & RADEON_DOMAIN_VRAM)
       bo->rws->mapped_vram += bo->base.size;
    else
       bo->rws->mapped_gtt += bo->base.size;

    pipe_mutex_unlock(bo->map_mutex);
    return bo->ptr;
}

static void *radeon_bo_map(struct pb_buffer *buf,
                           struct radeon_winsys_cs *rcs,
                           enum pipe_transfer_usage usage)
{
    struct radeon_bo *bo = (struct radeon_bo*)buf;
    struct radeon_drm_cs *cs = (struct radeon_drm_cs*)rcs;

    /* If it's not unsynchronized bo_map, flush CS if needed and then wait. */
    if (!(usage & PIPE_TRANSFER_UNSYNCHRONIZED)) {
        /* DONTBLOCK doesn't make sense with UNSYNCHRONIZED. */
        if (usage & PIPE_TRANSFER_DONTBLOCK) {
            if (!(usage & PIPE_TRANSFER_WRITE)) {
                /* Mapping for read.
                 *
                 * Since we are mapping for read, we don't need to wait
                 * if the GPU is using the buffer for read too
                 * (neither one is changing it).
                 *
                 * Only check whether the buffer is being used for write. */
                if (cs && radeon_bo_is_referenced_by_cs_for_write(cs, bo)) {
                    cs->flush_cs(cs->flush_data, RADEON_FLUSH_ASYNC, NULL);
                    return NULL;
                }

                if (!radeon_bo_wait((struct pb_buffer*)bo, 0,
                                    RADEON_USAGE_WRITE)) {
                    return NULL;
                }
            } else {
                if (cs && radeon_bo_is_referenced_by_cs(cs, bo)) {
                    cs->flush_cs(cs->flush_data, RADEON_FLUSH_ASYNC, NULL);
                    return NULL;
                }

                if (!radeon_bo_wait((struct pb_buffer*)bo, 0,
                                    RADEON_USAGE_READWRITE)) {
                    return NULL;
                }
            }
        } else {
            uint64_t time = os_time_get_nano();

            if (!(usage & PIPE_TRANSFER_WRITE)) {
                /* Mapping for read.
                 *
                 * Since we are mapping for read, we don't need to wait
                 * if the GPU is using the buffer for read too
                 * (neither one is changing it).
                 *
                 * Only check whether the buffer is being used for write. */
                if (cs && radeon_bo_is_referenced_by_cs_for_write(cs, bo)) {
                    cs->flush_cs(cs->flush_data, 0, NULL);
                }
                radeon_bo_wait((struct pb_buffer*)bo, PIPE_TIMEOUT_INFINITE,
                               RADEON_USAGE_WRITE);
            } else {
                /* Mapping for write. */
                if (cs) {
                    if (radeon_bo_is_referenced_by_cs(cs, bo)) {
                        cs->flush_cs(cs->flush_data, 0, NULL);
                    } else {
                        /* Try to avoid busy-waiting in radeon_bo_wait. */
                        if (p_atomic_read(&bo->num_active_ioctls))
                            radeon_drm_cs_sync_flush(rcs);
                    }
                }

                radeon_bo_wait((struct pb_buffer*)bo, PIPE_TIMEOUT_INFINITE,
                               RADEON_USAGE_READWRITE);
            }

            bo->rws->buffer_wait_time += os_time_get_nano() - time;
        }
    }

    return radeon_bo_do_map(bo);
}

static void radeon_bo_unmap(struct pb_buffer *_buf)
{
    struct radeon_bo *bo = (struct radeon_bo*)_buf;

    if (bo->user_ptr)
        return;

    pipe_mutex_lock(bo->map_mutex);
    if (!bo->ptr) {
        pipe_mutex_unlock(bo->map_mutex);
        return; /* it's not been mapped */
    }

    assert(bo->map_count);
    if (--bo->map_count) {
        pipe_mutex_unlock(bo->map_mutex);
        return; /* it's been mapped multiple times */
    }

    os_munmap(bo->ptr, bo->base.size);
    bo->ptr = NULL;

    if (bo->initial_domain & RADEON_DOMAIN_VRAM)
       bo->rws->mapped_vram -= bo->base.size;
    else
       bo->rws->mapped_gtt -= bo->base.size;

    pipe_mutex_unlock(bo->map_mutex);
}

static const struct pb_vtbl radeon_bo_vtbl = {
    radeon_bo_destroy_or_cache
    /* other functions are never called */
};

#ifndef RADEON_GEM_GTT_WC
#define RADEON_GEM_GTT_WC		(1 << 2)
#endif
#ifndef RADEON_GEM_CPU_ACCESS
/* BO is expected to be accessed by the CPU */
#define RADEON_GEM_CPU_ACCESS		(1 << 3)
#endif
#ifndef RADEON_GEM_NO_CPU_ACCESS
/* CPU access is not expected to work for this BO */
#define RADEON_GEM_NO_CPU_ACCESS	(1 << 4)
#endif

static struct radeon_bo *radeon_create_bo(struct radeon_drm_winsys *rws,
                                          unsigned size, unsigned alignment,
                                          unsigned usage,
                                          unsigned initial_domains,
                                          unsigned flags,
                                          unsigned pb_cache_bucket)
{
    struct radeon_bo *bo;
    struct drm_radeon_gem_create args;
    int r;

    memset(&args, 0, sizeof(args));

    assert(initial_domains);
    assert((initial_domains &
            ~(RADEON_GEM_DOMAIN_GTT | RADEON_GEM_DOMAIN_VRAM)) == 0);

    args.size = size;
    args.alignment = alignment;
    args.initial_domain = initial_domains;
    args.flags = 0;

    if (flags & RADEON_FLAG_GTT_WC)
        args.flags |= RADEON_GEM_GTT_WC;
    if (flags & RADEON_FLAG_CPU_ACCESS)
        args.flags |= RADEON_GEM_CPU_ACCESS;
    if (flags & RADEON_FLAG_NO_CPU_ACCESS)
        args.flags |= RADEON_GEM_NO_CPU_ACCESS;

    if (drmCommandWriteRead(rws->fd, DRM_RADEON_GEM_CREATE,
                            &args, sizeof(args))) {
        fprintf(stderr, "radeon: Failed to allocate a buffer:\n");
        fprintf(stderr, "radeon:    size      : %u bytes\n", size);
        fprintf(stderr, "radeon:    alignment : %u bytes\n", alignment);
        fprintf(stderr, "radeon:    domains   : %u\n", args.initial_domain);
        fprintf(stderr, "radeon:    flags     : %u\n", args.flags);
        return NULL;
    }

    bo = CALLOC_STRUCT(radeon_bo);
    if (!bo)
        return NULL;

    pipe_reference_init(&bo->base.reference, 1);
    bo->base.alignment = alignment;
    bo->base.usage = usage;
    bo->base.size = size;
    bo->base.vtbl = &radeon_bo_vtbl;
    bo->rws = rws;
    bo->handle = args.handle;
    bo->va = 0;
    bo->initial_domain = initial_domains;
    pipe_mutex_init(bo->map_mutex);
    pb_cache_init_entry(&rws->bo_cache, &bo->cache_entry, &bo->base,
                        pb_cache_bucket);

    if (rws->info.has_virtual_memory) {
        struct drm_radeon_gem_va va;
        unsigned va_gap_size;

        va_gap_size = rws->check_vm ? MAX2(4 * alignment, 64 * 1024) : 0;
        bo->va = radeon_bomgr_find_va(rws, size + va_gap_size, alignment);

        va.handle = bo->handle;
        va.vm_id = 0;
        va.operation = RADEON_VA_MAP;
        va.flags = RADEON_VM_PAGE_READABLE |
                   RADEON_VM_PAGE_WRITEABLE |
                   RADEON_VM_PAGE_SNOOPED;
        va.offset = bo->va;
        r = drmCommandWriteRead(rws->fd, DRM_RADEON_GEM_VA, &va, sizeof(va));
        if (r && va.operation == RADEON_VA_RESULT_ERROR) {
            fprintf(stderr, "radeon: Failed to allocate virtual address for buffer:\n");
            fprintf(stderr, "radeon:    size      : %d bytes\n", size);
            fprintf(stderr, "radeon:    alignment : %d bytes\n", alignment);
            fprintf(stderr, "radeon:    domains   : %d\n", args.initial_domain);
            fprintf(stderr, "radeon:    va        : 0x%016llx\n", (unsigned long long)bo->va);
            radeon_bo_destroy(&bo->base);
            return NULL;
        }
        pipe_mutex_lock(rws->bo_handles_mutex);
        if (va.operation == RADEON_VA_RESULT_VA_EXIST) {
            struct pb_buffer *b = &bo->base;
            struct radeon_bo *old_bo =
                util_hash_table_get(rws->bo_vas, (void*)(uintptr_t)va.offset);

            pipe_mutex_unlock(rws->bo_handles_mutex);
            pb_reference(&b, &old_bo->base);
            return radeon_bo(b);
        }

        util_hash_table_set(rws->bo_vas, (void*)(uintptr_t)bo->va, bo);
        pipe_mutex_unlock(rws->bo_handles_mutex);
    }

    if (initial_domains & RADEON_DOMAIN_VRAM)
        rws->allocated_vram += align(size, rws->info.gart_page_size);
    else if (initial_domains & RADEON_DOMAIN_GTT)
        rws->allocated_gtt += align(size, rws->info.gart_page_size);

    return bo;
}

bool radeon_bo_can_reclaim(struct pb_buffer *_buf)
{
   struct radeon_bo *bo = radeon_bo(_buf);

   if (radeon_bo_is_referenced_by_any_cs(bo))
      return false;

   return radeon_bo_wait(_buf, 0, RADEON_USAGE_READWRITE);
}

static unsigned eg_tile_split(unsigned tile_split)
{
    switch (tile_split) {
    case 0:     tile_split = 64;    break;
    case 1:     tile_split = 128;   break;
    case 2:     tile_split = 256;   break;
    case 3:     tile_split = 512;   break;
    default:
    case 4:     tile_split = 1024;  break;
    case 5:     tile_split = 2048;  break;
    case 6:     tile_split = 4096;  break;
    }
    return tile_split;
}

static unsigned eg_tile_split_rev(unsigned eg_tile_split)
{
    switch (eg_tile_split) {
    case 64:    return 0;
    case 128:   return 1;
    case 256:   return 2;
    case 512:   return 3;
    default:
    case 1024:  return 4;
    case 2048:  return 5;
    case 4096:  return 6;
    }
}

static void radeon_bo_get_metadata(struct pb_buffer *_buf,
				   struct radeon_bo_metadata *md)
{
    struct radeon_bo *bo = radeon_bo(_buf);
    struct drm_radeon_gem_set_tiling args;

    memset(&args, 0, sizeof(args));

    args.handle = bo->handle;

    drmCommandWriteRead(bo->rws->fd,
                        DRM_RADEON_GEM_GET_TILING,
                        &args,
                        sizeof(args));

    md->microtile = RADEON_LAYOUT_LINEAR;
    md->macrotile = RADEON_LAYOUT_LINEAR;
    if (args.tiling_flags & RADEON_TILING_MICRO)
        md->microtile = RADEON_LAYOUT_TILED;
    else if (args.tiling_flags & RADEON_TILING_MICRO_SQUARE)
        md->microtile = RADEON_LAYOUT_SQUARETILED;

    if (args.tiling_flags & RADEON_TILING_MACRO)
        md->macrotile = RADEON_LAYOUT_TILED;

    md->bankw = (args.tiling_flags >> RADEON_TILING_EG_BANKW_SHIFT) & RADEON_TILING_EG_BANKW_MASK;
    md->bankh = (args.tiling_flags >> RADEON_TILING_EG_BANKH_SHIFT) & RADEON_TILING_EG_BANKH_MASK;
    md->tile_split = (args.tiling_flags >> RADEON_TILING_EG_TILE_SPLIT_SHIFT) & RADEON_TILING_EG_TILE_SPLIT_MASK;
    md->mtilea = (args.tiling_flags >> RADEON_TILING_EG_MACRO_TILE_ASPECT_SHIFT) & RADEON_TILING_EG_MACRO_TILE_ASPECT_MASK;
    md->tile_split = eg_tile_split(md->tile_split);
    md->scanout = bo->rws->gen >= DRV_SI && !(args.tiling_flags & RADEON_TILING_R600_NO_SCANOUT);
}

static void radeon_bo_set_metadata(struct pb_buffer *_buf,
                                   struct radeon_bo_metadata *md)
{
    struct radeon_bo *bo = radeon_bo(_buf);
    struct drm_radeon_gem_set_tiling args;

    memset(&args, 0, sizeof(args));

    os_wait_until_zero(&bo->num_active_ioctls, PIPE_TIMEOUT_INFINITE);

    if (md->microtile == RADEON_LAYOUT_TILED)
        args.tiling_flags |= RADEON_TILING_MICRO;
    else if (md->microtile == RADEON_LAYOUT_SQUARETILED)
        args.tiling_flags |= RADEON_TILING_MICRO_SQUARE;

    if (md->macrotile == RADEON_LAYOUT_TILED)
        args.tiling_flags |= RADEON_TILING_MACRO;

    args.tiling_flags |= (md->bankw & RADEON_TILING_EG_BANKW_MASK) <<
        RADEON_TILING_EG_BANKW_SHIFT;
    args.tiling_flags |= (md->bankh & RADEON_TILING_EG_BANKH_MASK) <<
        RADEON_TILING_EG_BANKH_SHIFT;
    if (md->tile_split) {
	args.tiling_flags |= (eg_tile_split_rev(md->tile_split) &
			      RADEON_TILING_EG_TILE_SPLIT_MASK) <<
	    RADEON_TILING_EG_TILE_SPLIT_SHIFT;
    }
    args.tiling_flags |= (md->mtilea & RADEON_TILING_EG_MACRO_TILE_ASPECT_MASK) <<
        RADEON_TILING_EG_MACRO_TILE_ASPECT_SHIFT;

    if (bo->rws->gen >= DRV_SI && !md->scanout)
        args.tiling_flags |= RADEON_TILING_R600_NO_SCANOUT;

    args.handle = bo->handle;
    args.pitch = md->stride;

    drmCommandWriteRead(bo->rws->fd,
                        DRM_RADEON_GEM_SET_TILING,
                        &args,
                        sizeof(args));
}

static struct pb_buffer *
radeon_winsys_bo_create(struct radeon_winsys *rws,
                        uint64_t size,
                        unsigned alignment,
                        enum radeon_bo_domain domain,
                        enum radeon_bo_flag flags)
{
    struct radeon_drm_winsys *ws = radeon_drm_winsys(rws);
    struct radeon_bo *bo;
    unsigned usage = 0, pb_cache_bucket;

    /* Only 32-bit sizes are supported. */
    if (size > UINT_MAX)
        return NULL;

    /* Align size to page size. This is the minimum alignment for normal
     * BOs. Aligning this here helps the cached bufmgr. Especially small BOs,
     * like constant/uniform buffers, can benefit from better and more reuse.
     */
    size = align(size, ws->info.gart_page_size);
    alignment = align(alignment, ws->info.gart_page_size);

    /* Only set one usage bit each for domains and flags, or the cache manager
     * might consider different sets of domains / flags compatible
     */
    if (domain == RADEON_DOMAIN_VRAM_GTT)
        usage = 1 << 2;
    else
        usage = (unsigned)domain >> 1;
    assert(flags < sizeof(usage) * 8 - 3);
    usage |= 1 << (flags + 3);

    /* Determine the pb_cache bucket for minimizing pb_cache misses. */
    pb_cache_bucket = 0;
    if (size <= 4096) /* small buffers */
       pb_cache_bucket += 1;
    if (domain & RADEON_DOMAIN_VRAM) /* VRAM or VRAM+GTT */
       pb_cache_bucket += 2;
    if (flags == RADEON_FLAG_GTT_WC) /* WC */
       pb_cache_bucket += 4;
    assert(pb_cache_bucket < ARRAY_SIZE(ws->bo_cache.buckets));

    bo = radeon_bo(pb_cache_reclaim_buffer(&ws->bo_cache, size, alignment,
                                           usage, pb_cache_bucket));
    if (bo)
        return &bo->base;

    bo = radeon_create_bo(ws, size, alignment, usage, domain, flags,
                          pb_cache_bucket);
    if (!bo) {
        /* Clear the cache and try again. */
        pb_cache_release_all_buffers(&ws->bo_cache);
        bo = radeon_create_bo(ws, size, alignment, usage, domain, flags,
                              pb_cache_bucket);
        if (!bo)
            return NULL;
    }

    bo->use_reusable_pool = true;

    pipe_mutex_lock(ws->bo_handles_mutex);
    util_hash_table_set(ws->bo_handles, (void*)(uintptr_t)bo->handle, bo);
    pipe_mutex_unlock(ws->bo_handles_mutex);

    return &bo->base;
}

static struct pb_buffer *radeon_winsys_bo_from_ptr(struct radeon_winsys *rws,
                                                   void *pointer, uint64_t size)
{
    struct radeon_drm_winsys *ws = radeon_drm_winsys(rws);
    struct drm_radeon_gem_userptr args;
    struct radeon_bo *bo;
    int r;

    bo = CALLOC_STRUCT(radeon_bo);
    if (!bo)
        return NULL;

    memset(&args, 0, sizeof(args));
    args.addr = (uintptr_t)pointer;
    args.size = align(size, ws->info.gart_page_size);
    args.flags = RADEON_GEM_USERPTR_ANONONLY |
        RADEON_GEM_USERPTR_VALIDATE |
        RADEON_GEM_USERPTR_REGISTER;
    if (drmCommandWriteRead(ws->fd, DRM_RADEON_GEM_USERPTR,
                            &args, sizeof(args))) {
        FREE(bo);
        return NULL;
    }

    pipe_mutex_lock(ws->bo_handles_mutex);

    /* Initialize it. */
    pipe_reference_init(&bo->base.reference, 1);
    bo->handle = args.handle;
    bo->base.alignment = 0;
    bo->base.size = size;
    bo->base.vtbl = &radeon_bo_vtbl;
    bo->rws = ws;
    bo->user_ptr = pointer;
    bo->va = 0;
    bo->initial_domain = RADEON_DOMAIN_GTT;
    pipe_mutex_init(bo->map_mutex);

    util_hash_table_set(ws->bo_handles, (void*)(uintptr_t)bo->handle, bo);

    pipe_mutex_unlock(ws->bo_handles_mutex);

    if (ws->info.has_virtual_memory) {
        struct drm_radeon_gem_va va;

        bo->va = radeon_bomgr_find_va(ws, bo->base.size, 1 << 20);

        va.handle = bo->handle;
        va.operation = RADEON_VA_MAP;
        va.vm_id = 0;
        va.offset = bo->va;
        va.flags = RADEON_VM_PAGE_READABLE |
                   RADEON_VM_PAGE_WRITEABLE |
                   RADEON_VM_PAGE_SNOOPED;
        va.offset = bo->va;
        r = drmCommandWriteRead(ws->fd, DRM_RADEON_GEM_VA, &va, sizeof(va));
        if (r && va.operation == RADEON_VA_RESULT_ERROR) {
            fprintf(stderr, "radeon: Failed to assign virtual address space\n");
            radeon_bo_destroy(&bo->base);
            return NULL;
        }
        pipe_mutex_lock(ws->bo_handles_mutex);
        if (va.operation == RADEON_VA_RESULT_VA_EXIST) {
            struct pb_buffer *b = &bo->base;
            struct radeon_bo *old_bo =
                util_hash_table_get(ws->bo_vas, (void*)(uintptr_t)va.offset);

            pipe_mutex_unlock(ws->bo_handles_mutex);
            pb_reference(&b, &old_bo->base);
            return b;
        }

        util_hash_table_set(ws->bo_vas, (void*)(uintptr_t)bo->va, bo);
        pipe_mutex_unlock(ws->bo_handles_mutex);
    }

    ws->allocated_gtt += align(bo->base.size, ws->info.gart_page_size);

    return (struct pb_buffer*)bo;
}

static struct pb_buffer *radeon_winsys_bo_from_handle(struct radeon_winsys *rws,
                                                      struct winsys_handle *whandle,
                                                      unsigned *stride,
                                                      unsigned *offset)
{
    struct radeon_drm_winsys *ws = radeon_drm_winsys(rws);
    struct radeon_bo *bo;
    int r;
    unsigned handle;
    uint64_t size = 0;

    if (!offset && whandle->offset != 0) {
        fprintf(stderr, "attempt to import unsupported winsys offset %u\n",
                whandle->offset);
        return NULL;
    }

    /* We must maintain a list of pairs <handle, bo>, so that we always return
     * the same BO for one particular handle. If we didn't do that and created
     * more than one BO for the same handle and then relocated them in a CS,
     * we would hit a deadlock in the kernel.
     *
     * The list of pairs is guarded by a mutex, of course. */
    pipe_mutex_lock(ws->bo_handles_mutex);

    if (whandle->type == DRM_API_HANDLE_TYPE_SHARED) {
        /* First check if there already is an existing bo for the handle. */
        bo = util_hash_table_get(ws->bo_names, (void*)(uintptr_t)whandle->handle);
    } else if (whandle->type == DRM_API_HANDLE_TYPE_FD) {
        /* We must first get the GEM handle, as fds are unreliable keys */
        r = drmPrimeFDToHandle(ws->fd, whandle->handle, &handle);
        if (r)
            goto fail;
        bo = util_hash_table_get(ws->bo_handles, (void*)(uintptr_t)handle);
    } else {
        /* Unknown handle type */
        goto fail;
    }

    if (bo) {
        /* Increase the refcount. */
        struct pb_buffer *b = NULL;
        pb_reference(&b, &bo->base);
        goto done;
    }

    /* There isn't, create a new one. */
    bo = CALLOC_STRUCT(radeon_bo);
    if (!bo) {
        goto fail;
    }

    if (whandle->type == DRM_API_HANDLE_TYPE_SHARED) {
        struct drm_gem_open open_arg = {};
        memset(&open_arg, 0, sizeof(open_arg));
        /* Open the BO. */
        open_arg.name = whandle->handle;
        if (drmIoctl(ws->fd, DRM_IOCTL_GEM_OPEN, &open_arg)) {
            FREE(bo);
            goto fail;
        }
        handle = open_arg.handle;
        size = open_arg.size;
        bo->flink_name = whandle->handle;
    } else if (whandle->type == DRM_API_HANDLE_TYPE_FD) {
        size = lseek(whandle->handle, 0, SEEK_END);
        /* 
         * Could check errno to determine whether the kernel is new enough, but
         * it doesn't really matter why this failed, just that it failed.
         */
        if (size == (off_t)-1) {
            FREE(bo);
            goto fail;
        }
        lseek(whandle->handle, 0, SEEK_SET);
    }

    bo->handle = handle;

    /* Initialize it. */
    pipe_reference_init(&bo->base.reference, 1);
    bo->base.alignment = 0;
    bo->base.size = (unsigned) size;
    bo->base.vtbl = &radeon_bo_vtbl;
    bo->rws = ws;
    bo->va = 0;
    pipe_mutex_init(bo->map_mutex);

    if (bo->flink_name)
        util_hash_table_set(ws->bo_names, (void*)(uintptr_t)bo->flink_name, bo);

    util_hash_table_set(ws->bo_handles, (void*)(uintptr_t)bo->handle, bo);

done:
    pipe_mutex_unlock(ws->bo_handles_mutex);

    if (stride)
        *stride = whandle->stride;
    if (offset)
        *offset = whandle->offset;

    if (ws->info.has_virtual_memory && !bo->va) {
        struct drm_radeon_gem_va va;

        bo->va = radeon_bomgr_find_va(ws, bo->base.size, 1 << 20);

        va.handle = bo->handle;
        va.operation = RADEON_VA_MAP;
        va.vm_id = 0;
        va.offset = bo->va;
        va.flags = RADEON_VM_PAGE_READABLE |
                   RADEON_VM_PAGE_WRITEABLE |
                   RADEON_VM_PAGE_SNOOPED;
        va.offset = bo->va;
        r = drmCommandWriteRead(ws->fd, DRM_RADEON_GEM_VA, &va, sizeof(va));
        if (r && va.operation == RADEON_VA_RESULT_ERROR) {
            fprintf(stderr, "radeon: Failed to assign virtual address space\n");
            radeon_bo_destroy(&bo->base);
            return NULL;
        }
        pipe_mutex_lock(ws->bo_handles_mutex);
        if (va.operation == RADEON_VA_RESULT_VA_EXIST) {
            struct pb_buffer *b = &bo->base;
            struct radeon_bo *old_bo =
                util_hash_table_get(ws->bo_vas, (void*)(uintptr_t)va.offset);

            pipe_mutex_unlock(ws->bo_handles_mutex);
            pb_reference(&b, &old_bo->base);
            return b;
        }

        util_hash_table_set(ws->bo_vas, (void*)(uintptr_t)bo->va, bo);
        pipe_mutex_unlock(ws->bo_handles_mutex);
    }

    bo->initial_domain = radeon_bo_get_initial_domain((void*)bo);

    if (bo->initial_domain & RADEON_DOMAIN_VRAM)
        ws->allocated_vram += align(bo->base.size, ws->info.gart_page_size);
    else if (bo->initial_domain & RADEON_DOMAIN_GTT)
        ws->allocated_gtt += align(bo->base.size, ws->info.gart_page_size);

    return (struct pb_buffer*)bo;

fail:
    pipe_mutex_unlock(ws->bo_handles_mutex);
    return NULL;
}

static bool radeon_winsys_bo_get_handle(struct pb_buffer *buffer,
                                        unsigned stride, unsigned offset,
                                        unsigned slice_size,
                                        struct winsys_handle *whandle)
{
    struct drm_gem_flink flink;
    struct radeon_bo *bo = radeon_bo(buffer);
    struct radeon_drm_winsys *ws = bo->rws;

    memset(&flink, 0, sizeof(flink));

    bo->use_reusable_pool = false;

    if (whandle->type == DRM_API_HANDLE_TYPE_SHARED) {
        if (!bo->flink_name) {
            flink.handle = bo->handle;

            if (ioctl(ws->fd, DRM_IOCTL_GEM_FLINK, &flink)) {
                return false;
            }

            bo->flink_name = flink.name;

            pipe_mutex_lock(ws->bo_handles_mutex);
            util_hash_table_set(ws->bo_names, (void*)(uintptr_t)bo->flink_name, bo);
            pipe_mutex_unlock(ws->bo_handles_mutex);
        }
        whandle->handle = bo->flink_name;
    } else if (whandle->type == DRM_API_HANDLE_TYPE_KMS) {
        whandle->handle = bo->handle;
    } else if (whandle->type == DRM_API_HANDLE_TYPE_FD) {
        if (drmPrimeHandleToFD(ws->fd, bo->handle, DRM_CLOEXEC, (int*)&whandle->handle))
            return false;
    }

    whandle->stride = stride;
    whandle->offset = offset;
    whandle->offset += slice_size * whandle->layer;

    return true;
}

static bool radeon_winsys_bo_is_user_ptr(struct pb_buffer *buf)
{
   return ((struct radeon_bo*)buf)->user_ptr != NULL;
}

static uint64_t radeon_winsys_bo_va(struct pb_buffer *buf)
{
    return ((struct radeon_bo*)buf)->va;
}

void radeon_drm_bo_init_functions(struct radeon_drm_winsys *ws)
{
    ws->base.buffer_set_metadata = radeon_bo_set_metadata;
    ws->base.buffer_get_metadata = radeon_bo_get_metadata;
    ws->base.buffer_map = radeon_bo_map;
    ws->base.buffer_unmap = radeon_bo_unmap;
    ws->base.buffer_wait = radeon_bo_wait;
    ws->base.buffer_create = radeon_winsys_bo_create;
    ws->base.buffer_from_handle = radeon_winsys_bo_from_handle;
    ws->base.buffer_from_ptr = radeon_winsys_bo_from_ptr;
    ws->base.buffer_is_user_ptr = radeon_winsys_bo_is_user_ptr;
    ws->base.buffer_get_handle = radeon_winsys_bo_get_handle;
    ws->base.buffer_get_virtual_address = radeon_winsys_bo_va;
    ws->base.buffer_get_initial_domain = radeon_bo_get_initial_domain;
}
