# LazyVim Development Environment Setup for Windows
# PowerShell script to install all required tools

Write-Host "🚀 LazyVim Development Environment Setup for Windows" -ForegroundColor Green
Write-Host "This script will install all required tools for Go, Python, Shell, DevOps, and Web development" -ForegroundColor Yellow

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script needs to be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Install Chocolatey if not present
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Installing Chocolatey..." -ForegroundColor Blue
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Install Scoop if not present (for additional tools)
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Installing Scoop..." -ForegroundColor Blue
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    irm get.scoop.sh | iex
}

Write-Host "📦 Installing core development tools..." -ForegroundColor Blue

# Core Tools
choco install -y git
choco install -y neovim
choco install -y nodejs
choco install -y python
choco install -y golang

# Go Tools
Write-Host "🐹 Installing Go development tools..." -ForegroundColor Blue
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
Write-Host "🐍 Installing Python development tools..." -ForegroundColor Blue
pip install --upgrade pip
pip install basedpyright
pip install ruff
pip install mypy
pip install debugpy
pip install black
pip install isort
pip install bandit

# Shell Tools (via scoop)
Write-Host "🐚 Installing Shell development tools..." -ForegroundColor Blue
scoop install shellcheck
scoop install shfmt

# DevOps Tools
Write-Host "🛠️ Installing DevOps tools..." -ForegroundColor Blue
choco install -y terraform
choco install -y docker-desktop
choco install -y kubernetes-helm

# Install via npm (Node.js tools)
Write-Host "📦 Installing Node.js based tools..." -ForegroundColor Blue
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

# Additional Tools
Write-Host "🔧 Installing additional development tools..." -ForegroundColor Blue
choco install -y ripgrep
choco install -y fd
choco install -y fzf
choco install -y lazygit
choco install -y bottom

# Rust-based tools (via cargo if available)
if (Get-Command cargo -ErrorAction SilentlyContinue) {
    Write-Host "🦀 Installing Rust-based tools..." -ForegroundColor Blue
    cargo install stylua
    cargo install taplo-cli # TOML formatter
}

# Install Lua Language Server
Write-Host "🌙 Installing Lua Language Server..." -ForegroundColor Blue
scoop bucket add extras
scoop install lua-language-server

Write-Host "✅ Installation completed!" -ForegroundColor Green
Write-Host "📝 Please restart your terminal or run 'refreshenv' to update PATH" -ForegroundColor Yellow
Write-Host "🚀 You can now use LazyVim with full language support!" -ForegroundColor Green

Write-Host "`n📋 Installed tools summary:" -ForegroundColor Cyan
Write-Host "  Go: gopls, gofumpt, golangci-lint, delve, gotests, gotestsum" -ForegroundColor White
Write-Host "  Python: basedpyright, ruff, mypy, debugpy, black, isort, bandit" -ForegroundColor White
Write-Host "  Shell: bash-language-server, shellcheck, shfmt" -ForegroundColor White
Write-Host "  DevOps: yaml-language-server, dockerfile-language-server, terraform" -ForegroundColor White
Write-Host "  Web: typescript-language-server, eslint_d, prettier" -ForegroundColor White
Write-Host "  Others: lua-language-server, marksman, ripgrep, fd, fzf" -ForegroundColor White