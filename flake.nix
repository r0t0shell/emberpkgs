{
  description = "A Nix flake of offensive security utilities, ready for use in red team operations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      packageFiles = lib.filter (
        path: lib.hasSuffix ".nix" (toString path)
      ) (lib.filesystem.listFilesRecursive ./packages);

      packageName = path: lib.removeSuffix ".nix" (baseNameOf path);
      packageNames = map packageName packageFiles;

      packageDefinitions =
        assert lib.length packageNames == lib.length (lib.unique packageNames);
        builtins.listToAttrs (
          map (path: {
            name = packageName path;
            value = path;
          }) packageFiles
        );

      overlay = final: _previous:
        lib.mapAttrs (_name: path: final.callPackage path { }) packageDefinitions;

      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      overlays.default = overlay;

      packages = lib.genAttrs supportedSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in
        lib.getAttrs packageNames pkgs
      );
    };
}
