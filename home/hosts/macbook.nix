{ pkgs, ... }: {
  home.packages = with pkgs; [
    rectangle
    alt-tab
    # add Mac-specific tools
  ];
}