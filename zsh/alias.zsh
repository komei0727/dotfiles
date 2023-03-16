### エイリアス設定 ###
alias vz="vim ~/.zshrc"
alias vv="vim ~/.vimrc"
alias sz="source ~/.zshrc"

### batコマンド ###
if builtin command -v bat > /dev/null; then
  alias cat="bat"
fi
