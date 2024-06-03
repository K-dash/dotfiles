# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# Q pre block. Keep at the top of this file.
# starship
eval "$(starship init zsh)"

# terminal color
export LSCOLORS=gxfxcxdxbxegedabagacad

# default permission
umask 022

# core dump delete
limit coredumpsize 0

# alias
alias vi='nvim'
alias cl='clear'
alias ll='clear && ls -lthaGF'
alias k='kubectl'
alias dive="docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"
alias d='docker'
alias c='docker compose'

source "$HOME/.rye/env"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# peco
function peco-history-selection-keep() {
  BUFFER=$(history -n 1 | tail -r  | awk '!a[$0]++' | peco --layout=bottom-up --query="$BUFFER" --print-query | tail -n 1)

  CURSOR=$#BUFFER
}
zle -N peco-history-selection-keep
bindkey '^R' peco-history-selection-keep

# Q post block. Keep at the bottom of this file.
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
