setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt auto_list
setopt list_packed
setopt rec_exact
setopt no_case_glob
setopt extendedglob
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt share_history
setopt no_hup
setopt no_beep
setopt prompt_subst
setopt vi

HISTSIZE=600
SAVEHIST=600
HISTFILE=~/.zsh_history

ZSH_AUTOSUGGEST_STRATEGY=(completion history)
