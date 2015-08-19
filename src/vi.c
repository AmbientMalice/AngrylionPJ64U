#include "context.h"
#include "z64.h"
#include "vi.h"

onetime onetimewarnings;

UINT8* rdram_8;
UINT16* rdram_16;
u32 plim;
u32 idxlim16;
u32 idxlim32;
UINT8 hidden_bits[0x400000];

UINT32 gamma_table[0x100];
UINT32 gamma_dither_table[0x4000];
int vi_restore_table[0x3FF + 1];
INT32 oldvstart = 1337;

GLuint screen[1024 * 1024];
GLuint* PreScale;
GLint viewport[4];

/*
 * Update the emulator window screen size?
 * Here, `video_sync' indicates whether there are changes in the queue.
 */
int video_sync = 1;

UINT32 tvfadeoutstate[PRESCALE_HEIGHT];
static UINT32 prevwasblank = 0;
#ifdef _WIN32
static UINT32 brightness = 0;
#endif

static void video_filter16(CCVG* res, UINT32 fboffset, UINT32 num, UINT32 hres);
static void video_filter32(CCVG* res, UINT32 fboffset, UINT32 num, UINT32 hres);
static void divot_filter(
    CCVG* final, CCVG center, CCVG left, CCVG right);
static void restore_filter16(
    CCVG* res, UINT32 fboffset, UINT32 num, UINT32 hres);
static void restore_filter32(
    CCVG* res, UINT32 fboffset, UINT32 num, UINT32 hres);
static void gamma_filters(unsigned char* argb, int gamma_and_dither);
static void adjust_brightness(unsigned char* argb, int brightcoeff);
static void vi_vl_lerp(CCVG* up, CCVG down, UINT32 frac);
static void video_max_optimized(
    UINT32* pixels, UINT32* penumin, UINT32* penumax, int numofels);

static void vi_fetch_filter16(
    CCVG* res, UINT32 fboffset, UINT32 cur_x, UINT32 fsaa, UINT32 dither_filter,
    UINT32 vres);
static void vi_fetch_filter32(
    CCVG* res, UINT32 fboffset, UINT32 cur_x, UINT32 fsaa, UINT32 dither_filter,
    UINT32 vres);

static void do_frame_buffer_proper(
    UINT32 prescale_ptr, int hres, int vres, int vitype, int linecount);
static void do_frame_buffer_raw(
    UINT32 prescale_ptr, int hres, int vres, int vitype, int linecount);
static void (*do_frame_buffer[2])(UINT32, int, int, int, int) = {
    do_frame_buffer_proper, do_frame_buffer_raw
};

static void (*vi_fetch_filter_func[2])(
    CCVG*, UINT32, UINT32, UINT32, UINT32, UINT32) = {
    vi_fetch_filter16, vi_fetch_filter32
};

/*
 * raster vector
 *  A--B   C--D
 *  |  |   |  |
 *  C--D   A--B
 */
static GLfloat quad[4*COORDS_PER_VTX << INTERLEAVED] = {
     0.f, +1.f ZW_CARTESIAN/* A */-1.f, -1.f ZW_CARTESIAN/* C */
    +1.f, +1.f ZW_CARTESIAN/* B */+1.f, -1.f ZW_CARTESIAN/* D */
     0.f,  0.f ZW_CARTESIAN/* C */-1.f, +1.f ZW_CARTESIAN/* A */
    +1.f,  0.f ZW_CARTESIAN/* D */+1.f, +1.f ZW_CARTESIAN/* B */
};

#if (NUM_BUFFERS > 2)
static GLubyte quad_into_tris[TRIANGLES_PER_QUAD * VERTICES_PER_TRI] = {
    0, 1, 2,
    0, 3, 2,
};
#endif

/*
 * minhpass and maxhpass:  new to upstream angrylion r87
 *
 * It was discovered that the VI aggressively discards some pixels closest to
 * h_start and h_end, unless (h_end - h_start >= 16 pixels).
 */
static int hpass_minmax[2];
static int x_start_init;

int hres_old, vres_old; /* for optional FB size change detection */
int shift_old;
int rdp_update(void)
{
#if (NUM_BUFFERS > 2)
    GLvoid* indices;
#endif
    GLenum error;
    UINT32 prescale_ptr;
    int hres, vres;
    int h_start, v_start;
    int h_end;
    int two_lines, line_shifter, line_count;
    int hrightblank;
    int vactivelines;
    int validh;
    int serration_pulses;
    int lowerfield;
    int h_start_clamped, hres_clamped;
    register int i, j;
    GLsizei height;
    const int x_add = *GET_GFX_INFO(VI_X_SCALE_REG) & 0x00000FFF;
    const int v_sync = *GET_GFX_INFO(VI_V_SYNC_REG) & 0x000003FF;
    const int ispal  = (v_sync > 550);
    const int x1 = (*GET_GFX_INFO(VI_H_START_REG) >> 16) & 0x03FF;
    const int y1 = (*GET_GFX_INFO(VI_V_START_REG) >> 16) & 0x03FF;
    const int x2 = (*GET_GFX_INFO(VI_H_START_REG) >>  0) & 0x03FF;
    const int y2 = (*GET_GFX_INFO(VI_V_START_REG) >>  0) & 0x03FF;
    const int delta_x = x2 - x1;
    const int delta_y = y2 - y1;
    const int vitype = *GET_GFX_INFO(VI_STATUS_REG) & 0x00000003;
    const int pixel_size = sizeof(INT32);

    serration_pulses  = *GET_GFX_INFO(VI_STATUS_REG) >> 6;
    lowerfield = serration_pulses & (ispal ? y1 < oldvstart : y1 > oldvstart);
    serration_pulses &= (y1 != oldvstart);
    two_lines = serration_pulses ^ 0;
    line_shifter = serration_pulses ^ 1;
    line_count = pitchindwords << serration_pulses;

    hres = delta_x;
    vres = delta_y;
    h_start = x1 - (ispal ? 128 : 108);
    v_start = y1 - (ispal ?  47 :  37);
    x_start_init = (GET_RCP_REG(VI_X_SCALE_REG) >> 16) & 0x00000FFF;

    h_start_clamped = 0;
    if (h_start < 0)
    {
        x_start_init -= x_add * h_start;
        hres += h_start;

        h_start = 0;
        h_start_clamped = 1;
    }
    oldvstart = y1;
    v_start >>= 1;
    if (v_start < 0)
        v_start = 0;
    vres >>= 1;

    hres_clamped = 0;
    if (hres > PRESCALE_WIDTH - h_start)
    {
        hres = PRESCALE_WIDTH - h_start;
        hres_clamped = 1;
    }
    if (vres > PRESCALE_HEIGHT - v_start)
        vres = PRESCALE_HEIGHT - v_start;
    h_end = hres + h_start;

    hrightblank = PRESCALE_WIDTH - h_end;
    vactivelines = v_sync - (ispal ? 47 : 37);
    if (vactivelines > PRESCALE_HEIGHT)
    {
        DisplayError("VI_V_SYNC_REG too big");
        return 1;
    }
    if (vactivelines < 0)
        return 2;
    vactivelines >>= line_shifter;
    validh = (hres >= 0 && h_start < PRESCALE_WIDTH);

    hpass_minmax[0] = h_start_clamped ? 0 : 8;
    hpass_minmax[1] = hres_clamped ? hres : hres - 7;

    if (hres <= 0 || vres <= 0 || (!(vitype & 2) && prevwasblank))
        return 3;

    video_sync |= (hres != hres_old) | (vres != vres_old);
    video_sync |= (line_shifter != shift_old);
    if (video_sync != 0)
    { /* GL context calls apparently fail when directly in ChangeWindow. */
#if defined(STUCK_WITH_SDL)
        Uint32 SDL_flags;

        SDL_flags = video_surface -> flags;
     /* is_full_screen = (SDL_flags & SDL_FULLSCREEN) ? 1 : 0; */
#endif
        if (is_full_screen != 0)
        {
            GLfloat aspect_ratio, aspect_ratio_PC;
            int dimensions[2];

            get_screen_size(dimensions);
#if 0
            aspect_ratio = (GLfloat)(hres)/2.f / (GLfloat)(vres);
#else
            aspect_ratio = ispal ? (10.f / 9.f) : (12.f / 9.f);
#endif
            aspect_ratio_PC = (GLfloat)dimensions[0] / (GLfloat)dimensions[1];

            if (aspect_ratio_PC < 1.f)
            { /* narrow, tall picture */
                viewport[2] = dimensions[0];
                viewport[3] = (GLint)((GLfloat)dimensions[0] / aspect_ratio);
                viewport[0] = 0;
                viewport[1] = (dimensions[1] - viewport[3]) / 2;
            }
            else
            { /* wide, short picture */
                viewport[3] = dimensions[1];
                viewport[2] = (GLint)((GLfloat)dimensions[1] * aspect_ratio);
                viewport[1] = 0;
                viewport[0] = (dimensions[0] - viewport[2]) / 2;
            }
#if defined(STUCK_WITH_SDL)
            video_surface = SDL_SetVideoMode(
                SDL_desktop[0], SDL_desktop[1], 0, SDL_flags
            );
#endif
        }
        else
        {
            const int x_scale = GET_RCP_REG(VI_X_SCALE_REG) & 0x00000FFF;
            const int y_scale = GET_RCP_REG(VI_Y_SCALE_REG) & 0x00000FFF;

            viewport[0] = 0;
            viewport[1] = 0;
            if (GFX_INFO_NAME.hStatusBar != NULL)
            {
#ifdef _WIN32
                RECT status_bar;

                GetClientRect(GFX_INFO_NAME.hStatusBar, &status_bar);
                viewport[0] = status_bar.left;
                viewport[1] = status_bar.bottom;
#endif
            }
            switch (cfg[4])
            {
                case 0x00:
                    viewport[2] = 640;
                    viewport[3] = 480; /* ispal ? 576 : 480 */
                    break;
                case 0x01:
                    viewport[2] = (GLsizei)(hres * x_scale/1024) - (hres & 1);
                    viewport[3] = (GLsizei)(vres * y_scale/1024 * 454./448.f);
                    break;
                case 0x02:
                    viewport[2] = (cfg[0] << 8) | cfg[1];
                    viewport[3] = (cfg[2] << 8) | cfg[3];
                    viewport[2] = (viewport[2] & 0x0000FFFF) + 1;
                    viewport[3] = (viewport[3] & 0x0000FFFF) + 1;
                    break;
                default:
                    DisplayError("Invalid resolution control setting.");
                    break;
            }
            screen_resize(viewport[2], viewport[3]);
#if defined(STUCK_WITH_SDL)
            video_surface = SDL_SetVideoMode(
                viewport[2], viewport[3], 0, SDL_flags
            );
#endif
        }
        video_sync = 0;
        glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);
        reform_image_canvas(ispal, line_shifter);
    }
    hres_old = hres;
    vres_old = vres;
    shift_old = line_shifter;

    PreScale = (support_pixel_DMAs != GL_FALSE)
      ? (GLuint *)xglMapBuffer(GL_PIXEL_UNPACK_BUFFER, GL_WRITE_ONLY)
      : (GLuint *)&screen[0]
      ;
    if (vitype >> 1 == 0)
    {
        memfill(tvfadeoutstate, 0x00, pixel_size*PRESCALE_HEIGHT);
        for (i = 0; i < PRESCALE_HEIGHT; i++)
            memfill(
                &PreScale[i * pitchindwords],
                0x00,
                pixel_size * PRESCALE_WIDTH
            );
        prevwasblank = 1;
        goto no_frame_buffer;
    }
#undef RENDER_CVG_BITS16
#undef RENDER_CVG_BITS32
#undef RENDER_MIN_CVG_ONLY
#undef RENDER_MAX_CVG_ONLY

#undef MONITOR_Z
#undef BW_ZBUFFER
#undef ZBUFF_AS_16B_IATEXTURE

#ifdef MONITOR_Z
    frame_buffer = zb_address;
#endif

    prevwasblank = 0;
    if (h_start > 0 && h_start < PRESCALE_WIDTH)
        for (i = 0; i < vactivelines; i++)
            memfill(&PreScale[i*pitchindwords], 0x00, pixel_size*h_start);

    if (h_end >= 0 && h_end < PRESCALE_WIDTH)
        for (i = 0; i < vactivelines; i++)
            memfill(
                &PreScale[i*pitchindwords + h_end],
                0x00,
                pixel_size * hrightblank
            );

    for (i = 0; i < (v_start << two_lines) + lowerfield; i++)
    {
        tvfadeoutstate[i] >>= 1;
        if (~tvfadeoutstate[i] & validh)
            memfill(
                &PreScale[i*pitchindwords + h_start],
                0x00,
                pixel_size * hres
            );
    }

    if (serration_pulses == 0)
        for (j = 0; j < vres; j++)
            tvfadeoutstate[i++] = 2;
    else
        for (j = 0; j < vres; j++)
        {
            tvfadeoutstate[i] = 2;
            ++i;
            tvfadeoutstate[i] >>= 1;
            if (~tvfadeoutstate[i] & validh)
                memfill(
                    &PreScale[i*pitchindwords + h_start],
                    0x00,
                    pixel_size * hres
                );
            ++i;
        }

    while (i < vactivelines)
    {
        tvfadeoutstate[i] >>= 1;
        if (~tvfadeoutstate[i] & validh)
            memfill(
                &PreScale[i*pitchindwords + h_start],
                0x00,
                pixel_size * hres
            );
        ++i;
    }

    prescale_ptr =
        (v_start * line_count) + h_start + (lowerfield ? pitchindwords : 0);
    do_frame_buffer[cfg[23] & 1](prescale_ptr, hres, vres, vitype, line_count);

no_frame_buffer:
    height = (unsigned)(ispal ? 576 : 480) >> line_shifter;
#if (NUM_BUFFERS > 2)
    indices = (GLvoid *)quad_into_tris;
#endif
    if (support_pixel_DMAs != GL_FALSE)
    {
        xglUnmapBuffer(GL_PIXEL_UNPACK_BUFFER);
        PreScale = NULL;
#if (NUM_BUFFERS > 2)
        indices = NULL;
#endif
    }
#if defined(GL_VERSION_1_0) & !defined(GL_VERSION_1_1)
#if 0
    glCallList(frame_buffer_draw_list); /* incompatible; NPOT 640x480 */
#else
    glRasterPos2f(-1., +1.);

    glPixelZoom((GLfloat)viewport[2] / +640.f, (GLfloat)viewport[3] / -height);
    glDisable(GL_TEXTURE_2D); /* bug in NV drivers? */
    glDrawPixels(640, height, GL_BGRA, GL_UNSIGNED_BYTE, PreScale);
    glEnable(GL_TEXTURE_2D);
#endif
#else
    glTexSubImage2D(
        GL_TEXTURE_2D,
        0,
        0,
        0,
        PRESCALE_WIDTH,
        height,
        GL_BGRA,
        GL_UNSIGNED_BYTE,
        PreScale
    );
#if (NUM_BUFFERS > 2)
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, indices);
#else
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
#endif
#endif
    error = glGetError();
    if (error != GL_NO_ERROR)
        DisplayGLError("Problem scaling the frame drawing.", error);
    return 0;
}

static void do_frame_buffer_proper(
    UINT32 prescale_ptr, int hres, int vres, int vitype, int linecount)
{
    GLubyte bgra[4];
    GLuint* scanline;
    static CCVG viaa_array[0xA10 << 1];
    static CCVG divot_array[0xA10 << 1];
    CCVG *viaa_cache, *viaa_cache_next, *divot_cache, *divot_cache_next;
    CCVG *tempccvgptr;
    CCVG color, nextcolor, scancolor, scannextcolor;
    int x_start;
    int slowbright;
    register int i, j;
    UINT32 pixels = 0, nextpixels = 0;
    UINT32 prevy = 0;
    UINT32 y_start = (GET_RCP_REG(VI_Y_SCALE_REG) >> 16) & 0x0FFF;
    UINT32 frame_buffer = GET_RCP_REG(VI_ORIGIN_REG) & 0x00FFFFFF;
    signed int cache_marker_init;
    int line_x = 0, next_line_x = 0, prev_line_x = 0, far_line_x = 0;
    int prev_scan_x = 0, scan_x = 0, next_scan_x = 0, far_scan_x = 0;
    int prev_x = 0, cur_x = 0, next_x = 0, far_x = 0;
    int cache_marker = 0, cache_next_marker = 0, divot_cache_marker = 0, divot_cache_next_marker = 0;
    int xfrac = 0, yfrac = 0;
    int lerping = 0;
    const int vi_width_low = GET_RCP_REG(VI_WIDTH_REG) & 0x00000FFF;
    const int x_add = GET_RCP_REG(VI_X_SCALE_REG) & 0x00000FFF;
    const int y_add = GET_RCP_REG(VI_Y_SCALE_REG) & 0x00000FFF;
    const int gamma_dither     = !!(GET_RCP_REG(VI_STATUS_REG) & 0x00000004);
    const int gamma            = !!(GET_RCP_REG(VI_STATUS_REG) & 0x00000008);
    const int divot            = !!(GET_RCP_REG(VI_STATUS_REG) & 0x00000010);
    const int clock_enable     = !!(GET_RCP_REG(VI_STATUS_REG) & 0x00000020);
    const int extralines       =  !(GET_RCP_REG(VI_STATUS_REG) & 0x00000100);
    const int fsaa             =  !(GET_RCP_REG(VI_STATUS_REG) & 0x00000200);
    const int dither_filter    = !!(GET_RCP_REG(VI_STATUS_REG) & 0x00010000);
    const int gamma_and_dither = (gamma << 1) | gamma_dither;
    const int lerp_en          = fsaa | extralines;

    if (frame_buffer == 0)
        return;

    if (clock_enable)
        DisplayError(
            "rdp_update: vbus_clock_enable bit set in VI_CONTROL_REG "\
            "register. Never run this code on your N64! It's rumored that "\
            "turning this bit on will result in permanent damage to the "\
            "hardware! Emulation will now continue.");

    viaa_cache = &viaa_array[0];
    viaa_cache_next = &viaa_array[0xA10];
    divot_cache = &divot_array[0];
    divot_cache_next = &divot_array[0xA10];

    cache_marker_init = (x_start_init >> 10) - 1;

    slowbright = 0;
#ifdef WIN32
    if (GetAsyncKeyState(0x91))
        brightness = ++brightness & 0xF;
    slowbright = brightness >> 1;
#endif
    pixels = 0;

    for (j = 0; j < vres; j++)
    {
        x_start = x_start_init;

        if ((y_start >> 10) == (prevy + 1) && j)
        {
            cache_marker = cache_next_marker;
            cache_next_marker = cache_marker_init;

            tempccvgptr = viaa_cache;
            viaa_cache = viaa_cache_next;
            viaa_cache_next = tempccvgptr;
            if (divot == 0)
                {/* do nothing and branch */}
            else
            {
                divot_cache_marker = divot_cache_next_marker;
                divot_cache_next_marker = cache_marker_init;
                tempccvgptr = divot_cache;
                divot_cache = divot_cache_next;
                divot_cache_next = tempccvgptr;
            }
        }
        else if ((y_start >> 10) != prevy || !j)
        {
            cache_marker = cache_next_marker = cache_marker_init;
            if (divot == 0)
                {/* do nothing and branch */}
            else
                divot_cache_marker
              = divot_cache_next_marker
              = cache_marker_init;
        }

        scanline = &PreScale[prescale_ptr];
        prescale_ptr += linecount;

        prevy = y_start >> 10;
        yfrac = (y_start >> 5) & 0x1f;
        pixels = vi_width_low * prevy;
        nextpixels = pixels + vi_width_low;

        for (i = 0; i < hres; i++)
        {
            line_x = x_start >> 10;
            prev_line_x = line_x - 1;
            next_line_x = line_x + 1;
            far_line_x = line_x + 2;

            cur_x = pixels + line_x;
            prev_x = pixels + prev_line_x;
            next_x = pixels + next_line_x;
            far_x = pixels + far_line_x;

            scan_x = nextpixels + line_x;
            prev_scan_x = nextpixels + prev_line_x;
            next_scan_x = nextpixels + next_line_x;
            far_scan_x = nextpixels + far_line_x;

            line_x++;
            prev_line_x++;
            next_line_x++;
            far_line_x++;

            xfrac = (x_start >> 5) & 0x1f;
            lerping = lerp_en & (xfrac || yfrac);

            if (prev_line_x > cache_marker)
            {
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache[prev_line_x], frame_buffer, prev_x, fsaa,
                    dither_filter, vres);
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache[line_x], frame_buffer, cur_x, fsaa,
                    dither_filter, vres);
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache[next_line_x], frame_buffer, next_x, fsaa,
                    dither_filter, vres);
                cache_marker = next_line_x;
            }
            else if (line_x > cache_marker)
            {
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache[line_x], frame_buffer, cur_x, fsaa,
                    dither_filter, vres);
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache[next_line_x], frame_buffer, next_x, fsaa,
                    dither_filter, vres);
                cache_marker = next_line_x;
            }
            else if (next_line_x > cache_marker)
            {
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache[next_line_x], frame_buffer, next_x, fsaa,
                    dither_filter, vres);
                cache_marker = next_line_x;
            }

            if (prev_line_x > cache_next_marker)
            {
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache_next[prev_line_x], frame_buffer, prev_scan_x,
                    fsaa, dither_filter, vres);
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache_next[line_x], frame_buffer, scan_x, fsaa,
                    dither_filter, vres);
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache_next[next_line_x], frame_buffer, next_scan_x,
                    fsaa, dither_filter, vres);
                cache_next_marker = next_line_x;
            }
            else if (line_x > cache_next_marker)
            {
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache_next[line_x], frame_buffer, scan_x, fsaa,
                    dither_filter, vres);
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache_next[next_line_x], frame_buffer, next_scan_x,
                    fsaa, dither_filter, vres);
                cache_next_marker = next_line_x;
            }
            else if (next_line_x > cache_next_marker)
            {
                vi_fetch_filter_func[vitype & 1](
                    &viaa_cache_next[next_line_x], frame_buffer, next_scan_x,
                    fsaa, dither_filter, vres);
                cache_next_marker = next_line_x;
            }

            if (divot == 0)
                color = viaa_cache[line_x];
            else
            {
                if (far_line_x > cache_marker)
                {
                    vi_fetch_filter_func[vitype & 1](
                        &viaa_cache[far_line_x], frame_buffer, far_x, fsaa,
                        dither_filter, vres);
                    cache_marker = far_line_x;
                }

                if (far_line_x > cache_next_marker)
                {
                    vi_fetch_filter_func[vitype & 1](
                        &viaa_cache_next[far_line_x], frame_buffer, far_scan_x,
                        fsaa, dither_filter, vres);
                    cache_next_marker = far_line_x;
                }

                if (line_x > divot_cache_marker)
                {
                    divot_filter(
                        &divot_cache[line_x], viaa_cache[line_x],
                        viaa_cache[prev_line_x], viaa_cache[next_line_x]);
                    divot_filter(
                        &divot_cache[next_line_x], viaa_cache[next_line_x],
                        viaa_cache[line_x], viaa_cache[far_line_x]);
                    divot_cache_marker = next_line_x;
                }
                else if (next_line_x > divot_cache_marker)
                {
                    divot_filter(
                        &divot_cache[next_line_x], viaa_cache[next_line_x],
                        viaa_cache[line_x], viaa_cache[far_line_x]);
                    divot_cache_marker = next_line_x;
                }

                if (line_x > divot_cache_next_marker)
                {
                    divot_filter(
                        &divot_cache_next[line_x], viaa_cache_next[line_x],
                        viaa_cache_next[prev_line_x],
                        viaa_cache_next[next_line_x]);
                    divot_filter(
                        &divot_cache_next[next_line_x],
                        viaa_cache_next[next_line_x], viaa_cache_next[line_x],
                        viaa_cache_next[far_line_x]);
                    divot_cache_next_marker = next_line_x;
                }
                else if (next_line_x > divot_cache_next_marker)
                {
                    divot_filter(
                        &divot_cache_next[next_line_x],
                        viaa_cache_next[next_line_x], viaa_cache_next[line_x],
                        viaa_cache_next[far_line_x]);
                    divot_cache_next_marker = next_line_x;
                }
                color = divot_cache[line_x];
            }

            if (lerping)
            {
                if (divot == 0)
                { /* branch unlikely */
                    nextcolor = viaa_cache[next_line_x];
                    scancolor = viaa_cache_next[line_x];
                    scannextcolor = viaa_cache_next[next_line_x];
                }
                else
                {
                    nextcolor = divot_cache[next_line_x];
                    scancolor = divot_cache_next[line_x];
                    scannextcolor = divot_cache_next[next_line_x];
                }
                if (yfrac == 0)
                    {}
                else
                {
                    vi_vl_lerp(&color, scancolor, yfrac);
                    vi_vl_lerp(&nextcolor, scannextcolor, yfrac);
                }
                if (xfrac == 0)
                    {}
                else
                    vi_vl_lerp(&color, nextcolor, xfrac);
            }
            bgra[0] = color.rgba[CCVG_BLU];
            bgra[1] = color.rgba[CCVG_GRN];
            bgra[2] = color.rgba[CCVG_RED];

            gamma_filters(bgra, gamma_and_dither);
#ifdef BW_ZBUFFER
            UINT32 tempz = RREADIDX16((frame_buffer >> 1) + cur_x);

            pix = tempz;
            bgra[0] = bgra[1] = bgra[2] = pix >> 8;
#endif
#ifdef ZBUFF_AS_16B_IATEXTURE
            bgra[0] = bgra[1] = bgra[2] =
                (unsigned char)(pix >> 8)*(unsigned char)(pix >> 0) >> 8;
#endif
#ifdef RENDER_CVG_BITS16
            bgra[0] = bgra[1] = bgra[2] = cur_cvg << 5;
#endif
#ifdef RENDER_CVG_BITS32
            bgra[0] = bgra[1] = bgra[2] = cur_cvg << 5;
#endif
#ifdef RENDER_MIN_CVG_ONLY
            if (!cur_cvg)
                bgra[0] = bgra[1] = bgra[2] = 0x00;
            else
                bgra[0] = bgra[1] = bgra[2] = 0xFF;
#endif
#ifdef RENDER_MAX_CVG_ONLY
            if (cur_cvg != 7)
                bgra[0] = bgra[1] = bgra[2] = 0x00;
            else
                bgra[0] = bgra[1] = bgra[2] = 0xFF;
#endif
            x_start += x_add;

            scanline[i] = 0x00000000; /* blank pixel if VI discarded data */
            if (i < hpass_minmax[0])
                continue;
            if (i >= hpass_minmax[1])
                continue;
            scanline[i] = *(GLint *)bgra;
            if (slowbright == 0)
                continue; /* branch very likely */
            adjust_brightness(bgra, slowbright);
            scanline[i] = *(GLint *)bgra;
        }
        y_start += y_add;
    }
}
static void do_frame_buffer_raw(
    UINT32 prescale_ptr, int hres, int vres, int vitype, int linecount)
{
    GLubyte bgra[4];
    GLuint* scanline;
    int pixels;
    int prevy, x_start, y_start;
    int cur_x, line_x;
    register int i;
    const int frame_buffer = GET_RCP_REG(VI_ORIGIN_REG) & 0x00FFFFFF;
    const int VI_width = GET_RCP_REG(VI_WIDTH_REG) & 0x00000FFF;
    const int x_add = GET_RCP_REG(VI_X_SCALE_REG) & 0x00000FFF;
    const int y_add = GET_RCP_REG(VI_Y_SCALE_REG) & 0x00000FFF;

    if (frame_buffer == 0)
        return;
    bgra[3] = 0xFF;
    y_start = GET_RCP_REG(VI_Y_SCALE_REG)>>16 & 0x0FFF;

    if (vitype & 1) /* 32-bit RGBA (branch unlikely) */
    {
        while (--vres >= 0)
        {
            x_start = x_start_init;
            scanline = &PreScale[prescale_ptr];
            prescale_ptr += linecount;

            prevy = y_start >> 10;
            pixels = VI_width * prevy;

            for (i = 0; i < hres; i++)
            {
                GLuint pixel;
                unsigned long addr;

                line_x = x_start >> 10;
                cur_x = pixels + line_x;
                x_start += x_add;
                addr = frame_buffer + 4*cur_x;

                scanline[i] = 0x00000000;
                if (i < hpass_minmax[0])
                    continue;
                if (i >= hpass_minmax[1])
                    continue;
                if (plim < addr)
                    continue;
                pixel = *(GLuint *)(DRAM + addr);
                bgra[2] = (pixel >> 24) & 0xFF;
                bgra[1] = (pixel >> 16) & 0xFF;
                bgra[0] = (pixel >>  8) & 0xFF;
             /* bgra[3] = (pixel >>  0) & 0xFF; */
                scanline[i] = *(GLuint *)(bgra);
            }
            y_start += y_add;
        }
    }
    else /* 16-bit RRRRR GGGGG BBBBB A */
    {
        while (--vres >= 0)
        {
            x_start = x_start_init;
            scanline = &PreScale[prescale_ptr];
            prescale_ptr += linecount;

            prevy = y_start >> 10;
            pixels = VI_width * prevy;

            for (i = 0; i < hres; i++)
            {
                GLushort pixel;
                unsigned long addr;

                line_x = x_start >> 10;
                cur_x = pixels + line_x;

                x_start += x_add;
                addr = frame_buffer + 2*cur_x;

                scanline[i] = 0x00000000;
                if (i < hpass_minmax[0])
                    continue;
                if (i >= hpass_minmax[1])
                    continue;
                if (plim < addr)
                    continue;
                addr = addr ^ (WORD_ADDR_XOR << 1);
                pixel = *(GLushort *)(DRAM + addr);
                bgra[2] = (pixel & 0xF800U) >> (11 - 3);
                bgra[1] = (pixel & 0x07C0U) >> ( 6 - 3);
                bgra[0] = (pixel & 0x003EU) << 2 >> (1 - 1);
             /* bgra[3] = (pixel & 0x0001U) ? ~0x00 : 0x00; */
                scanline[i] = *(GLuint *)(bgra);
            }
            y_start += y_add;
        }
    }
    return;
}

static void vi_fetch_filter16(
    CCVG* res, UINT32 fboffset, UINT32 cur_x, UINT32 fsaa, UINT32 dither_filter,
    UINT32 vres)
{
    UINT32 pix, hval;
    UINT32 idx;
    unsigned int cur_cvg;
    const unsigned short fbw = GET_RCP_REG(VI_WIDTH_REG) & 0x00000FFFUL;

    idx = (2*cur_x + fboffset)>>1 & (0x00FFFFFFUL >> 1);
    if (fsaa)
    {
        PAIRREAD16(pix, hval, idx);
        cur_cvg = (4*pix + hval) & 7;
    }
    else
    {
        pix = RREADIDX16(idx);
        cur_cvg = 7;
    }

    res->rgba[CCVG_RED] = GET_HI(pix);
    res->rgba[CCVG_GRN] = GET_MED(pix);
    res->rgba[CCVG_BLU] = GET_LOW(pix);
    res->rgba[CCVG_CVG] = cur_cvg;

    if (cur_cvg == 7)
    {
        if (dither_filter)
            restore_filter16(res, fboffset, cur_x, fbw);
    }
    else
    {
        video_filter16(res, fboffset, cur_x, fbw);
    }
    return;
}

static void vi_fetch_filter32(
    CCVG* res, UINT32 fboffset, UINT32 cur_x, UINT32 fsaa, UINT32 dither_filter,
    UINT32 vres)
{
    UINT32 pix = RREADIDX32((fboffset >> 2) + cur_x);
    UINT32 fbw = *GET_GFX_INFO(VI_WIDTH_REG) & 0x00000FFF;

    res->rgba[CCVG_CVG]  = pix >> 5;
    res->rgba[CCVG_CVG] |= (fsaa &= 1) ? 0 : ~0;
    res->rgba[CCVG_CVG] &= 07;

    res->rgba[CCVG_RED] = (pix >> 24) & 0xFF;
    res->rgba[CCVG_GRN] = (pix >> 16) & 0xFF;
    res->rgba[CCVG_BLU] = (pix >>  8) & 0xFF;

    if (res->rgba[CCVG_CVG] == 7)
    {
        if (dither_filter)
            restore_filter32(res, fboffset, cur_x, fbw);
    }
    else
    {
        video_filter32(res, fboffset, cur_x, fbw);
    }
    return;
}

static void video_filter16(CCVG* res, UINT32 fboffset, UINT32 num, UINT32 hres)
{
    ALIGNED unsigned int rgb[3 + 1];
    ALIGNED unsigned int col_rgb[3 + 1];
    ALIGNED unsigned int penu_max_rgb[3 + 1], penu_min_rgb[3 + 1];
    UINT32 backr[7], backg[7], backb[7];
    UINT16 pix;
    UINT32 hidval;
    UINT32 n_full = 1;

    UINT32 idx = (fboffset >> 1) + num;
    UINT32 leftup = idx - hres - 1;
    UINT32 rightup = idx - hres + 1;
    UINT32 toleft = idx - 2;
    UINT32 toright = idx + 2;
    UINT32 leftdown = idx + hres - 1;
    UINT32 rightdown = idx + hres + 1;
    UINT32 coeff = res->rgba[CCVG_CVG] ^ 7;

    rgb[0] = res -> rgba[CCVG_RED];
    rgb[1] = res -> rgba[CCVG_GRN];
    rgb[2] = res -> rgba[CCVG_BLU];

    backr[0] = rgb[0];
    backg[0] = rgb[1];
    backb[0] = rgb[2];

/*
 *  x x
 * x X x // VI interpolation of pixels
 *  x x
 */
    VI_ANDER(leftup);
    VI_ANDER(rightup);
    VI_ANDER(toleft);
    VI_ANDER(toright);
    VI_ANDER(leftdown);
    VI_ANDER(rightdown);

    video_max_optimized(&backr[0], &penu_min_rgb[0], &penu_max_rgb[0], n_full);
    video_max_optimized(&backg[0], &penu_min_rgb[1], &penu_max_rgb[1], n_full);
    video_max_optimized(&backb[0], &penu_min_rgb[2], &penu_max_rgb[2], n_full);

    col_rgb[0] = penu_min_rgb[0] + penu_max_rgb[0] - (rgb[0] << 1);
    col_rgb[1] = penu_min_rgb[1] + penu_max_rgb[1] - (rgb[1] << 1);
    col_rgb[2] = penu_min_rgb[2] + penu_max_rgb[2] - (rgb[2] << 1);

    col_rgb[0] = (((col_rgb[0] * coeff) + 4) >> 3) + rgb[0];
    col_rgb[1] = (((col_rgb[1] * coeff) + 4) >> 3) + rgb[1];
    col_rgb[2] = (((col_rgb[2] * coeff) + 4) >> 3) + rgb[2];

    res->rgba[CCVG_RED] = col_rgb[0] & 0xFF;
    res->rgba[CCVG_GRN] = col_rgb[1] & 0xFF;
    res->rgba[CCVG_BLU] = col_rgb[2] & 0xFF;
    return;
}

static void video_filter32(CCVG* res, UINT32 fboffset, UINT32 num, UINT32 hres)
{
    ALIGNED unsigned int rgb[3 + 1];
    ALIGNED unsigned int col_rgb[3 + 1];
    ALIGNED unsigned int penu_max_rgb[3 + 1], penu_min_rgb[3 + 1];
    UINT32 backr[7], backg[7], backb[7];
    UINT32 pix = 0, pixcvg = 0;
    UINT32 n_full = 1;

    UINT32 idx = (fboffset >> 2) + num;
    UINT32 leftup = idx - hres - 1;
    UINT32 rightup = idx - hres + 1;
    UINT32 toleft = idx - 2;
    UINT32 toright = idx + 2;
    UINT32 leftdown = idx + hres - 1;
    UINT32 rightdown = idx + hres + 1;
    UINT32 coeff = 7 ^ res -> rgba[CCVG_CVG];

    rgb[0] = res -> rgba[CCVG_RED];
    rgb[1] = res -> rgba[CCVG_GRN];
    rgb[2] = res -> rgba[CCVG_BLU];

    backr[0] = rgb[0];
    backg[0] = rgb[1];
    backb[0] = rgb[2];

    VI_ANDER32(leftup);
    VI_ANDER32(rightup);
    VI_ANDER32(toleft);
    VI_ANDER32(toright);
    VI_ANDER32(leftdown);
    VI_ANDER32(rightdown);

    video_max_optimized(&backr[0], &penu_min_rgb[0], &penu_max_rgb[0], n_full);
    video_max_optimized(&backg[0], &penu_min_rgb[1], &penu_max_rgb[1], n_full);
    video_max_optimized(&backb[0], &penu_min_rgb[2], &penu_max_rgb[2], n_full);

    col_rgb[0] = penu_min_rgb[0] + penu_max_rgb[0] - (rgb[0] << 1);
    col_rgb[1] = penu_min_rgb[1] + penu_max_rgb[1] - (rgb[1] << 1);
    col_rgb[2] = penu_min_rgb[2] + penu_max_rgb[2] - (rgb[2] << 1);

    col_rgb[0] = (((col_rgb[0] * coeff) + 4) >> 3) + rgb[0];
    col_rgb[1] = (((col_rgb[1] * coeff) + 4) >> 3) + rgb[1];
    col_rgb[2] = (((col_rgb[2] * coeff) + 4) >> 3) + rgb[2];

    res->rgba[CCVG_RED] = col_rgb[0] & 0xFF;
    res->rgba[CCVG_GRN] = col_rgb[1] & 0xFF;
    res->rgba[CCVG_BLU] = col_rgb[2] & 0xFF;
    return;
}

static void divot_filter(
    CCVG* final, CCVG center, CCVG left, CCVG right)
{
    CCVG* outcomes[3];
    ALIGNED signed int
        l_rgb[4], c_rgb[4], r_rgb[4], lb_rgb[4], cb_rgb[4], rb_rgb[4];
    register int i;

    *final = center;
    i = center.rgba[CCVG_CVG] & left.rgba[CCVG_CVG] & right.rgba[CCVG_CVG];
    if (i == 0x07)
        return;

    outcomes[0] = &left;
    outcomes[1] = final;
    outcomes[2] = &right;

    l_rgb[0] = left.rgba[CCVG_RED];
    l_rgb[1] = left.rgba[CCVG_GRN];
    l_rgb[2] = left.rgba[CCVG_BLU];
    r_rgb[0] = right.rgba[CCVG_RED];
    r_rgb[1] = right.rgba[CCVG_GRN];
    r_rgb[2] = right.rgba[CCVG_BLU];
    c_rgb[0] = center.rgba[CCVG_RED];
    c_rgb[1] = center.rgba[CCVG_GRN];
    c_rgb[2] = center.rgba[CCVG_BLU];

    copy_si128(lb_rgb, l_rgb);
    copy_si128(rb_rgb, r_rgb);
    copy_si128(cb_rgb, c_rgb);

    for (i = 0; i < 4; i++)
        c_rgb[i] -= r_rgb[i];
    for (i = 0; i < 4; i++)
        l_rgb[i] -= r_rgb[i];
    copy_si128(r_rgb, c_rgb);
    for (i = 0; i < 4; i++)
        r_rgb[i] &= l_rgb[i];
    for (i = 0; i < 4; i++)
        l_rgb[i]  = -l_rgb[i];
    for (i = 0; i < 4; i++)
        c_rgb[i]  = -c_rgb[i];
    for (i = 0; i < 4; i++)
        l_rgb[i] &= c_rgb[i];
    for (i = 0; i < 4; i++)
        r_rgb[i] |= l_rgb[i];
    final->rgba[CCVG_RED] = outcomes[SIGN_MSB(r_rgb[0]) + 2] -> rgba[CCVG_RED];
    final->rgba[CCVG_GRN] = outcomes[SIGN_MSB(r_rgb[1]) + 2] -> rgba[CCVG_GRN];
    final->rgba[CCVG_BLU] = outcomes[SIGN_MSB(r_rgb[2]) + 2] -> rgba[CCVG_BLU];

    copy_si128(l_rgb, lb_rgb);
    copy_si128(r_rgb, rb_rgb);
    copy_si128(c_rgb, cb_rgb);

    for (i = 0; i < 4; i++)
        c_rgb[i] -= l_rgb[i];
    for (i = 0; i < 4; i++)
        r_rgb[i] -= l_rgb[i];
    copy_si128(l_rgb, c_rgb);
    for (i = 0; i < 4; i++)
        l_rgb[i] &= r_rgb[i];
    for (i = 0; i < 4; i++)
        c_rgb[i]  = -c_rgb[i];
    for (i = 0; i < 4; i++)
        r_rgb[i]  = -r_rgb[i];
    for (i = 0; i < 4; i++)
        r_rgb[i] &= c_rgb[i];
    for (i = 0; i < 4; i++)
        l_rgb[i] |= r_rgb[i];
    final->rgba[CCVG_RED] = outcomes[ZERO_MSB(l_rgb[0])] -> rgba[CCVG_RED];
    final->rgba[CCVG_GRN] = outcomes[ZERO_MSB(l_rgb[1])] -> rgba[CCVG_GRN];
    final->rgba[CCVG_BLU] = outcomes[ZERO_MSB(l_rgb[2])] -> rgba[CCVG_BLU];
    return;
}

static void restore_filter16(
    CCVG* res, UINT32 fboffset, UINT32 num, UINT32 hres)
{
    UINT32 tempr, tempg, tempb;
    UINT16 pix;

    UINT32 idx = (fboffset >> 1) + num;
    UINT32 leftuppix = idx - hres - 1;
    UINT32 leftdownpix = idx + hres - 1;
    UINT32 toleftpix = idx - 1;
    UINT32 maxpix = idx + hres + 1;

    int rend = res -> rgba[CCVG_RED];
    int gend = res -> rgba[CCVG_GRN];
    int bend = res -> rgba[CCVG_BLU];
    const int* redptr   = &vi_restore_table[(rend << 2) & 0x03E0];
    const int* greenptr = &vi_restore_table[(gend << 2) & 0x03E0];
    const int* blueptr  = &vi_restore_table[(bend << 2) & 0x03E0];

    if (maxpix <= idxlim16 && leftuppix <= idxlim16)
    {
        VI_COMPARE_OPT(leftuppix);
        VI_COMPARE_OPT(leftuppix + 1);
        VI_COMPARE_OPT(leftuppix + 2);
        VI_COMPARE_OPT(leftdownpix);
        VI_COMPARE_OPT(leftdownpix + 1);
        VI_COMPARE_OPT(maxpix);
        VI_COMPARE_OPT(toleftpix);
        VI_COMPARE_OPT(toleftpix + 2);
    }
    else
    {
        VI_COMPARE(leftuppix);
        VI_COMPARE(leftuppix + 1);
        VI_COMPARE(leftuppix + 2);
        VI_COMPARE(leftdownpix);
        VI_COMPARE(leftdownpix + 1);
        VI_COMPARE(maxpix);
        VI_COMPARE(toleftpix);
        VI_COMPARE(toleftpix + 2);
    }

    res->rgba[CCVG_RED] = rend & 0xFF;
    res->rgba[CCVG_GRN] = gend & 0xFF;
    res->rgba[CCVG_BLU] = bend & 0xFF;
    return;
}

static void restore_filter32(
    CCVG* res, UINT32 fboffset, UINT32 num, UINT32 hres)
{
    UINT32 tempr, tempg, tempb;
    UINT32 pix;

    UINT32 idx = (fboffset >> 2) + num;
    UINT32 leftuppix = idx - hres - 1;
    UINT32 leftdownpix = idx + hres - 1;
    UINT32 toleftpix = idx - 1;
    UINT32 maxpix = idx + hres + 1;

    int rend = res -> rgba[CCVG_RED];
    int gend = res -> rgba[CCVG_GRN];
    int bend = res -> rgba[CCVG_BLU];
    const int* redptr   = &vi_restore_table[(rend << 2) & 0x03E0];
    const int* greenptr = &vi_restore_table[(gend << 2) & 0x03E0];
    const int* blueptr  = &vi_restore_table[(bend << 2) & 0x03E0];

    if (maxpix <= idxlim32 && leftuppix <= idxlim32)
    {
        VI_COMPARE32_OPT(leftuppix);
        VI_COMPARE32_OPT(leftuppix + 1);
        VI_COMPARE32_OPT(leftuppix + 2);
        VI_COMPARE32_OPT(leftdownpix);
        VI_COMPARE32_OPT(leftdownpix + 1);
        VI_COMPARE32_OPT(maxpix);
        VI_COMPARE32_OPT(toleftpix);
        VI_COMPARE32_OPT(toleftpix + 2);
    }
    else
    {
        VI_COMPARE32(leftuppix);
        VI_COMPARE32(leftuppix + 1);
        VI_COMPARE32(leftuppix + 2);
        VI_COMPARE32(leftdownpix);
        VI_COMPARE32(leftdownpix + 1);
        VI_COMPARE32(maxpix);
        VI_COMPARE32(toleftpix);
        VI_COMPARE32(toleftpix + 2);
    }

    res->rgba[CCVG_RED] = rend & 0xFF;
    res->rgba[CCVG_GRN] = gend & 0xFF;
    res->rgba[CCVG_BLU] = bend & 0xFF;
    return;
}

static void gamma_filters(unsigned char* bgra, int gamma_and_dither)
{
    int cdith, dith;
    int r, g, b;

    r = bgra[2];
    g = bgra[1];
    b = bgra[0];

    switch (gamma_and_dither)
    {
        case 0:
            return;
            break;
        case 1:
            cdith = irand();
            r += cdith & (r < 255);
            cdith = cdith >> 1;
            g += cdith & (g < 255);
            cdith = cdith >> 2;
            b += cdith & (b < 255);
            break;
        case 2:
            r = gamma_table[r];
            g = gamma_table[g];
            b = gamma_table[b];
            break;
        case 3:
            cdith = irand();
            dith = cdith & 0x3F;
            r = gamma_dither_table[(r << 6) | dith];
            dith = (cdith >> 6) & 0x3F;
            g = gamma_dither_table[(g << 6) | dith];
            dith = ((cdith >> 9) & 0x38) | (cdith & 0x07);
            b = gamma_dither_table[(b << 6) | dith];
            break;
    }
    bgra[2] = (unsigned char)(r);
    bgra[1] = (unsigned char)(g);
    bgra[0] = (unsigned char)(b);
    return;
}

static void adjust_brightness(unsigned char* bgra, int brightcoeff)
{
    int r, g, b;

    r = bgra[2];
    g = bgra[1];
    b = bgra[0];
    brightcoeff &= 7;
    switch (brightcoeff)
    {
        case 0:    
            break;
        case 1: 
        case 2:
        case 3:
            r += (r >> (4 - brightcoeff));
            g += (g >> (4 - brightcoeff));
            b += (b >> (4 - brightcoeff));
            if (r > 0xFF)
                r = 0xFF;
            if (g > 0xFF)
                g = 0xFF;
            if (b > 0xFF)
                b = 0xFF;
            break;
        case 4:
        case 5:
        case 6:
        case 7:
            r = (r + 1) << (brightcoeff - 3);
            g = (g + 1) << (brightcoeff - 3);
            b = (b + 1) << (brightcoeff - 3);
            if (r > 0xFF)
                r = 0xFF;
            if (g > 0xFF)
                g = 0xFF;
            if (b > 0xFF)
                b = 0xFF;
            break;
    }
    bgra[2] = (unsigned char)(r);
    bgra[1] = (unsigned char)(g);
    bgra[0] = (unsigned char)(b);
    return;
}

static void vi_vl_lerp(CCVG* up, CCVG down, UINT32 frac)
{
    ALIGNED UINT32 rgb_0[3 + 1];

    if (frac == 0)
        return;

    rgb_0[0] = up -> rgba[CCVG_RED];
    rgb_0[1] = up -> rgba[CCVG_GRN];
    rgb_0[2] = up -> rgba[CCVG_BLU];

    up->rgba[CCVG_RED] =
        (((frac*(down.rgba[CCVG_RED] - rgb_0[0]) + 16) >> 5) + rgb_0[0]) & 0xFF;
    up->rgba[CCVG_GRN] =
        (((frac*(down.rgba[CCVG_GRN] - rgb_0[1]) + 16) >> 5) + rgb_0[1]) & 0xFF;
    up->rgba[CCVG_BLU] =
        (((frac*(down.rgba[CCVG_BLU] - rgb_0[2]) + 16) >> 5) + rgb_0[2]) & 0xFF;
    return;
}

static void video_max_optimized(
    UINT32* pixels, UINT32* penu_min, UINT32* penu_max, int elements)
{
    UINT32 max, min;
    UINT32 curpen_max, curpen_min;
    int posmax, posmin;
    register int i;

    posmax = posmin = 0;
    curpen_max = curpen_min = pixels[0];
    for (i = 1; i < elements; i++)
    {
        if (pixels[i] > pixels[posmax])
        {
            curpen_max = pixels[posmax];
            posmax = i;
        }
        else if (pixels[i] < pixels[posmin])
        {
            curpen_min = pixels[posmin];
            posmin = i;
        }
    }
    max = pixels[posmax];
    min = pixels[posmin];
    if (curpen_max == max)
        { /* branch */ }
    else
        for (i = posmax + 1; i < elements; i++)
            if (pixels[i] > curpen_max)
                curpen_max = pixels[i];
    if (curpen_min == min)
        { /* branch */ }
    else
        for (i = posmin + 1; i < elements; i++)
            if (pixels[i] < curpen_min)
                curpen_min = pixels[i];
    *penu_max = curpen_max;
    *penu_min = curpen_min;
    return;
}

NOINLINE void DisplayError(char * error)
{
#ifdef _WIN32
    const p_void hWnd = GET_GFX_INFO(hWnd);

    MessageBox(hWnd, error, NULL, MB_ICONERROR);
#else
    fputs(error, stderr);
    fputc('\n', stderr);
#endif
    return;
}
NOINLINE void DisplayWarning(char * warning)
{
#ifdef _WIN32
    const p_void hWnd = GET_GFX_INFO(hWnd);

    MessageBox(hWnd, warning, "Warning", MB_ICONWARNING);
#else
    fputs(warning, stdout);
    fputc('\n', stdout);
#endif
    return;
}

/*
 * idea picked up from the source to Nemu64 graphics plugin
 * thanks to Lemmy for the example
 */
NOINLINE void DisplayInStatusPanel(char * message)
{
#ifdef _WIN32
    const p_void hStatusBar = GET_GFX_INFO(hStatusBar);

    if (hStatusBar == NULL)
        DisplayWarning(message);
    else
        SendMessage(hStatusBar, SB_SETTEXT, 0x0000, (LPARAM)message);
#else
    puts(message);
#endif
    return;
}

NOINLINE void memfill(void * memory, unsigned char byte, size_t length)
{
#if defined(USE_SSE_SUPPORT)
    __m128i xmm;
#endif
    unsigned char * bytes;
    size_t count;

    bytes = (unsigned char *)memory;
#if defined(USE_SSE_SUPPORT)
    xmm = _mm_set1_epi8((unsigned char)byte);
    while (length >= 64)
    {
        _mm_storeu_si128((__m128i *)&bytes[length - 16*1], xmm);
        _mm_storeu_si128((__m128i *)&bytes[length - 16*2], xmm);
        _mm_storeu_si128((__m128i *)&bytes[length - 16*3], xmm);
        _mm_storeu_si128((__m128i *)&bytes[length - 16*4], xmm);
        length -= 64;
    }
    while (length >= 32)
    {
        _mm_storeu_si128((__m128i *)&bytes[length - 16*1], xmm);
        _mm_storeu_si128((__m128i *)&bytes[length - 16*2], xmm);
        length -= 32;
    }

    while (length >= 16)
    {
        _mm_storeu_si128((__m128i *)&bytes[length - 16*1], xmm);
        length -= 16;
    }
    switch (length & 0xF)
    {
    case 0xF:
        bytes[0xE] = byte;
    case 0xE:
        bytes[0xD] = byte;
    case 0xD:
        bytes[0xC] = byte;
    case 0xC:
        bytes[0xB] = byte;
    case 0xB:
        bytes[0xA] = byte;
    case 0xA:
        bytes[0x9] = byte;
    case 0x9:
        bytes[0x8] = byte;
    case 0x8:
        bytes[0x7] = byte;
    case 0x7:
        bytes[0x6] = byte;
    case 0x6:
        bytes[0x5] = byte;
    case 0x5:
        bytes[0x4] = byte;
    case 0x4:
        bytes[0x3] = byte;
    case 0x3:
        bytes[0x2] = byte;
    case 0x2:
        bytes[0x1] = byte;
    case 0x1:
        bytes[0x0] = byte;
    case 0x0:
        break;
    }
#else
    for (count = 0; count < length; count++)
        bytes[count] = byte;
#endif
    return;
}

NOINLINE int file_exists(char* path)
{
#if defined(_WIN32)
    HANDLE file;

    file = CreateFile(
        path,
        GENERIC_READ,
        0,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );
    if (file == INVALID_HANDLE_VALUE)
        return 0;
    while (CloseHandle(file) == 0)
        ;
#else
    FILE * file;

    file = fopen(path, "rb");
    if (file == NULL)
        return 0;
    while (fclose(file) != 0)
        ;
#endif
    return 1;
}

NOINLINE int file_in(const char* path, void* data, unsigned long length)
{
#ifdef _WIN32
    HANDLE file;
    DWORD read;
#else
    FILE * file;
    size_t read;
#endif
    int success;

#ifdef _WIN32
    file = CreateFile(
        path,
        GENERIC_READ,
        FILE_SHARE_READ,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );
    if (file == INVALID_HANDLE_VALUE)
        return 0;
    success  = ReadFile(file, data, length, &read, NULL);
    success &= CloseHandle(file);
#else
    file = fopen(path, "rb");
    if (file == NULL)
        return 0;
    read = fread(data, length, 1, file);
    while (fclose(file) != 0);
    success = (read != 0);
#endif
    return (success);
}

NOINLINE void file_out(const char* path, const void* data, unsigned long length)
{
#ifdef _WIN32
    HANDLE file;
    BOOL success;
    DWORD written;
#else
    FILE * file;
    int success;
#endif

#ifdef _WIN32
    file = CreateFile(
        path,
        GENERIC_WRITE,
        FILE_SHARE_WRITE,
        NULL,
        CREATE_ALWAYS,
        FILE_FLAG_WRITE_THROUGH,
        NULL
    );
    success  = (file != INVALID_HANDLE_VALUE);
    success &= WriteFile(file, data, length, &written, NULL);
    success &= CloseHandle(file);
#else
    file = fopen(path, "wb");
    success = fwrite(data, length, 1, file);
    while (fclose(file) != 0);
#endif
    if (success == 0)
        DisplayError("Failed to write file.\n");
    return;
}

NOINLINE void screen_resize(GLsizei width, GLsizei height)
{
#ifdef _WIN32
    RECT bigrect, smallrect, statusrect;
    int rightdiff;
    int bottomdiff;

    GetWindowRect(GFX_INFO_NAME.hWnd, &bigrect);
    GetClientRect(GFX_INFO_NAME.hWnd, &smallrect);
    rightdiff = width - smallrect.right;
    bottomdiff = height - smallrect.bottom;

    statusrect.left = 0;
    statusrect.bottom = 0;
    if (GFX_INFO_NAME.hStatusBar != NULL)
    {
        GetClientRect(GFX_INFO_NAME.hStatusBar, &statusrect);
        bottomdiff += statusrect.bottom;
    }

    MoveWindow(
        GFX_INFO_NAME.hWnd,
        bigrect.left,
        bigrect.top,
        bigrect.right - bigrect.left + rightdiff,
        bigrect.bottom - bigrect.top + bottomdiff,
        TRUE
    );
#else

#if defined(STUCK_WITH_SDL)
    video_surface = SDL_SetVideoMode(
        width, height,
        video_surface -> format -> BitsPerPixel,
        video_surface -> flags
    );
#else
    XResizeWindow(GLX_display, GLX_window, width, height);
#endif

#endif
    video_sync = 1;
    return;
}

NOINLINE void get_screen_size(int* dimensions)
{
#ifdef _WIN32
    int width, height;
    const HWND hWnd = GET_GFX_INFO(hWnd);

    width = GetDeviceCaps(device_context, HORZRES);
    height = GetDeviceCaps(device_context, VERTRES);
    *(dimensions + 0) = GetSystemMetrics(SM_CXSCREEN);
    *(dimensions + 1) = GetSystemMetrics(SM_CYSCREEN);
    if (dimensions[0] != width || dimensions[1] != height)
        DisplayWarning(
            "Conflicting monitor resolution information.\n"\
            "Perhaps you have more than one output device?"
        );
#else

#if defined(STUCK_WITH_SDL)
    *(dimensions + 0) = SDL_desktop[0];
    *(dimensions + 1) = SDL_desktop[1];
#else
    Screen * GLX_screen;

    GLX_screen = XDefaultScreenOfDisplay(GLX_display);
    *(dimensions + 0) = XWidthOfScreen(GLX_screen);
    *(dimensions + 1) = XHeightOfScreen(GLX_screen);
#endif

#endif
    return;
}

#ifdef _DEBUG
void trace_VI_registers(void)
{
    FILE * stream;

    stream = fopen("rcp_vi.txt", "w");
    if (stream == NULL)
    {
        DisplayError("Could not trace VI register segments.");
        return;
    }

    fprintf(stream, "VI_STATUS_REG :  %08X\n", GET_RCP_REG(VI_STATUS_REG));
    fprintf(stream, "VI_ORIGIN_REG :  %08X\n", GET_RCP_REG(VI_ORIGIN_REG));
    fprintf(stream, "VI_WIDTH_REG  :  %08X\n", GET_RCP_REG(VI_WIDTH_REG));
    fprintf(stream, "VI_INTR_REG   :  %08X\n", GET_RCP_REG(VI_INTR_REG));
    fprintf(stream, "VI_CURRENT_REG:  %08X\n",
        GET_RCP_REG(VI_V_CURRENT_LINE_REG));
    fprintf(stream, "VI_BURST_REG  :  %08X\n", GET_RCP_REG(VI_TIMING_REG));
    fprintf(stream, "VI_V_SYNC_REG :  %08X\n", GET_RCP_REG(VI_V_SYNC_REG));
    fprintf(stream, "VI_H_SYNC_REG :  %08X\n", GET_RCP_REG(VI_H_SYNC_REG));
    fprintf(stream, "VI_LEAP_REG   :  %08X\n", GET_RCP_REG(VI_LEAP_REG));
    fprintf(stream, "VI_H_VIDEO_REG:  %08X\n", GET_RCP_REG(VI_H_START_REG));
    fprintf(stream, "VI_V_VIDEO_REG:  %08X\n", GET_RCP_REG(VI_V_START_REG));
    fprintf(stream, "VI_V_BURST_REG:  %08X\n", GET_RCP_REG(VI_V_BURST_REG));
    fprintf(stream, "VI_X_SCALE_REG:  %08X\n", GET_RCP_REG(VI_X_SCALE_REG));
    fprintf(stream, "VI_Y_SCALE_REG:  %08X\n", GET_RCP_REG(VI_Y_SCALE_REG));
    fclose(stream);
    return;
}
#endif

NOINLINE void reform_image_canvas(int is_PAL, int non_interlaced)
{
    const unsigned int height = (is_PAL ? 576 : 480) >> non_interlaced;

    quad[(3*COORDS_PER_VTX << INTERLEAVED) + 0]
  = quad[(1*COORDS_PER_VTX << INTERLEAVED) + 0]
  = (640.f / 1024.f);
    quad[(1*COORDS_PER_VTX << INTERLEAVED) + 1]
  = quad[(0*COORDS_PER_VTX << INTERLEAVED) + 1]
  = (GLfloat)height / 1024.f;

    rebound_screen_texture(quad, ~cfg[23] & 2);
    return;
}
