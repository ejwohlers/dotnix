{ config, pkgs, username, homeDirectory, hostname, cliCore, uiCore, cliK8s, ... }:

let
  lib = pkgs.lib;
  cliK8s = import ../../modules/cli-k8s.nix { inherit pkgs; };

  macApps = lib.optionals pkgs.stdenv.isDarwin [
    pkgs.iterm2
    pkgs.vscode
    pkgs.docker
  ];

  cliExtras = [
    pkgs.neofetch
    pkgs.htop
  ];
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.zsh.enable = true;
}
