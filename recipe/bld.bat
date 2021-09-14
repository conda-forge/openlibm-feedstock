set ARCH=x86_64
set CC=%ARCH%-w64-mingw32-gcc
set OS=WINNT
set MAKE=%BUILD_PREFIX%\Library\mingw-w64\bin\mingw32-make.exe
set "MAKE_ARGS=ARCH=%ARCH% CC=%CC% OS=%OS% SHLIB_EXT=dll prefix=%LIBRARY_PREFIX:\=/%"

%MAKE% %MAKE_ARGS%
%MAKE% install %MAKE_ARGS%
