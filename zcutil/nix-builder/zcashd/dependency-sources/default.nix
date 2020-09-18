with (import ./../../pkgs-pinned.nix);
let
  deps = lib.trivial.importJSON ./urls.json;
  forEach = lib.lists.forEach;
in
  stdenv.mkDerivation {
    name = "zcashd-dependency-sources";
    builder = ./symlink-merge-builder.sh;
    inputs = forEach deps ({package, archives}:
      stdenv.mkDerivation {
        name = "${package}-source-archives";
        builder = ./source-archive-builder.sh;
        inputs = forEach archives ({filename ? null, url, sha256, stamp_extras ? []}:
          let
            fname = (
              if filename == null
              then lib.lists.last (lib.splitString "/" url)
              else filename
            );
          in stdenv.mkDerivation {
            name = "${package}-${fname}-stamped-archive";
            builder = ./stamped-archive-builder.sh;
            inputs = [
              (fetchurl {
                inherit url sha256;
                name = "${package}-${fname}";
              })
            ] ++ (
                if stamp_extras == null
                then [] # specific case for native_cctools
                else [
                  (writeTextFile {
                    name = "${package}-${fname}-stamp_extras";
                    text = stamp_extras;
                  })
                ]
            );
          }
        );
      }
    );
  }
