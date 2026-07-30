#!/usr/bin/env bash

# ARCH is an argument to the Makefile.
# So we tweak ARCH to be as expected.
if [ "$ARCH" == "64" ]
then
    export ARCH="amd64"
elif [ "$ARCH" == "32" ]
then
    export ARCH="i386"
fi

# Set compiler to use to match the system.
if [[ "$target_platform" == osx-* ]]; then
    export USEGCC=0
    export USECLANG=1
    sed -i.bak "s/CC = clang/CC ?= clang/g" Make.inc
elif [[ "$target_platform" == linux-* ]]; then
    export USEGCC=1
    export USECLANG=0
fi

make prefix="${PREFIX}/"
make install prefix="${PREFIX}/"

# openlibm's hand-written x86 assembly (.S) files don't mark the stack
# non-executable, so the linker leaves the PT_GNU_STACK header requesting
# an executable stack. glibc >= 2.41 and hardened kernels refuse to
# dlopen() such a library ("cannot enable executable stack as shared
# object requires"), which breaks every Julia release that links against
# this package (JuliaLang/julia#57250). Clear the flag on the objects we
# actually ship.
if [[ "$target_platform" == linux-* ]]; then
    find "${PREFIX}/lib" -name 'libopenlibm.so*' -exec patchelf --clear-execstack {} \;
fi
