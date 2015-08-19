#include <malloc.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include "resource.h"
#endif

#include "rdp.h"
#include "vi.h"

static void dump_DRAM(const char* filename);
static size_t set_dump_name(char * name);

static char DRAM_name[32];
static const char digits[16] = {
    '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F',
};

#ifdef _WIN32
void CreateOptionsDialogs(HWND hParent);
BOOL CALLBACK ConfigDlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam);
BOOL CALLBACK DBGProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam);
HWND sWidth, sHeight, hPropSheetHwnd, Parent;
HINSTANCE hinst;
#endif

const char * vendor;
const char * renderer;
const char * version;

unsigned char cfg[32] = {
    0x02, 0x7F, /* custom digital screen width, minus one */
    0x01, 0xDF, /* custom digital screen height, minus one */

/*
 * screen resolution formula methods
 * 0x00:  VI DAC to NTSC/PAL
 * 0x01:  DP frame buffer active video
 * 0x02:  user-defined (cares what the above two words are)
 */
    0x00,

/*
 * reserved for future use as a graphics microcode simulation setting
 * 0xFF:  no microcode simulation (force LLE graphics)
 * 0x00:  automatic (if asked to do HLE, try to auto-detect microcode)
 * 0x01:  RSP SW
 * 0x02:  F3DEX
 * ...
 */
    0x00,

/*
 * reserved for doing extra OpenGL stuff...brightness, extra filtering?
 * not yet implemented
 */
    0x00, 0x00,
    0x00, 0x00,
    0x00, 0x00,
    0x00, 0x00,

    0x00, /* Skip UpdateScreen this many times. */
    0x00, /* Skip drawing triangles this many times. */

/*
 * 64-bit Boolean flags, bits 63..48 (little-endian):
 * currently reserved
 */
    0x00, 0x00,

/*
 * 64-bit Boolean flags, bits 47..32:
 * currently reserved
 */
    0x00, 0x00,

/*
 * 64-bit Boolean flags, bits 31..16:
 * currently reserved
 */
    0x00, 0x00,

/*
 * 64-bit Boolean flags, bits 15..0:
 *  0.  Ignore and bypass all VI_STATUS_REG filter modes?
 *  1.  Force point-sampled (or nearest-neighbor) up-scale?
 *  2.  Pause emulation after every screen update?
 */
    0x00, 0x00,

/*
 * spare bytes for other types of configuration?
 * currently unused
 */
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

#ifdef _WIN32
BOOL WINAPI DllMain(HINSTANCE hinstDLL, /* DLL module handle */
    DWORD fdwReason,                    /* reason called */
    LPVOID lpvReserved)                 /* reserved */
{
    hinst = hinstDLL;
    return TRUE;
}
#endif

EXPORT void CALL DllAbout(p_void hParent)
{
#ifdef _WIN32
    MessageBox(
        hParent,
#else
    puts(
#endif
        "angrylion's pixel-accurate RDP from MESS code\n"\
        "Win32 GUI method of configuration contributed by RPGMaster."
#ifdef _WIN32
,       "Iconoclast's OpenGL",
        MB_ICONINFORMATION
#endif
    );
    return;
}

EXPORT void CALL DllConfig(p_void hParent)
{
#ifdef _DEBUG
    char text_buf[192];

    trace_VI_registers();
    sprintf(
        text_buf,

        "CYCLE_TYPE_1   :  %d\n"\
        "CYCLE_TYPE_2   :  %d\n"\
        "CYCLE_TYPE_COPY:  %d\n"\
        "CYCLE_TYPE_FILL:  %d",

        render_cycle_mode_counts[CYCLE_TYPE_1],
        render_cycle_mode_counts[CYCLE_TYPE_2],
        render_cycle_mode_counts[CYCLE_TYPE_COPY],
        render_cycle_mode_counts[CYCLE_TYPE_FILL]
    );
    DisplayWarning(text_buf);
#endif

    if (emulation_running == 0)
    {
#if 0
        DisplayError("Tried to access config without emulation thread.");
#else
        int pass;

        pass = file_in("RDP_CONF.BIN", cfg, 32);
        if (pass == 0)
            DisplayError("Could not open `RDP_CONF.BIN'.");
#endif
    }
#ifdef _WIN32
    CreateOptionsDialogs(hParent);
#else
    set_dump_name(DRAM_name);
    dump_DRAM(DRAM_name);
    cfg[23] ^= 1 << 0;
    if (cfg[4] != 0x02) /* not forced to user-defined resolution */
        cfg[4]  = (cfg[23] & 1) ? 0x01 : 0x00;
#endif

    if (emulation_running == 0)
        file_out("RDP_CONF.BIN", cfg, 32);
    else
        video_sync = 1;

#ifdef TRACE_DP_COMMANDS
    count_DP_commands();
#endif
    return;
}

#ifdef _WIN32
BOOL CALLBACK ConfigDlgProc(
    HWND hDlg, UINT Message, WPARAM wParam, LPARAM lParam)
{
    HWND item;
    LRESULT response;
    unsigned int value;

    switch (Message)
    {
        case WM_INITDIALOG:
            Parent = GetParent(hDlg); /* this removes redundancy */
            SendDlgItemMessage(
                hDlg, VI_STATUS_REG_FILTER, BM_SETCHECK, cfg[23]>>0 & 1, 0);
            SendDlgItemMessage(
                hDlg, GPU_ACCELERATED_SCALING, BM_SETCHECK, cfg[23]>>1 & 1, 0);
            SendDlgItemMessage(
                hDlg, PAUSE_EVERY_FRAME, BM_SETCHECK, cfg[23]>>2 & 1, 0);
            if (cfg[4] == 0x00)
                SendDlgItemMessage(hDlg, VI_REGISTER_LAYOUT, BM_SETCHECK, 1, 0);
            else if (cfg[4] == 0x01)
                SendDlgItemMessage(hDlg, DP_FRAME_BUFFER, BM_SETCHECK, 1, 0);
            else if (cfg[4] == 0x02)
                SendDlgItemMessage(hDlg, USER_DEFINED, BM_SETCHECK, 1, 0);

/*
 * I store the HWND of the width and height textboxes to prevent having to
 * call GetDlgItem() multiple times.
 */
            EnableWindow(
                sWidth  = GetDlgItem(hDlg, SCREEN_WIDTH),  cfg[4] == 2);
            EnableWindow(
                sHeight = GetDlgItem(hDlg, SCREEN_HEIGHT), cfg[4] == 2);
            SetDlgItemInt(hDlg, UPDATE_SCREEN, cfg[14], 0);
            SetDlgItemInt(hDlg, PROCESSDLIST,  cfg[15], 0);
            value = ((cfg[0] << 8) | cfg[1]) + 1;
            if (value > 1024)
                value = 1024;
            SetDlgItemInt(hDlg, SCREEN_WIDTH,  value, 0);
            value = ((cfg[2] << 8) | cfg[3]) + 1;
            if (value > 1024)
                value = 1024;
            SetDlgItemInt(hDlg, SCREEN_HEIGHT, value, 0);

            item = GetDlgItem(hDlg, MICROCODE);
            SendMessage(item, CB_ADDSTRING, 0, (LPARAM)" 0:  Automatic");
            SendMessage(item, CB_ADDSTRING, 0, (LPARAM)" 1:  RSP SW");
            SendMessage(item, CB_ADDSTRING, 0, (LPARAM)" 2:  F3DEX");

/*
 * sets selection to automatic
 */
            SendMessage(item, CB_SETCURSEL, 0, 0);
            break;
        case WM_NOTIFY:
            switch (((LPNMHDR)lParam)->code)
            {
                case PSN_APPLY:
                    SendMessage(hDlg, WM_COMMAND, IDOK, lParam);
                    break;
                case PSN_SETACTIVE: /* This enables the Apply button. */
                    PropSheet_Changed(Parent, hDlg);
                    break;
            }
            break;
        case WM_COMMAND:
            switch (LOWORD(wParam))
            {
                case IDOK:
                    value = GetDlgItemInt(hDlg, SCREEN_WIDTH, 0, 0) - 1;
                    if (value > 1024 - 1)
                        value = 1024 - 1;
                    cfg[0] = (value >> 8) & 0xFF;
                    cfg[1] = (value >> 0) & 0xFF;
                    value = GetDlgItemInt(hDlg, SCREEN_HEIGHT, 0, 0) - 1;
                    if (value > 1024 - 1)
                        value = 1024 - 1;
                    cfg[2] = (value >> 8) & 0xFF;
                    cfg[3] = (value >> 0) & 0xFF;

                    cfg[23] &= ~(0x01 << 0);
                    cfg[23] &= ~(0x01 << 1);
                    cfg[23] &= ~(0x01 << 2);
                    response = SendDlgItemMessage(
                        hDlg, VI_STATUS_REG_FILTER, BM_GETCHECK, 0, 0);
                    cfg[23] |= (response == TRUE) << 0;
                    response = SendDlgItemMessage(
                        hDlg, GPU_ACCELERATED_SCALING, BM_GETCHECK, 0, 0);
                    cfg[23] |= (response == TRUE) << 1;
                    response = SendDlgItemMessage(
                        hDlg, PAUSE_EVERY_FRAME, BM_GETCHECK, 0, 0);
                    cfg[23] |= (response == TRUE) << 2;

                    response = SendDlgItemMessage(
                        hDlg, VI_REGISTER_LAYOUT, BM_GETCHECK, 0, 0);
                    if (response == TRUE)
                        cfg[4] = 0;
                    else
                    {
                        response = SendDlgItemMessage(
                            hDlg, DP_FRAME_BUFFER, BM_GETCHECK, 0, 0);
                        if (response == TRUE)
                            cfg[4] = 0x01;
                        else
                        {
                            response = SendDlgItemMessage(
                                hDlg, USER_DEFINED, BM_GETCHECK, 0, 0);
                            if (response == TRUE)
                                cfg[4] = 0x02;
                        }
                    }
                    value = GetDlgItemInt(hDlg, UPDATE_SCREEN, 0, 0) & 0xFF;
                    cfg[14] = (value > 0xFF) ? 0xFF : value & 0xFF;
                    value = GetDlgItemInt(hDlg, PROCESSDLIST , 0, 0) & 0xFF;
                    cfg[15] = (value > 0xFF) ? 0xFF : value & 0xFF;
                    break;
                case VI_REGISTER_LAYOUT:
                case DP_FRAME_BUFFER:
                    EnableWindow(sWidth,  FALSE); /* disables width textbox */
                    EnableWindow(sHeight, FALSE); /* disables height textbox */
                    break;

                case USER_DEFINED:
                    EnableWindow(sWidth,  TRUE); /* enables width textbox */
                    EnableWindow(sHeight, TRUE); /* enables height textbox */
                    break;
            }
            break;
        default:
        return FALSE;
    }
    return TRUE;
}

BOOL CALLBACK DBGProc(HWND hDlg, UINT Message, WPARAM wParam, LPARAM lParam)
{
    switch (Message)
    {
        case WM_INITDIALOG:
            SetDlgItemText(hDlg, GL_Vendor, vendor);
            SetDlgItemText(hDlg, GL_Renderer, renderer);
            SetDlgItemText(hDlg, GL_Version, version);

            CheckDlgButton(
                hDlg, SUPPORT_GDI_BITMAP, support_GDI_bitmap);
            CheckDlgButton(
                hDlg, SUPPORT_BUFFER_OBJECTS, support_buffer_objects);
            CheckDlgButton(
                hDlg, SUPPORT_PIXEL_DMAs, support_pixel_DMAs);
            CheckDlgButton(
                hDlg, SUPPORT_VERTEX_PROGRAM, support_vertex_program);
            break;
        case WM_COMMAND:
            switch (LOWORD(wParam))
            {
                case DLLTEST:
                    DllTest(hDlg);
                    break;
                case RDRAM_DUMP:
                    set_dump_name(DRAM_name);
                    dump_DRAM(DRAM_name);
                    break;
            }
            break;
        default:
            return FALSE;
    }
    return TRUE;
}

#define NUMBER_OF_TABS      2
void CreateOptionsDialogs(HWND hParent)
{
    PROPSHEETPAGE psp[NUMBER_OF_TABS];
    PROPSHEETHEADER psh;

    memfill(&psp, 0x00, 2 * sizeof(PROPSHEETPAGE));
    memfill(&psh, 0x00, sizeof(PROPSHEETHEADER));

    psp[0].dwSize = sizeof(PROPSHEETPAGE);
    psp[0].dwFlags = PSP_USETITLE;
    psp[0].hInstance = hinst;
    psp[0].pszTemplate = MAKEINTRESOURCE(IDD_DIALOG1);
    psp[0].pszIcon = NULL;
    psp[0].pfnDlgProc = (DLGPROC)ConfigDlgProc;
    psp[0].pszTitle = "Processing";
    psp[0].lParam = 0;

    psp[1].dwSize = sizeof(PROPSHEETPAGE);
    psp[1].dwFlags = PSP_USETITLE;
    psp[1].hInstance = hinst;
    psp[1].pszTemplate = MAKEINTRESOURCE(IDD_DIALOG2);
    psp[1].pszIcon = NULL;
    psp[1].pfnDlgProc = (DLGPROC)DBGProc;
    psp[1].pszTitle = "Context State";
    psp[1].lParam = 0;

    psh.dwSize = sizeof(PROPSHEETHEADER);
    psh.dwFlags = PSH_PROPSHEETPAGE;
    psh.hwndParent = hParent;
    psh.hInstance = hinst;
    psh.pszCaption = (LPSTR) "DllConfig";
    psh.nPages = sizeof(psp) / sizeof(PROPSHEETPAGE);
    psh.ppsp = (LPCPROPSHEETPAGE)& psp;

    psh.nStartPage = 0;
    hPropSheetHwnd = (HWND)PropertySheet(&psh);	/* Start the Property Sheet */
    return;
}
#endif

#ifdef _WIN32
static char results[] = {
    "nSize\n\t0000\n"\
    "nVersion\n\t0000\n"\
    "dwFlags\n\t00000000\n"\
    "iPixelType\n\t00\n"\
    "cColorBits\n\t00\n"\
    "cRedBits\n\t00\n"\
    "cRedShift\n\t00\n"\
    "cGreenBits\n\t00\n"\
    "cGreenShift\n\t00\n"\
    "cBlueBits\n\t00\n"\
    "cBlueShift\n\t00\n"\
    "cAlphaBits\n\t00\n"\
    "cAlphaShift\n\t00\n"\
    "cAccumBits\n\t00\n"\
    "cAccumRedBits\n\t00\n"\
    "cAccumGreenBits\n\t00\n"\
    "cAccumBlueBits\n\t00\n"\
    "cAccumAlphaBits\n\t00\n"\
    "cDepthBits\n\t00\n"\
    "cStencilBits\n\t00\n"\
    "cAuxBuffers\n\t00\n"\
    "iLayerType\n\t00\n"\
    "bReserved\n\t00\n"\
    "dwLayerMask\n\t00000000\n"\
    "dwVisibleMask\n\t00000000\n"\
    "dwDamageMask\n\t00000000\n"\
};
#endif

EXPORT void CALL DllTest(p_void hParent)
{
#ifdef _WIN32
    PIXELFORMATDESCRIPTOR test;
    int pixel_format_enum;
    int formats;

    if (device_context == NULL)
    {
        DisplayError(
            "No current device context.\n"\
            "Try initializing the plugin before testing it."
        );
        return;
    }

    MessageBox(hParent, "Begin testing.", "DllTest", MB_ICONINFORMATION);
    pixel_format_enum = GetPixelFormat(device_context);
    formats = ChoosePixelFormat(device_context, &pixel_format);
    if (pixel_format_enum != formats)
        DisplayWarning("Mismatch between run-time and test pixel formats.");
    if (pixel_format_enum == 0)
    {
        DisplayError("No suitable pixel format detected on this system.");
        return;
    }

    formats = DescribePixelFormat(
        device_context,
        pixel_format_enum,
        sizeof(PIXELFORMATDESCRIPTOR),
        &test);
    if (formats == 0)
    {
        DisplayError("No suitable pixel format detected on this system.");
        return;
    }

    results[  7] = digits[(test.nSize & 0xF000) >> 12];
    results[  8] = digits[(test.nSize & 0x0F00) >>  8];
    results[  9] = digits[(test.nSize & 0x00F0) >>  4];
    results[ 10] = digits[(test.nSize & 0x000F) >>  0];

    results[ 22] = digits[(test.nVersion & 0xF000) >> 12];
    results[ 23] = digits[(test.nVersion & 0x0F00) >>  8];
    results[ 24] = digits[(test.nVersion & 0x00F0) >>  4];
    results[ 25] = digits[(test.nVersion & 0x000F) >>  0];

    results[ 36] = digits[(test.dwFlags & 0xF0000000) >> 28];
    results[ 37] = digits[(test.dwFlags & 0x0F000000) >> 24];
    results[ 38] = digits[(test.dwFlags & 0x00F00000) >> 20];
    results[ 39] = digits[(test.dwFlags & 0x000F0000) >> 16];
    results[ 40] = digits[(test.dwFlags & 0x0000F000) >> 12];
    results[ 41] = digits[(test.dwFlags & 0x00000F00) >>  8];
    results[ 42] = digits[(test.dwFlags & 0x000000F0) >>  4];
    results[ 43] = digits[(test.dwFlags & 0x0000000F) >>  0];

    results[ 57] = digits[(test.iPixelType & 0xF0) >> 4];
    results[ 58] = digits[(test.iPixelType & 0x0F) >> 0];
    results[ 72] = digits[(test.cColorBits & 0xF0) >> 4];
    results[ 73] = digits[(test.cColorBits & 0x0F) >> 0];
    results[ 85] = digits[(test.cRedBits & 0xF0) >> 4];
    results[ 86] = digits[(test.cRedBits & 0x0F) >> 0];
    results[ 99] = digits[(test.cRedShift & 0xF0) >> 4];
    results[100] = digits[(test.cRedShift & 0x0F) >> 0];
    results[114] = digits[(test.cGreenBits & 0xF0) >> 4];
    results[115] = digits[(test.cGreenBits & 0x0F) >> 0];
    results[130] = digits[(test.cGreenShift & 0xF0) >> 4];
    results[131] = digits[(test.cGreenShift & 0x0F) >> 0];
    results[144] = digits[(test.cBlueBits & 0xF0) >> 4];
    results[145] = digits[(test.cBlueBits & 0x0F) >> 0];
    results[159] = digits[(test.cBlueShift & 0xF0) >> 4];
    results[160] = digits[(test.cBlueShift & 0x0F) >> 0];
    results[174] = digits[(test.cAlphaBits & 0xF0) >> 4];
    results[175] = digits[(test.cAlphaBits & 0x0F) >> 0];
    results[190] = digits[(test.cAlphaShift & 0xF0) >> 4];
    results[191] = digits[(test.cAlphaShift & 0x0F) >> 0];
    results[205] = digits[(test.cAccumBits & 0xF0) >> 4];
    results[206] = digits[(test.cAccumBits & 0x0F) >> 0];
    results[223] = digits[(test.cAccumRedBits & 0xF0) >> 4];
    results[224] = digits[(test.cAccumRedBits & 0x0F) >> 0];
    results[243] = digits[(test.cAccumGreenBits & 0xF0) >> 4];
    results[244] = digits[(test.cAccumGreenBits & 0x0F) >> 0];
    results[262] = digits[(test.cAccumBlueBits & 0xF0) >> 4];
    results[263] = digits[(test.cAccumBlueBits & 0x0F) >> 0];
    results[282] = digits[(test.cAccumAlphaBits & 0xF0) >> 4];
    results[283] = digits[(test.cAccumAlphaBits & 0x0F) >> 0];
    results[297] = digits[(test.cDepthBits & 0xF0) >> 4];
    results[298] = digits[(test.cDepthBits & 0x0F) >> 0];
    results[314] = digits[(test.cStencilBits & 0xF0) >> 4];
    results[315] = digits[(test.cStencilBits & 0x0F) >> 0];
    results[330] = digits[(test.cAuxBuffers & 0xF0) >> 4];
    results[331] = digits[(test.cAuxBuffers & 0x0F) >> 0];
    results[345] = digits[(test.iLayerType & 0xF0) >> 4];
    results[346] = digits[(test.iLayerType & 0x0F) >> 0];
    results[359] = digits[(test.bReserved & 0xF0) >> 4];
    results[360] = digits[(test.bReserved & 0x0F) >> 0];

    results[375] = digits[(test.dwLayerMask & 0xF0000000) >> 28];
    results[376] = digits[(test.dwLayerMask & 0x0F000000) >> 24];
    results[377] = digits[(test.dwLayerMask & 0x00F00000) >> 20];
    results[378] = digits[(test.dwLayerMask & 0x000F0000) >> 16];
    results[379] = digits[(test.dwLayerMask & 0x0000F000) >> 12];
    results[380] = digits[(test.dwLayerMask & 0x00000F00) >>  8];
    results[381] = digits[(test.dwLayerMask & 0x000000F0) >>  4];
    results[382] = digits[(test.dwLayerMask & 0x0000000F) >>  0];

    results[399] = digits[(test.dwVisibleMask & 0xF0000000) >> 28];
    results[400] = digits[(test.dwVisibleMask & 0x0F000000) >> 24];
    results[401] = digits[(test.dwVisibleMask & 0x00F00000) >> 20];
    results[402] = digits[(test.dwVisibleMask & 0x000F0000) >> 16];
    results[403] = digits[(test.dwVisibleMask & 0x0000F000) >> 12];
    results[404] = digits[(test.dwVisibleMask & 0x00000F00) >>  8];
    results[405] = digits[(test.dwVisibleMask & 0x000000F0) >>  4];
    results[406] = digits[(test.dwVisibleMask & 0x0000000F) >>  0];

    results[422] = digits[(test.dwDamageMask & 0xF0000000) >> 28];
    results[423] = digits[(test.dwDamageMask & 0x0F000000) >> 24];
    results[424] = digits[(test.dwDamageMask & 0x00F00000) >> 20];
    results[425] = digits[(test.dwDamageMask & 0x000F0000) >> 16];
    results[426] = digits[(test.dwDamageMask & 0x0000F000) >> 12];
    results[427] = digits[(test.dwDamageMask & 0x00000F00) >>  8];
    results[428] = digits[(test.dwDamageMask & 0x000000F0) >>  4];
    results[429] = digits[(test.dwDamageMask & 0x0000000F) >>  0];

    file_out("gl_pfd.txt", results, sizeof(results));
    MessageBox(
        hParent,
        "Finished PFD tests.\nCheck `gl_pfd.txt'.",
        "DllTest",
        MB_ICONINFORMATION
    );
#endif
    return;
}

void dump_DRAM(const char* filename)
{
#ifdef _WIN32
    DWORD written, i;
    HANDLE file;
#else
    u32 written, i;
    FILE * file;
#endif
    unsigned char * swapped;
    const int little_endian = GET_GFX_INFO(MemoryBswaped);

    if (plim > 0x00FFFFFF)
    {
        DisplayError("RAM capacity exceeds RCP hardware limit.");
        return;
    }

    if (little_endian == 0)
    {
        file_out(filename, DRAM, plim + 1);
        return;
    }

#ifdef _WIN32
    file = CreateFile(
        filename,
        GENERIC_WRITE,
        FILE_SHARE_READ,
        NULL,
        CREATE_ALWAYS,
        FILE_FLAG_WRITE_THROUGH,
        NULL
    );
    if (file == INVALID_HANDLE_VALUE)
        goto write_failure;
    swapped = GlobalAlloc(GMEM_FIXED, plim + 1);
#else
    file = fopen(filename, "wb");
    if (file == NULL)
        goto write_failure;
    swapped = malloc(plim + 1);
#endif

    for (i = 0x000000; i <= plim; i += 0x000008)
    {
        swapped[i + 0] = DRAM[i + (0 ^ ENDIAN_SWAP_BYTE)];
        swapped[i + 1] = DRAM[i + (1 ^ ENDIAN_SWAP_BYTE)];
        swapped[i + 2] = DRAM[i + (2 ^ ENDIAN_SWAP_BYTE)];
        swapped[i + 3] = DRAM[i + (3 ^ ENDIAN_SWAP_BYTE)];
        swapped[i + 4] = DRAM[i + (4 ^ ENDIAN_SWAP_BYTE)];
        swapped[i + 5] = DRAM[i + (5 ^ ENDIAN_SWAP_BYTE)];
        swapped[i + 6] = DRAM[i + (6 ^ ENDIAN_SWAP_BYTE)];
        swapped[i + 7] = DRAM[i + (7 ^ ENDIAN_SWAP_BYTE)];
    }
#ifdef _WIN32
    WriteFile(file, &swapped[0], i, &written, NULL);
    GlobalFree(swapped);
    CloseHandle(file);
#else
    written = fwrite(swapped, 1, i, file);
    free(swapped);
    fclose(file);
#endif
    if (written != i)
        goto write_failure;
    return;
write_failure:
    DisplayError("Failed to write file.");
    return;
}

static size_t set_dump_name(char * name)
{
    register size_t i, j;
    const u32 reg_dram_addr = GET_RCP_REG(VI_ORIGIN_REG);
    const u32 reg_control   = GET_RCP_REG(VI_STATUS_REG);

    name[i = 0] = '\0'; /* From here, we could just call strcat() instead. */

    name[i++] = 'R';
    name[i++] = 'C';
    name[i++] = 'P';
    name[i++] = '_';
    for (j = 0; j < 8; j++)
    {
        u32 bitmask;
        const unsigned int shift_amount = 28 - 4*j;

        bitmask = reg_dram_addr & (0x0000000Ful << shift_amount);
        name[i++] = digits[(bitmask >> shift_amount) & 0xF];
    }
    name[i++] = '_';
    for (j = 0; j < 8; j++)
    {
        u32 bitmask;
        const unsigned int shift_amount = 28 - 4*j;

        bitmask = reg_control & (0x0000000Ful << shift_amount);
        name[i++] = digits[(bitmask >> shift_amount) & 0xF];
    }
    name[i++] = '.';
    name[i++] = 'b';
    name[i++] = 'i';
    name[i++] = 'n';
    name[i]   = '\0';

#ifdef _DEBUG
    i = strlen(name);
#endif
    return (i);
}
