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
    # Make.inc unconditionally sets CC := $(TOOLPREFIX)gcc when USEGCC=1,
    # ignoring any environment-inherited $CC, and TOOLPREFIX is never set
    # here. This breaks cross-compiled builds (aarch64, ppc64le), where
    # only the triplet-prefixed compiler exists ("gcc: No such file or
    # directory"). Let the environment CC win instead, mirroring the
    # existing clang/osx fix above.
    sed -i.bak 's/CC := \$(TOOLPREFIX)gcc/CC ?= \$(TOOLPREFIX)gcc/' Make.inc
fi

make prefix="${PREFIX}/"
make install prefix="${PREFIX}/"
