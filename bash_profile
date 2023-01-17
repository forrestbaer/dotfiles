if ((BASH_VERSINFO[0] < 4))
then 
  echo "Looks like you're running an older version of Bash." 
  echo "You need at least bash-4.0 or some options will not work correctly." 
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

[[ -r "/usr/local/etc/bash_completion.d/git-prompt.sh" ]] && . "/usr/local/etc/bash_completion.d/git-prompt.sh"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/usr/local/etc/bash_completion.d/git-completion.bash" ]] && . "/usr/local/etc/bash_completion.d/git-completion.bash"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh"

export GIT_PS1_SHOWDIRTYSTATE=1

export PS1='$? [\[\e[0;97m\]\w\[\e[0m\]] $(__git_ps1 "\[\e[0;38;5;242m\](\[\e[0;38;5;237m\]%s\[\e[0;38;5;242m\])") \[\e[0;90m\]\$ \[\e[0m\]'


export PATH=/usr/local/opt/texinfo/bin:/usr/local/bin:/usr/local/sbin:.local/bin:~/bin:/usr/bin:/bin:~/.bin:$PATH

[[ -r /usr/local/opt/fzf/bin ]] && PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
[[ -f ~/.bashrc ]] && source ~/.bashrc

if [[ $TERM != 'dumb' ]]; then
    export TERM=alacritty
fi

export CLICOLOR=1
export LSCOLORS=dxfxcxdxGxegedabagacad

export FZF_DEFAULT_OPTS='--color=bg+:#222222,bg:#000000,border:#6B6B6B,spinner:#00A800,hl:#AA00AA,fg:#D9D9D9,header:#00A800,info:#A4722C,pointer:#00AAAA,marker:#55F7F7,fg+:#D9D9D9,preview-bg:#000000,prompt:#A4722C,hl+:#55F7F7'

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
[[ -f ~/.bashrc ]] && source ~/.bashrc # ghcup-env
