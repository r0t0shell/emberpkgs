{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org/" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      systems = flake-utils.lib.defaultSystems;

      packages = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          packageDirs = builtins.attrNames (builtins.readDir ./derivations);
          pkgsFromDirs = builtins.listToAttrs (map (name: {
            inherit name;
            value = pkgs.callPackage (./derivations + "/${name}") { };
          }) packageDirs);
        in pkgsFromDirs // { });

    in { inherit packages; };
}
