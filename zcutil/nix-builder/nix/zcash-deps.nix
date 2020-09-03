{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/b58ada326aa612ea1e2fb9a53d550999e94f1985.tar.gz") {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "zcashd";
  version = "FIXME";

  # rev = "cbe903e7f8839794fbe572ea4c811e2c802a4038";
  src = "../" ;

  buildInputs = [
    pkgs.boost
  ];

  configurePhase = ''
    env
    ./configure
  '';

  buildPhase = ''
    env
    make
  '';

  #installPhase = ''
  #  mkdir -p $out/bin
  #  mv chord $out/bin
  #'';
}
