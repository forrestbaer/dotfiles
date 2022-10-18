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

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

