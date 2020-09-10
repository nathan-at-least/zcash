#!/bin/bash
set -efuxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y \
    curl \
    xz-utils
