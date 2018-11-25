alias ls='ls -GhF'
alias ll='ls -GhlFa' # long format listing; add / to end of directories
alias la='ls -GalaF' # include dot files in listing; add / to end of directories
alias eject='diskutil list | grep FB64 | awk '\''{ print $NF }'\'' | xargs diskutil unmount'
alias mv='mv -i' # prompt before moving a file that would overwrite an existing file
alias grep='grep --color --line-number'
alias c='clear'
alias cat='bat'
alias cal='khal'
alias mail='neomutt'
alias mutt='neomutt'
alias gtd='grep -R TODO *'
alias vdisc='vdirsyncer discover'
alias vsync='vdirsyncer sync'
alias vnc='remmina'

# Git

alias gs='git status'
alias gstatus='git status'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias getch='git fetch'
alias hist='git hist'
alias gh="git hist"
alias ga='git add'

# tmux

alias tmux='tmux att -d'

# vim

alias vi='nvim'
alias vim='nvim'

# python

alias py='python3'
alias python='python3'
alias pyvenv='python3 -m venv'
