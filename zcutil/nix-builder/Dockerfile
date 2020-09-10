FROM debian:stable@sha256:55dbe60bf1779a4bb168c1b7cd40cac26a6d8ee369425e265fe2f1c8e99b9317

ENV ZC_NIX_BUILDER_BOOTSTRAP '/usr/local/share/zcash-nix-builder/bootstrap'

ENV ZC_NIX_BUILDER_PHASE_0 "${ZC_NIX_BUILDER_BOOTSTRAP}/phase0-user-config.sh"
COPY ./zcutil/nix-builder/bootstrap/phase0-user-config.sh "$ZC_NIX_BUILDER_PHASE_0"
RUN "$ZC_NIX_BUILDER_PHASE_0"

ENV ZC_NIX_BUILDER_PHASE_1 "${ZC_NIX_BUILDER_BOOTSTRAP}/phase1-install-debs.sh"
COPY ./zcutil/nix-builder/bootstrap/phase1-install-debs.sh "$ZC_NIX_BUILDER_PHASE_1"
RUN "$ZC_NIX_BUILDER_PHASE_1"

# Set USER manually; nix requires it & docker doesn't use `login`:
ENV USER nixbuilder
USER $USER
SHELL ["/bin/bash", "-c"]

ENV ZC_NIX_BUILDER_PHASE_2 "${ZC_NIX_BUILDER_BOOTSTRAP}/phase2-install-nix.sh"
COPY ./zcutil/nix-builder/bootstrap/phase2-install-nix.sh "$ZC_NIX_BUILDER_PHASE_2"
RUN "$ZC_NIX_BUILDER_PHASE_2"

ENV BASH_ENV /home/nixbuilder/.nix-profile/etc/profile.d/nix.sh

COPY . /usr/local/src/zcash
RUN nix-build --show-trace '/usr/local/src/zcash/zcutil/nix-builder/nix/zcash-deps.nix'

# TODO: verify the build artifacts are bytewise-reproducible then copy the build artifacts out somehow.
