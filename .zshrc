# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# zsh history settings
HISTFILE=~/.zsh_histfile
HISTORY_IGNORE="(cd|pwd|l[sal])"
HISTSIZE=10000
SAVEHIST=10000
 
setopt extended_history
setopt hist_allow_clobber
setopt hist_fcntl_lock
setopt hist_find_no_dups 
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history_time

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
alias g='git'

# python rye
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

# rust cargo
export PATH="$HOME/.cargo/bin:$PATH"

# fzf
source <(fzf --zsh)

# Yazi
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
