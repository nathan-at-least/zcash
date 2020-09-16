set -efuo pipefail

source "$stdenv/setup"

mkdir "$out"
for input in $inputs
do
    fname="$(basename "$input" | sed 's/^[^-]*-//')"
    ln -sv "$input" "$out/$fname"
done
