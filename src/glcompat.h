#ifndef _GLCOMPAT_H_
#define _GLCOMPAT_H_

/*
 * We can't determine whether the OpenGL/ES (etc.?) deprecation model is in
 * place or not without reading from your local <GL/gl.h>, <GLES/gl.h>, or
 * whatever you intended to use.  Include the GL header first, then this.
 * Did you mean to #include <GLES2/gl2.h>?  We don't know.  Just include it.
 */
#ifndef __gl_h_
#error Cannot detect core OpenGL deprecation if GL API not yet included.
#endif

/*
 * Conversely, it's impossible for us to see the version of your included
 * GL API header file if you DID include "glext.h", because that #define's
 * many of the GL_VERSION_#_# symbols and interferes with version detection.
 */
#if defined(__glext_h_) & defined(_WIN32)
#error Cannot detect core OpenGL deprecation if <glext.h> included prematurely.
#endif

/*
 * Currently we'll assume that you included the OpenGL ES API header based on
 * whether either the 1_0 or 2_0 symbols were defined.  We can't just check
 * only GL_OES_VERSION_1_0 because OpenGL ES 2.0 isn't backwards-compatible,
 * due to conforming to the deprecation model in OpenGL 3.  The OpenGL ES 1.1
 * header, for example, will define the 1_0 symbol, but GL ES 2.0+ will not.
 */
#if defined(GL_OES_VERSION_1_0) | defined(GL_OES_VERSION_2_0)
#define GL_EMBEDDED_SYSTEM
#endif

/*
 * Minimum OpenGL and OpenGL ES versions defined that imply deprecation.
 * These are stacked upon, so GL 3.2, GL 3.3 etc. define GL_VERSION_3_1.
 */
#if defined(GL_VERSION_3_1) | defined(GL_OES_VERSION_2_0)
#ifndef __glext_h_
#define GL_DEPRECATION_MODEL
#endif
#endif

#undef GL_GLEXT_PROTOTYPES
#if defined(GL_VERSION_2_0) | defined(GL_VERSION_3_0) | defined(GL_VERSION_3_1)
#else
#include <GL/glext.h>
#endif

/*
 * Modern OpenGL programming can be a pain when forced to go through
 * extensions on a limited, legacy OpenGL API header include file.
 *
 * There are convenience libraries like GLEW to be sure, true, but why
 * not have a unified macro, "glGetProcAddress", which may translate to:
 */
#ifdef __egl_h_ /* mobile or embedded devices and OpenGL ES */
#define glGetProcAddress(fn)    eglGetProcAddress(fn)
#elif defined(GLX_H) /* Linux X-windowing system interface */
#define glGetProcAddress(fn)    glXGetProcAddress((const GLubyte *)fn)
#elif defined(_WINGDI_) /* Windows GDI generic software interface */
#define glGetProcAddress(fn)    wglGetProcAddress((LPCSTR)fn)
#elif defined(_SDL_H) /* Simple DirectMedia Layer */
#define glGetProcAddress(fn)    SDL_GL_GetProcAddress(fn)
#else
/* ??? dunno what Macintosh's CGL, FreeBSD, others do ??? */
#error \
Unimplemented on this OS, or you forgot to include context creation API for it?
#endif

/*
 * This is where we set up "fake functions" as macros for the deprecated
 * (and removed) OpenGL functions no longer available in the OpenGL API.
 *
 * If you are compiling with API headers for OpenGL 3.1 or later, this
 * section will be necessary to avoid unresolved symbol errors.
 *
 * We don't need to instantly fail the compilation process if the compiler
 * sees references to any of these...we're just using deprecated methods as a
 * compatibility fallback within the application if extensions aren't found.
 * This way, the software prints errors to the user to let them know WHAT
 * required OpenGL extensions their video card is missing, IF the deprecated
 * commands were removed and inaccessible at run-time.  Verbosity is good. :)
 */
#ifdef GL_DEPRECATION_MODEL
#define glBegin(mode) \
    DisplayGLError("glBegin", GL_INVALID_OPERATION)
#define glEnd() \
    DisplayGLError("glEnd", GL_INVALID_OPERATION)

#define glGenLists(range) \
    DisplayGLError("glGenLists", GL_INVALID_OPERATION)
#define glNewList(list, mode) \
    DisplayGLError("glNewList", GL_INVALID_OPERATION)
#define glEndList() \
    DisplayGLError("glEndList", GL_INVALID_OPERATION)
#define glDeleteLists(list, range) \
    DisplayGLError("glDeleteLists", GL_INVALID_OPERATION)
#define glIsList(list) \
    DisplayGLError("glIsList", GL_INVALID_OPERATION)
#define glCallList(list) \
    DisplayGLError("glCallList", GL_INVALID_OPERATION)
#define glCallLists(n, type, lists) \
    DisplayGLError("glCallLists", GL_INVALID_OPERATION)
#define glListBase(base) \
    DisplayGLError("glListBase", GL_INVALID_OPERATION)

#define glVertex2fv(v) \
    DisplayGLError("glVertex2fv", GL_INVALID_OPERATION)
#define glVertex3fv(v) \
    DisplayGLError("glVertex3fv", GL_INVALID_OPERATION)
#define glVertex4fv(v) \
    DisplayGLError("glVertex4fv", GL_INVALID_OPERATION)

#define glTexCoord2fv(v) \
    DisplayGLError("glTexCoord2fv", GL_INVALID_OPERATION)
#define glTexCoord3fv(v) \
    DisplayGLError("glTexCoord3fv", GL_INVALID_OPERATION)
#define glTexCoord4fv(v) \
    DisplayGLError("glTexCoord4fv", GL_INVALID_OPERATION)

#define glColor2fv(v) \
    DisplayGLError("glColor2fv", GL_INVALID_OPERATION)
#define glColor3fv(v) \
    DisplayGLError("glColor3fv", GL_INVALID_OPERATION)
#define glColor4fv(v) \
    DisplayGLError("glColor4fv", GL_INVALID_OPERATION)
#define glColor4f(red, green, blue, alpha) \
    DisplayGLError("glColor4f", GL_INVALID_OPERATION)

#define glDisableClientState(array) \
    DisplayGLError("glDisableClientState", GL_INVALID_OPERATION)
#define glEnableClientState(array) \
    DisplayGLError("glEnableClientState", GL_INVALID_OPERATION)

#define glColorPointer(size, type, stride, pointer) \
    DisplayGLError("glColorPointer", GL_INVALID_OPERATION)
#define glVertexPointer(size, type, stride, pointer) \
    DisplayGLError("glVertexPointer", GL_INVALID_OPERATION)
#define glTexCoordPointer(size, type, stride, pointer) \
    DisplayGLError("glTexCoordPointer", GL_INVALID_OPERATION)

#define glRectfv(v1, v2) \
    DisplayGLError("glRectfv", GL_INVALID_OPERATION)

#define glRasterPos2fv(x, y) \
    DisplayGLError("glRasterPos2fv", GL_INVALID_OPERATION)
#define glRasterPos3fv(x, y) \
    DisplayGLError("glRasterPos3fv", GL_INVALID_OPERATION)
#define glRasterPos4fv(x, y) \
    DisplayGLError("glRasterPos4fv", GL_INVALID_OPERATION)

#define glPixelZoom(xfactor, yfactor) \
    DisplayGLError("glPixelZoom", GL_INVALID_OPERATION)
#define glDrawPixels(width, height, format, type, pixels) \
    DisplayGLError("glDrawPixels", GL_INVALID_OPERATION)
#define glCopyPixels(x, y, width, height, type) \
    DisplayGLError("glCopyPixels", GL_INVALID_OPERATION)
#endif

/*
 * As for OpenGL ES, only a couple extra things need to be addressed.
 * The primary factor is that (GLdouble) is not a valid type.
 */
#ifdef GL_EMBEDDED_SYSTEM
#define glClearDepth(depth) \
    glClearDepthf((GLfloat)(depth))
#define glDepthRange(zNear, zFar) \
    glDepthRangef((GLclampf)(zNear), (GLclampf)(zFar))
#define glTexImage1D( \
    target, level, internalformat, width, border, format, type, pixels) \
    DisplayGLError("glTexImage1D", GL_INVALID_OPERATION)
#endif

/*
 * But what exactly should "DisplayGLError" do?
 * It's certainly not a macro I can define in this file.
 *
 * I got the idea off Creative Labs' OpenAL SDK, which used "DisplayALError".
 * Creative never gave a definite, clean solution for this function, so
 * here's my optimized example using their demonstrative prototype.
 */
extern void DisplayGLError(char * text, GLenum error);
#ifdef JUST_AN_EXAMPLE_OF_DISPLAYGLERROR
static const char* GL_errors[8] = {
    "GL_NO_ERROR", /* There is no current error. */
    "GL_INVALID_ENUM", /* Invalid parameter. */
    "GL_INVALID_VALUE", /* Invalid enum parameter value. */
    "GL_INVALID_OPERATION", /* Illegal call. */
    "GL_STACK_OVERFLOW", /* Command would cause a stack overflow. */
    "GL_STACK_UNDERFLOW", /* Command would cause a stack underflow. */
    "GL_OUT_OF_MEMORY", /* Unable to allocate memory. */

    "GL_UNKNOWN_ERROR" /* ??? */
};

NOINLINE void DisplayGLError(char * text, GLenum error)
{
    FILE * stream;
    signed int index;

    stream = (error == GL_NO_ERROR) ? stdout : stderr;
    index = (signed int)(error);
    if (error != GL_NO_ERROR)
        index = index - GL_INVALID_ENUM + 1;
    if (index < 0 || index > 7)
        index = 7;
    fputs(GL_errors[index], stream);
    fputs("\n", stream);
    fputs(text, stream);
    fputs("\n\n", stream);
    return;
}
#endif

/*
 * In case the appropriate extensions for modern OpenGL features (such as
 * pixel and vertex buffer objects) are not found on one's video hardware
 * (quite plausible when executing an OpenGL application on Microsoft Windows
 * in generic software GL 1.1 mode for debugging hardware/driver problems),
 * then we are forced to use some of these deprecated commands.  If, however,
 * the user's video card has no support for non-deprecated OpenGL commands
 * AND the deprecated commands we must fall back on don't exist at run-time,
 * then we're screwed, but, at least we can't say I didn't try. :)
 *
 * When compiling and linking against an OpenGL 3.0 or earlier library,
 * run-time success at calling these removed OpenGL commands depends
 * on the following three factors, in order of significance:
 *     1.  your GPU's incapability of getting an OpenGL 3.1 or later context
 *     2.  your video card manufacturer/drivers (NVIDIA is a safe bet.)
 *     3.  your operating system's decision to supply GL_ARB_compatibility
 *         (counterexample:  Apple Macintosh)
 * If even one of these conditions gets a check, you're safe to use
 * deprecated OpenGL commands.
 */
#endif
