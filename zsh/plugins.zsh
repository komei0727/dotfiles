### basic-plugin ###
zinit wait lucid blockf light-mode for \
    @'zsh-users/zsh-autosuggestions' \
    @'zsh-users/zsh-completions' \
    @'zdharma-continuum/fast-syntax-highlighting'

### zsh-replace-multiple-dots ###
__replace_multiple_dots_atload() {
    replace_multiple_dots_exclude_go() {
        if [[ "$LBUFFER" =~ '^go ' ]]; then
            zle self-insert
        else
            zle .replace_multiple_dots
        fi
    }

    zle -N .replace_multiple_dots replace_multiple_dots
    zle -N replace_multiple_dots replace_multiple_dots_exclude_go
}
zinit wait lucid light-mode for \
    atload'__replace_multiple_dots_atload' \
    @'momo-lab/zsh-replace-multiple-dots'

### autopair ###
zinit wait'1' lucid light-mode for \
    @'hlissner/zsh-autopair'

### bat ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'bat*/bat'   @'sharkdp/bat'
export BAT_CONFIG_PATH="$HOME/dotfiles/zsh/bat/bat.conf"

### ripgrep ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'ripgrep*/rg'   @'BurntSushi/ripgrep'
export RIPGREP_CONFIG_PATH="$HOME/dotfiles/zsh/ripgrep/config"

### fd ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'fd*/fd'  @'sharkdp/fd'

### exa ###
__exa_atload() {
    alias ls='exa --group-directories-first'
    alias la='exa --group-directories-first -a'
    alias ll='exa --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
    alias tree='exa --group-directories-first -T --icons'
}
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'bin/exa' \
    atclone'cp -f completions/exa.zsh _exa' atpull'%atclone' \
    atload'__exa_atload' \
    @'ogham/exa'

### tldr ###
zinit as'program' from'gh-r' for \
    @'httpie/cli'

### fzf ###
zinit wait lucid light-mode as'program' for \
    pick="bin/(fzf|fzf-tmux)" \
    atclone="./install --bin; cp shell/completion.zsh _fzf_completion" \
    atpull="./install --bin" \
    @junegunn/fzf
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%"
export FZF_DEFAULT_COMMAND='fd --hidden --color=always'
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border \
--preview-window 'right:50%' \
--bind 'ctrl-/:change-preview-window(80%|hidden|)' \
--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"

### navi ###
__navi_search() {
    LBUFFER="$(navi --print --query="$LBUFFER")"
    zle reset-prompt
}
__navi_atload() {
    export NAVI_CONFIG="$HOME/dotfiles/zsh/navi/config.yaml"

    zle -N __navi_search
    bindkey '^N' __navi_search
}
zinit wait lucid light-mode as'program' from'gh-r' for \
    atload'__navi_atload' \
    @'denisidoro/navi'

### dsq ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'dsq' \
    @'multiprocessio/dsq'

### pyenv ###
zinit wait lucid light-mode as'program' from'gh' for \
    pick'bin/pyenv' \
    @'pyenv/pyenv'

### ghq ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'ghq*/ghq' \
    @'x-motemen/ghq'

### tmux ###
zinit wait lucid light-mode as'program' from'gh-r' for \
    pick'tmux*/tmux' \
    @'tmux/tmux'