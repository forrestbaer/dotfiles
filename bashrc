alias ls='ls -GhF'
alias ll='ls -GhlFa'
alias la='ls -GalaF'
alias mv='mv -i'
alias c='clear'
alias md='mkdir'
alias cat='bat'
alias dh='dirs -v'
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"

alias ocd="openocd -s ../tcl -f ./interface/picoprobe.cfg -f ./target/rp2040.cfg"

# Git

alias gs='git status'
alias gc='git commit -m'
alias gd='git diff'
alias gp='git push'
alias gf='git fetch'
alias hist="git log --oneline --decorate --color | fzf --ansi --preview 'git show $(echo {} | cut -d" " -f1)'"
alias ga='git add -u'

alias vim='nvim'
alias vi='nvim'

# tmux

alias tmux='tmux new -As0'
alias home='tmuxinator start home'
alias work='tmuxinator start work'

# easy directory jumps

alias cdds='cd ~/code/design-system'
alias cddf='cd ~/code/dotfiles'

export SHELL=/usr/local/bin/bash
export GNUPGHOME=~/store/gpg
export GPG_TTY="$TTY"
export PICO_SDK_PATH="$HOME/code/pico-sdk"
export EDITOR=nvim
