{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/b58ada326aa612ea1e2fb9a53d550999e94f1985.tar.gz") {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "zcashd-deps";
  version = "FIXME";

  src = ./.;
  builder = ./zcash-deps-builder.sh;
}
