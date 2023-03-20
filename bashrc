alias ls='ls -GhF'
alias ll='ls -GhlFa'
alias la='ls -GalaF'
alias mv='mv -i'
alias c='clear'
alias md='mkdir'
alias cat='bat'
alias dh='dirs -v'
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
alias sclang="/Applications/SuperCollider.app/Contents/MacOS/sclang"

alias ocd="openocd -s ../tcl -f ./interface/picoprobe.cfg -f ./target/rp2040.cfg"

# Git

alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias gf='git fetch'
alias hist="git log --oneline --decorate --color | fzf --ansi --preview 'git show $(echo {} | cut -d" " -f1)'"
alias ga='git add -u'
alias gco='git checkout $(git branch | fzf| tr -d "[:space:]")'
alias gcx="git checkout \$(git branch -a | sed -E 's/remotes\/([a-zA-Z-]*\/)//' | grep -v '\*|HEAD' | sort |uniq | fzf --select-1)"

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
export PICO_SDK_PATH="$HOME/code/pico/pico-sdk"
export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
[[ -f "/Users/monk/.ghcup/env" ]] && source "/Users/monk/.ghcup/env" # ghcup-env
