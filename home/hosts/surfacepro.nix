{ config, pkgs, username, homeDirectory, hostname, ... }:

let
  cliK8s = import ../../modules/cli-k8s.nix { inherit pkgs; };
in

{

  imports = [ ./gnome.nix ];

  home.packages = with pkgs; cliCore ++ uiCore ++ cliK8s;

  # You can even use the hostname in logic:
  xdg.userDirs.enable = true;

  # Optional diagnostics/logs
  # home.activation.reportHost = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   echo "🌍 Activating for hostname: ${hostname}"
  # '';
}
