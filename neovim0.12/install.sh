#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Config paths ────────────────────────────────────────────────────────────
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim0.12"
PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim0.12/site/pack/default/start"
AUTOLOAD_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim0.12/site/autoload"

# ── Symlink config ──────────────────────────────────────────────────────────
echo "→ Creating config symlink: $CONFIG_DIR"
mkdir -p "$(dirname "$CONFIG_DIR")"
ln -sfn "$DOTFILES_DIR/.config/nvim0.12" "$CONFIG_DIR"

# ── Clone plugins ──────────────────────────────────────────────────────────
clone_plugin() {
  local repo=$1
  local name=${repo#*/}
  local dir="$PLUGIN_DIR/$name"
  if [[ -d "$dir" ]]; then
    echo "  ✔ $name already installed"
  else
    echo "  → Cloning $name ..."
    git clone --depth=1 "https://github.com/$repo" "$dir"
  fi
}

mkdir -p "$PLUGIN_DIR"

echo "→ Installing plugins to $PLUGIN_DIR"

clone_plugin "neovim/nvim-lspconfig"
clone_plugin "nvim-treesitter/nvim-treesitter"

# blink.cmp needs full history for git tags (used to download native lib)
if [[ -d "$PLUGIN_DIR/blink.cmp" ]]; then
  echo "  ✔ blink.cmp already installed"
else
  echo "  → Cloning blink.cmp (full clone, needs tags) ..."
  git clone "https://github.com/saghen/blink.cmp" "$PLUGIN_DIR/blink.cmp"
fi
clone_plugin "saghen/blink.lib"

# Download blink.cmp native library
if [[ -d "$PLUGIN_DIR/blink.cmp" ]]; then
  echo "  → Downloading blink.cmp native lib ..."
  if NVIM_APPNAME=nvim0.12 nvim --headless -c "lua require('blink.cmp').download({ match = '*' }):pwait()" -c "qa!" 2>/dev/null; then
    echo "    ✔ blink.cmp lib ready"
  else
    echo "    ⚠ blink.cmp download failed, trying build ..."
    NVIM_APPNAME=nvim0.12 nvim --headless -c "lua require('blink.cmp').build():pwait()" -c "qa!" 2>/dev/null && echo "    ✔ blink.cmp built" || echo "    ⚠ blink.cmp build also failed"
  fi
fi
clone_plugin "stevearc/conform.nvim"
clone_plugin "lewis6991/gitsigns.nvim"
clone_plugin "nvim-telescope/telescope.nvim"
clone_plugin "nvim-lua/plenary.nvim"
clone_plugin "rafamadriz/friendly-snippets"
clone_plugin "folke/flash.nvim"

# ── Done ───────────────────────────────────────────────────────────────────
echo ""
echo "  ✔ Setup complete!"
echo ""
echo "  Launch:  NVIM_APPNAME=nvim0.12 nvim"
echo "  Alias:   alias v0='NVIM_APPNAME=nvim0.12 nvim'"
echo ""
