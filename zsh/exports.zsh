export EDITOR="nvim"

if [[ $TERM != 'dumb' ]]; then
    export TERM=rxvt-256color
fi

export CLICOLOR=1
export LSCOLORS=dxfxcxdxGxegedabagacad
export PATH=/usr/local/bin:/usr/local/sbin:~/bin:~/avr32-tools/bin:$PATH
