### プラグインの設定 ###
### powerlevel10k ###
zinit ice depth=1; zinit light romkatv/powerlevel10k

### syntax-highlighting ###
zinit light zdharma-continuum/fast-syntax-highlighting

### auto suggestions ###
zinit light zsh-users/zsh-autosuggestions
bindkey '^j' autosuggest-accept

### bat ###
zinit ice as"program" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat
