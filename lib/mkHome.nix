{ nixpkgs, home-manager }:

{ system, username, homeDirectory, modules ? [] }:

home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs { inherit system; };
  inherit username homeDirectory;
  modules = modules;
}