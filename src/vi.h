#ifndef _VI_H_
#define _VI_H_

#include <memory.h>
#include <stdio.h>
#ifdef _WIN32
#include <windows.h>
#include <commctrl.h>
#include <prsht.h>
#else
#include <X11/X.h>
#include <X11/Xlib.h>
#include <GL/glx.h>
#endif

#include <GL/gl.h>
#include "context.h"
#include "glcompat.h"

#include "gfx.h"
#include "z64.h"
#include "rdp.h"

extern unsigned char cfg[32];

extern GLuint screen[1024 * 1024];
extern UINT32 tvfadeoutstate[PRESCALE_HEIGHT];

/*
 * <windows.h> on my MinGW 4.8.1 seems to be failing to define this.
 */
#ifndef MONITOR_DEFAULTTONEAREST
#define MONITOR_DEFAULTTONEAREST    0x00000002
#endif

#define CCVG_RED    (0 ^ (BYTE_ADDR_XOR))
#define CCVG_GRN    (1 ^ (BYTE_ADDR_XOR))
#define CCVG_BLU    (2 ^ (BYTE_ADDR_XOR))
#define CCVG_CVG    (3 ^ (BYTE_ADDR_XOR))
typedef union {
    unsigned char rgba[4];
    signed char sxrgba[4];
} CCVG;

typedef struct {
    int ntscnolerp;
    int copymstrangecrashes;
    int fillmcrashes;
    int fillmbitcrashes;
    int syncfullcrash;
} onetime;

typedef struct {
    UINT8 cvg;
    UINT8 cvbit;
    UINT8 xoff;
    UINT8 yoff;
} CVtcmaskDERIVATIVE;

extern INT32 pitchindwords;

extern int emulation_running;
extern int video_sync;
extern int is_full_screen;

extern GFX_INFO GFX_INFO_NAME;
extern UINT8* rdram_8;
extern UINT16* rdram_16;
extern u32 plim;
extern u32 idxlim16;
extern u32 idxlim32;
extern UINT8 hidden_bits[0x400000];

extern onetime onetimewarnings;

extern GLuint* PreScale;

extern UINT32 gamma_table[0x100];
extern UINT32 gamma_dither_table[0x4000];
extern int vi_restore_table[0x3FF + 1];
extern INT32 oldvstart;
extern int hres_old, vres_old; /* for optional FB size change detection */

extern NOINLINE void DisplayError(char * error);
extern NOINLINE void DisplayWarning(char * warning);
extern NOINLINE void DisplayInStatusPanel(char * message);

#ifdef _DEBUG
extern void trace_VI_registers(void);
#endif

extern NOINLINE void memfill(void * memory, unsigned char byte, size_t length);
extern NOINLINE int file_exists(char* path);
extern NOINLINE int file_in(
    const char* path, void* data, unsigned long length);
extern NOINLINE void file_out(
    const char* path, const void* data, unsigned long length);

extern NOINLINE void reform_image_canvas(int is_PAL, int non_interlaced);
extern NOINLINE void screen_resize(GLsizei width, GLsizei height);
extern NOINLINE void get_screen_size(int* dimensions);

extern STRICTINLINE INT32 irand(void);
extern void rdp_init(void);
extern int rdp_update(void);

#endif
