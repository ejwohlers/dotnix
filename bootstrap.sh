#!/usr/bin/env bash
set -euo pipefail

echo "🧪 Welcome to the dotfiles bootstrap wizard"
echo "🌍 Hostname: $(hostname)"
echo "👤 User: $USER"
echo "🏠 Home: $HOME"
SYSTEM=$(nix eval --impure --expr builtins.currentSystem --raw)
HOSTNAME=$(hostname)

echo "🧬 System: $SYSTEM"

# 1. Install Nix if missing
if ! command -v nix >/dev/null 2>&1; then
  echo "💡 Nix not found. Installing..."
  curl -L https://nixos.org/nix/install | sh
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
else
  echo "✅ Nix already installed"
fi

# 2. Enable flakes & nix-command in Nix config (only if not already set)
mkdir -p ~/.config/nix
if ! grep -q 'experimental-features' ~/.config/nix/nix.conf 2>/dev/null; then
  echo "✨ Enabling flakes and nix-command"
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
else
  echo "✅ Flakes already enabled"
fi

# 3. Clone the repo if missing
if [ ! -d "$HOME/.dotfiles/.git" ]; then
  echo "📦 Cloning dotfiles repo..."
  git clone https://github.com/yourname/dotnix ~/.dotfiles
else
  echo "✅ Dotfiles repo already cloned"
fi

cd ~/.dotfiles

# 4. Apply system config
if [[ "$OSTYPE" == "darwin"* ]]; then
  if nix eval --impure .#darwinConfigurations.${HOSTNAME}.system &>/dev/null; then
    echo "🍏 Detected macOS — running darwin-rebuild"
    nix run github:lnl7/nix-darwin -- switch --impure --flake ".#${HOSTNAME}"
  else
    echo "⚠️ No matching darwinConfigurations for this Mac (${HOSTNAME})"
    exit 1
  fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "🐧 Detected Linux — running home-manager"
  nix run .#homeConfigurations.self.activationPackage \
    --no-write-lock-file \
    --impure \
    --system "$SYSTEM"
else
  echo "⚠️ Unsupported system: $OSTYPE"
  exit 1
fi

# 5. Final activation (only if script exists)
if [ -x ./activate.sh ]; then
  echo "🚀 Finalizing with activate.sh..."
  ./activate.sh
else
  echo "⚠️ No activate.sh found — skipping final activation."
fi

echo "✅ All done! Your system is now configured 🎉"
