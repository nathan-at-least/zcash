#!/bin/bash
set -exu -o pipefail

cd "$(dirname "$(readlink -f "$0")")/.."

# If --enable-lcov is the first argument, enable lcov coverage support:
LCOV_ARG=''
if [ "x${1:-}" = 'x--enable-lcov' ]
then
    LCOV_ARG='--enable-lcov'
    shift
fi

# BUG: parameterize the platform/host directory:
PREFIX="$(pwd)/depends/x86_64-unknown-linux-gnu/"

make "$@" -C ./depends/ V=1 NO_QT=1
./autogen.sh
./configure --prefix="${PREFIX}" --with-gui=no "$LCOV_ARG" CXXFLAGS='-O0 -g'
make "$@" V=1
