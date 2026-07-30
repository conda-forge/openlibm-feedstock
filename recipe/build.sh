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
    # openlibm's hand-written x86 assembly (.S) files don't mark the stack
    # non-executable, so the linker leaves PT_GNU_STACK requesting one.
    # glibc >= 2.41 and hardened kernels refuse to dlopen() such a library
    # ("cannot enable executable stack as shared object requires"), which
    # breaks every Julia release linking against this package
    # (JuliaLang/julia#57250). Force the linker to mark the stack
    # non-executable regardless of what individual objects request.
    export LDFLAGS="${LDFLAGS} -Wl,-z,noexecstack"
fi

make prefix="${PREFIX}/"
make install prefix="${PREFIX}/"

if [[ "$target_platform" == linux-* ]]; then
    for lib in "${PREFIX}"/lib/libopenlibm.so.*; do
        [[ -L "$lib" ]] && continue
        if readelf -lW "$lib" | grep -q 'GNU_STACK.*RWE'; then
            echo "$lib still requests an executable stack" >&2
            exit 1
        fi
    done
fi
