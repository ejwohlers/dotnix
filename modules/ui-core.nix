# modules/ui-core.nix
{ pkgs }:

with pkgs; [
  kitty # terminal
  neofetch # fetch + aesthetic system info
  figlet # ASCII banners
  lolcat # rainbow output
  xclip # X11 clipboard
  wl-clipboard # Wayland clipboard
  fontconfig # font support
  noto-fonts-color-emoji # emoji fallback
  nerd-fonts.fira-code
  nerd-fonts.jetbrains-mono
]
