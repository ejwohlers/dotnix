{ pkgs }:

with pkgs; [
  kubectl
  k9s
  helm
  stern # tail logs with filters
  kubectx
  kind # local clusters (optional)
  skaffold # for rapid local dev (optional)
]
