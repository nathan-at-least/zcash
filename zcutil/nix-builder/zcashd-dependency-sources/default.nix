with (import ./../pkgs-pinned.nix);
let
  deps = lib.trivial.importJSON ./urls.json;
  fetchdep = {package, version, filename, url, sha256}: fetchurl {
    inherit url sha256;
    name = "${package}-${filename}";
  };
in
  stdenv.mkDerivation {
    name = "zcashd-dependency-sources";
    inputs = (map fetchdep deps);
    builder = ./builder.sh;
  }
