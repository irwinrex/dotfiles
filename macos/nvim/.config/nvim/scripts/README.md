# LazyVim Development Environment Setup

This repository contains installation scripts for setting up a complete development environment optimized for **LazyVim** with support for Go, Python, Shell scripting, DevOps tools, and Web development.

## 🚀 Quick Start

Choose your operating system and run the appropriate installation script:

### Windows (PowerShell)
```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\install-windows.ps1
```

### macOS
```bash
chmod +x install-macos.sh
./install-macos.sh
```

### Linux

#### Arch Linux
```bash
chmod +x install-arch.sh
./install-arch.sh
```

#### Ubuntu/Debian
```bash
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

#### Alpine Linux
```bash
chmod +x install-alpine.sh
sudo ./install-alpine.sh
```

## 📋 What Gets Installed

### Core Development Tools
- **Git** - Version control
- **Neovim** - Text editor
- **Node.js & npm** - JavaScript runtime and package manager
- **Python 3** - Python interpreter and pip
- **Go** - Go programming language

### 🐹 Go Development Stack
| Tool | Purpose |
|------|---------|
| `gopls` | Go Language Server |
| `gofumpt` | Enhanced Go formatter |
| `golangci-lint` | Comprehensive Go linter |
| `delve` | Go debugger |
| `gotests` | Test generation |
| `gotestsum` | Enhanced test runner |
| `gomodifytags` | Struct tag management |
| `impl` | Interface implementation generator |
| `govulncheck` | Vulnerability scanner |

### 🐍 Python Development Stack
| Tool | Purpose |
|------|---------|
| `basedpyright` | Type-aware Python Language Server (FOSS) |
| `ruff` | Fast Python linter and formatter |
| `mypy` | Static type checker |
| `debugpy` | Python debugger |
| `black` | Code formatter (backup) |
| `isort` | Import sorter (backup) |
| `bandit` | Security vulnerability scanner |

### 🐚 Shell Development Stack
| Tool | Purpose |
|------|---------|
| `bash-language-server` | Bash Language Server |
| `shellcheck` | Shell script linter |
| `shfmt` | Shell script formatter |
| `shellharden` | Shell script security hardening |

### 🛠️ DevOps & Infrastructure Stack
| Tool | Purpose |
|------|---------|
| `yaml-language-server` | YAML Language Server |
| `yamllint` | YAML linter |
| `dockerfile-language-server` | Docker Language Server |
| `hadolint` | Dockerfile linter |
| `terraform` | Infrastructure as Code |
| `tflint` | Terraform linter |
| `helm` | Kubernetes package manager |
| `docker` | Container platform |

### 🌐 Web Development Stack
| Tool | Purpose |
|------|---------|
| `typescript-language-server` | TypeScript/JavaScript LSP |
| `eslint_d` | Fast JavaScript linter daemon |
| `prettier` | Code formatter |
| `vscode-langservers-extracted` | JSON, HTML, CSS Language Servers |

### 🔧 Additional Tools
| Tool | Purpose |
|------|---------|
| `lua-language-server` | Lua LSP (for Neovim config) |
| `marksman` | Markdown Language Server |
| `ripgrep` | Fast text search |
| `fd` | Fast file finder |
| `fzf` | Fuzzy finder |
| `lazygit` | Git UI |
| `bottom` | System monitor |

## 🎯 LazyVim Configuration

After installation, these LazyVim configurations will work seamlessly:

### Mason Configuration
```lua
return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      -- All tools are already installed system-wide!
      -- Mason will detect and use them automatically
    })
  end,
}
```

### Language Configurations

#### Go Configuration
```lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              staticcheck = true,
              usePlaceholders = true,
              completeUnimported = true,
              gofumpt = true,
              -- Enhanced settings included
            },
          },
        },
      },
    },
  },
  -- Linting and formatting configurations included
}
```

#### Python Configuration
```lua
return {
  {
    "neovim/nvim-lspconfig", 
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              typeCheckingMode = "standard",
              -- Enhanced settings included
            },
          },
        },
      },
    },
  },
  -- Ruff integration for linting and formatting
}
```

## 🖥️ Platform-Specific Notes

### Windows
- **Requirements**: PowerShell 5.1+ (Run as Administrator)
- **Package Managers**: Chocolatey, Scoop
- **Additional**: Run `refreshenv` after installation

### macOS
- **Requirements**: macOS 10.15+
- **Package Manager**: Homebrew
- **Apple Silicon**: Script auto-detects and configures properly

### Arch Linux
- **Requirements**: Base system with sudo access
- **Package Managers**: pacman, yay (AUR helper)
- **Additional**: User added to docker group (logout/login required)

### Ubuntu/Debian
- **Requirements**: Ubuntu 20.04+ or Debian 11+
- **Package Manager**: apt with additional repositories
- **Additional**: Latest versions installed from official sources

### Alpine Linux
- **Requirements**: Alpine Linux 3.17+
- **Package Manager**: apk
- **Notes**: Python packages use `--break-system-packages` (consider virtual environments)

## 🔧 Post-Installation Setup

### 1. Update Shell Configuration

Add these lines to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
# Go
export PATH=$PATH:$(go env GOPATH)/bin

# Rust (if installed)
export PATH=$PATH:~/.cargo/bin

# Python (user packages)
export PATH=$PATH:~/.local/bin

# Node.js global packages
export PATH=$PATH:~/.npm-global/bin
```

### 2. Docker Setup (Linux)
```bash
# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add user to docker group (logout/login required)
sudo usermod -aG docker $USER
```

### 3. Verify Installation
```bash
# Check core tools
nvim --version
go version
python3 --version
node --version

# Check language servers
gopls version
basedpyright --version
yaml-language-server --version

# Check formatters and linters
gofumpt --version
ruff --version
shellcheck --version
```

## 🐛 Troubleshooting

### Common Issues

#### Permission Errors (Linux/macOS)
```bash
# Make scripts executable
chmod +x install-*.sh

# Fix npm permissions
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
```

#### Path Issues
```bash
# Reload shell configuration
source ~/.bashrc  # or ~/.zshrc

# Check if tools are in PATH
which gopls
which ruff
which yaml-language-server
```

#### Go Tools Not Found
```bash
# Ensure Go bin is in PATH
export PATH=$PATH:$(go env GOPATH)/bin
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
```

#### Python Tools Not Found
```bash
# Check Python user bin directory
python3 -m site --user-base
export PATH=$PATH:~/.local/bin
```

### Docker Issues (Linux)
```bash
# Check Docker status
sudo systemctl status docker

# Start Docker if not running
sudo systemctl start docker

# Check if user is in docker group
groups $USER

# If not in docker group, add and restart
sudo usermod -aG docker $USER
# Then logout and login again
```

## 🔄 Updates

To update installed tools:

### Go Tools
```bash
go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
# ... etc for other Go tools
```

### Python Tools
```bash
pip3 install --upgrade basedpyright ruff mypy
```

### Node.js Tools
```bash
npm update -g yaml-language-server typescript-language-server prettier
```

### System Package Managers
```bash
# Windows (Chocolatey)
choco upgrade all

# macOS (Homebrew) 
brew upgrade

# Arch Linux
sudo pacman -Syu

# Ubuntu/Debian
sudo apt update && sudo apt upgrade

# Alpine Linux
apk update && apk upgrade
```

## 📄 License

This project is released into the public domain. Feel free to modify and distribute as needed.

## 🤝 Contributing

Issues and improvements are welcome! Please submit pull requests or open issues for:

- Platform-specific installation problems
- Missing tools or language servers
- Configuration improvements
- Documentation updates

## 📚 Additional Resources

- [LazyVim Documentation](https://lazyvim.github.io/)
- [Neovim LSP Configuration](https://neovim.io/doc/user/lsp.html)
- [Mason.nvim](https://github.com/mason-org/mason.nvim)
- [Go Tools](https://pkg.go.dev/golang.org/x/tools)
- [Ruff Documentation](https://docs.astral.sh/ruff/)

---

**Happy coding with LazyVim! 🚀**