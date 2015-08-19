#ifndef _BITMAP_H_
#define _BITMAP_H_

#include "gfx.h"
#include "z64.h"

#define PADDING             (10)
#define HEADERSIZE          (14 + 40 + PADDING)
#define PIXEL_COUNT         (PRESCALE_WIDTH * PRESCALE_HEIGHT)

#define RESOLUTION_H    2835
#define RESOLUTION_V    RESOLUTION_H

#ifndef _MAX_PATH
#define _MAX_PATH    256
#endif

enum {
    STAGE_CAPTURE_THREAD = -1,
    STAGE_CAPTURE_PENDING = 0,
    STAGE_REFRESH_THREAD_CAPTURE
};
extern int thread_stage;
extern int is_full_screen;

extern NOINLINE void set_bitmap_header(int hres, int vres, unsigned char bpp);
extern NOINLINE void capture_screen_to_file(char * path);
extern NOINLINE char safe_name(char character);

extern void capture_FB_to_file_16b(char * path);
extern void capture_FB_to_file_32b(char * path);

extern void (*capture_FB_to_file[2])(char * path);

#endif
