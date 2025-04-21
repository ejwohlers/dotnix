{ config, pkgs, username, homeDirectory, hostname, ... }:

let
  cliK8s = import ../../modules/cli-k8s.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; cliCore ++ uiCore ++ cliK8s ++ [
    # Productivity
    rectangle # window snapping
    alt-tab # alt-tab switcher like on Windows
    stats # menu bar stats app
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
