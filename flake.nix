{
  description = "Reusable Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations = {
      picard = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        modules = [
          ./home/common.nix
          ./home/hosts/surfacepro.nix
        ];

        # Name + Home folder
        home.username = "picard";
        home.homeDirectory = "/home/picard";
      };
    };
  };
}

