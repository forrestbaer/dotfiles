setopt always_to_end
setopt append_history
setopt auto_cd
setopt complete_in_word
setopt extendedglob
setopt no_case_glob
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt inc_append_history
setopt nobeep
setopt nohup
setopt prompt_subst
setopt vi

HISTSIZE=600
SAVEHIST=600
HISTFILE=~/.zsh_history

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
