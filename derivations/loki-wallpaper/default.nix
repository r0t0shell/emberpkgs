{ stdenv, lib }:

stdenv.mkDerivation rec {
  name = "loki-wallpaper";
  version = "1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/wallpaper/
    cp wallpapers/* $out/wallpaper/
  '';

  buildPhase = "true";

  meta = with lib; {
    description = "LokiOS wallpaper collection";
    license = lib.licenses.free;
  };
}

