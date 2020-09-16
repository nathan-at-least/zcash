let
  pkgs = import ./pkgs-pinned.nix;
  zcdepsrc = import ./zcashd-dependency-sources.nix;
in
  with pkgs;
  stdenv.mkDerivation {
    pname = "zcashd";
    version = "FIXME";

    src = ./../../..;
    builder = ./builder.sh;

    buildInputs = [
      zcdepsrc
    ];
  }
