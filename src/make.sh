mkdir -p obj
src="."
FLAGS_x86="-pedantic -masm=intel -msse2 -DSTUCK_WITH_SDL"
FLAGS_x64="-pedantic -masm=intel -fPIC -DSTUCK_WITH_SDL"

# Set to FLAGS_x64 if on 64-bit target, but currently no 64-bit plugin specs.
FLAGS_C=$FLAGS_x86

echo Compiling C source code...
cc -S -Os $FLAGS_C -o obj/main.asm      $src/main.c
cc -S -Os $FLAGS_C -o obj/context.asm   $src/context.c
cc -S -O3 $FLAGS_C -o obj/n64video.asm  $src/n64video.c -DUSE_SSE_SUPPORT
cc -S -O3 $FLAGS_C -o obj/vi.asm        $src/vi.c       -DUSE_SSE_SUPPORT
cc -S -O3 $FLAGS_C -o obj/rdp.asm       $src/rdp.c      -DUSE_SSE_SUPPORT
cc -S -Os $FLAGS_C -o obj/config.asm    $src/config.c
cc -S -Os $FLAGS_C -o obj/bitmap.asm    $src/bitmap.c

echo Assembling compiled sources...
as -o obj/main.o        obj/main.asm
as -o obj/context.o     obj/context.asm
as -o obj/n64video.o    obj/n64video.asm
as -o obj/vi.o          obj/vi.asm
as -o obj/rdp.o         obj/rdp.asm
as -o obj/config.o      obj/config.asm
as -o obj/bitmap.o      obj/bitmap.asm

OBJ_LIST="\
    obj/main.o \
    obj/context.o \
    obj/n64video.o \
    obj/vi.o \
    obj/rdp.o \
    obj/config.o \
    obj/bitmap.o \
"

echo Linking assembled object files...
ld --shared -o obj/vigl.so $OBJ_LIST -lGL -lX11
strip -o obj/vigl.so obj/vigl.so
