source "$stdenv/setup"
set -efuo pipefail

mkdir -p "$out/download-stamps"
cd "$out"
for archlinks in $inputs
do
    pkgarchname="$(echo "$archlinks" | sed 's/^[^-]*-//; s/-stamped-archive$//')"
    archname="$(echo "$pkgarchname" | sed 's/^[^-]*-//')"
    stamppath="./download-stamps/.stamp_fetched-${pkgarchname}.hash"
    ln -s "$archlinks/$archname" .
    sha256sum "$archname" > "$stamppath"
    for extra in $(cat "$archlinks/$archname-stamp_extras")
    do
        sha256sum "$extra" >> "$stamppath"
    done
done
