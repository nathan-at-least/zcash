#!/bin/bash
source "$stdenv/setup"
set -efuxo pipefail
SELF="$(readlink -f "$0")"

for d in $(echo "$PATH" | tr ':' ' ')
do
    candidate="$d/tar"
    if [ -x "$candidate" ] && ! [ "$(readlink -f "$candidate")" = "$SELF" ]
    then
        REALTAR="$candidate"
    fi
done

eval "$REALTAR" "$@"

# Now patch hashbangs from the tarball:
for d in $(find . -type d)
do
    patchShebangs --build "$d"
done
