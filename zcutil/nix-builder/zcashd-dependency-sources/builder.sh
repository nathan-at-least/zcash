set -efuo pipefail

source "$stdenv/setup"
# trap 'set +x; exitHandler' EXIT; set -x

mkdir -p "$out/download-stamps"
cd "$out"
for input in $inputs
do
    # fullname contains package and tarball name:
    fullname="$(basename "$input" | sed 's/^[^-]*-//')"
    # tarball name only:
    tarname="$(echo "$fullname" | sed 's/^[^-]*-//')"
    ln -s "$input" "$tarname"
    sha256sum "$tarname" > "./download-stamps/.stamp_fetched-${fullname}.hash"
done
