if ((BASH_VERSINFO[0] < 4))
then
  echo "Looks like you're running an older version of Bash."
  echo "You need at least bash-4.0 or some options will not work correctly."
fi

if [[ $TERM != 'dumb' ]]; then
    export TERM=xterm
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
alias ls='ls'
alias ll='ls -l'
alias lsa='ls -a'
alias lla='ll -a'

alias mv='mv -i'
alias md='mkdir'
alias more='less'
alias less='less -RX'
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
alias editkb='cd ~/code/qmk && vi ./keyboards/keyboardio/atreus/keymaps/mine/keymap.c'
alias t='task'
alias sync-norns='rsync -chavzP we@norns.local:~/dust/audio/tape .'

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
  "sudo find / -name $1 2>/dev/null"
}

export CLICOLOR=1
export EDITOR=nvim
export LSCOLORS=dxfxcxdxGxegedabagacad

[[ -r "/usr/local/etc/bash_completion.d/git-prompt.sh" ]] && . "/usr/local/etc/bash_completion.d/git-prompt.sh"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/usr/local/etc/bash_completion.d/git-completion.bash" ]] && . "/usr/local/etc/bash_completion.d/git-completion.bash"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh"

export GIT_PS1_SHOWDIRTYSTATE=1

export PS1='$? [\[\e[0;97m\]\w\[\e[0m\]] $(__git_ps1 "\[\e[0;38;5;242m\](\[\e[0;38;5;237m\]%s\[\e[0;38;5;242m\])") \[\e[0;90m\]\$ \[\e[0m\]'

export PATH=/bin:/usr/bin:/usr/local/sbin:~/.local/bin:~/bin:~/.cargo/bin:~/go/bin:/opt/homebrew/bin:/usr/local/bin:/opt/homebrew/sbin:$PATH

[ -s "$HOME/.dir_colors" ] && eval "$(dircolors ~/.dir_colors)"

for f in /opt/homebrew/etc/bash_completion.d/*; do source $f; done

GPG_TTY=$(tty)
export GPG_TTY
export PINENTRY_USER_DATA="USE_CURSES=1"

export FZF_DEFAULT_OPTS='--color=bg+:#222222,bg:#000000,border:#6B6B6B,spinner:#00A800,hl:#AA00AA,fg:#D9D9D9,header:#00A800,info:#A4722C,pointer:#00AAAA,marker:#55F7F7,fg+:#D9D9D9,preview-bg:#000000,prompt:#A4722C,hl+:#55F7F7'

# sshfs remote:dir localdir .. .woah...
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
