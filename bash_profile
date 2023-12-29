if ((BASH_VERSINFO[0] < 4))
then
  echo "Looks like you're running an older version of Bash."
  echo "You need at least bash-4.0 or some options will not work correctly."
fi

if [[ $TERM != 'dumb' ]]; then
    export TERM=screen-256color
fi

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

export CDPATH=".:~:~/code"
export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
export HISTTIMEFORMAT="%F %T "
export PROMPT_COMMAND="history -a"
export PROMPT_DIRTRIM=2

export PASSWORD_STORE_DIR="/home/monk/h/p/pass"

alias cp='cp -r'
alias vim='nvim'
alias vi='nvim'
alias cat='batcat'
alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
alias lsa='ls -A'
alias lla='ll -A'
alias mv='mv -i'
alias md='mkdir'
alias more='less'
alias less='less -R'
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
alias editkb='cd ~/code/qmk && vi ./keyboards/keyboardio/atreus/keymaps/mine/keymap.c'

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

alias sudo='sudo '
alias tmux='tmux new -As0'
alias cddf='cd ~/code/dotfiles'
alias fixq='sudo xattr -rd com.apple.quarantine'
alias size='du -hs * 2>/dev/null | grep "^...M" | sort -h'

fin() {
  sudo find / -name $1 2>/dev/null
}

export CLICOLOR=1
export LSCOLORS=dxfxcxdxGxegedabagacad
export SHELL=/bin/bash
export EDITOR=nvim
export PS1='$? [\[\e[0;97m\]\w\[\e[0m\]] \[\e[0;90m\]\$ \[\e[0m\]'
export PATH=/bin:/usr/bin:/usr/local/sbin:~/.local/bin:~/bin:$PATH
export GNUPGHOME=/home/monk/h/p/gpg


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /usr/share/doc/fzf/examples/key-bindings.bash
. "$HOME/.cargo/env"
