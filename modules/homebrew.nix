# modules/homebrew.nix
{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    taps = [ "homebrew/cask" ];
    brews = [ "fzf" ];

    casks = [
      "rectangle"
      "alt-tab"
      "stats"
      "monitorcontrol"
      "raycast"
    ];

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
  };
}
