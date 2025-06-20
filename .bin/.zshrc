# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSHRC_DIR=$HOME/dotfiles/zsh

function source {
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "\033[1;36mCompiling\033[0m $1"
    zcompile $1
  fi
}

ensure_zcompiled ~/.zshrc

source $ZSHRC_DIR/nolazy.zsh

export SHELDON_CONFIG_DIR="$ZSHRC_DIR/sheldon"
sheldon_cache="$SHELDON_CONFIG_DIR/sheldon.zsh"
sheldon_toml="$SHELDON_CONFIG_DIR/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  sheldon source > $sheldon_cache
fi
source $sheldon_cache
unset sheldon_cache sheldon_toml

# Load platform-specific configurations
case "$OSTYPE" in
  linux*)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      zsh-defer source $ZSHRC_DIR/wsl.zsh
    else
      zsh-defer source $ZSHRC_DIR/linux.zsh
    fi
    ;;
  darwin*)
    zsh-defer source $ZSHRC_DIR/darwin.zsh
    ;;
esac

zsh-defer zsh-defer unfunction source
