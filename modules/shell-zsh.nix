{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lah";
      ls = "eza --icons";
      tree = "eza --tree --level=2";
      gs = "git status";
      v = "nvim";
      cat = "bat";
      grep = "rg";
      cd = "z";
      top = "btop";
    };

    initExtra = ''
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi

      eval "$(starship init zsh)"
      eval "$(zoxide init zsh)"
      neofetch
    '';
  };
}
