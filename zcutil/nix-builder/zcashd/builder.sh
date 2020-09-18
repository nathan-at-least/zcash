source "$stdenv/setup"
set -efuo pipefail

# Override tar w/ our hash-bang patcher:
patcherbin="$(pwd)/hashbang-patcher-tar/bin"
mkdir -p "$patcherbin"
install --mode 555 "$hashbangPatcherTar" "$patcherbin/tar"
patchShebangs --build "$patcherbin"
export PATH="$patcherbin:$PATH"
type tar

tar --help
exit 1

set -x
make -C \
    "$src/depends" \
    BASEDIR="$out/depends-output" \
    PATCHES_PATH="$src/depends/patches" \
    SOURCES_PATH="$zcdepsrc"

./autogen.sh
CONFIG_SITE="$src/depends/$HOST/share/config.site" ./configure
make
