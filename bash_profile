if ((BASH_VERSINFO[0] < 4))
then 
  echo "Looks like you're running an older version of Bash." 
  echo "You need at least bash-4.0 or some options will not work correctly." 
fi

set -o noclobber

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

[[ -r "/usr/local/etc/bash_completion.d/git-prompt.sh" ]] && . "/usr/local/etc/bash_completion.d/git-prompt.sh"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh"

export GIT_PS1_SHOWDIRTYSTATE=1

export PS1='\e[32m\]@\h \e[37m\w \e[35m$(__git_ps1 "(%s)") \e[$(($?==0?0:31))m$ \e[0m'

export PATH=/usr/local/bin:/usr/local/sbin:.local/bin:~/bin:/usr/bin:/bin:$PATH

if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
