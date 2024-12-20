autoload -U compinit && compinit
autoload colors && colors

if [[ -d ~/.zsh/zsh-autosuggestions ]]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions &&
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

source ~/.zsh/aliases.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/nvm.zsh
source ~/.zsh/options.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/completion.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
