#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <X11/X.h>
#endif
#include "context.h"

/*
 * a last-minute include needed to integrate context dependencies on the way
 * the N64 video interface operates, plus system messages from VI module
 */
#include "vi.h"

#ifdef _WIN32
HGLRC render_context;
HDC device_context;
#else
Display* GLX_display;
Window GLX_window;
GLXContext GLX_context;
#endif

#ifdef STUCK_WITH_SDL
SDL_Surface * video_surface;
const SDL_VideoInfo * video_info;
unsigned int SDL_desktop[3];
#endif

#ifdef _WIN32
const PIXELFORMATDESCRIPTOR pixel_format = {
    sizeof(PIXELFORMATDESCRIPTOR), /* nSize */
    0x0001, /* nVersion */
    PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DEPTH_DONTCARE, /* dwFlags */
    PFD_TYPE_RGBA, /* iPixelType */
    24, /* cColorBits */

    8, 0, /* N64 FB format is usually RGB5, but can be RGBX8. */
    8, 0,
    8, 0,
    0, 0, /* Alpha coverage and blending is all RDP hardware stuff. */

    0,
    0, 0, 0, 0,

    0, /* cDepthBits */
    0, /* cStencilBits */
    0, /* cAuxBuffers */
    PFD_MAIN_PLANE, /* iLayerType */

    0x00, /* bReserved */
    0x00000000, /* dwLayerMask */
    0x00000000, /* dwVisibleMask */
    0x00000000, /* dwDamageMask */
};
#else
static GLint GLX_attributes[] = {
    GLX_USE_GL,
    GLX_BUFFER_SIZE, 8 + 8 + 8, /* ignored for non-color-indexed palettes */
#if 0
    GLX_DOUBLEBUFFER, /* Double-buffering causes some window event issues. */
#endif
    GLX_LEVEL, 0,
    GLX_RGBA,
    GLX_AUX_BUFFERS, 0,
    GLX_RED_SIZE, 8,
    GLX_GREEN_SIZE, 8,
    GLX_BLUE_SIZE, 8,
    GLX_ALPHA_SIZE, 0,
    GLX_DEPTH_SIZE, 0,
    GLX_STENCIL_SIZE, 0,
    GLX_ACCUM_RED_SIZE, 0,
    GLX_ACCUM_GREEN_SIZE, 0,
    GLX_ACCUM_BLUE_SIZE, 0,
    GLX_ACCUM_ALPHA_SIZE, 0,
    None
};
#endif

static GLfloat my_glColor[4 * 4] = {
    1.f, 1.f, 1.f, 1.f,
};

static const GLfloat colors[8][4] = {
    { CHAN_ON , CHAN_ON , CHAN_ON , 1.f, },
    { CHAN_ON , CHAN_ON , CHAN_OFF, 1.f, },
    { CHAN_OFF, CHAN_ON , CHAN_ON , 1.f, },
    { CHAN_OFF, CHAN_ON , CHAN_OFF, 1.f, }, /* highest luminance:  green */
    { CHAN_ON , CHAN_OFF, CHAN_ON , 1.f, }, /* lower luminance w/o green */
    { CHAN_ON , CHAN_OFF, CHAN_OFF, 1.f, },
    { CHAN_OFF, CHAN_OFF, CHAN_ON , 1.f, },
    { CHAN_OFF, CHAN_OFF, CHAN_OFF, 1.f, },
};

GLuint name_buf[NUM_BUFFERS];
GLuint name_tex;
GLuint frame_buffer_draw_list;

GLboolean double_buffering;
GLboolean support_GDI_bitmap;
GLboolean support_buffer_objects;
GLboolean support_pixel_DMAs;
GLboolean support_vertex_program;

#if defined(GL_VERSION_1_0) | defined(GL_VERSION_1_1)
PFNGLGETSTRINGIPROC xglGetStringi;
PFNGLVERTEXATTRIBPOINTERPROC xglVertexAttribPointer;

PFNGLENABLEVERTEXATTRIBARRAYPROC xglEnableVertexAttribArray;
PFNGLDISABLEVERTEXATTRIBARRAYPROC xglDisableVertexAttribArray;

PFNGLGENBUFFERSPROC xglGenBuffers;
PFNGLDELETEBUFFERSPROC xglDeleteBuffers;

PFNGLBINDBUFFERPROC xglBindBuffer;
PFNGLBUFFERDATAPROC xglBufferData;

PFNGLMAPBUFFERPROC xglMapBuffer;
PFNGLUNMAPBUFFERPROC xglUnmapBuffer;
#endif

static const char* GL_errors[8] = {
    "GL_NO_ERROR", /* There is no current error. */
    "GL_INVALID_ENUM", /* Invalid parameter. */
    "GL_INVALID_VALUE", /* Invalid enum parameter value. */
    "GL_INVALID_OPERATION", /* Illegal call. */
    "GL_STACK_OVERFLOW",
    "GL_STACK_UNDERFLOW",
    "GL_OUT_OF_MEMORY", /* Unable to allocate memory. */

    "GL_UNKNOWN_ERROR" /* ??? */
};

/*
 * specific tracing of any OpenGL errors
 * based on the illustrations in the OpenAL specifications
 */
NOINLINE void DisplayGLError(char * text, GLenum error)
{
    signed int index;

    if (error == GL_NO_ERROR)
    {
#ifdef _WIN32
        MessageBoxA(NULL, text, GL_errors[GL_NO_ERROR], MB_ICONINFORMATION);
#else
        puts(text);
#endif
        return;
    }

    index = (signed int)(error);
    index = index - GL_INVALID_ENUM + 1;
    if (index < 0 || index > 07) /* 2's complement:  if (index & ~7) */
        index = 7;
#ifdef _WIN32
    MessageBoxA(NULL, text, GL_errors[index], MB_ICONERROR);
#else
    fprintf(stderr, "%s\n%s\n\n", GL_errors[index], text);
#endif
    return;
}

static void GL_init_state(void)
{
#ifdef GL_VERSION_1_0
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glColor4f(1.f, 1.f, 1.f, 1.f);
#endif
    glGetIntegerv(GL_VIEWPORT, &viewport[0]);

    glHint(GL_FOG_HINT, GL_FASTEST);
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);

    glLineWidth(1.f);
    glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
    glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST);
    glHint(GL_POLYGON_SMOOTH_HINT, GL_FASTEST);

    glDisable(GL_BLEND);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_SCISSOR_TEST);
    glDisable(GL_CULL_FACE);

    glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_FALSE);
    glDepthMask(GL_FALSE);
    glStencilMask(0);
 /* glIndexMask(0); */

    glBlendFunc(GL_ONE, GL_ZERO);
    glDepthFunc(GL_ALWAYS);
    glStencilFunc(GL_ALWAYS, 0, ~0u);
 /* glAlphaFunc(GL_ALWAYS); */

    glCullFace(GL_BACK);
    glFrontFace(GL_CCW);
    glScissor(0, 0, 640 - 1, 480 - 1);
    glStencilOp(GL_ZERO, GL_INVERT, GL_KEEP);

    glClearColor(0.f, 0.f, 0.f, 0.f);
    glClearDepth(0.);
    glClearStencil(0);
    DisplayInStatusPanel("Waiting for video input...");

    glFinish();
    draw_test_screen();
 /* glColor4f(1.f, 1.f, 1.f, 1.f); */
    glClearColor(0.f, 0.f, 0.f, 0.f);
    return;
}

NOINLINE int init_GL_context(p_void hWnd)
{
    GLenum error;
    GLint max_texture_size;
    int pass;
#ifdef _WIN32
    int pixel_format_enum, pixel_format_old;
    int formats;
    PIXELFORMATDESCRIPTOR test;
    HGLRC current_RC;
    HDC current_DC;
#endif
#if defined(STUCK_WITH_SDL)
    Uint32 video_flags;
#endif

#ifdef _WIN32
    device_context = GetDC(hWnd);
    if (device_context == NULL)
    {
        DisplayError("Failed to get device context from render window.");
        return 0;
    }

    pixel_format_enum = ChoosePixelFormat(device_context, &pixel_format);
    if (pixel_format_enum == 0)
    {
        DisplayError("No suitable pixel format detected on this system.");
        return 0;
    }

    pixel_format_old = GetPixelFormat(device_context);
    if (pixel_format_old != 0 && pixel_format_enum != pixel_format_old)
        pixel_format_enum = pixel_format_old;

    pass = SetPixelFormat(device_context, pixel_format_enum, &pixel_format);
    if (pass == FALSE)
    {
        DisplayError("Failed to set detected pixel format.");
        return 0;
    }

    render_context = wglCreateContext(device_context);
    if (render_context == NULL)
    {
        DisplayError("Failed to get OpenGL render context from DC.");
        return 0;
    }

    pass = wglMakeCurrent(device_context, render_context);
    if (pass == FALSE)
    {
        DisplayError("Failed to set valid render context.");
        return 0;
    }

    current_RC = wglGetCurrentContext();
    current_DC = wglGetCurrentDC();
    if (current_RC != render_context || current_DC != device_context)
        DisplayWarning("OpenGL context state mismatches?");

    formats = GetPixelFormat(device_context);
    formats = DescribePixelFormat(
        device_context, formats, sizeof(PIXELFORMATDESCRIPTOR), &test);
    if (formats == 0) /* either no valid pixel formats or failed call */
        DisplayWarning("Unable to count possible pixel formats?");
    double_buffering = (test.dwFlags & PFD_DOUBLEBUFFER) ? GL_TRUE : GL_FALSE;
#else
#if defined(STUCK_WITH_SDL)
    if (SDL_InitSubSystem(SDL_INIT_VIDEO) < 0)
    {
        fprintf(stderr, "failed SDL_INIT_VIDEO:  %s\n", SDL_GetError());
        SDL_Quit();
    }
    video_info = SDL_GetVideoInfo();
    SDL_desktop[0] = video_info -> current_w;
    SDL_desktop[1] = video_info -> current_h;
    SDL_desktop[2] = video_info -> vfmt -> BitsPerPixel;
    printf("%i x %i, %u-bit\n", SDL_desktop[0], SDL_desktop[1], SDL_desktop[2]);

    SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 5);
    SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 5);
    SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 5);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 0);

    video_surface = SDL_SetVideoMode(640, 480, 0, SDL_OPENGL | SDL_RESIZABLE);
    if (video_surface == NULL)
    {
        fprintf(stderr, "failed SetVideoMode:  %s\n", SDL_GetError());
        SDL_Quit();
    }

    pass = 0;
    SDL_GL_GetAttribute(SDL_GL_DOUBLEBUFFER, &pass);
    double_buffering = (pass == 1) ? GL_TRUE : GL_FALSE;
    if (double_buffering != GL_FALSE)
        puts("Warning:  Double-buffered context in SDL plugin.");
    SDL_WM_SetCaption("Iconoclast's OpenGL", NULL);
#else
    XSetWindowAttributes GLX_set_attributes;
    XVisualInfo* GLX_visual_info;
    Colormap GLX_colormap;
    Window root_window;
    Bool direct_rendering, GLX_support;
    int fail;
    int major, minor;

    GLX_display = XOpenDisplay(NULL);
    if (GLX_display == NULL)
    {
        fputs("Failed to connect to X server.\n", stderr);
        return 0;
    }

    GLX_support = glXQueryExtension(GLX_display, NULL, NULL);
    if (GLX_support == False)
    {
        fputs("OpenGL not supported on this X window display.", stderr);
        return 0;
    }

    GLX_support = glXQueryVersion(GLX_display, &major, &minor);
    if (GLX_support == False)
    {
        fputs("Failed to identify GLX version.\n", stderr);
        return 0;
    }
    printf("Achieved GLX extension version %i.%i.\n", major, minor);

    GLX_visual_info = glXChooseVisual(
        GLX_display,
        DefaultScreen(GLX_display),
        GLX_attributes
    );
    printf("GLX_visual_info = %p\n", (p_void)GLX_visual_info);
    if (GLX_visual_info == NULL)
        return 0;

#if 1
    root_window = RootWindow(GLX_display, GLX_visual_info -> screen);
#else
    root_window = DefaultRootWindow(GLX_display);
#endif
    GLX_colormap = XCreateColormap(
        GLX_display,
        root_window,
        GLX_visual_info -> visual,
        AllocNone
    );

    GLX_set_attributes.colormap = GLX_colormap;
    GLX_set_attributes.border_pixel = 0;
#if 1
    GLX_set_attributes.event_mask = StructureNotifyMask;
#else
    GLX_set_attributes.event_mask = ExposureMask | KeyPressMask;
#endif
    GLX_window = XCreateWindow(
        GLX_display,
        root_window,
        0,
        0,
        640,
        480,
        0,
        GLX_visual_info -> depth,
        InputOutput,
        GLX_visual_info -> visual,
        CWBorderPixel | CWColormap | CWEventMask,
        &GLX_set_attributes
    );

    XMapWindow(GLX_display, GLX_window);
    XStoreName(GLX_display, GLX_window, "Iconoclast's OpenGL");

    GLX_context = glXCreateContext(GLX_display, GLX_visual_info, NULL, True);
    if (GLX_context == NULL)
    {
        fputs("Failed to create context.\n", stderr);
        return 0;
    }
    glXMakeCurrent(GLX_display, GLX_window, GLX_context);

    fail = glXGetConfig(GLX_display, GLX_visual_info, GLX_DOUBLEBUFFER, &pass);
    if (fail != 0)
        fputs("Unable to verify if context is double-buffered.\n", stderr);
    else
        double_buffering = (pass != False) ? GL_TRUE : GL_FALSE;

    direct_rendering = glXIsDirect(GLX_display, GLX_context);
    if (direct_rendering == False)
        puts("No direct rendering support!");
#endif /* STUCK_WITH_SDL */
#endif

    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &max_texture_size);
    if (max_texture_size < 1024)
    {
        char retarded[] = "GL_MAX_TEXTURE_SIZE:  000";

        retarded[22] += (max_texture_size / 100) % 10;
        retarded[23] += (max_texture_size /  10) % 10;
        retarded[24] += (max_texture_size /   1) % 10;
        DisplayError(retarded);
        return 0;
    }
    map_extensions();

    vendor = (const char *)glGetString(GL_VENDOR);
    renderer = (const char *)glGetString(GL_RENDERER);
    version = (const char *)glGetString(GL_VERSION);
#ifndef _WIN32
    printf("GL_VENDOR    :  %s\n", vendor);
    printf("GL_RENDERER  :  %s\n", renderer);
    printf("GL_VERSION   :  %s\n", version);
    puts  ("GL_EXTENSIONS:  ");
    if (support_GDI_bitmap != GL_FALSE)
        printf("    %s\n", "GL_EXT_bgra");
    if (support_buffer_objects != GL_FALSE)
        printf("    %s\n", "GL_ARB_vertex_buffer_object");
    if (support_vertex_program != GL_FALSE)
        printf("    %s\n", "GL_ARB_vertex_program");
    if (support_pixel_DMAs != GL_FALSE)
        printf("    %s\n", "GL_ARB_pixel_buffer_object");
    putchar('\n');
#endif

    GL_init_state();
    pass = swap_buffers();
    if (pass == 0)
        DisplayError("Swapping buffers seems to fail.");

    error = glGetError();
    if (error != GL_NO_ERROR)
    {
        DisplayGLError("Failed to test OpenGL context.", error);
        return 0;
    }
    reform_image_canvas(0, 0);
    return 1;
}

NOINLINE int swap_buffers(void)
{
    GLenum error;
    int pass;

    pass = 1;
    if (double_buffering != GL_FALSE)
    {
#ifdef _DEBUG
        glFinish();
#endif
#ifdef _WIN32
        Sleep(5);
        pass &= SwapBuffers(device_context);
        Sleep(5);
#else

#if defined(STUCK_WITH_SDL)
        SDL_GL_SwapBuffers();
#else
/*
 * In what appears to be a delayed reaction to calling this function, SDL 1.2
 * (or X11) hangs up in an infinite loop after returning from this call in
 * some particular circumstance that I had after hibernating and resuming my
 * 32-bit Ubuntu laptop session prior.  For this reason, we'll stick to plain
 * single-buffered contexts when compiling for Linux Mupen64's plugin system.
 */
        glXSwapBuffers(GLX_display, GLX_window);
#endif

#endif
        glClear( /* Modern OpenGL implementations benefit from extra clears. */
            GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
    else
    {
#ifdef _DEBUG
        glFinish();
#else
        glFlush();
#endif
        glClear(GL_COLOR_BUFFER_BIT);
    }
    error = glGetError();
    if (error != GL_NO_ERROR)
    {
        pass = 0;
        DisplayGLError("Failed to sync commands.", error);
    }
    return (pass);
}

/*
 * OpenGL 3+ has deprecated glColor* and glVertex*.
 * Therefore I wrote my own glColor* and glVertex*, defined in terms of
 * vertex arrays.  For backward-compatibility in this non-performance-relevant
 * test, they are client-side vertex arrays which may need a deprecated func.
 */
NOINLINE static void my_glColorfv(const GLfloat* color)
{
    register int i;

    for (i = 0; i < 4; i++)
        my_glColor[4*0 + i] = color[i];

/*
 * Due to the nature of vertex attribute arrays, to solidly color a
 * geometric figure with a single color requires specifying the same
 * exact color definition multiple times.  On OpenGL ES 1.0, however,
 * we are still presented with the glColor4f alternative, removed in ES 2.0+.
 */
    for (i = 0; i < 4; i++)
        my_glColor[4*1 + i] = color[i];
    for (i = 0; i < 4; i++)
        my_glColor[4*2 + i] = color[i];
    for (i = 0; i < 4; i++)
        my_glColor[4*3 + i] = color[i];
    return;
}

NOINLINE static void my_glRectfv(const GLfloat* v1, const GLfloat* v2)
{
    GLfloat vertices[4 * TRIANGLES_PER_QUAD];
    const GLubyte indices[VERTICES_PER_TRI * TRIANGLES_PER_QUAD] = {
        3, 0, 1,
        3, 2, 1,
    };

    vertices[0*2 + 0] = v1[0]; /* x1 */
    vertices[0*2 + 1] = v1[1]; /* y1 */
    vertices[2*2 + 0] = v2[0]; /* x2 */
    vertices[2*2 + 1] = v2[1]; /* y2 */

    vertices[3*2 + 0] = vertices[0*2 + 0];
    vertices[3*2 + 1] = vertices[2*2 + 1];
    vertices[1*2 + 0] = vertices[2*2 + 0];
    vertices[1*2 + 1] = vertices[0*2 + 1];

    glEnableVertexAttrib(ARRAY_VERTEX);
    glEnableVertexAttrib(ARRAY_COLOR);
    glAttribPointer(ARRAY_VERTEX, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glAttribPointer(ARRAY_COLOR, 4, GL_FLOAT, GL_FALSE, 0, my_glColor);

    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, indices);
    glDisableVertexAttrib(ARRAY_VERTEX);
    glDisableVertexAttrib(ARRAY_COLOR);
    return;
}

NOINLINE void maintain_context(p_void hWnd)
{
    int pass;
#ifndef _WIN32
    GLXContext current_context;
    GLXDrawable current_drawable;
#endif

#ifdef _WIN32
    device_context = wglGetCurrentDC();
    render_context = wglGetCurrentContext();
    if (device_context == NULL || render_context == NULL)
#else
    current_context = glXGetCurrentContext();
    current_drawable = glXGetCurrentDrawable();
    if (current_context == NULL || current_drawable == None)
#endif
    { /* can happen, especially on Microsoft Windows, when threads conflict */
        DisplayWarning("Had to re-initialize GL context.");
        do {
            pass = init_GL_context(hWnd);
        } while (pass == 0);
    }
    return;
}

static void draw_test_screen(void)
{
    GLfloat coordinates[4];
    const GLfloat * vertex;
    GLenum error;
    register int i;
    const GLfloat increment = +2.f/7.f; /* change to 2/8 if 8 bars */

    vertex = (const GLfloat *)(coordinates);
    glClearColor(.075f, .075f, .075f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    coordinates[0] = 0.f/3.f - 1.f;
    coordinates[1] = 2.f/3.f - 1.f;
    coordinates[2] = coordinates[0] + increment;
    coordinates[3] = 1.f;
    for (i = 0; i < 8 - 1; i++)
    {
        my_glColorfv(colors[i]);
        my_glRectfv(vertex + 0, vertex + 2);
        coordinates[0] += increment;
        coordinates[2] += increment;
    }

    coordinates[0] = 0.f/3.f - 1.f;
    coordinates[1] = 2.f/4.f - 1.f;
    coordinates[2] = coordinates[0] + increment;
    coordinates[3] = 2.f/3.f - 1.f;
    for (i = 0; i < 4; i++)
    {
        my_glColorfv(colors[6 - 2*i]);
        my_glRectfv(vertex + 0, vertex + 2);
        coordinates[0] += 2 * increment;
        coordinates[2] += 2 * increment;
    }

    my_glColor[0] = 0.f;
    my_glColor[1] = .125f;
    my_glColor[2] = .295f;
    my_glColor[3] = 1.f;
    my_glColorfv(my_glColor); /* colors approximate?? */

    coordinates[0] = 0./3. - 1.;
    coordinates[1] = 0./3. - 1.;
    coordinates[2] = coordinates[0] + (5.f/28.f * 2.0f); /* approximate?? */
    coordinates[3] = coordinates[1] + (2.f/4.f);
    my_glRectfv(vertex + 0, vertex + 2);

    coordinates[0] += 2 * 10.f/28.f;
    coordinates[2] += 2 * 10.f/28.f;
    my_glColor[0] = .195f;
    my_glColor[1] = 0.f;
    my_glColor[2] = .415f;
    my_glColor[3] = 1.f;
    my_glColorfv(my_glColor); /* colors approximate?? */
    my_glRectfv(vertex + 0, vertex + 2);

    coordinates[0] -= 10.f/28.f;
    coordinates[2] -= 10.f/28.f;
/*
 * We draw the pure white part last in order to leave the GL state machine's
 * glColor set back to white, so future drawings won't have color reduction.
 */
    for (i = 0; i < 4; i++)
        my_glColor[i] = 1.f;
    my_glColorfv(my_glColor);
    my_glRectfv(vertex + 0, vertex + 2);

    error = glGetError();
    if (error != GL_NO_ERROR)
        DisplayGLError("Failed to draw bars test pattern.", error);
    return;
}

NOINLINE GLboolean is_extension_present(char * name)
{
    const GLubyte * str;
    GLenum error;
    register int i, j;

    str = glGetString(GL_EXTENSIONS);
    error = glGetError();
    if (str == NULL || error != GL_NO_ERROR)
    { /* Idiocy has deprecated glGetString(GL_EXTENSIONS) in OpenGL 3.0. */
        GLint param;
        register GLint i, j;

        xglGetStringi = (PFNGLGETSTRINGIPROC)glGetProcAddress("glGetStringi");
        if (xglGetStringi == NULL || error != GL_INVALID_ENUM)
        {
            DisplayGLError("glGetString", error);
            return GL_FALSE;
        }
        glGetIntegerv(GL_NUM_EXTENSIONS, &param);
        for (i = 0; i < param; i++)
        {
            j = 0;
            str = xglGetStringi(GL_EXTENSIONS, i);
lol_loopz:
            if (str[j] != '\0')
            {
                if (name[j] != str[j])
                    continue; /* loop plz! */
                ++j;
                goto lol_loopz;
            }
            if (name[j] == '\0')
                return GL_TRUE;
        }
        return GL_FALSE; /* What did you expect?  Good code? */
    } /* Such is the result of Khronos' deprecation conspiracy. */

/*
 * better code :)
 * using str = glGetString(GL_EXTENSIONS)
 */
    for (j = i = 0; str[i] != '\0'; i++)
    {
        if (str[i] == name[j])
        {
            ++j;
            if (name[j] != '\0')
                continue;
            if (str[i + 1] == '\0' || str[i + 1] == ' ')
                return GL_TRUE;
        }
        j = 0;
    }
    return GL_FALSE;
}

GLvoid map_extensions(void)
{
#if !defined(__glext_h_) & defined(GL_VERSION_2_0)
    support_GDI_bitmap = GL_TRUE;
    support_buffer_objects = GL_TRUE;
    support_pixel_DMAs = GL_TRUE;
    support_vertex_program = GL_TRUE;
    return; /* OpenGL 2.0 (maybe even 1.5) has core support for all this. */
#else
    support_GDI_bitmap = GL_FALSE;
    support_buffer_objects = GL_FALSE;
    support_pixel_DMAs = GL_FALSE;
    support_vertex_program = GL_FALSE;
#endif

/*
 * needed for optimal pixel transfer on little-endian machines, like x86
 * Requires OpenGL 1.2 or later, or the presence of the extension below.
 */
    support_GDI_bitmap = is_extension_present("GL_EXT_bgra");
    if (support_GDI_bitmap == GL_FALSE)
    {
        GLshort endian_test;

        endian_test = 0;
        *(GLbyte *)&endian_test = 1;
        endian_test = (endian_test << 8) & 0xFFFF;
        if (endian_test != 0x00)
            DisplayError("GL_EXT_bgra");
    }

/*
 * We actually don't have high value for this function's support, but it is
 * a requirement to being able to program low-level access to the GPU.  That
 * being said, it's the oldest way to render ANY geometry that hasn't been
 * deprecated.  (glVertex*, glVertexPointer, etc. are deprecated as of GL3.)
 */
#if defined(__glext_h_) & defined(GL_VERSION_2_0)
    support_vertex_program = is_extension_present("GL_ARB_vertex_program");
    if (support_vertex_program == GL_FALSE)
        DisplayWarning("GL_ARB_vertex_program");

    xglVertexAttribPointer =
        (PFNGLVERTEXATTRIBPOINTERPROC)
        glGetProcAddress("glVertexAttribPointerARB");
    xglEnableVertexAttribArray =
        (PFNGLENABLEVERTEXATTRIBARRAYPROC)
        glGetProcAddress("glEnableVertexAttribArrayARB");
    xglDisableVertexAttribArray =
        (PFNGLDISABLEVERTEXATTRIBARRAYPROC)
        glGetProcAddress("glDisableVertexAttribArrayARB");
#endif

#if defined(__glext_h_) & defined(GL_VERSION_1_5)
/*
 * needed for optimal vertex arrays on video card server's side
 * Requires OpenGL 1.5 (1.2 for ARB), or the below extension.
 *
 * If compiling for a primitive OpenGL context (like 1.1 for Windows), there
 * is no cause for concern, as this plugin implements compatibility fallback.
 * It won't make the plugin unusable, just slower due to CPU-side bus upload.
 */
    support_buffer_objects =
        is_extension_present("GL_ARB_vertex_buffer_object");

/*
 * needed for optimal pixel transfer on video card server's side
 * Requires OpenGL 1.5 (1.2 for ARB), or the below extension.
 *
 * VERY important extension!  This gave me a whole extra 100+ VI/s speed in
 * basic CFB homebrew/demos emulation.  The above extension is only an
 * ingredient to this one and is far less significant for optimal speed.
 */
    support_pixel_DMAs = is_extension_present("GL_ARB_pixel_buffer_object");

    xglGenBuffers = (PFNGLGENBUFFERSPROC)glGetProcAddress("glGenBuffersARB");
    xglBindBuffer = (PFNGLBINDBUFFERPROC)glGetProcAddress("glBindBufferARB");
    xglBufferData = (PFNGLBUFFERDATAPROC)glGetProcAddress("glBufferDataARB");

    xglDeleteBuffers = (PFNGLDELETEBUFFERSPROC)
        glGetProcAddress("glDeleteBuffersARB");
    xglMapBuffer = (PFNGLMAPBUFFERPROC)glGetProcAddress("glMapBufferARB");
    xglUnmapBuffer = (PFNGLUNMAPBUFFERPROC)glGetProcAddress("glUnmapBufferARB");
    xglGetStringi = (PFNGLGETSTRINGIPROC)glGetProcAddress("glGetStringiARB");
#endif
    return;
}

NOINLINE void rebound_screen_texture(const float * quad, int linear)
{
    const GLfloat * pointer;
    GLenum error;
    GLint param;
    const GLsizei stride = (COORDS_PER_VTX << INTERLEAVED) * sizeof(GLfloat);
    const GLboolean is_texture = glIsTexture(name_tex);

    pointer = quad;
    if (support_buffer_objects != GL_FALSE)
    {
        pointer = NULL;

        xglBindBuffer(GL_ARRAY_BUFFER, 0);
#if (NUM_BUFFERS > 2)
        xglBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
#endif
        xglDeleteBuffers(NUM_BUFFERS, &name_buf[0]);
    }
    if (support_pixel_DMAs != GL_FALSE)
        xglBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);

    if (support_buffer_objects != GL_FALSE)
    { /* support for modern OpenGL to attempt avoidance of deprecated methods */
        xglGenBuffers(NUM_BUFFERS, &name_buf[0]);
        xglBindBuffer(GL_ARRAY_BUFFER, name_buf[NAME_ARRAY]);
        xglBufferData(GL_ARRAY_BUFFER, 4 * stride, quad, GL_STATIC_DRAW);
#if (NUM_BUFFERS > 2)
        xglBindBuffer(GL_ELEMENT_ARRAY_BUFFER, name_buf[NAME_ELEMENT_ARRAY]);
        xglBufferData(
            GL_ELEMENT_ARRAY_BUFFER,
            TRIANGLES_PER_QUAD * VERTICES_PER_TRI * sizeof(GLubyte),
            quad_into_tris,
            GL_STATIC_DRAW
        );
#endif
    }

#ifdef _DEBUG
    wglMakeCurrent(device_context, render_context); /* wgl drivers fix? */

/*
 * only useful for removing wrap-around pixel lines in X and Y dimensions
 * when there is an inaccuracy with the OpenGL texture stretching
 *
 * best left to their default values for extra speed
 */
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
#endif

    param = (linear) ? GL_LINEAR : GL_NEAREST;
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, param);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, param);

#ifdef GL_VERSION_1_0
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
#endif

#if defined(GL_VERSION_1_0) & !defined(GL_VERSION_1_1)
    glDeleteLists(frame_buffer_draw_list, 1);
    frame_buffer_draw_list = glGenLists(1);

    glNewList(frame_buffer_draw_list, GL_COMPILE);
    glBegin(GL_QUADS);

    glTexCoord(&quad[0*COORDS_PER_VTX << INTERLEAVED]);
    glVertex(&quad[(0*COORDS_PER_VTX << INTERLEAVED) + COORDS_PER_VTX]);
    glTexCoord(&quad[1*COORDS_PER_VTX << INTERLEAVED]);
    glVertex(&quad[(1*COORDS_PER_VTX << INTERLEAVED) + COORDS_PER_VTX]);
    glTexCoord(&quad[3*COORDS_PER_VTX << INTERLEAVED]);
    glVertex(&quad[(3*COORDS_PER_VTX << INTERLEAVED) + COORDS_PER_VTX]);
    glTexCoord(&quad[2*COORDS_PER_VTX << INTERLEAVED]);
    glVertex(&quad[(2*COORDS_PER_VTX << INTERLEAVED) + COORDS_PER_VTX]);

    glEnd();
    glEndList();
#else
    if (is_texture != GL_FALSE)
        { /* branch */ }
    else
    {
        glEnable(GL_TEXTURE_2D);
        glDeleteTextures(1, &name_tex);
        glGenTextures(1, &name_tex);
        glBindTexture(GL_TEXTURE_2D, name_tex);
    }
    glTexImage2D(
        GL_TEXTURE_2D,
        0,
        4,
        1024, /* maximum (VI_H_SYNC_REG &= 0x00000FFF):  4095 quarter-pixels */
        1024, /* maximum (VI_V_SYNC_REG &= 0x000003FF):  1023 pixels */
        0,
        GL_BGRA,
        GL_UNSIGNED_BYTE,
        NULL
    );

    if (support_pixel_DMAs != GL_FALSE)
    {
        xglBindBuffer(GL_PIXEL_UNPACK_BUFFER, name_buf[NAME_PIXEL_UNPACK]);
        xglBufferData(
            GL_PIXEL_UNPACK_BUFFER,
            4 * 1024 * 1024,
            NULL, /* promotes asynchronous glMapBuffer ?? */
            GL_STREAM_DRAW
        );
    }
    glEnableVertexAttrib(ARRAY_VERTEX);
    glEnableVertexAttrib(ARRAY_TEXTURE_COORD);
    glAttribPointer(
        ARRAY_VERTEX,
        COORDS_PER_VTX,
        GL_FLOAT,
        GL_FALSE,
        stride,
        &pointer[COORDS_PER_VTX]
    );
    glAttribPointer(
        ARRAY_TEXTURE_COORD,
        COORDS_PER_VTX,
        GL_FLOAT,
        GL_FALSE,
        stride,
        &pointer[0]
    );
#endif

    error = glGetError();
    if (error != GL_NO_ERROR)
        DisplayGLError("Failed to rebound 2-D texture image.", error);
    return;
}
