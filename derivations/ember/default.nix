{ lib, stdenv, ... }:
stdenv.mkDerivation {
  pname = "ember";
  version = "1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    echo -e "#!/bin/sh\necho Ember $version" > $out/bin/$pname
    chmod +x $out/bin/$pname
  '';

  meta = with lib; {
    description = "";
    license = lib.licenses.free;
  };
}
