{ stdenv, lib, pkgs, fetchFromGitHub, cmake, qt6, ... }:

stdenv.mkDerivation rec {
  name = "AdaptixClient";
  version = "31967d8";

  src = fetchFromGitHub {
    owner = "Adaptix-Framework";
    repo = "AdaptixC2";
    rev = "31967d85dcc181451659fb60a8861d70e61f6a08";
    sha256 = "sha256-YwNFDmStLyU3GLCNVcLk646Pc1gLIpIAsRPckQNyqVc=";
  };

  nativeBuildInputs = with pkgs; [
    qt6.wrapQtAppsHook
    gnumake
    cmake
  ];

  buildInputs = with qt6; [
    qtbase
    qtdeclarative
    qtwebengine
  ];

  # Disable automatic cmake configuration - the Makefile runs cmake itself
  dontUseCmakeConfigure = true;

  buildPhase = ''
    runHook preBuild
    make client
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp dist/AdaptixClient $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description =
      "AdaptixC2 is a Command and Control framework designed for red team operations and adversary simulations.";
    homepage = "";
    license = licenses.free;
    maintainers = [ ];
  };
}
