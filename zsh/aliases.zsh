alias weather='curl -s "wttr.in/?format=%l:+%c+%t+%h+%P+%m\n"'
alias ytaudio='youtube-dl --extract-audio --audio-quality 0 --audio-format mp3 -o "~/store/music/%(title)s-%(id)s.%(ext)s"'

alias ls='ls -GhF'
alias ll='ls -GhlFa'
alias la='ls -GalaF'
alias mv='mv -i'
alias c='clear'
alias md='mkdir'
alias cat='bat'
alias dh='dirs -v'

alias home='tmuxinator start home'
alias work='tmuxinator start work'

# Git

alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias gf='git fetch'
alias hist='git hist'
alias ga='git add'

# Vim

alias vi='nvim'
alias vim='nvim'

# tmux

alias tmux='tmux new -As0'

# ad hoc

alias cdds='cd ~/code/design-system'
alias cdms='cd ~/code/marketplace-shared/jenkins/pipelines/design-system'
alias cddf='cd ~/code/dotfiles'
