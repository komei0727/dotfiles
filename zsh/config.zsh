

#################################  COMPLEMENT  #################################
# 補完候補をそのまま探す -> 小文字を大文字に変えて探す -> 大文字を小文字に変えて探す
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

### 補完方法毎にグループ化する。
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''


### 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2
#################################  OTHERS  #################################
# ディレクトリ名を入力するだけで自動的にディレクトリを変更
setopt auto_cd

# ctrl+s, ctrl+qを無効化
setopt no_flow_control

# uv
eval "$(uv generate-shell-completion zsh)"

# mise
eval "$(mise activate zsh)"

# fzf
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%"
export FZF_DEFAULT_COMMAND="fd --hidden --color=always"
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border \
--preview-window 'right:50%' \
--bind 'ctrl-/:change-preview-window(80%|hidden|)' \
--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"

[[ $- == *i* ]] && source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/completion.zsh" 2> /dev/null

source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh"

# navi
export NAVI_CONFIG="$ZSHRC_DIR/navi/config.yaml"
