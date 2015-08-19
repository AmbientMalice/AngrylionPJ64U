@ECHO OFF
TITLE MinGW Compiler Suite Invocation

set MinGW=C:/MinGW

set src=%CD%
set obj=%src%/obj

set OBJ_LIST=^
%obj%/main.o ^
%obj%/context.o ^
%obj%/n64video.o ^
%obj%/vi.o ^
%obj%/rdp.o ^
%obj%/config.o ^
%obj%/bitmap.o ^
%obj%/res.res

set FLAGS_x86=-pedantic -masm=intel -msse2 -mstackrealign
set FLAGS_C=%FLAGS_x86%

if not exist obj (
mkdir obj
)
cd %MinGW%/bin

echo Compiling C source code...
cc -S -Os %FLAGS_C% -o %obj%/main.asm       %src%/main.c
cc -S -Os %FLAGS_C% -o %obj%/context.asm    %src%/context.c
cc -S -O3 %FLAGS_C% -o %obj%/n64video.asm   %src%/n64video.c -DUSE_SSE_SUPPORT
cc -S -O3 %FLAGS_C% -o %obj%/vi.asm         %src%/vi.c       -DUSE_SSE_SUPPORT
cc -S -O3 %FLAGS_C% -o %obj%/rdp.asm        %src%/rdp.c      -DUSE_SSE_SUPPORT
cc -S -Os %FLAGS_C% -o %obj%/config.asm     %src%/config.c
cc -S -Os %FLAGS_C% -o %obj%/bitmap.asm     %src%/bitmap.c

echo Assembling compiled sources...
as -o %obj%/main.o          %obj%/main.asm
as -o %obj%/context.o       %obj%/context.asm
as -o %obj%/n64video.o      %obj%/n64video.asm
as -o %obj%/vi.o            %obj%/vi.asm
as -o %obj%/rdp.o           %obj%/rdp.asm
as -o %obj%/config.o        %obj%/config.asm
as -o %obj%/bitmap.o        %obj%/bitmap.asm

echo Linking assembled object files...
windres -i %src%/res.rc --input-format=rc -o %obj%/res.res -O coff
ld --shared -e _DllMain@12 -o %obj%/vigl_dbg.dll %OBJ_LIST% -lcomctl32 -lopengl32 -lgdi32 -luser32 -lkernel32
strip -o %obj%/vigl.dll %obj%/vigl_dbg.dll

pause
