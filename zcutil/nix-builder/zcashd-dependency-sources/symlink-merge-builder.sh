source "$stdenv/setup"
set -efuo pipefail

mkdir "$out"
for input in $inputs
do
    for relpath in $(cd "$input"; find . -type f -o -type l)
    do
        src="$input/$relpath"
        dst="$out/$relpath" 
        mkdir -p "$(dirname "$dst")" || true
        ln -s "$src" "$dst"
    done
done
