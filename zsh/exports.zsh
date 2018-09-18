export EDITOR="nvim"

if [[ $TERM != 'dumb' ]]; then
	export TERM=xterm-256color;
fi

export CLICOLOR=1
export LSCOLORS=dxfxcxdxGxegedabagacad
export PATH=$GOPATH/bin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH
