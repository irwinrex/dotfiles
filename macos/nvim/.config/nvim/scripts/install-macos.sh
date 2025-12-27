#!/bin/bash
# LazyVim Development Environment Setup for macOS
# Bash script to install all required tools

set -e

echo "🚀 LazyVim Development Environment Setup for macOS"
echo "This script will install all required tools for Go, Python, Shell, DevOps, and Web development"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}📦 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

echo -e "${BLUE}📦 Updating Homebrew...${NC}"
brew update

echo -e "${BLUE}📦 Installing core development tools...${NC}"

# Core Tools
brew install git
brew install neovim
brew install node
brew install python@3.12
brew install go

# Development utilities
brew install ripgrep
brew install fd
brew install fzf
brew install lazygit
brew install bottom

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
pip3 install --upgrade pip
pip3 install basedpyright
pip3 install ruff
pip3 install mypy
pip3 install debugpy
pip3 install black
pip3 install isort
pip3 install bandit

# Shell Tools
echo -e "${BLUE}🐚 Installing Shell development tools...${NC}"
brew install shellcheck
brew install shfmt

# DevOps Tools  
echo -e "${BLUE}🛠️ Installing DevOps tools...${NC}"
brew install terraform
brew install tflint
brew install docker
brew install helm
brew install yamllint
brew install hadolint

# Rust (for some tools)
echo -e "${BLUE}🦀 Installing Rust and Rust-based tools...${NC}"
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
fi

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
brew install lua-language-server

# Additional language servers via Homebrew
brew install efm-langserver

echo -e "${GREEN}✅ Installation completed!${NC}"
echo -e "${YELLOW}📝 Please restart your terminal to ensure all tools are in PATH${NC}"
echo -e "${GREEN}🚀 You can now use LazyVim with full language support!${NC}"

echo -e "\n${CYAN}📋 Installed tools summary:${NC}"
echo -e "  ${NC}Go: gopls, gofumpt, golangci-lint, delve, gotests, gotestsum${NC}"
echo -e "  ${NC}Python: basedpyright, ruff, mypy, debugpy, black, isort, bandit${NC}"
echo -e "  ${NC}Shell: bash-language-server, shellcheck, shfmt${NC}"
echo -e "  ${NC}DevOps: yaml-language-server, dockerfile-language-server, terraform, helm${NC}"
echo -e "  ${NC}Web: typescript-language-server, eslint_d, prettier${NC}"
echo -e "  ${NC}Others: lua-language-server, marksman, ripgrep, fd, fzf${NC}"

echo -e "\n${YELLOW}🔧 Additional setup:${NC}"
echo -e "  ${NC}1. Add Go bin to PATH: export PATH=\$PATH:\$(go env GOPATH)/bin${NC}"
echo -e "  ${NC}2. Add Cargo bin to PATH: export PATH=\$PATH:~/.cargo/bin${NC}"
echo -e "  ${NC}3. Consider adding these to your ~/.zshrc or ~/.bash_profile${NC}"