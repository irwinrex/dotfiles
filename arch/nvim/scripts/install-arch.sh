#!/bin/bash
# LazyVim Development Environment Setup for Arch Linux
# Bash script to install all required tools using pacman and AUR

set -e

echo "🚀 LazyVim Development Environment Setup for Arch Linux"
echo "This script will install all required tools for Go, Python, Shell, DevOps, and Web development"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if running as non-root user
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ This script should not be run as root (except for pacman commands)${NC}"
   exit 1
fi

# Update system
echo -e "${BLUE}📦 Updating system packages...${NC}"
sudo pacman -Syu --noconfirm

echo -e "${BLUE}📦 Installing core development tools...${NC}"

# Core Tools
sudo pacman -S --noconfirm git
sudo pacman -S --noconfirm neovim
sudo pacman -S --noconfirm nodejs npm
sudo pacman -S --noconfirm python python-pip
sudo pacman -S --noconfirm go

# Development utilities
sudo pacman -S --noconfirm ripgrep
sudo pacman -S --noconfirm fd
sudo pacman -S --noconfirm fzf
sudo pacman -S --noconfirm bottom
sudo pacman -S --noconfirm base-devel

# Check for AUR helper (yay)
if ! command -v yay &> /dev/null; then
    echo -e "${BLUE}📦 Installing yay (AUR helper)...${NC}"
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
fi

# Go Tools
echo -e "${BLUE}🐹 Installing Go development tools...${NC}"
go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/cweill/gotests/gotests@latest
go install gotest.tools/gotestsum@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/josharian/impl@latest
go install golang.org/x/vuln/cmd/govulncheck@latest

# Python Tools
echo -e "${BLUE}🐍 Installing Python development tools...${NC}"
pip install --user --upgrade pip
pip install --user basedpyright
pip install --user ruff
pip install --user mypy
pip install --user debugpy
pip install --user black
pip install --user isort
pip install --user bandit

# Shell Tools
echo -e "${BLUE}🐚 Installing Shell development tools...${NC}"
sudo pacman -S --noconfirm shellcheck
sudo pacman -S --noconfirm shfmt

# DevOps Tools
echo -e "${BLUE}🛠️ Installing DevOps tools...${NC}"
sudo pacman -S --noconfirm terraform
sudo pacman -S --noconfirm docker
sudo pacman -S --noconfirm docker-compose
sudo pacman -S --noconfirm helm
sudo pacman -S --noconfirm yamllint

# Docker setup
echo -e "${BLUE}🐳 Setting up Docker...${NC}"
sudo systemctl enable docker
sudo usermod -aG docker $USER
yay -S --noconfirm hadolint-bin

# Rust (for some tools)
echo -e "${BLUE}🦀 Installing Rust and Rust-based tools...${NC}"
sudo pacman -S --noconfirm rustup
rustup default stable
cargo install stylua
cargo install taplo-cli # TOML formatter

# Node.js based tools
echo -e "${BLUE}📦 Installing Node.js based tools...${NC}"
npm install -g yaml-language-server
npm install -g dockerfile-language-server-nodejs
npm install -g typescript-language-server
npm install -g @eslint/eslintrc @eslint/js eslint_d
npm install -g prettier
npm install -g vscode-langservers-extracted
npm install -g @volar/vue-language-server
npm install -g bash-language-server
npm install -g marksman
npm install -g fixjson
npm install -g sql-language-server

# Lua Language Server
echo -e "${BLUE}🌙 Installing Lua Language Server...${NC}"
sudo pacman -S --noconfirm lua-language-server

# Additional AUR packages
echo -e "${BLUE}📦 Installing additional tools from AUR...${NC}"
yay -S --noconfirm lazygit
yay -S --noconfirm tflint-bin

# Additional language servers
sudo pacman -S --noconfirm efm-langserver

# Install tree-sitter CLI
echo -e "${BLUE}🌳 Installing Tree-sitter CLI...${NC}"
npm install -g tree-sitter-cli

echo -e "${GREEN}✅ Installation completed!${NC}"
echo -e "${YELLOW}📝 Please restart your terminal or run 'source ~/.bashrc' to update PATH${NC}"
echo -e "${YELLOW}🐳 Please log out and log back in for Docker group changes to take effect${NC}"
echo -e "${GREEN}🚀 You can now use LazyVim with full language support!${NC}"

echo -e "\n${CYAN}📋 Installed tools summary:${NC}"
echo -e "  ${NC}Go: gopls, gofumpt, golangci-lint, delve, gotests, gotestsum${NC}"
echo -e "  ${NC}Python: basedpyright, ruff, mypy, debugpy, black, isort, bandit${NC}"
echo -e "  ${NC}Shell: bash-language-server, shellcheck, shfmt${NC}"
echo -e "  ${NC}DevOps: yaml-language-server, dockerfile-language-server, terraform, helm, docker${NC}"
echo -e "  ${NC}Web: typescript-language-server, eslint_d, prettier${NC}"
echo -e "  ${NC}Others: lua-language-server, marksman, ripgrep, fd, fzf, lazygit${NC}"

echo -e "\n${YELLOW}🔧 Additional setup:${NC}"
echo -e "  ${NC}1. Add Go bin to PATH: export PATH=\$PATH:\$(go env GOPATH)/bin${NC}"
echo -e "  ${NC}2. Add Cargo bin to PATH: export PATH=\$PATH:~/.cargo/bin${NC}"
echo -e "  ${NC}3. Add local Python bin to PATH: export PATH=\$PATH:~/.local/bin${NC}"
echo -e "  ${NC}4. Add these to your ~/.bashrc or ~/.zshrc${NC}"
echo -e "  ${NC}5. Start Docker service: sudo systemctl start docker${NC}"