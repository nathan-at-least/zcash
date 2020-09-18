source "$stdenv/setup"
set -efuo pipefail

mkdir "$out"
cd "$out"
for input in $inputs
do
    pkgfname="$(echo "$input" | sed 's/^[^-]*-//')"
    fname="$(echo "$pkgfname" | sed 's/^[^-]*-//')"
    ln -s "$input" "$fname"
done
