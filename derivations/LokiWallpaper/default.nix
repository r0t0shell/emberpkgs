{ stdenv, fetchFromGitHub, go, git, makeWrapper }:

stdenv.mkDerivation rec {
  name = "loki-wallpaper";
  version = "1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/share/loki-wallpaper/
    cp wallpapers/* $out/share/loki-wallpaper/
  '';

  buildPhase = "true";

  meta = with lib; {
    description = "LokiOS wallpaper collection";
    license = "";
  };
}

