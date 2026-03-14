{ stdenv, lib, ... }:

stdenv.mkDerivation rec {
  name = "athena-art";
  version = "1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/wallpaper/
    cp wallpapers/* $out/wallpaper/
  '';

  buildPhase = "true";

  meta = with lib; {
    description = "Athena system art collection";
    license = lib.licenses.free;
  };
}

