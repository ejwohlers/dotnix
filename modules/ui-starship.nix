{ pkgs, ... }:

{
  programs.starship = {
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
}
