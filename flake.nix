# flake.nix
{
  description = "💻 Modular dotfiles using flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, nixpkgs, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" "aarch64-darwin" ];

      perSystem = { system, pkgs, config, inputs', ... }:
        let
          vscodeShell = import ./modules/devshells/vscode.nix { inherit pkgs; };
          neovimApp = import ./modules/apps/neovim.nix { inherit pkgs; };
        in
        {
          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [
                pre-commit
                statix
                deadnix
                nixpkgs-fmt
              ];
            };

            inherit (vscodeShell) vscode;
          };

          apps = {
            inherit (neovimApp) neovim;

            fmt = {
              type = "app";
              program = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
              meta.description = "Format Nix files using nixpkgs-fmt";
            };
          };

          formatter = pkgs.nixpkgs-fmt;

          checks = {
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
              runtimeInputs = [ pkgs.pre-commit ];
              text = ''
                pre-commit run --all-files
              '';
            };
          };
        };


      flake = {
        homeConfigurations =
          let
            inherit (builtins) getEnv pathExists;
            username = getEnv "USER";
            homeDirectory = getEnv "HOME";
            hostname = getEnv "HOSTNAME";

            hostModulePath =
              if hostname != "" then ./home/hosts/${hostname}.nix
              else ./home/hosts/default.nix;

            hostModule =
              if pathExists hostModulePath
              then hostModulePath
              else ./home/hosts/default.nix;

          in
          {
            self = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs { system = "x86_64-linux"; }; # optionally make dynamic
              modules = [
                ./home/common.nix
                ./home/pre-commit.nix
                hostModule
              ];
              extraSpecialArgs = { inherit username homeDirectory hostname; };
            };
          };
      };
    };
}
