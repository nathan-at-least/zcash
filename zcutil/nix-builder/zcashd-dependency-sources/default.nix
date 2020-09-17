with (import ./../pkgs-pinned.nix);
let
  deps = lib.trivial.importJSON ./urls.json;
  fetchdep = {package, sha256, url, version}: fetchurl {
    inherit url sha256;
    name =
      let
        components = lib.strings.splitString "/" url;
        filename = lib.last components;
      in "${package}-${filename}";
  };
in
  stdenv.mkDerivation {
    name = "zcashd-dependency-sources";
    inputs = (map fetchdep deps);
    builder = ./builder.sh;
  }
