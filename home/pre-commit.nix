{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    pre-commit
    nixpkgs-fmt
    statix
    deadnix
  ];

  home.sessionVariables = {
    PRE_COMMIT_HOME = "${config.xdg.cacheHome}/pre-commit";
  };
}
