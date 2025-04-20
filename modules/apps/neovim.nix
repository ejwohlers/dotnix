{ pkgs, ... }: {
  neovim = {
    type = "app";
    program = "${pkgs.neovim}/bin/nvim";
    meta.description = "Run Neovim directly from flake";
  };
}
