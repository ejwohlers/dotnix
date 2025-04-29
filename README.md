# ✨ dotnix — My Modular Nix Dotfiles

Welcome to dotnix, my personal Nix-powered setup for dotfiles, dev environments, system configuration, and terminal aesthetic goodness.

It’s clean. It’s reproducible. And it vibes hard. 💻💚
Powered entirely by Nix and flake-parts, this setup is 🔥 reproducible, portable, and a little bit magical.

## ✨ Features
- 💻 home-manager + flake-parts + nixpkgs

- 🧱 Modular layout: shared config + per-host overrides

- ✅ Pre-commit hooks with nixpkgs-fmt, statix, deadnix

- 🔁 GitHub CI for flake check + formatting

- 🧪 Dev shells: VSCode, Neovim, CLI power tools

- 💅 Zsh + Starship setup

- 🍏 macOS-ready with nix-darwin

- 📦 Flake apps: nix run .#neovim, nix develop .#vscode, and more

- 🧹 Bootstrap wizard for easy setup



## 🧭 Getting Started
the one-liner:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ejwohlers/dotnix/main/bootstrap.sh)"

```

or

```bash
# 1. Clone the repo
git clone https://github.com/ejwohlers/dotnix ~/.dotfiles
cd ~/.dotfiles

# 2. Bootstrap the system
bash ./bootstrap.sh

# 3. (Optional) Re-activate Home Manager config manually
./activate.sh
```

The bootstrap wizard will:

Install Nix if missing

Enable flakes and nix-command

Run darwin-rebuild (macOS) or home-manager (Linux)

## 📁 Structure

bash
Copy
Edit
.
├── flake.nix              # The main entry point
├── home/
│   ├── common.nix         # Shared Home Manager config
│   ├── pre-commit.nix     # Pre-commit tools (statix, deadnix, etc.)
│   └── hosts/             # Per-host overrides (Surface, Macbook, etc.)
├── modules/
│   ├── devshells/         # Dev shells (e.g., VSCode)
│   ├── apps/              # Flake apps (e.g., Neovim)
│   ├── cli-core.nix       # CLI tools (bat, eza, git, etc.)
│   ├── homebrew.nix       # Homebrew-managed casks (macOS)
│   └── macos.nix          # macOS-specific tweaks (dock, settings)
├── lib/
│   └── checks.nix         # Flake checks (pre-commit, formatters)
├── .github/
│   └── workflows/         # CI pipelines for flake checks
└── bootstrap.sh           # Bootstrap script for fresh machines


## 🤝 Credits & Inspirations
@ryantm — agenix
@mic92 — sops-nix
@zhaofengli — flake layouts
Nix community 💚


"Once you understand flakes, there’s no going back." — a wise Nix wizard

🧙‍♂️ License
MIT — use it, fork it, vibe with it.