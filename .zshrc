#Ctrl+Dでログアウトしてしまうことを防ぐ
setopt IGNOREEOF
#日本語を使用
export LANG=ja_JP.UTF-8
#色を使用
autoload -Uz colors
colors
#補完
autoload -Uz compinit
compinit
#cdコマンドを省略して、ディレクトリ名のみで移動
#setopt auto_cd
#自動でpushdを実行
setopt auto_pushd
#pushdから重複を削除
setopt pushd_ignore_dups
#コマンドミスを修正
setopt correct

#エイリアス
alias v='vim'
alias vi='vim'
alias vz='vim ~/.zshrc'
alias relogin='exec $SHELL -l'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias rm='rm -i'

#mkdirとcdを同時実行
function mkcd(){
    if [[-d $1 ]]; then

		echo "$1 already exists!"
		cd $1
	else
		mkdir -p $1 && cd $1
	fi
}


# zplug
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# theme (https://github.com/sindresorhus/pure#zplug)　
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# history関係
zplug "zsh-users/zsh-history-substring-search"
# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
# Then, source plugins and add commands to $PATH
zplug load


# coreutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# gnu-sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

#history
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000

#share .zshhistory
setopt inc_append_history
setopt share_history

#ヒストリーに重複を表示しない
setopt histignorealldups

# cdr
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs


function peco-history-selection(){
	BUFFER=`history -n 1 | awk '!a[$0]++' | peco`
	CURSOR=$#BUFFER
	zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

function peco-cdr() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^E' peco-cdr

#go
GOPATH=$HOME/workspace/go
