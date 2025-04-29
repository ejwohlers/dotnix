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

      darwinHost =
        let
          fallback = "macbook";
          hostnameFile = "/etc/hostname";
        in
        if getEnv "HOSTNAME" != "" then getEnv "HOSTNAME"
        else if pathExists hostnameFile then
          builtins.readFile hostnameFile
        else
          fallback;

      darwinPkgs = import nixpkgs { system = darwinSystem; };

      # Create the darwin configuration for the host
      mkDarwinConfig = hostName: darwin.lib.darwinSystem {
        system = darwinSystem;
        modules = [
          ./modules/homebrew.nix
          ./modules/macos.nix
          home-manager.darwinModules.home-manager

          {
            nixpkgs.hostPlatform = darwinSystem;

            users.users.${darwinUser} = {
              home = "/Users/${darwinUser}";
              shell = darwinPkgs.zsh;
            };

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = {
                username = darwinUser;
                homeDirectory = "/Users/${darwinUser}";
                hostname = hostName;

                cliCore = import ./modules/cli-core.nix { pkgs = darwinPkgs; };
                uiCore = import ./modules/ui-core.nix { pkgs = darwinPkgs; };
                cliK8s = import ./modules/cli-k8s.nix { pkgs = darwinPkgs; };
              };

              users.${darwinUser} = {
                imports = [
                  ./home/common.nix
                  (
                    let
                      hostModulePath = ./home/hosts/${hostName}.nix;
                    in
                    if pathExists hostModulePath then hostModulePath else ./home/hosts/default.nix
                  )
                ];
              };
            };
          }
        ];
      };

    in
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ linuxSystem darwinSystem ];

      perSystem = { system, pkgs, config, inputs', ... }: {
        devShells.default = pkgs.mkShell {
          packages = (import ./modules/cli-core.nix { inherit pkgs; }) ++ [
            pkgs.pre-commit
            pkgs.statix
            pkgs.deadnix
            pkgs.nixpkgs-fmt
          ];
        };

        devShells.vscode = (import ./modules/devshells/vscode.nix { inherit pkgs; }).vscode;

        apps = {
          inherit ((import ./modules/apps/neovim.nix { inherit pkgs; })) neovim;

          fmt = {
            type = "app";
            program = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
            meta.description = "Format Nix files using nixpkgs-fmt";
          };
        };

        formatter = pkgs.nixpkgs-fmt;
      };

      # Put specialized outputs in the flake attribute
      flake = {
        # Darwin configurations
        darwinConfigurations.${darwinHost} = mkDarwinConfig darwinHost;

        # Home manager configurations
        homeConfigurations.self = home-manager.lib.homeManagerConfiguration {
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
    };
}
