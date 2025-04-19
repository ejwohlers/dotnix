{
  description = "✨ Auto-detecting, cross-platform Home Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = builtins.currentSystem;

      # 🧙 Helper function to build a clean Home Manager config
      mkHome = import ./lib/mkHome.nix {
        inherit nixpkgs home-manager;
      };

      # 🌍 Auto-detect user + home
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";

      # 💻 Detect host by HOSTNAME env var
      hostname = builtins.getEnv "HOSTNAME";

      # 📦 Try loading host-specific config, fallback to default
      hostModulePath =
        if hostname != ""
        then ./home/hosts/${hostname}.nix
        else ./home/hosts/default.nix;

      hostModule =
        if builtins.pathExists hostModulePath
        then hostModulePath
        else ./home/hosts/default.nix;

    in {
      
      homeConfigurations = {
        # 🧠 Universal, self-replicating config
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
