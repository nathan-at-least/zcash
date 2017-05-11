#!/bin/bash
set -fexuo pipefail

SRCDIR="$(dirname "$(dirname "$(readlink -f "$0")")")"


BUILDMNT="$(mktemp --directory "${TMPDIR:-/tmp}/zcash-tmpfs-build.XXXX")"
function cleanup1 { rm -rf "$BUILDMNT"; }
trap cleanup1 EXIT


sudo mount -t tmpfs -o "size=2g,uid=$UID" tmpfs "$BUILDMNT"
function cleanup2 { cd /; sudo umount "$BUILDMNT"; cleanup1; }
trap cleanup2 EXIT


cp -a "$SRCDIR/*" "$BUILDMNT"
cd "$BUILDMNT"
./zcutil/build.sh "$@"


function cp-back { cp -v "$BUILDMNT/$1" "$SRCDIR/$1"; }
cp-back 'src/bitcoin'
cp-back 'src/zcashd'
cp-back 'src/zcash-cli'
cp-back 'src/zcash-gtest'
cp-back 'src/zcash-tx'
cp-back 'src/test/test_bitcoin'
cp-back 'src/zcash/GenerateParams'
cp-back 'src/zcash/CreateJoinSplit'
