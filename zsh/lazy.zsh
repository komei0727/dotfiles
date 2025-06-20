
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

### エイリアス設定 ###
alias vz="vim ~/.zshrc"
alias vv="vim ~/.vimrc"
alias sz="source ~/.zshrc"

### fzf ###
# fd - cd to selected directory
# https://qiita.com/kamykn/items/aa9920f07487559c0c7e
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

fgc() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

### tmux ###
function navipopup() {
  path_local=$PATH
  window=$(tmux display -p -F '#S:#I.#P')
  tmux popup -E -w 95% -h 95% "
    export PATH=$PATH:$path_local && \
    export NAVI_CONFIG='$HOME/dotfiles/zsh/navi/config.yaml' && \
    window=$(tmux display -p -F '#S:#I.#P') && \
    export FZF_DEFAULT_OPTS='-m --layout=reverse --border' && \
    zsh -c 'source $HOME/.zshrc' && \
    zsh -c 'navi --print | tr -d '\n' | tmux load-buffer -b tmp -' && tmux paste-buffer -drp -t $window -b tmp \
  "
}
zle -N navipopup
bindkey '^N' navipopup

# eza
alias ls="eza --group-directories-first --icons=always"
alias ll="eza --group-directories-first -al --header --icons=always --color-scale --git --time-style=long-iso"
alias la="eza --group-directories-first --icons=always -a"
alias tree="eza --group-directories-first -T --icons=always"

### ghq ###
function create_session_with_ghq() {
    # fzfで選んだghqのリポジトリのpathを取得
    moveto=$(ghq root)/$(ghq list | fzf-tmux -p 80%)

    if [[ ! -z ${TMUX} ]]
    then
        # リポジトリ名を取得
        repo_name=`basename $moveto`

        # repositoryが選択されなかった時は実行しない
        if [ $repo_name != `basename $(ghq root)` ]
        then
            # セッション作成（エラーは/dev/nullへ）
            tmux new-session -d -c $moveto -s $repo_name  2> /dev/null

            # セッション切り替え（エラーは/dev/nullへ）
            tmux switch-client -t $repo_name 2> /dev/null
        fi
    fi
}
zle -N create_session_with_ghq
bindkey '^G' create_session_with_ghq


# claude-tilex: <count> 個のペインを開き、
# ブランチ名を入力 → worktree 作成 → claude を実行
#
# 使い方例:
#   claude-tilex 4                 # オプションなし
#   claude-tilex 2 -- --model opus # 2 ペインで Opus を実行

claude-tilex() {
  local count session="claude-parallel"

  # ---------- 引数パース ----------
  while (($#)); do
    case $1 in
      --) shift; break ;;          # 以降はそのまま claude へ
      [0-9]*) count=$1; shift ;;
      *) echo "Usage: claude-tilex <count> [-- <claude options>]"; return 1 ;;
    esac
  done
  [[ -z $count ]] && { echo "Usage: claude-tilex <count> [-- <claude options>]"; return 1; }

  local claude_opts="$*"            # 残りをそのまま渡す（空でも可）
  local root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not in git repo"; return 1; }
  cd "$root"

  # ---------- セッション準備 ----------
  local target created=0 cmd
  cmd="claude ${claude_opts:+$claude_opts}"

  if [[ -z $TMUX ]]; then
    tmux new-session -d -s "$session" \
      "bash -c 'read -p \"branch name: \" br; git worktree add -B \"\$br\" .worktrees/\$br HEAD && cd .worktrees/\$br && $cmd'"
    target=$session
    created=1
  else
    target="."
  fi

  # ---------- 残りペイン ----------
  for ((i = created; i < count; i++)); do
    tmux split-window -t "$target" \
      "bash -c 'read -p \"branch name: \" br; git worktree add -B \"\$br\" .worktrees/\$br HEAD && cd .worktrees/\$br && $cmd'"
  done

  tmux select-layout -t "$target" tiled
  [[ -z $TMUX ]] && tmux attach -t "$session"

  echo "✅ claude-tilex: started $count pane(s) with \"${cmd}\""
}