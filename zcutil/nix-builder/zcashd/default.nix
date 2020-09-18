let
  pkgs = import ./../pkgs-pinned.nix;
  zcdepsrc = import ./dependency-sources;
in
  with pkgs;
  stdenv.mkDerivation {
    pname = "zcashd";
    version = "FIXME";

    src = ./../../..;
    builder = ./builder.sh;
    hashbangPatcherTar = ./hashbang-patcher-tar.sh;

    buildInputs = [
        # These are required at least by openssl:
        perl
        coreutils
    ];

    inherit zcdepsrc;
  }
