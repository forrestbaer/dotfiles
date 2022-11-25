alias ls='ls -GhF'
alias ll='ls -GhlFa'
alias la='ls -GalaF'
alias mv='mv -i'
alias c='clear'
alias md='mkdir'
alias cat='bat'
alias dh='dirs -v'
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"

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

# alias tmux='tmux new -As0'
alias home='tmuxinator start home'
alias work='tmuxinator start work'

# easy directory jumps

alias cdds='cd ~/code/design-system'
alias cddf='cd ~/code/dotfiles'

export SHELL=/usr/local/bin/bash
export GNUPGHOME=~/store/gpg
export GPG_TTY="$TTY"

if [[ $TERM != 'dumb' ]]; then
    export TERM=screen-256color
fi

export CLICOLOR=1
export LSCOLORS=dxfxcxdxGxegedabagacad

export FZF_DEFAULT_OPTS='--color=bg+:#222222,bg:#000000,border:#6B6B6B,spinner:#00A800,hl:#AA00AA,fg:#D9D9D9,header:#00A800,info:#A4722C,pointer:#00AAAA,marker:#55F7F7,fg+:#D9D9D9,preview-bg:#000000,prompt:#A4722C,hl+:#55F7F7'

export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
