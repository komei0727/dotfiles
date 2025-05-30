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
abbr ls="eza --group-directories-first --icons=always"
abbr ll="eza --group-directories-first -al --header --icons=always --color-scale --git --time-style=long-iso"
abbr la="eza --group-directories-first --icons=always -a"
abbr tree="eza --group-directories-first -T --icons=always"

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
