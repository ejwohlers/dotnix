{ config, pkgs, username, homeDirectory, hostname, ... }:
{
  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    # ───── Nerd Fonts ─────
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

    # ───── Terminals & Shell Tools ─────
    kitty
    zsh
    starship
    tmux

    # ───── Editor & File Manager ─────
    neovim
    yazi

    # ───── CLI Core Replacements ─────
    bat # better 'cat'
    eza # better 'ls'
    fd # better 'find'
    ripgrep # better 'grep'
    fzf # fuzzy finder
    zoxide # smarter 'cd'
    tldr # man pages, but friendlier
    jq # JSON parser
    btop # modern system monitor
    du-dust # better 'du'
    procs # better 'ps'
    htop # better 'top'

    # ───── Dev Tools ─────
    git
    lazygit
    gh
    unzip
    zip
    wget
    curl
    pre-commit
    nixpkgs-fmt
    deadnix
    statix

    # ───── Eye Candy ─────
    lolcat
    figlet
    neofetch

    # ───── Neovim Health Fixes ─────
    lua5_1
    luarocks
    gcc
    tree-sitter
    nodejs

    # ───── Clipboard Support ─────
    wl-clipboard # for Wayland
    xclip # fallback for X11

  ];

  programs = {

    home-manager.enable = true;

    #zsh config
    zsh = {
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
        # Load nix profile manually in Zsh
        if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
          . "$HOME/.nix-profile/etc/profile.d/nix.sh"
        fi

        eval "$(starship init zsh)"
        eval "$(zoxide init zsh)"
        neofetch
      '';
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        format = "$directory$git_branch$git_status";

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };

        directory.style = "bold blue";

        git_branch = {
          symbol = "🌱 ";
          format = "[$symbol$branch]($style) ";
        };

        git_status.style = "yellow";
      };
    };


    # tmux config
    tmux = {
      enable = true;
      clock24 = true;
      terminal = "screen-256color";
      keyMode = "vi";
      extraConfig = ''
        set -g mouse on
        bind r source-file ~/.tmux.conf \; display "Reloaded!"
      '';
    };

  };

}
