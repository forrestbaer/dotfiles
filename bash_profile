if ((BASH_VERSINFO[0] < 4))
then
  echo "Looks like you're running an older version of Bash."
  echo "You need at least bash-4.0 or some options will not work correctly."
fi

if [[ $TERM != 'dumb' ]]; then
    export TERM=screen-256color
fi

# rwxr-xr-x
umask 022

set -o noclobber
set -o vi

shopt -s checkwinsize
shopt -s globstar 2> /dev/null
shopt -s nocaseglob;

bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"
bind "set mark-symlinked-directories on"

shopt -s histappend
shopt -s cmdhist

shopt -s autocd 2> /dev/null
shopt -s dirspell 2> /dev/null
shopt -s cdspell 2> /dev/null

GPG_TTY=$(tty)
export GPG_TTY

export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
export HISTTIMEFORMAT="%F %T "
export PROMPT_COMMAND="history -a"
export PROMPT_DIRTRIM=2

alias sudo='sudo '
alias cp='cp -r'
alias vim='nvim'
alias vi='nvim'
alias cat='bat'
alias ls='lsd'
alias ll='lsd -l'
alias lsa='ls -a'
alias lla='ll -a'

alias mv='mv -i'
alias md='mkdir'
alias more='less'
alias less='less -RX'
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
alias editkb='cd ~/code/qmk && vi ./keyboards/keyboardio/atreus/keymaps/mine/keymap.c'
alias t='task'
alias ps='ps -au'
alias sync-norns='rsync -chavzP we@norns.local:~/dust/audio/tape .'
alias dnf='sudo dnf '

# Git
alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias gf='git fetch'
alias hist="git log --oneline --decorate --color | fzf --ansi --preview 'git show $(echo {} | cut -d" " -f1)'"
alias ga='git add'
alias gco='git checkout $(git branch | fzf| tr -d "[:space:]")'
alias gcx="git checkout \$(git branch -a | sed -E 's/remotes\/([a-zA-Z-]*\/)//' | grep -v '\*|HEAD' | sort |uniq | fzf --select-1)"
alias glog='git log -p --'

alias cddf='cd ~/code/dotfiles'
alias size='du -hs * 2>/dev/null | grep "^...M" | sort -h'

fin() {
  sudo find / -name $1 2>/dev/null
}

export DF=~/code/dotfiles

export CLICOLOR=1
export EDITOR=nvim
export LS_COLORS='di=37'
export PS1='$? [\[\e[0;97m\]\w\[\e[0m\]] \[\e[0;90m\]\$ \[\e[0m\]'
export PATH=/bin:/usr/bin:/usr/local/sbin:~/.local/bin:~/bin:~/.cargo/bin:$PATH

[ -s "$HOME/.dir_colors" ] && eval $(dircolors ~/.dir_colors)

source /usr/share/fzf/shell/key-bindings.bash
