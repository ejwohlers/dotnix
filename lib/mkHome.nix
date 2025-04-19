{ nixpkgs, home-manager }:

{ system, modules ? [] }:

home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs { inherit system; };
  modules = modules;
}
