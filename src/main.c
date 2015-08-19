#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <X11/X.h>
#include <X11/Xatom.h>
#endif

#include "context.h"
#include "z64.h"
#include "gfx.h"
#include "vi.h"
#include "rdp.h"
#include "bitmap.h"

INT32 pitchindwords;
int emulation_running = 0;

FILE* zeldainfo = 0;
extern int SaveLoaded;
extern UINT32 command_counter;

GFX_INFO GFX_INFO_NAME;

/*
 * based on the Win32 full-screen implementation written by zilmar in his
 * basic CFB plugin
 */
int is_full_screen = 0;

static char filepath[_MAX_PATH];
static signed short count_ = -1;

EXPORT void CALL CaptureScreen(char * Directory)
{
    register int i;
    const int analog_pass = (cfg[4] == 0) | (cfg[4] == 2);

    for (i = 0; i < _MAX_PATH; i++)
        if (Directory[i] == '\0')
            break;
        else
            filepath[i] = *(Directory + i);
    if (filepath[i - 1] != '/' && filepath[i - 1] != '\\')
    {
        filepath[i] = '/';
        ++i;
    }
    if (i + 12 >= _MAX_PATH)
    {
        DisplayError("Screenshots directory too long.");
        return;
    }
    filepath[i +  0] = safe_name(GFX_INFO_NAME.HEADER[0x3B ^ ENDIAN_SWAP_BYTE]);
    filepath[i +  1] = safe_name(GFX_INFO_NAME.HEADER[0x3C ^ ENDIAN_SWAP_BYTE]);
    filepath[i +  2] = safe_name(GFX_INFO_NAME.HEADER[0x3D ^ ENDIAN_SWAP_BYTE]);
    filepath[i +  3] = safe_name(GFX_INFO_NAME.HEADER[0x3E ^ ENDIAN_SWAP_BYTE]);

    filepath[i +  8] = '.';
    if (analog_pass)
    {
        filepath[i +  9] = 'd';
        filepath[i + 10] = 'i';
        filepath[i + 11] = 'b';
    }
    else
    {
        filepath[i +  9] = 'b';
        filepath[i + 10] = 'm';
        filepath[i + 11] = 'p';
    }
    filepath[i + 12] = '\0';
    do {
        if (count_ == 9999)
            DisplayError("Screenshots directory is about to overflow.");
        count_ = (count_ + 0x0001) % 10000;
        filepath[i +  4] = '0' + (count_/1000 % 10);
        filepath[i +  5] = '0' + (count_/ 100 % 10);
        filepath[i +  6] = '0' + (count_/  10 % 10);
        filepath[i +  7] = '0' + (count_/   1 % 10);
    } while (file_exists(filepath));
    if (analog_pass)
        capture_screen_to_file(filepath);
    else
        capture_FB_to_file[GET_RCP_REG(VI_STATUS_REG) & 0x00000001](filepath);
    return;
}

EXPORT void CALL ChangeWindow(void)
{
    int dimensions[2];
#ifdef _WIN32
    static WINDOWPLACEMENT wndpl;
    static HMENU old_menu;
    static LONG old_style;
    const HWND hWnd = GET_GFX_INFO(hWnd);
    const HWND hStatusBar = GET_GFX_INFO(hStatusBar);
#elif !defined(STUCK_WITH_SDL)
    Atom atoms[2];

    atoms[0] = XInternAtom(GLX_display, "_NET_WM_STATE_FULLSCREEN", False);
    atoms[1] = None;
#endif
    dimensions[1] = dimensions[0] = 0;

    if (is_full_screen == 0)
    {
        is_full_screen = 1;
        get_screen_size(dimensions);

#ifdef _WIN32
        wndpl.length = sizeof(wndpl);
        GetWindowPlacement(hWnd, &wndpl);

        if (hStatusBar)
            ShowWindow(hStatusBar, SW_HIDE);
        old_menu = GetMenu(hWnd);
        if (old_menu)
            SetMenu(hWnd, NULL);
        old_style = GetWindowLong(hWnd, GWL_STYLE);
        SetWindowLong(hWnd, GWL_STYLE, WS_VISIBLE);
        SetWindowPos(
            hWnd, HWND_TOPMOST, 0, 0, dimensions[0], dimensions[1],
            SWP_SHOWWINDOW
        );
        ShowCursor(FALSE);
#elif !defined(STUCK_WITH_SDL)
        XChangeProperty(
            GLX_display,
            GLX_window,
            XInternAtom(GLX_display, "_NET_WM_STATE", False),
            XA_ATOM,
            32,
            PropModeReplace,
            (unsigned char *)atoms,
            1
        );
#endif
    }
    else
    {
        is_full_screen = 0;
        switch (cfg[4])
        {
            case 0x00:
                dimensions[0] = 640;
                dimensions[1] = 480;
                break;
            case 0x01:
                dimensions[0] = hres_old;
                dimensions[1] = vres_old;
                break;
            case 0x02:
                dimensions[0] = (cfg[0] << 8) + cfg[1] + 1;
                dimensions[1] = (cfg[2] << 8) + cfg[3] + 1;
                break;
            default:
                DisplayError("Invalid resolution control setting.");
                break;
        }
#ifdef _WIN32
        if (hStatusBar)
            ShowWindow(hStatusBar, SW_SHOW);
        if (old_menu)
        { 
            SetMenu(hWnd, old_menu);
            old_menu = NULL;
        }
        SetWindowLong(hWnd, GWL_STYLE, old_style);
        SetWindowPos(
            hWnd, HWND_NOTOPMOST, wndpl.rcNormalPosition.left,
            wndpl.rcNormalPosition.top, dimensions[0], dimensions[1],
            SWP_NOSIZE | SWP_SHOWWINDOW);
        ShowCursor(TRUE);
#elif !defined(STUCK_WITH_SDL)
        XChangeProperty(
            GLX_display,
            GLX_window,
            XInternAtom(GLX_display, "_NET_WM_STATE", False),
            XA_ATOM,
            32,
            PropModeReplace,
            (unsigned char *)atoms,
            1
        );
#endif
    }
    video_sync = 1;
    return;
}

EXPORT void CALL CloseDLL(void)
{
#ifdef _WIN32
    BOOL pass;
    HDC current_DC;
    HGLRC current_RC;
    const HWND hWnd = GET_GFX_INFO(hWnd);

    device_context = wglGetCurrentDC();
    render_context = wglGetCurrentContext();
    if (device_context == NULL && render_context == NULL)
        return;

    pass = wglMakeCurrent(device_context, NULL);
    if (pass == FALSE)
        DisplayError("Failed to free OpenGL render context.");
    pass = wglDeleteContext(render_context);

    current_RC = wglGetCurrentContext();
    render_context = current_RC;
    if (pass == FALSE)
        DisplayError("Failed to delete OpenGL render context.");

    pass = wglMakeCurrent(NULL, NULL);
    if (pass == FALSE && render_context != NULL)
        DisplayError("Failed to free device context.");
    ReleaseDC(hWnd, device_context);

    current_DC = wglGetCurrentDC();
    device_context = current_DC;
    if (current_DC != NULL)
        DisplayError("Failed to delete device context.");
#else

#if defined(STUCK_WITH_SDL)
    SDL_Quit();
#else
    Bool pass;

    do {
        pass = glXMakeCurrent(GLX_display, None, NULL);
    } while (pass == False);
    glXDestroyContext(GLX_display, GLX_context);
    XDestroyWindow(GLX_display, GLX_window);
    XCloseDisplay(GLX_display);
#endif

#endif
    return;
}

EXPORT void CALL DrawScreen(void)
{ /* only seems to be called on Project64 1.7+ Soft Reset/saved states? */
    return;
}

static const char DLL_name[] = "angrylion's RDP with OpenGL 1.5";
EXPORT void CALL GetDllInfo(PLUGIN_INFO* PluginInfo)
{
    register size_t i;

    PluginInfo -> Version = SPECS_VERSION;
    PluginInfo -> Type = PLUGIN_TYPE_GFX;
    PluginInfo -> NormalMemory = 1;
    PluginInfo -> MemoryBswaped = 1;
    for (i = 0; i < sizeof(DLL_name); i++)
        PluginInfo -> Name[i] = DLL_name[i];
    return;
}

EXPORT int CALL InitiateGFX(GFX_INFO Gfx_Info)
{
#ifdef _WIN32
    int DC_released;

    device_context = GetDC(Gfx_Info.hWnd);
    if (device_context == NULL)
    {
        DisplayError("Failed to get device context from render window.");
        return 0;
    }

    DC_released = ReleaseDC(Gfx_Info.hWnd, device_context);
    if (DC_released == 0)
    {
        DisplayError("Unable to release initialized device context.");
        return 0;
    }
    device_context = NULL;
#endif

    emulation_running = 0;
 /* RomOpen means emulation started, not InitiateGFX. */

    GFX_INFO_NAME = Gfx_Info;
#if defined(_DEBUG)
    return init_GL_context(Gfx_Info.hWnd);
#else
    return 1;
#endif
}

EXPORT void CALL MoveScreen(int xpos, int ypos)
{
    static int xpos_old, ypos_old;

    if (xpos_old == xpos && ypos_old == ypos)
        return;
    xpos_old = xpos;
    ypos_old = ypos;

    video_sync = 1;
    return;
}

EXPORT void CALL ProcessDList(void)
{
    DisplayError("Unidentified microcode."); /* HLE not yet added :P */
    return;
}

EXPORT void CALL ProcessRDPList(void)
{
    process_RDP_list();
    return;
}

EXPORT void CALL RomClosed(void)
{
    emulation_running = 0;
    SaveLoaded = 1;
    command_counter = 0;

    file_out("RDP_CONF.BIN", cfg, 32);
    CloseDLL();
    return;
}

EXPORT void CALL RomOpen(void)
{
    int pass;
#if defined(X_H)
    XWindowAttributes GLX_window_attributes;
#elif defined(_WIN32)
    RECT status_bar = { 0 };
#endif

    rdp_init();
    emulation_running = 1;
    video_sync = 1;
    pitchindwords = PRESCALE_WIDTH / 1;

    pass = file_in("RDP_CONF.BIN", cfg, 32);
    if (pass == 0)
        DisplayError("Could not open `RDP_CONF.BIN'.");

    screen_resize(PRESCALE_WIDTH, 480);
#ifdef _WIN32
    if (GFX_INFO_NAME.hStatusBar != NULL)
        GetClientRect(GFX_INFO_NAME.hStatusBar, &status_bar);
#elif !defined(STUCK_WITH_SDL)
    XGetWindowAttributes(GLX_display, GLX_window, &GLX_window_attributes);
#endif

#ifdef _DEBUG
    maintain_context(GFX_INFO_NAME.hWnd);
#else
    init_GL_context(GFX_INFO_NAME.hWnd);
#endif

#if defined(_WIN32) | defined(WIN32)
    glViewport(status_bar.left, status_bar.bottom, PRESCALE_WIDTH, 480);
#else
    glViewport(0, 0, 640, 480); /* to-do:  get offset from GLX window att? */
    fputc('\n', stdout); /* Some emulators lack trailing newlines. */
#endif
    return;
}

EXPORT void CALL ShowCFB(void)
{
    UpdateScreen();
    return;
}

static unsigned char called_count;
EXPORT void CALL UpdateScreen(void)
{
    int no_blit;

    if (called_count < cfg[14])
    {
        ++called_count;
        return;
    }
    called_count = 0x00;

    if (emulation_running == 0)
        return; /* doesn't matter whether context fell if it's time to die :) */
    maintain_context(GFX_INFO_NAME.hWnd);

    if (emulation_running == 0) /* multi-threading issues on end emulation */
        return;

    no_blit = rdp_update();
    if (thread_stage == STAGE_CAPTURE_PENDING)
    {
        thread_stage = STAGE_REFRESH_THREAD_CAPTURE;
        capture_screen_to_file(filepath);
    }

    if (no_blit)
        return;
    swap_buffers();
#ifdef _WIN32
    if (cfg[23] & 0x04)
        MessageBox(NULL, "Updated screen.\nPaused.", "Frame Step", MB_OK);
#endif
    return;
}

static const char digits[16] = {
    '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
};
EXPORT void CALL ViStatusChanged(void)
{
    char message[] = "New VI_CONTROL_REG:  0x00000000";
    const unsigned long status = GET_RCP_REG(VI_STATUS_REG) & 0xFFFFFFFFul;

    message[23] = digits[(status >> 28) & 0xF];
    message[24] = digits[(status >> 24) & 0xF];
    message[25] = digits[(status >> 20) & 0xF];
    message[26] = digits[(status >> 16) & 0xF];
    message[27] = digits[(status >> 12) & 0xF];
    message[28] = digits[(status >>  8) & 0xF];
    message[29] = digits[(status >>  4) & 0xF];
    message[30] = digits[(status >>  0) & 0xF];

    DisplayInStatusPanel(message);
    video_sync = 1;
    return;
}

EXPORT void CALL ViWidthChanged(void)
{
    GLenum cleared;
    char message[] = "New VI_H_WIDTH_REG:  0x00000000";
    const unsigned long width = GET_RCP_REG(VI_WIDTH_REG) & 0xFFFFFFFFul;

    message[23] = digits[(width >> 28) & 0xF];
    message[24] = digits[(width >> 24) & 0xF];
    message[25] = digits[(width >> 20) & 0xF];
    message[26] = digits[(width >> 16) & 0xF];
    message[27] = digits[(width >> 12) & 0xF];
    message[28] = digits[(width >>  8) & 0xF];
    message[29] = digits[(width >>  4) & 0xF];
    message[30] = digits[(width >>  0) & 0xF];
    DisplayInStatusPanel(message);

    if (emulation_running == 0)
        return;
    maintain_context(GFX_INFO_NAME.hWnd);
    glClear(GL_COLOR_BUFFER_BIT);
    cleared = glGetError();
    if (cleared != GL_NO_ERROR)
        DisplayGLError("Failed to clear screen.", cleared);

    video_sync = 1; /* Synchronize viewport width/height at next VI update. */
    return;
}

/*
 * Mupen64Plus seems to assume that this function is a (required) part of the
 * common plugin specifications.  It's actually one of the schibo-Rice
 * extension functions that Hacktarux implemented to Mupen64, but if this
 * plugin won't export the function then emulation will crash in Mupen64Plus.
 */
EXPORT void CALL ReadScreen(void** dest, long* width, long* height)
{
    return;
}

#ifdef SCHIBO_RICE_EXTENSIONS
EXPORT void CALL FBWrite(DWORD addr, DWORD size)
{
}

EXPORT void CALL FBWList(FrameBufferModifyEntry* plist, DWORD size)
{
}

EXPORT void CALL FBRead(DWORD addr)
{
}

EXPORT void CALL FBGetFrameBufferInfo(void* pinfo)
{
}
#endif
