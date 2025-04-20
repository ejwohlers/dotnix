_:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "screen-256color";
    keyMode = "vi";
    extraConfig = ''
      set -g mouse on
      bind r source-file ~/.tmux.conf \; display "Reloaded!"
    '';
  };
}
