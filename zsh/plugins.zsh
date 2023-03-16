### プラグインの設定 ###
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
