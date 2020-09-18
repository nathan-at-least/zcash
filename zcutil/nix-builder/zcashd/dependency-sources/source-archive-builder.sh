source "$stdenv/setup"
set -efuo pipefail

mkdir -p "$out/download-stamps"
cd "$out"

function for-each-input
{
    for archlinks in $inputs
    do
        pkgarchname="$(echo "$archlinks" | sed 's/^[^-]*-//; s/-stamped-archive$//')"
        archname="$(echo "$pkgarchname" | sed 's/^[^-]*-//')"

        eval "$1" "$archlinks" "$archname" "$pkgarchname"
    done
}

function link-archive
{
    local archlinks="$1"
    local archname="$2"
    ln -s "$archlinks/$archname" .
}

function write-archive-stamps
{
    local archlinks="$1"
    local archname="$2"
    local pkgarchname="$3"

    local stampextras="$archlinks/$archname-stamp_extras"
    if [ -f "$stampextras" ]
    then
        local stamppath="./download-stamps/.stamp_fetched-${pkgarchname}.hash"
        sha256sum "$archname" > "$stamppath"
        for extra in $(cat "$stampextras")
        do
            sha256sum "$extra" >> "$stamppath"
        done
    fi
}

for-each-input link-archive
for-each-input write-archive-stamps
