{ lib, pkgs, buildGoModule, fetchFromGitHub, go_1_25, ... }:

(buildGoModule.override { go = go_1_25; }) rec {
  name = "AdaptixServer";
  version = "31967d8";

  src = fetchFromGitHub {
    owner = "Adaptix-Framework";
    repo = "AdaptixC2";
    rev = "31967d85dcc181451659fb60a8861d70e61f6a08";
    sha256 = "sha256-YwNFDmStLyU3GLCNVcLk646Pc1gLIpIAsRPckQNyqVc=";
  };

  sourceRoot = "source/AdaptixServer";

  vendorHash = "sha256-cONOdVNkYC0bv8wowuG0SPovf24un/WvhBI47H7rpFI=";
  proxyVendor = true;

  env.GOEXPERIMENT = "jsonv2,greenteagc";

  ldflags = [
    "-s" # strip symbols
    "-w" # strip DWARF
  ];

  nativeBuildInputs = with pkgs; [ gnumake ];

  subPackages = [ "." ];

  postInstall = ''
    cp ssl_gen.sh profile.json 404page.html $out/bin/
  '';

  meta = with lib; {
    description =
      "AdaptixC2 is a Command and Control framework designed for red team operations and adversary simulations.";
    homepage = "";
    license = licenses.free;
    maintainers = [ ];
  };
}
