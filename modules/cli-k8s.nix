{ pkgs }:

with pkgs; [
  kubectl
  k9s
  helm
  stern # tail logs with filters
  kubectx
  kubens
  kind # local clusters (optional)
  skaffold # for rapid local dev (optional)
]
