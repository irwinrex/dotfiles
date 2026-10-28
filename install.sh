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

setup_rust() {
  # 1. rustup itself (cross-platform: works on all supported OSes, unlike the
  #    OS-gated brew/pacman/apt functions). NVIM's instantlua init prepends
  #    ~/.cargo/bin to PATH and expects a rustup-managed rust-analyzer there.
  if ! command -v rustup >/dev/null 2>&1; then
    info "Installing rustup (stable toolchain)..."
    if ! command -v curl >/dev/null 2>&1; then
      err "curl not found (required to install rustup)"
      return 1
    fi
    # -y: non-interactive (install_curl_sh can't be reused: it pipes to bare
    # sh with no args, which hangs on rustup's toolchain prompt).
    curl -sSfL https://sh.rustup.rs | sh -s -- -y --default-toolchain stable >/dev/null 2>&1 || {
      warn "rustup install script failed"
      return 0
    }
    export PATH="$HOME/.cargo/bin:$PATH"
  fi
  if ! command -v rustup >/dev/null 2>&1; then
    warn "rustup not available after install (log out and back in)"
    return 0
  fi
  ok "rustup is installed"

  # 2. Components. NB: ~/.cargo/bin/rust-analyzer is a rustup shim that exits
  #    with "Unknown binary" unless the component exists in the active
  #    toolchain — checking `command -v` is NOT enough, so verify per component.
  local c
  for c in rust-analyzer rust-src rustfmt clippy; do
    if rustup component list --installed 2>/dev/null | grep -q "^${c}-"; then
      ok "rustup component $c already installed"
    else
      info "Adding rustup component $c..."
      rustup component add "$c" 2>/dev/null \
        && ok "rustup component $c installed" \
        || warn "rustup component add $c failed"
    fi
  done
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

run_stow_nvim() {
  info "Setting up nvim config symlinks..."

  if [[ -L "$HOME/.config/nvim" ]]; then
    rm -f "$HOME/.config/nvim"
  elif [[ -d "$HOME/.config/nvim" ]]; then
    warn "Backing up existing ~/.config/nvim → ~/.config/nvim.backup"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
  fi

  cd "$DOTFILES_DIR" && stow nvim

  if [[ -L "$HOME/.config/nvim" ]]; then
    ok "nvim config symlinks created"
  else
    err "Stow may not have worked correctly"
    err "Run manually: cd ~/dotfiles && stow -v nvim"
  fi
}

run_stow_lazygit() {
  info "Setting up lazygit config symlinks..."

  if [[ -L "$HOME/.config/lazygit" ]]; then
    rm -f "$HOME/.config/lazygit"
  elif [[ -d "$HOME/.config/lazygit" ]]; then
    warn "Backing up existing ~/.config/lazygit → ~/.config/lazygit.backup"
    mv "$HOME/.config/lazygit" "$HOME/.config/lazygit.backup"
  fi

  cd "$DOTFILES_DIR" && stow lazygit

  if [[ -L "$HOME/.config/lazygit" ]]; then
    ok "lazygit config symlinks created"
  else
    err "Stow may not have worked correctly"
    err "Run manually: cd ~/dotfiles && stow -v lazygit"
  fi
}

run_stow_opencode() {
  info "Setting up opencode config symlinks..."

  if [[ -L "$HOME/.config/opencode" ]]; then
    rm -f "$HOME/.config/opencode"
  elif [[ -d "$HOME/.config/opencode" ]]; then
    warn "Backing up existing ~/.config/opencode → ~/.config/opencode.backup"
    mv "$HOME/.config/opencode" "$HOME/.config/opencode.backup"
  fi

  cd "$DOTFILES_DIR" && stow opencode

  if [[ -L "$HOME/.config/opencode" ]]; then
    ok "opencode config symlinks created"
  else
    err "Stow may not have worked correctly"
    err "Run manually: cd ~/dotfiles && stow -v opencode"
  fi
}

run_stow_claude() {
  info "Setting up Claude Code config symlinks..."

  if [[ -f "$HOME/.claude/settings.json" && ! -L "$HOME/.claude/settings.json" ]]; then
    warn "Backing up existing ~/.claude/settings.json → ~/.claude/settings.json.backup"
    mv "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.backup"
  fi

  cd "$DOTFILES_DIR" && stow claude

  if [[ -L "$HOME/.claude/settings.json" ]]; then
    ok "Claude config symlinks created"
  else
    err "Stow may not have worked correctly"
    err "Run manually: cd ~/dotfiles && stow -v claude"
  fi
}

run_stow_sofka() {
  info "Setting up sofka config symlinks..."

  if [[ -L "$HOME/.config/sofka" ]]; then
    rm -f "$HOME/.config/sofka"
  elif [[ -d "$HOME/.config/sofka" ]]; then
    warn "Backing up existing ~/.config/sofka → ~/.config/sofka.backup"
    mv "$HOME/.config/sofka" "$HOME/.config/sofka.backup"
  fi

  cd "$DOTFILES_DIR" && stow sofka

  if [[ -L "$HOME/.config/sofka" ]]; then
    ok "sofka config symlinks created"
  else
    err "Stow may not have worked correctly"
    err "Run manually: cd ~/dotfiles && stow -v sofka"
  fi
}

run_stow_k9s() {
  info "Setting up k9s config symlinks..."

  if [[ -L "$HOME/.config/k9s" ]]; then
    rm -f "$HOME/.config/k9s"
  elif [[ -d "$HOME/.config/k9s" ]]; then
    warn "Backing up existing ~/.config/k9s → ~/.config/k9s.backup"
    mv "$HOME/.config/k9s" "$HOME/.config/k9s.backup"
  fi

  cd "$DOTFILES_DIR" && stow k9s

  if [[ -L "$HOME/.config/k9s" ]]; then
    ok "k9s config symlinks created"
  else
    err "Stow may not have worked correctly"
    err "Run manually: cd ~/dotfiles && stow -v k9s"
  fi
}

run_stow_agy() {
  info "Setting up antigravity config symlinks..."

  mkdir -p "$HOME/.gemini" "$HOME/.gemini/antigravity-cli"

  for target in "$HOME/.gemini/GEMINI.md" "$HOME/.gemini/antigravity-cli/settings.json"; do
    if [[ -L "$target" ]]; then
      rm -f "$target"
    elif [[ -f "$target" ]]; then
      warn "Backing up existing $target → $target.backup"
      mv "$target" "$target.backup"
    fi
  done

  cd "$DOTFILES_DIR" && stow agy

  if [[ -L "$HOME/.gemini/GEMINI.md" && -L "$HOME/.gemini/antigravity-cli/settings.json" ]]; then
    ok "antigravity config symlinks created"
  else
    err "Stow may not have worked correctly"
    err "Run manually: cd ~/dotfiles && stow -v agy"
  fi
}

install_omz() {
  local omz_dir="$HOME/.oh-my-zsh"
  local custom_plugins="$omz_dir/custom/plugins"

  if [[ -f "$omz_dir/oh-my-zsh.sh" ]]; then
    ok "Oh My Zsh is already installed"
  else
    info "Installing Oh My Zsh..."
    if ! command -v git >/dev/null 2>&1; then
      err "git not found (required to install Oh My Zsh)"
      return 1
    fi
    # Use git clone instead of the official curl installer so we do not
    # overwrite the stowed ~/.zshrc.
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir" >/dev/null 2>&1 || {
      err "Failed to clone Oh My Zsh"
      return 1
    }
    ok "Oh My Zsh installed"
  fi

  mkdir -p "$custom_plugins"

  local plugin repo
  for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode; do
    case "$plugin" in
      zsh-autosuggestions)    repo="zsh-users/zsh-autosuggestions" ;;
      zsh-syntax-highlighting) repo="zsh-users/zsh-syntax-highlighting" ;;
      zsh-vi-mode)            repo="jeffreytse/zsh-vi-mode" ;;
    esac

    if [[ -d "$custom_plugins/$plugin" ]]; then
      ok "Oh My Zsh plugin $plugin is already installed"
      continue
    fi

    info "Installing Oh My Zsh plugin $plugin..."
    git clone --depth=1 "https://github.com/${repo}.git" "$custom_plugins/$plugin" >/dev/null 2>&1 || {
      warn "Failed to clone $plugin"
      continue
    }
    ok "Oh My Zsh plugin $plugin installed"
  done
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
      install_pkg lazygit
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
      install_pkg lazygit
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
      install_pkg lazygit
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
      install_pkg lazygit
      install_curl_sh "https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh" zoxide
      install_curl_sh "https://starship.rs/install.sh" starship
      fix_debian_bins
      ;;
  esac

  echo ""
  setup_rust
  ensure_stow
  create_dirs
  install_omz
  run_stow
  run_stow_nvim
  run_stow_lazygit
  run_stow_opencode
  run_stow_claude
  run_stow_sofka
  run_stow_k9s
  run_stow_agy
  echo ""
  set_default_shell
  echo ""

  info "=================================="
  info "  Installation complete!"
  info "=================================="
  echo ""
  info "Next steps:"
  info "  1. Restart your terminal or run: exec zsh"
  info "  2. Update Oh My Zsh later with: omz update"
  info "  3. Rust LSP works when opening a .rs file in nvim (rustup-managed rust-analyzer)"
  echo ""
  ok "Happy hacking!"
}

main "$@"
