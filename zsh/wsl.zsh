# WSL-specific configurations

# Windows interop
export BROWSER="pwsh.exe /c start"

# WSL2 specific settings
if [[ $(uname -r) =~ WSL2 ]]; then
    # X11 forwarding for GUI apps
    export DISPLAY=$(ip route list default | awk '{print $3}'):0
    export LIBGL_ALWAYS_INDIRECT=1
fi

# Windows paths integration
alias explorer="explorer.exe"
alias code="code.exe"
alias notepad="notepad.exe"

# WSL utilities
alias wsl="wsl.exe"
alias pwsh="pwsh.exe"
alias cmd="cmd.exe"

# Clipboard integration
alias pbcopy="clip.exe"
alias pbpaste="powershell.exe -command 'Get-Clipboard' | tr -d '\r'"

# Open Windows file explorer in current directory
open() {
    if [ $# -eq 0 ]; then
        explorer.exe .
    else
        explorer.exe "$@"
    fi
}

# Convert between WSL and Windows paths
wslpath() {
    /mnt/c/Windows/System32/wsl.exe wslpath "$@"
}