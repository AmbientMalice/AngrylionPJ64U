#ifndef _CONTEXT_H_
#define _CONTEXT_H_

#ifdef _WIN32
#include <windows.h>
#else
#include <X11/X.h>
#endif

#include <GL/gl.h>
#ifdef X_H
#include <GL/glx.h>
#endif

#include "glcompat.h"
#include "my_types.h"

#ifdef STUCK_WITH_SDL
/*
 * Due to an on-going bug with GL context initialization under a parent X11
 * window which was created via SDL, it is difficult not to include SDL. :(
 */
#include <SDL/SDL.h>
#endif

/*
 * using the NTSC-typical SMPTE standard of 75% color intensity
 */
#define CHAN_OFF    (0.f / 4.f)
#define CHAN_ON     (3.f / 4.f)

#define NUM_BUFFERS     2

#ifdef _WIN32
extern HGLRC render_context;
extern HDC device_context;
extern const PIXELFORMATDESCRIPTOR pixel_format;
#else
extern GLXContext GLX_context;
extern Display* GLX_display;
extern Window GLX_window;
#endif

#ifdef STUCK_WITH_SDL
extern SDL_Surface* video_surface;
extern const SDL_VideoInfo* video_info;
extern unsigned int SDL_desktop[3];
#endif

/*  ___
 * |  /| 1 rectangle = 2 triangles
 * | / | 1 triangle = 3 vertices
 * |/__| 1 vertex = 2+ coordinates
 * Vertices and texture boundary data are "INTERLEAVED" in one array.
 */
#define INTERLEAVED             1
#define TRIANGLES_PER_QUAD      2
#define VERTICES_PER_TRI        3
#ifdef _DEBUG
#define COORDS_PER_VTX          4
#else
#define COORDS_PER_VTX          2
#endif

#if (COORDS_PER_VTX < 3)
#define ZW_CARTESIAN    ,
#elif (COORDS_PER_VTX == 3)
#define ZW_CARTESIAN    , 0.f,
#else
#define ZW_CARTESIAN    , 0.f, +1.f,
#endif

/*
 * for OpenGL 1.0 compliance
 * Do not use OpenGL 1.0.  The fixed function pipeline support is for tests.
 */
#define glVertex            glVertexf
#define glTexCoord          glTexCoordf
#define glRasterPos         glRasterPosf

#define glVertexf           glVertexfv
#define glTexCoordf         glTexCoordfv
#define glRasterPosf        glRasterPosfv
#if (COORDS_PER_VTX == 2)
#define glVertexfv          glVertex2fv
#define glTexCoordfv        glTexCoord2fv
#define glRasterPosfv       glRasterPos2fv
#elif (COORDS_PER_VTX == 3)
#define glVertexfv          glVertex3fv
#define glTexCoordfv        glTexCoord3fv
#define glRasterPosfv       glRasterPos3fv
#else
#define glVertexfv          glVertex4fv
#define glTexCoordfv        glTexCoord4fv
#define glRasterPosfv       glRasterPos4fv
#endif

#ifdef GL_DEPRECATION_MODEL
enum {
    ARRAY_VERTEX,
    ARRAY_NORMAL,
    ARRAY_COLOR,
    ARRAY_INDEX,
    ARRAY_TEXTURE_COORD
};
#else
#define ARRAY_VERTEX            GL_VERTEX_ARRAY
#define ARRAY_NORMAL            GL_NORMAL_ARRAY
#define ARRAY_COLOR             GL_COLOR_ARRAY
#define ARRAY_INDEX             GL_INDEX_ARRAY
#define ARRAY_TEXTURE_COORD     GL_TEXTURE_COORD_ARRAY
#endif

/*
 * Should I have named it "glEnableAttribArray", not "glEnableVertexAttrib"?
 * Eh, they're both short of meaning.  Attrib. arrays could mean glColor*v.
 *
 * This doesn't en-/disable vertex attributes everywhere, just vertex arrays.
 */
#ifdef GL_DEPRECATION_MODEL
#define glEnableVertexAttrib(index)     glEnableVertexAttribArray(index)
#define glDisableVertexAttrib(index)    glDisableVertexAttribArray(index)
#else
#define glEnableVertexAttrib(array)     glEnableClientState(array)
#define glDisableVertexAttrib(array)    glDisableClientState(array)
#endif

#ifdef GL_DEPRECATION_MODEL
#define glAttribPointer(index, size, type, normalized, stride, pointer) \
    xglVertexAttribPointer(index, size, type, normalized, stride, pointer)
#else
#define glAttribPointer(array, size, type, normalized, stride, pointer) \
    switch (array) \
    { \
    case ARRAY_VERTEX:         \
        glVertexPointer(size, type, stride, pointer);   break; \
    case ARRAY_NORMAL:         \
        glNormalPointer(type, stride, pointer);         break; \
    case ARRAY_COLOR:          \
        glColorPointer(size, type, stride, pointer);    break; \
    case ARRAY_INDEX:          \
        glIndexPointer(type, stride, pointer);          break; \
    case ARRAY_TEXTURE_COORD:  \
        glTexCoordPointer(size, type, stride, pointer); break; \
    }
#endif

#if defined(GL_VERSION_1_0) | defined(GL_VERSION_1_1)
extern PFNGLGETSTRINGIPROC xglGetStringi;
extern PFNGLVERTEXATTRIBPOINTERPROC xglVertexAttribPointer;

extern PFNGLENABLEVERTEXATTRIBARRAYPROC xglEnableVertexAttribArray;
extern PFNGLDISABLEVERTEXATTRIBARRAYPROC xglDisableVertexAttribArray;

extern PFNGLGENBUFFERSPROC xglGenBuffers;
extern PFNGLDELETEBUFFERSPROC xglDeleteBuffers;

extern PFNGLBINDBUFFERPROC xglBindBuffer;
extern PFNGLBUFFERDATAPROC xglBufferData;

extern PFNGLMAPBUFFERPROC xglMapBuffer;
extern PFNGLUNMAPBUFFERPROC xglUnmapBuffer;
#endif

enum {
    NAME_PIXEL_UNPACK,
    NAME_ARRAY,
    NAME_ELEMENT_ARRAY /* optional, for glDrawElements indexed vertex array */
};

extern GLuint name_buf[NUM_BUFFERS];
extern GLint viewport[4];

extern const char * vendor;
extern const char * renderer;
extern const char * version;

extern GLuint name_tex;
extern GLuint frame_buffer_draw_list;

extern GLboolean double_buffering;
extern GLboolean support_GDI_bitmap;
extern GLboolean support_buffer_objects;
extern GLboolean support_pixel_DMAs;
extern GLboolean support_vertex_program;

static NOINLINE void my_glColorfv(const GLfloat* color);
static NOINLINE void my_glRectfv(const GLfloat* v1, const GLfloat* v2);
static void draw_test_screen(void);

extern NOINLINE int init_GL_context(p_void hWnd);
extern NOINLINE void maintain_context(p_void hWnd);
extern NOINLINE void DisplayGLError(char * text, GLenum error);
extern NOINLINE GLboolean is_extension_present(char * name);
extern GLvoid map_extensions(void);

extern NOINLINE int swap_buffers(void);
extern NOINLINE void rebound_screen_texture(const float * quad, int linear);

#endif
