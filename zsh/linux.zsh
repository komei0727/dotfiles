# Linux-specific configurations

# Linux-specific aliases
alias open="xdg-open"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

# systemd aliases (if systemd is available)
if command -v systemctl &> /dev/null; then
    alias sc="systemctl"
    alias scu="systemctl --user"
    alias jc="journalctl"
    alias jcu="journalctl --user"
fi

# Package manager aliases
if command -v apt &> /dev/null; then
    # Debian/Ubuntu
    alias apt-update="sudo apt update && sudo apt upgrade"
    alias apt-search="apt search"
    alias apt-install="sudo apt install"
elif command -v dnf &> /dev/null; then
    # Fedora
    alias dnf-update="sudo dnf upgrade"
    alias dnf-search="dnf search"
    alias dnf-install="sudo dnf install"
elif command -v pacman &> /dev/null; then
    # Arch
    alias pac-update="sudo pacman -Syu"
    alias pac-search="pacman -Ss"
    alias pac-install="sudo pacman -S"
fi

# Linux performance monitoring
alias htop="htop"
alias iotop="sudo iotop"