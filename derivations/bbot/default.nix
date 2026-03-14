{
  lib,
  pkgs,
  uv2nix,
  pyproject-nix,
  pyproject-build-systems,
}:

let
  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

  overlay = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel";
  };

  python = pkgs.python312;

  baseSet = pkgs.callPackage pyproject-nix.build.packages {
    inherit python;
  };

  # Override to provide build systems for packages built from source
  pyprojectOverrides = final: prev: {
    bbot = prev.bbot.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ])
        ++ final.resolveBuildSystem { hatchling = [ ]; };
    });

    antlr4-python3-runtime = prev.antlr4-python3-runtime.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ])
        ++ final.resolveBuildSystem { setuptools = [ ]; };
    });

    wordninja = prev.wordninja.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ])
        ++ final.resolveBuildSystem { setuptools = [ ]; };
    });
  };

  pythonSet = baseSet.overrideScope (
    lib.composeManyExtensions [
      pyproject-build-systems.overlays.wheel
      overlay
      pyprojectOverrides
    ]
  );

  inherit (pkgs.callPackages pyproject-nix.build.util { }) mkApplication;

  venv = pythonSet.mkVirtualEnv "bbot-env" workspace.deps.default;

in
mkApplication {
  inherit venv;
  package = pythonSet.bbot;
}
