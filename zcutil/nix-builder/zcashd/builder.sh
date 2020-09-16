#!/bin/bash
set -efuo pipefail

# Include the std nix build config, including our package's own build
# toolchain dependencies:
source "$stdenv/setup"

# Turn off xtrace before running nix exitHandler:
trap 'set +x; exitHandler' EXIT

# Show each step:
set -x

make -C \
    "$src/depends" \
    BASEDIR="$out/depends-output" \
    PATCHES_PATH="$src/depends/patches" \
    SOURCES_PATH="$zcdepsrc"

./autogen.sh
CONFIG_SITE="$src/depends/$HOST/share/config.site" ./configure
make
