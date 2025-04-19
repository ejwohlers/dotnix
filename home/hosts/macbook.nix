{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # Productivity
    rectangle     # window snapping
    alt-tab       # alt-tab switcher like on Windows
    stats         # menu bar stats app
    monitorcontrol # control external display brightness

    # Dev
    iterm2
    visual-studio-code
    raycast
    docker

    # CLI extras
    neofetch
    htop
  ];

  # 🧠 Add Mac-specific config if needed
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Example: add login shell override
  programs.zsh.enable = true;
}
