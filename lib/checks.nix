# lib/checks.nix
{ inputs, nixpkgs, system, cliCorePkgs }:

let
  pkgs = import nixpkgs { inherit system; };
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

  home-self = (
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ../home/common.nix
        ../home/hosts/default.nix
      ];

      extraSpecialArgs = {
        username = "nixos";
        homeDirectory = "/home/nixos";
        hostname = "default";
      };
    }
  ).activationPackage;

}
