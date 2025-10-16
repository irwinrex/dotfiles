#!/bin/bash
# LazyVim Development Environment Setup for Alpine Linux
# Bash script to install all required tools using apk

set -e

echo "🚀 LazyVim Development Environment Setup for Alpine Linux"
echo "This script will install all required tools for Go, Python, Shell, DevOps, and Web development"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if running as non-root user for some operations
if [[ $EUID -eq 0 ]]; then
   echo -e "${YELLOW}⚠️  Running as root - some tools will be installed system-wide${NC}"
fi

# Update system
echo -e "${BLUE}📦 Updating system packages...${NC}"
apk update && apk upgrade

echo -e "${BLUE}📦 Installing core development tools...${NC}"

# Core Tools and build dependencies
apk add --no-cache \
    git \
    curl \
    wget \
    bash \
    build-base \
    linux-headers \
    musl-dev \
    gcc \
    g++

# Install Neovim
apk add --no-cache neovim

# Install Node.js and npm
apk add --no-cache nodejs npm

# Install Python
apk add --no-cache python3 python3-dev py3-pip

# Install Go
apk add --no-cache go

# Development utilities
echo -e "${BLUE}📦 Installing development utilities...${NC}"
apk add --no-cache \
    ripgrep \
    fd \
    fzf

# Install Rust (for additional tools)
echo -e "${BLUE}🦀 Installing Rust...${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env || true

# Go Tools
echo -e "${BLUE}🐹 Installing Go development tools...${NC}"
export PATH=$PATH:/usr/lib/go/bin:~/go/bin
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
pip3 install --break-system-packages --user basedpyright
pip3 install --break-system-packages --user ruff
pip3 install --break-system-packages --user mypy
pip3 install --break-system-packages --user debugpy
pip3 install --break-system-packages --user black
pip3 install --break-system-packages --user isort
pip3 install --break-system-packages --user bandit

# Alternative: using virtual environment (recommended for Alpine)
# python3 -m venv ~/python-tools
# source ~/python-tools/bin/activate
# pip install basedpyright ruff mypy debugpy black isort bandit

# Shell Tools
echo -e "${BLUE}🐚 Installing Shell development tools...${NC}"
apk add --no-cache shellcheck

# Install shfmt via Go
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# DevOps Tools
echo -e "${BLUE}🛠️ Installing DevOps tools...${NC}"

# Install Terraform
TERRAFORM_VERSION="1.6.6"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Docker
apk add --no-cache docker docker-compose
rc-update add docker boot 2>/dev/null || true

# Install Helm
HELM_VERSION="v3.13.3"
wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64 helm-${HELM_VERSION}-linux-amd64.tar.gz

# Install yamllint
apk add --no-cache yamllint

# Install hadolint (Dockerfile linter)
HADOLINT_VERSION="v2.12.0"
wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64
chmod +x /usr/local/bin/hadolint

# Rust-based tools
echo -e "${BLUE}🦀 Installing Rust-based tools...${NC}"
if command -v cargo &> /dev/null; then
    cargo install stylua
    cargo install taplo-cli # TOML formatter
    cargo install bottom # System monitor
fi

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

# Install Lua Language Server
echo -e "${BLUE}🌙 Installing Lua Language Server...${NC}"
LUA_LS_VERSION=$(wget -qO- https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep -oP '"tag_name": "\K[^"]*')
wget https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz
mkdir -p /opt/lua-language-server
tar -xzf lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz -C /opt/lua-language-server
ln -sf /opt/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server
rm lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz

# Install lazygit
echo -e "${BLUE}📦 Installing lazygit...${NC}"
LAZYGIT_VERSION=$(wget -qO- "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
wget -O lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
mv lazygit /usr/local/bin/
rm lazygit.tar.gz

# Install tree-sitter CLI
echo -e "${BLUE}🌳 Installing Tree-sitter CLI...${NC}"
npm install -g tree-sitter-cli

# Install tflint
echo -e "${BLUE}🔧 Installing tflint...${NC}"
TFLINT_VERSION="v0.50.3"
wget -O tflint.zip https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip
unzip tflint.zip
mv tflint /usr/local/bin/
rm tflint.zip

# Set up environment variables
echo -e "${BLUE}🔧 Setting up environment...${NC}"
cat >> /etc/profile.d/development-tools.sh << 'EOF'
export PATH=$PATH:/usr/lib/go/bin:~/go/bin:~/.cargo/bin:~/.local/bin
export GOPATH=~/go
export GOROOT=/usr/lib/go
EOF

# For current session
export PATH=$PATH:/usr/lib/go/bin:~/go/bin:~/.cargo/bin:~/.local/bin
export GOPATH=~/go
export GOROOT=/usr/lib/go

echo -e "${GREEN}✅ Installation completed!${NC}"
echo -e "${YELLOW}📝 Please restart your terminal or run 'source /etc/profile.d/development-tools.sh' to update PATH${NC}"
echo -e "${YELLOW}🐳 Docker service: 'rc-service docker start' or reboot to start automatically${NC}"
echo -e "${GREEN}🚀 You can now use LazyVim with full language support!${NC}"

echo -e "\n${CYAN}📋 Installed tools summary:${NC}"
echo -e "  ${NC}Go: gopls, gofumpt, golangci-lint, delve, gotests, gotestsum${NC}"
echo -e "  ${NC}Python: basedpyright, ruff, mypy, debugpy, black, isort, bandit${NC}"
echo -e "  ${NC}Shell: bash-language-server, shellcheck, shfmt${NC}"
echo -e "  ${NC}DevOps: yaml-language-server, dockerfile-language-server, terraform, helm, docker${NC}"
echo -e "  ${NC}Web: typescript-language-server, eslint_d, prettier${NC}"
echo -e "  ${NC}Others: lua-language-server, marksman, ripgrep, fd, fzf, lazygit${NC}"

echo -e "\n${YELLOW}🔧 Alpine-specific notes:${NC}"
echo -e "  ${NC}1. Python packages installed with --break-system-packages flag${NC}"
echo -e "  ${NC}2. Consider using virtual environments for Python development${NC}"
echo -e "  ${NC}3. Docker service: rc-service docker start${NC}"
echo -e "  ${NC}4. Environment variables set in /etc/profile.d/development-tools.sh${NC}"
echo -e "  ${NC}5. Go tools installed to ~/go/bin${NC}"

echo -e "\n${YELLOW}🐍 For better Python isolation, consider:${NC}"
echo -e "  ${NC}python3 -m venv ~/python-dev${NC}"
echo -e "  ${NC}source ~/python-dev/bin/activate${NC}"
echo -e "  ${NC}pip install basedpyright ruff mypy debugpy black isort bandit${NC}"