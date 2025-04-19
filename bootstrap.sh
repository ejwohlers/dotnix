#!/usr/bin/env bash

set -euo pipefail

echo "🧪 Welcome to the dotfiles bootstrap wizard"
echo "🌍 Hostname: $(hostname)"
echo "👤 User: $USER"
echo "🏠 Home: $HOME"

# 1. Install Nix if it's not already installed
if ! command -v nix >/dev/null 2>&1; then
  echo "💡 Nix not found. Installing..."
  curl -L https://nixos.org/nix/install | sh
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
else
  echo "✅ Nix already installed"
fi

# 2. Enable flakes & nix-command in Nix config
mkdir -p ~/.config/nix
if ! grep -q 'experimental-features' ~/.config/nix/nix.conf 2>/dev/null; then
  echo "✨ Enabling flakes and nix-command"
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# 3. Clone the repo if not already cloned
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "📦 Cloning dotfiles repo..."
  git clone https://github.com/ejwohlers/dotfiles.git ~/.dotfiles
fi

cd ~/.dotfiles

# 4. Run Home Manager via flake
echo "🚀 Activating home configuration..."
nix run .#homeConfigurations.self.activationPackage

echo "✅ All done! Your system is now configured 🎉"
