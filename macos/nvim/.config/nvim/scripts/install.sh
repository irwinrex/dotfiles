#!/bin/bash
# Universal LazyVim Development Environment Installer
# Auto-detects OS and runs appropriate installation script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Universal LazyVim Development Environment Installer${NC}"
echo -e "${BLUE}Auto-detecting your operating system...${NC}"

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$NAME
            DISTRO=$ID
        elif type lsb_release >/dev/null 2>&1; then
            OS=$(lsb_release -si)
            DISTRO=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
        elif [ -f /etc/lsb-release ]; then
            . /etc/lsb-release
            OS=$DISTRIB_ID
            DISTRO=$(echo $DISTRIB_ID | tr '[:upper:]' '[:lower:]')
        else
            OS=$(uname -s)
            DISTRO="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        DISTRO="macos"
    elif [[ "$OSTYPE" == "msys" ]]; then
        OS="Windows"
        DISTRO="windows"
    else
        OS=$(uname -s)
        DISTRO="unknown"
    fi
}

# Download script from GitHub or use local file
download_and_run() {
    local script_name=$1
    local script_url="https://raw.githubusercontent.com/yourusername/lazyvim-setup/main/${script_name}"
    
    echo -e "${BLUE}📥 Downloading ${script_name}...${NC}"
    
    # Try to download from GitHub first, fall back to local file
    if command -v curl >/dev/null 2>&1; then
        if curl -fsSL "$script_url" -o "/tmp/${script_name}" 2>/dev/null; then
            chmod +x "/tmp/${script_name}"
            "/tmp/${script_name}"
            rm "/tmp/${script_name}"
            return 0
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget -q "$script_url" -O "/tmp/${script_name}" 2>/dev/null; then
            chmod +x "/tmp/${script_name}"
            "/tmp/${script_name}"
            rm "/tmp/${script_name}"
            return 0
        fi
    fi
    
    # Fall back to local file
    if [ -f "${script_name}" ]; then
        echo -e "${YELLOW}📁 Using local ${script_name}${NC}"
        chmod +x "${script_name}"
        "./${script_name}"
    else
        echo -e "${RED}❌ Could not download or find ${script_name}${NC}"
        echo -e "${YELLOW}Please download the appropriate script manually:${NC}"
        echo -e "  ${CYAN}${script_url}${NC}"
        exit 1
    fi
}

# Main installation logic
main() {
    detect_os
    
    echo -e "${CYAN}Detected OS: ${OS}${NC}"
    echo -e "${CYAN}Distribution: ${DISTRO}${NC}"
    echo ""
    
    case "$DISTRO" in
        "arch" | "archlinux" | "manjaro")
            echo -e "${BLUE}🏗️  Installing for Arch Linux...${NC}"
            download_and_run "install-arch.sh"
            ;;
        "ubuntu" | "debian" | "linuxmint" | "pop")
            echo -e "${BLUE}🏗️  Installing for Ubuntu/Debian...${NC}"
            download_and_run "install-ubuntu.sh"
            ;;
        "alpine")
            echo -e "${BLUE}🏗️  Installing for Alpine Linux...${NC}"
            echo -e "${YELLOW}⚠️  Alpine installation requires root privileges${NC}"
            download_and_run "install-alpine.sh"
            ;;
        "macos")
            echo -e "${BLUE}🏗️  Installing for macOS...${NC}"
            download_and_run "install-macos.sh"
            ;;
        "windows")
            echo -e "${RED}❌ Windows detected but this script is for Unix-like systems${NC}"
            echo -e "${YELLOW}Please run install-windows.ps1 in PowerShell as Administrator${NC}"
            echo -e "${CYAN}Download: https://raw.githubusercontent.com/yourusername/lazyvim-setup/main/install-windows.ps1${NC}"
            exit 1
            ;;
        *)
            echo -e "${YELLOW}⚠️  Unknown or unsupported distribution: ${DISTRO}${NC}"
            echo -e "${BLUE}Available installation scripts:${NC}"
            echo -e "  ${CYAN}install-arch.sh${NC}     - Arch Linux, Manjaro"
            echo -e "  ${CYAN}install-ubuntu.sh${NC}   - Ubuntu, Debian, Linux Mint"
            echo -e "  ${CYAN}install-alpine.sh${NC}   - Alpine Linux"
            echo -e "  ${CYAN}install-macos.sh${NC}    - macOS"
            echo -e "  ${CYAN}install-windows.ps1${NC} - Windows (PowerShell)"
            echo ""
            echo -e "${YELLOW}Please run the appropriate script manually for your system.${NC}"
            exit 1
            ;;
    esac
}

# Check if we're on Windows (Git Bash, WSL, etc.)
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ -n "$WINDIR" ]]; then
    echo -e "${RED}❌ Windows environment detected${NC}"
    echo -e "${YELLOW}This script is for Unix-like systems. For Windows:${NC}"
    echo -e "${BLUE}1. Open PowerShell as Administrator${NC}"
    echo -e "${BLUE}2. Run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser${NC}"
    echo -e "${BLUE}3. Download and run install-windows.ps1${NC}"
    echo ""
    echo -e "${CYAN}PowerShell script: https://raw.githubusercontent.com/yourusername/lazyvim-setup/main/install-windows.ps1${NC}"
    exit 1
fi

# Check for required tools
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    echo -e "${RED}❌ Neither curl nor wget found${NC}"
    echo -e "${YELLOW}Please install curl or wget to download installation scripts${NC}"
    exit 1
fi

# Run main installation
main

echo -e "${GREEN}✅ Installation process completed!${NC}"
echo -e "${YELLOW}📝 Please restart your terminal to ensure all tools are available${NC}"
echo -e "${BLUE}🚀 You can now enjoy LazyVim with full language support!${NC}"