{ home-manager, nixpkgs }:

{ system, username, homeDirectory, modules ? [] }:
  
  home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs { inherit system; };
    inherit homeDirectory;
    inherit username;
    modules = [
      ../home/common.nix
    ] ++ modules;
  }
