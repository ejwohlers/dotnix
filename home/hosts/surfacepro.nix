{ config, pkgs, username, homeDirectory, hostname, ... }:

{
  # Example: host-specific extra packages
  home.packages = with pkgs; [
    # Add Surface-specific tools if needed
  ];

  # You can even use the hostname in logic:
  xdg.userDirs.enable = true;

  # Optional diagnostics/logs
  # home.activation.reportHost = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   echo "🌍 Activating for hostname: ${hostname}"
  # '';
}
