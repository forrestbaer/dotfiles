alias weather='curl -s "wttr.in/?format=%l:+%c+%t+%h+%P+%m\n"'

alias ls='ls -GhF'
alias ll='ls -GhlFa'
alias la='ls -GalaF'
alias mv='mv -i'
alias c='clear'
alias md='mkdir'
alias cat='bat'
alias dh='dirs -v'
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"

alias p='f() { qlmanage -p $1 2> /dev/null};f'

# Git

alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias gf='git fetch'
alias hist="git log --oneline --decorate --color | fzf --ansi --preview 'git show $(echo {} | cut -d" " -f1)'"
alias ga='git add'

# Vim

alias vi='nvim'
alias vim='nvim'

# tmux

alias tmux='tmux new -As0'

# easy directory jump

alias cddf='cd ~/code/dotfiles'
