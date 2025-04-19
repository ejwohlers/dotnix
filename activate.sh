#!/usr/bin/env bash
set -euo pipefail

echo "🌍 Detecting system..."

SYSTEM=$(nix eval --impure --expr builtins.currentSystem --raw)

echo "💻 Current system: $SYSTEM"
echo "🚀 Activating home configuration..."

nix run .#homeConfigurations.self.activationPackage --system "$SYSTEM"
