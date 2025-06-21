# WSL-specific configurations

# Windows interop
export BROWSER="pwsh.exe /c start"

# WSL2 specific settings
if [[ $(uname -r) =~ WSL2 ]]; then
    # X11 forwarding for GUI apps
    export DISPLAY=$(ip route list default | awk '{print $3}'):0
    export LIBGL_ALWAYS_INDIRECT=1
fi

alias code="/mnt/c/Users/User/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"

# Config sync aliases for Windows app configurations
alias winsync="${HOME}/dotfiles/.config/wsl/config-sync"
alias ws="winsync"
alias wspull="winsync pull"
alias wspush="winsync push"
alias wsstatus="winsync status"
alias wsdiff="winsync diff"

/usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519
source $HOME/.keychain/$HOST-sh
