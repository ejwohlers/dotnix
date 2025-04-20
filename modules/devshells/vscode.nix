{ pkgs, ... }: {
  vscode = pkgs.mkShell {
    name = "vscode-shell";
    packages = with pkgs; [
      nodejs
      git
      pre-commit
      nodePackages.prettier
    ];
    shellHook = ''
      echo "🚀 VS Code dev shell loaded"
    '';
  };
}
