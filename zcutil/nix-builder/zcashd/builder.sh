set -efuo pipefail

source "$stdenv/setup"
trap 'set +x; exitHandler' EXIT
set -x

make -C \
    "$src/depends" \
    BASEDIR="$out/depends-output" \
    PATCHES_PATH="$src/depends/patches" \
    SOURCES_PATH="$zcdepsrc"

./autogen.sh
CONFIG_SITE="$src/depends/$HOST/share/config.site" ./configure
make
