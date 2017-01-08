/****************************************************************************
* Copyright (C) 2014-2015 Intel Corporation.   All Rights Reserved.
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
****************************************************************************/

#ifndef __SWR_SIMD16INTRIN_H__
#define __SWR_SIMD16INTRIN_H__

#if ENABLE_AVX512_SIMD16

#if KNOB_SIMD16_WIDTH == 16

#if ENABLE_AVX512_EMULATION
struct simd16scalar
{
    __m256  lo;
    __m256  hi;
};
struct simd16scalard
{
    __m256d lo;
    __m256d hi;
};
struct simd16scalari
{
    __m256i lo;
    __m256i hi;
};
typedef uint16_t simd16mask;

#define _simd16_masklo(mask) ((mask) & 0xFF)
#define _simd16_maskhi(mask) (((mask) >> 8))
#define _simd16_setmask(hi, lo) (((hi) << 8) | (lo))

#else
typedef __m512 simd16scalar;
typedef __m512d simd16scalard;
typedef __m512i simd16scalari;
typedef __mmask16 simd16mask;
#endif//ENABLE_AVX512_EMULATION
#else
#error Unsupported vector width
#endif//KNOB_SIMD16_WIDTH == 16

OSALIGN(union, KNOB_SIMD16_BYTES) simd16vector
{
    simd16scalar  v[4];
    struct
    {
        simd16scalar x, y, z, w;
    };

    simd16scalar& operator[] (const int i) { return v[i]; }
    const simd16scalar& operator[] (const int i) const { return v[i]; }
};

#if ENABLE_AVX512_EMULATION

#define SIMD16_EMU_AVX512_0(type, func, intrin) \
INLINE type func()\
{\
    type result;\
\
    result.lo = intrin();\
    result.hi = intrin();\
\
    return result;\
}

#define SIMD16_EMU_AVX512_1(type, func, intrin) \
INLINE type func(type a)\
{\
    type result;\
\
    result.lo = intrin(a.lo);\
    result.hi = intrin(a.hi);\
\
    return result;\
}

#define SIMD16_EMU_AVX512_2(type, func, intrin) \
INLINE type func(type a, type b)\
{\
    type result;\
\
    result.lo = intrin(a.lo, b.lo);\
    result.hi = intrin(a.hi, b.hi);\
\
    return result;\
}

#define SIMD16_EMU_AVX512_3(type, func, intrin) \
INLINE type func(type a, type b, type c)\
{\
    type result;\
\
    result.lo = intrin(a.lo, b.lo, c.lo);\
    result.hi = intrin(a.hi, b.hi, c.hi);\
\
    return result;\
}

SIMD16_EMU_AVX512_0(simd16scalar, _simd16_setzero_ps, _mm256_setzero_ps)
SIMD16_EMU_AVX512_0(simd16scalari, _simd16_setzero_si, _mm256_setzero_si256)

INLINE simd16scalar _simd16_set1_ps(float a)
{
    simd16scalar result;

    result.lo = _mm256_set1_ps(a);
    result.hi = _mm256_set1_ps(a);

    return result;
}

INLINE simd16scalari _simd16_set1_epi8(char a)
{
    simd16scalari result;

    result.lo = _mm256_set1_epi8(a);
    result.hi = _mm256_set1_epi8(a);

    return result;
}

INLINE simd16scalari _simd16_set1_epi32(int a)
{
    simd16scalari result;

    result.lo = _mm256_set1_epi32(a);
    result.hi = _mm256_set1_epi32(a);

    return result;
}

INLINE simd16scalari _simd16_set_epi32(int e7, int e6, int e5, int e4, int e3, int e2, int e1, int e0)
{
    simd16scalari result;

    result.lo = _mm256_set_epi32(e7, e6, e5, e4, e3, e2, e1, e0);
    result.hi = _mm256_set_epi32(e7, e6, e5, e4, e3, e2, e1, e0);

    return result;
}

INLINE simd16scalari _simd16_set_epi32(int e15, int e14, int e13, int e12, int e11, int e10, int e9, int e8, int e7, int e6, int e5, int e4, int e3, int e2, int e1, int e0)
{
    simd16scalari result;

    result.lo = _mm256_set_epi32(e7, e6, e5, e4, e3, e2, e1, e0);
    result.hi = _mm256_set_epi32(e15, e14, e13, e12, e11, e10, e9, e8);

    return result;
}

INLINE simd16scalar _simd16_load_ps(float const *m)
{
    simd16scalar result;

    float const *n = reinterpret_cast<float const *>(reinterpret_cast<uint8_t const *>(m) + sizeof(result.lo));

    result.lo = _mm256_load_ps(m);
    result.hi = _mm256_load_ps(n);

    return result;
}

INLINE simd16scalar _simd16_loadu_ps(float const *m)
{
    simd16scalar result;

    float const *n = reinterpret_cast<float const *>(reinterpret_cast<uint8_t const *>(m) + sizeof(result.lo));

    result.lo = _mm256_loadu_ps(m);
    result.hi = _mm256_loadu_ps(n);

    return result;
}

INLINE simd16scalar _simd16_load1_ps(float const *m)
{
    simd16scalar result;

    result.lo = _mm256_broadcast_ss(m);
    result.hi = _mm256_broadcast_ss(m);

    return result;
}

INLINE simd16scalari _simd16_load_si(simd16scalari const *m)
{
    simd16scalari result;

    result.lo = _mm256_load_si256(&m[0].lo);
    result.hi = _mm256_load_si256(&m[0].hi);

    return result;
}

INLINE simd16scalari _simd16_loadu_si(simd16scalari const *m)
{
    simd16scalari result;

    result.lo = _mm256_loadu_si256(&m[0].lo);
    result.hi = _mm256_loadu_si256(&m[0].hi);

    return result;
}

INLINE simd16scalar _simd16_broadcast_ss(float const *m)
{
    simd16scalar result;

    result.lo = _mm256_broadcast_ss(m);
    result.hi = _mm256_broadcast_ss(m);

    return result;
}

INLINE simd16scalar _simd16_broadcast_ps(__m128 const *m)
{
    simd16scalar result;

    result.lo = _mm256_broadcast_ps(m);
    result.hi = _mm256_broadcast_ps(m);

    return result;
}

INLINE void _simd16_store_ps(float *m, simd16scalar a)
{
    float *n = reinterpret_cast<float *>(reinterpret_cast<uint8_t *>(m) + sizeof(a.lo));

    _mm256_store_ps(m, a.lo);
    _mm256_store_ps(n, a.hi);
}

INLINE void _simd16_maskstore_ps(float *m, simd16scalari mask, simd16scalar a)
{
    float *n = reinterpret_cast<float *>(reinterpret_cast<uint8_t *>(m) + sizeof(a.lo));

    _mm256_maskstore_ps(m, mask.lo, a.lo);
    _mm256_maskstore_ps(n, mask.hi, a.hi);
}

INLINE void _simd16_store_si(simd16scalari *m, simd16scalari a)
{
    _mm256_store_si256(&m[0].lo, a.lo);
    _mm256_store_si256(&m[0].hi, a.hi);
}

template <simd16mask mask>
INLINE simd16scalar _simd16_blend_ps_temp(simd16scalar a, simd16scalar b)
{
    simd16scalar result;

    result.lo = _mm256_blend_ps(a.lo, b.lo, _simd16_masklo(mask));
    result.hi = _mm256_blend_ps(a.hi, b.hi, _simd16_maskhi(mask));

    return result;
}

#define _simd16_blend_ps(a, b, mask) _simd16_blend_ps_temp<mask>(a, b)

SIMD16_EMU_AVX512_3(simd16scalar, _simd16_blendv_ps, _mm256_blendv_ps)

INLINE simd16scalari _simd16_blendv_epi32(simd16scalari a, simd16scalari b, const simd16scalar mask)
{
    simd16scalari result;

    result.lo = _mm256_castps_si256(_mm256_blendv_ps(_mm256_castsi256_ps(a.lo), _mm256_castsi256_ps(b.lo), mask.lo));
    result.hi = _mm256_castps_si256(_mm256_blendv_ps(_mm256_castsi256_ps(a.hi), _mm256_castsi256_ps(b.hi), mask.hi));

    return result;
}

INLINE simd16scalari _simd16_blendv_epi32(simd16scalari a, simd16scalari b, const simd16scalari mask)
{
    simd16scalari result;

    result.lo = _mm256_castps_si256(_mm256_blendv_ps(_mm256_castsi256_ps(a.lo), _mm256_castsi256_ps(b.lo), _mm256_castsi256_ps(mask.lo)));
    result.hi = _mm256_castps_si256(_mm256_blendv_ps(_mm256_castsi256_ps(a.hi), _mm256_castsi256_ps(b.hi), _mm256_castsi256_ps(mask.hi)));

    return result;
}

SIMD16_EMU_AVX512_2(simd16scalar, _simd16_mul_ps, _mm256_mul_ps)
SIMD16_EMU_AVX512_2(simd16scalar, _simd16_add_ps, _mm256_add_ps)
SIMD16_EMU_AVX512_2(simd16scalar, _simd16_sub_ps, _mm256_sub_ps)
SIMD16_EMU_AVX512_1(simd16scalar, _simd16_rsqrt_ps, _mm256_rsqrt_ps)
SIMD16_EMU_AVX512_2(simd16scalar, _simd16_min_ps, _mm256_min_ps)
SIMD16_EMU_AVX512_2(simd16scalar, _simd16_max_ps, _mm256_max_ps)

INLINE simd16mask _simd16_movemask_ps(simd16scalar a)
{
    simd16mask mask;

    reinterpret_cast<uint8_t *>(&mask)[0] = _mm256_movemask_ps(a.lo);
    reinterpret_cast<uint8_t *>(&mask)[1] = _mm256_movemask_ps(a.hi);

    return mask;
}

INLINE simd16mask _simd16_movemask_pd(simd16scalard a)
{
    simd16mask mask;

    reinterpret_cast<uint8_t *>(&mask)[0] = _mm256_movemask_pd(a.lo);
    reinterpret_cast<uint8_t *>(&mask)[1] = _mm256_movemask_pd(a.hi);

    return mask;
}

INLINE simd16mask _simd16_movemask_epi8(simd16scalari a)
{
    simd16mask mask;

    reinterpret_cast<uint8_t *>(&mask)[0] = _mm256_movemask_epi8(a.lo);
    reinterpret_cast<uint8_t *>(&mask)[1] = _mm256_movemask_epi8(a.hi);

    return mask;
}

INLINE simd16scalari _simd16_cvtps_epi32(simd16scalar a)
{
    simd16scalari result;

    result.lo = _mm256_cvtps_epi32(a.lo);
    result.hi = _mm256_cvtps_epi32(a.hi);

    return result;
}

INLINE simd16scalari _simd16_cvttps_epi32(simd16scalar a)
{
    simd16scalari result;

    result.lo = _mm256_cvttps_epi32(a.lo);
    result.hi = _mm256_cvttps_epi32(a.hi);

    return result;
}

INLINE simd16scalar _simd16_cvtepi32_ps(simd16scalari a)
{
    simd16scalar result;

    result.lo = _mm256_cvtepi32_ps(a.lo);
    result.hi = _mm256_cvtepi32_ps(a.hi);

    return result;
}

template <int comp>
INLINE simd16scalar _simd16_cmp_ps(simd16scalar a, simd16scalar b)
{
    simd16scalar result;

    result.lo = _mm256_cmp_ps(a.lo, b.lo, comp);
    result.hi = _mm256_cmp_ps(a.hi, b.hi, comp);

    return result;
}

#define _simd16_cmplt_ps(a, b) _simd16_cmp_ps<_CMP_LT_OQ>(a, b)
#define _simd16_cmpgt_ps(a, b) _simd16_cmp_ps<_CMP_GT_OQ>(a, b)
#define _simd16_cmpneq_ps(a, b) _simd16_cmp_ps<_CMP_NEQ_OQ>(a, b)
#define _simd16_cmpeq_ps(a, b) _simd16_cmp_ps<_CMP_EQ_OQ>(a, b)
#define _simd16_cmpge_ps(a, b) _simd16_cmp_ps<_CMP_GE_OQ>(a, b)
#define _simd16_cmple_ps(a, b) _simd16_cmp_ps<_CMP_LE_OQ>(a, b)

SIMD16_EMU_AVX512_2(simd16scalar, _simd16_and_ps, _mm256_and_ps)
SIMD16_EMU_AVX512_2(simd16scalar, _simd16_or_ps, _mm256_or_ps)
SIMD16_EMU_AVX512_1(simd16scalar, _simd16_rcp_ps, _mm256_rcp_ps)
SIMD16_EMU_AVX512_2(simd16scalar, _simd16_div_ps, _mm256_div_ps)

INLINE simd16scalar _simd16_castsi_ps(simd16scalari a)
{
    return *reinterpret_cast<simd16scalar *>(&a);
}

INLINE simd16scalari _simd16_castps_si(simd16scalar a)
{
    return *reinterpret_cast<simd16scalari *>(&a);
}

INLINE simd16scalard _simd16_castsi_pd(simd16scalari a)
{
    return *reinterpret_cast<simd16scalard *>(&a);
}

INLINE simd16scalari _simd16_castpd_si(simd16scalard a)
{
    return *reinterpret_cast<simd16scalari *>(&a);
}

INLINE simd16scalar _simd16_castpd_ps(simd16scalard a)
{
    return *reinterpret_cast<simd16scalar *>(&a);
}

INLINE simd16scalard _simd16_castps_pd(simd16scalar a)
{
    return *reinterpret_cast<simd16scalard *>(&a);
}

SIMD16_EMU_AVX512_2(simd16scalar, _simd16_andnot_ps, _mm256_andnot_ps)

template <int mode>
INLINE simd16scalar _simd16_round_ps_temp(simd16scalar a)
{
    simd16scalar result;

    result.lo = _mm256_round_ps(a.lo, mode);
    result.hi = _mm256_round_ps(a.hi, mode);

    return result;
}

#define _simd16_round_ps(a, mode) _simd16_round_ps_temp<mode>(a)

SIMD16_EMU_AVX512_2(simd16scalari, _simd16_mul_epi32, _mm256_mul_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_mullo_epi32, _mm256_mullo_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_sub_epi32, _mm256_sub_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_sub_epi64, _mm256_sub_epi64)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_min_epi32, _mm256_min_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_max_epi32, _mm256_max_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_min_epu32, _mm256_min_epu32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_max_epu32, _mm256_max_epu32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_add_epi32, _mm256_add_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_and_si, _mm256_and_si256)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_andnot_si, _mm256_andnot_si256)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_or_si, _mm256_or_si256)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_xor_si, _mm256_xor_si256)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_cmpeq_epi32, _mm256_cmpeq_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_cmpgt_epi32, _mm256_cmpgt_epi32)

INLINE int _simd16_testz_ps(simd16scalar a, simd16scalar b)
{
    int lo = _mm256_testz_ps(a.lo, b.lo);
    int hi = _mm256_testz_ps(a.hi, b.hi);

    return lo & hi;
}

#define _simd16_cmplt_epi32(a, b) _simd16_cmpgt_epi32(b, a)

SIMD16_EMU_AVX512_2(simd16scalari, _simd16_unpacklo_epi32, _mm256_unpacklo_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_unpackhi_epi32, _mm256_unpackhi_epi32)

template <int imm8>
INLINE simd16scalari _simd16_slli_epi32_temp(simd16scalari a)
{
    simd16scalari result;

    result.lo = _mm256_slli_epi32(a.lo, imm8);
    result.hi = _mm256_slli_epi32(a.hi, imm8);

    return result;
}

#define _simd16_slli_epi32(a, imm8) _simd16_slli_epi32_temp<imm8>(a)

template <int imm8>
INLINE simd16scalari _simd16_srai_epi32_temp(simd16scalari a)
{
    simd16scalari result;

    result.lo = _mm256_srai_epi32(a.lo, imm8);
    result.hi = _mm256_srai_epi32(a.hi, imm8);

    return result;
}

#define _simd16_srai_epi32(a, imm8) _simd16_srai_epi32_temp<imm8>(a)

template <int imm8>
INLINE simd16scalari _simd16_srli_epi32_temp(simd16scalari a)
{
    simd16scalari result;

    result.lo = _mm256_srli_epi32(a.lo, imm8);
    result.hi = _mm256_srli_epi32(a.hi, imm8);

    return result;
}

#define _simd16_srli_epi32(a, imm8) _simd16_srli_epi32_temp<imm8>(a)

SIMD16_EMU_AVX512_3(simd16scalar, _simd16_fmadd_ps, _mm256_fmadd_ps)
SIMD16_EMU_AVX512_3(simd16scalar, _simd16_fmsub_ps, _mm256_fmsub_ps)

SIMD16_EMU_AVX512_2(simd16scalari, _simd16_shuffle_epi8, _mm256_shuffle_epi8)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_adds_epu8, _mm256_adds_epu8)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_subs_epu8, _mm256_subs_epu8)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_add_epi8, _mm256_add_epi8)

template <int imm8>
INLINE simd16scalar _simd16_i32gather_ps_temp(float const *m, simd16scalari a)
{
    simd16scalar result;

    result.lo = _mm256_i32gather_ps(m, a.lo, imm8);
    result.hi = _mm256_i32gather_ps(m, a.hi, imm8);

    return result;
}

#define _simd16_i32gather_ps(m, a, imm8) _simd16_i32gather_ps_temp<imm8>(m, a)

SIMD16_EMU_AVX512_1(simd16scalari, _simd16_abs_epi32, _mm256_abs_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_cmpeq_epi64, _mm256_cmpeq_epi64)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_cmpgt_epi64, _mm256_cmpgt_epi64)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_cmpeq_epi16, _mm256_cmpeq_epi16)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_cmpgt_epi16, _mm256_cmpgt_epi16)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_cmpeq_epi8, _mm256_cmpeq_epi8)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_cmpgt_epi8, _mm256_cmpgt_epi8)

INLINE simd16scalar _simd16_permute_ps(simd16scalar a, simd16scalari b)
{
    simd16scalar result;

    result.lo = _mm256_permutevar8x32_ps(a.lo, b.lo);
    result.hi = _mm256_permutevar8x32_ps(a.hi, b.hi);

    return result;
}

SIMD16_EMU_AVX512_2(simd16scalari, _simd16_permute_epi32, _mm256_permutevar8x32_epi32)

SIMD16_EMU_AVX512_2(simd16scalari, _simd16_srlv_epi32, _mm256_srlv_epi32)
SIMD16_EMU_AVX512_2(simd16scalari, _simd16_sllv_epi32, _mm256_sllv_epi32)

template <int imm8>
INLINE simd16scalar _simd16_shuffle_ps_temp(simd16scalar a, simd16scalar b)
{
    simd16scalar result;

    result.lo = _mm256_shuffle_ps(a.lo, b.lo, imm8);
    result.hi = _mm256_shuffle_ps(a.hi, b.hi, imm8);

    return result;
}

#define _simd16_shuffle_ps(a, b, imm8) _simd16_shuffle_ps_temp<imm8>(a, b)

template <int imm8>
INLINE simd16scalari _simd16_permute_128_temp(simd16scalari a, simd16scalari b)
{
    simd16scalari result;

    result.lo = _mm256_permute2x128_si256(a.lo, b.lo, imm8);
    result.hi = _mm256_permute2x128_si256(a.hi, b.hi, imm8);

    return result;
}

#define _simd16_permute_128(a, b, imm8) _simd16_permute_128_temp<imm8>(a, b)

// convert bitmask to vector mask
INLINE simd16scalar vMask16(int32_t mask)
{
    simd16scalari temp = _simd16_set1_epi32(mask);

    simd16scalari bits = _simd16_set_epi32(0x8000, 0x4000, 0x2000, 0x1000, 0x0800, 0x0400, 0x0200, 0x0100, 0x0080, 0x0040, 0x0020, 0x0010, 0x0008, 0x0004, 0x0002, 0x0001);

    simd16scalari result = _simd16_cmplt_epi32(_simd16_setzero_si(), _simd16_and_si(temp, bits));

    return _simd16_castsi_ps(result);
}

#else

INLINE simd16mask _simd16_scalari2mask(simd16scalari mask)
{
    __m512i flag = _mm512_set1_epi32(0x80000000);

    __m512i temp = _mm512_and_epi32(mask, flag);

    return _mm512_cmpeq_epu32_mask(temp, flag);
}

#if 0
INLINE simd16mask _simd16_scalard2mask(simd16scalard mask)
{
    __m512i flag = _mm512_set1_epi64(0x8000000000000000);

    __m512 tempi = _mm512_and_epi64(_mm512_castpd_si512(mask), flag);

    return _mm512_cmpeq_epu64_mask(temp, flag);
}
#endif

#define _simd16_setzero_ps      _mm512_setzero_ps
#define _simd16_setzero_si      _mm512_setzero_si512
#define _simd16_set1_ps         _mm512_set1_ps
#define _simd16_set1_epi8       _mm512_set1_epi8
#define _simd16_set1_epi32      _mm512_set1_epi32

INLINE simd16scalari _simd16_set_epi32(int e7, int e6, int e5, int e4, int e3, int e2, int e1, int e0)
{
    simd16scalari result;

    result = _mm512_set_epi32(e7, e6, e5, e4, e3, e2, e1, e0, e7, e6, e5, e4, e3, e2, e1, e0);

    return result;
}

INLINE simd16scalari _simd16_set_epi32(int e15, int e14, int e13, int e12, int e11, int e10, int e9, int e8, int e7, int e6, int e5, int e4, int e3, int e2, int e1, int e0)
{
    simd16scalari result;

    result = _mm512_set_epi32(e15, e14, e13, e12, e11, e10, e9, e8, e7, e6, e5, e4, e3, e2, e1, e0);

    return result;
}

#define _simd16_load_ps         _mm512_load_ps
#define _simd16_loadu_ps        _mm512_loadu_ps
#if 1
#define _simd16_load1_ps        _simd16_broadcast_ss
#endif
#define _simd16_load_si         _mm256_load_si256
#define _simd16_loadu_si        _mm256_loadu_si256
#define _simd16_broadcast_ss(m) _mm512_extload_ps(m, _MM_UPCONV_PS_NONE, _MM_BROADCAST_1X16, 0)
#define _simd16_broadcast_ps(m) _mm512_extload_ps(m, _MM_UPCONV_PS_NONE, _MM_BROADCAST_4X16, 0)
#define _simd16_store_ps        _mm512_store_ps
#define _simd16_store_si        _mm512_store_si512

INLINE void _simd16_maskstore_ps(float *m, simd16scalari mask, simd16scalar a)
{
    simd16mask k = _simd16_scalari2mask(mask);

    _mm512_mask_store_ps(m, k, a);
}

#define _simd16_blend_ps(a, b, mask)    _mm512_mask_blend_ps(mask, a, b)

INLINE simd16scalar _simd16_blendv_ps(simd16scalar a, simd16scalar b, const simd16scalar mask)
{
    simd16mask k = _simd16_scalari2mask(_mm512_castps_si512(mask));

    _mm512_mask_blend_ps(k, a, b);
}

INLINE simd16scalari _simd16_blendv_epi32(simd16scalari a, simd16scalari b, const simd16scalar mask)
{
    simd16mask k = _simd16_scalari2mask(_mm512_castps_si512(mask));

    _mm512_mask_blend_epi32(k, a, b);
}

INLINE simd16scalari _simd16_blendv_epi32(simd16scalari a, simd16scalari b, const simd16scalari mask)
{
    simd16mask k = _simd16_scalari2mask(mask);

    _mm512_mask_blend_epi32(k, a, b);
}

#define _simd16_mul_ps          _mm512_mul_ps
#define _simd16_add_ps          _mm512_add_ps
#define _simd16_sub_ps          _mm512_sub_ps
#define _simd16_rsqrt_ps        _mm512_rsqrt23_ps
#define _simd16_min_ps          _mm512_min_ps
#define _simd16_max_ps          _mm512_max_ps

INLINE simd16mask _simd16_movemask_ps(simd16scalar a)
{
    return  _simd16_scalari2mask(_mm512_castps_si512(a));
}

#if 0
INLINE simd16mask _simd16_movemask_pd(simd16scalard a)
{
    return  _simd16_scalard2mask(_mm512i_castpd_si512(a));
}
#endif

#if 0
INLINE int _simd16_movemask_epi8(simd16scalari a)
{
    return  _simd16_scalar2mask(a);
}
#endif

#define _simd16_cvtps_epi32     _mm512_cvtps_epi32
#define _simd16_cvttps_epi32    _mm512_cvttps_epi32
#define _simd16_cvtepi32_ps     _mm512_cvtepi32_ps

template <int comp>
INLINE simd16scalar _simd16_cmp_ps_temp(simd16scalar a, simd16scalar b)
{
    simd16mask k = _mm512_cmpeq_ps_mask(a, b);

    return _mm512_castsi256_ps(_mm512_mask_blend_epi32(k, _mm512_setzero_epi32(), _mm512_set1_epi32(0xFFFFFFFF)));
}

#define _simd16_cmp_ps(a, b, comp)  _simd16_cmp_ps_temp<comp>(a, b)

#define _simd16_cmplt_ps(a, b)      _simd16_cmp_ps<_CMP_LT_OQ>(a, b)
#define _simd16_cmpgt_ps(a, b)      _simd16_cmp_ps<_CMP_GT_OQ>(a, b)
#define _simd16_cmpneq_ps(a, b)     _simd16_cmp_ps<_CMP_NEQ_OQ>(a, b)
#define _simd16_cmpeq_ps(a, b)      _simd16_cmp_ps<_CMP_EQ_OQ>(a, b)
#define _simd16_cmpge_ps(a, b)      _simd16_cmp_ps<_CMP_GE_OQ>(a, b)
#define _simd16_cmple_ps(a, b)      _simd16_cmp_ps<_CMP_LE_OQ>(a, b)

#define _simd16_castsi_ps           _mm512_castsi512_ps
#define _simd16_castps_si           _mm512_castps_si512
#define _simd16_castsi_pd           _mm512_castsi512_pd
#define _simd16_castpd_si           _mm512_castpd_si512
#define _simd16_castpd_ps           _mm512_castpd_ps
#define _simd16_castps_pd           _mm512_castps_pd

#define _simd16_andnot_ps           _mm512_andnot_ps

template <int mode>
INLINE simd16scalar _simd16_round_ps_temp(simd16scalar a)
{
    return _mm512_roundscale_ps(a, mode);
}

#define _simd16_round_ps(a, mode) _simd16_round_ps_temp<mode>(a)

#define _simd16_mul_epi32         _mm512_mul_epi32
#define _simd16_mullo_epi32       _mm512_mullo_epi32
#define _simd16_sub_epi32         _mm512_sub_epi32
#define _simd16_sub_epi64         _mm512_sub_epi64
#define _simd16_min_epi32         _mm512_min_epi32
#define _simd16_max_epi32         _mm512_max_epi32
#define _simd16_min_epu32         _mm512_min_epu32
#define _simd16_max_epu32         _mm512_max_epu32
#define _simd16_add_epi32         _mm512_add_epi32
#define _simd16_and_si            _mm512_and_si512
#define _simd16_andnot_si         _mm512_andnot_si512
#define _simd16_or_si             _mm512_or_si512
#define _simd16_xor_si            _mm512_xor_si512

INLINE simd16scalari _simd16_cmpeq_epi32(simd16scalari a, simd16scalari b)
{
    simd16mask k = _mm512_cmpeq_epi32_mask(a, b);

    return _mm512_mask_blend_epi32(k, _mm512_setzero_epi32(), _mm512_set1_epi32(0xFFFFFFFF));
}

INLINE simd16scalari _simd16_cmpgt_epi32(simd16scalari a, simd16scalari b)
{
    simd16mask k = _mm512_cmpgt_epi32_mask(a, b);

    return _mm512_mask_blend_epi32(k, _mm512_setzero_epi32(), _mm512_set1_epi32(0xFFFFFFFF));
}

INLINE simd16scalari _simd16_cmplt_epi32(simd16scalari a, simd16scalari b)
{
    simd16mask k = _mm512_cmplt_epi32_mask(a, b);

    return _mm512_mask_blend_epi32(k, _mm512_setzero_epi32(), _mm512_set1_epi32(0xFFFFFFFF));
}

#if 0
INLINE int _simd16_testz_ps(simd16scalar a, simd16scalar b)
{
    int lo = _mm256_testz_ps(a.lo, b.lo);
    int hi = _mm256_testz_ps(a.hi, b.hi);

    return lo & hi;
}

#endif

#define _simd16_unpacklo_epi32    _mm512_unpacklo_epi32
#define _simd16_unpackhi_epi32    _mm512_unpackhi_epi32
#define _simd16_slli_epi32        _mm512_slli_epi32
#define _simd16_srli_epi32        _mm512_srli_epi32
#define _simd16_srai_epi32        _mm512_srai_epi32
#define _simd16_fmadd_ps          _mm512_fmadd_ps
#define _simd16_fmsub_ps          _mm512_fmsub_ps
#define _simd16_adds_epu8         _mm512_adds_epu8
#define _simd16_subs_epu8         _mm512_subs_epu8
#define _simd16_add_epi8          _mm512_add_epi8
#define _simd16_shuffle_epi8      _mm512_shuffle_epi8

#define _simd16_i32gather_ps(m, index, scale) _mm512_i32gather_ps(index, m, scale)

#define _simd16_abs_epi32         _mm512_abs_epi32
#define _simd16_cmpeq_epi64       _mm512_abs_epi32

INLINE simd16scalari _simd16_cmpeq_epi64(simd16scalari a, simd16scalari b)
{
    __mmask8 k = _mm512_cmpeq_epi64_mask(a, b);

    return _mm512_mask_blend_epi64(k, _mm512_setzero_si512(), _mm512_set1_epi32(0xFFFFFFFF));
}

INLINE simd16scalari _simd16_cmpgt_epi64(simd16scalari a, simd16scalari b)
{
    __mmask8 k = _mm512_cmpgt_epi64_mask(a, b);

    return _mm512_mask_blend_epi64(k, _mm512_setzero_si512(), _mm512_set1_epi32(0xFFFFFFFF));
}

INLINE simd16scalari _simd16_cmpeq_epi16(simd16scalari a, simd16scalari b)
{
    __mmask32 k = _mm512_cmpeq_epi16_mask(a, b);

    return _mm512_mask_blend_epi16(k, _mm512_setzero_si512(), _mm512_set1_epi32(0xFFFFFFFF));
}

INLINE simd16scalari _simd16_cmpgt_epi16(simd16scalari a, simd16scalari b)
{
    __mmask32 k = _mm512_cmpgt_epi16_mask(a, b);

    return _mm512_mask_blend_epi16(k, _mm512_setzero_si512(), _mm512_set1_epi32(0xFFFFFFFF));
}

INLINE simd16scalari _simd16_cmpeq_epi8(simd16scalari a, simd16scalari b)
{
    __mmask64 k = _mm512_cmpeq_epi8_mask(a, b);

    return _mm512_mask_blend_epi8(k, _mm512_setzero_si512(), _mm512_set1_epi32(0xFFFFFFFF));
}

INLINE simd16scalari _simd16_cmpgt_epi8(simd16scalari a, simd16scalari b)
{
    __mmask64 k = _mm512_cmpgt_epi8_mask(a, b);

    return _mm512_mask_blend_epi8(k, _mm512_setzero_si512(), _mm512_set1_epi32(0xFFFFFFFF));
}

#if 0
INLINE simd16scalar _simd16_permute_ps(simd16scalar a, simd16scalari b)
{
    simd16scalar result;

    result.lo = _mm256_permutevar8x32_ps(a.lo, b.lo);
    result.hi = _mm256_permutevar8x32_ps(a.hi, b.hi);

    return result;
}

INLINE (simd16scalari _simd16_permute_epi32(simd16scalari a, simd16scalari b)
{
    simd16scalar result;

    result.lo = _mm256_permutevar8x32_epi32(a.lo, b.lo);
    result.hi = _mm256_permutevar8x32_epi32(a.hi, b.hi);

    return result;
}

#endif

#define _simd16_sllv_epi32        _mm512_srlv_epi32
#define _simd16_srlv_epi32        _mm512_sllv_epi32
#define _simd16_shuffle_ps        _mm512_shuffle_ps
#define _simd16_permute_128       _mm512_permute4f128_epi32

// convert bitmask to vector mask
INLINE simd16scalar vMask16(int32_t mask)
{
    simd16scalari temp = _simd16_set1_epi32(mask);

    simd16scalari bits = _simd16_set_epi32(0x8000, 0x4000, 0x2000, 0x1000, 0x0800, 0x0400, 0x0200, 0x0100, 0x0080, 0x0040, 0x0020, 0x0010, 0x0008, 0x0004, 0x0002, 0x0001);

    simd16scalari result = _simd16_cmplt_epi32(_simd16_setzero_si(), _simd16_and_si(temp, bits));

    return _simd16_castsi_ps(result);
}

#endif//ENABLE_AVX512_EMULATION

#endif//ENABLE_AVX512_SIMD16

#endif//__SWR_SIMD16INTRIN_H_
