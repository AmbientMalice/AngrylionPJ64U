#include <stdarg.h>
#include "z64.h"
#include "gfx.h"
#include "tctables.h"
#include "vi.h"
#include "rdp.h"

extern GFX_INFO gfx;

int scfield;
int sckeepodd;

int ti_format;
int ti_size;
int ti_width;
UINT32 ti_address;

int fb_format;
int fb_size;
int fb_width;
UINT32 fb_address;
UINT32 zb_address;

UINT32 max_level;
INT32 min_level;
INT32 primitive_lod_frac;

UINT32 primitive_z;
UINT16 primitive_delta_z;

UINT32 fill_color;

INT32 *combiner_rgbsub_a_r[2];
INT32 *combiner_rgbsub_a_g[2];
INT32 *combiner_rgbsub_a_b[2];
INT32 *combiner_rgbsub_b_r[2];
INT32 *combiner_rgbsub_b_g[2];
INT32 *combiner_rgbsub_b_b[2];
INT32 *combiner_rgbmul_r[2];
INT32 *combiner_rgbmul_g[2];
INT32 *combiner_rgbmul_b[2];
INT32 *combiner_rgbadd_r[2];
INT32 *combiner_rgbadd_g[2];
INT32 *combiner_rgbadd_b[2];

INT32 *combiner_alphasub_a[2];
INT32 *combiner_alphasub_b[2];
INT32 *combiner_alphamul[2];
INT32 *combiner_alphaadd[2];

INT32 *blender1a_r[2];
INT32 *blender1a_g[2];
INT32 *blender1a_b[2];
INT32 *blender1b_a[2];
INT32 *blender2a_r[2];
INT32 *blender2a_g[2];
INT32 *blender2a_b[2];
INT32 *blender2b_a[2];

/*
 * YUV-to-RGB conversion matrix has 6 terms:  k0, k1, k2, k3, k4 and k5.
 * relevant to RDP "Set Convert" command
 */
i32 k_YUV_RGB[6];

TILE tile[8];

OTHER_MODES other_modes;

COLOR key_width;
COLOR key_scale;
COLOR key_center;
COLOR fog_color;
COLOR blend_color;
COLOR prim_color;
COLOR env_color;

int rdp_pipeline_crashed;

UINT32 z64gl_command;

RECTANGLE clip = {
    0, 0, 0x2000, 0x2000
};

void (*fbread1_ptr)(UINT32, UINT32*);
void (*fbread2_ptr)(UINT32, UINT32*);
void (*fbwrite_ptr)(UINT32, UINT32, UINT32, UINT32, UINT32, UINT32, UINT32);
void (*fbfill_ptr)(UINT32);

void (*fbread_func[4])(UINT32, UINT32*) = {
    fbread_4, fbread_8, fbread_16, fbread_32
};
void (*fbread2_func[4])(UINT32, UINT32*) = {
    fbread2_4, fbread2_8, fbread2_16, fbread2_32
};
void (*fbwrite_func[4])(
    UINT32, UINT32, UINT32, UINT32, UINT32, UINT32, UINT32) = {
    fbwrite_4, fbwrite_8, fbwrite_16, fbwrite_32
};
void (*fbfill_func[4])(UINT32) = {
    fbfill_4, fbfill_8, fbfill_16, fbfill_32
};

#undef  LOG_RDP_EXECUTION
#define DETAILED_LOGGING 0


FILE *rdp_exec;

extern FILE* zeldainfo;

UINT32 old_vi_origin = 0;
UINT32 oldhstart = 0;
UINT32 oldsomething = 0;
UINT32 double_stretch = 0;
int blshifta = 0, blshiftb = 0, pastblshifta = 0, pastblshiftb = 0;
INT32 iseed = 1;

SPAN span[1024];
u8 cvgbuf[1024];

i32 spans_d_rgba[4];
i32 spans_d_stwz[4];
u16 spans_dzpix;

i32 spans_d_rgba_dy[4];
i32 spans_cd_rgba[4];
int spans_cdz;

i32 spans_d_stwz_dy[4];

typedef struct
{
    UINT8 r, g, b;
} FBCOLOR;

typedef struct
{
    int tilenum;
    UINT16 xl, yl, xh, yh;        
    INT16 s, t;                    
    INT16 dsdx, dtdy;            
    UINT32 flip;    
} TEX_RECTANGLE;


#define CVG_CLAMP                0
#define CVG_WRAP                1
#define CVG_ZAP                    2
#define CVG_SAVE                3


#define ZMODE_OPAQUE            0
#define ZMODE_INTERPENETRATING    1
#define ZMODE_TRANSPARENT        2
#define ZMODE_DECAL                3

COLOR combined_color;
COLOR texel0_color;
COLOR texel1_color;
COLOR nexttexel_color;
COLOR shade_color;
static INT32 noise = 0;
static INT32 one_color = 0x100;
static INT32 zero_color = 0x00;

INT32 keyalpha;

static INT32 blenderone    = 0xff;

COLOR pixel_color;
COLOR inv_pixel_color;
COLOR blended_pixel_color;
COLOR memory_color;
COLOR pre_memory_color;

int oldscyl = 0;

UINT8 TMEM[0x1000]; 

#define tlut ((UINT16*)(&TMEM[0x800]))

#define PIXELS_TO_BYTES(pix, siz) (((pix) << (siz)) >> 1)

typedef struct{
    int startspan;
    int endspan;
    int preendspan;
    int nextspan;
    int midspan;
    int longspan;
    int onelessthanmid;
} SPANSIGS;

INLINE void fetch_texel(COLOR *color, int s, int t, UINT32 tilenum);
INLINE void fetch_texel_entlut(COLOR *color, int s, int t, UINT32 tilenum);
INLINE void fetch_texel_quadro(COLOR *color0, COLOR *color1, COLOR *color2, COLOR *color3, int s0, int s1, int t0, int t1, UINT32 tilenum);
INLINE void fetch_texel_entlut_quadro(COLOR *color0, COLOR *color1, COLOR *color2, COLOR *color3, int s0, int s1, int t0, int t1, UINT32 tilenum);
void loading_pipeline(int start, int end, int tilenum, int coord_quad, int ltlut);
void get_tmem_idx(int s, int t, UINT32 tilenum, UINT32* idx0, UINT32* idx1, UINT32* idx2, UINT32* idx3, UINT32* bit3flipped, UINT32* hibit);
void sort_tmem_idx(UINT32 *idx, UINT32 idxa, UINT32 idxb, UINT32 idxc, UINT32 idxd, UINT32 bankno);
void sort_tmem_shorts_lowhalf(UINT32* bindshort, UINT32 short0, UINT32 short1, UINT32 short2, UINT32 short3, UINT32 bankno);
void compute_color_index(UINT32* cidx, UINT32 readshort, UINT32 nybbleoffset, UINT32 tilenum);
void read_tmem_copy(int s, int s1, int s2, int s3, int t, UINT32 tilenum, UINT32* sortshort, int* hibits, int* lowbits);
void replicate_for_copy(UINT32* outbyte, UINT32 inshort, UINT32 nybbleoffset, UINT32 tilenum, UINT32 tformat, UINT32 tsize);
void fetch_qword_copy(UINT32* hidword, UINT32* lowdword, INT32 ssss, INT32 ssst, UINT32 tilenum);
void render_spans_1cycle_complete(int start, int end, int tilenum, int flip);
void render_spans_1cycle_notexel1(int start, int end, int tilenum, int flip);
void render_spans_1cycle_notex(int start, int end, int tilenum, int flip);
void render_spans_2cycle_complete(int start, int end, int tilenum, int flip);
void render_spans_2cycle_notexelnext(int start, int end, int tilenum, int flip);
void render_spans_2cycle_notexel1(int start, int end, int tilenum, int flip);
void render_spans_2cycle_notex(int start, int end, int tilenum, int flip);
STRICTINLINE void combiner_1cycle(int adseed, UINT32* curpixel_cvg);
STRICTINLINE void combiner_2cycle(int adseed, UINT32* curpixel_cvg);
STRICTINLINE int blender_1cycle(UINT32* fr, UINT32* fg, UINT32* fb, int dith, UINT32 blend_en, UINT32 prewrap, UINT32 curpixel_cvg, UINT32 curpixel_cvbit);
STRICTINLINE int blender_2cycle(UINT32* fr, UINT32* fg, UINT32* fb, int dith, UINT32 blend_en, UINT32 prewrap, UINT32 curpixel_cvg, UINT32 curpixel_cvbit);
STRICTINLINE void texture_pipeline_cycle(COLOR* TEX, COLOR* prev, INT32 SSS, INT32 SST, UINT32 tilenum, UINT32 cycle);
STRICTINLINE void tc_pipeline_copy(INT32* sss0, INT32* sss1, INT32* sss2, INT32* sss3, INT32* sst, int tilenum);
STRICTINLINE void tc_pipeline_load(INT32* sss, INT32* sst, int tilenum, int coord_quad);
STRICTINLINE void tcclamp_generic(INT32* S, INT32* T, INT32* SFRAC, INT32* TFRAC, INT32 maxs, INT32 maxt, INT32 num);
STRICTINLINE void tcclamp_cycle(INT32* S, INT32* T, INT32* SFRAC, INT32* TFRAC, INT32 maxs, INT32 maxt, INT32 num);
STRICTINLINE void tcclamp_cycle_light(INT32* S, INT32* T, INT32 maxs, INT32 maxt, INT32 num);
STRICTINLINE void tcshift_cycle(INT32* S, INT32* T, INT32* maxs, INT32* maxt, UINT32 num);
STRICTINLINE void tcshift_copy(INT32* S, INT32* T, UINT32 num);
INLINE void precalculate_everything(void);
STRICTINLINE int alpha_compare(INT32 comb_alpha);
STRICTINLINE INT32 color_combiner_equation(INT32 a, INT32 b, INT32 c, INT32 d);
STRICTINLINE INT32 alpha_combiner_equation(INT32 a, INT32 b, INT32 c, INT32 d);
STRICTINLINE void blender_equation_cycle0(int* r, int* g, int* b);
STRICTINLINE void blender_equation_cycle0_2(int* r, int* g, int* b);
STRICTINLINE void blender_equation_cycle1(int* r, int* g, int* b);
STRICTINLINE UINT32 rightcvghex(UINT32 x, UINT32 fmask); 
STRICTINLINE UINT32 leftcvghex(UINT32 x, UINT32 fmask);
STRICTINLINE void compute_cvg_noflip(INT32 scanline);
STRICTINLINE void compute_cvg_flip(INT32 scanline);
STRICTINLINE UINT32 z_decompress(UINT32 rawz);
STRICTINLINE UINT32 dz_decompress(UINT32 compresseddz);
STRICTINLINE UINT32 dz_compress(UINT32 value);
INLINE void z_build_com_table(void);
INLINE void precalc_cvmask_derivatives(void);
STRICTINLINE UINT16 decompress_cvmask_frombyte(UINT8 byte);
STRICTINLINE void lookup_cvmask_derivatives(UINT32 mask, UINT8* offx, UINT8* offy, UINT32* curpixel_cvg, UINT32* curpixel_cvbit);
STRICTINLINE void z_store(UINT32 zcurpixel, UINT32 z, int dzpixenc);
STRICTINLINE UINT32 z_compare(UINT32 zcurpixel, UINT32 sz, UINT16 dzpix, int dzpixenc, UINT32* blend_en, UINT32* prewrap, UINT32* curpixel_cvg, UINT32 curpixel_memcvg);
STRICTINLINE int finalize_spanalpha(
    UINT32 blend_en, UINT32 curpixel_cvg, UINT32 curpixel_memcvg);
STRICTINLINE INT32 CLIP(INT32 value,INT32 min,INT32 max);
INLINE void tcdiv_persp(INT32 ss, INT32 st, INT32 sw, INT32* sss, INT32* sst);
INLINE void tcdiv_nopersp(INT32 ss, INT32 st, INT32 sw, INT32* sss, INT32* sst);
STRICTINLINE void tclod_4x17_to_15(INT32 scurr, INT32 snext, INT32 tcurr, INT32 tnext, INT32 previous, INT32* lod);
STRICTINLINE void tclod_tcclamp(INT32* sss, INT32* sst);
STRICTINLINE void tclod_1cycle_current(INT32* sss, INT32* sst, INT32 nexts, INT32 nextt, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 scanline, INT32 prim_tile, INT32* t1, SPANSIGS* sigs);
STRICTINLINE void tclod_1cycle_current_simple(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 scanline, INT32 prim_tile, INT32* t1, SPANSIGS* sigs);
STRICTINLINE void tclod_1cycle_next(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 scanline, INT32 prim_tile, INT32* t1, SPANSIGS* sigs, INT32* prelodfrac);
STRICTINLINE void tclod_2cycle_current(INT32* sss, INT32* sst, INT32 nexts, INT32 nextt, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1, INT32* t2);
STRICTINLINE void tclod_2cycle_current_simple(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1, INT32* t2);
STRICTINLINE void tclod_2cycle_current_notexel1(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1);
STRICTINLINE void tclod_2cycle_next(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1, INT32* t2, INT32* prelodfrac);
STRICTINLINE void tclod_copy(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1);
STRICTINLINE void get_texel1_1cycle(INT32* s1, INT32* t1, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 scanline, SPANSIGS* sigs);
STRICTINLINE void get_nexttexel0_2cycle(INT32* s1, INT32* t1, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc);
INLINE void rgb_dither_complete(int* r, int* g, int* b, int dith);
INLINE void rgb_dither_nothing(int* r, int* g, int* b, int dith);
INLINE void get_dither_noise_complete(int x, int y, int* cdith, int* adith);
INLINE void get_dither_only(int x, int y, int* cdith, int* adith);
INLINE void get_dither_nothing(int x, int y, int* cdith, int* adith);
STRICTINLINE void rgbaz_correct_clip(int offx, int offy, int r, int g, int b, int a, int* z, UINT32 curpixel_cvg);
int IsBadPtrW32(void *ptr, UINT32 bytes);
UINT32 vi_integer_sqrt(UINT32 a);

STRICTINLINE void lodfrac_lodtile_signals(
    unsigned int lodclamp,
    INT32 lod,
    UINT32* l_tile,
    unsigned int* magnify,
    UINT32* distant
);

static INT32 lod_frac = 0;
UINT32 DebugMode = 0, DebugMode2 = 0;
int debugcolor = 0;
struct {UINT32 shift; UINT32 add;} z_dec_table[8] = {
     { 6, 0x00000 },
     { 5, 0x20000 },
     { 4, 0x30000 },
     { 3, 0x38000 },
     { 2, 0x3C000 },
     { 1, 0x3E000 },
     { 0, 0x3F000 },
     { 0, 0x3F800 },
};

static void (*get_dither_noise_func[3])(int, int, int*, int*) = 
{
    get_dither_noise_complete, get_dither_only, get_dither_nothing
};

static void (*rgb_dither_func[2])(int*, int*, int*, int) =
{
    rgb_dither_complete, rgb_dither_nothing
};

static void (*tcdiv_func[2])(INT32, INT32, INT32, INT32*, INT32*) =
{
    tcdiv_nopersp, tcdiv_persp
};

static void (*render_spans_1cycle_func[3])(int, int, int, int) =
{
    render_spans_1cycle_notex, render_spans_1cycle_notexel1, render_spans_1cycle_complete
};

static void (*render_spans_2cycle_func[4])(int, int, int, int) =
{
    render_spans_2cycle_notex, render_spans_2cycle_notexel1, render_spans_2cycle_notexelnext, render_spans_2cycle_complete
};

static void (*get_dither_noise_ptr)(int, int, int*, int*);
static void (*rgb_dither_ptr)(int*, int*, int*, int);
static void (*tcdiv_ptr)(INT32, INT32, INT32, INT32*, INT32*);
void (*render_spans_1cycle_ptr)(int, int, int, int);
void (*render_spans_2cycle_ptr)(int, int, int, int);

UINT16 z_com_table[0x40000];
UINT32 z_complete_dec_table[0x4000];
UINT8 replicated_rgba[32];
INT32 maskbits_table[16];
UINT32 special_9bit_clamptable[512];
INT32 special_9bit_exttable[512];
INT32 ge_two_table[128];
INT32 log2table[256];
INT32 tcdiv_table[0x8000];
UINT8 bldiv_hwaccurate_table[0x8000];
INT32 clamp_t_diff[8];
INT32 clamp_s_diff[8];
CVtcmaskDERIVATIVE cvarray[0x100];

UINT32 command_counter = 0;
int SaveLoaded = 0;

STRICTINLINE void tcmask(INT32* S, INT32* T, INT32 num);
STRICTINLINE void tcmask(INT32* S, INT32* T, INT32 num)
{
    INT32 wrap;
    
    

    if (tile[num].mask_s)
    {
        if (tile[num].ms)
        {
            wrap = *S >> tile[num].f.masksclamped;
            wrap &= 1;
            *S ^= (-wrap);
        }
        *S &= maskbits_table[tile[num].mask_s];
    }

    if (tile[num].mask_t)
    {
        if (tile[num].mt)
        {
            wrap = *T >> tile[num].f.masktclamped;
            wrap &= 1;
            *T ^= (-wrap);
        }
        
        *T &= maskbits_table[tile[num].mask_t];
    }
}


STRICTINLINE void tcmask_coupled(INT32* S, INT32* S1, INT32* T, INT32* T1, INT32 num);
STRICTINLINE void tcmask_coupled(INT32* S, INT32* S1, INT32* T, INT32* T1, INT32 num)
{
    INT32 wrap;
    INT32 maskbits; 
    INT32 wrapthreshold; 


    if (tile[num].mask_s)
    {
        if (tile[num].ms)
        {
            wrapthreshold = tile[num].f.masksclamped;

            wrap = (*S >> wrapthreshold) & 1;
            *S ^= (-wrap);

            wrap = (*S1 >> wrapthreshold) & 1;
            *S1 ^= (-wrap);
        }

        maskbits = maskbits_table[tile[num].mask_s];
        *S &= maskbits;
        *S1 &= maskbits;
    }

    if (tile[num].mask_t)
    {
        if (tile[num].mt)
        {
            wrapthreshold = tile[num].f.masktclamped;

            wrap = (*T >> wrapthreshold) & 1;
            *T ^= (-wrap);

            wrap = (*T1 >> wrapthreshold) & 1;
            *T1 ^= (-wrap);
        }
        maskbits = maskbits_table[tile[num].mask_t];
        *T &= maskbits;
        *T1 &= maskbits;
    }
}


STRICTINLINE void tcmask_copy(INT32* S, INT32* S1, INT32* S2, INT32* S3, INT32* T, INT32 num);
STRICTINLINE void tcmask_copy(INT32* S, INT32* S1, INT32* S2, INT32* S3, INT32* T, INT32 num)
{
    INT32 wrap;
    INT32 maskbits_s; 
    INT32 swrapthreshold; 

    if (tile[num].mask_s)
    {
        if (tile[num].ms)
        {
            swrapthreshold = tile[num].f.masksclamped;

            wrap = (*S >> swrapthreshold) & 1;
            *S ^= (-wrap);

            wrap = (*S1 >> swrapthreshold) & 1;
            *S1 ^= (-wrap);

            wrap = (*S2 >> swrapthreshold) & 1;
            *S2 ^= (-wrap);

            wrap = (*S3 >> swrapthreshold) & 1;
            *S3 ^= (-wrap);
        }

        maskbits_s = maskbits_table[tile[num].mask_s];
        *S &= maskbits_s;
        *S1 &= maskbits_s;
        *S2 &= maskbits_s;
        *S3 &= maskbits_s;
    }

    if (tile[num].mask_t)
    {
        if (tile[num].mt)
        {
            wrap = *T >> tile[num].f.masktclamped; 
            wrap &= 1;
            *T ^= (-wrap);
        }

        *T &= maskbits_table[tile[num].mask_t];
    }
}


STRICTINLINE void tcshift_cycle(INT32* S, INT32* T, INT32* maxs, INT32* maxt, UINT32 num)
{



    INT32 coord = *S;
    INT32 shifter = tile[num].shift_s;

    if (shifter < 11)
    {
        coord = SIGN16(coord);
        coord >>= shifter;
    }
    else
    {
        coord <<= (16 - shifter);
        coord = SIGN16(coord);
    }
    *S = coord; 

    

    
    *maxs = ((coord >> 3) >= tile[num].sh);
    
    

    coord = *T;
    shifter = tile[num].shift_t;

    if (shifter < 11)
    {
        coord = SIGN16(coord);
        coord >>= shifter;
    }
    else
    {
        coord <<= (16 - shifter);
        coord = SIGN16(coord);
    }
    *T = coord; 
    *maxt = ((coord >> 3) >= tile[num].th);
}    


STRICTINLINE void tcshift_copy(INT32* S, INT32* T, UINT32 num)
{
    INT32 coord = *S;
    INT32 shifter = tile[num].shift_s;

    if (shifter < 11)
    {
        coord = SIGN16(coord);
        coord >>= shifter;
    }
    else
    {
        coord <<= (16 - shifter);
        coord = SIGN16(coord);
    }
    *S = coord; 

    coord = *T;
    shifter = tile[num].shift_t;

    if (shifter < 11)
    {
        coord = SIGN16(coord);
        coord >>= shifter;
    }
    else
    {
        coord <<= (16 - shifter);
        coord = SIGN16(coord);
    }
    *T = coord; 
    
}


STRICTINLINE void tcclamp_cycle(INT32* S, INT32* T, INT32* SFRAC, INT32* TFRAC, INT32 maxs, INT32 maxt, INT32 num)
{

    INT32 locs = *S, loct = *T;
    if (tile[num].f.clampens)
    {
        if (!(locs & 0x10000))
        {
            if (!maxs)
                *S = (locs >> 5);
            else
            {
                *S = tile[num].f.clampdiffs;
                *SFRAC = 0;
            }
        }
        else
        {
            *S = 0;
            *SFRAC = 0;
        }
    }
    else
        *S = (locs >> 5);

    if (tile[num].f.clampent)
    {
        if (!(loct & 0x10000))
        {
            if (!maxt)
                *T = (loct >> 5);
            else
            {
                *T = tile[num].f.clampdifft;
                *TFRAC = 0;
            }
        }
        else
        {
            *T = 0;
            *TFRAC = 0;
        }
    }
    else
        *T = (loct >> 5);
}


STRICTINLINE void tcclamp_cycle_light(INT32* S, INT32* T, INT32 maxs, INT32 maxt, INT32 num)
{
    INT32 locs = *S, loct = *T;
    if (tile[num].f.clampens)
    {
        if (!(locs & 0x10000))
        {
            if (!maxs)
                *S = (locs >> 5);
            else
                *S = tile[num].f.clampdiffs;
        }
        else
            *S = 0;
    }
    else
        *S = (locs >> 5);

    if (tile[num].f.clampent)
    {
        if (!(loct & 0x10000))
        {
            if (!maxt)
                *T = (loct >> 5);
            else
                *T = tile[num].f.clampdifft;
        }
        else
            *T = 0;
    }
    else
        *T = (loct >> 5);
}

void rdp_init(void)
{
    register int i;

#ifdef LOG_RDP_EXECUTION
        rdp_exec = fopen("rdp_execute.txt", "wt");
#endif

    fbread1_ptr = fbread_func[0];
    fbread2_ptr = fbread2_func[0];
    fbwrite_ptr = fbwrite_func[0];
    fbfill_ptr = fbfill_func[0];
    get_dither_noise_ptr = get_dither_noise_func[0];
    rgb_dither_ptr = rgb_dither_func[0];
    tcdiv_ptr = tcdiv_func[0];
    render_spans_1cycle_ptr = render_spans_1cycle_func[2];
    render_spans_2cycle_ptr = render_spans_2cycle_func[1];

    combiner_rgbsub_a_r[0] = combiner_rgbsub_a_r[1] = &one_color;
    combiner_rgbsub_a_g[0] = combiner_rgbsub_a_g[1] = &one_color;
    combiner_rgbsub_a_b[0] = combiner_rgbsub_a_b[1] = &one_color;
    combiner_rgbsub_b_r[0] = combiner_rgbsub_b_r[1] = &one_color;
    combiner_rgbsub_b_g[0] = combiner_rgbsub_b_g[1] = &one_color;
    combiner_rgbsub_b_b[0] = combiner_rgbsub_b_b[1] = &one_color;
    combiner_rgbmul_r[0] = combiner_rgbmul_r[1] = &one_color;
    combiner_rgbmul_g[0] = combiner_rgbmul_g[1] = &one_color;
    combiner_rgbmul_b[0] = combiner_rgbmul_b[1] = &one_color;
    combiner_rgbadd_r[0] = combiner_rgbadd_r[1] = &one_color;
    combiner_rgbadd_g[0] = combiner_rgbadd_g[1] = &one_color;
    combiner_rgbadd_b[0] = combiner_rgbadd_b[1] = &one_color;

    combiner_alphasub_a[0] = combiner_alphasub_a[1] = &one_color;
    combiner_alphasub_b[0] = combiner_alphasub_b[1] = &one_color;
    combiner_alphamul[0] = combiner_alphamul[1] = &one_color;
    combiner_alphaadd[0] = combiner_alphaadd[1] = &one_color;

    SET_BLENDER_INPUT(0, 0, &blender1a_r[0], &blender1a_g[0], &blender1a_b[0],
                      &blender1b_a[0], 0, 0);
    SET_BLENDER_INPUT(0, 1, &blender2a_r[0], &blender2a_g[0], &blender2a_b[0],
                      &blender2b_a[0], 0, 0);
    SET_BLENDER_INPUT(1, 0, &blender1a_r[1], &blender1a_g[1], &blender1a_b[1],
                      &blender1b_a[1], 0, 0);
    SET_BLENDER_INPUT(1, 1, &blender2a_r[1], &blender2a_g[1], &blender2a_b[1],
                      &blender2b_a[1], 0, 0);
    other_modes.f.stalederivs = 1;

    memfill(TMEM, 0x00, 0x1000);
    memfill(tvfadeoutstate, 0x00, sizeof(tvfadeoutstate));
    memfill(hidden_bits, 0x03, sizeof(hidden_bits));
    memfill(tile, 0x00, sizeof(tile));

    for (i = 0; i < 8; i++)
    {
        calculate_tile_derivs(i);
        calculate_clamp_diffs(i);
    }

    memfill(&combined_color, 0x00, sizeof(COLOR));
    memfill(&prim_color, 0x00, sizeof(COLOR));
    memfill(&env_color, 0x00, sizeof(COLOR));
    memfill(&key_scale, 0x00, sizeof(COLOR));
    memfill(&key_center, 0x00, sizeof(COLOR));

    rdp_pipeline_crashed = 0;
    memfill(&onetimewarnings, 0x00, sizeof(onetimewarnings));

    precalculate_everything();

#ifdef WIN32
    if (IsBadPtrW32(&DRAM[0x3FFFF0], 16))
        DisplayError("Insufficient RDRAM installed.");
    else if (IsBadPtrW32(&DRAM[0x7FFFF0], 16))
        plim = 0x003FFFFFul;
    else if (IsBadPtrW32(&DRAM[0xFFFFF0], 16))
        plim = 0x007FFFFFul;
    else
        plim = 0x00FFFFFFul;
#else
    plim = 0x7FFFFF; /* The 8-MiB limit is more commonly useful or needed. */
#endif
    idxlim16 = (plim >> 1) & 0xFFFFFFul;
    idxlim32 = (plim >> 2) & 0xFFFFFFul;

    rdram_8 = (UINT8*)rdram;
    rdram_16 = (UINT16*)rdram;
    return;
}

INLINE void SET_SUBA_RGB_INPUT(INT32 **input_r, INT32 **input_g, INT32 **input_b, int code)
{
    switch (code & 0xf)
    {
        case 0:        *input_r = &combined_color.r;    *input_g = &combined_color.g;    *input_b = &combined_color.b;    break;
        case 1:        *input_r = &texel0_color.r;        *input_g = &texel0_color.g;        *input_b = &texel0_color.b;        break;
        case 2:        *input_r = &texel1_color.r;        *input_g = &texel1_color.g;        *input_b = &texel1_color.b;        break;
        case 3:        *input_r = &prim_color.r;        *input_g = &prim_color.g;        *input_b = &prim_color.b;        break;
        case 4:        *input_r = &shade_color.r;        *input_g = &shade_color.g;        *input_b = &shade_color.b;        break;
        case 5:        *input_r = &env_color.r;        *input_g = &env_color.g;        *input_b = &env_color.b;        break;
        case 6:        *input_r = &one_color;            *input_g = &one_color;            *input_b = &one_color;        break;
        case 7:        *input_r = &noise;                *input_g = &noise;                *input_b = &noise;                break;
        case 8: case 9: case 10: case 11: case 12: case 13: case 14: case 15:
        {
            *input_r = &zero_color;        *input_g = &zero_color;        *input_b = &zero_color;        break;
        }
    }
}

INLINE void SET_SUBB_RGB_INPUT(INT32 **input_r, INT32 **input_g, INT32 **input_b, int code)
{
    switch (code & 0xf)
    {
        case 0:        *input_r = &combined_color.r;    *input_g = &combined_color.g;    *input_b = &combined_color.b;    break;
        case 1:        *input_r = &texel0_color.r;        *input_g = &texel0_color.g;        *input_b = &texel0_color.b;        break;
        case 2:        *input_r = &texel1_color.r;        *input_g = &texel1_color.g;        *input_b = &texel1_color.b;        break;
        case 3:        *input_r = &prim_color.r;        *input_g = &prim_color.g;        *input_b = &prim_color.b;        break;
        case 4:        *input_r = &shade_color.r;        *input_g = &shade_color.g;        *input_b = &shade_color.b;        break;
        case 5:        *input_r = &env_color.r;        *input_g = &env_color.g;        *input_b = &env_color.b;        break;
        case 6:        *input_r = &key_center.r;        *input_g = &key_center.g;        *input_b = &key_center.b;        break;
        case 7:        *input_r = &k_YUV_RGB[4];        *input_g = &k_YUV_RGB[4];        *input_b = &k_YUV_RGB[4];        break;
        case 8: case 9: case 10: case 11: case 12: case 13: case 14: case 15:
        {
            *input_r = &zero_color;        *input_g = &zero_color;        *input_b = &zero_color;        break;
        }
    }
}

INLINE void SET_MUL_RGB_INPUT(INT32 **input_r, INT32 **input_g, INT32 **input_b, int code)
{
    switch (code & 0x1f)
    {
        case 0:        *input_r = &combined_color.r;    *input_g = &combined_color.g;    *input_b = &combined_color.b;    break;
        case 1:        *input_r = &texel0_color.r;        *input_g = &texel0_color.g;        *input_b = &texel0_color.b;        break;
        case 2:        *input_r = &texel1_color.r;        *input_g = &texel1_color.g;        *input_b = &texel1_color.b;        break;
        case 3:        *input_r = &prim_color.r;        *input_g = &prim_color.g;        *input_b = &prim_color.b;        break;
        case 4:        *input_r = &shade_color.r;        *input_g = &shade_color.g;        *input_b = &shade_color.b;        break;
        case 5:        *input_r = &env_color.r;        *input_g = &env_color.g;        *input_b = &env_color.b;        break;
        case 6:        *input_r = &key_scale.r;        *input_g = &key_scale.g;        *input_b = &key_scale.b;        break;
        case 7:        *input_r = &combined_color.a;    *input_g = &combined_color.a;    *input_b = &combined_color.a;    break;
        case 8:        *input_r = &texel0_color.a;        *input_g = &texel0_color.a;        *input_b = &texel0_color.a;        break;
        case 9:        *input_r = &texel1_color.a;        *input_g = &texel1_color.a;        *input_b = &texel1_color.a;        break;
        case 10:    *input_r = &prim_color.a;        *input_g = &prim_color.a;        *input_b = &prim_color.a;        break;
        case 11:    *input_r = &shade_color.a;        *input_g = &shade_color.a;        *input_b = &shade_color.a;        break;
        case 12:    *input_r = &env_color.a;        *input_g = &env_color.a;        *input_b = &env_color.a;        break;
        case 13:    *input_r = &lod_frac;            *input_g = &lod_frac;            *input_b = &lod_frac;            break;
        case 14:    *input_r = &primitive_lod_frac;    *input_g = &primitive_lod_frac;    *input_b = &primitive_lod_frac; break;
        case 15:    *input_r = &k_YUV_RGB[5];        *input_g = &k_YUV_RGB[5];        *input_b = &k_YUV_RGB[5];        break;
        case 16: case 17: case 18: case 19: case 20: case 21: case 22: case 23:
        case 24: case 25: case 26: case 27: case 28: case 29: case 30: case 31:
        {
            *input_r = &zero_color;        *input_g = &zero_color;        *input_b = &zero_color;        break;
        }
    }
}

INLINE void SET_ADD_RGB_INPUT(INT32 **input_r, INT32 **input_g, INT32 **input_b, int code)
{
    switch (code & 0x7)
    {
        case 0:        *input_r = &combined_color.r;    *input_g = &combined_color.g;    *input_b = &combined_color.b;    break;
        case 1:        *input_r = &texel0_color.r;        *input_g = &texel0_color.g;        *input_b = &texel0_color.b;        break;
        case 2:        *input_r = &texel1_color.r;        *input_g = &texel1_color.g;        *input_b = &texel1_color.b;        break;
        case 3:        *input_r = &prim_color.r;        *input_g = &prim_color.g;        *input_b = &prim_color.b;        break;
        case 4:        *input_r = &shade_color.r;        *input_g = &shade_color.g;        *input_b = &shade_color.b;        break;
        case 5:        *input_r = &env_color.r;        *input_g = &env_color.g;        *input_b = &env_color.b;        break;
        case 6:        *input_r = &one_color;            *input_g = &one_color;            *input_b = &one_color;            break;
        case 7:        *input_r = &zero_color;            *input_g = &zero_color;            *input_b = &zero_color;            break;
    }
}

INLINE void SET_SUB_ALPHA_INPUT(INT32 **input, int code)
{
    switch (code & 0x7)
    {
        case 0:        *input = &combined_color.a; break;
        case 1:        *input = &texel0_color.a; break;
        case 2:        *input = &texel1_color.a; break;
        case 3:        *input = &prim_color.a; break;
        case 4:        *input = &shade_color.a; break;
        case 5:        *input = &env_color.a; break;
        case 6:        *input = &one_color; break;
        case 7:        *input = &zero_color; break;
    }
}

INLINE void SET_MUL_ALPHA_INPUT(INT32 **input, int code)
{
    switch (code & 0x7)
    {
        case 0:        *input = &lod_frac; break;
        case 1:        *input = &texel0_color.a; break;
        case 2:        *input = &texel1_color.a; break;
        case 3:        *input = &prim_color.a; break;
        case 4:        *input = &shade_color.a; break;
        case 5:        *input = &env_color.a; break;
        case 6:        *input = &primitive_lod_frac; break;
        case 7:        *input = &zero_color; break;
    }
}

STRICTINLINE void combiner_1cycle(int adseed, UINT32* curpixel_cvg)
{
    INT32 redkey, greenkey, bluekey, temp;

    temp = 0;
    if (combiner_rgbmul_r[1] == &zero_color)
    {
        combined_color.r =
            ((special_9bit_exttable[*combiner_rgbadd_r[1]] << 8) + 0x80)
          & 0x0001FFFFUL;
        combined_color.g =
            ((special_9bit_exttable[*combiner_rgbadd_g[1]] << 8) + 0x80)
          & 0x0001FFFFUL;
        combined_color.b =
            ((special_9bit_exttable[*combiner_rgbadd_b[1]] << 8) + 0x80)
          & 0x0001FFFFUL;
    }
    else
    {
        combined_color.r = color_combiner_equation(
            *combiner_rgbsub_a_r[1],
            *combiner_rgbsub_b_r[1],
            *combiner_rgbmul_r[1],
            *combiner_rgbadd_r[1]
        );
        combined_color.g = color_combiner_equation(
            *combiner_rgbsub_a_g[1],
            *combiner_rgbsub_b_g[1],
            *combiner_rgbmul_g[1],
            *combiner_rgbadd_g[1]
        );
        combined_color.b = color_combiner_equation(
            *combiner_rgbsub_a_b[1],
            *combiner_rgbsub_b_b[1],
            *combiner_rgbmul_b[1],
            *combiner_rgbadd_b[1]
        );
    }
    if (combiner_alphamul[1] == &zero_color)
        combined_color.a = special_9bit_exttable[*combiner_alphaadd[1]] & 0x1FF;
    else
        combined_color.a =
            alpha_combiner_equation(
                *combiner_alphasub_a[1],
                *combiner_alphasub_b[1],
                *combiner_alphamul[1],
                *combiner_alphaadd[1]
            );

    pixel_color.a = special_9bit_clamptable[combined_color.a];
    if (pixel_color.a == 0xff)
        pixel_color.a = 0x100;

    if (!other_modes.key_en)
    {
        
        combined_color.r >>= 8;
        combined_color.g >>= 8;
        combined_color.b >>= 8;
        pixel_color.r = special_9bit_clamptable[combined_color.r];
        pixel_color.g = special_9bit_clamptable[combined_color.g];
        pixel_color.b = special_9bit_clamptable[combined_color.b];
    }
    else
    {
        redkey = combined_color.r;
        if (redkey >= 0)
            redkey = (key_width.r << 4) - redkey;
        else
            redkey = (key_width.r << 4) + redkey;
        greenkey = combined_color.g;
        if (greenkey >= 0)
            greenkey = (key_width.g << 4) - greenkey;
        else
            greenkey = (key_width.g << 4) + greenkey;
        bluekey = combined_color.b;
        if (bluekey >= 0)
            bluekey = (key_width.b << 4) - bluekey;
        else
            bluekey = (key_width.b << 4) + bluekey;
        keyalpha = (redkey < greenkey) ? redkey : greenkey;
        keyalpha = (bluekey < keyalpha) ? bluekey : keyalpha;
        keyalpha = CLIP(keyalpha, 0, 0xff);

        
        pixel_color.r = special_9bit_clamptable[*combiner_rgbsub_a_r[1]];
        pixel_color.g = special_9bit_clamptable[*combiner_rgbsub_a_g[1]];
        pixel_color.b = special_9bit_clamptable[*combiner_rgbsub_a_b[1]];

        
        combined_color.r >>= 8;
        combined_color.g >>= 8;
        combined_color.b >>= 8;
    }
    
    
    if (other_modes.cvg_times_alpha)
    {
        temp = (pixel_color.a * (*curpixel_cvg) + 4) >> 3;
        *curpixel_cvg = (temp >> 5) & 0xf;
    }

    if (!other_modes.alpha_cvg_select)
    {    
        if (!other_modes.key_en)
        {
            pixel_color.a += adseed;
            if (pixel_color.a & 0x100)
                pixel_color.a = 0xff;
        }
        else
            pixel_color.a = keyalpha;
    }
    else
    {
        if (other_modes.cvg_times_alpha)
            pixel_color.a = temp;
        else
            pixel_color.a = (*curpixel_cvg) << 5;
        if (pixel_color.a > 0xff)
            pixel_color.a = 0xff;
    }

    shade_color.a += adseed;
    if (shade_color.a & 0x100)
        shade_color.a = 0xff;
}

STRICTINLINE void combiner_2cycle(int adseed, UINT32* curpixel_cvg)
{
    INT32 redkey, greenkey, bluekey, temp;

    temp = 0;
    if (combiner_rgbmul_r[0] == &zero_color)
    {
        combined_color.r =
            ((special_9bit_exttable[*combiner_rgbadd_r[0]] << 8) + 0x80)
          & 0x0001FFFFUL;
        combined_color.g =
            ((special_9bit_exttable[*combiner_rgbadd_g[0]] << 8) + 0x80)
          & 0x0001FFFFUL;
        combined_color.b =
            ((special_9bit_exttable[*combiner_rgbadd_b[0]] << 8) + 0x80)
          & 0x0001FFFFUL;
    }
    else
    {
        combined_color.r =
            color_combiner_equation(
                *combiner_rgbsub_a_r[0],
                *combiner_rgbsub_b_r[0],
                *combiner_rgbmul_r[0],
                *combiner_rgbadd_r[0]
            );
        combined_color.g =
            color_combiner_equation(
                *combiner_rgbsub_a_g[0],
                *combiner_rgbsub_b_g[0],
                *combiner_rgbmul_g[0],
                *combiner_rgbadd_g[0]
            );
        combined_color.b =
            color_combiner_equation(
                *combiner_rgbsub_a_b[0],
                *combiner_rgbsub_b_b[0],
                *combiner_rgbmul_b[0],
                *combiner_rgbadd_b[0]
            );
    }
    if (combiner_alphamul[0] == &zero_color)
        combined_color.a = special_9bit_exttable[*combiner_alphaadd[0]] & 0x1FF;
    else
        combined_color.a =
            alpha_combiner_equation(
                *combiner_alphasub_a[0],
                *combiner_alphasub_b[0],
                *combiner_alphamul[0],
                *combiner_alphaadd[0]
            );

    combined_color.r >>= 8;
    combined_color.g >>= 8;
    combined_color.b >>= 8;

    
    texel0_color = texel1_color;
    texel1_color = nexttexel_color;

    if (combiner_rgbmul_r[1] == &zero_color)
    {
        combined_color.r =
            ((special_9bit_exttable[*combiner_rgbadd_r[1]] << 8) + 0x80)
          & 0x0001FFFFUL;
        combined_color.g =
            ((special_9bit_exttable[*combiner_rgbadd_g[1]] << 8) + 0x80)
          & 0x0001FFFFUL;
        combined_color.b =
            ((special_9bit_exttable[*combiner_rgbadd_b[1]] << 8) + 0x80)
          & 0x0001FFFFUL;
    }
    else
    {
        combined_color.r =
            color_combiner_equation(
                *combiner_rgbsub_a_r[1],
                *combiner_rgbsub_b_r[1],
                *combiner_rgbmul_r[1],
                *combiner_rgbadd_r[1]
            );
        combined_color.g =
            color_combiner_equation(
                *combiner_rgbsub_a_g[1],
                *combiner_rgbsub_b_g[1],
                *combiner_rgbmul_g[1],
                *combiner_rgbadd_g[1]
            );
        combined_color.b =
            color_combiner_equation(
                *combiner_rgbsub_a_b[1],
                *combiner_rgbsub_b_b[1],
                *combiner_rgbmul_b[1],
                *combiner_rgbadd_b[1]
            );
    }
    if (combiner_alphamul[1] == &zero_color)
        combined_color.a = special_9bit_exttable[*combiner_alphaadd[1]] & 0x1FF;
    else
        combined_color.a =
            alpha_combiner_equation(
                *combiner_alphasub_a[1],
                *combiner_alphasub_b[1],
                *combiner_alphamul[1],
                *combiner_alphaadd[1]
            );

    if (!other_modes.key_en)
    {
        
        combined_color.r >>= 8;
        combined_color.g >>= 8;
        combined_color.b >>= 8;

        pixel_color.r = special_9bit_clamptable[combined_color.r];
        pixel_color.g = special_9bit_clamptable[combined_color.g];
        pixel_color.b = special_9bit_clamptable[combined_color.b];
    }
    else
    {
        redkey = combined_color.r;
        if (redkey >= 0)
            redkey = (key_width.r << 4) - redkey;
        else
            redkey = (key_width.r << 4) + redkey;
        greenkey = combined_color.g;
        if (greenkey >= 0)
            greenkey = (key_width.g << 4) - greenkey;
        else
            greenkey = (key_width.g << 4) + greenkey;
        bluekey = combined_color.b;
        if (bluekey >= 0)
            bluekey = (key_width.b << 4) - bluekey;
        else
            bluekey = (key_width.b << 4) + bluekey;
        keyalpha = (redkey < greenkey) ? redkey : greenkey;
        keyalpha = (bluekey < keyalpha) ? bluekey : keyalpha;
        keyalpha = CLIP(keyalpha, 0, 0xff);

        pixel_color.r = special_9bit_clamptable[*combiner_rgbsub_a_r[1]];
        pixel_color.g = special_9bit_clamptable[*combiner_rgbsub_a_g[1]];
        pixel_color.b = special_9bit_clamptable[*combiner_rgbsub_a_b[1]];

        combined_color.r >>= 8;
        combined_color.g >>= 8;
        combined_color.b >>= 8;
    }
    
    pixel_color.a = special_9bit_clamptable[combined_color.a];
    if (pixel_color.a == 0xff)
        pixel_color.a = 0x100;

    
    if (other_modes.cvg_times_alpha)
    {
        temp = (pixel_color.a * (*curpixel_cvg) + 4) >> 3;
        *curpixel_cvg = (temp >> 5) & 0xf;
    }

    if (!other_modes.alpha_cvg_select)
    {
        if (!other_modes.key_en)
        {
            pixel_color.a += adseed;
            if (pixel_color.a & 0x100)
                pixel_color.a = 0xff;
        }
        else
            pixel_color.a = keyalpha;
    }
    else
    {
        if (other_modes.cvg_times_alpha)
            pixel_color.a = temp;
        else
            pixel_color.a = (*curpixel_cvg) << 5;
        if (pixel_color.a > 0xff)
            pixel_color.a = 0xff;
    }
    

    shade_color.a += adseed;
    if (shade_color.a & 0x100)
        shade_color.a = 0xff;
}

INLINE void precalculate_everything(void)
{
    int ps[9];
    UINT32 exponent;
    UINT32 mantissa;
    int temppoint, tempslope; 
    int normout;
    int wnorm;
    int shift, tlu_rcp;
    int d = 0, n = 0, temp = 0, res = 0, invd = 0, nbit = 0;
    int i = 0, k = 0;

    for (i = 0; i < 256; i++)
    {
        gamma_table[i] = vi_integer_sqrt(i << 6);
        gamma_table[i] <<= 1;
    }
    for (i = 0; i < 0x4000; i++)
    {
        gamma_dither_table[i] = vi_integer_sqrt(i);
        gamma_dither_table[i] <<= 1;
    }

    z_build_com_table();

    for (i = 0; i < 0x4000; i++)
    {
        exponent = (i >> 11) & 7;
        mantissa = i & 0x7ff;
        z_complete_dec_table[i] = ((mantissa << z_dec_table[exponent].shift) + z_dec_table[exponent].add) & 0x3ffff;
    }

    precalc_cvmask_derivatives();

    i = 0;
    log2table[0] = log2table[1] = 0;
    for (i = 2; i < 256; i++)
    {
        for (k = 7; k > 0; k--)
        {
            if((i >> k) & 1)
            {
                log2table[i] = k;
                break;
            }
        }
    }

    for (i = 0; i < 0x400; i++)
    {
        if (((i >> 5) & 0x1f) < (i & 0x1f))
            vi_restore_table[i] = 1;
        else if (((i >> 5) & 0x1f) > (i & 0x1f))
            vi_restore_table[i] = -1;
        else
            vi_restore_table[i] = 0;
    }

    for (i = 0; i < 32; i++)
        replicated_rgba[i] = (i << 3) | ((i >> 2) & 7); 

    maskbits_table[0] = 0x3ff;
    for (i = 1; i < 16; i++)
        maskbits_table[i] = ((UINT16)(0xffff) >> (16 - i)) & 0x3ff;

    for(i = 0; i < 0x200; i++)
    {
        switch((i >> 7) & 3)
        {
        case 0:
        case 1:
            special_9bit_clamptable[i] = i & 0xff;
            break;
        case 2:
            special_9bit_clamptable[i] = 0xff;
            break;
        case 3:
            special_9bit_clamptable[i] = 0;
            break;
        }
    }

    for(i = 0; i < 0x200; i++)
    {
        special_9bit_exttable[i] = ((i & 0x180) == 0x180) ? (i | ~0x1ff) : (i & 0x1ff);
    }

    for (i = 0; i < 0x8000; i++)
    {
        for (k = 1; k <= 14 && !((i << k) & 0x8000); k++) 
            ;
        shift = k - 1;
        normout = (i << shift) & 0x3fff;
        wnorm = (normout & 0xff) << 2;
        normout >>= 8;

        temppoint = norm_point_table[normout];
        tempslope = norm_slope_table[normout];

        tempslope = (tempslope | ~0x3ff) + 1;
        
        tlu_rcp = (((tempslope * wnorm) >> 10) + temppoint) & 0x7fff;
        
        tcdiv_table[i] = shift | (tlu_rcp << 4);
    }

    for (i = 0; i < 0x8000; i++)
    {
        res = 0;
        d = (i >> 11) & 0xf;
        n = i & 0x7ff;
        invd = (~d) & 0xf;

        temp = invd + (n >> 8) + 1;
        ps[0] = temp & 7;
        for (k = 0; k < 8; k++)
        {
            nbit = (n >> (7 - k)) & 1;
            if (res & (0x100 >> k))
                temp = invd + (ps[k] << 1) + nbit + 1;
            else
                temp = d + (ps[k] << 1) + nbit;
            ps[k + 1] = temp & 7;
            if (temp & 0x10)
                res |= (1 << (7 - k));
        }
        bldiv_hwaccurate_table[i] = res;
    }
    return;
}

INLINE void SET_BLENDER_INPUT(int cycle, int which, INT32 **input_r, INT32 **input_g, INT32 **input_b, INT32 **input_a, int a, int b)
{

    switch (a & 0x3)
    {
        case 0:
        {
            if (cycle == 0)
            {
                *input_r = &pixel_color.r;
                *input_g = &pixel_color.g;
                *input_b = &pixel_color.b;
            }
            else
            {
                *input_r = &blended_pixel_color.r;
                *input_g = &blended_pixel_color.g;
                *input_b = &blended_pixel_color.b;
            }
            break;
        }

        case 1:
        {
            *input_r = &memory_color.r;
            *input_g = &memory_color.g;
            *input_b = &memory_color.b;
            break;
        }

        case 2:
        {
            *input_r = &blend_color.r;        *input_g = &blend_color.g;        *input_b = &blend_color.b;
            break;
        }

        case 3:
        {
            *input_r = &fog_color.r;        *input_g = &fog_color.g;        *input_b = &fog_color.b;
            break;
        }
    }

    if (which == 0)
    {
        switch (b & 0x3)
        {
            case 0:        *input_a = &pixel_color.a; break;
            case 1:        *input_a = &fog_color.a; break;
            case 2:        *input_a = &shade_color.a; break;
            case 3:        *input_a = &zero_color; break;
        }
    }
    else
    {
        switch (b & 0x3)
        {
            case 0:        *input_a = &inv_pixel_color.a; break;
            case 1:        *input_a = &memory_color.a; break;
            case 2:        *input_a = &blenderone; break;
            case 3:        *input_a = &zero_color; break;
        }
    }
}

static unsigned char bayer_matrix[16] = {
    00, 04, 01, 05,
    04, 00, 05, 01,
    03, 07, 02, 06,
    07, 03, 06, 02
};
static unsigned char magic_matrix[16] = {
    00, 06, 01, 07,
    04, 02, 05, 03,
    03, 05, 02, 04,
    07, 01, 06, 00
};

STRICTINLINE int blender_1cycle(UINT32* fr, UINT32* fg, UINT32* fb, int dith, UINT32 blend_en, UINT32 prewrap, UINT32 curpixel_cvg, UINT32 curpixel_cvbit)
{
    int r, g, b, dontblend;
    
    
    if (alpha_compare(pixel_color.a))
    {

        

        
        
        
        if (other_modes.antialias_en ? (curpixel_cvg) : (curpixel_cvbit))
        {

            if (!other_modes.color_on_cvg || prewrap)
            {
                dontblend = (other_modes.f.partialreject_1cycle && pixel_color.a >= 0xff);
                if (!blend_en || dontblend)
                {
                    r = *blender1a_r[0];
                    g = *blender1a_g[0];
                    b = *blender1a_b[0];
                }
                else
                {
                    inv_pixel_color.a =  (~(*blender1b_a[0])) & 0xff;
                    
                    
                    
                    

                    blender_equation_cycle0(&r, &g, &b);
                }
            }
            else
            {
                r = *blender2a_r[0];
                g = *blender2a_g[0];
                b = *blender2a_b[0];
            }

            rgb_dither_ptr(&r, &g, &b, dith);
            *fr = r;
            *fg = g;
            *fb = b;
            return 1;
        }
        else 
            return 0;
        }
    else 
        return 0;
}

STRICTINLINE int blender_2cycle(UINT32* fr, UINT32* fg, UINT32* fb, int dith, UINT32 blend_en, UINT32 prewrap, UINT32 curpixel_cvg, UINT32 curpixel_cvbit)
{
    int r, g, b, dontblend;

    
    if (alpha_compare(pixel_color.a))
    {
        if (other_modes.antialias_en ? (curpixel_cvg) : (curpixel_cvbit))
        {
            
            inv_pixel_color.a =  (~(*blender1b_a[0])) & 0xff;

            blender_equation_cycle0_2(&r, &g, &b);

            
            memory_color = pre_memory_color;

            blended_pixel_color.r = r;
            blended_pixel_color.g = g;
            blended_pixel_color.b = b;
            blended_pixel_color.a = pixel_color.a;

            if (!other_modes.color_on_cvg || prewrap)
            {
                dontblend = (other_modes.f.partialreject_2cycle && pixel_color.a >= 0xff);
                if (!blend_en || dontblend)
                {
                    r = *blender1a_r[1];
                    g = *blender1a_g[1];
                    b = *blender1a_b[1];
                }
                else
                {
                    inv_pixel_color.a =  (~(*blender1b_a[1])) & 0xff;
                    blender_equation_cycle1(&r, &g, &b);
                }
            }
            else
            {
                r = *blender2a_r[1];
                g = *blender2a_g[1];
                b = *blender2a_b[1];
            }

            
            rgb_dither_ptr(&r, &g, &b, dith);
            *fr = r;
            *fg = g;
            *fb = b;
            return 1;
        }
        else 
            return 0;
    }
    else 
        return 0;
}

INLINE void fetch_texel(COLOR *color, int s, int t, UINT32 tilenum)
{
    UINT32 tbase = tile[tilenum].line * t + tile[tilenum].tmem;
    

    UINT32 tpal    = tile[tilenum].palette;

    
    
    
    
    
    
    
    UINT16 *tc16 = (UINT16*)TMEM;
    UINT32 taddr = 0;

    

    

    switch (tile[tilenum].f.notlutswitch)
    {
    case TEXEL_RGBA4:
        {
            UINT8 byteval, c; 
            taddr = ((tbase << 4) + s) >> 1;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);

            byteval = TMEM[taddr & 0xfff];
            c = ((s & 1)) ? (byteval & 0xf) : (byteval >> 4);
            c |= (c << 4);
            color->r = c;
            color->g = c;
            color->b = c;
            color->a = c;
        }
        break;
    case TEXEL_RGBA8:
        {
            UINT8 p;

            taddr = (tbase << 3) + s;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);

            p = TMEM[taddr & 0xfff];
            color->r = p;
            color->g = p;
            color->b = p;
            color->a = p;
        }
        break;
    case TEXEL_RGBA16:
        {         
            UINT16 c;

            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);

            c = tc16[taddr & 0x7ff];
            color->r = GET_HI_RGBA16_TMEM(c);
            color->g = GET_MED_RGBA16_TMEM(c);
            color->b = GET_LOW_RGBA16_TMEM(c);
            color->a = (c & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_RGBA32:
        {
            UINT16 c;

            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);

            taddr &= 0x3ff;
            c = tc16[taddr];
            color->r = c >> 8;
            color->g = c & 0xff;
            c = tc16[taddr | 0x400];
            color->b = c >> 8;
            color->a = c & 0xff;
        }
        break;
    case TEXEL_YUV4:
    case TEXEL_YUV8:
        {
            INT32 u, save;

            taddr  = (tbase << 3) + s;
            taddr ^= (t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            save = u = TMEM[taddr & 0x7FF];

            u = (u - 0x80) & 0x1FF;
            color->r = u;
            color->g = u;
            color->b = save;
            color->a = save;
        }
        break;
    case TEXEL_YUV16:
    case TEXEL_YUV32:
        {
            UINT16 c;
            INT32 y, u, v;
            int taddrlow;

            taddr = (tbase << 3) + s;
            taddrlow = taddr >> 1;

            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            taddrlow ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);
            taddr &= 0x7ff;
            taddrlow &= 0x3ff;
            c = tc16[taddrlow];
            y = TMEM[taddr | 0x800];
            u = c >> 8;
            v = c & 0xff;

            u = (u - 0x80) & 0x1FF;
            v = (v - 0x80) & 0x1FF;
            color->r = u;
            color->g = v;
            color->b = y;
            color->a = y;
        }
        break;
    case TEXEL_CI4:
        {
            UINT8 p;

            taddr = ((tbase << 4) + s) >> 1;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);

            p = TMEM[taddr & 0xfff];
            p = (s & 1) ? (p & 0xf) : (p >> 4);
            p = (tpal << 4) | p;
            color->r = color->g = color->b = color->a = p;
        }
        break;
    case TEXEL_CI8:
        {
            UINT8 p;

            taddr = (tbase << 3) + s;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);

            p = TMEM[taddr & 0xfff];
            color->r = p;
            color->g = p;
            color->b = p;
            color->a = p;
        }
        break;
    case TEXEL_CI16:
        {         
            UINT16 c;

            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);

            c = tc16[taddr & 0x7ff];
            color->r = c >> 8;
            color->g = c & 0xff;
            color->b = color->r;
            color->a = (c & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_CI32:
        {
            UINT16 c;

            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);
            c = tc16[taddr & 0x7ff];
            color->r = c >> 8;
            color->g = c & 0xff;
            color->b = color->r;
            color->a = (c & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_IA4:
        {
            UINT8 p, i;

            taddr = ((tbase << 4) + s) >> 1;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            p = TMEM[taddr & 0xfff];
            p = (s & 1) ? (p & 0xf) : (p >> 4);
            i = p & 0xe;
            i = (i << 4) | (i << 1) | (i >> 2);
            color->r = i;
            color->g = i;
            color->b = i;
            color->a = (p & 0x1) ? 0xff : 0;
        }
        break;
    case TEXEL_IA8:
        {
            UINT8 p, i;

            taddr = (tbase << 3) + s;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            p = TMEM[taddr & 0xfff];
            i = p & 0xf0;
            i |= (i >> 4);
            color->r = i;
            color->g = i;
            color->b = i;
            color->a = ((p & 0xf) << 4) | (p & 0xf);
        }
        break;
    case TEXEL_IA16:
        {
            UINT16 c;

            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);                         
            c = tc16[taddr & 0x7ff];
            color->r = color->g = color->b = (c >> 8);
            color->a = c & 0xff;
        }
        break;
    case TEXEL_IA32:
        {
            UINT16 c;

            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);
            c = tc16[taddr & 0x7ff];
            color->r = c >> 8;
            color->g = c & 0xff;
            color->b = color->r;
            color->a = (c & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_I4:
        {
            UINT8 byteval, c;

            taddr = ((tbase << 4) + s) >> 1;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            byteval = TMEM[taddr & 0xfff];
            c = (s & 1) ? (byteval & 0xf) : (byteval >> 4);
            c |= (c << 4);
            color->r = c;
            color->g = c;
            color->b = c;
            color->a = c;
        }
        break;
    case TEXEL_I8:
        {
            UINT8 c;

            taddr = (tbase << 3) + s;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            c = TMEM[taddr & 0xfff];
            color->r = c;
            color->g = c;
            color->b = c;
            color->a = c;
        }
        break;
    case TEXEL_I16:
        {        
            UINT16 c;

            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);    
            c = tc16[taddr & 0x7ff];
            color->r = c >> 8;
            color->g = c & 0xff;
            color->b = color->r;
            color->a = (c & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_I32:
        {
            UINT16 c;

            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);   
            c = tc16[taddr & 0x7ff];
            color->r = c >> 8;
            color->g = c & 0xff;
            color->b = color->r;
            color->a = (c & 1) ? 0xff : 0;
        }
        break;
    }
}

INLINE void fetch_texel_entlut(COLOR *color, int s, int t, UINT32 tilenum)
{
    UINT32 tbase = tile[tilenum].line * t + tile[tilenum].tmem;
    UINT32 tpal    = tile[tilenum].palette << 4;
    UINT16 *tc16 = (UINT16*)TMEM;
    UINT32 taddr = 0;
    UINT32 c;

    c = 0;
    switch (tile[tilenum].f.tlutswitch & 0xF)
    {
    case 0:
    case 1:
    case 2:
        {
            taddr = ((tbase << 4) + s) >> 1;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            c = TMEM[taddr & 0x7ff];
            c = (s & 1) ? (c & 0xf) : (c >> 4);
            c = tlut[((tpal | c) << 2) ^ WORD_ADDR_XOR];
        }
        break;
    case 3:
        {
            taddr = (tbase << 3) + s;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            c = TMEM[taddr & 0x7ff];
            c = (s & 1) ? (c & 0xf) : (c >> 4);
            c = tlut[((tpal | c) << 2) ^ WORD_ADDR_XOR];
        }
        break;
    case 4:
    case 5:
    case 6:
    case 7:
        {
            taddr = (tbase << 3) + s;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            c = TMEM[taddr & 0x7ff];
            c = tlut[(c << 2) ^ WORD_ADDR_XOR];
        }
        break;
    case 8:
    case 9:
    case 10:
        {
            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);
            c = tc16[taddr & 0x3ff];
            c = tlut[((c >> 6) & ~3) ^ WORD_ADDR_XOR];
            
        }
        break;
    case 11:
        {
            taddr = (tbase << 3) + s;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            c = TMEM[taddr & 0x7ff];
            c = tlut[(c << 2) ^ WORD_ADDR_XOR];
        }
        break;
    case 12:
    case 13:
    case 14:
        {
            taddr = (tbase << 2) + s;
            taddr ^= ((t & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR);
            c = tc16[taddr & 0x3ff];
            c = tlut[((c >> 6) & ~3) ^ WORD_ADDR_XOR];
        }
        break;
    case 15:
        {
            taddr = (tbase << 3) + s;
            taddr ^= ((t & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR);
            c = TMEM[taddr & 0x7ff];
            c = tlut[(c << 2) ^ WORD_ADDR_XOR];
        }
        break;
    }

    if (!other_modes.tlut_type)
    {
        color->r = GET_HI_RGBA16_TMEM(c);
        color->g = GET_MED_RGBA16_TMEM(c);
        color->b = GET_LOW_RGBA16_TMEM(c);
        color->a = (c & 1) ? 0xff : 0;
    }
    else
    {
        color->r = color->g = color->b = c >> 8;
        color->a = c & 0xff;
    }

}



INLINE void fetch_texel_quadro(COLOR *color0, COLOR *color1, COLOR *color2, COLOR *color3, int s0, int s1, int t0, int t1, UINT32 tilenum)
{

    UINT32 tbase0 = tile[tilenum].line * t0 + tile[tilenum].tmem;
    UINT32 tbase2 = tile[tilenum].line * t1 + tile[tilenum].tmem;
    UINT32 tpal    = tile[tilenum].palette;
    UINT32 xort = 0, ands = 0;

    
    

    UINT16 *tc16 = (UINT16*)TMEM;
    UINT32 taddr0 = 0, taddr1 = 0, taddr2 = 0, taddr3 = 0;
    UINT32 taddrlow0 = 0, taddrlow1 = 0, taddrlow2 = 0, taddrlow3 = 0;

    switch (tile[tilenum].f.notlutswitch)
    {
    case TEXEL_RGBA4:
        {
            UINT32 byteval, c;

            taddr0 = ((tbase0 << 4) + s0) >> 1;
            taddr1 = ((tbase0 << 4) + s1) >> 1;
            taddr2 = ((tbase2 << 4) + s0) >> 1;
            taddr3 = ((tbase2 << 4) + s1) >> 1;
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0xfff;
            taddr1 &= 0xfff;
            taddr2 &= 0xfff;
            taddr3 &= 0xfff;
            ands = s0 & 1;
            byteval = TMEM[taddr0];
            c = (ands) ? (byteval & 0xf) : (byteval >> 4);
            c |= (c << 4);
            color0->r = c;
            color0->g = c;
            color0->b = c;
            color0->a = c;
            byteval = TMEM[taddr2];
            c = (ands) ? (byteval & 0xf) : (byteval >> 4);
            c |= (c << 4);
            color2->r = c;
            color2->g = c;
            color2->b = c;
            color2->a = c;

            ands = s1 & 1;
            byteval = TMEM[taddr1];
            c = (ands) ? (byteval & 0xf) : (byteval >> 4);
            c |= (c << 4);
            color1->r = c;
            color1->g = c;
            color1->b = c;
            color1->a = c;
            byteval = TMEM[taddr3];
            c = (ands) ? (byteval & 0xf) : (byteval >> 4);
            c |= (c << 4);
            color3->r = c;
            color3->g = c;
            color3->b = c;
            color3->a = c;
        }
        break;
    case TEXEL_RGBA8:
        {
            UINT32 p;

            taddr0 = ((tbase0 << 3) + s0);
            taddr1 = ((tbase0 << 3) + s1);
            taddr2 = ((tbase2 << 3) + s0);
            taddr3 = ((tbase2 << 3) + s1);
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0xfff;
            taddr1 &= 0xfff;
            taddr2 &= 0xfff;
            taddr3 &= 0xfff;
            p = TMEM[taddr0];
            color0->r = p;
            color0->g = p;
            color0->b = p;
            color0->a = p;
            p = TMEM[taddr2];
            color2->r = p;
            color2->g = p;
            color2->b = p;
            color2->a = p;
            p = TMEM[taddr1];
            color1->r = p;
            color1->g = p;
            color1->b = p;
            color1->a = p;
            p = TMEM[taddr3];
            color3->r = p;
            color3->g = p;
            color3->b = p;
            color3->a = p;
        }
        break;
    case TEXEL_RGBA16:
        {
            UINT32 c0, c1, c2, c3;

            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0x7ff;
            taddr1 &= 0x7ff;
            taddr2 &= 0x7ff;
            taddr3 &= 0x7ff;
            c0 = tc16[taddr0];
            c1 = tc16[taddr1];
            c2 = tc16[taddr2];
            c3 = tc16[taddr3];
            color0->r = GET_HI_RGBA16_TMEM(c0);
            color0->g = GET_MED_RGBA16_TMEM(c0);
            color0->b = GET_LOW_RGBA16_TMEM(c0);
            color0->a = (c0 & 1) ? 0xff : 0;
            color1->r = GET_HI_RGBA16_TMEM(c1);
            color1->g = GET_MED_RGBA16_TMEM(c1);
            color1->b = GET_LOW_RGBA16_TMEM(c1);
            color1->a = (c1 & 1) ? 0xff : 0;
            color2->r = GET_HI_RGBA16_TMEM(c2);
            color2->g = GET_MED_RGBA16_TMEM(c2);
            color2->b = GET_LOW_RGBA16_TMEM(c2);
            color2->a = (c2 & 1) ? 0xff : 0;
            color3->r = GET_HI_RGBA16_TMEM(c3);
            color3->g = GET_MED_RGBA16_TMEM(c3);
            color3->b = GET_LOW_RGBA16_TMEM(c3);
            color3->a = (c3 & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_RGBA32:
        {
            UINT16 c0, c1, c2, c3;

            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0x3ff;
            taddr1 &= 0x3ff;
            taddr2 &= 0x3ff;
            taddr3 &= 0x3ff;
            c0 = tc16[taddr0];
            color0->r = c0 >> 8;
            color0->g = c0 & 0xff;
            c0 = tc16[taddr0 | 0x400];
            color0->b = c0 >>  8;
            color0->a = c0 & 0xff;
            c1 = tc16[taddr1];
            color1->r = c1 >> 8;
            color1->g = c1 & 0xff;
            c1 = tc16[taddr1 | 0x400];
            color1->b = c1 >>  8;
            color1->a = c1 & 0xff;
            c2 = tc16[taddr2];
            color2->r = c2 >> 8;
            color2->g = c2 & 0xff;
            c2 = tc16[taddr2 | 0x400];
            color2->b = c2 >>  8;
            color2->a = c2 & 0xff;
            c3 = tc16[taddr3];
            color3->r = c3 >> 8;
            color3->g = c3 & 0xff;
            c3 = tc16[taddr3 | 0x400];
            color3->b = c3 >>  8;
            color3->a = c3 & 0xff;
        }
        break;
    case TEXEL_YUV4:
    case TEXEL_YUV8:
        {
            INT32 u0, u1, u2, u3, save0, save1, save2, save3;

            taddr0 = (tbase0 << 3) + s0;
            taddr1 = (tbase0 << 3) + s1;
            taddr2 = (tbase2 << 3) + s0;
            taddr3 = (tbase2 << 3) + s1;

            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;

            save0 = u0 = TMEM[taddr0 & 0x7FF];
            u0 = (u0 - 0x80) & 0x1FF;
            save1 = u1 = TMEM[taddr1 & 0x7FF];
            u1 = (u1 - 0x80) & 0x1FF;
            save2 = u2 = TMEM[taddr2 & 0x7FF];
            u2 = (u2 - 0x80) & 0x1FF;
            save3 = u3 = TMEM[taddr3 & 0x7FF];
            u3 = (u3 - 0x80) & 0x1FF;

            color0->r = u0;
            color0->g = u0;
            color0->b = save0;
            color0->a = save0;
            color1->r = u1;
            color1->g = u1;
            color1->b = save1;
            color1->a = save1;
            color2->r = u2;
            color2->g = u2;
            color2->b = save2;
            color2->a = save2;
            color3->r = u3;
            color3->g = u3;
            color3->b = save3;
            color3->a = save3;
        }
        break;
    case TEXEL_YUV16:
    case TEXEL_YUV32:
        {
            UINT16 c0, c1, c2, c3;
            INT32 y0, y1, y2, y3, u0, u1, u2, u3, v0, v1, v2, v3;

            taddr0 = ((tbase0 << 3) + s0);
            taddr1 = ((tbase0 << 3) + s1);
            taddr2 = ((tbase2 << 3) + s0);
            taddr3 = ((tbase2 << 3) + s1);
            taddrlow0 = taddr0 >> 1;
            taddrlow1 = taddr1 >> 1;
            taddrlow2 = taddr2 >> 1;
            taddrlow3 = taddr3 >> 1;

            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddrlow0 ^= xort;
            taddrlow1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddrlow2 ^= xort;
            taddrlow3 ^= xort;

            taddr0 &= 0x7ff;
            taddr1 &= 0x7ff;
            taddr2 &= 0x7ff;
            taddr3 &= 0x7ff;
            taddrlow0 &= 0x3ff;
            taddrlow1 &= 0x3ff;
            taddrlow2 &= 0x3ff;
            taddrlow3 &= 0x3ff;

            c0 = tc16[taddrlow0];
            c1 = tc16[taddrlow1];
            c2 = tc16[taddrlow2];
            c3 = tc16[taddrlow3];                    
            
            y0 = TMEM[taddr0 | 0x800];
            u0 = c0 >> 8;
            v0 = c0 & 0xff;
            y1 = TMEM[taddr1 | 0x800];
            u1 = c1 >> 8;
            v1 = c1 & 0xff;
            y2 = TMEM[taddr2 | 0x800];
            u2 = c2 >> 8;
            v2 = c2 & 0xff;
            y3 = TMEM[taddr3 | 0x800];
            u3 = c3 >> 8;
            v3 = c3 & 0xff;

            v0 = (v0 - 0x80) & 0x1FF;
            u0 = (u0 - 0x80) & 0x1FF;
            v1 = (v1 - 0x80) & 0x1FF;
            u1 = (u1 - 0x80) & 0x1FF;
            v2 = (v2 - 0x80) & 0x1FF;
            u2 = (u2 - 0x80) & 0x1FF;
            v3 = (v3 - 0x80) & 0x1FF;
            u3 = (u3 - 0x80) & 0x1FF;

            color0->r = u0;
            color0->g = v0;
            color0->b = y0;
            color0->a = y0;
            color1->r = u1;
            color1->g = v1;
            color1->b = y1;
            color1->a = y1;
            color2->r = u2;
            color2->g = v2;
            color2->b = y2;
            color2->a = y2;
            color3->r = u3;
            color3->g = v3;
            color3->b = y3;
            color3->a = y3;
        }
        break;
    case TEXEL_CI4:
        {
            UINT32 p;

            taddr0 = ((tbase0 << 4) + s0) >> 1;
            taddr1 = ((tbase0 << 4) + s1) >> 1;
            taddr2 = ((tbase2 << 4) + s0) >> 1;
            taddr3 = ((tbase2 << 4) + s1) >> 1;
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0xfff;
            taddr1 &= 0xfff;
            taddr2 &= 0xfff;
            taddr3 &= 0xfff;
            ands = s0 & 1;
            p = TMEM[taddr0];
            p = (ands) ? (p & 0xf) : (p >> 4);
            p = (tpal << 4) | p;
            color0->r = color0->g = color0->b = color0->a = p;
            p = TMEM[taddr2];
            p = (ands) ? (p & 0xf) : (p >> 4);
            p = (tpal << 4) | p;
            color2->r = color2->g = color2->b = color2->a = p;

            ands = s1 & 1;
            p = TMEM[taddr1];
            p = (ands) ? (p & 0xf) : (p >> 4);
            p = (tpal << 4) | p;
            color1->r = color1->g = color1->b = color1->a = p;
            p = TMEM[taddr3];
            p = (ands) ? (p & 0xf) : (p >> 4);
            p = (tpal << 4) | p;
            color3->r = color3->g = color3->b = color3->a = p;
        }
        break;
    case TEXEL_CI8:
        {
            UINT32 p;

            taddr0 = ((tbase0 << 3) + s0);
            taddr1 = ((tbase0 << 3) + s1);
            taddr2 = ((tbase2 << 3) + s0);
            taddr3 = ((tbase2 << 3) + s1);
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;

            taddr0 &= 0xfff;
            taddr1 &= 0xfff;
            taddr2 &= 0xfff;
            taddr3 &= 0xfff;
            p = TMEM[taddr0];
            color0->r = p;
            color0->g = p;
            color0->b = p;
            color0->a = p;
            p = TMEM[taddr2];
            color2->r = p;
            color2->g = p;
            color2->b = p;
            color2->a = p;
            p = TMEM[taddr1];
            color1->r = p;
            color1->g = p;
            color1->b = p;
            color1->a = p;
            p = TMEM[taddr3];
            color3->r = p;
            color3->g = p;
            color3->b = p;
            color3->a = p;
        }
        break;
    case TEXEL_CI16:
        {
            UINT16 c0, c1, c2, c3;

            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0x7ff;
            taddr1 &= 0x7ff;
            taddr2 &= 0x7ff;
            taddr3 &= 0x7ff;
            c0 = tc16[taddr0];
            color0->r = c0 >> 8;
            color0->g = c0 & 0xff;
            color0->b = c0 >> 8;
            color0->a = (c0 & 1) ? 0xff : 0;
            c1 = tc16[taddr1];
            color1->r = c1 >> 8;
            color1->g = c1 & 0xff;
            color1->b = c1 >> 8;
            color1->a = (c1 & 1) ? 0xff : 0;
            c2 = tc16[taddr2];
            color2->r = c2 >> 8;
            color2->g = c2 & 0xff;
            color2->b = c2 >> 8;
            color2->a = (c2 & 1) ? 0xff : 0;
            c3 = tc16[taddr3];
            color3->r = c3 >> 8;
            color3->g = c3 & 0xff;
            color3->b = c3 >> 8;
            color3->a = (c3 & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_CI32:
        {
            UINT16 c0, c1, c2, c3;

            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0x7ff;
            taddr1 &= 0x7ff;
            taddr2 &= 0x7ff;
            taddr3 &= 0x7ff;
            c0 = tc16[taddr0];
            color0->r = c0 >> 8;
            color0->g = c0 & 0xff;
            color0->b = c0 >> 8;
            color0->a = (c0 & 1) ? 0xff : 0;
            c1 = tc16[taddr1];
            color1->r = c1 >> 8;
            color1->g = c1 & 0xff;
            color1->b = c1 >> 8;
            color1->a = (c1 & 1) ? 0xff : 0;
            c2 = tc16[taddr2];
            color2->r = c2 >> 8;
            color2->g = c2 & 0xff;
            color2->b = c2 >> 8;
            color2->a = (c2 & 1) ? 0xff : 0;
            c3 = tc16[taddr3];
            color3->r = c3 >> 8;
            color3->g = c3 & 0xff;
            color3->b = c3 >> 8;
            color3->a = (c3 & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_IA4:
        {
            UINT32 p, i;

            taddr0 = ((tbase0 << 4) + s0) >> 1;
            taddr1 = ((tbase0 << 4) + s1) >> 1;
            taddr2 = ((tbase2 << 4) + s0) >> 1;
            taddr3 = ((tbase2 << 4) + s1) >> 1;
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0xfff;
            taddr1 &= 0xfff;
            taddr2 &= 0xfff;
            taddr3 &= 0xfff;
            ands = s0 & 1;
            p = TMEM[taddr0];
            p = ands ? (p & 0xf) : (p >> 4);
            i = p & 0xe;
            i = (i << 4) | (i << 1) | (i >> 2);
            color0->r = i;
            color0->g = i;
            color0->b = i;
            color0->a = (p & 0x1) ? 0xff : 0;
            p = TMEM[taddr2];
            p = ands ? (p & 0xf) : (p >> 4);
            i = p & 0xe;
            i = (i << 4) | (i << 1) | (i >> 2);
            color2->r = i;
            color2->g = i;
            color2->b = i;
            color2->a = (p & 0x1) ? 0xff : 0;

            ands = s1 & 1;
            p = TMEM[taddr1];
            p = ands ? (p & 0xf) : (p >> 4);
            i = p & 0xe;
            i = (i << 4) | (i << 1) | (i >> 2);
            color1->r = i;
            color1->g = i;
            color1->b = i;
            color1->a = (p & 0x1) ? 0xff : 0;
            p = TMEM[taddr3];
            p = ands ? (p & 0xf) : (p >> 4);
            i = p & 0xe;
            i = (i << 4) | (i << 1) | (i >> 2);
            color3->r = i;
            color3->g = i;
            color3->b = i;
            color3->a = (p & 0x1) ? 0xff : 0;
        }
        break;
    case TEXEL_IA8:
        {
            UINT32 p, i;

            taddr0 = ((tbase0 << 3) + s0);
            taddr1 = ((tbase0 << 3) + s1);
            taddr2 = ((tbase2 << 3) + s0);
            taddr3 = ((tbase2 << 3) + s1);
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;

            taddr0 &= 0xfff;
            taddr1 &= 0xfff;
            taddr2 &= 0xfff;
            taddr3 &= 0xfff;
            p = TMEM[taddr0];
            i = p & 0xf0;
            i |= (i >> 4);
            color0->r = i;
            color0->g = i;
            color0->b = i;
            color0->a = ((p & 0xf) << 4) | (p & 0xf);
            p = TMEM[taddr1];
            i = p & 0xf0;
            i |= (i >> 4);
            color1->r = i;
            color1->g = i;
            color1->b = i;
            color1->a = ((p & 0xf) << 4) | (p & 0xf);
            p = TMEM[taddr2];
            i = p & 0xf0;
            i |= (i >> 4);
            color2->r = i;
            color2->g = i;
            color2->b = i;
            color2->a = ((p & 0xf) << 4) | (p & 0xf);
            p = TMEM[taddr3];
            i = p & 0xf0;
            i |= (i >> 4);
            color3->r = i;
            color3->g = i;
            color3->b = i;
            color3->a = ((p & 0xf) << 4) | (p & 0xf);
        }
        break;
    case TEXEL_IA16:
        {
            UINT16 c0, c1, c2, c3;

            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0x7ff;
            taddr1 &= 0x7ff;
            taddr2 &= 0x7ff;
            taddr3 &= 0x7ff;
            c0 = tc16[taddr0];
            color0->r = color0->g = color0->b = c0 >> 8;
            color0->a = c0 & 0xff;
            c1 = tc16[taddr1];
            color1->r = color1->g = color1->b = c1 >> 8;
            color1->a = c1 & 0xff;
            c2 = tc16[taddr2];
            color2->r = color2->g = color2->b = c2 >> 8;
            color2->a = c2 & 0xff;
            c3 = tc16[taddr3];
            color3->r = color3->g = color3->b = c3 >> 8;
            color3->a = c3 & 0xff;
        }
        break;
    case TEXEL_IA32:
        {
            UINT16 c0, c1, c2, c3;

            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0x7ff;
            taddr1 &= 0x7ff;
            taddr2 &= 0x7ff;
            taddr3 &= 0x7ff;
            c0 = tc16[taddr0];
            color0->r = c0 >> 8;
            color0->g = c0 & 0xff;
            color0->b = c0 >> 8;
            color0->a = (c0 & 1) ? 0xff : 0;
            c1 = tc16[taddr1];
            color1->r = c1 >> 8;
            color1->g = c1 & 0xff;
            color1->b = c1 >> 8;
            color1->a = (c1 & 1) ? 0xff : 0;
            c2 = tc16[taddr2];
            color2->r = c2 >> 8;
            color2->g = c2 & 0xff;
            color2->b = c2 >> 8;
            color2->a = (c2 & 1) ? 0xff : 0;
            c3 = tc16[taddr3];
            color3->r = c3 >> 8;
            color3->g = c3 & 0xff;
            color3->b = c3 >> 8;
            color3->a = (c3 & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_I4:
        {
            UINT32 p, c0, c1, c2, c3;

            taddr0 = ((tbase0 << 4) + s0) >> 1;
            taddr1 = ((tbase0 << 4) + s1) >> 1;
            taddr2 = ((tbase2 << 4) + s0) >> 1;
            taddr3 = ((tbase2 << 4) + s1) >> 1;
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0xfff;
            taddr1 &= 0xfff;
            taddr2 &= 0xfff;
            taddr3 &= 0xfff;
            ands = s0 & 1;
            p = TMEM[taddr0];
            c0 = ands ? (p & 0xf) : (p >> 4);
            c0 |= (c0 << 4);
            color0->r = color0->g = color0->b = color0->a = c0;
            p = TMEM[taddr2];
            c2 = ands ? (p & 0xf) : (p >> 4);
            c2 |= (c2 << 4);
            color2->r = color2->g = color2->b = color2->a = c2;

            ands = s1 & 1;
            p = TMEM[taddr1];
            c1 = ands ? (p & 0xf) : (p >> 4);
            c1 |= (c1 << 4);
            color1->r = color1->g = color1->b = color1->a = c1;
            p = TMEM[taddr3];
            c3 = ands ? (p & 0xf) : (p >> 4);
            c3 |= (c3 << 4);
            color3->r = color3->g = color3->b = color3->a = c3;
        }
        break;
    case TEXEL_I8:
        {
            UINT32 p;

            taddr0 = ((tbase0 << 3) + s0);
            taddr1 = ((tbase0 << 3) + s1);
            taddr2 = ((tbase2 << 3) + s0);
            taddr3 = ((tbase2 << 3) + s1);
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;

            taddr0 &= 0xfff;
            taddr1 &= 0xfff;
            taddr2 &= 0xfff;
            taddr3 &= 0xfff;
            p = TMEM[taddr0];
            color0->r = p;
            color0->g = p;
            color0->b = p;
            color0->a = p;
            p = TMEM[taddr1];
            color1->r = p;
            color1->g = p;
            color1->b = p;
            color1->a = p;
            p = TMEM[taddr2];
            color2->r = p;
            color2->g = p;
            color2->b = p;
            color2->a = p;
            p = TMEM[taddr3];
            color3->r = p;
            color3->g = p;
            color3->b = p;
            color3->a = p;
        }
        break;
    case TEXEL_I16:
        {
            UINT16 c0, c1, c2, c3;

            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0x7ff;
            taddr1 &= 0x7ff;
            taddr2 &= 0x7ff;
            taddr3 &= 0x7ff;
            c0 = tc16[taddr0];
            color0->r = c0 >> 8;
            color0->g = c0 & 0xff;
            color0->b = c0 >> 8;
            color0->a = (c0 & 1) ? 0xff : 0;
            c1 = tc16[taddr1];
            color1->r = c1 >> 8;
            color1->g = c1 & 0xff;
            color1->b = c1 >> 8;
            color1->a = (c1 & 1) ? 0xff : 0;
            c2 = tc16[taddr2];
            color2->r = c2 >> 8;
            color2->g = c2 & 0xff;
            color2->b = c2 >> 8;
            color2->a = (c2 & 1) ? 0xff : 0;
            c3 = tc16[taddr3];
            color3->r = c3 >> 8;
            color3->g = c3 & 0xff;
            color3->b = c3 >> 8;
            color3->a = (c3 & 1) ? 0xff : 0;
        }
        break;
    case TEXEL_I32:
        {
            UINT16 c0, c1, c2, c3;

            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            taddr0 &= 0x7ff;
            taddr1 &= 0x7ff;
            taddr2 &= 0x7ff;
            taddr3 &= 0x7ff;
            c0 = tc16[taddr0];
            color0->r = c0 >> 8;
            color0->g = c0 & 0xff;
            color0->b = c0 >> 8;
            color0->a = (c0 & 1) ? 0xff : 0;
            c1 = tc16[taddr1];
            color1->r = c1 >> 8;
            color1->g = c1 & 0xff;
            color1->b = c1 >> 8;
            color1->a = (c1 & 1) ? 0xff : 0;
            c2 = tc16[taddr2];
            color2->r = c2 >> 8;
            color2->g = c2 & 0xff;
            color2->b = c2 >> 8;
            color2->a = (c2 & 1) ? 0xff : 0;
            c3 = tc16[taddr3];
            color3->r = c3 >> 8;
            color3->g = c3 & 0xff;
            color3->b = c3 >> 8;
            color3->a = (c3 & 1) ? 0xff : 0;
        }
        break;
    }
}

INLINE void fetch_texel_entlut_quadro(COLOR *color0, COLOR *color1, COLOR *color2, COLOR *color3, int s0, int s1, int t0, int t1, UINT32 tilenum)
{
    UINT32 tbase0 = tile[tilenum].line * t0 + tile[tilenum].tmem;
    UINT32 tbase2 = tile[tilenum].line * t1 + tile[tilenum].tmem;
    UINT32 tpal    = tile[tilenum].palette << 4;
    UINT32 xort = 0, ands = 0;

    UINT16 *tc16 = (UINT16*)TMEM;
    UINT32 taddr0 = 0, taddr1 = 0, taddr2 = 0, taddr3 = 0;
    UINT16 c0, c1, c2, c3;

    c3 = c2 = c1 = c0 = 0x0000;
    switch (tile[tilenum].f.tlutswitch & 0xF)
    {
    case 0:
    case 1:
    case 2:
        {
            taddr0 = ((tbase0 << 4) + s0) >> 1;
            taddr1 = ((tbase0 << 4) + s1) >> 1;
            taddr2 = ((tbase2 << 4) + s0) >> 1;
            taddr3 = ((tbase2 << 4) + s1) >> 1;
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
                                                            
            ands = s0 & 1;
            c0 = TMEM[taddr0 & 0x7ff];
            c0 = (ands) ? (c0 & 0xf) : (c0 >> 4);
            c0 = tlut[((tpal | c0) << 2) ^ WORD_ADDR_XOR];
            c2 = TMEM[taddr2 & 0x7ff];
            c2 = (ands) ? (c2 & 0xf) : (c2 >> 4);
            c2 = tlut[((tpal | c2) << 2) ^ WORD_ADDR_XOR];

            ands = s1 & 1;
            c1 = TMEM[taddr1 & 0x7ff];
            c1 = (ands) ? (c1 & 0xf) : (c1 >> 4);
            c1 = tlut[((tpal | c1) << 2) ^ WORD_ADDR_XOR];
            c3 = TMEM[taddr3 & 0x7ff];
            c3 = (ands) ? (c3 & 0xf) : (c3 >> 4);
            c3 = tlut[((tpal | c3) << 2) ^ WORD_ADDR_XOR];
        }
        break;
    case 3:
        {
            taddr0 = ((tbase0 << 3) + s0);
            taddr1 = ((tbase0 << 3) + s1);
            taddr2 = ((tbase2 << 3) + s0);
            taddr3 = ((tbase2 << 3) + s1);
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
                                                            
            ands = s0 & 1;
            c0 = TMEM[taddr0 & 0x7ff];
            c0 = (ands) ? (c0 & 0xf) : (c0 >> 4);
            c0 = tlut[((tpal | c0) << 2) ^ WORD_ADDR_XOR];
            c2 = TMEM[taddr2 & 0x7ff];
            c2 = (ands) ? (c2 & 0xf) : (c2 >> 4);
            c2 = tlut[((tpal | c2) << 2) ^ WORD_ADDR_XOR];

            ands = s1 & 1;
            c1 = TMEM[taddr1 & 0x7ff];
            c1 = (ands) ? (c1 & 0xf) : (c1 >> 4);
            c1 = tlut[((tpal | c1) << 2) ^ WORD_ADDR_XOR];
            c3 = TMEM[taddr3 & 0x7ff];
            c3 = (ands) ? (c3 & 0xf) : (c3 >> 4);
            c3 = tlut[((tpal | c3) << 2) ^ WORD_ADDR_XOR];
        }
        break;
    case 4:
    case 5:
    case 6:
    case 7:
        {
            taddr0 = ((tbase0 << 3) + s0);
            taddr1 = ((tbase0 << 3) + s1);
            taddr2 = ((tbase2 << 3) + s0);
            taddr3 = ((tbase2 << 3) + s1);
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            
            c0 = TMEM[taddr0 & 0x7ff];
            c0 = tlut[(c0 << 2) ^ WORD_ADDR_XOR];
            c2 = TMEM[taddr2 & 0x7ff];
            c2 = tlut[(c2 << 2) ^ WORD_ADDR_XOR];
            c1 = TMEM[taddr1 & 0x7ff];
            c1 = tlut[(c1 << 2) ^ WORD_ADDR_XOR];
            c3 = TMEM[taddr3 & 0x7ff];
            c3 = tlut[(c3 << 2) ^ WORD_ADDR_XOR];
        }
        break;
    case 8:
    case 9:
    case 10:
        {
            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
                    
            c0 = tc16[taddr0 & 0x3ff];
            c0 = tlut[((c0 >> 6) & ~3) ^ WORD_ADDR_XOR];
            c1 = tc16[taddr1 & 0x3ff];
            c1 = tlut[((c1 >> 6) & ~3) ^ WORD_ADDR_XOR];
            c2 = tc16[taddr2 & 0x3ff];
            c2 = tlut[((c2 >> 6) & ~3) ^ WORD_ADDR_XOR];
            c3 = tc16[taddr3 & 0x3ff];
            c3 = tlut[((c3 >> 6) & ~3) ^ WORD_ADDR_XOR];
        }
        break;
    case 11:
        {
            taddr0 = ((tbase0 << 3) + s0);
            taddr1 = ((tbase0 << 3) + s1);
            taddr2 = ((tbase2 << 3) + s0);
            taddr3 = ((tbase2 << 3) + s1);
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            
            c0 = TMEM[taddr0 & 0x7ff];
            c0 = tlut[(c0 << 2) ^ WORD_ADDR_XOR];
            c2 = TMEM[taddr2 & 0x7ff];
            c2 = tlut[(c2 << 2) ^ WORD_ADDR_XOR];
            c1 = TMEM[taddr1 & 0x7ff];
            c1 = tlut[(c1 << 2) ^ WORD_ADDR_XOR];
            c3 = TMEM[taddr3 & 0x7ff];
            c3 = tlut[(c3 << 2) ^ WORD_ADDR_XOR];
        }
        break;
    case 12:
    case 13:
    case 14:
        {
            taddr0 = ((tbase0 << 2) + s0);
            taddr1 = ((tbase0 << 2) + s1);
            taddr2 = ((tbase2 << 2) + s0);
            taddr3 = ((tbase2 << 2) + s1);
            xort = (t0 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? WORD_XOR_DWORD_SWAP : WORD_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
                                
            c0 = tc16[taddr0 & 0x3ff];
            c0 = tlut[((c0 >> 6) & ~3) ^ WORD_ADDR_XOR];
            c1 = tc16[taddr1 & 0x3ff];
            c1 = tlut[((c1 >> 6) & ~3) ^ WORD_ADDR_XOR];
            c2 = tc16[taddr2 & 0x3ff];
            c2 = tlut[((c2 >> 6) & ~3) ^ WORD_ADDR_XOR];
            c3 = tc16[taddr3 & 0x3ff];
            c3 = tlut[((c3 >> 6) & ~3) ^ WORD_ADDR_XOR];
        }
        break;
    case 15:
        {
            taddr0 = ((tbase0 << 3) + s0);
            taddr1 = ((tbase0 << 3) + s1);
            taddr2 = ((tbase2 << 3) + s0);
            taddr3 = ((tbase2 << 3) + s1);
            xort = (t0 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr0 ^= xort;
            taddr1 ^= xort;
            xort = (t1 & 1) ? BYTE_XOR_DWORD_SWAP : BYTE_ADDR_XOR;
            taddr2 ^= xort;
            taddr3 ^= xort;
            
            c0 = TMEM[taddr0 & 0x7ff];
            c0 = tlut[(c0 << 2) ^ WORD_ADDR_XOR];
            c2 = TMEM[taddr2 & 0x7ff];
            c2 = tlut[(c2 << 2) ^ WORD_ADDR_XOR];
            c1 = TMEM[taddr1 & 0x7ff];
            c1 = tlut[(c1 << 2) ^ WORD_ADDR_XOR];
            c3 = TMEM[taddr3 & 0x7ff];
            c3 = tlut[(c3 << 2) ^ WORD_ADDR_XOR];
        }
        break;
    }

    if (!other_modes.tlut_type)
    {
        color0->r = GET_HI_RGBA16_TMEM(c0);
        color0->g = GET_MED_RGBA16_TMEM(c0);
        color0->b = GET_LOW_RGBA16_TMEM(c0);
        color0->a = (c0 & 1) ? 0xff : 0;
        color1->r = GET_HI_RGBA16_TMEM(c1);
        color1->g = GET_MED_RGBA16_TMEM(c1);
        color1->b = GET_LOW_RGBA16_TMEM(c1);
        color1->a = (c1 & 1) ? 0xff : 0;
        color2->r = GET_HI_RGBA16_TMEM(c2);
        color2->g = GET_MED_RGBA16_TMEM(c2);
        color2->b = GET_LOW_RGBA16_TMEM(c2);
        color2->a = (c2 & 1) ? 0xff : 0;
        color3->r = GET_HI_RGBA16_TMEM(c3);
        color3->g = GET_MED_RGBA16_TMEM(c3);
        color3->b = GET_LOW_RGBA16_TMEM(c3);
        color3->a = (c3 & 1) ? 0xff : 0;
    }
    else
    {
        color0->r = color0->g = color0->b = c0 >> 8;
        color0->a = c0 & 0xff;
        color1->r = color1->g = color1->b = c1 >> 8;
        color1->a = c1 & 0xff;
        color2->r = color2->g = color2->b = c2 >> 8;
        color2->a = c2 & 0xff;
        color3->r = color3->g = color3->b = c3 >> 8;
        color3->a = c3 & 0xff;
    }
}


void get_tmem_idx(int s, int t, UINT32 tilenum, UINT32* idx0, UINT32* idx1, UINT32* idx2, UINT32* idx3, UINT32* bit3flipped, UINT32* hibit)
{
    UINT32 tbase;
    UINT32 tsize;
    UINT32 tformat;
    UINT32 sshorts;
    int tidx_a, tidx_b, tidx_c, tidx_d;

    tbase  = (tile[tilenum].line * t) & 0x000001FF;
    tbase += tile[tilenum].tmem;
    tsize = tile[tilenum].size;
    tformat = tile[tilenum].format;
    sshorts = 0;

    if (tsize == PIXEL_SIZE_8BIT || tformat == FORMAT_YUV)
        sshorts = s >> 1;
    else if (tsize >= PIXEL_SIZE_16BIT)
        sshorts = s;
    else
        sshorts = s >> 2;
    sshorts &= 0x7ff;

    *bit3flipped = ((sshorts & 2) ? 1 : 0) ^ (t & 1);
    tidx_a = ((tbase << 2) + sshorts) & 0x7fd;
    tidx_b = (tidx_a + 1) & 0x7ff;
    tidx_c = (tidx_a + 2) & 0x7ff;
    tidx_d = (tidx_a + 3) & 0x7ff;

    *hibit = (tidx_a & 0x400) ? 1 : 0;

    if (t & 1)
    {
        tidx_a ^= 2;
        tidx_b ^= 2;
        tidx_c ^= 2;
        tidx_d ^= 2;
    }

    
    sort_tmem_idx(idx0, tidx_a, tidx_b, tidx_c, tidx_d, 0);
    sort_tmem_idx(idx1, tidx_a, tidx_b, tidx_c, tidx_d, 1);
    sort_tmem_idx(idx2, tidx_a, tidx_b, tidx_c, tidx_d, 2);
    sort_tmem_idx(idx3, tidx_a, tidx_b, tidx_c, tidx_d, 3);
}

void read_tmem_copy(int s, int s1, int s2, int s3, int t, UINT32 tilenum, UINT32* sortshort, int* hibits, int* lowbits)
{
    UINT32 sortidx[8];
    UINT32 tbase;
    UINT32 tsize;
    UINT32 tformat;
    UINT32 shbytes, shbytes1, shbytes2, shbytes3;
    INT32 delta;
    UINT16* tmem16;
    UINT32 short0, short1, short2, short3;
    int tidx_a, tidx_blow, tidx_bhi, tidx_c, tidx_dlow, tidx_dhi;

    delta = 0;
    tbase  = (tile[tilenum].line * t) & 0x000001FF;
    tbase += tile[tilenum].tmem;
    tsize = tile[tilenum].size;
    tformat = tile[tilenum].format;

    if (tsize == PIXEL_SIZE_8BIT || tformat == FORMAT_YUV)
    {
        shbytes = s << 1;
        shbytes1 = s1 << 1;
        shbytes2 = s2 << 1;
        shbytes3 = s3 << 1;
    }
    else if (tsize >= PIXEL_SIZE_16BIT)
    {
        shbytes = s << 2;
        shbytes1 = s1 << 2;
        shbytes2 = s2 << 2;
        shbytes3 = s3 << 2;
    }
    else
    {
        shbytes = s;
        shbytes1 = s1;
        shbytes2 = s2;
        shbytes3 = s3;
    }

    shbytes &= 0x1fff;
    shbytes1 &= 0x1fff;
    shbytes2 &= 0x1fff;
    shbytes3 &= 0x1fff;

    tbase <<= 4;
    tidx_a = (tbase + shbytes) & 0x1fff;
    tidx_bhi = (tbase + shbytes1) & 0x1fff;
    tidx_c = (tbase + shbytes2) & 0x1fff;
    tidx_dhi = (tbase + shbytes3) & 0x1fff;

    if (tformat == FORMAT_YUV)
    {
        delta = shbytes1 - shbytes;
        tidx_blow = (tidx_a + (delta << 1)) & 0x1fff;
        tidx_dlow = (tidx_blow + shbytes3 - shbytes) & 0x1fff;
    }
    else
    {
        tidx_blow = tidx_bhi;
        tidx_dlow = tidx_dhi;
    }

    if (t & 1)
    {
        tidx_a ^= 8;
        tidx_blow ^= 8;
        tidx_bhi ^= 8;
        tidx_c ^= 8;
        tidx_dlow ^= 8;
        tidx_dhi ^= 8;
    }

    hibits[0] = (tidx_a & 0x1000) ? 1 : 0;
    hibits[1] = (tidx_blow & 0x1000) ? 1 : 0; 
    hibits[2] =    (tidx_bhi & 0x1000) ? 1 : 0;
    hibits[3] =    (tidx_c & 0x1000) ? 1 : 0;
    hibits[4] =    (tidx_dlow & 0x1000) ? 1 : 0;
    hibits[5] = (tidx_dhi & 0x1000) ? 1 : 0;
    lowbits[0] = tidx_a & 0xf;
    lowbits[1] = tidx_blow & 0xf;
    lowbits[2] = tidx_bhi & 0xf;
    lowbits[3] = tidx_c & 0xf;
    lowbits[4] = tidx_dlow & 0xf;
    lowbits[5] = tidx_dhi & 0xf;

    tmem16 = (UINT16 *)TMEM;

    tidx_a >>= 2;
    tidx_blow >>= 2;
    tidx_bhi >>= 2;
    tidx_c >>= 2;
    tidx_dlow >>= 2;
    tidx_dhi >>= 2;

    
    sort_tmem_idx(&sortidx[0], tidx_a, tidx_blow, tidx_c, tidx_dlow, 0);
    sort_tmem_idx(&sortidx[1], tidx_a, tidx_blow, tidx_c, tidx_dlow, 1);
    sort_tmem_idx(&sortidx[2], tidx_a, tidx_blow, tidx_c, tidx_dlow, 2);
    sort_tmem_idx(&sortidx[3], tidx_a, tidx_blow, tidx_c, tidx_dlow, 3);

    short0 = tmem16[sortidx[0] ^ WORD_ADDR_XOR];
    short1 = tmem16[sortidx[1] ^ WORD_ADDR_XOR];
    short2 = tmem16[sortidx[2] ^ WORD_ADDR_XOR];
    short3 = tmem16[sortidx[3] ^ WORD_ADDR_XOR];

    
    sort_tmem_shorts_lowhalf(&sortshort[0], short0, short1, short2, short3, lowbits[0] >> 2);
    sort_tmem_shorts_lowhalf(&sortshort[1], short0, short1, short2, short3, lowbits[1] >> 2);
    sort_tmem_shorts_lowhalf(&sortshort[2], short0, short1, short2, short3, lowbits[3] >> 2);
    sort_tmem_shorts_lowhalf(&sortshort[3], short0, short1, short2, short3, lowbits[4] >> 2);

    if (other_modes.en_tlut)
    {
         
        compute_color_index(&short0, sortshort[0], lowbits[0] & 3, tilenum);
        compute_color_index(&short1, sortshort[1], lowbits[1] & 3, tilenum);
        compute_color_index(&short2, sortshort[2], lowbits[3] & 3, tilenum);
        compute_color_index(&short3, sortshort[3], lowbits[4] & 3, tilenum);

        
        sortidx[4] = (short0 << 2);
        sortidx[5] = (short1 << 2) | 1;
        sortidx[6] = (short2 << 2) | 2;
        sortidx[7] = (short3 << 2) | 3;
    }
    else
    {
        sort_tmem_idx(&sortidx[4], tidx_a, tidx_bhi, tidx_c, tidx_dhi, 0);
        sort_tmem_idx(&sortidx[5], tidx_a, tidx_bhi, tidx_c, tidx_dhi, 1);
        sort_tmem_idx(&sortidx[6], tidx_a, tidx_bhi, tidx_c, tidx_dhi, 2);
        sort_tmem_idx(&sortidx[7], tidx_a, tidx_bhi, tidx_c, tidx_dhi, 3);
    }

    short0 = tmem16[(sortidx[4] | 0x400) ^ WORD_ADDR_XOR];
    short1 = tmem16[(sortidx[5] | 0x400) ^ WORD_ADDR_XOR];
    short2 = tmem16[(sortidx[6] | 0x400) ^ WORD_ADDR_XOR];
    short3 = tmem16[(sortidx[7] | 0x400) ^ WORD_ADDR_XOR];

    if (other_modes.en_tlut)
    {
        sort_tmem_shorts_lowhalf(&sortshort[4], short0, short1, short2, short3, 0);
        sort_tmem_shorts_lowhalf(&sortshort[5], short0, short1, short2, short3, 1);
        sort_tmem_shorts_lowhalf(&sortshort[6], short0, short1, short2, short3, 2);
        sort_tmem_shorts_lowhalf(&sortshort[7], short0, short1, short2, short3, 3);
    }
    else
    {
        sort_tmem_shorts_lowhalf(&sortshort[4], short0, short1, short2, short3, lowbits[0] >> 2);
        sort_tmem_shorts_lowhalf(&sortshort[5], short0, short1, short2, short3, lowbits[2] >> 2);
        sort_tmem_shorts_lowhalf(&sortshort[6], short0, short1, short2, short3, lowbits[3] >> 2);
        sort_tmem_shorts_lowhalf(&sortshort[7], short0, short1, short2, short3, lowbits[5] >> 2);
    }
}

void sort_tmem_idx(UINT32 *idx, UINT32 idxa, UINT32 idxb, UINT32 idxc, UINT32 idxd, UINT32 bankno)
{
    if ((idxa & 3) == bankno)
        *idx = idxa & 0x3ff;
    else if ((idxb & 3) == bankno)
        *idx = idxb & 0x3ff;
    else if ((idxc & 3) == bankno)
        *idx = idxc & 0x3ff;
    else if ((idxd & 3) == bankno)
        *idx = idxd & 0x3ff;
    else
        *idx = 0;
}


void sort_tmem_shorts_lowhalf(UINT32* bindshort, UINT32 short0, UINT32 short1, UINT32 short2, UINT32 short3, UINT32 bankno)
{
    switch(bankno)
    {
    case 0:
        *bindshort = short0;
        break;
    case 1:
        *bindshort = short1;
        break;
    case 2:
        *bindshort = short2;
        break;
    case 3:
        *bindshort = short3;
        break;
    }
}



void compute_color_index(UINT32* cidx, UINT32 readshort, UINT32 nybbleoffset, UINT32 tilenum)
{
    UINT32 lownib, hinib;
    if (tile[tilenum].size == PIXEL_SIZE_4BIT)
    {
        lownib = (nybbleoffset ^ 3) << 2;
        hinib = tile[tilenum].palette;
    }
    else
    {
        lownib = ((nybbleoffset & 2) ^ 2) << 2;
        hinib = lownib ? ((readshort >> 12) & 0xf) : ((readshort >> 4) & 0xf);
    }
    lownib = (readshort >> lownib) & 0xf;
    *cidx = (hinib << 4) | lownib;
}


void replicate_for_copy(UINT32* outbyte, UINT32 inshort, UINT32 nybbleoffset, UINT32 tilenum, UINT32 tformat, UINT32 tsize)
{
    UINT32 lownib, hinib;
    switch(tsize)
    {
    case PIXEL_SIZE_4BIT:
        lownib = (nybbleoffset ^ 3) << 2;
        lownib = hinib = (inshort >> lownib) & 0xf;
        if (tformat == FORMAT_CI)
        {
            *outbyte = (tile[tilenum].palette << 4) | lownib;
        }
        else if (tformat == FORMAT_IA)
        {
            lownib = (lownib << 4) | lownib;
            *outbyte = (lownib & 0xe0) | ((lownib & 0xe0) >> 3) | ((lownib & 0xc0) >> 6);
        }
        else
            *outbyte = (lownib << 4) | lownib;
        break;
    case PIXEL_SIZE_8BIT:
        hinib = ((nybbleoffset ^ 3) | 1) << 2;
        if (tformat == FORMAT_IA)
        {
            lownib = (inshort >> hinib) & 0xf;
            *outbyte = (lownib << 4) | lownib;
        }
        else
        {
            lownib = (inshort >> (hinib & ~4)) & 0xf;
            hinib = (inshort >> hinib) & 0xf;
            *outbyte = (hinib << 4) | lownib;
        }
        break;
    default:
        *outbyte = (inshort >> 8) & 0xff;
        break;
    }
}

void fetch_qword_copy(UINT32* hidword, UINT32* lowdword, INT32 ssss, INT32 ssst, UINT32 tilenum)
{
    UINT32 shorta, shortb, shortc, shortd;
    UINT32 sortshort[8];
    int hibits[6];
    int lowbits[6];
    INT32 sss = ssss, sst = ssst, sss1 = 0, sss2 = 0, sss3 = 0;
    int largetex = 0;

    UINT32 tformat, tsize;
    if (other_modes.en_tlut)
    {
        tsize = PIXEL_SIZE_16BIT;
        tformat = other_modes.tlut_type ? FORMAT_IA : FORMAT_RGBA;
    }
    else
    {
        tsize = tile[tilenum].size;
        tformat = tile[tilenum].format;
    }

    tc_pipeline_copy(&sss, &sss1, &sss2, &sss3, &sst, tilenum);
    read_tmem_copy(sss, sss1, sss2, sss3, sst, tilenum, sortshort, hibits, lowbits);
    largetex = (tformat == FORMAT_YUV || (tformat == FORMAT_RGBA && tsize == PIXEL_SIZE_32BIT));

    
    if (other_modes.en_tlut)
    {
        shorta = sortshort[4];
        shortb = sortshort[5];
        shortc = sortshort[6];
        shortd = sortshort[7];
    }
    else if (largetex)
    {
        shorta = sortshort[0];
        shortb = sortshort[1];
        shortc = sortshort[2];
        shortd = sortshort[3];
    }
    else
    {
        shorta = hibits[0] ? sortshort[4] : sortshort[0];
        shortb = hibits[1] ? sortshort[5] : sortshort[1];
        shortc = hibits[3] ? sortshort[6] : sortshort[2];
        shortd = hibits[4] ? sortshort[7] : sortshort[3];
    }

    *lowdword = (shortc << 16) | shortd;

    if (tsize == PIXEL_SIZE_16BIT)
        *hidword = (shorta << 16) | shortb;
    else
    {
        replicate_for_copy(&shorta, shorta, lowbits[0] & 3, tilenum, tformat, tsize);
        replicate_for_copy(&shortb, shortb, lowbits[1] & 3, tilenum, tformat, tsize);
        replicate_for_copy(&shortc, shortc, lowbits[3] & 3, tilenum, tformat, tsize);
        replicate_for_copy(&shortd, shortd, lowbits[4] & 3, tilenum, tformat, tsize);
        *hidword = (shorta << 24) | (shortb << 16) | (shortc << 8) | shortd;
    }
}

STRICTINLINE void texture_pipeline_cycle(COLOR* TEX, COLOR* prev, INT32 SSS, INT32 SST, UINT32 tilenum, UINT32 cycle)                                            
{
#define TRELATIVE(x, y)     ((x) - ((y) << 3));
#define UPPER ((sfrac + tfrac) & 0x20)
    INT32 maxs, maxt, invt0r, invt0g, invt0b, invt0a;
    INT32 sfrac, tfrac, invsf, invtf;
    int bilerp = cycle ? other_modes.bi_lerp1 : other_modes.bi_lerp0;
    int convert = other_modes.convert_one && cycle;
    COLOR t0, t1, t2, t3;
    int sss1, sst1, sss2, sst2;

    sss1 = SSS;
    sst1 = SST;

    tcshift_cycle(&sss1, &sst1, &maxs, &maxt, tilenum);

    sss1 = TRELATIVE(sss1, tile[tilenum].sl);
    sst1 = TRELATIVE(sst1, tile[tilenum].tl);

    if (other_modes.sample_type)
    {    
        sfrac = sss1 & 0x1f;
        tfrac = sst1 & 0x1f;

        tcclamp_cycle(&sss1, &sst1, &sfrac, &tfrac, maxs, maxt, tilenum);

        if (tile[tilenum].format == FORMAT_YUV)
            sss2 = sss1 + 2;
        else
            sss2 = sss1 + 1;

        sst2 = sst1 + 1;

        tcmask_coupled(&sss1, &sss2, &sst1, &sst2, tilenum);

        if (bilerp)
        {
            if (!other_modes.en_tlut)
                fetch_texel_quadro(&t0, &t1, &t2, &t3, sss1, sss2, sst1, sst2, tilenum);
            else
                fetch_texel_entlut_quadro(&t0, &t1, &t2, &t3, sss1, sss2, sst1, sst2, tilenum);

            if (tile[tilenum].format == FORMAT_YUV)
            {
                t0.r = SIGN(t0.r, 9);
                t0.g = SIGN(t0.g, 9);
                t1.r = SIGN(t1.r, 9);
                t1.g = SIGN(t1.g, 9);
                t2.r = SIGN(t2.r, 9);
                t2.g = SIGN(t2.g, 9);
                t3.r = SIGN(t3.r, 9);
                t3.g = SIGN(t3.g, 9);
            }

            if (!other_modes.mid_texel || sfrac != 0x10 || tfrac != 0x10)
            {
                if (!convert)
                {
                    if (UPPER)
                    {
                        invsf = 0x20 - sfrac;
                        invtf = 0x20 - tfrac;
                        TEX->r = t3.r + ((((invsf * (t2.r - t3.r)) + (invtf * (t1.r - t3.r))) + 0x10) >> 5);
                        TEX->g = t3.g + ((((invsf * (t2.g - t3.g)) + (invtf * (t1.g - t3.g))) + 0x10) >> 5);
                        TEX->b = t3.b + ((((invsf * (t2.b - t3.b)) + (invtf * (t1.b - t3.b))) + 0x10) >> 5);
                        TEX->a = t3.a + ((((invsf * (t2.a - t3.a)) + (invtf * (t1.a - t3.a))) + 0x10) >> 5);
                    }
                    else
                    {
                        TEX->r = t0.r + ((((sfrac * (t1.r - t0.r)) + (tfrac * (t2.r - t0.r))) + 0x10) >> 5);
                        TEX->g = t0.g + ((((sfrac * (t1.g - t0.g)) + (tfrac * (t2.g - t0.g))) + 0x10) >> 5);
                        TEX->b = t0.b + ((((sfrac * (t1.b - t0.b)) + (tfrac * (t2.b - t0.b))) + 0x10) >> 5);
                        TEX->a = t0.a + ((((sfrac * (t1.a - t0.a)) + (tfrac * (t2.a - t0.a))) + 0x10) >> 5);
                    }
                }
                else
                {
                    if (UPPER)
                    {
                        TEX->r = prev->b + ((((prev->r * (t2.r - t3.r)) + (prev->g * (t1.r - t3.r))) + 0x80) >> 8);
                        TEX->g = prev->b + ((((prev->r * (t2.g - t3.g)) + (prev->g * (t1.g - t3.g))) + 0x80) >> 8);
                        TEX->b = prev->b + ((((prev->r * (t2.b - t3.b)) + (prev->g * (t1.b - t3.b))) + 0x80) >> 8);
                        TEX->a = prev->b + ((((prev->r * (t2.a - t3.a)) + (prev->g * (t1.a - t3.a))) + 0x80) >> 8);
                    }
                    else
                    {
                        TEX->r = prev->b + ((((prev->r * (t1.r - t0.r)) + (prev->g * (t2.r - t0.r))) + 0x80) >> 8);
                        TEX->g = prev->b + ((((prev->r * (t1.g - t0.g)) + (prev->g * (t2.g - t0.g))) + 0x80) >> 8);
                        TEX->b = prev->b + ((((prev->r * (t1.b - t0.b)) + (prev->g * (t2.b - t0.b))) + 0x80) >> 8);
                        TEX->a = prev->b + ((((prev->r * (t1.a - t0.a)) + (prev->g * (t2.a - t0.a))) + 0x80) >> 8);
                    }    
                }
            }
            else
            {
                invt0r  = ~t0.r; invt0g = ~t0.g; invt0b = ~t0.b; invt0a = ~t0.a;
                if (!convert)
                {
                    sfrac <<= 2;
                    tfrac <<= 2;
                    TEX->r = t0.r + ((((sfrac * (t1.r - t0.r)) + (tfrac * (t2.r - t0.r))) + ((invt0r + t3.r) << 6) + 0xc0) >> 8);
                    TEX->g = t0.g + ((((sfrac * (t1.g - t0.g)) + (tfrac * (t2.g - t0.g))) + ((invt0g + t3.g) << 6) + 0xc0) >> 8);
                    TEX->b = t0.b + ((((sfrac * (t1.b - t0.b)) + (tfrac * (t2.b - t0.b))) + ((invt0b + t3.b) << 6) + 0xc0) >> 8);
                    TEX->a = t0.a + ((((sfrac * (t1.a - t0.a)) + (tfrac * (t2.a - t0.a))) + ((invt0a + t3.a) << 6) + 0xc0) >> 8);
                }
                else
                {
                    TEX->r = prev->b + ((((prev->r * (t1.r - t0.r)) + (prev->g * (t2.r - t0.r))) + ((invt0r + t3.r) << 6) + 0xc0) >> 8);
                    TEX->g = prev->b + ((((prev->r * (t1.g - t0.g)) + (prev->g * (t2.g - t0.g))) + ((invt0g + t3.g) << 6) + 0xc0) >> 8);
                    TEX->b = prev->b + ((((prev->r * (t1.b - t0.b)) + (prev->g * (t2.b - t0.b))) + ((invt0b + t3.b) << 6) + 0xc0) >> 8);
                    TEX->a = prev->b + ((((prev->r * (t1.a - t0.a)) + (prev->g * (t2.a - t0.a))) + ((invt0a + t3.a) << 6) + 0xc0) >> 8);
                }
            }
        }
        else
        {
            if (!other_modes.en_tlut)
                fetch_texel(&t0, sss1, sst1, tilenum);
            else
                fetch_texel_entlut(&t0, sss1, sst1, tilenum);
            if (convert)
                t0 = *prev;

            if (tile[tilenum].format == FORMAT_YUV)
            {
                t0.r = SIGN(t0.r, 9);
                t0.g = SIGN(t0.g, 9);
            }
            TEX->r = t0.b + (((k_YUV_RGB[0] * t0.g) + 0x80) >> 8);
            TEX->g = t0.b + (((k_YUV_RGB[1] * t0.r + k_YUV_RGB[2] * t0.g) + 0x80) >> 8);
            TEX->b = t0.b + (((k_YUV_RGB[2] * t0.r) + 0x80) >> 8);
            TEX->a = t0.b;
        }
        TEX->r &= 0x1FF;
        TEX->g &= 0x1FF;
        TEX->b &= 0x1FF;
        TEX->a &= 0x1FF;
    }
    else
    {
        tcclamp_cycle_light(&sss1, &sst1, maxs, maxt, tilenum);
        
        tcmask(&sss1, &sst1, tilenum);
        if (!other_modes.en_tlut)
            fetch_texel(&t0, sss1, sst1, tilenum);
        else
            fetch_texel_entlut(&t0, sss1, sst1, tilenum);
        
        if (bilerp)
        {
            if (!convert)
                *TEX = t0;
            else
                TEX->r = TEX->g = TEX->b = TEX->a = prev->b;
        }
        else
        {
            if (convert)
                t0 = *prev;
            t0.r = SIGN(t0.r, 9);
            t0.g = SIGN(t0.g, 9);
            t0.b = SIGN(t0.b, 9);
            TEX->r = t0.b + (((k_YUV_RGB[0] * t0.g) + 0x80) >> 8);
            TEX->g = t0.b + (((k_YUV_RGB[1] * t0.r + k_YUV_RGB[2] * t0.g) + 0x80) >> 8);
            TEX->b = t0.b + (((k_YUV_RGB[3] * t0.r) + 0x80) >> 8);
            TEX->a = t0.b;
            TEX->r &= 0x1FF;
            TEX->g &= 0x1FF;
            TEX->b &= 0x1FF;
            TEX->a &= 0x1FF;
        }
    }
}

STRICTINLINE void tc_pipeline_copy(INT32* sss0, INT32* sss1, INT32* sss2, INT32* sss3, INT32* sst, int tilenum)                                            
{
    int ss0 = *sss0, ss1 = 0, ss2 = 0, ss3 = 0, st = *sst;

    tcshift_copy(&ss0, &st, tilenum);
    
    

    ss0 = TRELATIVE(ss0, tile[tilenum].sl);
    st = TRELATIVE(st, tile[tilenum].tl);
    ss0 = (ss0 >> 5);
    st = (st >> 5);

    ss1 = ss0 + 1;
    ss2 = ss0 + 2;
    ss3 = ss0 + 3;

    tcmask_copy(&ss0, &ss1, &ss2, &ss3, &st, tilenum);    

    *sss0 = ss0;
    *sss1 = ss1;
    *sss2 = ss2;
    *sss3 = ss3;
    *sst = st;
}

STRICTINLINE void tc_pipeline_load(INT32* sss, INT32* sst, int tilenum, int coord_quad)
{
    int sss1 = *sss, sst1 = *sst;
    sss1 = SIGN16(sss1);
    sst1 = SIGN16(sst1);

    
    sss1 = TRELATIVE(sss1, tile[tilenum].sl);
    sst1 = TRELATIVE(sst1, tile[tilenum].tl);
    

    
    if (!coord_quad)
    {
        sss1 = (sss1 >> 5);
        sst1 = (sst1 >> 5);
    }
    else
    {
        sss1 = (sss1 >> 3);
        sst1 = (sst1 >> 3);
    }
    
    *sss = sss1;
    *sst = sst1;
}

void render_spans_1cycle_complete(int start, int end, int tilenum, int flip)
{
    UINT8 offx, offy;
    SPANSIGS sigs;
    UINT32 blend_en;
    UINT32 prewrap;
    UINT32 curpixel_cvg, curpixel_cvbit, curpixel_memcvg;
    unsigned long zbcur;

    int prim_tile = tilenum;
    int tile1 = tilenum;
    int newtile = tilenum; 
    int news, newt;

    int i, j;
    int drinc, dginc, dbinc, dainc, dzinc, dsinc, dtinc, dwinc;
    int xinc;

    int dzpix;
    int dzpixenc;

    int cdith = 7, adith = 0;
    int r, g, b, a, z, s, t, w;
    int sr, sg, sb, sa, sz, ss, st, sw;
    int xstart, xend, xendsc;
    int sss = 0, sst = 0;
    INT32 prelodfrac;
    int curpixel = 0;
    int x, length, scdiff;
    UINT32 fir, fig, fib;

    if (flip)
    {
        drinc = spans_d_rgba[0];
        dginc = spans_d_rgba[1];
        dbinc = spans_d_rgba[2];
        dainc = spans_d_rgba[3];
        dsinc = spans_d_stwz[0];
        dtinc = spans_d_stwz[1];
        dwinc = spans_d_stwz[2];
        dzinc = spans_d_stwz[3];
        xinc = 1;
    }
    else
    {
        drinc = -spans_d_rgba[0];
        dginc = -spans_d_rgba[1];
        dbinc = -spans_d_rgba[2];
        dainc = -spans_d_rgba[3];
        dsinc = -spans_d_stwz[0];
        dtinc = -spans_d_stwz[1];
        dwinc = -spans_d_stwz[2];
        dzinc = -spans_d_stwz[3];
        xinc = -1;
    }

    if (!other_modes.z_source_sel)
        dzpix = spans_dzpix;
    else
    {
        dzpix = primitive_delta_z;
        dzinc = spans_cdz = spans_d_stwz_dy[3] = 0;
    }
    dzpixenc = dz_compress(dzpix);

    for (i = start; i <= end; i++)
    {
        if (span[i].validline == 0)
            continue;
        xstart = span[i].lx;
        xend = span[i].unscrx;
        xendsc = span[i].rx;
        r = span[i].rgba[0];
        g = span[i].rgba[1];
        b = span[i].rgba[2];
        a = span[i].rgba[3];
        s = span[i].stwz[0];
        t = span[i].stwz[1];
        w = span[i].stwz[2];
        z = other_modes.z_source_sel ? primitive_z : span[i].stwz[3];

        x = xendsc;
        curpixel = fb_width * i + x;
        zbcur  = zb_address + 2*curpixel;
        zbcur &= 0x00FFFFFF;
        zbcur  = zbcur >> 1;

        if (!flip)
        {
            length = xendsc - xstart;
            scdiff = xend - xendsc;
            compute_cvg_noflip(i);
        }
        else
        {
            length = xstart - xendsc;
            scdiff = xendsc - xend;
            compute_cvg_flip(i);
        }
        sigs.longspan = (length > 7);
        sigs.midspan = (length == 7);
        sigs.onelessthanmid = (length == 6);

        if (scdiff)
        {
            r += (drinc * scdiff);
            g += (dginc * scdiff);
            b += (dbinc * scdiff);
            a += (dainc * scdiff);
            z += (dzinc * scdiff);
            s += (dsinc * scdiff);
            t += (dtinc * scdiff);
            w += (dwinc * scdiff);
        }
        sigs.startspan = 1;

        for (j = 0; j <= length; j++)
        {
            sr = r >> 14;
            sg = g >> 14;
            sb = b >> 14;
            sa = a >> 14;
            ss = s >> 16;
            st = t >> 16;
            sw = w >> 16;
            sz = (z >> 10) & 0x3fffff;

            sigs.endspan = (j == length);
            sigs.preendspan = (j == (length - 1));

            lookup_cvmask_derivatives(cvgbuf[x], &offx, &offy, &curpixel_cvg, &curpixel_cvbit);

            get_texel1_1cycle(&news, &newt, s, t, w, dsinc, dtinc, dwinc, i, &sigs);

            if (!sigs.startspan)
            {
                texel0_color = texel1_color;
                lod_frac = prelodfrac;
            }
            else
            {
                tcdiv_ptr(ss, st, sw, &sss, &sst);

                tclod_1cycle_current(&sss, &sst, news, newt, s, t, w, dsinc, dtinc, dwinc, i, prim_tile, &tile1, &sigs);
                texture_pipeline_cycle(&texel0_color, &texel0_color, sss, sst, tile1, 0);

                sigs.startspan = 0;
            }
            sigs.nextspan = sigs.endspan;
            sigs.endspan = sigs.preendspan;
            sigs.preendspan = (j == length - 2);

            s += dsinc;
            t += dtinc;
            w += dwinc;
            tclod_1cycle_next(&news, &newt, s, t, w, dsinc, dtinc, dwinc, i, prim_tile, &newtile, &sigs, &prelodfrac);
            texture_pipeline_cycle(&texel1_color, &texel1_color, news, newt, newtile, 0);

            rgbaz_correct_clip(offx, offy, sr, sg, sb, sa, &sz, curpixel_cvg);

            get_dither_noise_ptr(x, i, &cdith, &adith);
            combiner_1cycle(adith, &curpixel_cvg);
            fbread1_ptr(curpixel, &curpixel_memcvg);
            if (z_compare(zbcur, sz, dzpix, dzpixenc, &blend_en, &prewrap, &curpixel_cvg, curpixel_memcvg))
            {
                if (blender_1cycle(&fir, &fig, &fib, cdith, blend_en, prewrap, curpixel_cvg, curpixel_cvbit))
                {
                    fbwrite_ptr(curpixel, fir, fig, fib, blend_en, curpixel_cvg, curpixel_memcvg);
                    if (other_modes.z_update_en)
                        z_store(zbcur, sz, dzpixenc);
                }
            }
            r += drinc;
            g += dginc;
            b += dbinc;
            a += dainc;
            z += dzinc;
            x += xinc;
            curpixel += xinc;
            zbcur += xinc;
            zbcur &= 0x00FFFFFF >> 1;
        }
    }
    return;
}


void render_spans_1cycle_notexel1(int start, int end, int tilenum, int flip)
{
    int zbcur;
    UINT8 offx, offy;
    SPANSIGS sigs;
    UINT32 blend_en;
    UINT32 prewrap;
    UINT32 curpixel_cvg, curpixel_cvbit, curpixel_memcvg;

    int prim_tile = tilenum;
    int tile1 = tilenum;

    int i, j;

    int drinc, dginc, dbinc, dainc, dzinc, dsinc, dtinc, dwinc;
    int xinc;

    int dzpix;
    int dzpixenc;

    int cdith = 7, adith = 0;
    int r, g, b, a, z, s, t, w;
    int sr, sg, sb, sa, sz, ss, st, sw;
    int xstart, xend, xendsc;
    int sss = 0, sst = 0;
    int curpixel = 0;
    int x, length, scdiff;
    UINT32 fir, fig, fib;

    if (flip)
    {
        drinc = spans_d_rgba[0];
        dginc = spans_d_rgba[1];
        dbinc = spans_d_rgba[2];
        dainc = spans_d_rgba[3];
        dsinc = spans_d_stwz[0];
        dtinc = spans_d_stwz[1];
        dwinc = spans_d_stwz[2];
        dzinc = spans_d_stwz[3];
        xinc = 1;
    }
    else
    {
        drinc = -spans_d_rgba[0];
        dginc = -spans_d_rgba[1];
        dbinc = -spans_d_rgba[2];
        dainc = -spans_d_rgba[3];
        dsinc = -spans_d_stwz[0];
        dtinc = -spans_d_stwz[1];
        dwinc = -spans_d_stwz[2];
        dzinc = -spans_d_stwz[3];
        xinc = -1;
    }

    if (!other_modes.z_source_sel)
        dzpix = spans_dzpix;
    else
    {
        dzpix = primitive_delta_z;
        dzinc = spans_cdz = spans_d_stwz_dy[3] = 0;
    }
    dzpixenc = dz_compress(dzpix);
                    
    for (i = start; i <= end; i++)
    {
        if (span[i].validline == 0)
            continue;
        xstart = span[i].lx;
        xend = span[i].unscrx;
        xendsc = span[i].rx;
        r = span[i].rgba[0];
        g = span[i].rgba[1];
        b = span[i].rgba[2];
        a = span[i].rgba[3];
        s = span[i].stwz[0];
        t = span[i].stwz[1];
        w = span[i].stwz[2];
        z = other_modes.z_source_sel ? primitive_z : span[i].stwz[3];

        x = xendsc;
        curpixel = fb_width * i + x;
        zbcur  = zb_address + 2*curpixel;
        zbcur &= 0x00FFFFFF;
        zbcur  = zbcur >> 1;

        if (!flip)
        {
            length = xendsc - xstart;
            scdiff = xend - xendsc;
            compute_cvg_noflip(i);
        }
        else
        {
            length = xstart - xendsc;
            scdiff = xendsc - xend;
            compute_cvg_flip(i);
        }

        sigs.longspan = (length > 7);
        sigs.midspan = (length == 7);

        if (scdiff)
        {
            r += (drinc * scdiff);
            g += (dginc * scdiff);
            b += (dbinc * scdiff);
            a += (dainc * scdiff);
            z += (dzinc * scdiff);
            s += (dsinc * scdiff);
            t += (dtinc * scdiff);
            w += (dwinc * scdiff);
        }

        for (j = 0; j <= length; j++)
        {
            sr = r >> 14;
            sg = g >> 14;
            sb = b >> 14;
            sa = a >> 14;
            ss = s >> 16;
            st = t >> 16;
            sw = w >> 16;
            sz = (z >> 10) & 0x3fffff;

            sigs.endspan = (j == length);
            sigs.preendspan = (j == (length - 1));

            lookup_cvmask_derivatives(cvgbuf[x], &offx, &offy, &curpixel_cvg, &curpixel_cvbit);

            tcdiv_ptr(ss, st, sw, &sss, &sst);

            tclod_1cycle_current_simple(&sss, &sst, s, t, w, dsinc, dtinc, dwinc, i, prim_tile, &tile1, &sigs);

            texture_pipeline_cycle(&texel0_color, &texel0_color, sss, sst, tile1, 0);

            rgbaz_correct_clip(offx, offy, sr, sg, sb, sa, &sz, curpixel_cvg);

            get_dither_noise_ptr(x, i, &cdith, &adith);
            combiner_1cycle(adith, &curpixel_cvg);
                
            fbread1_ptr(curpixel, &curpixel_memcvg);
            if (z_compare(zbcur, sz, dzpix, dzpixenc, &blend_en, &prewrap, &curpixel_cvg, curpixel_memcvg))
            {
                if (blender_1cycle(&fir, &fig, &fib, cdith, blend_en, prewrap, curpixel_cvg, curpixel_cvbit))
                {
                    fbwrite_ptr(curpixel, fir, fig, fib, blend_en, curpixel_cvg, curpixel_memcvg);
                    if (other_modes.z_update_en)
                        z_store(zbcur, sz, dzpixenc);
                }
            }

            s += dsinc;
            t += dtinc;
            w += dwinc;
            r += drinc;
            g += dginc;
            b += dbinc;
            a += dainc;
            z += dzinc;
            
            x += xinc;
            curpixel += xinc;
            zbcur += xinc;
            zbcur &= 0x00FFFFFF >> 1;
        }
    }
}


void render_spans_1cycle_notex(int start, int end, int tilenum, int flip)
{
    int zbcur;
    UINT8 offx, offy;
    UINT32 blend_en;
    UINT32 prewrap;
    UINT32 curpixel_cvg, curpixel_cvbit, curpixel_memcvg;

    int i, j;

    int drinc, dginc, dbinc, dainc, dzinc;
    int xinc;

    int dzpix;
    int dzpixenc;

    int cdith = 7, adith = 0;
    int r, g, b, a, z;
    int sr, sg, sb, sa, sz;
    int xstart, xend, xendsc;
    int curpixel = 0;
    int x, length, scdiff;
    UINT32 fir, fig, fib;

    if (flip)
    {
        drinc = spans_d_rgba[0];
        dginc = spans_d_rgba[1];
        dbinc = spans_d_rgba[2];
        dainc = spans_d_rgba[3];
        dzinc = spans_d_stwz[3];
        xinc = 1;
    }
    else
    {
        drinc = -spans_d_rgba[0];
        dginc = -spans_d_rgba[1];
        dbinc = -spans_d_rgba[2];
        dainc = -spans_d_rgba[3];
        dzinc = -spans_d_stwz[3];
        xinc = -1;
    }
    
    if (!other_modes.z_source_sel)
        dzpix = spans_dzpix;
    else
    {
        dzpix = primitive_delta_z;
        dzinc = spans_cdz = spans_d_stwz_dy[3] = 0;
    }
    dzpixenc = dz_compress(dzpix);
                    
    for (i = start; i <= end; i++)
    {
        if (span[i].validline == 0)
            continue;
        xstart = span[i].lx;
        xend = span[i].unscrx;
        xendsc = span[i].rx;
        r = span[i].rgba[0];
        g = span[i].rgba[1];
        b = span[i].rgba[2];
        a = span[i].rgba[3];
        z = other_modes.z_source_sel ? primitive_z : span[i].stwz[3];

        x = xendsc;
        curpixel = fb_width * i + x;
        zbcur  = zb_address + 2*curpixel;
        zbcur &= 0x00FFFFFF;
        zbcur  = zbcur >> 1;

        if (!flip)
        {
            length = xendsc - xstart;
            scdiff = xend - xendsc;
            compute_cvg_noflip(i);
        }
        else
        {
            length = xstart - xendsc;
            scdiff = xendsc - xend;
            compute_cvg_flip(i);
        }

        if (scdiff)
        {
            r += (drinc * scdiff);
            g += (dginc * scdiff);
            b += (dbinc * scdiff);
            a += (dainc * scdiff);
            z += (dzinc * scdiff);
        }

        for (j = 0; j <= length; j++)
        {
            sr = r >> 14;
            sg = g >> 14;
            sb = b >> 14;
            sa = a >> 14;
            sz = (z >> 10) & 0x3fffff;

            lookup_cvmask_derivatives(cvgbuf[x], &offx, &offy, &curpixel_cvg, &curpixel_cvbit);

            rgbaz_correct_clip(offx, offy, sr, sg, sb, sa, &sz, curpixel_cvg);

            get_dither_noise_ptr(x, i, &cdith, &adith);
            combiner_1cycle(adith, &curpixel_cvg);
                
            fbread1_ptr(curpixel, &curpixel_memcvg);
            if (z_compare(zbcur, sz, dzpix, dzpixenc, &blend_en, &prewrap, &curpixel_cvg, curpixel_memcvg))
            {
                if (blender_1cycle(&fir, &fig, &fib, cdith, blend_en, prewrap, curpixel_cvg, curpixel_cvbit))
                {
                    fbwrite_ptr(curpixel, fir, fig, fib, blend_en, curpixel_cvg, curpixel_memcvg);
                    if (other_modes.z_update_en)
                        z_store(zbcur, sz, dzpixenc);
                }
            }
            r += drinc;
            g += dginc;
            b += dbinc;
            a += dainc;
            z += dzinc;
            
            x += xinc;
            curpixel += xinc;
            zbcur += xinc;
            zbcur &= 0x00FFFFFF >> 1;
        }
    }
}

void render_spans_2cycle_complete(int start, int end, int tilenum, int flip)
{
    int zbcur;
    UINT8 offx, offy;
    SPANSIGS sigs;
    INT32 prelodfrac;
    COLOR nexttexel1_color;
    UINT32 blend_en;
    UINT32 prewrap;
    UINT32 curpixel_cvg, curpixel_cvbit, curpixel_memcvg;

    int tile2 = (tilenum + 1) & 7;
    int tile1 = tilenum;
    int prim_tile = tilenum;

    int newtile1 = tile1;
    int newtile2 = tile2;
    int news, newt;

    int i, j;

    int drinc, dginc, dbinc, dainc, dzinc, dsinc, dtinc, dwinc;
    int xinc;

    int cdith = 7, adith = 0;
    int r, g, b, a, z, s, t, w;
    int sr, sg, sb, sa, sz, ss, st, sw;
    int xstart, xend, xendsc;
    int sss = 0, sst = 0;
    int curpixel = 0;
    
    int x, length, scdiff;
    UINT32 fir, fig, fib;

    int dzpix;
    int dzpixenc;

    if (flip)
    {
        drinc = spans_d_rgba[0];
        dginc = spans_d_rgba[1];
        dbinc = spans_d_rgba[2];
        dainc = spans_d_rgba[3];
        dsinc = spans_d_stwz[0];
        dtinc = spans_d_stwz[1];
        dwinc = spans_d_stwz[2];
        dzinc = spans_d_stwz[3];
        xinc = 1;
    }
    else
    {
        drinc = -spans_d_rgba[0];
        dginc = -spans_d_rgba[1];
        dbinc = -spans_d_rgba[2];
        dainc = -spans_d_rgba[3];
        dsinc = -spans_d_stwz[0];
        dtinc = -spans_d_stwz[1];
        dwinc = -spans_d_stwz[2];
        dzinc = -spans_d_stwz[3];
        xinc = -1;
    }

    if (!other_modes.z_source_sel)
        dzpix = spans_dzpix;
    else
    {
        dzpix = primitive_delta_z;
        dzinc = spans_cdz = spans_d_stwz_dy[3] = 0;
    }
    dzpixenc = dz_compress(dzpix);
                
    for (i = start; i <= end; i++)
    {
        if (span[i].validline == 0)
            continue;
        xstart = span[i].lx;
        xend = span[i].unscrx;
        xendsc = span[i].rx;
        r = span[i].rgba[0];
        g = span[i].rgba[1];
        b = span[i].rgba[2];
        a = span[i].rgba[3];
        s = span[i].stwz[0];
        t = span[i].stwz[1];
        w = span[i].stwz[2];
        z = other_modes.z_source_sel ? primitive_z : span[i].stwz[3];

        x = xendsc;
        curpixel = fb_width * i + x;
        zbcur  = zb_address + 2*curpixel;
        zbcur &= 0x00FFFFFF;
        zbcur  = zbcur >> 1;

        if (!flip)
        {
            length = xendsc - xstart;
            scdiff = xend - xendsc;
            compute_cvg_noflip(i);
        }
        else
        {
            length = xstart - xendsc;
            scdiff = xendsc - xend;
            compute_cvg_flip(i);
        }

        if (scdiff)
        {
            r += (drinc * scdiff);
            g += (dginc * scdiff);
            b += (dbinc * scdiff);
            a += (dainc * scdiff);
            z += (dzinc * scdiff);
            s += (dsinc * scdiff);
            t += (dtinc * scdiff);
            w += (dwinc * scdiff);
        }
        sigs.startspan = 1;

        for (j = 0; j <= length; j++)
        {
            sr = r >> 14;
            sg = g >> 14;
            sb = b >> 14;
            sa = a >> 14;
            ss = s >> 16;
            st = t >> 16;
            sw = w >> 16;
            sz = (z >> 10) & 0x3fffff;

            lookup_cvmask_derivatives(cvgbuf[x], &offx, &offy, &curpixel_cvg, &curpixel_cvbit);

            get_nexttexel0_2cycle(&news, &newt, s, t, w, dsinc, dtinc, dwinc);
            if (!sigs.startspan)
            {
                lod_frac = prelodfrac;
                texel0_color = nexttexel_color;
                texel1_color = nexttexel1_color;
            }
            else
            {
                tcdiv_ptr(ss, st, sw, &sss, &sst);

                tclod_2cycle_current(&sss, &sst, news, newt, s, t, w, dsinc, dtinc, dwinc, prim_tile, &tile1, &tile2);

                texture_pipeline_cycle(&texel0_color, &texel0_color, sss, sst, tile1, 0);
                texture_pipeline_cycle(&texel1_color, &texel0_color, sss, sst, tile2, 1);

                sigs.startspan = 0;
            }

            s += dsinc;
            t += dtinc;
            w += dwinc;

            tclod_2cycle_next(&news, &newt, s, t, w, dsinc, dtinc, dwinc, prim_tile, &newtile1, &newtile2, &prelodfrac);

            texture_pipeline_cycle(&nexttexel_color, &nexttexel_color, news, newt, newtile1, 0);
            texture_pipeline_cycle(&nexttexel1_color, &nexttexel_color, news, newt, newtile2, 1);

            rgbaz_correct_clip(offx, offy, sr, sg, sb, sa, &sz, curpixel_cvg);
            get_dither_noise_ptr(x, i, &cdith, &adith);
            combiner_2cycle(adith, &curpixel_cvg);
            fbread2_ptr(curpixel, &curpixel_memcvg);
            if (z_compare(zbcur, sz, dzpix, dzpixenc, &blend_en, &prewrap, &curpixel_cvg, curpixel_memcvg))
            {
                if (blender_2cycle(&fir, &fig, &fib, cdith, blend_en, prewrap, curpixel_cvg, curpixel_cvbit))
                {
                    fbwrite_ptr(curpixel, fir, fig, fib, blend_en, curpixel_cvg, curpixel_memcvg);
                    if (other_modes.z_update_en)
                        z_store(zbcur, sz, dzpixenc);
                    
                }
            }

            memory_color = pre_memory_color;
            pastblshifta = blshifta;
            pastblshiftb = blshiftb;
            r += drinc;
            g += dginc;
            b += dbinc;
            a += dainc;
            z += dzinc;
            
            x += xinc;
            curpixel += xinc;
            zbcur += xinc;
            zbcur &= 0x00FFFFFF >> 1;
        }
    }
}



void render_spans_2cycle_notexelnext(int start, int end, int tilenum, int flip)
{
    int zbcur;
    UINT8 offx, offy;
    UINT32 blend_en;
    UINT32 prewrap;
    UINT32 curpixel_cvg, curpixel_cvbit, curpixel_memcvg;

    int tile2 = (tilenum + 1) & 7;
    int tile1 = tilenum;
    int prim_tile = tilenum;

    int i, j;

    int drinc, dginc, dbinc, dainc, dzinc, dsinc, dtinc, dwinc;
    int xinc;

    int cdith = 7, adith = 0;
    int r, g, b, a, z, s, t, w;
    int sr, sg, sb, sa, sz, ss, st, sw;
    int xstart, xend, xendsc;
    int sss = 0, sst = 0;
    int curpixel = 0;
    
    int x, length, scdiff;
    UINT32 fir, fig, fib;

    int dzpix;
    int dzpixenc;

    if (flip)
    {
        drinc = spans_d_rgba[0];
        dginc = spans_d_rgba[1];
        dbinc = spans_d_rgba[2];
        dainc = spans_d_rgba[3];
        dsinc = spans_d_stwz[0];
        dtinc = spans_d_stwz[1];
        dwinc = spans_d_stwz[2];
        dzinc = spans_d_stwz[3];
        xinc = 1;
    }
    else
    {
        drinc = -spans_d_rgba[0];
        dginc = -spans_d_rgba[1];
        dbinc = -spans_d_rgba[2];
        dainc = -spans_d_rgba[3];
        dsinc = -spans_d_stwz[0];
        dtinc = -spans_d_stwz[1];
        dwinc = -spans_d_stwz[2];
        dzinc = -spans_d_stwz[3];
        xinc = -1;
    }

    if (!other_modes.z_source_sel)
        dzpix = spans_dzpix;
    else
    {
        dzpix = primitive_delta_z;
        dzinc = spans_cdz = spans_d_stwz_dy[3] = 0;
    }
    dzpixenc = dz_compress(dzpix);
                
    for (i = start; i <= end; i++)
    {
        if (span[i].validline == 0)
            continue;
        xstart = span[i].lx;
        xend = span[i].unscrx;
        xendsc = span[i].rx;
        r = span[i].rgba[0];
        g = span[i].rgba[1];
        b = span[i].rgba[2];
        a = span[i].rgba[3];
        s = span[i].stwz[0];
        t = span[i].stwz[1];
        w = span[i].stwz[2];
        z = other_modes.z_source_sel ? primitive_z : span[i].stwz[3];

        x = xendsc;
        curpixel = fb_width * i + x;
        zbcur  = zb_address + 2*curpixel;
        zbcur &= 0x00FFFFFF;
        zbcur  = zbcur >> 1;

        if (!flip)
        {
            length = xendsc - xstart;
            scdiff = xend - xendsc;
            compute_cvg_noflip(i);
        }
        else
        {
            length = xstart - xendsc;
            scdiff = xendsc - xend;
            compute_cvg_flip(i);
        }

        if (scdiff)
        {
            r += (drinc * scdiff);
            g += (dginc * scdiff);
            b += (dbinc * scdiff);
            a += (dainc * scdiff);
            z += (dzinc * scdiff);
            s += (dsinc * scdiff);
            t += (dtinc * scdiff);
            w += (dwinc * scdiff);
        }

        for (j = 0; j <= length; j++)
        {
            sr = r >> 14;
            sg = g >> 14;
            sb = b >> 14;
            sa = a >> 14;
            ss = s >> 16;
            st = t >> 16;
            sw = w >> 16;
            sz = (z >> 10) & 0x3fffff;

            lookup_cvmask_derivatives(cvgbuf[x], &offx, &offy, &curpixel_cvg, &curpixel_cvbit);
            
            tcdiv_ptr(ss, st, sw, &sss, &sst);

            tclod_2cycle_current_simple(&sss, &sst, s, t, w, dsinc, dtinc, dwinc, prim_tile, &tile1, &tile2);
                
            texture_pipeline_cycle(&texel0_color, &texel0_color, sss, sst, tile1, 0);
            texture_pipeline_cycle(&texel1_color, &texel0_color, sss, sst, tile2, 1);

            rgbaz_correct_clip(offx, offy, sr, sg, sb, sa, &sz, curpixel_cvg);
                    
            get_dither_noise_ptr(x, i, &cdith, &adith);
            combiner_2cycle(adith, &curpixel_cvg);
                
            fbread2_ptr(curpixel, &curpixel_memcvg);

            if (z_compare(zbcur, sz, dzpix, dzpixenc, &blend_en, &prewrap, &curpixel_cvg, curpixel_memcvg))
            {
                if (blender_2cycle(&fir, &fig, &fib, cdith, blend_en, prewrap, curpixel_cvg, curpixel_cvbit))
                {
                    fbwrite_ptr(curpixel, fir, fig, fib, blend_en, curpixel_cvg, curpixel_memcvg);
                    if (other_modes.z_update_en)
                        z_store(zbcur, sz, dzpixenc);
                }
            }

            memory_color = pre_memory_color;
            pastblshifta = blshifta;
            pastblshiftb = blshiftb;
            s += dsinc;
            t += dtinc;
            w += dwinc;
            r += drinc;
            g += dginc;
            b += dbinc;
            a += dainc;
            z += dzinc;
            
            x += xinc;
            curpixel += xinc;
            zbcur += xinc;
            zbcur &= 0x00FFFFFF >> 1;
        }
    }
}


void render_spans_2cycle_notexel1(int start, int end, int tilenum, int flip)
{
    int zbcur;
    UINT8 offx, offy;
    UINT32 blend_en;
    UINT32 prewrap;
    UINT32 curpixel_cvg, curpixel_cvbit, curpixel_memcvg;

    int tile1 = tilenum;
    int prim_tile = tilenum;

    int i, j;

    int drinc, dginc, dbinc, dainc, dzinc, dsinc, dtinc, dwinc;
    int xinc;

    int cdith = 7, adith = 0;
    int r, g, b, a, z, s, t, w;
    int sr, sg, sb, sa, sz, ss, st, sw;
    int xstart, xend, xendsc;
    int sss = 0, sst = 0;
    int curpixel = 0;
    
    int x, length, scdiff;
    UINT32 fir, fig, fib;

    int dzpix;
    int dzpixenc;

    if (flip)
    {
        drinc = spans_d_rgba[0];
        dginc = spans_d_rgba[1];
        dbinc = spans_d_rgba[2];
        dainc = spans_d_rgba[3];
        dsinc = spans_d_stwz[0];
        dtinc = spans_d_stwz[1];
        dwinc = spans_d_stwz[2];
        dzinc = spans_d_stwz[3];
        xinc = 1;
    }
    else
    {
        drinc = -spans_d_rgba[0];
        dginc = -spans_d_rgba[1];
        dbinc = -spans_d_rgba[2];
        dainc = -spans_d_rgba[3];
        dsinc = -spans_d_stwz[0];
        dtinc = -spans_d_stwz[1];
        dwinc = -spans_d_stwz[2];
        dzinc = -spans_d_stwz[3];
        xinc = -1;
    }

    if (!other_modes.z_source_sel)
        dzpix = spans_dzpix;
    else
    {
        dzpix = primitive_delta_z;
        dzinc = spans_cdz = spans_d_stwz_dy[3] = 0;
    }
    dzpixenc = dz_compress(dzpix);

    for (i = start; i <= end; i++)
    {
        if (span[i].validline == 0)
            continue;
        xstart = span[i].lx;
        xend = span[i].unscrx;
        xendsc = span[i].rx;
        r = span[i].rgba[0];
        g = span[i].rgba[1];
        b = span[i].rgba[2];
        a = span[i].rgba[3];
        s = span[i].stwz[0];
        t = span[i].stwz[1];
        w = span[i].stwz[2];
        z = other_modes.z_source_sel ? primitive_z : span[i].stwz[3];

        x = xendsc;
        curpixel = fb_width * i + x;
        zbcur  = zb_address + 2*curpixel;
        zbcur &= 0x00FFFFFF;
        zbcur  = zbcur >> 1;

        if (!flip)
        {
            length = xendsc - xstart;
            scdiff = xend - xendsc;
            compute_cvg_noflip(i);
        }
        else
        {
            length = xstart - xendsc;
            scdiff = xendsc - xend;
            compute_cvg_flip(i);
        }

        if (scdiff)
        {
            r += (drinc * scdiff);
            g += (dginc * scdiff);
            b += (dbinc * scdiff);
            a += (dainc * scdiff);
            z += (dzinc * scdiff);
            s += (dsinc * scdiff);
            t += (dtinc * scdiff);
            w += (dwinc * scdiff);
        }

        for (j = 0; j <= length; j++)
        {
            sr = r >> 14;
            sg = g >> 14;
            sb = b >> 14;
            sa = a >> 14;
            ss = s >> 16;
            st = t >> 16;
            sw = w >> 16;
            sz = (z >> 10) & 0x3fffff;

            lookup_cvmask_derivatives(cvgbuf[x], &offx, &offy, &curpixel_cvg, &curpixel_cvbit);
            
            tcdiv_ptr(ss, st, sw, &sss, &sst);

            tclod_2cycle_current_notexel1(&sss, &sst, s, t, w, dsinc, dtinc, dwinc, prim_tile, &tile1);
            
            
            texture_pipeline_cycle(&texel0_color, &texel0_color, sss, sst, tile1, 0);

            rgbaz_correct_clip(offx, offy, sr, sg, sb, sa, &sz, curpixel_cvg);
                    
            get_dither_noise_ptr(x, i, &cdith, &adith);
            combiner_2cycle(adith, &curpixel_cvg);
                
            fbread2_ptr(curpixel, &curpixel_memcvg);

            if (z_compare(zbcur, sz, dzpix, dzpixenc, &blend_en, &prewrap, &curpixel_cvg, curpixel_memcvg))
            {
                if (blender_2cycle(&fir, &fig, &fib, cdith, blend_en, prewrap, curpixel_cvg, curpixel_cvbit))
                {
                    fbwrite_ptr(curpixel, fir, fig, fib, blend_en, curpixel_cvg, curpixel_memcvg);
                    if (other_modes.z_update_en)
                        z_store(zbcur, sz, dzpixenc);
                }
            }

            memory_color = pre_memory_color;
            pastblshifta = blshifta;
            pastblshiftb = blshiftb;
            s += dsinc;
            t += dtinc;
            w += dwinc;
            r += drinc;
            g += dginc;
            b += dbinc;
            a += dainc;
            z += dzinc;
            
            x += xinc;
            curpixel += xinc;
            zbcur += xinc;
            zbcur &= 0x00FFFFFF >> 1;
        }
    }
}


void render_spans_2cycle_notex(int start, int end, int tilenum, int flip)
{
    int zbcur;
    UINT8 offx, offy;
    int i, j;
    UINT32 blend_en;
    UINT32 prewrap;
    UINT32 curpixel_cvg, curpixel_cvbit, curpixel_memcvg;

    int drinc, dginc, dbinc, dainc, dzinc;
    int xinc;

    int cdith = 7, adith = 0;
    int r, g, b, a, z;
    int sr, sg, sb, sa, sz;
    int xstart, xend, xendsc;
    int curpixel = 0;
    
    int x, length, scdiff;
    UINT32 fir, fig, fib;

    int dzpix;
    int dzpixenc;

    if (flip)
    {
        drinc = spans_d_rgba[0];
        dginc = spans_d_rgba[1];
        dbinc = spans_d_rgba[2];
        dainc = spans_d_rgba[3];
        dzinc = spans_d_stwz[3];
        xinc = 1;
    }
    else
    {
        drinc = -spans_d_rgba[0];
        dginc = -spans_d_rgba[1];
        dbinc = -spans_d_rgba[2];
        dainc = -spans_d_rgba[3];
        dzinc = -spans_d_stwz[3];
        xinc = -1;
    }

    if (!other_modes.z_source_sel)
        dzpix = spans_dzpix;
    else
    {
        dzpix = primitive_delta_z;
        dzinc = spans_cdz = spans_d_stwz_dy[3] = 0;
    }
    dzpixenc = dz_compress(dzpix);
                
    for (i = start; i <= end; i++)
    {
        if (span[i].validline == 0)
            continue;
        xstart = span[i].lx;
        xend = span[i].unscrx;
        xendsc = span[i].rx;
        r = span[i].rgba[0];
        g = span[i].rgba[1];
        b = span[i].rgba[2];
        a = span[i].rgba[3];
        z = other_modes.z_source_sel ? primitive_z : span[i].stwz[3];

        x = xendsc;
        curpixel = fb_width * i + x;
        zbcur  = zb_address + 2*curpixel;
        zbcur &= 0x00FFFFFF;
        zbcur  = zbcur >> 1;

        if (!flip)
        {
            length = xendsc - xstart;
            scdiff = xend - xendsc;
            compute_cvg_noflip(i);
        }
        else
        {
            length = xstart - xendsc;
            scdiff = xendsc - xend;
            compute_cvg_flip(i);
        }

        if (scdiff)
        {
            r += (drinc * scdiff);
            g += (dginc * scdiff);
            b += (dbinc * scdiff);
            a += (dainc * scdiff);
            z += (dzinc * scdiff);
        }

        for (j = 0; j <= length; j++)
        {
            sr = r >> 14;
            sg = g >> 14;
            sb = b >> 14;
            sa = a >> 14;
            sz = (z >> 10) & 0x3fffff;

            lookup_cvmask_derivatives(cvgbuf[x], &offx, &offy, &curpixel_cvg, &curpixel_cvbit);

            rgbaz_correct_clip(offx, offy, sr, sg, sb, sa, &sz, curpixel_cvg);
                    
            get_dither_noise_ptr(x, i, &cdith, &adith);
            combiner_2cycle(adith, &curpixel_cvg);
                
            fbread2_ptr(curpixel, &curpixel_memcvg);

            if (z_compare(zbcur, sz, dzpix, dzpixenc, &blend_en, &prewrap, &curpixel_cvg, curpixel_memcvg))
            {
                if (blender_2cycle(&fir, &fig, &fib, cdith, blend_en, prewrap, curpixel_cvg, curpixel_cvbit))
                {
                    fbwrite_ptr(curpixel, fir, fig, fib, blend_en, curpixel_cvg, curpixel_memcvg);
                    if (other_modes.z_update_en)
                        z_store(zbcur, sz, dzpixenc);
                }
            }

            memory_color = pre_memory_color;
            pastblshifta = blshifta;
            pastblshiftb = blshiftb;
            r += drinc;
            g += dginc;
            b += dbinc;
            a += dainc;
            z += dzinc;
            
            x += xinc;
            curpixel += xinc;
            zbcur += xinc;
            zbcur &= 0x00FFFFFF >> 1;
        }
    }
}

NOINLINE void render_spans_fill(int start, int end, int flip)
{
    int curpixel;
    int length;
    register int i, j;
    const int fastkillbits
      = other_modes.image_read_en | other_modes.z_compare_en;
    const int slowkillbits
      = other_modes.z_update_en & ~other_modes.z_source_sel & ~fastkillbits;

    flip = -(flip & 1);
    fbfill_ptr = fbfill_func[fb_size];
    if (fb_size == PIXEL_SIZE_4BIT)
    {
        rdp_pipeline_crashed = 1;
        return;
    }

    if (fastkillbits | slowkillbits)
    { /* branch very unlikely */
        for (i = start; i <= end; i++)
        {
            length  = span[i].rx - span[i].lx; /* end - start */
            length ^= flip;
            length -= flip;

            if (length < 0)
                continue;
            if (onetimewarnings.fillmbitcrashes == 0)
                DisplayError("render_spans_fill:  RDP crashed");
            onetimewarnings.fillmbitcrashes = 1;
            rdp_pipeline_crashed = 1;
            end = i; /* premature termination of render_spans */
            if (fastkillbits) /* left out for performance */
                DisplayError("Exact fill abort timing not implemented.");
            break;
        }
    }

    curpixel = 0;
    if (flip == 0)
    {
        for (i = start; i <= end; i++)
        {
            const int xstart = span[i].lx;
            const int xendsc = span[i].rx;

            if (span[i].validline == 0)
                continue;
            curpixel = fb_width*i + xendsc;
            length = +(xendsc - xstart);
            for (j = 0; j <= length; j++)
            {
                fbfill_ptr(curpixel);
                --curpixel;
            }
        }
    }
    else
    {
        for (i = start; i <= end; i++)
        {
            const int xstart = span[i].lx;
            const int xendsc = span[i].rx;

            if (span[i].validline == 0)
                continue;
            curpixel = fb_width*i + xendsc;
            length = -(xendsc - xstart);
            for (j = 0; j <= length; j++)
            {
                fbfill_ptr(curpixel);
                ++curpixel;
            }
        }
    }
}

NOINLINE void render_spans_copy(int start, int end, int tilenum, int flip)
{
    int i, j, k;
    
    int tile1 = tilenum;
    int prim_tile = tilenum;

    int dsinc, dtinc, dwinc;
    int xinc;

    int xstart = 0, xendsc;
    int s = 0, t = 0, w = 0, ss = 0, st = 0, sw = 0, sss = 0, sst = 0;
    int fb_index, length;

    UINT32 hidword = 0, lowdword = 0;
    int fbadvance = (fb_size == PIXEL_SIZE_4BIT) ? 8 : 16 >> fb_size;
    UINT32 fbptr = 0;
    int fbptr_advance = flip ? 8 : -8;
    UINT64 copyqword = 0;
    UINT32 tempdword = 0, tempbyte = 0;
    int copywmask = 0, alphamask = 0;
    int bytesperpixel = (fb_size == PIXEL_SIZE_4BIT) ? 1 : (1 << (fb_size - 1));
    UINT32 fbendptr = 0;
    INT32 threshold, currthreshold;

    if (fb_size == PIXEL_SIZE_32BIT)
    {
        rdp_pipeline_crashed = 1;
        return;
    }

    if (flip)
    {
        dsinc = spans_d_stwz[0];
        dtinc = spans_d_stwz[1];
        dwinc = spans_d_stwz[2];
        xinc = 1;
    }
    else
    {
        dsinc = -spans_d_stwz[0];
        dtinc = -spans_d_stwz[1];
        dwinc = -spans_d_stwz[2];
        xinc = -1;
    }

#define PIXELS_TO_BYTES_SPECIAL4(pix, siz) ((siz) ? PIXELS_TO_BYTES(pix, siz) : (pix))
                
    for (i = start; i <= end; i++)
    {
        if (span[i].validline == 0)
            continue;
        s = span[i].stwz[0];
        t = span[i].stwz[1];
        w = span[i].stwz[2];
        
        xstart = span[i].lx;
        xendsc = span[i].rx;

        fb_index = fb_width * i + xendsc;
        fbptr = fb_address + PIXELS_TO_BYTES_SPECIAL4(fb_index, fb_size);
        fbendptr = fb_address + PIXELS_TO_BYTES_SPECIAL4((fb_width * i + xstart), fb_size);
        fbptr &= 0x00FFFFFF;
        fbendptr &= 0x00FFFFFF;
        length = flip ? (xstart - xendsc) : (xendsc - xstart);

        for (j = 0; j <= length; j += fbadvance)
        {
            ss = s >> 16;
            st = t >> 16;
            sw = w >> 16;

            tcdiv_ptr(ss, st, sw, &sss, &sst);
            tclod_copy(&sss, &sst, s, t, w, dsinc, dtinc, dwinc, prim_tile, &tile1);
            fetch_qword_copy(&hidword, &lowdword, sss, sst, tile1);

            if (fb_size == PIXEL_SIZE_16BIT || fb_size == PIXEL_SIZE_8BIT)
                copyqword = ((UINT64)hidword << 32) | ((UINT64)lowdword);
            else
                copyqword = 0;
            if (!other_modes.alpha_compare_en)
                alphamask = 0xff;
            else if (fb_size == PIXEL_SIZE_16BIT)
            {
                alphamask = 0;
                alphamask |= (((copyqword >> 48) & 1) ? 0xC0 : 0);
                alphamask |= (((copyqword >> 32) & 1) ? 0x30 : 0);
                alphamask |= (((copyqword >> 16) & 1) ? 0xC : 0);
                alphamask |= ((copyqword & 1) ? 0x3 : 0);
            }
            else if (fb_size == PIXEL_SIZE_8BIT)
            {
                alphamask = 0;
                threshold = (other_modes.dither_alpha_en) ? (irand() & 0xff) : blend_color.a;
                if (other_modes.dither_alpha_en)
                {
                    currthreshold = threshold;
                    alphamask |= (((copyqword >> 24) & 0xff) >= currthreshold ? 0xC0 : 0);
                    currthreshold = ((threshold & 3) << 6) | (threshold >> 2);
                    alphamask |= (((copyqword >> 16) & 0xff) >= currthreshold ? 0x30 : 0);
                    currthreshold = ((threshold & 0xf) << 4) | (threshold >> 4);
                    alphamask |= (((copyqword >> 8) & 0xff) >= currthreshold ? 0xC : 0);
                    currthreshold = ((threshold & 0x3f) << 2) | (threshold >> 6);
                    alphamask |= ((copyqword & 0xff) >= currthreshold ? 0x3 : 0);    
                }
                else
                {
                    alphamask |= (((copyqword >> 24) & 0xff) >= threshold ? 0xC0 : 0);
                    alphamask |= (((copyqword >> 16) & 0xff) >= threshold ? 0x30 : 0);
                    alphamask |= (((copyqword >> 8) & 0xff) >= threshold ? 0xC : 0);
                    alphamask |= ((copyqword & 0xff) >= threshold ? 0x3 : 0);
                }
            }
            else
                alphamask = 0;

            copywmask  = fbptr - fbendptr;
            copywmask ^= -flip;
            copywmask -= -flip;
            copywmask += bytesperpixel;
            if (copywmask > 8) 
                copywmask = 8;
            tempdword = fbptr;
            k = 7;
            while (copywmask > 0)
            {
                tempbyte = (UINT32)((copyqword >> (k << 3)) & 0xff);
                if (alphamask & (1 << k))
                {
                    PAIRWRITE8(tempdword, tempbyte, (tempbyte & 1) ? 3 : 0);
                }
                k--;
                tempdword += xinc;
                copywmask--;
            }
            s += dsinc;
            t += dtinc;
            w += dwinc;
            fbptr += fbptr_advance;
            fbptr &= 0x00FFFFFF;
        }
    }
    return;
}

NOINLINE void loading_pipeline(
    int start, int end, int tilenum, int coord_quad, int ltlut)
{
    int i, j;

    int dsinc, dtinc;

    int s, t;
    int ss, st;
    int xstart, xend;
    int sss = 0, sst = 0;
    int ti_index, length;

    UINT32 tmemidx0 = 0, tmemidx1 = 0, tmemidx2 = 0, tmemidx3 = 0;
    int dswap = 0;
    UINT16* tmem16 = (UINT16*)TMEM;
    UINT32 readval0, readval1, readval2, readval3;
    UINT32 readidx32;
    UINT64 loadqword;
    UINT16 tempshort;
    int tmem_formatting = 0;
    UINT32 bit3fl = 0, hibit = 0;

    int tiadvance = 0, spanadvance = 0;
    unsigned long tiptr;

    dsinc = spans_d_stwz[0];
    dtinc = spans_d_stwz[1];

    if (end > start && ltlut)
    {
        rdp_pipeline_crashed = 1;
        return;
    }

    if (tile[tilenum].format == FORMAT_YUV)
        tmem_formatting = 0;
    else if (tile[tilenum].format == FORMAT_RGBA && tile[tilenum].size == PIXEL_SIZE_32BIT)
        tmem_formatting = 1;
    else
        tmem_formatting = 2;

    switch (ti_size)
    {
    case PIXEL_SIZE_4BIT:
        rdp_pipeline_crashed = 1;
        return;
        break;
    case PIXEL_SIZE_8BIT:
        tiadvance = 8;
        spanadvance = 8;
        break;
    case PIXEL_SIZE_16BIT:
        if (!ltlut)
        {
            tiadvance = 8;
            spanadvance = 4;
        }
        else
        {
            tiadvance = 2;
            spanadvance = 1;
        }
        break;
    case PIXEL_SIZE_32BIT:
        tiadvance = 8;
        spanadvance = 2;
        break;
    }

    for (i = start; i <= end; i++)
    {
        xstart = span[i].lx;
        xend = span[i].unscrx;
     /* xendsc = span[i].rx; */
        s = span[i].stwz[0];
        t = span[i].stwz[1];

        ti_index = ti_width * i + xend;
        tiptr = ti_address + PIXELS_TO_BYTES(ti_index, ti_size);
        tiptr = tiptr & 0x00FFFFFF;

        length = (xstart - xend + 1) & 0xfff;

        for (j = 0; j < length; j+= spanadvance)
        {
            ss = s >> 16;
            st = t >> 16;

            sss = ss & 0xffff;
            sst = st & 0xffff;

            tc_pipeline_load(&sss, &sst, tilenum, coord_quad);

            dswap = sst & 1;

            get_tmem_idx(sss, sst, tilenum, &tmemidx0, &tmemidx1, &tmemidx2, &tmemidx3, &bit3fl, &hibit);

            readidx32 = (tiptr >> 2) & ~1;
            readval0 = RREADIDX32(readidx32);
            readval1 = RREADIDX32(readidx32 + 1);
            readval2 = RREADIDX32(readidx32 + 2);
            readval3 = RREADIDX32(readidx32 + 3);

            switch (tiptr & 7)
            {
            case 0:
                if (!ltlut)
                    loadqword = ((UINT64)readval0 << 32) | readval1;
                else
                {
                    tempshort = readval0 >> 16;
                    loadqword = ((UINT64)tempshort << 48) | ((UINT64) tempshort << 32) | ((UINT64) tempshort << 16) | tempshort;
                }
                break;
            case 1:
                loadqword = ((UINT64)readval0 << 40) | ((UINT64)readval1 << 8) | (readval2 >> 24);
                break;
            case 2:
                if (!ltlut)
                    loadqword = ((UINT64)readval0 << 48) | ((UINT64)readval1 << 16) | (readval2 >> 16);
                else
                {
                    tempshort = readval0 & 0xffff;
                    loadqword = ((UINT64)tempshort << 48) | ((UINT64) tempshort << 32) | ((UINT64) tempshort << 16) | tempshort;
                }
                break;
            case 3:
                loadqword = ((UINT64)readval0 << 56) | ((UINT64)readval1 << 24) | (readval2 >> 8);
                break;
            case 4:
                if (!ltlut)
                    loadqword = ((UINT64)readval1 << 32) | readval2;
                else
                {
                    tempshort = readval1 >> 16;
                    loadqword = ((UINT64)tempshort << 48) | ((UINT64) tempshort << 32) | ((UINT64) tempshort << 16) | tempshort;
                }
                break;
            case 5:
                loadqword = ((UINT64)readval1 << 40) | ((UINT64)readval2 << 8) | (readval3 >> 24);
                break;
            case 6:
                if (!ltlut)
                    loadqword = ((UINT64)readval1 << 48) | ((UINT64)readval2 << 16) | (readval3 >> 16);
                else
                {
                    tempshort = readval1 & 0xffff;
                    loadqword = ((UINT64)tempshort << 48) | ((UINT64) tempshort << 32) | ((UINT64) tempshort << 16) | tempshort;
                }
                break;
            case 7:
                loadqword = ((UINT64)readval1 << 56) | ((UINT64)readval2 << 24) | (readval3 >> 8);
                break;
            }

            
            switch(tmem_formatting)
            {
            case 0:
                readval0 = (UINT32)((((loadqword >> 56) & 0xff) << 24) | (((loadqword >> 40) & 0xff) << 16) | (((loadqword >> 24) & 0xff) << 8) | (((loadqword >> 8) & 0xff) << 0));
                readval1 = (UINT32)((((loadqword >> 48) & 0xff) << 24) | (((loadqword >> 32) & 0xff) << 16) | (((loadqword >> 16) & 0xff) << 8) | (((loadqword >> 0) & 0xff) << 0));
                if (bit3fl)
                {
                    tmem16[tmemidx2 ^ WORD_ADDR_XOR] = (UINT16)(readval0 >> 16);
                    tmem16[tmemidx3 ^ WORD_ADDR_XOR] = (UINT16)(readval0 & 0xffff);
                    tmem16[(tmemidx2 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(readval1 >> 16);
                    tmem16[(tmemidx3 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(readval1 & 0xffff);
                }
                else
                {
                    tmem16[tmemidx0 ^ WORD_ADDR_XOR] = (UINT16)(readval0 >> 16);
                    tmem16[tmemidx1 ^ WORD_ADDR_XOR] = (UINT16)(readval0 & 0xffff);
                    tmem16[(tmemidx0 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(readval1 >> 16);
                    tmem16[(tmemidx1 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(readval1 & 0xffff);
                }
                break;
            case 1:
                readval0 = (UINT32)(((loadqword >> 48) << 16) | ((loadqword >> 16) & 0xffff));
                readval1 = (UINT32)((((loadqword >> 32) & 0xffff) << 16) | (loadqword & 0xffff));

                if (bit3fl)
                {
                    tmem16[tmemidx2 ^ WORD_ADDR_XOR] = (UINT16)(readval0 >> 16);
                    tmem16[tmemidx3 ^ WORD_ADDR_XOR] = (UINT16)(readval0 & 0xffff);
                    tmem16[(tmemidx2 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(readval1 >> 16);
                    tmem16[(tmemidx3 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(readval1 & 0xffff);
                }
                else
                {
                    tmem16[tmemidx0 ^ WORD_ADDR_XOR] = (UINT16)(readval0 >> 16);
                    tmem16[tmemidx1 ^ WORD_ADDR_XOR] = (UINT16)(readval0 & 0xffff);
                    tmem16[(tmemidx0 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(readval1 >> 16);
                    tmem16[(tmemidx1 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(readval1 & 0xffff);
                }
                break;
            case 2:
                if (!dswap)
                {
                    if (!hibit)
                    {
                        tmem16[tmemidx0 ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 48);
                        tmem16[tmemidx1 ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 32);
                        tmem16[tmemidx2 ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 16);
                        tmem16[tmemidx3 ^ WORD_ADDR_XOR] = (UINT16)(loadqword & 0xffff);
                    }
                    else
                    {
                        tmem16[(tmemidx0 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 48);
                        tmem16[(tmemidx1 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 32);
                        tmem16[(tmemidx2 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 16);
                        tmem16[(tmemidx3 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(loadqword & 0xffff);
                    }
                }
                else
                {
                    if (!hibit)
                    {
                        tmem16[tmemidx0 ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 16);
                        tmem16[tmemidx1 ^ WORD_ADDR_XOR] = (UINT16)(loadqword & 0xffff);
                        tmem16[tmemidx2 ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 48);
                        tmem16[tmemidx3 ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 32);
                    }
                    else
                    {
                        tmem16[(tmemidx0 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 16);
                        tmem16[(tmemidx1 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(loadqword & 0xffff);
                        tmem16[(tmemidx2 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 48);
                        tmem16[(tmemidx3 | 0x400) ^ WORD_ADDR_XOR] = (UINT16)(loadqword >> 32);
                    }
                }
            break;
            }


            s = (s + dsinc) & ~0x1f;
            t = (t + dtinc) & ~0x1f;
            tiptr += tiadvance;
            tiptr &= 0x00FFFFFF;
        }
    }
}

void edgewalker_for_loads(INT32* lewdata)
{
    int j = 0;
    int xleft = 0, xright = 0;
    int xend = 0;
    int s = 0, t = 0;
    int dsdx = 0, dtdx = 0, dtde = 0;
    int tilenum = 0;

    int spix;
    int ycur;
    int ylfar;

    INT32 maxxmx, minxhx;
    INT32 yl = 0, ym = 0, yh = 0;
    INT32 xl = 0, xm = 0, xh = 0;

    int commandcode = (lewdata[0] >> 24) & 0x3f;
    int ltlut = (commandcode == 0x30);
    int coord_quad = ltlut || (commandcode == 0x33);
        
    int k = 0;

    int valid_y = 1;
    INT32 xrsc = 0, xlsc = 0;
    INT32 yllimit;
    INT32 yhlimit;

    max_level = 0;
    tilenum = (lewdata[0] >> 16) & 7;

    yl = SIGN(lewdata[0], 14);
    ym = lewdata[1] >> 16;
    ym = SIGN(ym, 14);
    yh = SIGN(lewdata[1], 14);

    xl = SIGN(lewdata[2], 28);
    xh = SIGN(lewdata[3], 28);
    xm = SIGN(lewdata[4], 28);

    s    = lewdata[5] & 0xffff0000;
    t    = (lewdata[5] & 0xffff) << 16;
 /* w    = 0; */
    dsdx = (lewdata[7] & 0xffff0000) | ((lewdata[6] >> 16) & 0xffff);
    dtdx = ((lewdata[7] << 16) & 0xffff0000)    | (lewdata[6] & 0xffff);
    dtde = (lewdata[9] & 0xffff) << 16;

    spans_d_stwz[0] = dsdx & ~0x1f;
    spans_d_stwz[1] = dtdx & ~0x1f;
    spans_d_stwz[2] = 0;

    xright = xh & ~0x1;
    xleft = xm & ~0x1;

#define ADJUST_ATTR_LOAD() {           \
    span[j].stwz[0] = s & ~0x000003FF; \
    span[j].stwz[1] = t & ~0x000003FF; \
}

#define ADDVALUES_LOAD() { \
    t += dtde; \
}

    spix = 0;
    ycur = yh & ~3;
    ylfar = yl | 3;
    yllimit = yl;
    yhlimit = yh;

    xend = xright >> 16;

    minxhx = maxxmx = 0;
    for (k = ycur; k <= ylfar; k++)
    {
        if (k == ym)
            xleft = xl & ~1;
        spix = k & 3;
        if (!(k & ~0xfff))
        {
            j = k >> 2;
            valid_y = !(k < yhlimit || k >= yllimit);

            if (spix == 0)
            {
                maxxmx = 0;
                minxhx = 0xfff;
            }

            xrsc = (xright >> 13) & 0x7ffe;

            xlsc = (xleft >> 13) & 0x7ffe;

            if (valid_y)
            {
                maxxmx = (((xlsc >> 3) & 0xfff) > maxxmx) ? (xlsc >> 3) & 0xfff : maxxmx;
                minxhx = (((xrsc >> 3) & 0xfff) < minxhx) ? (xrsc >> 3) & 0xfff : minxhx;
            }

            if (spix == 0)
            {
                span[j].unscrx = xend;
                ADJUST_ATTR_LOAD();
            }

            if (spix == 3)
            {
                span[j].lx = maxxmx;
                span[j].rx = minxhx;
            }
        }

        if (spix == 3)
        {
            ADDVALUES_LOAD();
        }
    }

    loading_pipeline(yhlimit >> 2, yllimit >> 2, tilenum, coord_quad, ltlut);
    return;
}


static const char *const image_format[] = { "RGBA", "YUV", "CI", "IA", "I", "???", "???", "???" };
static const char *const image_size[] = { "4-bit", "8-bit", "16-bit", "32-bit" };

void deduce_derivatives()
{
    int texel1_used_in_cc1 = 0, texel0_used_in_cc1 = 0, texel0_used_in_cc0 = 0, texel1_used_in_cc0 = 0;
    int lod_frac_used_in_cc1 = 0, lod_frac_used_in_cc0 = 0;
    int lodfracused = 0;

    other_modes.f.partialreject_1cycle = (blender2b_a[0] == &inv_pixel_color.a && blender1b_a[0] == &pixel_color.a);
    other_modes.f.partialreject_2cycle = (blender2b_a[1] == &inv_pixel_color.a && blender1b_a[1] == &pixel_color.a);

    other_modes.f.special_bsel0 = (blender2b_a[0] == &memory_color.a);
    other_modes.f.special_bsel1 = (blender2b_a[1] == &memory_color.a);

    other_modes.f.rgb_alpha_dither = (other_modes.rgb_dither_sel << 2) | other_modes.alpha_dither_sel;

    if (other_modes.rgb_dither_sel == 3)
        rgb_dither_ptr = rgb_dither_func[1];
    else
        rgb_dither_ptr = rgb_dither_func[0];

    tcdiv_ptr = tcdiv_func[other_modes.persp_tex_en];

    if ((combiner_rgbmul_r[1] == &lod_frac) || (combiner_alphamul[1] == &lod_frac))
        lod_frac_used_in_cc1 = 1;
    if ((combiner_rgbmul_r[0] == &lod_frac) || (combiner_alphamul[0] == &lod_frac))
        lod_frac_used_in_cc0 = 1;

    if (combiner_rgbmul_r[1] == &texel1_color.r || combiner_rgbsub_a_r[1] == &texel1_color.r || combiner_rgbsub_b_r[1] == &texel1_color.r || combiner_rgbadd_r[1] == &texel1_color.r || \
        combiner_alphamul[1] == &texel1_color.a || combiner_alphasub_a[1] == &texel1_color.a || combiner_alphasub_b[1] == &texel1_color.a || combiner_alphaadd[1] == &texel1_color.a || \
        combiner_rgbmul_r[1] == &texel1_color.a)
        texel1_used_in_cc1 = 1;
    if (combiner_rgbmul_r[1] == &texel0_color.r || combiner_rgbsub_a_r[1] == &texel0_color.r || combiner_rgbsub_b_r[1] == &texel0_color.r || combiner_rgbadd_r[1] == &texel0_color.r || \
        combiner_alphamul[1] == &texel0_color.a || combiner_alphasub_a[1] == &texel0_color.a || combiner_alphasub_b[1] == &texel0_color.a || combiner_alphaadd[1] == &texel0_color.a || \
        combiner_rgbmul_r[1] == &texel0_color.a)
        texel0_used_in_cc1 = 1;
    if (combiner_rgbmul_r[0] == &texel1_color.r || combiner_rgbsub_a_r[0] == &texel1_color.r || combiner_rgbsub_b_r[0] == &texel1_color.r || combiner_rgbadd_r[0] == &texel1_color.r || \
        combiner_alphamul[0] == &texel1_color.a || combiner_alphasub_a[0] == &texel1_color.a || combiner_alphasub_b[0] == &texel1_color.a || combiner_alphaadd[0] == &texel1_color.a || \
        combiner_rgbmul_r[0] == &texel1_color.a)
        texel1_used_in_cc0 = 1;
    if (combiner_rgbmul_r[0] == &texel0_color.r || combiner_rgbsub_a_r[0] == &texel0_color.r || combiner_rgbsub_b_r[0] == &texel0_color.r || combiner_rgbadd_r[0] == &texel0_color.r || \
        combiner_alphamul[0] == &texel0_color.a || combiner_alphasub_a[0] == &texel0_color.a || combiner_alphasub_b[0] == &texel0_color.a || combiner_alphaadd[0] == &texel0_color.a || \
        combiner_rgbmul_r[0] == &texel0_color.a)
        texel0_used_in_cc0 = 1;
 /* texels_in_cc0 = texel0_used_in_cc0 || texel1_used_in_cc0; */
 /* texels_in_cc1 = texel0_used_in_cc1 || texel1_used_in_cc1; */

    
    if (texel1_used_in_cc1)
        render_spans_1cycle_ptr = render_spans_1cycle_func[2];
    else if (texel0_used_in_cc1 || lod_frac_used_in_cc1)
        render_spans_1cycle_ptr = render_spans_1cycle_func[1];
    else
        render_spans_1cycle_ptr = render_spans_1cycle_func[0];

    if (texel1_used_in_cc1)
        render_spans_2cycle_ptr = render_spans_2cycle_func[3];
    else if (texel1_used_in_cc0 || texel0_used_in_cc1)
        render_spans_2cycle_ptr = render_spans_2cycle_func[2];
    else if (texel0_used_in_cc0 || lod_frac_used_in_cc0 || lod_frac_used_in_cc1)
        render_spans_2cycle_ptr = render_spans_2cycle_func[1];
    else
        render_spans_2cycle_ptr = render_spans_2cycle_func[0];

    if ((other_modes.cycle_type == CYCLE_TYPE_2 && (lod_frac_used_in_cc0 || lod_frac_used_in_cc1)) || \
        (other_modes.cycle_type == CYCLE_TYPE_1 && lod_frac_used_in_cc1))
        lodfracused = 1;

    if ((other_modes.cycle_type == CYCLE_TYPE_1 && combiner_rgbsub_a_r[1] == &noise) || \
        (other_modes.cycle_type == CYCLE_TYPE_2 && (combiner_rgbsub_a_r[0] == &noise || combiner_rgbsub_a_r[1] == &noise)) || \
        other_modes.alpha_dither_sel == 2)
        get_dither_noise_ptr = get_dither_noise_func[0];
    else if (other_modes.f.rgb_alpha_dither != 0xf)
        get_dither_noise_ptr = get_dither_noise_func[1];
    else
        get_dither_noise_ptr = get_dither_noise_func[2];

    other_modes.f.dolod = other_modes.tex_lod_en || lodfracused;
    return;
}

void tile_tlut_common_cs_decoder(UINT32 w1, UINT32 w2)
{
    INT32 lewdata[10];
    int tilenum = (w2 >> 24) & 0x7;
    int sl, tl, sh, th;

    tile[tilenum].sl = sl = ((w1 >> 12) & 0xfff);
    tile[tilenum].tl = tl = ((w1 >>  0) & 0xfff);
    tile[tilenum].sh = sh = ((w2 >> 12) & 0xfff);
    tile[tilenum].th = th = ((w2 >>  0) & 0xfff);

    calculate_clamp_diffs(tilenum);

    lewdata[0] = (w1 & 0xff000000) | (0x10 << 19) | (tilenum << 16) | (th | 3);
    lewdata[1] = ((th | 3) << 16) | (tl);
    lewdata[2] = ((sh >> 2) << 16) | ((sh & 3) << 14);
    lewdata[3] = ((sl >> 2) << 16) | ((sl & 3) << 14);
    lewdata[4] = ((sh >> 2) << 16) | ((sh & 3) << 14);
    lewdata[5] = ((sl << 3) << 16) | (tl << 3);
    lewdata[6] = 0;
    lewdata[7] = (0x200 >> ti_size) << 16;
    lewdata[8] = 0x20;
    lewdata[9] = 0x20;

    edgewalker_for_loads(lewdata);
    return;
}

STRICTINLINE INT32 irand(void)
{
    iseed *= 0x343fd;
    iseed += 0x269ec3;
    return ((iseed >> 16) & 0x7fff);
}

STRICTINLINE int alpha_compare(INT32 comb_alpha)
{
    INT32 threshold;

    if (!other_modes.alpha_compare_en)
        return 1;
    else
    {
        if (!other_modes.dither_alpha_en)
            threshold = blend_color.a;
        else
            threshold = irand() & 0xff;
        if (comb_alpha >= threshold)
            return 1;
        else
            return 0;
    }
}

STRICTINLINE INT32 color_combiner_equation(INT32 a, INT32 b, INT32 c, INT32 d)
{
    a = special_9bit_exttable[a];
    b = special_9bit_exttable[b];
    c = SIGNF(c, 9);
    d = special_9bit_exttable[d];
    a = ((a - b) * c) + (d << 8) + 0x80;
    return (a & 0x1ffff);
}

STRICTINLINE INT32 alpha_combiner_equation(INT32 a, INT32 b, INT32 c, INT32 d)
{
    a = special_9bit_exttable[a];
    b = special_9bit_exttable[b];
    c = SIGNF(c, 9);
    d = special_9bit_exttable[d];
    a = (((a - b) * c) + (d << 8) + 0x80) >> 8;
    return (a & 0x1ff);
}


STRICTINLINE void blender_equation_cycle0(int* r, int* g, int* b)
{
    int blend1a, blend2a;
    int blr, blg, blb, sum;
    int mulb;

    blend1a = *blender1b_a[0] >> 3;
    blend2a = *blender2b_a[0] >> 3;

    if (other_modes.f.special_bsel0)
    {
        blend1a = (blend1a >> blshifta) & 0x3C;
        blend2a = (blend2a >> blshiftb) | 3;
    }
    mulb = blend2a + 1;

    blr = (*blender1a_r[0]) * blend1a + (*blender2a_r[0]) * mulb;
    blg = (*blender1a_g[0]) * blend1a + (*blender2a_g[0]) * mulb;
    blb = (*blender1a_b[0]) * blend1a + (*blender2a_b[0]) * mulb;

    if (!other_modes.force_blend)
    {
        sum = ((blend1a & ~3) + (blend2a & ~3) + 4) << 9;
        *r = bldiv_hwaccurate_table[sum | ((blr >> 2) & 0x7ff)];
        *g = bldiv_hwaccurate_table[sum | ((blg >> 2) & 0x7ff)];
        *b = bldiv_hwaccurate_table[sum | ((blb >> 2) & 0x7ff)];
    }
    else
    {
        *r = (blr >> 5) & 0xff;    
        *g = (blg >> 5) & 0xff; 
        *b = (blb >> 5) & 0xff;
    }    
}

STRICTINLINE void blender_equation_cycle0_2(int* r, int* g, int* b)
{
    int blend1a, blend2a;
    blend1a = *blender1b_a[0] >> 3;
    blend2a = *blender2b_a[0] >> 3;

    if (other_modes.f.special_bsel0)
    {
        blend1a = (blend1a >> pastblshifta) & 0x3C;
        blend2a = (blend2a >> pastblshiftb) | 3;
    }
    blend2a += 1;
    *r = (((*blender1a_r[0]) * blend1a + (*blender2a_r[0]) * blend2a) >> 5) & 0xff;
    *g = (((*blender1a_g[0]) * blend1a + (*blender2a_g[0]) * blend2a) >> 5) & 0xff;
    *b = (((*blender1a_b[0]) * blend1a + (*blender2a_b[0]) * blend2a) >> 5) & 0xff;
}

STRICTINLINE void blender_equation_cycle1(int* r, int* g, int* b)
{
    int blend1a, blend2a;
    int blr, blg, blb, sum;
    int mulb;

    blend1a = *blender1b_a[1] >> 3;
    blend2a = *blender2b_a[1] >> 3;

    if (other_modes.f.special_bsel1)
    {
        blend1a = (blend1a >> blshifta) & 0x3C;
        blend2a = (blend2a >> blshiftb) | 3;
    }
    mulb = blend2a + 1;
    blr = (*blender1a_r[1]) * blend1a + (*blender2a_r[1]) * mulb;
    blg = (*blender1a_g[1]) * blend1a + (*blender2a_g[1]) * mulb;
    blb = (*blender1a_b[1]) * blend1a + (*blender2a_b[1]) * mulb;

    if (!other_modes.force_blend)
    {
        sum = ((blend1a & ~3) + (blend2a & ~3) + 4) << 9;
        *r = bldiv_hwaccurate_table[sum | ((blr >> 2) & 0x7ff)];
        *g = bldiv_hwaccurate_table[sum | ((blg >> 2) & 0x7ff)];
        *b = bldiv_hwaccurate_table[sum | ((blb >> 2) & 0x7ff)];
    }
    else
    {
        *r = (blr >> 5) & 0xff;    
        *g = (blg >> 5) & 0xff; 
        *b = (blb >> 5) & 0xff;
    }
}

STRICTINLINE UINT32 rightcvghex(UINT32 x, UINT32 fmask)
{
    UINT32 covered = ((x & 7) + 1) >> 1;

    covered = 0xf0 >> covered;
    return (covered & fmask);
}

STRICTINLINE UINT32 leftcvghex(UINT32 x, UINT32 fmask) 
{
    UINT32 covered = ((x & 7) + 1) >> 1;

    covered = 0xf >> covered;
    return (covered & fmask);
}

STRICTINLINE void compute_cvg_flip(INT32 scanline)
{
    INT32 purgestart, purgeend;
    int i, k, length, fmask, maskshift, fmaskshifted;
    INT32 minorcur, majorcur, minorcurint, majorcurint, samecvg;

    purgestart = span[scanline].rx;
    purgeend = span[scanline].lx;
    length = purgeend - purgestart;
    if (length >= 0)
    {
        memfill(&cvgbuf[purgestart], 0xFF, length + 1);
        for (i = 0; i < 4; i++)
        {
            fmask = 0xA >> (i & 1);
            maskshift = (i - 2) & 4;
            fmaskshifted = fmask << maskshift;

            if (!span[scanline].invalyscan[i])
            {
                minorcur = span[scanline].minorx[i];
                majorcur = span[scanline].majorx[i];
                minorcurint = minorcur >> 3;
                majorcurint = majorcur >> 3;

                for (k = purgestart; k <= majorcurint; k++)
                    cvgbuf[k] &= ~fmaskshifted;
                for (k = minorcurint; k <= purgeend; k++)
                    cvgbuf[k] &= ~fmaskshifted;

                if (minorcurint != majorcurint)
                {
                    cvgbuf[minorcurint] |= (rightcvghex(minorcur, fmask) << maskshift);
                    cvgbuf[majorcurint] |= (leftcvghex(majorcur, fmask) << maskshift);
                }
                else
                {
                    samecvg = rightcvghex(minorcur, fmask) & leftcvghex(majorcur, fmask);
                    cvgbuf[majorcurint] |= (samecvg << maskshift);
                }
            }
            else
            {
                for (k = purgestart; k <= purgeend; k++)
                    cvgbuf[k] &= ~fmaskshifted;
            }
        }
    }
}

STRICTINLINE void compute_cvg_noflip(INT32 scanline)
{
    INT32 purgestart, purgeend;
    int i, k, length, fmask, maskshift, fmaskshifted;
    INT32 minorcur, majorcur, minorcurint, majorcurint, samecvg;
    
    purgestart = span[scanline].lx;
    purgeend = span[scanline].rx;
    length = purgeend - purgestart;

    if (length >= 0)
    {
        memfill(&cvgbuf[purgestart], 0xFF, length + 1);

        for (i = 0; i < 4; i++)
        {
            fmask = 0xA >> (i & 1);
            maskshift = (i - 2) & 4;
            fmaskshifted = fmask << maskshift;

            if (!span[scanline].invalyscan[i])
            {
                minorcur = span[scanline].minorx[i];
                majorcur = span[scanline].majorx[i];
                minorcurint = minorcur >> 3;
                majorcurint = majorcur >> 3;

                for (k = purgestart; k <= minorcurint; k++)
                    cvgbuf[k] &= ~fmaskshifted;
                for (k = majorcurint; k <= purgeend; k++)
                    cvgbuf[k] &= ~fmaskshifted;

                if (minorcurint != majorcurint)
                {
                    cvgbuf[minorcurint] |= (leftcvghex(minorcur, fmask) << maskshift);
                    cvgbuf[majorcurint] |= (rightcvghex(majorcur, fmask) << maskshift);
                }
                else
                {
                    samecvg = leftcvghex(minorcur, fmask) & rightcvghex(majorcur, fmask);
                    cvgbuf[majorcurint] |= (samecvg << maskshift);
                }
            }
            else
            {
                for (k = purgestart; k <= purgeend; k++)
                    cvgbuf[k] &= ~fmaskshifted;
            }
        }
    }
}

void fbwrite_4(
    UINT32 curpixel, UINT32 r, UINT32 g, UINT32 b, UINT32 blend_en,
    UINT32 curpixel_cvg, UINT32 curpixel_memcvg)
{
    register unsigned long addr;

    addr  = fb_address + curpixel*1;
    addr &= 0x00FFFFFF;

    RWRITEADDR8(addr, 0x00);
    return;
}

void fbwrite_8(
    UINT32 curpixel, UINT32 r, UINT32 g, UINT32 b, UINT32 blend_en,
    UINT32 curpixel_cvg, UINT32 curpixel_memcvg)
{
    register unsigned long addr;

    addr  = fb_address + 1*curpixel;
    addr &= 0x00FFFFFF;
    PAIRWRITE8(addr, r, (r & 1) ? 3 : 0);
    return;
}

void fbwrite_16(
    UINT32 curpixel, UINT32 r, UINT32 g, UINT32 b, UINT32 blend_en,
    UINT32 curpixel_cvg, UINT32 curpixel_memcvg)
{
    u16 color;
    int coverage;
    register unsigned long addr;

    coverage = finalize_spanalpha(blend_en, curpixel_cvg, curpixel_memcvg);
#undef CVG_DRAW
#ifdef CVG_DRAW
    const int covdraw = (curpixel_cvg - 1) << 5;

    r = covdraw;
    g = covdraw;
    b = covdraw;
#endif
    if (fb_format != FORMAT_RGBA)
    {
        color = (r << 8) | (coverage << 5);
        coverage = 0x00;
    }
    else
    {
        r &= 0xFF & ~7;
        g &= 0xFF & ~7;
        b &= 0xFF & ~7;
        color = (r << 8) | (g << 3) | (b >> 2) | (coverage >> 2);
    }

    addr  = fb_address + 2*curpixel;
    addr &= 0x00FFFFFF;
    addr  = addr >> 1;
    PAIRWRITE16(addr, color, coverage & 3);
    return;
}

void fbwrite_32(
    UINT32 curpixel, UINT32 r, UINT32 g, UINT32 b, UINT32 blend_en,
    UINT32 curpixel_cvg, UINT32 curpixel_memcvg)
{
    u32 color;
    int coverage;
    register unsigned long addr;

    addr  = fb_address + 4*curpixel;
    addr &= 0x00FFFFFF;
    addr  = addr >> 2;

    coverage = finalize_spanalpha(blend_en, curpixel_cvg, curpixel_memcvg);
    color  = (r << 24) | (g << 16) | (b <<  8);
    color |= (coverage << 5);

    g = -(signed)(g & 1) & 3;
    PAIRWRITE32(addr, color, g, 0);
    return;
}

void fbfill_4(UINT32 curpixel)
{
    rdp_pipeline_crashed = 1;
    return;
}

void fbfill_8(UINT32 curpixel)
{
    unsigned char source;
    register unsigned long addr;

    addr  = fb_address + 1*curpixel;
    addr &= 0x00FFFFFF;

    source = (fill_color >> 8*(~addr & 3)) & 0xFF;
    PAIRWRITE8(addr, source, -(source & 1) & 3);
    return;
}

void fbfill_16(UINT32 curpixel)
{
    register unsigned long addr;
    register unsigned short source;

    addr  = fb_address + 2*curpixel;
    addr &= 0x00FFFFFF;
    addr  = addr >> 1;

    source = fill_color>>16*(~addr & 1) & 0xFFFF;
    PAIRWRITE16(addr, source, -(source & 1) & 3);
    return;
}

void fbfill_32(UINT32 curpixel)
{
    register unsigned long addr;
    const unsigned short fill_color_hi = (fill_color >> 16) & 0xFFFF;
    const unsigned short fill_color_lo = (fill_color >>  0) & 0xFFFF;

    addr  = fb_address + 4*curpixel;
    addr &= 0x00FFFFFF;
    addr  = addr >> 2;
    PAIRWRITE32(addr, fill_color,
        -(fill_color_hi & 0x0001) & 3, -(fill_color_lo & 0x0001) & 3);
    return;
}

void fbread_4(UINT32 curpixel, UINT32* curpixel_memcvg)
{
    memory_color.r = memory_color.g = memory_color.b = 0x00;
    memory_color.a = 0xE0;
    *curpixel_memcvg = 7;
    return;
}

void fbread2_4(UINT32 curpixel, UINT32* curpixel_memcvg)
{
    pre_memory_color.r = pre_memory_color.g = pre_memory_color.b = 0x00;
    pre_memory_color.a = 0xE0;
    *curpixel_memcvg = 7;
    return;
}

void fbread_8(UINT32 curpixel, UINT32* curpixel_memcvg)
{
    u8 color;
    register unsigned long addr;

    addr  = fb_address + 1*curpixel;
    addr &= 0x00FFFFFF;
    color = RREADADDR8(addr);

    memory_color.r = color;
    memory_color.g = color;
    memory_color.b = color;
    memory_color.a = 0xE0;
    *curpixel_memcvg = 7;
    return;
}

void fbread2_8(UINT32 curpixel, UINT32* curpixel_memcvg)
{
    u8 color;
    register unsigned long addr;

    addr  = fb_address + 1*curpixel;
    addr &= 0x00FFFFFF;
    color = RREADADDR8(addr);

    pre_memory_color.r = color;
    pre_memory_color.g = color;
    pre_memory_color.b = color;
    pre_memory_color.a = 0xE0;
    *curpixel_memcvg = 7;
    return;
}

void fbread_16(UINT32 curpixel, UINT32* curpixel_memcvg)
{
    u16 color;
    u8 hidden;
    register unsigned long addr;

    addr  = (fb_address + 2*curpixel) >> 1;
    addr &= 0x00FFFFFFUL >> 1;

    if (other_modes.image_read_en == 0)
    {
        color = RREADIDX16(addr);
        *curpixel_memcvg = ~0;
    }
    else
    {
        PAIRREAD16(color, hidden, addr);
        *curpixel_memcvg = 4*color + hidden;
    }
    *curpixel_memcvg &= 0x07;
    memory_color.a = *curpixel_memcvg << 5;

    if (fb_format != FORMAT_RGBA)
    {
        memory_color.r = color >> 8;
        memory_color.g = color >> 8;
        memory_color.b = color >> 8;
    }
    else
    {
        memory_color.r = GET_HI(color);
        memory_color.g = GET_MED(color);
        memory_color.b = GET_LOW(color);
    }
    return;
}

void fbread2_16(UINT32 curpixel, UINT32* curpixel_memcvg)
{
    u16 color;
    u8 hidden;
    register unsigned long addr;

    addr  = (fb_address + 2*curpixel) >> 1;
    addr &= 0x00FFFFFFUL >> 1;

    if (other_modes.image_read_en == 0)
    {
        color = RREADIDX16(addr);
        *curpixel_memcvg = ~0;
    }
    else
    {
        PAIRREAD16(color, hidden, addr);
        *curpixel_memcvg = 4*color + hidden;
    }
    *curpixel_memcvg &= 0x07;
    pre_memory_color.a = *curpixel_memcvg << 5;

    if (fb_format != FORMAT_RGBA)
    {
        pre_memory_color.r = color >> 8;
        pre_memory_color.g = color >> 8;
        pre_memory_color.b = color >> 8;
    }
    else
    {
        pre_memory_color.r = GET_HI(color);
        pre_memory_color.g = GET_MED(color);
        pre_memory_color.b = GET_LOW(color);
    }
    return;
}

void fbread_32(UINT32 curpixel, UINT32* curpixel_memcvg)
{
    u32 color;
    register unsigned long addr;

    addr  = fb_address + 4*curpixel;
    addr &= 0x00FFFFFF;
    addr  = addr >> 2;
    color = RREADIDX32(addr);

    memory_color.r = (color >> 24) & 0xFF;
    memory_color.g = (color >> 16) & 0xFF;
    memory_color.b = (color >>  8) & 0xFF;

    memory_color.a  = (color >>  0) & 0xFF;
    memory_color.a |= ~(-other_modes.image_read_en);
    memory_color.a &= 0xE0;

    *curpixel_memcvg = (unsigned char)(memory_color.a) >> 5;
    return;
}

void fbread2_32(UINT32 curpixel, UINT32* curpixel_memcvg)
{
    u32 color;
    register unsigned long addr;

    addr  = fb_address + 4*curpixel;
    addr &= 0x00FFFFFF;
    addr  = addr >> 2;
    color = RREADIDX32(addr);

    pre_memory_color.r = (color >> 24) & 0xFF;
    pre_memory_color.g = (color >> 16) & 0xFF;
    pre_memory_color.b = (color >>  8) & 0xFF;

    pre_memory_color.a  = (color >>  0) & 0xFF;
    pre_memory_color.a |= ~(-other_modes.image_read_en);
    pre_memory_color.a &= 0xE0;

    *curpixel_memcvg = (unsigned char)(pre_memory_color.a) >> 5;
    return;
}

STRICTINLINE UINT32 z_decompress(UINT32 zb)
{
    zb &= 0x0000FFFF;
    return (z_complete_dec_table[zb >> 2]);
}

INLINE void z_build_com_table(void)
{
    register int z;
    UINT16 altmem = 0;

    for (z = 0; z < 0x40000; z++)
    {
    switch((z >> 11) & 0x7f)
    {
    case 0x00:
    case 0x01:
    case 0x02:
    case 0x03:
    case 0x04:
    case 0x05:
    case 0x06:
    case 0x07:
    case 0x08:
    case 0x09:
    case 0x0a:
    case 0x0b:
    case 0x0c:
    case 0x0d:
    case 0x0e:
    case 0x0f:
    case 0x10:
    case 0x11:
    case 0x12:
    case 0x13:
    case 0x14:
    case 0x15:
    case 0x16:
    case 0x17:
    case 0x18:
    case 0x19:
    case 0x1a:
    case 0x1b:
    case 0x1c:
    case 0x1d:
    case 0x1e:
    case 0x1f:
    case 0x20:
    case 0x21:
    case 0x22:
    case 0x23:
    case 0x24:
    case 0x25:
    case 0x26:
    case 0x27:
    case 0x28:
    case 0x29:
    case 0x2a:
    case 0x2b:
    case 0x2c:
    case 0x2d:
    case 0x2e:
    case 0x2f:
    case 0x30:
    case 0x31:
    case 0x32:
    case 0x33:
    case 0x34:
    case 0x35:
    case 0x36:
    case 0x37:
    case 0x38:
    case 0x39:
    case 0x3a:
    case 0x3b:
    case 0x3c:
    case 0x3d:
    case 0x3e:
    case 0x3f:
        altmem = (z >> 4) & 0x1ffc;
        break;
    case 0x40:
    case 0x41:
    case 0x42:
    case 0x43:
    case 0x44:
    case 0x45:
    case 0x46:
    case 0x47:
    case 0x48:
    case 0x49:
    case 0x4a:
    case 0x4b:
    case 0x4c:
    case 0x4d:
    case 0x4e:
    case 0x4f:
    case 0x50:
    case 0x51:
    case 0x52:
    case 0x53:
    case 0x54:
    case 0x55:
    case 0x56:
    case 0x57:
    case 0x58:
    case 0x59:
    case 0x5a:
    case 0x5b:
    case 0x5c:
    case 0x5d:
    case 0x5e:
    case 0x5f:
        altmem = ((z >> 3) & 0x1ffc) | 0x2000;
        break;
    case 0x60:
    case 0x61:
    case 0x62:
    case 0x63:
    case 0x64:
    case 0x65:
    case 0x66:
    case 0x67:
    case 0x68:
    case 0x69:
    case 0x6a:
    case 0x6b:
    case 0x6c:
    case 0x6d:
    case 0x6e:
    case 0x6f:
        altmem = ((z >> 2) & 0x1ffc) | 0x4000;
        break;
    case 0x70:
    case 0x71:
    case 0x72:
    case 0x73:
    case 0x74:
    case 0x75:
    case 0x76:
    case 0x77:
        altmem = ((z >> 1) & 0x1ffc) | 0x6000;
        break;
    case 0x78:
    case 0x79:
    case 0x7a:
    case 0x7b:
        altmem = (z & 0x1ffc) | 0x8000;
        break;
    case 0x7c:
    case 0x7d:
        altmem = ((z << 1) & 0x1ffc) | 0xa000;
        break;
    case 0x7e:
        altmem = ((z << 2) & 0x1ffc) | 0xc000;
        break;
    case 0x7f:
        altmem = ((z << 2) & 0x1ffc) | 0xe000;
        break;
    default:
        DisplayError("z_build_com_table failed");
        break;
    }

    z_com_table[z] = altmem;

    }
}

INLINE void precalc_cvmask_derivatives(void)
{
    int i = 0, k = 0;
    UINT16 mask = 0, maskx = 0, masky = 0;
    UINT8 offx = 0, offy = 0;
    const UINT8 yarray[16] = {0, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0};
    const UINT8 xarray[16] = {0, 3, 2, 2, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0};

    
    for (; i < 0x100; i++)
    {
        mask = decompress_cvmask_frombyte(i);
        cvarray[i].cvg = cvarray[i].cvbit = 0;
        cvarray[i].cvbit = (i >> 7) & 1;
        for (k = 0; k < 8; k++)
            cvarray[i].cvg += ((i >> k) & 1);

        
        masky = maskx = offx = offy = 0;
        for (k = 0; k < 4; k++)
            masky |= ((mask & (0xf000 >> (k << 2))) > 0) << k;

        offy = yarray[masky];
        
        maskx = (mask & (0xf000 >> (offy << 2))) >> ((offy ^ 3) << 2);
        
        
        offx = xarray[maskx];
        
        cvarray[i].xoff = offx;
        cvarray[i].yoff = offy;
    }
}

STRICTINLINE UINT16 decompress_cvmask_frombyte(UINT8 x)
{
    UINT16 y = (x & 1) | ((x & 2) << 4) | (x & 4) | ((x & 8) << 4) |
        ((x & 0x10) << 4) | ((x & 0x20) << 8) | ((x & 0x40) << 4) | ((x & 0x80) << 8);
    return y;
}

STRICTINLINE void lookup_cvmask_derivatives(UINT32 mask, UINT8* offx, UINT8* offy, UINT32* curpixel_cvg, UINT32* curpixel_cvbit)
{
    CVtcmaskDERIVATIVE temp = cvarray[mask];
    *curpixel_cvg = temp.cvg;
    *curpixel_cvbit = temp.cvbit;
    *offx = temp.xoff;
    *offy = temp.yoff;
}

STRICTINLINE void z_store(UINT32 zcurpixel, UINT32 z, int dzpixenc)
{
    UINT16 zval = z_com_table[z & 0x3ffff]|(dzpixenc >> 2);
    UINT8 hval = dzpixenc & 3;
    PAIRWRITE16(zcurpixel, zval, hval);
}

STRICTINLINE UINT32 dz_decompress(UINT32 dz_compressed)
{
    return (1 << dz_compressed);
}

STRICTINLINE UINT32 dz_compress(UINT32 value)
{
    int j = 0;
    if (value & 0xff00)
        j |= 8;
    if (value & 0xf0f0)
        j |= 4;
    if (value & 0xcccc)
        j |= 2;
    if (value & 0xaaaa)
        j |= 1;
    return j;
}

STRICTINLINE UINT32 z_compare(UINT32 zcurpixel, UINT32 sz, UINT16 dzpix, int dzpixenc, UINT32* blend_en, UINT32* prewrap, UINT32* curpixel_cvg, UINT32 curpixel_memcvg)
{
    int cvgcoeff = 0;
    UINT32 dzenc = 0;
    
    INT32 diff;
    UINT32 nearer, max, infront;
    int force_coplanar = 0;

    UINT32 oz, dzmem, zval, hval;
    INT32 rawdzmem;

    sz &= 0x3ffff;
    if (other_modes.z_compare_en)
    {
        UINT32 dznew;
        UINT32 dznotshift;
        UINT32 dzmemmodifier;
        UINT32 farther;
        int overflow;
        int precision_factor;

        PAIRREAD16(zval, hval, zcurpixel);
        oz = z_decompress(zval);
        rawdzmem = ((zval & 3) << 2) | hval;
        dzmem = dz_decompress(rawdzmem);

        blshifta = CLIP(dzpixenc - rawdzmem, 0, 4);
        blshiftb = CLIP(rawdzmem - dzpixenc, 0, 4);

        precision_factor = (zval >> 13) & 0xf;

        if (precision_factor < 3)
        {
            if (dzmem != 0x8000)
            {
                dzmemmodifier = 16 >> precision_factor;
                dzmem <<= 1;
                if (dzmem <= dzmemmodifier)
                    dzmem = dzmemmodifier;
            }
            else
            {
                force_coplanar = 1;
                dzmem <<= 1;
            }
            
        }
        if (dzmem > 0x8000)
            dzmem = 0xffff;

        dznew = (dzmem > dzpix) ? dzmem : (UINT32)dzpix;
        dznotshift = dznew;
        dznew <<= 3;
        

        farther = force_coplanar || ((sz + dznew) >= oz);
        
        overflow = (curpixel_memcvg + *curpixel_cvg) & 8;
        *blend_en = other_modes.force_blend || (!overflow && other_modes.antialias_en && farther);
        
        *prewrap = overflow;

        switch(other_modes.z_mode)
        {
        case ZMODE_OPAQUE: 
            infront = sz < oz;
            diff = (INT32)sz - (INT32)dznew;
            nearer = force_coplanar || (diff <= (INT32)oz);
            max = (oz == 0x3ffff);
            return (max || (overflow ? infront : nearer));
            break;
        case ZMODE_INTERPENETRATING: 
            infront = sz < oz;
            if (!infront || !farther || !overflow)
            {
                diff = (INT32)sz - (INT32)dznew;
                nearer = force_coplanar || (diff <= (INT32)oz);
                max = (oz == 0x3ffff);
                return (max || (overflow ? infront : nearer)); 
            }
            else
            {
                dzenc = dz_compress(dznotshift & 0xffff);
                cvgcoeff = ((oz >> dzenc) - (sz >> dzenc)) & 0xf;
                *curpixel_cvg = ((cvgcoeff * (*curpixel_cvg)) >> 3) & 0xf;
                return 1;
            }
            break;
        case ZMODE_TRANSPARENT: 
            infront = sz < oz;
            max = (oz == 0x3ffff);
            return (infront || max); 
            break;
        case ZMODE_DECAL: 
            diff = (INT32)sz - (INT32)dznew;
            nearer = force_coplanar || (diff <= (INT32)oz);
            max = (oz == 0x3ffff);
            return (farther && nearer && !max); 
            break;
        }
        return 0;
    }
    else
    {
        int overflow = (curpixel_memcvg + *curpixel_cvg) & 8;

        blshifta = CLIP(dzpixenc - 0xf, 0, 4);
        blshiftb = CLIP(0xf - dzpixenc, 0, 4);

        *blend_en = other_modes.force_blend || (!overflow && other_modes.antialias_en);
        *prewrap = overflow;

        return 1;
    }
}

STRICTINLINE int finalize_spanalpha(
    UINT32 blend_en, UINT32 curpixel_cvg, UINT32 curpixel_memcvg)
{
    int possibilities[4];

    possibilities[CVG_WRAP] = curpixel_memcvg;
    possibilities[CVG_SAVE] = curpixel_memcvg;
    possibilities[CVG_ZAP] = 7;
    possibilities[CVG_CLAMP]  = curpixel_memcvg;
    possibilities[CVG_CLAMP] |= -(signed)(blend_en) ^ ~0;
    possibilities[CVG_CLAMP] += curpixel_cvg;
    possibilities[CVG_WRAP] += curpixel_cvg;
    possibilities[CVG_CLAMP] |= -(possibilities[CVG_CLAMP]>>3 & 1);

    return (possibilities[other_modes.cvg_dest] & 7);
}

STRICTINLINE INT32 CLIP(INT32 value,INT32 min,INT32 max)
{
    if (value < min)
        return min;
    else if (value > max)
        return max;
    else
        return value;
}

INLINE void calculate_clamp_diffs(UINT32 i)
{
    tile[i].f.clampdiffs = ((tile[i].sh >> 2) - (tile[i].sl >> 2)) & 0x3ff;
    tile[i].f.clampdifft = ((tile[i].th >> 2) - (tile[i].tl >> 2)) & 0x3ff;
}


INLINE void calculate_tile_derivs(UINT32 i)
{
    tile[i].f.clampens = tile[i].cs || !tile[i].mask_s;
    tile[i].f.clampent = tile[i].ct || !tile[i].mask_t;
    tile[i].f.masksclamped = tile[i].mask_s <= 10 ? tile[i].mask_s : 10;
    tile[i].f.masktclamped = tile[i].mask_t <= 10 ? tile[i].mask_t : 10;
    tile[i].f.notlutswitch = (tile[i].format << 2) | tile[i].size;
    tile[i].f.tlutswitch = (tile[i].size << 2) | ((tile[i].format + 2) & 3);
}

INLINE void rgb_dither_complete(int* r, int* g, int* b, int dith)
{
    i32 new_rgb[4], comp_rgb[4];
    register size_t i;
    const size_t limit = 4 - 1;

    new_rgb[0] = *r;
    new_rgb[1] = *g;
    new_rgb[2] = *b;

    for (i = 0; i < limit; i++)
        if (new_rgb[i] >= 0xF8)
            new_rgb[i]  = 0xFF;
        else
            new_rgb[i] = (new_rgb[i] & 0xF8) + 0x08;

    for (i = 0; i < limit; i++)
        comp_rgb[i] = dith;
    comp_rgb[0] >>= (other_modes.rgb_dither_sel == 2) ? 0 : 0;
    comp_rgb[1] >>= (other_modes.rgb_dither_sel == 2) ? 3 : 0;
    comp_rgb[2] >>= (other_modes.rgb_dither_sel == 2) ? 6 : 0;
    for (i = 0; i < limit; i++)
        comp_rgb[i] &= 7;

    *r = (comp_rgb[0] < (*r & 7)) ? new_rgb[0] : *r;
    *g = (comp_rgb[1] < (*g & 7)) ? new_rgb[1] : *g;
    *b = (comp_rgb[2] < (*b & 7)) ? new_rgb[2] : *b;
    return;
}

INLINE void rgb_dither_nothing(int* r, int* g, int* b, int dith)
{
}


INLINE void get_dither_noise_complete(int x, int y, int* cdith, int* adith)
{
    int dithindex;

    noise = ((irand() & 7) << 6) | 0x20;
    switch(other_modes.f.rgb_alpha_dither)
    {
    case 0:
        dithindex = ((y & 3) << 2) | (x & 3);
        *adith = *cdith = magic_matrix[dithindex];
        break;
    case 1:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = magic_matrix[dithindex];
        *adith = (~(*cdith)) & 7;
        break;
    case 2:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = magic_matrix[dithindex];
        *adith = (noise >> 6) & 7;
        break;
    case 3:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = magic_matrix[dithindex];
        *adith = 0;
        break;
    case 4:
        dithindex = ((y & 3) << 2) | (x & 3);
        *adith = *cdith = bayer_matrix[dithindex];
        break;
    case 5:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = bayer_matrix[dithindex];
        *adith = (~(*cdith)) & 7;
        break;
    case 6:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = bayer_matrix[dithindex];
        *adith = (noise >> 6) & 7;
        break;
    case 7:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = bayer_matrix[dithindex];
        *adith = 0;
        break;
    case 8:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = irand();
        *adith = magic_matrix[dithindex];
        break;
    case 9:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = irand();
        *adith = (~magic_matrix[dithindex]) & 7;
        break;
    case 10:
        *cdith = irand();
        *adith = (noise >> 6) & 7;
        break;
    case 11:
        *cdith = irand();
        *adith = 0;
        break;
    case 12:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = 7;
        *adith = bayer_matrix[dithindex];
        break;
    case 13:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = 7;
        *adith = (~bayer_matrix[dithindex]) & 7;
        break;
    case 14:
        *cdith = 7;
        *adith = (noise >> 6) & 7;
        break;
    case 15:
        *cdith = 7;
        *adith = 0;
        break;
    }
}


INLINE void get_dither_only(int x, int y, int* cdith, int* adith)
{
    int dithindex; 
    switch(other_modes.f.rgb_alpha_dither)
    {
    case 0:
        dithindex = ((y & 3) << 2) | (x & 3);
        *adith = *cdith = magic_matrix[dithindex];
        break;
    case 1:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = magic_matrix[dithindex];
        *adith = (~(*cdith)) & 7;
        break;
    case 2:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = magic_matrix[dithindex];
        *adith = (noise >> 6) & 7;
        break;
    case 3:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = magic_matrix[dithindex];
        *adith = 0;
        break;
    case 4:
        dithindex = ((y & 3) << 2) | (x & 3);
        *adith = *cdith = bayer_matrix[dithindex];
        break;
    case 5:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = bayer_matrix[dithindex];
        *adith = (~(*cdith)) & 7;
        break;
    case 6:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = bayer_matrix[dithindex];
        *adith = (noise >> 6) & 7;
        break;
    case 7:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = bayer_matrix[dithindex];
        *adith = 0;
        break;
    case 8:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = irand();
        *adith = magic_matrix[dithindex];
        break;
    case 9:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = irand();
        *adith = (~magic_matrix[dithindex]) & 7;
        break;
    case 10:
        *cdith = irand();
        *adith = (noise >> 6) & 7;
        break;
    case 11:
        *cdith = irand();
        *adith = 0;
        break;
    case 12:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = 7;
        *adith = bayer_matrix[dithindex];
        break;
    case 13:
        dithindex = ((y & 3) << 2) | (x & 3);
        *cdith = 7;
        *adith = (~bayer_matrix[dithindex]) & 7;
        break;
    case 14:
        *cdith = 7;
        *adith = (noise >> 6) & 7;
        break;
    case 15:
        *cdith = 7;
        *adith = 0;
        break;
    }
}

INLINE void get_dither_nothing(int x, int y, int* cdith, int* adith)
{
}

STRICTINLINE void rgbaz_correct_clip(int offx, int offy, int r, int g, int b, int a, int* z, UINT32 curpixel_cvg)
{
    int summand_r, summand_b, summand_g, summand_a;
    int summand_z;
    int sz = *z;
    int zanded;




    if (curpixel_cvg == 8)
    {
        r >>= 2;
        g >>= 2;
        b >>= 2;
        a >>= 2;
        sz = sz >> 3;
    }
    else
    {
        summand_r = offx * spans_cd_rgba[0] + offy * spans_d_rgba_dy[0];
        summand_g = offx * spans_cd_rgba[1] + offy * spans_d_rgba_dy[1];
        summand_b = offx * spans_cd_rgba[2] + offy * spans_d_rgba_dy[2];
        summand_a = offx * spans_cd_rgba[3] + offy * spans_d_rgba_dy[3];
        summand_z = offx * spans_cdz + offy * spans_d_stwz_dy[3];

        r = ((r << 2) + summand_r) >> 4;
        g = ((g << 2) + summand_g) >> 4;
        b = ((b << 2) + summand_b) >> 4;
        a = ((a << 2) + summand_a) >> 4;
        sz = ((sz << 2) + summand_z) >> 5;
    }

    
    shade_color.r = special_9bit_clamptable[r & 0x1ff];
    shade_color.g = special_9bit_clamptable[g & 0x1ff];
    shade_color.b = special_9bit_clamptable[b & 0x1ff];
    shade_color.a = special_9bit_clamptable[a & 0x1ff];
    
    
    
    zanded = (sz & 0x60000) >> 17;

    
    switch(zanded)
    {
        case 0: *z = sz & 0x3ffff;                        break;
        case 1:    *z = sz & 0x3ffff;                        break;
        case 2: *z = 0x3ffff;                            break;
        case 3: *z = 0;                                    break;
    }
}



int IsBadPtrW32(void *ptr, UINT32 bytes)
{
#ifdef WIN32
    SIZE_T dwSize;
    MEMORY_BASIC_INFORMATION meminfo;
    if (!ptr)
        return 1;
    memfill(&meminfo, 0x00, sizeof(meminfo));
    dwSize = VirtualQuery(ptr, &meminfo, sizeof(meminfo));
    if (!dwSize)
        return 1;
    if (MEM_COMMIT != meminfo.State)
        return 1;
    if (!(meminfo.Protect & (PAGE_READWRITE | PAGE_WRITECOPY | PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY)))
        return 1;
    if (bytes > meminfo.RegionSize)
        return 1;
    if ((UINT64)((char*)ptr - (char*)meminfo.BaseAddress) > (UINT64)(meminfo.RegionSize - bytes))
        return 1;
#endif
    return 0;
}

UINT32 vi_integer_sqrt(UINT32 a)
{
    unsigned long op = a, res = 0, one = 1 << 30;

    while (one > op) 
        one >>= 2;

    while (one != 0) 
    {
        if (op >= res + one) 
        {
            op -= res + one;
            res += one << 1;
        }
        res >>= 1;
        one >>= 2;
    }
    return res;
}

INLINE void tcdiv_nopersp(INT32 ss, INT32 st, INT32 sw, INT32* sss, INT32* sst)
{



    *sss = (SIGN16(ss)) & 0x1ffff;
    *sst = (SIGN16(st)) & 0x1ffff;
}

INLINE void tcdiv_persp(INT32 ss, INT32 st, INT32 sw, INT32* sss, INT32* sst)
{


    int w_carry = 0;
    int shift; 
    int tlu_rcp;
    int sprod, tprod;
    int outofbounds_s, outofbounds_t;
    int tempmask;
    int shift_value;
    INT32 temps, tempt;

    
    
    int overunder_s = 0, overunder_t = 0;
    
    
    if (SIGN16(sw) <= 0)
        w_carry = 1;

    sw &= 0x7fff;

    
    
    shift = tcdiv_table[sw];
    tlu_rcp = shift >> 4;
    shift &= 0xf;

    sprod = SIGN16(ss) * tlu_rcp;
    tprod = SIGN16(st) * tlu_rcp;

    
    
    
    tempmask = ((1 << 30) - 1) & -((1 << 29) >> shift);
    
    outofbounds_s = sprod & tempmask;
    outofbounds_t = tprod & tempmask;
    
    if (shift != 0xe)
    {
        shift_value = 13 - shift;
        temps = sprod = (sprod >> shift_value);
        tempt = tprod = (tprod >> shift_value);
    }
    else
    {
        temps = sprod << 1;
        tempt = tprod << 1;
    }
    
    if (outofbounds_s != tempmask && outofbounds_s != 0)
    {
        if (!(sprod & (1 << 29)))
            overunder_s = 2 << 17;
        else
            overunder_s = 1 << 17;
    }

    if (outofbounds_t != tempmask && outofbounds_t != 0)
    {
        if (!(tprod & (1 << 29)))
            overunder_t = 2 << 17;
        else
            overunder_t = 1 << 17;
    }

    if (w_carry)
    {
        overunder_s |= (2 << 17);
        overunder_t |= (2 << 17);
    }

    *sss = (temps & 0x1ffff) | overunder_s;
    *sst = (tempt & 0x1ffff) | overunder_t;
}

STRICTINLINE void tclod_2cycle_current(INT32* sss, INT32* sst, INT32 nexts, INT32 nextt, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1, INT32* t2)
{
    int nextys, nextyt, nextysw;
    INT32 lod = 0;
    UINT32 l_tile;
    UINT32 distant = 0;
    int inits = *sss, initt = *sst;
    unsigned int lodclamp;
    unsigned int magnify;

    tclod_tcclamp(sss, sst);

    if (!other_modes.f.dolod)
        return;

    nextys = (s + spans_d_stwz_dy[0]) >> 16;
    nextyt = (t + spans_d_stwz_dy[1]) >> 16;
    nextysw = (w + spans_d_stwz_dy[2]) >> 16;

    tcdiv_ptr(nextys, nextyt, nextysw, &nextys, &nextyt);

    lodclamp  = (initt | nextt | inits | nexts | nextys | nextyt) >> 17;
    lodclamp |= (lodclamp >> 1);
    lodclamp &= 1;

    tclod_4x17_to_15(inits, nexts, initt, nextt, 0, &lod);
    tclod_4x17_to_15(inits, nextys, initt, nextyt, lod, &lod);

    lodfrac_lodtile_signals(lodclamp, lod, &l_tile, &magnify, &distant);

    if (!other_modes.tex_lod_en)
        return;

    if (distant)
        l_tile = max_level;
    if (!other_modes.detail_tex_en)
    {
        *t1 = prim_tile + l_tile + 0 + 0 - 0;
        magnify = (magnify & ~other_modes.sharpen_tex_en) | distant;
        *t2 = prim_tile + l_tile + 1 + 0 - magnify;
    }
    else
    {
        *t1 = prim_tile + l_tile + 0 + 1 - magnify;
        magnify = distant | magnify;
        *t2 = prim_tile + l_tile + 1 + 1 - magnify;
    }
    *t1 &= 7;
    *t2 &= 7;
}

STRICTINLINE void tclod_2cycle_current_simple(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1, INT32* t2)
{
    int nextys, nextyt, nextysw, nexts, nextt, nextsw;
    INT32 lod = 0;
    UINT32 l_tile;
    UINT32 distant = 0;
    int inits = *sss, initt = *sst;
    unsigned int lodclamp;
    unsigned int magnify;

    tclod_tcclamp(sss, sst);

    if (!other_modes.f.dolod)
        return;

    nextsw = (w + dwinc) >> 16;
    nexts = (s + dsinc) >> 16;
    nextt = (t + dtinc) >> 16;
    nextys = (s + spans_d_stwz_dy[0]) >> 16;
    nextyt = (t + spans_d_stwz_dy[1]) >> 16;
    nextysw = (w + spans_d_stwz_dy[2]) >> 16;

    tcdiv_ptr(nexts, nextt, nextsw, &nexts, &nextt);
    tcdiv_ptr(nextys, nextyt, nextysw, &nextys, &nextyt);

    lodclamp  = (initt | nextt | inits | nexts | nextys | nextyt) >> 17;
    lodclamp |= (lodclamp >> 1);
    lodclamp &= 1;

    tclod_4x17_to_15(inits, nexts, initt, nextt, 0, &lod);
    tclod_4x17_to_15(inits, nextys, initt, nextyt, lod, &lod);

    lodfrac_lodtile_signals(lodclamp, lod, &l_tile, &magnify, &distant);

    if (!other_modes.tex_lod_en)
        return;

    if (distant)
        l_tile = max_level;
    if (!other_modes.detail_tex_en)
    {
        *t1 = prim_tile + l_tile + 0 + 0 - 0;
        magnify = (magnify & ~other_modes.sharpen_tex_en) | distant;
        *t2 = prim_tile + l_tile + 1 + 0 - magnify;
    }
    else
    {
        *t1 = prim_tile + l_tile + 0 + 1 - magnify;
        magnify = distant | magnify;
        *t2 = prim_tile + l_tile + 1 + 1 - magnify;
    }
    *t1 &= 7;
    *t2 &= 7;
}

STRICTINLINE void tclod_2cycle_current_notexel1(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1)
{
    int nextys, nextyt, nextysw, nexts, nextt, nextsw;
    INT32 lod = 0;
    UINT32 l_tile;
    UINT32 distant = 0;
    int inits = *sss, initt = *sst;
    unsigned int lodclamp;
    unsigned int magnify;

    tclod_tcclamp(sss, sst);

    if (!other_modes.f.dolod)
        return;

    nextsw = (w + dwinc) >> 16;
    nexts = (s + dsinc) >> 16;
    nextt = (t + dtinc) >> 16;
    nextys = (s + spans_d_stwz_dy[0]) >> 16;
    nextyt = (t + spans_d_stwz_dy[1]) >> 16;
    nextysw = (w + spans_d_stwz_dy[2]) >> 16;

    tcdiv_ptr(nexts, nextt, nextsw, &nexts, &nextt);
    tcdiv_ptr(nextys, nextyt, nextysw, &nextys, &nextyt);

    lodclamp  = (initt | nextt | inits | nexts | nextys | nextyt) >> 17;
    lodclamp |= (lodclamp >> 1);
    lodclamp &= 1;

    tclod_4x17_to_15(inits, nexts, initt, nextt, 0, &lod);
    tclod_4x17_to_15(inits, nextys, initt, nextyt, lod, &lod);

    lodfrac_lodtile_signals(lodclamp, lod, &l_tile, &magnify, &distant);
    if (!other_modes.tex_lod_en)
        return;

    if (distant)
        l_tile = max_level;
    magnify = ~magnify & other_modes.detail_tex_en;
    *t1 = (prim_tile + l_tile + magnify) & 7;
}

STRICTINLINE void tclod_2cycle_next(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1, INT32* t2, INT32* prelodfrac)
{
    int nexts, nextt, nextsw, nextys, nextyt, nextysw;
    INT32 lod = 0;
    UINT32 l_tile;
    UINT32 distant = 0;
    int inits = *sss, initt = *sst;
    unsigned int lodclamp;
    unsigned int magnify;

    tclod_tcclamp(sss, sst);

    if (!other_modes.f.dolod)
        return;

    nextsw = (w + dwinc) >> 16;
    nexts = (s + dsinc) >> 16;
    nextt = (t + dtinc) >> 16;
    nextys = (s + spans_d_stwz_dy[0]) >> 16;
    nextyt = (t + spans_d_stwz_dy[1]) >> 16;
    nextysw = (w + spans_d_stwz_dy[2]) >> 16;

    tcdiv_ptr(nexts, nextt, nextsw, &nexts, &nextt);
    tcdiv_ptr(nextys, nextyt, nextysw, &nextys, &nextyt);
    lodclamp  = (initt | nextt | inits | nexts | nextys | nextyt) >> 17;
    lodclamp |= (lodclamp >> 1);
    lodclamp &= 1;

    tclod_4x17_to_15(inits, nexts, initt, nextt, 0, &lod);
    tclod_4x17_to_15(inits, nextys, initt, nextyt, lod, &lod);

    if ((lod & 0x4000) || lodclamp)
        lod = 0x7fff;
    else if (lod < min_level)
        lod = min_level;
    magnify = FULL_MSB(lod - 32);
    l_tile =  log2table[(lod >> 5) & 0xff];
    distant = ((lod & 0x6000) || (l_tile >= max_level)) ? ~0 : 0;

    *prelodfrac = (lod << 3) >> l_tile;
    if (other_modes.sharpen_tex_en | other_modes.detail_tex_en)
        { /* branch */ }
    else
    {
        *prelodfrac &= ~magnify;
        *prelodfrac |=  distant;
    }
    *prelodfrac &= 0xFF;
    *prelodfrac |= (other_modes.sharpen_tex_en & magnify) << 8;

    if (!other_modes.tex_lod_en)
        return;

    if (distant)
        l_tile = max_level;
    if (!other_modes.detail_tex_en)
    {
        *t1 = prim_tile + l_tile + 1 - 1;
        magnify = (magnify & ~other_modes.sharpen_tex_en) | distant;
        *t2 = prim_tile + l_tile + 1 - magnify;
    }
    else
    {
        *t1 = prim_tile + l_tile + 1 + 0 - magnify;
        magnify = distant | magnify;
        *t2 = prim_tile + l_tile + 1 + 1 - magnify;
    }
    *t1 &= 7;
    *t2 &= 7;
}

STRICTINLINE void tclod_1cycle_current(INT32* sss, INT32* sst, INT32 nexts, INT32 nextt, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 scanline, INT32 prim_tile, INT32* t1, SPANSIGS* sigs)
{
    int fars, fart, farsw;
    INT32 lod = 0;
    UINT32 l_tile = 0, distant = 0;
    int nextscan = scanline + 1;
    unsigned int lodclamp;
    unsigned int magnify;

    tclod_tcclamp(sss, sst);

    if (!other_modes.f.dolod)
        return;

    if (span[nextscan].validline)
    {
        if (!sigs->endspan || !sigs->longspan)
        {
            if (!(sigs->preendspan && sigs->longspan) && !(sigs->endspan && sigs->midspan))
            {
                farsw = (w + (dwinc << 1)) >> 16;
                fars = (s + (dsinc << 1)) >> 16;
                fart = (t + (dtinc << 1)) >> 16;
            }
            else
            {
                farsw = (w - dwinc) >> 16;
                fars = (s - dsinc) >> 16;
                fart = (t - dtinc) >> 16;
            }
        }
        else
        {
            fars = (span[nextscan].stwz[0] + dsinc) >> 16;
            fart = (span[nextscan].stwz[1] + dtinc) >> 16;
            farsw = (span[nextscan].stwz[2] + dwinc) >> 16;
        }
    }
    else
    {
        farsw = (w + (dwinc << 1)) >> 16;
        fars = (s + (dsinc << 1)) >> 16;
        fart = (t + (dtinc << 1)) >> 16;
    }

    tcdiv_ptr(fars, fart, farsw, &fars, &fart);

    lodclamp  = (fart | nextt | fars | nexts) >> 17;
    lodclamp |= (lodclamp >> 1);
    lodclamp &= 1;

    tclod_4x17_to_15(nexts, fars, nextt, fart, 0, &lod);

    lodfrac_lodtile_signals(lodclamp, lod, &l_tile, &magnify, &distant);

    if (!other_modes.tex_lod_en)
        return;
    if (distant)
        l_tile = max_level;
    magnify = ~magnify & other_modes.detail_tex_en;
    *t1 = (prim_tile + l_tile + magnify) & 7;
}

STRICTINLINE void tclod_1cycle_current_simple(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 scanline, INT32 prim_tile, INT32* t1, SPANSIGS* sigs)
{
    int fars, fart, farsw, nexts, nextt, nextsw;
    INT32 lod = 0;
    UINT32 l_tile = 0, distant = 0;
    int nextscan = scanline + 1;
    unsigned int lodclamp;
    unsigned int magnify;

    tclod_tcclamp(sss, sst);

    if (!other_modes.f.dolod)
        return;

    if (span[nextscan].validline)
    {
        if (!sigs->endspan || !sigs->longspan)
        {
            nextsw = (w + dwinc) >> 16;
            nexts = (s + dsinc) >> 16;
            nextt = (t + dtinc) >> 16;

            if (!(sigs->preendspan && sigs->longspan) && !(sigs->endspan && sigs->midspan))
            {
                farsw = (w + (dwinc << 1)) >> 16;
                fars = (s + (dsinc << 1)) >> 16;
                fart = (t + (dtinc << 1)) >> 16;
            }
            else
            {
                farsw = (w - dwinc) >> 16;
                fars = (s - dsinc) >> 16;
                fart = (t - dtinc) >> 16;
            }
        }
        else
        {
            nexts = span[nextscan].stwz[0] >> 16;
            nextt = span[nextscan].stwz[1] >> 16;
            nextsw = span[nextscan].stwz[2] >> 16;
            fars = (span[nextscan].stwz[0] + dsinc) >> 16;
            fart = (span[nextscan].stwz[1] + dtinc) >> 16;
            farsw = (span[nextscan].stwz[2] + dwinc) >> 16;
        }
    }
    else
    {
        nextsw = (w + dwinc) >> 16;
        nexts = (s + dsinc) >> 16;
        nextt = (t + dtinc) >> 16;
        farsw = (w + (dwinc << 1)) >> 16;
        fars = (s + (dsinc << 1)) >> 16;
        fart = (t + (dtinc << 1)) >> 16;
    }

    tcdiv_ptr(nexts, nextt, nextsw, &nexts, &nextt);
    tcdiv_ptr(fars, fart, farsw, &fars, &fart);

    lodclamp  = (fart | nextt | fars | nexts) >> 17;
    lodclamp |= (lodclamp >> 1);
    lodclamp &= 1;

    tclod_4x17_to_15(nexts, fars, nextt, fart, 0, &lod);

    lodfrac_lodtile_signals(lodclamp, lod, &l_tile, &magnify, &distant);
    if (!other_modes.tex_lod_en)
        return;

    if (distant)
        l_tile = max_level;
    magnify = ~magnify & other_modes.detail_tex_en;
    *t1 = (prim_tile + l_tile + magnify) & 7;
}

STRICTINLINE void tclod_1cycle_next(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 scanline, INT32 prim_tile, INT32* t1, SPANSIGS* sigs, INT32* prelodfrac)
{
    int nexts, nextt, nextsw, fars, fart, farsw;
    INT32 lod = 0;
    UINT32 l_tile = 0, distant = 0;
    int nextscan = scanline + 1;
    unsigned int lodclamp;
    unsigned int magnify;

    tclod_tcclamp(sss, sst);
    if (!other_modes.f.dolod)
        return;

    if (span[nextscan].validline)
    {
        if (!sigs->nextspan)
        {
            if (!sigs->endspan || !sigs->longspan)
            {
                nextsw = (w + dwinc) >> 16;
                nexts = (s + dsinc) >> 16;
                nextt = (t + dtinc) >> 16;

                if (!(sigs->preendspan && sigs->longspan) && !(sigs->endspan && sigs->midspan))
                {
                    farsw = (w + (dwinc << 1)) >> 16;
                    fars = (s + (dsinc << 1)) >> 16;
                    fart = (t + (dtinc << 1)) >> 16;
                }
                else
                {
                    farsw = (w - dwinc) >> 16;
                    fars = (s - dsinc) >> 16;
                    fart = (t - dtinc) >> 16;
                }
            }
            else
            {
                nexts = span[nextscan].stwz[0];
                nextt = span[nextscan].stwz[1];
                nextsw = span[nextscan].stwz[2];
                fart = (nextt + dtinc) >> 16;
                fars = (nexts + dsinc) >> 16;
                farsw = (nextsw + dwinc) >> 16;
                nextt >>= 16;
                nexts >>= 16;
                nextsw >>= 16;
            }
        }
        else
        {
            if (!sigs->onelessthanmid)
            {
                nexts = span[nextscan].stwz[0] + dsinc;
                nextt = span[nextscan].stwz[1] + dtinc;
                nextsw = span[nextscan].stwz[2] + dwinc;
                fart = (nextt + dtinc) >> 16;
                fars = (nexts + dsinc) >> 16;
                farsw = (nextsw + dwinc) >> 16;
                nextt >>= 16;
                nexts >>= 16;
                nextsw >>= 16;
            }
            else
            {
                nextsw = (w + dwinc) >> 16;
                nexts = (s + dsinc) >> 16;
                nextt = (t + dtinc) >> 16;
                farsw = (w - dwinc) >> 16;
                fars = (s - dsinc) >> 16;
                fart = (t - dtinc) >> 16;
            }
        }
    }
    else
    {
        nextsw = (w + dwinc) >> 16;
        nexts = (s + dsinc) >> 16;
        nextt = (t + dtinc) >> 16;
        farsw = (w + (dwinc << 1)) >> 16;
        fars = (s + (dsinc << 1)) >> 16;
        fart = (t + (dtinc << 1)) >> 16;
    }

    tcdiv_ptr(nexts, nextt, nextsw, &nexts, &nextt);
    tcdiv_ptr(fars, fart, farsw, &fars, &fart);

    lodclamp  = (fart | nextt | fars | nexts) >> 17;
    lodclamp |= (lodclamp >> 1);
    lodclamp &= 1;

    tclod_4x17_to_15(nexts, fars, nextt, fart, 0, &lod);

    if ((lod & 0x4000) || lodclamp)
        lod = 0x7fff;
    else if (lod < min_level)
        lod = min_level;

    magnify = FULL_MSB(lod - 32);
    l_tile =  log2table[(lod >> 5) & 0xff];
    distant = ((lod & 0x6000) || (l_tile >= max_level)) ? ~0 : 0;

    *prelodfrac = (lod << 3) >> l_tile;
    if (other_modes.sharpen_tex_en | other_modes.detail_tex_en)
        { /* branch */ }
    else
    {
        *prelodfrac &= ~magnify;
        *prelodfrac |=  distant;
    }
    *prelodfrac &= 0xFF;
    *prelodfrac |= (other_modes.sharpen_tex_en & magnify) << 8;

    if (!other_modes.tex_lod_en)
        return;

    if (distant)
        l_tile = max_level;
    magnify = ~magnify & other_modes.detail_tex_en;
    *t1 = (prim_tile + l_tile + magnify) & 7;
}

STRICTINLINE void tclod_copy(INT32* sss, INT32* sst, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 prim_tile, INT32* t1)
{
    int nexts, nextt, nextsw, fars, fart, farsw;
    INT32 lod = 0;
    UINT32 l_tile = 0, distant = 0;
    unsigned int lodclamp;
    unsigned int magnify;

    tclod_tcclamp(sss, sst);

    if (!other_modes.tex_lod_en)
        return;

    nextsw = (w + dwinc) >> 16;
    nexts = (s + dsinc) >> 16;
    nextt = (t + dtinc) >> 16;
    farsw = (w + (dwinc << 1)) >> 16;
    fars = (s + (dsinc << 1)) >> 16;
    fart = (t + (dtinc << 1)) >> 16;

    tcdiv_ptr(nexts, nextt, nextsw, &nexts, &nextt);
    tcdiv_ptr(fars, fart, farsw, &fars, &fart);

    lodclamp  = (fart | nextt | fars | nexts) >> 17;
    lodclamp |= (lodclamp >> 1);
    lodclamp &= 1;

    tclod_4x17_to_15(nexts, fars, nextt, fart, 0, &lod);

    if ((lod & 0x4000) || lodclamp)
        lod = 0x7fff;
    else if (lod < min_level)
        lod = min_level;

    magnify = ZERO_MSB(lod - 32);
    l_tile =  log2table[(lod >> 5) & 0xff];
    distant = ((lod & 0x6000) || (l_tile >= max_level)) ? ~0 : 0;

    if (distant)
        l_tile = max_level;
    magnify = ~magnify & other_modes.detail_tex_en;
    *t1 = (prim_tile + l_tile + magnify) & 7;
}

STRICTINLINE void get_texel1_1cycle(INT32* s1, INT32* t1, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc, INT32 scanline, SPANSIGS* sigs)
{
    INT32 nexts, nextt, nextsw;
    
    if (!sigs->endspan || !sigs->longspan || !span[scanline + 1].validline)
    {
    
    
        nextsw = (w + dwinc) >> 16;
        nexts = (s + dsinc) >> 16;
        nextt = (t + dtinc) >> 16;
    }
    else
    {
        INT32 nextscan = scanline + 1;

        nexts = span[nextscan].stwz[0] >> 16;
        nextt = span[nextscan].stwz[1] >> 16;
        nextsw = span[nextscan].stwz[2] >> 16;
    }
    tcdiv_ptr(nexts, nextt, nextsw, s1, t1);
    return;
}

STRICTINLINE void get_nexttexel0_2cycle(INT32* s1, INT32* t1, INT32 s, INT32 t, INT32 w, INT32 dsinc, INT32 dtinc, INT32 dwinc)
{
    INT32 nexts, nextt, nextsw;
    nextsw = (w + dwinc) >> 16;
    nexts = (s + dsinc) >> 16;
    nextt = (t + dtinc) >> 16;

    tcdiv_ptr(nexts, nextt, nextsw, s1, t1);
}



STRICTINLINE void tclod_4x17_to_15(INT32 scurr, INT32 snext, INT32 tcurr, INT32 tnext, INT32 previous, INT32* lod)
{
    int dels = SIGN(snext, 17) - SIGN(scurr, 17);
    int delt = SIGN(tnext, 17) - SIGN(tcurr, 17);

    if (dels & 0x20000)
        dels = ~dels & 0x1ffff;
    if (delt & 0x20000)
        delt = ~delt & 0x1ffff;

    dels = (dels > delt) ? dels : delt;
    dels = (previous > dels) ? previous : dels;
    *lod = dels & 0x7fff;
    if (dels & 0x1c000)
        *lod |= 0x4000;
    return;
}

STRICTINLINE void tclod_tcclamp(INT32* sss, INT32* sst)
{
    INT32 tempanded, temps = *sss, tempt = *sst;

    
    
    
    
    if (!(temps & 0x40000))
    {
        if (!(temps & 0x20000))
        {
            tempanded = temps & 0x18000;
            if (tempanded != 0x8000)
            {
                if (tempanded != 0x10000)
                    *sss &= 0xffff;
                else
                    *sss = 0x8000;
            }
            else
                *sss = 0x7fff;
        }
        else
            *sss = 0x8000;
    }
    else
        *sss = 0x7fff;

    if (!(tempt & 0x40000))
    {
        if (!(tempt & 0x20000))
        {
            tempanded = tempt & 0x18000;
            if (tempanded != 0x8000)
            {
                if (tempanded != 0x10000)
                    *sst &= 0xffff;
                else
                    *sst = 0x8000;
            }
            else
                *sst = 0x7fff;
        }
        else
            *sst = 0x8000;
    }
    else
        *sst = 0x7fff;

}

STRICTINLINE void lodfrac_lodtile_signals(
    unsigned int lodclamp,
    INT32 lod,
    UINT32* l_tile,
    unsigned int* magnify,
    UINT32* distant
)
{
    UINT32 ltil, dis;
    u16 lf;
    unsigned int mag;

    if ((lod & 0x4000) || lodclamp)
        lod = 0x7fff;
    else if (lod < min_level)
        lod = min_level;

    mag = FULL_MSB(lod - 32);
    ltil=  log2table[(lod >> 5) & 0xff];
    dis = ((lod & 0x6000) || (ltil >= max_level)) ? ~0 : 0;

    lf = (lod << 3) >> ltil;
    if (other_modes.sharpen_tex_en | other_modes.detail_tex_en)
        { /* branch */ }
    else
    {
        lf &= ~mag;
        lf |=  dis;
    }
    lf &= 0xFF;
    lf |= (other_modes.sharpen_tex_en & mag) << 8;

    *distant = dis & 1;
    *l_tile = ltil;
    *magnify = mag & 1;
    lod_frac = lf;
}
