#!/bin/bash
# Arch Linux Dev Setup
# Installs: jq, neovim, docker, kubectl, nodejs, git, ripgrep, fd, fzf, go, python, lazygit, lazydocker, brave-bin, tmux

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Starting Arch Linux Environment Setup...${NC}"

# 1. Helper Functions
# -----------------------------------------------------------

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install official pacman packages if missing
install_pacman() {
    PACKAGE=$1
    CMD=${2:-$PACKAGE} # If 2nd arg provided, use it as command name, else use package name

    if command_exists "$CMD"; then
        echo -e "${YELLOW}⏭️  $PACKAGE is already installed. Skipping.${NC}"
    else
        echo -e "${GREEN}📦 Installing $PACKAGE...${NC}"
        sudo pacman -S --noconfirm "$PACKAGE"
    fi
}

# Function to install AUR packages if missing
install_aur() {
    PACKAGE=$1
    CMD=${2:-$PACKAGE}

    if pacman -Qi "$PACKAGE" &> /dev/null || command_exists "$CMD"; then
        echo -e "${YELLOW}⏭️  $PACKAGE (AUR) is already installed. Skipping.${NC}"
    else
        echo -e "${GREEN}📦 Installing $PACKAGE from AUR...${NC}"
        yay -S --noconfirm "$PACKAGE"
    fi
}

# 2. System Update & Prerequisites
# -----------------------------------------------------------
echo -e "${BLUE}🔄 Updating repositories...${NC}"
sudo pacman -Sy

# Ensure base-devel and git are installed (needed for AUR)
install_pacman base-devel make
install_pacman git

# Install Yay (AUR Helper) if not present
if ! command_exists yay; then
    echo -e "${BLUE}📦 Installing yay...${NC}"
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    echo -e "${YELLOW}⏭️  yay is already installed.${NC}"
fi

# 3. Install Official Packages
# -----------------------------------------------------------
echo -e "${BLUE}🛠️  Installing Official Packages...${NC}"

install_pacman neovim nvim
install_pacman tmux
install_pacman jq
install_pacman ripgrep rg
install_pacman fd
install_pacman fzf
install_pacman docker
install_pacman kubectl
install_pacman nodejs node
install_pacman npm
install_pacman go
install_pacman python
install_pacman lazygit

# 4. Install AUR Packages
# -----------------------------------------------------------
echo -e "${BLUE}🦄 Installing AUR Packages...${NC}"

install_aur lazydocker
install_aur brave-bin brave

# 5. Post-Install Configuration (Docker)
# -----------------------------------------------------------
echo -e "${BLUE}🐳 Configuring Docker...${NC}"

# Enable Docker service if not enabled
if ! systemctl is-active --quiet docker; then
    echo "Starting Docker service..."
    sudo systemctl enable --now docker
else
    echo -e "${YELLOW}⏭️  Docker service is already running.${NC}"
fi

# Add user to docker group if not already added
if ! groups "$USER" | grep -q docker; then
    echo "Adding $USER to docker group..."
    sudo usermod -aG docker "$USER"
    echo -e "${YELLOW}⚠️  You will need to log out and back in for Docker group changes to take effect.${NC}"
else
    echo -e "${YELLOW}⏭️  User already in docker group.${NC}"
fi

# 6. Completion
# -----------------------------------------------------------
echo -e "${GREEN}✅ Setup Complete!${NC}"
