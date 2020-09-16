let
  pkgs = import ./../pkgs-pinned.nix;
  deps = pkgs.lib.trivial.importJSON ./urls.json;
  fetchdep = dep: pkgs.fetchurl { inherit (dep) url sha256; };
in
  pkgs.stdenv.mkDerivation {
    name = "zcashd-dependency-sources";
    inputs = (map fetchdep deps);
    builder = ./builder.sh;
  }
