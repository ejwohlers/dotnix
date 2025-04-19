{
  description = "Smart auto-detecting dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      mkHome = import ./lib/mkHome.nix { inherit nixpkgs home-manager; };

      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
      system = builtins.currentSystem;

      # 🔍 Detect hostname and try to load a host config file
      hostname = builtins.getEnv "HOSTNAME";
      hostModulePath =
        if hostname != ""
        then ./home/hosts/${hostname}.nix
        else ./home/hosts/default.nix;

      # 💥 fallback in case the file doesn't exist
      hostModule =
        if builtins.pathExists hostModulePath
        then hostModulePath
        else ./home/hosts/default.nix;

    in {
      homeConfigurations = {
        self = mkHome {
          inherit username homeDirectory system;

          modules = [
            ./home/common.nix
            hostModule
          ];
        };
      };
    };
}
