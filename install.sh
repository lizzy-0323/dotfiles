#!/bin/bash

# Dotfiles installation script for Mac
# This script sets up configurations for ideavim, vim, docker, and vscode

# Set colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Print section header
print_section() {
    echo -e "\n${BLUE}==>${NC} ${GREEN}$1${NC}"
}

# Print success message
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Print error message
print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Print info message
print_info() {
    echo -e "${YELLOW}i${NC} $1"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create directory if it doesn't exist
create_dir_if_not_exists() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        print_info "Created directory: $1"
    fi
}

# Backup file if it exists
backup_if_exists() {
    if [ -f "$1" ] || [ -d "$1" ]; then
        backup_name="$1.backup.$(date +%Y%m%d%H%M%S)"
        mv "$1" "$backup_name"
        print_info "Backed up $1 to $backup_name"
    fi
}

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This script is designed for macOS. Please run it on a Mac."
    exit 1
fi

print_section "Starting dotfiles installation"

# Install Homebrew if not already installed
if ! command_exists brew; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    print_success "Homebrew installed"
else
    print_info "Homebrew already installed, updating..."
    brew update
    print_success "Homebrew updated"
fi

# Install required packages
print_section "Installing required packages"
BREW_PACKAGES=("vim" "neovim" "docker" "docker-compose" "visual-studio-code")

for package in "${BREW_PACKAGES[@]}"; do
    if brew list "$package" &>/dev/null; then
        print_info "$package already installed, skipping"
    else
        print_info "Installing $package..."
        brew install "$package" || brew install --cask "$package"
        print_success "$package installed"
    fi
done

# Setup Vim configuration
print_section "Setting up Vim configuration"

# Vim setup
VIM_CONFIG_DIR="$HOME/.vim"
create_dir_if_not_exists "$VIM_CONFIG_DIR"

if [ -d "$SCRIPT_DIR/vim" ]; then
    print_info "Copying Vim configuration files..."
    
    # Backup existing .vimrc
    backup_if_exists "$HOME/.vimrc"
    
    # Copy vim configuration files
    cp -r "$SCRIPT_DIR/vim"/* "$VIM_CONFIG_DIR/"
    
    # Create symbolic link for .vimrc if it exists in the dotfiles
    if [ -f "$SCRIPT_DIR/vim/vimrc" ]; then
        ln -sf "$SCRIPT_DIR/vim/vimrc" "$HOME/.vimrc"
    fi
    
    print_success "Vim configuration set up"
else
    print_error "Vim configuration directory not found in dotfiles"
fi

# Setup Neovim configuration
print_section "Setting up Neovim configuration"

# Neovim setup
NEOVIM_CONFIG_DIR="$HOME/.config/nvim"
create_dir_if_not_exists "$NEOVIM_CONFIG_DIR"

if [ -d "$SCRIPT_DIR/neovim" ]; then
    print_info "Copying Neovim configuration files..."
    
    # Backup existing config
    backup_if_exists "$NEOVIM_CONFIG_DIR"
    
    # Copy neovim configuration files
    cp -r "$SCRIPT_DIR/neovim"/* "$NEOVIM_CONFIG_DIR/"
    
    print_success "Neovim configuration set up"
else
    print_error "Neovim configuration directory not found in dotfiles"
fi

# Setup IdeaVim configuration
print_section "Setting up IdeaVim configuration"

if [ -d "$SCRIPT_DIR/ideavim" ]; then
    print_info "Copying IdeaVim configuration files..."
    
    # Backup existing .ideavimrc
    backup_if_exists "$HOME/.ideavimrc"
    
    # Copy ideavim configuration
    if [ -f "$SCRIPT_DIR/ideavim/.ideavimrc" ]; then
        cp "$SCRIPT_DIR/ideavim/.ideavimrc" "$HOME/.ideavimrc"
    elif [ -f "$SCRIPT_DIR/ideavim/ideavimrc" ]; then
        cp "$SCRIPT_DIR/ideavim/ideavimrc" "$HOME/.ideavimrc"
    else
        print_error "IdeaVim configuration file not found"
    fi
    
    print_success "IdeaVim configuration set up"
else
    print_error "IdeaVim configuration directory not found in dotfiles"
fi

# Setup Docker configuration
print_section "Setting up Docker configuration"

# Docker setup
DOCKER_CONFIG_DIR="$HOME/.docker"
create_dir_if_not_exists "$DOCKER_CONFIG_DIR"

if [ -d "$SCRIPT_DIR/docker" ]; then
    print_info "Copying Docker configuration files..."
    
    # Backup existing config.json
    backup_if_exists "$DOCKER_CONFIG_DIR/config.json"
    
    # Copy docker configuration files
    if [ -f "$SCRIPT_DIR/docker/daemon.json" ]; then
        cp "$SCRIPT_DIR/docker/daemon.json" "$DOCKER_CONFIG_DIR/daemon.json"
    fi
    
    if [ -f "$SCRIPT_DIR/docker/config.json" ]; then
        cp "$SCRIPT_DIR/docker/config.json" "$DOCKER_CONFIG_DIR/config.json"
    fi
    
    print_success "Docker configuration set up"
else
    print_error "Docker configuration directory not found in dotfiles"
fi

# Setup VSCode configuration
print_section "Setting up VSCode configuration"

# VSCode setup
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
create_dir_if_not_exists "$VSCODE_CONFIG_DIR"

if [ -d "$SCRIPT_DIR/vscode" ]; then
    print_info "Copying VSCode configuration files..."
    
    # Backup existing settings.json and keybindings.json
    backup_if_exists "$VSCODE_CONFIG_DIR/settings.json"
    backup_if_exists "$VSCODE_CONFIG_DIR/keybindings.json"
    
    # Copy vscode configuration files
    if [ -f "$SCRIPT_DIR/vscode/settings.json" ]; then
        cp "$SCRIPT_DIR/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
    fi
    
    if [ -f "$SCRIPT_DIR/vscode/keybinding.json" ]; then
        cp "$SCRIPT_DIR/vscode/keybinding.json" "$VSCODE_CONFIG_DIR/keybindings.json"
    fi
    
    # Install VSCode extensions
    if command_exists code; then
        print_info "Installing VSCode extensions..."
        
        # Common VSCode extensions
        VSCODE_EXTENSIONS=(
            "vscodevim.vim"                # Vim emulation
            "ms-vscode.cpptools"          # C/C++ support
            "golang.go"                   # Go support
            "ms-python.python"            # Python support
            "zhuangtongfa.material-theme" # One Dark Pro theme
            "pkief.material-icon-theme"   # Material Icon Theme
        )
        
        for ext in "${VSCODE_EXTENSIONS[@]}"; do
            print_info "Installing VSCode extension: $ext"
            code --install-extension "$ext" || print_error "Failed to install $ext"
        done
        
        print_success "VSCode extensions installed"
    else
        print_error "VSCode command line tool not found. Extensions not installed."
        print_info "To enable the 'code' command, open VSCode, press Cmd+Shift+P, and run 'Shell Command: Install 'code' command in PATH'"
    fi
    
    print_success "VSCode configuration set up"
else
    print_error "VSCode configuration directory not found in dotfiles"
fi

# Setup ZSH configuration (if available)
if [ -d "$SCRIPT_DIR/zsh" ]; then
    print_section "Setting up ZSH configuration"
    
    # Backup existing .zshrc
    backup_if_exists "$HOME/.zshrc"
    
    # Copy zsh configuration
    if [ -f "$SCRIPT_DIR/zsh/.zshrc" ]; then
        cp "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
        print_success "ZSH configuration set up"
    elif [ -f "$SCRIPT_DIR/zsh/zshrc" ]; then
        cp "$SCRIPT_DIR/zsh/zshrc" "$HOME/.zshrc"
        print_success "ZSH configuration set up"
    else
        print_error "ZSH configuration file not found"
    fi
fi

print_section "Installation complete!"
print_info "You may need to restart your terminal or applications for all changes to take effect."
