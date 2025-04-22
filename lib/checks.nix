# lib/checks.nix
{ inputs, nixpkgs, system, cliCorePkgs }:

let
  pkgs = import nixpkgs { inherit system; };
  lib = pkgs.lib;

  # Shared helper to build a home-manager activationPackage
  mkHome = { modules, extraSpecialArgs }:
    (inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs modules extraSpecialArgs;
    }).activationPackage;
in
{
  flake-check = pkgs.writeShellApplication {
    name = "flake-check";
    runtimeInputs = [ pkgs.nix ];
    text = ''
      nix flake check
    '';
  };

  fmt = pkgs.writeShellApplication {
    name = "fmt-check";
    runtimeInputs = [ pkgs.nixpkgs-fmt ];
    text = ''
      nixpkgs-fmt --check .
    '';
  };

  pre-commit = pkgs.writeShellApplication {
    name = "pre-commit-check";
    runtimeInputs = cliCorePkgs ++ [ pkgs.pre-commit ];
    text = "pre-commit run --all-files";
  };

  deadnix = pkgs.writeShellApplication {
    name = "deadnix-check";
    runtimeInputs = [ pkgs.deadnix ];
    text = "deadnix .";
  };

  home-self = mkHome {
    modules = [
      ../home/common.nix
      ../home/hosts/default.nix
    ];
    extraSpecialArgs = {
      username = "picard";
      homeDirectory = "/home/picard";
      hostname = "surface";
      cliCore = cliCorePkgs;
      uiCore = import ../modules/ui-core.nix { inherit pkgs; };
      cliK8s = import ../modules/cli-k8s.nix { inherit pkgs; };
    };
  };

  home-all = pkgs.runCommand "home-all-check" { } ''
    ${
      mkHome {
        modules = [ ../home/hosts/surfacepro.nix ];
        extraSpecialArgs = {
          username = "picard";
          homeDirectory = "/home/picard";
          hostname = "surface";
          cliCore = cliCorePkgs;
          uiCore = import ../modules/ui-core.nix { inherit pkgs; };
          cliK8s = import ../modules/cli-k8s.nix { inherit pkgs; };
        };
      }
    }

    ${
      if pkgs.stdenv.isDarwin then
        mkHome {
          modules = [ ../home/hosts/macbook.nix ];
          extraSpecialArgs = {
            username = "eduardo_wohlers";
            homeDirectory = "/Users/eduardo_wohlers";
            hostname = "M-L2VXGW93VW";
            cliCore = cliCorePkgs;
            uiCore = import ../modules/ui-core.nix { inherit pkgs; };
            cliK8s = import ../modules/cli-k8s.nix { inherit pkgs; };
          };
        }
      else
        "echo 'Skipping macbook.nix on non-Darwin system'"
    }

    touch $out
  '';
}
