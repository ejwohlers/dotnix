{ config, pkgs, username, homeDirectory, ... }:

{
  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
  };

  imports = [
    ../gnome.nix
  ];
}
