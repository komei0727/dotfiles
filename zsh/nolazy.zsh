### zsh の設定 ###
#################################  HISTORY  #################################
# history
HISTFILE=$HOME/.zsh_history # 履歴を保存するファイル
HISTSIZE=100000             # メモリ上に保存する履歴のサイズ
SAVEHIST=1000000            # 上述のファイルに保存する履歴のサイズ

# share .zshhistory
setopt inc_append_history   # 実行時に履歴をファイルにに追加していく
setopt share_history        # 履歴を他のシェルとリアルタイム共有する

zshaddhistory() {
    local line="${1%%$'\n'}"
    [[ ! "$line" =~ "^(cd||la|ll|ls|rm|rmdir|sz|vv|vz)($| )" ]]
}

# Path
PATH=$HOME/.local/bin:$PATH

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"