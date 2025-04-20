# 🧙‍♂️ My Modular Nix Flake Setup

Welcome to my personal **dotfiles, dev environments, and system config** — powered entirely by [Nix](https://nixos.org/) and [flake-parts](https://github.com/hercules-ci/flake-parts). This setup is 🔥 reproducible, portable, and *a little bit magical*.

## ✨ Features

- 💻 `home-manager` + `flake-parts` + `nixpkgs`
- 🧱 Modular layout: shared config + per-host overrides
- ✅ Pre-commit hooks with `nixpkgs-fmt`, `statix`, `deadnix`
- 🔁 GitHub CI for `flake check` + formatting
- 🧪 Dev shells: VSCode, Neovim, CLI power tools
- 💅 Zsh + Starship setup
- 🍏 macOS-ready with `nix-darwin` (optional)
- 📦 Flake apps: `nix run .#neovim`, `nix develop .#vscode`, and more

## 🧭 Getting Started

```bash
git clone https://github.com/yourname/nix-config ~/.dotfiles
cd ~/.dotfiles

# Activate for this system
./activate.sh

# Or run specific shells/apps:
nix develop .#vscode
nix run .#neovim

## 📁 Structure
.
├── flake.nix              # The entry point
├── home/
│   ├── common.nix         # Shared Home Manager config
│   ├── pre-commit.nix     # Pre-commit tools
│   └── hosts/             # Per-host overrides
├── modules/
│   ├── devshells/         # Shell configs (e.g., vscode)
│   └── apps/              # Flake apps (e.g., neovim)
└── .github/workflows/     # CI checks


## 🤝 Credits & Inspirations
@ryantm — agenix
@mic92 — sops-nix
@zhaofengli — flake layouts
Nix community 💚


"Once you understand flakes, there’s no going back." — a wise Nix wizard

🧙‍♂️ License
MIT — use it, fork it, vibe with it.