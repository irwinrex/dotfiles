#!/bin/bash
# macOS Dev Setup
# Installs: jq, neovim, docker, kubectl, nodejs, git, ripgrep, fd, fzf, go, python, lazygit, lazydocker, brave, tmux

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🍎 Starting macOS Environment Setup...${NC}"

# 1. Check/Install Homebrew
# -----------------------------------------------------------
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}📦 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Setup Path for Apple Silicon (M1/M2/M3)
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo -e "${YELLOW}⏭️  Homebrew is already installed.${NC}"
fi

# Ensure brew is up to date
echo -e "${BLUE}🔄 Updating Homebrew...${NC}"
brew update

# 2. Helper Functions
# -----------------------------------------------------------

# Function to install CLI formulas
install_brew() {
    PACKAGE=$1
    
    if brew list --formula "$PACKAGE" &> /dev/null; then
        echo -e "${YELLOW}⏭️  $PACKAGE is already installed. Skipping.${NC}"
    else
        echo -e "${GREEN}📦 Installing $PACKAGE...${NC}"
        brew install "$PACKAGE"
    fi
}

# Function to install GUI Apps (Casks)
install_cask() {
    APP_NAME=$1
    
    if brew list --cask "$APP_NAME" &> /dev/null; then
        echo -e "${YELLOW}⏭️  $APP_NAME is already installed. Skipping.${NC}"
    else
        echo -e "${GREEN}🖥️  Installing $APP_NAME...${NC}"
        brew install --cask "$APP_NAME"
    fi
}

# 3. Install CLI Tools
# -----------------------------------------------------------
echo -e "${BLUE}🛠️  Installing CLI Tools...${NC}"

install_brew git
install_brew neovim
install_brew tmux
install_brew jq
install_brew ripgrep
install_brew fd
install_brew fzf
install_brew kubernetes-cli # This is kubectl
install_brew node
install_brew go
install_brew python
install_brew lazygit
install_brew lazydocker

# 4. Install GUI Applications (Casks)
# -----------------------------------------------------------
echo -e "${BLUE}🦄 Installing Applications...${NC}"

install_cask docker         # Installs Docker Desktop
install_cask brave-browser  # Installs Brave

# 5. Post-Install Setup
# -----------------------------------------------------------
echo -e "${BLUE}⚙️  Performing Post-Install configuration...${NC}"

# FZF keybindings (optional, checks if user wants it)
if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    echo -e "${YELLOW}ℹ️  To enable FZF keybindings (Ctrl+R, Ctrl+T), run:${NC}"
    echo "   $(brew --prefix)/opt/fzf/install"
fi

echo -e "${GREEN}✅ Setup Complete!${NC}"
echo -e "${YELLOW}⚠️  Note: You must launch 'Docker' from your Applications folder manually to start the Docker daemon.${NC}"
