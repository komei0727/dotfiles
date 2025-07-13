
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

# gh
eval "$(gh completion -s zsh)"

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
alias vim="nvim"
alias vi="nvim"
alias vz="nvim ~/.zshrc"
alias vn="nvim ~/.config/nvim/init.lua"
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

# git worktree
gwt() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwt <branch_name>"
    return 1
  fi

  # Get the current repository root
  local repo_root=$(git rev-parse --show-toplevel)


  # Fetch latest from remote
  echo "Fetching latest from remote..."
  git fetch origin deploy

  # Create the worktree from remote main branch
  echo "Creating worktree from origin/deploy"
  git worktree add -b "$1" ".worktree/$1" "origin/deploy"

  # Copy CLAUDE.md if it exists in the root
  if [[ -f "$repo_root/CLAUDE.md" ]]; then
    cp "$repo_root/CLAUDE.md" "$repo_root/.worktree/$1/"
    echo "Copied CLAUDE.md to worktree"
  fi

  # Copy claude-checklist.yaml if it exists in the root
  if [[ -f "$repo_root/claude-checklist.yaml" ]]; then
    cp "$repo_root/claude-checklist.yaml" "$repo_root/.worktree/$1/"
    echo "Copied claude-checklist.yaml to worktree"
  fi

  if [[ -d "$repo_root/.claude" ]]; then
    cp -r "$repo_root/.claude" "$repo_root/.worktree/$1/"
    echo "Copied .claude directory to worktree"
  fi

  if [ -f "$repo_root/.env.local" ]; then
    cp "$repo_root/.env.local" "$repo_root/.worktree/$1/"
    echo "Copied .env.local to worktree"
  fi

  if [ -f "$repo_root/.env.staging" ]; then
    cp "$repo_root/.env.staging" "$repo_root/.worktree/$1/"
    echo "Copied .env.staging to worktree"
  fi

  if [ -f "$repo_root/.env.production" ]; then
    cp "$repo_root/.env.production" "$repo_root/.worktree/$1/"
    echo "Copied .env.production to worktree"
  fi

  cd "$repo_root/.worktree/$1" || {
    echo "Failed to change directory to the new worktree."
    return 1
  }

  mise trust
  pnpm install
  pnpm prisma generate --schema=./prisma/schema.test.prisma
}

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
