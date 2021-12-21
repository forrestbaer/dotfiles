export EDITOR="code"
export SHELL=/bin/zsh

if [[ $TERM != 'dumb' ]]; then
    export TERM=rxvt-256color
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PYENV_ROOT="$HOME/.pyenv/shims"
export PATH="$PYENV_ROOT:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/python"

export CLICOLOR=1
export LSCOLORS=dxfxcxdxGxegedabagacad
export PATH=/usr/local/bin:/usr/local/sbin:~/bin:~/avr32-tools/bin:~/Library/Python/3.9/lib/python/site-packages:~/Library/Python/3.9/bin:~/.local/bin:~/.cargo/bin:~/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
