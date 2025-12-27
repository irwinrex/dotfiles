#!/bin/bash
# LazyVim Development Environment Setup for Ubuntu/Debian
# Bash script to install all required tools using apt and additional sources

set -e

echo "🚀 LazyVim Development Environment Setup for Ubuntu/Debian"
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
   echo -e "${RED}❌ This script should not be run as root (except for apt commands)${NC}"
   exit 1
fi

# Update system
echo -e "${BLUE}📦 Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

echo -e "${BLUE}📦 Installing core development tools...${NC}"

# Install essential packages
sudo apt install -y curl wget gpg software-properties-common apt-transport-https ca-certificates gnupg lsb-release

# Core Tools
sudo apt install -y git
sudo apt install -y build-essential

# Install Neovim (latest version via PPA)
echo -e "${BLUE}📦 Installing Neovim...${NC}"
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

# Install Node.js (via NodeSource)
echo -e "${BLUE}📦 Installing Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Install Python
sudo apt install -y python3 python3-pip python3-venv

# Install Go (latest version)
echo -e "${BLUE}🐹 Installing Go...${NC}"
GO_VERSION=$(curl -s https://api.github.com/repos/golang/go/releases/latest | grep -oP '"tag_name": "\K[^"]*' | sed 's/go//')
wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

# Development utilities
echo -e "${BLUE}📦 Installing development utilities...${NC}"
sudo apt install -y ripgrep
sudo apt install -y fd-find
sudo apt install -y fzf

# Install bottom (system monitor)
wget https://github.com/ClementTsang/bottom/releases/latest/download/bottom_0.9.6_amd64.deb
sudo dpkg -i bottom_0.9.6_amd64.deb
rm bottom_0.9.6_amd64.deb

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
pip3 install --user --upgrade pip
pip3 install --user basedpyright
pip3 install --user ruff
pip3 install --user mypy
pip3 install --user debugpy
pip3 install --user black
pip3 install --user isort
pip3 install --user bandit

# Shell Tools
echo -e "${BLUE}🐚 Installing Shell development tools...${NC}"
sudo apt install -y shellcheck

# Install shfmt
echo -e "${BLUE}📦 Installing shfmt...${NC}"
GO111MODULE=on go install mvdan.cc/sh/v3/cmd/shfmt@latest

# DevOps Tools
echo -e "${BLUE}🛠️ Installing DevOps tools...${NC}"

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install -y terraform

# Install Docker
echo -e "${BLUE}🐳 Installing Docker...${NC}"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER

# Install Helm
echo -e "${BLUE}⚓ Installing Helm...${NC}"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt install -y helm

# Additional DevOps tools
sudo apt install -y yamllint

# Install hadolint (Dockerfile linter)
wget -O /tmp/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
sudo mv /tmp/hadolint /usr/local/bin/hadolint
sudo chmod +x /usr/local/bin/hadolint

# Rust (for some tools)
echo -e "${BLUE}🦀 Installing Rust and Rust-based tools...${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env
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

# Install Lua Language Server
echo -e "${BLUE}🌙 Installing Lua Language Server...${NC}"
LUA_LS_VERSION=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep -oP '"tag_name": "\K[^"]*')
wget https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz
sudo mkdir -p /opt/lua-language-server
sudo tar -xzf lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz -C /opt/lua-language-server
sudo ln -sf /opt/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server
rm lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz

# Install lazygit
echo -e "${BLUE}📦 Installing lazygit...${NC}"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz

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
echo -e "  ${NC}1. Go bin already added to PATH${NC}"
echo -e "  ${NC}2. Add Cargo bin to PATH: export PATH=\$PATH:~/.cargo/bin${NC}"
echo -e "  ${NC}3. Add local Python bin to PATH: export PATH=\$PATH:~/.local/bin${NC}"
echo -e "  ${NC}4. Add these to your ~/.bashrc${NC}"
echo -e "  ${NC}5. Start Docker service: sudo systemctl start docker${NC}"