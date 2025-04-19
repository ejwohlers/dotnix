#!/usr/bin/env bash
set -euo pipefail

echo "🌍 Detecting system..."

# Safe fallback detection
SYSTEM=${SYSTEM:-$(nix eval --impure --expr builtins.currentSystem --raw || echo "x86_64-linux")}

if [ -z "$SYSTEM" ]; then
  echo "❌ Could not detect system. Falling back to x86_64-linux"
  SYSTEM="x86_64-linux"
fi

echo "💻 Current system: $SYSTEM"
echo "🚀 Activating home configuration..."

nix run .#homeConfigurations.self.activationPackage \
  --impure \
  --system "$SYSTEM"
