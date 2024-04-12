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
source ~/.zsh/prompt.zsh
source ~/.zsh/options.zsh
source ~/.zsh/completion.zsh
