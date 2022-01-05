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
