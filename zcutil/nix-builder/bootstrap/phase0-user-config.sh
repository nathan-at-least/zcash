#!/bin/bash
set -efuxo pipefail

adduser \
    --gecos '' \
    --disabled-password \
    --no-create-home \
    nixbuilder

adduser --group nixbld
adduser nixbuilder nixbld

install --directory --owner nixbuilder --group nixbld --mode 0755 /home/nixbuilder
install --directory --owner nixbuilder --group nixbld --mode 0755 /nix
