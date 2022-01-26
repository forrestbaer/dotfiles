alias weather='curl -s "wttr.in/?format=%l:+%c+%t+%h+%P+%m\n"'

alias ytaudio='youtube-dl --extract-audio --audio-quality 0 --audio-format mp3 -o "~/store/music/%(title)s-%(id)s.%(ext)s"'

alias ls='ls -GhF'
alias ll='ls -GhlFa' # long format listing; add / to end of directories
alias la='ls -GalaF' # include dot files in listing; add / to end of directories
alias mv='mv -i' # prompt before moving a file that would overwrite an existing file
alias grep='grep --color --line-number'
alias c='clear'
alias md='mkdir'
alias ctags='/usr/local/bin/ctags'
alias rm='trash'
alias cat='bat'

# Git

alias gs='git status'
alias gstatus='git status'
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
alias st='cd ~/store'
