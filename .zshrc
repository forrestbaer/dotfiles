autoload -U compinit && compinit
autoload colors && colors

source ~/.zsh/aliases.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/history.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/set_options.zsh

if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi
