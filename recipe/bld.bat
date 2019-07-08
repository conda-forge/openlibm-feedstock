set ARCH=x86_64
set CC=%ARCH%-w64-mingw32-gcc
set OS=WINNT
set MAKE=%BUILD_PREFIX%\Library\mingw-w64\bin\mingw32-make.exe
set "MAKE_ARGS=ARCH=%ARCH% CC=%CC% OS=%OS% SHLIB_EXT=dll prefix=%LIBRARY_PREFIX:\=/%"

%MAKE% %MAKE_ARGS%
%MAKE% install %MAKE_ARGS%

REM Its makefile still don't know how to generate .lib instead of .a:
REM This is the "static library"
move %LIBRARY_LIB%\libopenlibm.a %LIBRARY_LIB%\libopenlibm_static.lib
REM This is the "import library", note that it is moved to LIBRARY_LIB
move %LIBRARY_BIN%\libopenlibm.dll.a %LIBRARY_LIB%\libopenlibm.lib
