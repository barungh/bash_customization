#!/bin/bash

# =============================================================================
# Enhanced Bash Environment Setup Script
# =============================================================================
# This script sets up a comprehensive bash environment with modern tools
# and productivity enhancements on any Linux machine.
#
# Author: barungh
# Repository: https://github.com/barungh/bash_customization
# =============================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
GITHUB_REPO="https://raw.githubusercontent.com/barungh/bash_customization/main"
BACKUP_DIR="$HOME/.bash_backup_$(date +%Y%m%d_%H%M%S)"

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo -e "\n${PURPLE}=== $1 ===${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif command_exists lsb_release; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

# Create backup of existing files
backup_existing_files() {
    log_header "Creating Backup"

    mkdir -p "$BACKUP_DIR"

    for file in ~/.bashrc ~/.bash_aliases ~/.bash_functions ~/.bashrc.local; do
        if [ -f "$file" ]; then
            cp "$file" "$BACKUP_DIR/"
            log_info "Backed up $file to $BACKUP_DIR/"
        fi
    done

    log_success "Backup created at $BACKUP_DIR"
}

# =============================================================================
# PACKAGE INSTALLATION
# =============================================================================

install_packages_ubuntu_debian() {
    log_header "Installing Packages (Ubuntu/Debian)"

    # Update package list
    sudo apt update

    # Essential packages
    local packages=(
        # Build essentials
        "build-essential"
        "software-properties-common"
        "apt-transport-https"
        "ca-certificates"
        "gnupg"
        "lsb-release"

        # Archive tools
        "unzip"
        "zip"
        "tar"
        "gzip"
        "bzip2"
        "xz-utils"
        "p7zip-full"
        "unrar"

        # Development tools
        "git"
        "curl"
        "wget"
        "vim"
        "neovim"
        "tree"
        "htop"
        "neofetch"
        "fortune-mod"
        "cowsay"

        # Network tools
        "net-tools"
        "netstat-nat"
        "openssh-client"

        # Text processing
        "ripgrep"
        "fd-find"
        "bat"

        # System tools
        "autojump"
        "bash-completion"
    )

    for package in "${packages[@]}"; do
        if ! dpkg -l | grep -q "^ii  $package "; then
            log_info "Installing $package..."
            sudo apt install -y "$package" || log_warning "Failed to install $package"
        else
            log_info "$package is already installed"
        fi
    done

    # Install eza (modern ls replacement)
    install_eza_debian

    # Install Node.js LTS
    install_nodejs_debian
}

install_packages_fedora_rhel() {
    log_header "Installing Packages (Fedora/RHEL)"

    # Determine package manager
    local pkg_manager="dnf"
    if ! command_exists dnf; then
        pkg_manager="yum"
    fi

    # Essential packages
    local packages=(
        # Build essentials
        "gcc"
        "gcc-c++"
        "make"
        "kernel-devel"

        # Archive tools
        "unzip"
        "zip"
        "tar"
        "gzip"
        "bzip2"
        "xz"
        "p7zip"
        "unrar"

        # Development tools
        "git"
        "curl"
        "wget"
        "vim"
        "neovim"
        "tree"
        "htop"
        "neofetch"
        "fortune-mod"
        "cowsay"

        # Network tools
        "net-tools"
        "openssh-clients"

        # Text processing
        "ripgrep"
        "fd-find"
        "bat"

        # System tools
        "autojump"
        "bash-completion"
    )

    for package in "${packages[@]}"; do
        log_info "Installing $package..."
        sudo $pkg_manager install -y "$package" || log_warning "Failed to install $package"
    done

    # Install eza
    install_eza_fedora

    # Install Node.js LTS
    install_nodejs_fedora
}

install_packages_arch() {
    log_header "Installing Packages (Arch Linux)"

    # Update package database
    sudo pacman -Sy

    # Essential packages
    local packages=(
        # Build essentials
        "base-devel"

        # Archive tools
        "unzip"
        "zip"
        "tar"
        "gzip"
        "bzip2"
        "xz"
        "p7zip"
        "unrar"

        # Development tools
        "git"
        "curl"
        "wget"
        "vim"
        "neovim"
        "tree"
        "htop"
        "neofetch"
        "fortune-mod"
        "cowsay"

        # Network tools
        "net-tools"
        "openssh"

        # Text processing
        "ripgrep"
        "fd"
        "bat"
        "eza"

        # System tools
        "autojump"
        "bash-completion"

        # Node.js
        "nodejs"
        "npm"
    )

    for package in "${packages[@]}"; do
        log_info "Installing $package..."
        sudo pacman -S --noconfirm "$package" || log_warning "Failed to install $package"
    done
}

# Install eza for Debian/Ubuntu
install_eza_debian() {
    if ! command_exists eza; then
        log_info "Installing eza..."

        # Add GPG key and repository
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

        sudo apt update
        sudo apt install -y eza

        log_success "eza installed successfully"
    else
        log_info "eza is already installed"
    fi
}

# Install eza for Fedora/RHEL
install_eza_fedora() {
    if ! command_exists eza; then
        log_info "Installing eza from GitHub releases..."

        local latest_url=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep "browser_download_url.*x86_64-unknown-linux-gnu.tar.gz" | cut -d '"' -f 4)

        if [ -n "$latest_url" ]; then
            wget -O /tmp/eza.tar.gz "$latest_url"
            sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin/ --strip-components=1 eza
            sudo chmod +x /usr/local/bin/eza
            rm /tmp/eza.tar.gz
            log_success "eza installed successfully"
        else
            log_warning "Failed to get eza download URL"
        fi
    else
        log_info "eza is already installed"
    fi
}

# Install Node.js LTS for Debian/Ubuntu
install_nodejs_debian() {
    if ! command_exists node; then
        log_info "Installing Node.js LTS..."

        # Install NodeSource repository
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs

        log_success "Node.js $(node --version) and npm $(npm --version) installed"
    else
        log_info "Node.js $(node --version) is already installed"
    fi
}

# Install Node.js LTS for Fedora/RHEL
install_nodejs_fedora() {
    if ! command_exists node; then
        log_info "Installing Node.js LTS..."

        # Install NodeSource repository
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
        sudo dnf install -y nodejs || sudo yum install -y nodejs

        log_success "Node.js $(node --version) and npm $(npm --version) installed"
    else
        log_info "Node.js $(node --version) is already installed"
    fi
}

# =============================================================================
# FZF INSTALLATION
# =============================================================================

install_fzf() {
    log_header "Installing FZF (Fuzzy Finder)"

    if [ -d "$HOME/.fzf" ]; then
        log_info "FZF directory exists, updating..."
        cd "$HOME/.fzf" && git pull
    else
        log_info "Cloning FZF from GitHub..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    fi

    # Install FZF
    log_info "Installing FZF..."
    "$HOME/.fzf/install" --all --no-update-rc

    # Verify installation
    if [ -f "$HOME/.fzf/bin/fzf" ]; then
        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.fzf/bin:"* ]]; then
            export PATH="$HOME/.fzf/bin:$PATH"
        fi

        log_success "FZF installed successfully"
        log_info "FZF version: $($HOME/.fzf/bin/fzf --version)"
        log_info "FZF path: $HOME/.fzf/bin/fzf"
    else
        log_error "FZF installation failed"
        return 1
    fi
}

# =============================================================================
# STARSHIP PROMPT INSTALLATION
# =============================================================================

install_starship() {
    log_header "Installing Starship Prompt"

    if command_exists starship; then
        log_info "Starship is already installed: $(starship --version)"
        return 0
    fi

    log_info "Installing Starship prompt..."

    # Download and install starship
    curl -sS https://starship.rs/install.sh | sh -s -- --yes

    # Verify installation
    if command_exists starship; then
        log_success "Starship installed successfully"
        log_info "Starship version: $(starship --version)"
        log_info "Starship path: $(which starship)"
    else
        log_warning "Starship installation may have failed, but continuing..."
    fi
}

# =============================================================================
# CONFIGURATION DEPLOYMENT
# =============================================================================

download_bashrc() {
    log_header "Downloading Enhanced .bashrc"

    local bashrc_url="$GITHUB_REPO/.bashrc"

    log_info "Downloading .bashrc from $bashrc_url"

    if curl -fsSL "$bashrc_url" -o "$HOME/.bashrc.new"; then
        # Backup existing .bashrc if it exists
        if [ -f "$HOME/.bashrc" ]; then
            cp "$HOME/.bashrc" "$BACKUP_DIR/.bashrc.original"
        fi

        # Install new .bashrc
        mv "$HOME/.bashrc.new" "$HOME/.bashrc"
        log_success ".bashrc installed successfully"
    else
        log_error "Failed to download .bashrc from GitHub"
        log_info "Creating .bashrc from local template..."
        create_bashrc_local
    fi
}

create_bashrc_local() {
    log_info "Creating enhanced .bashrc locally..."

    # If download fails, we'll create a basic version with the essential features
    cat > "$HOME/.bashrc" << 'EOF'
# ~/.bashrc: executed by bash(1) for non-login shells.
# Enhanced version with productivity features

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# =============================================================================
# HISTORY CONFIGURATION
# =============================================================================
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s cmdhist
HISTTIMEFORMAT='%F %T '
HISTIGNORE='ls:ll:la:cd:pwd:exit:clear:history'

# =============================================================================
# SHELL OPTIONS
# =============================================================================
shopt -s checkwinsize
shopt -s globstar
shopt -s nocaseglob
shopt -s cdspell
shopt -s dirspell
shopt -s extglob
shopt -s autocd

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================
if command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim'
    export VISUAL='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR='vim'
    export VISUAL='vim'
else
    export EDITOR='nano'
    export VISUAL='nano'
fi

export PAGER='less'
export LESS='-R -M -S -i -J --mouse'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# =============================================================================
# ENHANCED ALIASES
# =============================================================================
# Smart ls aliases - use eza if available
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --group-directories-first'
    alias ll='eza -la --group-directories-first'
    alias la='eza -a --group-directories-first'
    alias l='eza --group-directories-first'
    alias tree='eza --tree --color=auto'
else
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Smart cat alias - use bat if available
if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
elif command -v batcat >/dev/null 2>&1; then
    alias cat='batcat'
    alias bat='batcat'
fi

# Git aliases
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gs='git status'
alias gp='git push'
alias gpl='git pull'

# System shortcuts
alias c='clear'
alias h='history'
alias grep='grep --color=auto'

# =============================================================================
# STARSHIP PROMPT
# =============================================================================
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# =============================================================================
# FZF INTEGRATION
# =============================================================================
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Enhanced directory search with fzf
if command -v fzf >/dev/null 2>&1; then
    fzf-cd() {
        local dir
        dir=$(find . -type d -not -path "*/\.git/*" 2>/dev/null | fzf --preview 'ls -la {}') && cd "$dir"
    }
    alias cf='fzf-cd'
fi

# Load custom configurations
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_functions ] && . ~/.bash_functions
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

# Welcome message
if [ -t 0 ]; then
    echo -e "\n🎉 Enhanced Bash Environment Loaded!"
    echo -e "💡 Type 'cheat' or 'bashhelp' to see available commands!"
fi
EOF

    log_success "Basic enhanced .bashrc created"
}

# =============================================================================
# VERIFICATION AND TESTING
# =============================================================================

verify_installation() {
    log_header "Verifying Installation"

    local all_good=true

    # Check essential commands
    local commands=("git" "curl" "wget" "vim" "tree" "htop")
    for cmd in "${commands[@]}"; do
        if command_exists "$cmd"; then
            log_success "✓ $cmd is available"
        else
            log_warning "✗ $cmd is not available"
            all_good=false
        fi
    done

    # Check modern tools
    local modern_tools=("eza" "bat" "rg" "fzf" "starship")
    for tool in "${modern_tools[@]}"; do
        if command_exists "$tool"; then
            log_success "✓ $tool is available"
            case $tool in
                "eza") log_info "  Version: $(eza --version | head -n1)" ;;
                "bat") log_info "  Version: $(bat --version | head -n1)" ;;
                "rg") log_info "  Version: $(rg --version | head -n1)" ;;
                "fzf") log_info "  Version: $(fzf --version)" ;;
                "starship") log_info "  Version: $(starship --version)" ;;
            esac
        else
            log_warning "✗ $tool is not available"
        fi
    done

    # Check FZF specifically
    if [ -f "$HOME/.fzf/bin/fzf" ]; then
        log_success "✓ FZF is installed at $HOME/.fzf/bin/fzf"
        log_info "  Version: $($HOME/.fzf/bin/fzf --version)"
        log_info "  Path: $HOME/.fzf/bin/fzf"
    else
        log_warning "✗ FZF binary not found at expected location"
    fi

    # Check Node.js
    if command_exists node && command_exists npm; then
        log_success "✓ Node.js $(node --version) and npm $(npm --version) are available"
    else
        log_warning "✗ Node.js or npm not available"
    fi

    # Check .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        log_success "✓ .bashrc is installed"
        log_info "  Size: $(wc -l < "$HOME/.bashrc") lines"
    else
        log_error "✗ .bashrc not found"
        all_good=false
    fi

    if $all_good; then
        log_success "🎉 All essential components are installed!"
    else
        log_warning "⚠️  Some components may need manual attention"
    fi
}

create_cheatsheet() {
    log_header "Creating Bash Cheatsheet"

    cat > "$HOME/.bash_cheatsheet.md" << 'EOF'
# 🚀 Enhanced Bash Environment Cheatsheet

## 📁 Navigation
- `..`, `...`, `....` - Go up 1, 2, 3 directories
- `cf` - Fuzzy find and change to directory (requires fzf)
- `mkcd <dir>` - Create and enter directory

## 📋 File Operations
- `ll`, `la`, `l` - Enhanced ls with eza (if available)
- `lt` - List files sorted by time
- `lS` - List files sorted by size
- `tree` - Tree view (eza or tree)
- `extract <file>` - Extract any archive format
- `backup <file>` - Quick backup (adds .bak extension)

## 🔍 Search & Find
- `ff <name>` - Find files by name
- `fd <name>` - Find directories by name
- `psgrep <process>` - Search for processes
- `rg <pattern>` - Ripgrep search (if available)

## 📊 System Info
- `dus` - Disk usage of current directory
- `top10` - Show most used commands
- `weather [city]` - Get weather info
- `serve [port]` - Start HTTP server (default: 8000)

## 🔧 Git Shortcuts
- `g` - git
- `ga` - git add
- `gaa` - git add .
- `gc` - git commit
- `gcm` - git commit -m
- `gs` - git status
- `gp` - git push
- `gpl` - git pull
- `gd` - git diff
- `gl` - git log --oneline

## 🛠️ Utilities
- `genpass [length]` - Generate random password
- `c` - clear
- `h` - history
- `path` - Show PATH variable
- `now` - Current time
- `nowdate` - Current date

## 🎨 Modern Tools
- `bat` - Better cat with syntax highlighting
- `eza` - Better ls with colors and icons
- `rg` - Faster grep replacement
- `fzf` - Fuzzy finder
- `starship` - Modern prompt

## 📝 Quick Edits
- `bashrc` - Edit and reload .bashrc
- `vimrc` - Edit .vimrc
- `nvimrc` - Edit neovim config

Type `cheat` or `bashhelp` to see this cheatsheet anytime!
EOF

    log_success "Cheatsheet created at ~/.bash_cheatsheet.md"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    log_header "Enhanced Bash Environment Setup"
    echo -e "${CYAN}This script will set up a comprehensive bash environment with modern tools.${NC}"
    echo -e "${YELLOW}Please ensure you have sudo privileges before continuing.${NC}\n"

    # Detect distribution
    local distro=$(detect_distro)
    log_info "Detected distribution: $distro"

    # Confirm with user
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup cancelled by user"
        exit 0
    fi

    # Create backup
    backup_existing_files

    # Install packages based on distribution
    case $distro in
        "ubuntu"|"debian"|"pop"|"mint")
            install_packages_ubuntu_debian
            ;;
        "fedora"|"rhel"|"centos"|"rocky"|"almalinux")
            install_packages_fedora_rhel
            ;;
        "arch"|"manjaro"|"endeavouros")
            install_packages_arch
            ;;
        *)
            log_warning "Unsupported distribution: $distro"
            log_info "Attempting generic installation..."
            install_packages_ubuntu_debian  # Fallback to apt-based
            ;;
    esac

    # Install FZF
    install_fzf

    # Install Starship
    install_starship

    # Download and install .bashrc
    download_bashrc

    # Create cheatsheet
    create_cheatsheet

    # Verify installation
    verify_installation

    # Final instructions
    log_header "Setup Complete!"
    echo -e "${GREEN}🎉 Your enhanced bash environment is ready!${NC}\n"
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "1. ${CYAN}source ~/.bashrc${NC} or restart your terminal"
    echo -e "2. Type ${CYAN}cheat${NC} to see available commands"
    echo -e "3. Enjoy your enhanced bash experience!\n"

    echo -e "${BLUE}Backup location:${NC} $BACKUP_DIR"
    echo -e "${BLUE}Repository:${NC} https://github.com/barungh/bash_customization"

    log_info "Setup completed successfully!"
}

# Run main function if script is executed directly or piped from curl
if [[ "${BASH_SOURCE[0]:-$0}" == "${0}" ]] || [[ "${0}" == "bash" ]]; then
    main "$@"
fi
