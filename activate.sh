#!/usr/bin/env bash
set -euo pipefail

echo "🌍 Detecting system..."
SYSTEM=$(nix eval --impure --expr 'builtins.currentSystem' --raw 2>/dev/null || echo "x86_64-linux")

if [ -z "$SYSTEM" ]; then
  echo "❌ Could not detect system type. Bailing out."
  exit 1
fi

echo "💻 Detected system: $SYSTEM"
echo "🚀 Activating home configuration..."

nix run .#homeConfigurations.self.activationPackage \
  --impure \
  --system "$SYSTEM" \
  --no-write-lock-file
