#!/usr/bin/env bash
# A wrapper script to handle system updates safely across platforms

set -e

# Detect operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "Detected macOS system, running darwin-rebuild..."
    nix run github:lnl7/nix-darwin -- switch --impure --flake ~/.dotfiles
else
    # Linux or other systems
    echo "Detected non-macOS system, running home-manager switch..."
    home-manager switch --flake ~/.dotfiles
fi

echo "System configuration updated successfully!"