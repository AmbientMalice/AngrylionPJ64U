#ifndef __Z64_H__
#define __Z64_H__

#include <stdio.h>

#if defined (_MSC_VER) && (_MSC_VER >= 1300)
#include <basetsd.h>
#endif

#if defined (_MSC_VER) && (_MSC_VER < 1300)
typedef unsigned char UINT8;
typedef signed short INT16;
typedef unsigned short UINT16;
#endif

#if !defined (_MSC_VER) || (_MSC_VER >= 1600)
#include <stdint.h>
typedef uint64_t UINT64;
typedef int64_t INT64;
typedef uint32_t UINT32;
typedef int32_t INT32;
typedef uint16_t UINT16;
typedef int16_t INT16;
typedef uint8_t UINT8;
typedef int8_t INT8;
#endif

#define SP_INTERRUPT    0x1
#define SI_INTERRUPT    0x2
#define AI_INTERRUPT    0x4
#define VI_INTERRUPT    0x8
#define PI_INTERRUPT    0x10
#define DP_INTERRUPT    0x20

#define SP_STATUS_HALT              0x00000001
#define SP_STATUS_BROKE             0x00000002
#define SP_STATUS_DMABUSY           0x00000004
#define SP_STATUS_DMAFULL           0x00000008
#define SP_STATUS_IOFULL            0x00000010
#define SP_STATUS_SSTEP             0x00000020
#define SP_STATUS_INTR_BREAK        0x00000040
#define SP_STATUS_SIGNAL0           0x00000080
#define SP_STATUS_SIGNAL1           0x00000100
#define SP_STATUS_SIGNAL2           0x00000200
#define SP_STATUS_SIGNAL3           0x00000400
#define SP_STATUS_SIGNAL4           0x00000800
#define SP_STATUS_SIGNAL5           0x00001000
#define SP_STATUS_SIGNAL6           0x00002000
#define SP_STATUS_SIGNAL7           0x00004000

#define DP_STATUS_XBUS_DMA          0x00000001
#define DP_STATUS_FREEZE            0x00000002
#define DP_STATUS_FLUSH             0x00000004
#define DP_STATUS_START_GCLK        0x00000008
#define DP_STATUS_TMEM_BUSY         0x00000010
#define DP_STATUS_PIPE_BUSY         0x00000020
#define DP_STATUS_CMD_BUSY          0x00000040
#define DP_STATUS_CBUF_READY        0x00000080
#define DP_STATUS_DMA_BUSY          0x00000100
#define DP_STATUS_END_VALID         0x00000200
#define DP_STATUS_START_VALID       0x00000400

#define R4300i_SP_Intr 1

#define LSB_FIRST 1 
#ifdef LSB_FIRST
    #define BYTE_ADDR_XOR        3
    #define WORD_ADDR_XOR        1
    #define BYTE4_XOR_BE(a)     ((a) ^ 3)                
#else
    #define BYTE_ADDR_XOR        0
    #define WORD_ADDR_XOR        0
    #define BYTE4_XOR_BE(a)     (a)
#endif

#ifdef LSB_FIRST
#define BYTE_XOR_DWORD_SWAP 7
#define WORD_XOR_DWORD_SWAP 3
#else
#define BYTE_XOR_DWORD_SWAP 4
#define WORD_XOR_DWORD_SWAP 2
#endif
#define DWORD_XOR_DWORD_SWAP 1

#ifdef _MSC_VER
#define STRICTINLINE    __forceinline
#else
#define STRICTINLINE    INLINE
#endif

#define PRESCALE_WIDTH 640
#define PRESCALE_HEIGHT 625

typedef unsigned int offs_t;

#define DRAM        GET_GFX_INFO(RDRAM)
#define DRAM16      ((i16 *)DRAM)
#define DRAM32      ((i32 *)DRAM)

#define SP_DMEM         GET_GFX_INFO(DMEM)
#define SP_IMEM         GET_GFX_INFO(IMEM)
#define SP_DMEM16       ((i16 *)SP_DMEM)
#define SP_IMEM16       ((i16 *)SP_IMEM)
#define SP_DMEM32       ((i32 *)SP_DMEM)
#define SP_IMEM32       ((i32 *)SP_IMEM)

#define rdram ((UINT32*)DRAM)

#if defined(USE_SSE_SUPPORT)
#define ZERO_MSB(word)    ((unsigned)(word) >> (8*sizeof(word) - 1))
#define SIGN_MSB(word)    ((signed)(word) >> (8*sizeof(word) - 1))
#define FULL_MSB(word)    SIGN_MSB(word)
#else
#define ZERO_MSB(word)    ((word < 0) ? +1 :  0)
#define SIGN_MSB(word)    ((word < 0) ? -1 :  0)
#define FULL_MSB(word)    ((word < 0) ? ~0 :  0)
#endif

#define GET_LOW(x)      (((x) & 0x003E) << 2)
#define GET_MED(x)      (((x) & 0x07C0) >> 3)
#define GET_HI(x)       (((x) >> 8) & 0x00F8)

#define RREADADDR8(in) \
    (((in) <= plim) ? (rdram_8[(in) ^ BYTE_ADDR_XOR]) : 0)
#define RREADIDX16(in) \
    (((in) <= idxlim16) ? (rdram_16[(in) ^ WORD_ADDR_XOR]) : 0)
#define RREADIDX32(in) \
    (((in) <= idxlim32) ? (rdram[(in)]) : 0)

#define RWRITEADDR8(in, val) { \
    if ((in) <= plim) rdram_8[(in) ^ BYTE_ADDR_XOR] = (val);}
#define RWRITEIDX16(in, val) { \
    if ((in) <= idxlim16) rdram_16[(in) ^ WORD_ADDR_XOR] = (val);}
#define RWRITEIDX32(in, val) { \
    if ((in) <= idxlim32) rdram[(in)] = (val);}

#define PAIRREAD16(rdst, hdst, in) {             \
    if ((in) <= idxlim16) {                      \
        (rdst) = rdram_16[(in) ^ WORD_ADDR_XOR]; \
        (hdst) = hidden_bits[(in)];              \
    } else                                       \
        (rdst) = (hdst) = 0;                     \
}
#define PAIRWRITE16(in, rval, hval) {            \
    if ((in) <= idxlim16) {                      \
        rdram_16[(in) ^ WORD_ADDR_XOR] = (rval); \
        hidden_bits[(in)] = (hval);              \
    }                                            \
}
#define PAIRWRITE32(in, rval, hval0, hval1) {    \
    if ((in) <= idxlim32) {                      \
        rdram[(in)] = (rval);                    \
        hidden_bits[(in) << 1] = (hval0);        \
        hidden_bits[((in) << 1) + 1] = (hval1);  \
    }                                            \
}
#define PAIRWRITE8(in, rval, hval) {             \
    if ((in) <= plim) {                          \
        rdram_8[(in) ^ BYTE_ADDR_XOR] = (rval);  \
        if ((in) & 1)                            \
            hidden_bits[(in) >> 1] = (hval);     \
    }                                            \
}

#define VI_ANDER(x) {                      \
    PAIRREAD16(pix, hidval, x);            \
    if ((pix & 1) + hidval != 4)           \
        { /* branch */ }                   \
    else {                                 \
        backr[n_full] = GET_HI(pix);       \
        backg[n_full] = GET_MED(pix);      \
        backb[n_full] = GET_LOW(pix);      \
        ++n_full;                          \
    }                                      \
}
#define VI_ANDER32(x) {                    \
    pix = RREADIDX32(x);                   \
    pixcvg = (pix >> 5) & 7;               \
    if (pixcvg != 7)                       \
        { /* branch */ }                   \
    else {                                 \
        backr[n_full] = (pix >> 24) & 0xFF;\
        backg[n_full] = (pix >> 16) & 0xFF;\
        backb[n_full] = (pix >>  8) & 0xFF;\
        ++n_full;                          \
    }                                      \
}
#define VI_COMPARE(x) {        \
    pix = RREADIDX16(x);       \
    tempr = (pix >> 11) & 31;  \
    tempg = (pix >>  6) & 31;  \
    tempb = (pix >>  1) & 31;  \
    rend += redptr[tempr];     \
    gend += greenptr[tempg];   \
    bend += blueptr[tempb];    \
}
#define VI_COMPARE_OPT(x) {            \
    pix = DRAM16[(x) ^ WORD_ADDR_XOR]; \
    tempr = (pix >> 11) & 31;          \
    tempg = (pix >> 6) & 31;           \
    tempb = (pix >> 1) & 31;           \
    rend += redptr[tempr];             \
    gend += greenptr[tempg];           \
    bend += blueptr[tempb];            \
}
#define VI_COMPARE32(x) {      \
    pix = RREADIDX32(x);       \
    tempr = (pix >> 27) & 31;  \
    tempg = (pix >> 19) & 31;  \
    tempb = (pix >> 11) & 31;  \
    rend += redptr[tempr];     \
    gend += greenptr[tempg];   \
    bend += blueptr[tempb];    \
}
#define VI_COMPARE32_OPT(x) {  \
    pix = DRAM32[(x)];         \
    tempr = (pix >> 27) & 31;  \
    tempg = (pix >> 19) & 31;  \
    tempb = (pix >> 11) & 31;  \
    rend += redptr[tempr];     \
    gend += greenptr[tempg];   \
    bend += blueptr[tempb];    \
}

#endif
