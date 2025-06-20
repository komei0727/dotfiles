# macOS-specific configurations
export CLICOLOR=1
export TERM=xterm-256color


(( ${+commands[gdate]} )) && alias date='gdate'
(( ${+commands[gls]} )) && alias ls='gls'
(( ${+commands[gmkdir]} )) && alias mkdir='gmkdir'
(( ${+commands[gcp]} )) && alias cp='gcp'
(( ${+commands[gmv]} )) && alias mv='gmv'
(( ${+commands[grm]} )) && alias rm='grm'
(( ${+commands[gdu]} )) && alias du='gdu'
(( ${+commands[ghead]} )) && alias head='ghead'
(( ${+commands[gtail]} )) && alias tail='gtail'
(( ${+commands[gsed]} )) && alias sed='gsed'
(( ${+commands[ggrep]} )) && alias grep='ggrep'
(( ${+commands[gfind]} )) && alias find='gfind'
(( ${+commands[gdirname]} )) && alias dirname='gdirname'
(( ${+commands[gxargs]} )) && alias xargs='gxargs'

# macOS aliases
alias ls="ls -G"  # Enable colorized output
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

# Homebrew paths (Apple Silicon vs Intel)
if [[ -f /opt/homebrew/bin/brew ]]; then
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    # Intel
    eval "$(/usr/local/bin/brew shellenv)"
fi

# macOS specific commands
alias update="brew update && brew upgrade && brew cleanup"
alias cleanup="brew cleanup && brew doctor"

# Quick Look from terminal
ql() {
    qlmanage -p "$@" &> /dev/null
}

# Notification when long running command finishes
notify() {
    osascript -e "display notification \"Command completed\" with title \"Terminal\""
}

# Flush DNS cache
alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# Show/hide desktop icons
alias showdesktop="defaults write com.apple.finder CreateDesktop true && killall Finder"
alias hidedesktop="defaults write com.apple.finder CreateDesktop false && killall Finder"

# Clipboard
alias pbcopy="pbcopy"
alias pbpaste="pbpaste"

# Open command uses native macOS open
alias open="open"
