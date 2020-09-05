#!/bin/bash
set -efuxo pipefail

cd "$(dirname "$(readlink -f "$0")")/../.."
exec docker build -t zcash-nix-builder -f ./zcutil/nix-builder/Dockerfile .
