# 🚀 Enhanced Bash Environment Setup

A comprehensive shell script that transforms any Linux machine into a productivity powerhouse with modern command-line tools and an enhanced bash configuration.

## ✨ Features

### 🛠️ **Essential Packages**
- **Build Tools**: gcc, make, build-essential
- **Archive Tools**: unzip, zip, tar, 7z, unrar
- **Development**: git, vim, neovim, curl, wget
- **System Tools**: htop, tree, net-tools, bash-completion

### 🎨 **Modern CLI Tools**
- **[eza](https://github.com/eza-community/eza)**: Modern replacement for `ls` with colors and icons
- **[bat](https://github.com/sharkdp/bat)**: Better `cat` with syntax highlighting
- **[ripgrep](https://github.com/BurntSushi/ripgrep)**: Ultra-fast grep alternative
- **[fzf](https://github.com/junegunn/fzf)**: Fuzzy finder for files and directories
- **[starship](https://starship.rs/)**: Fast, customizable prompt

### 🔧 **Node.js Development**
- **Node.js LTS**: Latest stable version
- **npm**: Package manager included

### 📋 **Enhanced .bashrc Features**
- **Smart History**: Large history with deduplication and timestamps
- **Intelligent Aliases**: Context-aware shortcuts that use modern tools when available
- **Git Integration**: Branch status in prompt + comprehensive git aliases
- **Productivity Functions**: Extract archives, weather info, password generation
- **FZF Integration**: Fuzzy directory navigation
- **Safety Features**: Interactive prompts for destructive operations

## 🚀 Quick Start

### One-Line Installation

```bash
# Direct installation
curl -fsSL https://raw.githubusercontent.com/barungh/bash_customization/master/setup-bash-environment.sh | bash

# Or using the installer wrapper
curl -fsSL https://raw.githubusercontent.com/barungh/bash_customization/master/install.sh | bash
```

### Manual Installation

1. **Clone or download the script:**
   ```bash
   wget https://raw.githubusercontent.com/barungh/bash_customization/master/setup-bash-environment.sh
   chmod +x setup-bash-environment.sh
   ```

2. **Run the setup:**
   ```bash
   ./setup-bash-environment.sh
   ```

3. **Reload your shell:**
   ```bash
   source ~/.bashrc
   # or restart your terminal
   ```

## 🐧 Supported Distributions

- **Ubuntu/Debian** (and derivatives like Pop!_OS, Linux Mint)
- **Fedora/RHEL/CentOS** (and derivatives like Rocky Linux, AlmaLinux)
- **Arch Linux** (and derivatives like Manjaro, EndeavourOS)

## 📦 What Gets Installed

### Package Managers Used
- **apt** (Ubuntu/Debian)
- **dnf/yum** (Fedora/RHEL)
- **pacman** (Arch Linux)

### Special Installations
- **FZF**: Cloned from GitHub and installed to `~/.fzf/`
- **Starship**: Downloaded from official installer
- **eza**: Added from official repositories or GitHub releases
- **Node.js**: Installed via NodeSource repositories

## 🔍 FZF Installation Details

The script addresses common FZF installation issues by:
- Cloning the latest version directly from GitHub
- Installing to `~/.fzf/` directory
- Adding to PATH automatically
- Verifying installation with version check
- Providing clear path confirmation

## 🛡️ Safety Features

- **Automatic Backup**: Creates timestamped backup of existing configurations
- **Non-destructive**: Preserves existing files before modification
- **Verification**: Checks installation success for all components
- **Fallback**: Creates local .bashrc if GitHub download fails

## 📚 Usage Examples

After installation, you'll have access to powerful aliases and functions:

```bash
# Modern file listing
ll              # Enhanced ls with eza
tree            # Tree view with colors

# Fuzzy finding
cf              # Fuzzy find and change directory
fzf             # Interactive file finder

# Git shortcuts
gs              # git status
gaa             # git add .
gcm "message"   # git commit -m "message"

# Utilities
extract file.tar.gz    # Extract any archive
weather london         # Get weather info
serve 8080            # Start HTTP server
genpass 16            # Generate secure password

# Quick help
cheat             # Show command cheatsheet
```

## 🔧 Customization

The script creates several files for easy customization:

- `~/.bashrc` - Main configuration
- `~/.bash_aliases` - Custom aliases (auto-loaded)
- `~/.bash_functions` - Custom functions (auto-loaded)
- `~/.bashrc.local` - Local machine-specific config
- `~/.bash_cheatsheet.md` - Command reference

## 🐛 Troubleshooting

### Arch Linux Hanging Issue
If the script appears to hang on Arch Linux after detecting the distribution, it's likely waiting for user input. The script now auto-detects when it's being piped from curl and proceeds automatically. If you still encounter issues:

```bash
# Download and run manually
wget https://raw.githubusercontent.com/barungh/bash_customization/master/setup-bash-environment.sh
chmod +x setup-bash-environment.sh
./setup-bash-environment.sh
```

### FZF Issues
If FZF doesn't work after installation:
```bash
# Check if FZF is in PATH
echo $PATH | grep fzf

# Manually add to PATH
export PATH="$HOME/.fzf/bin:$PATH"

# Reload bash configuration
source ~/.bashrc
```

### Permission Issues
If you encounter permission errors:
```bash
# Make sure you have sudo privileges
sudo -v

# Re-run the script
./setup-bash-environment.sh
```

### Package Installation Failures
Some packages might fail on certain distributions. The script continues with warnings, and you can manually install missing packages later.

## 📁 File Structure

```
~/.bash_backup_YYYYMMDD_HHMMSS/  # Backup directory
~/.bashrc                        # Enhanced bash configuration
~/.bash_cheatsheet.md           # Command reference
~/.fzf/                         # FZF installation
~/.bash_aliases                 # Custom aliases (optional)
~/.bash_functions              # Custom functions (optional)
~/.bashrc.local               # Local configuration (optional)
```

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Made with ❤️ for the command-line enthusiasts**
