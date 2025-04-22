{ config, pkgs, username, homeDirectory, hostname, ... }:

let
  cliCore = import ../modules/cli-core.nix { inherit pkgs; };
  uiCore = import ../modules/ui-core.nix { inherit pkgs; };
  starship = import ../modules/ui-starship.nix { inherit pkgs; };
  zsh = import ../modules/shell-zsh.nix { inherit pkgs; };
  tmux = import ../modules/terminal-tmux.nix { };
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";

    packages = cliCore ++ uiCore ++ (with pkgs; [
      # Optional: project- or host-specific tools here
      lazygit
      gh
      luarocks
      lua5_1
      gcc
      tree-sitter
      nodejs
    ]);
  };

  programs = {
    home-manager.enable = true;
  };

}
