# modules/macos.nix
{ config, pkgs, ... }:

{
  # 🧠 macOS system preferences
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.swipescrolldirection" = false;
    };

    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 36;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
  };

  # 🧹 Optional cleanup tools
  system.activationScripts.postActivation.text = ''
    echo "🧹 macOS tweaks applied. Some may require logout/login."
  '';
}
