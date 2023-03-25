if ((BASH_VERSINFO[0] < 4))
then
  echo "Looks like you're running an older version of Bash."
  echo "You need at least bash-4.0 or some options will not work correctly."
fi

if [[ $TERM != 'dumb' ]]; then
    export TERM=alacritty
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

CDPATH=".:~:~/code"
HISTSIZE=500000
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth"
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -a'
PROMPT_DIRTRIM=2

[[ -f ~/.bashrc ]] && source ~/.bashrc
