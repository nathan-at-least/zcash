#!/bin/bash
set -efuxo pipefail

sh <(curl -L 'https://nixos.org/nix/install') \
    --no-daemon \
    --no-channel-add \
    --no-modify-profile
