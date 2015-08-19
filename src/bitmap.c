/******************************************************************************\
* Project:  File Formatting for Capturing Screen Pixel Maps                    *
* Authors:  Iconoclast                                                         *
* Release:  2014.05.19                                                         *
* License:  none                                                               *
\******************************************************************************/

#include <memory.h>
#ifdef _WIN32
#include <windows.h>
#endif

#include "bitmap.h"
#include "vi.h"

unsigned char file_data[1024*1024*3 + HEADERSIZE];

/*
 * multi-threading fix for N64 plugin system
 *
 * The thread that calls the screenshot procedure is not the same as the one
 * that created the OpenGL rendering context, so we need to delay captures.
 */
int thread_stage = STAGE_CAPTURE_THREAD;

NOINLINE void set_bitmap_header(int hres, int vres, unsigned char bpp)
{
    const unsigned int bytes_per_pixel = bpp >> 3;

    file_data[0] = 'B';
    file_data[1] = 'M';

    file_data[10] = (HEADERSIZE >>  0) & 0xFF;
    file_data[11] = (HEADERSIZE >>  8) & 0xFF;
    file_data[12] = (HEADERSIZE >> 16) & 0xFF;
    file_data[13] = (HEADERSIZE >> 24) & 0xFF;

    file_data[14] = 40;
    file_data[15] = 0x00;
    file_data[16] = 0x00;
    file_data[17] = 0x00;

    file_data[26] = 1;
    file_data[27] = 0x00;

    file_data[28] = bpp;
    file_data[29] = 0x00;

    file_data[18] = (hres >>  0) & 0xFF;
    file_data[19] = (hres >>  8) & 0xFF;
    file_data[20] = (hres >> 16) & 0xFF;
    file_data[21] = (hres >> 24) & 0xFF;
    file_data[22] = (vres >>  0) & 0xFF;
    file_data[23] = (vres >>  8) & 0xFF;
    file_data[24] = (vres >> 16) & 0xFF;
    file_data[25] = (vres >> 24) & 0xFF;

    file_data[34] = (bytes_per_pixel*hres*vres >>  0) & 0xFF;
    file_data[35] = (bytes_per_pixel*hres*vres >>  8) & 0xFF;
    file_data[36] = (bytes_per_pixel*hres*vres >> 16) & 0xFF;
    file_data[37] = (bytes_per_pixel*hres*vres >> 24) & 0xFF;

    file_data[ 2] = (bytes_per_pixel*hres*vres + HEADERSIZE)>> 0 & 0xFF;
    file_data[ 3] = (bytes_per_pixel*hres*vres + HEADERSIZE)>> 8 & 0xFF;
    file_data[ 4] = (bytes_per_pixel*hres*vres + HEADERSIZE)>>16 & 0xFF;
    file_data[ 5] = (bytes_per_pixel*hres*vres + HEADERSIZE)>>24 & 0xFF;
    return;
}

NOINLINE void capture_screen_to_file(char * path)
{
    GLenum error;
    GLsizei hres, vres;
    unsigned long size;
#ifdef _WIN32
    RECT screen_offset = { 0 };
    const p_void hStatusBar = GET_GFX_INFO(hStatusBar);
#endif
    const unsigned char bpp = 24;

    if (thread_stage < STAGE_CAPTURE_PENDING)
    {
        thread_stage = STAGE_CAPTURE_PENDING;
        return;
    }
    thread_stage = STAGE_REFRESH_THREAD_CAPTURE; /* called by UpdateScreen */

#ifdef _WIN32
    if (hStatusBar != NULL && is_full_screen == 0)
        GetClientRect(hStatusBar, &screen_offset);
#endif
    hres = (GLsizei)viewport[2];
    vres = (GLsizei)viewport[3];

    glPixelStorei(GL_PACK_ALIGNMENT, 1);
    glReadPixels(
#ifdef _WIN32
        screen_offset.left,
        screen_offset.bottom,
#else
        0, 0,
#endif
        hres,
        vres,
        GL_BGR,
        GL_UNSIGNED_BYTE,
        file_data + HEADERSIZE
    );
    error = glGetError();
    if (error != GL_NO_ERROR)
    {
        DisplayGLError("Failed to read DAC.", error);
        return;
    }

    size  = (hres*vres < 1024*1024) ? hres*vres : 1024*1024;
    size *= bpp >> 3;
    size += HEADERSIZE;
    set_bitmap_header(hres, vres, bpp);
    file_out(path, file_data, size);

    thread_stage = STAGE_CAPTURE_THREAD;
    return;
}

NOINLINE char safe_name(char character)
{
    char safe_char;
    const char fallback = '-';

#ifdef FORCE_WEB_SAFE_FILE_NAMES
    if (character >= '0' && character <= '9')
        safe_char = character;
    else if (character >= 'A' && character <= 'Z')
        safe_char = character;
    else if (character >= 'a' && character <= 'z')
        safe_char = character;
    else if (character == '_' || character == '-' || character == '.')
        safe_char = character;
    else
        safe_char = fallback;
#else
    safe_char = character;
    if (character < '\0' || character > 127) /* invalid ASCII */
        safe_char = fallback;
    if (character < ' ' || character > '~') /* nonprintable ASCII */
        safe_char = fallback;
#endif
    return (safe_char);
}

void capture_FB_to_file_16b(char * path)
{
    int h_start, v_start;
    register int x, y;
    int pixels;
    int hres, vres;
    int invisible_width;
    const int frame_buffer = GET_RCP_REG(VI_ORIGIN_REG) & 0x00FFFFFF;
    const int VI_width = GET_RCP_REG(VI_WIDTH_REG) & 0x00000FFF;
    const int x_add = GET_RCP_REG(VI_X_SCALE_REG) & 0x00000FFF;
    const int y_add = GET_RCP_REG(VI_Y_SCALE_REG) & 0x00000FFF;
    const int v_sync = GET_RCP_REG(VI_V_SYNC_REG) & 0x000003FF;
    const int ispal  = (v_sync > 550);
    const int x1 = (GET_RCP_REG(VI_H_START_REG) >> 16) & 0x03FF;
    const int y1 = (GET_RCP_REG(VI_V_START_REG) >> 16) & 0x03FF;
    const int x2 = (GET_RCP_REG(VI_H_START_REG) >>  0) & 0x03FF;
    const int y2 = (GET_RCP_REG(VI_V_START_REG) >>  0) & 0x03FF;
    const unsigned char bits_per_pixel = 16;
    const unsigned int bytes_per_pixel = bits_per_pixel >> 3;

    hres = x_add*(x2 - x1) / 1024;
    hres = hres & ~1; /* weird hres in some games */
    vres = y_add*(y2 - y1) / 1024;

    h_start = x1 - (ispal ? 128 : 108);
    v_start = y1 - (ispal ?  47 :  37);
    h_start = (h_start < 0) ? 0 : h_start;
    v_start = (v_start < 0) ? 0 : v_start;
    v_start >>= 1;
    vres >>= 1;

#if 0
    v_start  = (int)((float)vres * (480.f / 474.f));
    v_start += ((float)vres*(480.0f / 474.0f) - (float)v_start >= 0.5f);
    vres  = v_start;
    vres += (unsigned)(v_start) % 2;
#endif
    invisible_width = VI_width - hres;

    pixels = 0;
    for (y = vres - 1; y >= 0; y--)
    {
        unsigned char* scanline;

        scanline = file_data + HEADERSIZE + bytes_per_pixel*y*hres;
        for (x = 0; x < hres; x++)
        {
            UINT16 pixel;
            unsigned long addr;

            addr = frame_buffer + 2*pixels;
            ++pixels;
            if (plim - addr < 0) /* RDRAM access overflowing physical limit */
                continue;
            addr = addr ^ (WORD_ADDR_XOR << 1);
            pixel = *(INT16 *)(DRAM + addr);
/*
            r = (pixel & 0xF800) >> 11;
            g = (pixel & 0x07C0) >>  6;
            b = (pixel & 0x003E) >>  1;
            a = (pixel & 0x0001) >>  0;
            pixel = (a << 15) | (r << 10) | (g << 5) | (b << 0);
*/
            pixel = (pixel<<15 & 0x8000) | (pixel>>1 & 0x7FFF);
            *(scanline++) = (pixel >> 0) & 0xFF;
            *(scanline++) = (pixel >> 8) & 0xFF;
        }
        pixels += invisible_width;
    }
    set_bitmap_header(hres, vres, 16);
    file_out(path, file_data, bytes_per_pixel*hres*vres + HEADERSIZE);
    return;
}

void capture_FB_to_file_32b(char * path)
{
    register int x, y;
    int h_start, v_start;
    int pixels;
    int hres, vres;
    int invisible_width;
    const int frame_buffer = GET_RCP_REG(VI_ORIGIN_REG) & 0x00FFFFFF;
    const int VI_width = GET_RCP_REG(VI_WIDTH_REG) & 0x00000FFF;
    const int x_add = GET_RCP_REG(VI_X_SCALE_REG) & 0x00000FFF;
    const int y_add = GET_RCP_REG(VI_Y_SCALE_REG) & 0x00000FFF;
    const int v_sync = GET_RCP_REG(VI_V_SYNC_REG) & 0x000003FF;
    const int ispal  = (v_sync > 550);
    const int x1 = (GET_RCP_REG(VI_H_START_REG) >> 16) & 0x03FF;
    const int y1 = (GET_RCP_REG(VI_V_START_REG) >> 16) & 0x03FF;
    const int x2 = (GET_RCP_REG(VI_H_START_REG) >>  0) & 0x03FF;
    const int y2 = (GET_RCP_REG(VI_V_START_REG) >>  0) & 0x03FF;
    const unsigned char bits_per_pixel = 32;
    const unsigned int bytes_per_pixel = bits_per_pixel >> 3;

    hres = x_add*(x2 - x1) / 1024;
    vres = y_add*(y2 - y1) / 1024;

    h_start = x1 - (ispal ? 128 : 108);
    v_start = y1 - (ispal ?  47 :  37);
    h_start = (h_start < 0) ? 0 : h_start;
    v_start = (v_start < 0) ? 0 : v_start;
    v_start >>= 1;
    vres >>= 1;

#if 0
    v_start  = (int)((float)vres * (480.f / 474.f));
    v_start += ((float)vres*(480.0f / 474.0f) - (float)v_start >= 0.5f);
    vres  = v_start;
    vres += (unsigned)(v_start) % 2;
#endif
    invisible_width = VI_width - hres;

    pixels = 0;
    for (y = vres - 1; y >= 0; y--)
    {
        unsigned char* scanline;

        scanline = file_data + HEADERSIZE + bytes_per_pixel*y*hres;
        for (x = 0; x < hres; x++)
        {
            unsigned char pixel[4];
            unsigned long addr;

            addr = frame_buffer + 4*pixels;
            ++pixels;
            if (plim - addr < 0) /* RDRAM access overflowing physical limit */
                continue;
            *(i32 *)pixel = *(i32 *)(DRAM + addr);
            *(scanline++) = pixel[2 ^ BYTE_ADDR_XOR];
            *(scanline++) = pixel[1 ^ BYTE_ADDR_XOR];
            *(scanline++) = pixel[0 ^ BYTE_ADDR_XOR];
            *(scanline++) = pixel[3 ^ BYTE_ADDR_XOR];
        }
        pixels += invisible_width;
    }
    set_bitmap_header(hres, vres, 32);
    file_out(path, file_data, bytes_per_pixel*hres*vres + HEADERSIZE);
    return;
}

void (*capture_FB_to_file[2])(char * path) = {
    capture_FB_to_file_16b, capture_FB_to_file_32b
};
