{ config, pkgs, ... }:

{
  programs.gnome.enable = true;

  programs.gnome.extensions = [
    "user-theme@gnome-shell-extensions.gcampax.github.com"
    "dash-to-dock@micxgx.gmail.com"
  ];

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    iconTheme.name = "Papirus";
    font.name = "Fira Sans 11";
  };

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Terminal.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-animations = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-fixed = true;
      click-action = "minimize";
      intellihide = false;
    };
  };

  home.packages = with pkgs; [
    gnome.gnome-tweaks
    gnome.gnome-shell-extensions
    papirus-icon-theme
    fira
  ];
}
