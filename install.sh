#!/bin/bash

set -e

DOTFILES_DIR="${HOME}/dotfiles"
REQUIRED_COMMANDS=("git" "curl" "make")

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_info() { echo -e "${YELLOW}→${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version; then
            echo "wsl"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

install_homebrew() {
    if check_command brew; then
        log_success "Homebrew already installed"
        return 0
    fi

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH based on OS
    case "$(detect_os)" in
        "linux"|"wsl")
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            ;;
        "macos")
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
            ;;
    esac

    log_success "Homebrew installed"
}

install_sheldon() {
    if check_command sheldon; then
        log_success "Sheldon already installed"
        return 0
    fi

    log_info "Installing Sheldon..."
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
        | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin

    # Add to PATH if not already present
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "${HOME}/.zprofile"
        export PATH="$HOME/.local/bin:$PATH"
    fi

    log_success "Sheldon installed"
}

clone_dotfiles() {
    if [ -d "$DOTFILES_DIR" ]; then
        log_success "Dotfiles directory already exists"
        return 0
    fi

    log_info "Cloning dotfiles repository..."
    git clone https://github.com/ktakabay/dotfiles.git "$DOTFILES_DIR"
    log_success "Dotfiles cloned"
}

setup_zsh() {
    if [ "$SHELL" = "$(which zsh)" ]; then
        log_success "ZSH is already the default shell"
        return 0
    fi

    if check_command zsh; then
        log_info "Setting ZSH as default shell..."
        chsh -s "$(which zsh)"
        log_success "ZSH set as default shell"
    else
        log_error "ZSH not found. It will be installed via Homebrew."
    fi
}

main() {
    echo "🚀 Starting dotfiles setup..."
    echo

    # Check OS
    OS=$(detect_os)
    log_info "Detected OS: $OS"

    # Check required commands
    log_info "Checking required commands..."
    for cmd in "${REQUIRED_COMMANDS[@]}"; do
        if check_command "$cmd"; then
            log_success "$cmd found"
        else
            log_error "$cmd not found. Please install $cmd first."
            exit 1
        fi
    done

    # Install prerequisites
    install_homebrew
    install_sheldon

    # Clone dotfiles if needed
    if [ ! -d "$DOTFILES_DIR" ]; then
        clone_dotfiles
    fi

    # Run make all
    log_info "Running dotfiles setup..."
    cd "$DOTFILES_DIR"
    make all
    log_success "Dotfiles setup completed"

    # Additional setup
    setup_zsh

    # WSL-specific setup
    if [ "$OS" = "wsl" ]; then
        log_info "Running WSL-specific setup..."
        if [ -f "${DOTFILES_DIR}/windows_config/link.sh" ]; then
            "${DOTFILES_DIR}/windows_config/link.sh"
            log_success "Windows config linked"
        fi
    fi

    echo
    echo "✨ Setup complete!"
    echo
    echo "Next steps:"
    echo "1. Restart your terminal or run: exec zsh"
    echo "2. Configure Powerlevel10k by running: p10k configure"
    echo "3. Run mise to set up runtime versions: mise install"
}

main "$@"