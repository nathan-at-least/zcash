FROM nixos/nix@sha256:2da921898aa6c89e2e60b1fb72d74525b8464b47412482c7f1cf77b8e707a099

ENV ZCASH_CHANNEL_REVISION="b58ada326aa612ea1e2fb9a53d550999e94f1985" \
    ZCASH_SRC="/usr/local/src/zcash" \
    ZCASH_NIX_BUILDER="${ZCASH_SRC}/zcutil/nix-builder" \
    ZCASH_NIX_EXPRS="${ZCASH_NIX_BUILDER}/nix"

COPY ./zcutil/nix-builder/nix "$ZCASH_NIX_EXPRS"
RUN nix-build --show-trace "${ZCASH_NIX_EXPRS}/zcash-deps.nix"

# Next step: copy the build artifacts out somehow.
