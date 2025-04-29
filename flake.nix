{
  description = "💻 Modular dotfiles using flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-parts.url = "github:hercules-ci/flake-parts";
    darwin.url = "github:lnl7/nix-darwin";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    statix.url = "github:nerdypepper/statix";
    deadnix.url = "github:astro/deadnix";
    nixpkgs-fmt.url = "github:nix-community/nixpkgs-fmt";
  };

  outputs = inputs@{ flake-parts, nixpkgs, home-manager, statix, deadnix, nixpkgs-fmt, darwin, ... }:
    let
      inherit (builtins) getEnv pathExists;

      # Linux
      linuxSystem = "x86_64-linux";
      linuxUser = if getEnv "USER" != "" then getEnv "USER" else "picard";
      linuxHome = if getEnv "HOME" != "" then getEnv "HOME" else "/home/picard";
      linuxHost = if getEnv "HOSTNAME" != "" then getEnv "HOSTNAME" else "surface";

      # macOS
      darwinSystem = "aarch64-darwin";
      darwinUser = if getEnv "USER" != "" then getEnv "USER" else "eduardo_wohlers";
      darwinHost = if getEnv "HOSTNAME" != "" then getEnv "HOSTNAME" else "macbook";
      darwinPkgs = import nixpkgs { system = darwinSystem; };



    in

    flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      {

        systems = [ linuxSystem darwinSystem ];

        perSystem = { system, pkgs, config, inputs', ... }:
          let

            vscodeShell = import ./modules/devshells/vscode.nix { inherit pkgs; };
            neovimApp = import ./modules/apps/neovim.nix { inherit pkgs; };
            cliCorePkgs = import ./modules/cli-core.nix { inherit pkgs; };
          in
          {

            devShells.default = pkgs.mkShell {
              packages = cliCorePkgs ++ [
                pkgs.pre-commit
                pkgs.statix
                pkgs.deadnix
                pkgs.nixpkgs-fmt
              ];
            };

            devShells.vscode = vscodeShell.vscode;

            apps = {
              inherit (neovimApp) neovim;

              fmt = {
                type = "app";
                program = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
                meta.description = "Format Nix files using nixpkgs-fmt";
              };
            };

            formatter = pkgs.nixpkgs-fmt;
          };

        flake = {
          homeConfigurations = {
            self = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs { system = linuxSystem; };
              modules = [
                ./home/common.nix
                ./home/pre-commit.nix
                (
                  let
                    hostModulePath = ./home/hosts/${linuxHost}.nix;
                  in
                  if pathExists hostModulePath then hostModulePath else ./home/hosts/default.nix
                )
              ];
              extraSpecialArgs = {
                username = linuxUser;
                homeDirectory = linuxHome;
                hostname = linuxHost;
              };
            };
          };

          darwinConfigurations.${darwinHost} = darwin.lib.darwinSystem {
            system = darwinSystem;
            modules = [
              ./home/common.nix
              ./home/hosts/macbook.nix
              ./modules/homebrew.nix
              ./modules/macos.nix
              home-manager.darwinModules.home-manager

              {
                nixpkgs.hostPlatform = darwinSystem;

                users.users.${darwinUser} = {
                  home = "/Users/${darwinUser}";
                  shell = darwinPkgs.zsh;
                };

                home-manager.extraSpecialArgs = {
                  useGlobalPkgs = true;
                  useUserPackages = true;

                  username = darwinUser;
                  homeDirectory = "/Users/${darwinUser}";
                  hostname = darwinHost;

                  cliCore = import ./modules/cli-core.nix { pkgs = darwinPkgs; };
                  uiCore = import ./modules/ui-core.nix { pkgs = darwinPkgs; };
                  cliK8s = import ./modules/cli-k8s.nix { pkgs = darwinPkgs; };
                };
              }
            ];
          };
        };
      };
}
