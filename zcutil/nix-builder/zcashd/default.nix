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

    inherit zcdepsrc;
  }
