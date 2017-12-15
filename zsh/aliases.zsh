alias ls='ls -GhF'
alias ll='ls -GhlF' # long format listing; add / to end of directories
alias la='ls -GalaF' # include dot files in listing; add / to end of directories
alias mv='mv -i' # prompt before moving a file that would overwrite an existing file
alias grep='grep --color --line-number'
alias c='clear'

# Git

alias st='git status'
alias gstatus='git status'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias getch='git fetch'
alias hist='git hist'
alias ga='git add'

# tmux

alias tmux='tmux att || tmux'
