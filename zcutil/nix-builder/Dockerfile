FROM nixos/nix@sha256:2da921898aa6c89e2e60b1fb72d74525b8464b47412482c7f1cf77b8e707a099

COPY . /usr/src/zcash
RUN nix-build /usr/src/zcash/docker-build/zcashd.nix

# Next step: copy the build artifacts out somehow.
