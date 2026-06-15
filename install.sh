#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# The Perfect Zsh Setup — Multi-Platform Installer
# =========================================================

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# =========================================================
# Colors
# =========================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { printf "${CYAN}%s${NC}\n" "$*"; }
ok()    { printf "${GREEN}✓ %s${NC}\n" "$*"; }
warn()  { printf "${YELLOW}⚠ %s${NC}\n" "$*"; }
err()   { printf "${RED}✘ %s${NC}\n" "$*"; }

# =========================================================
# OS Detection
# =========================================================

detect_os() {
  case "$(uname -s)" in
    Darwin)  echo "macos" ;;
    Linux)
      if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
          arch|archarm|manjaro|endeavouros|cachyos) echo "arch" ;;
          fedora)  echo "fedora" ;;
          debian|ubuntu|pop|linuxmint|elementary) echo "debian" ;;
          *)       echo "unknown" ;;
        esac
      else
        echo "unknown"
      fi
      ;;
    *) echo "unknown" ;;
  esac
}

OS=$(detect_os)

if [[ "$OS" == "unknown" ]]; then
  err "Unsupported OS: $(uname -s)"
  err "Supported: macOS, Arch Linux, Fedora, Debian/Ubuntu"
  exit 1
fi

info "Detected OS: $OS"

# =========================================================
# Install functions
# =========================================================

install_pkg() {
  local pkg=$1
  local pkg_name=${2:-$pkg}

  if command -v "$pkg_name" >/dev/null 2>&1; then
    ok "$pkg is already installed"
    return 0
  fi

  info "Installing $pkg..."
  case "$OS" in
    macos)
      if ! command -v brew >/dev/null 2>&1; then
        err "Homebrew not found. Install from https://brew.sh"
        return 1
      fi
      brew install "$pkg" >/dev/null 2>&1 || {
        warn "brew install $pkg failed (may already be installed via other method)"
        return 0
      }
      ;;
    arch)
      if ! command -v pacman >/dev/null 2>&1; then
        err "pacman not found"
        return 1
      fi
      sudo pacman -S --noconfirm "$pkg" >/dev/null 2>&1 || {
        warn "pacman -S $pkg failed"
        return 0
      }
      ;;
    fedora)
      if ! command -v dnf >/dev/null 2>&1; then
        err "dnf not found"
        return 1
      fi
      sudo dnf install -y "$pkg" >/dev/null 2>&1 || {
        warn "dnf install $pkg failed"
        return 0
      }
      ;;
    debian)
      if ! command -v apt >/dev/null 2>&1; then
        err "apt not found"
        return 1
      fi
      sudo apt install -y "$pkg" >/dev/null 2>&1 || {
        warn "apt install $pkg failed"
        return 0
      }
      ;;
  esac

  if command -v "$pkg_name" >/dev/null 2>&1; then
    ok "$pkg installed"
  else
    warn "$pkg may not have installed correctly (binary name mismatch)"
  fi
}

install_curl_sh() {
  local url=$1
  local name=$2

  if command -v "$name" >/dev/null 2>&1; then
    ok "$name is already installed"
    return 0
  fi

  info "Installing $name via curl..."
  if ! command -v curl >/dev/null 2>&1; then
    err "curl not found"
    return 1
  fi

  curl -sSfL "$url" | sh >/dev/null 2>&1 || {
    warn "$name install script failed"
    return 0
  }

  if command -v "$name" >/dev/null 2>&1; then
    ok "$name installed"
  else
    warn "$name installed but not in PATH (log out and back in)"
  fi
}

ensure_stow() {
  if command -v stow >/dev/null 2>&1; then
    ok "stow is already installed"
    return 0
  fi

  info "Installing stow..."
  case "$OS" in
    macos) brew install stow >/dev/null 2>&1 ;;
    arch)  sudo pacman -S --noconfirm stow >/dev/null 2>&1 ;;
    fedora) sudo dnf install -y stow >/dev/null 2>&1 ;;
    debian) sudo apt install -y stow >/dev/null 2>&1 ;;
  esac

  if command -v stow >/dev/null 2>&1; then
    ok "stow installed"
  else
    err "stow installation failed"
    exit 1
  fi
}

fix_debian_bins() {
  [[ "$OS" != "debian" ]] && return 0

  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    ok "Symlinked batcat → bat"
  fi

  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    ok "Symlinked fdfind → fd"
  fi
}

set_default_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)"

  if [[ "$SHELL" == "$zsh_path" ]]; then
    ok "zsh is already the default shell"
    return 0
  fi

  info "Setting zsh as default shell..."
  if chsh -s "$zsh_path" 2>/dev/null; then
    ok "Default shell set to zsh"
    info "Log out and back in for the change to take effect"
  else
    warn "Could not set zsh as default shell (run 'chsh -s $(which zsh)' manually)"
  fi
}

run_stow() {
  info "Setting up zsh config symlinks..."

  # Remove existing dir/symlink to prevent stow conflicts
  if [[ -L "$HOME/.config/zsh" ]]; then
    rm -f "$HOME/.config/zsh"
  elif [[ -d "$HOME/.config/zsh" ]]; then
    rm -rf "$HOME/.config/zsh"
  fi

  if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    warn "Backing up existing ~/.zshrc → ~/.zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
  fi

  cd "$DOTFILES_DIR" && stow zsh

  if [[ -L "$HOME/.zshrc" && -L "$HOME/.config/zsh" ]]; then
    ok "zsh config symlinks created"
  else
    err "Stow may not have worked correctly"
    err "Run manually: cd ~/dotfiles && stow -v zsh"
  fi
}

run_stow_neovim() {
  info "Setting up neovim0.12 config symlinks..."

  if [[ -L "$HOME/.config/nvim0.12" ]]; then
    rm -f "$HOME/.config/nvim0.12"
  elif [[ -d "$HOME/.config/nvim0.12" ]]; then
    warn "Backing up existing ~/.config/nvim0.12 → ~/.config/nvim0.12.backup"
    mv "$HOME/.config/nvim0.12" "$HOME/.config/nvim0.12.backup"
  fi

  cd "$DOTFILES_DIR" && stow neovim0.12

  if [[ -L "$HOME/.config/nvim0.12" ]]; then
    ok "neovim0.12 config symlinks created"
  else
    err "Stow may not have worked correctly"
    err "Run manually: cd ~/dotfiles && stow -v neovim0.12"
  fi
}

create_dirs() {
  mkdir -p "$HOME/.local/state/zsh"
  mkdir -p "$HOME/.cache/zsh"
}

# =========================================================
# Main
# =========================================================

main() {
  info "=================================="
  info "  The Perfect Zsh Setup Installer"
  info "=================================="
  echo ""

  case "$OS" in
    macos)
      info "Installing packages via Homebrew..."
      install_pkg neovim
      install_pkg eza
      install_pkg bat
      install_pkg fd
      install_pkg fzf
      install_pkg zoxide
      install_pkg starship
      install_pkg ripgrep rg
      install_pkg fd
      ;;
    arch)
      info "Installing packages via pacman..."
      install_pkg zsh
      install_pkg neovim
      install_pkg eza
      install_pkg bat
      install_pkg fd
      install_pkg fzf
      install_pkg zoxide
      install_pkg starship
      install_pkg ripgrep
      ;;
    fedora)
      info "Installing packages via dnf..."
      install_pkg zsh
      install_pkg neovim
      install_pkg eza
      install_pkg bat
      install_pkg fd-find fd
      install_pkg fzf
      install_pkg zoxide
      install_pkg starship
      install_pkg ripgrep
      ;;
    debian)
      info "Installing packages via apt..."
      install_pkg zsh
      install_pkg neovim
      install_pkg eza
      install_pkg bat
      install_pkg fd-find fd
      install_pkg fzf
      install_pkg ripgrep
      install_curl_sh "https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh" zoxide
      install_curl_sh "https://starship.rs/install.sh" starship
      fix_debian_bins
      ;;
  esac

  echo ""
  ensure_stow
  create_dirs
  run_stow
  run_stow_neovim
  echo ""
  set_default_shell
  echo ""

  info "=================================="
  info "  Installation complete!"
  info "=================================="
  echo ""
  info "Next steps:"
  info "  1. Restart your terminal or run: exec zsh"
  info "  2. First startup will clone plugins (may take a few seconds)"
  info "  3. Update plugins later with: zplugin-update"
  info "  4. Launch Neovim 0.12 with: v0"
  echo ""
  ok "Happy hacking!"
}

main "$@"
