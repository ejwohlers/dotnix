# modules/cli-core.nix
{ pkgs }:

with pkgs; [
  bat # better `cat`
  eza # better `ls`
  fd # better `find`
  ripgrep # better `grep`
  zoxide # smarter `cd`
  tldr # friendlier `man`
  jq # JSON parser
  btop # system monitor
  du-dust # better `du`
  procs # better `ps`
  htop # fallback `top`
  git
  unzip
  zip
  wget
  curl
]
