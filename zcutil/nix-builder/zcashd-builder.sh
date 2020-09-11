#!/bin/bash
set -efuo pipefail

source "$stdenv/setup"

set -x
# Turn off xtrace before running nix exitHandler:
trap 'set +x; exitHandler' EXIT

make -C "$src/depends"

./autogen.sh
CONFIG_SITE="$src/depends/$HOST/share/config.site" ./configure
make
