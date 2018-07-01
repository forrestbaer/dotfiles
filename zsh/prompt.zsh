# Put the string "hostname::/full/directory/path" in the title bar:
set_term_title() { 
  print -Pn "\e]0;%n@%m: %~\a"
}

# Put the parentdir/currentdir in the tab
set_term_tab() {
  echo -ne "\e]1;$PWD:h:t/$PWD:t\a" 
}

function set_prompt() {
  branch_name=$(git_branch_name)
  author_name=$(git_author_name)

  if (( $(id -u) ==0 )); then
      isroot='%F{red}'
  else
      isroot='%F{cyan}'
  fi
  
  PS1='%{$reset_color$bold_color$fg[black]%}[%{$reset_color%}%m%{$reset_color$bold_color$fg[black]%}] %{$reset_color%}%{$isroot%}%2/ %{%B$isroot%}$ %{$reset_color%}'
 
  if [ -n "$branch_name" ]; then
	  PS1='%{$reset_color$bold_color$fg[black]%}[%{$reset_color%}%m%{$reset_color$bold_color$fg[black]%}] %{$reset_color$fg[magenta]%}$branch_name %{$isroot%}%2/ %{%B$isroot%}$ %{$reset_color%}'
  fi
}

function git_branch_name() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function git_author_name() {
  git config --get user.name | sed 's/\([a-zA-Z+]\)[a-zA-Z]* */\1/g' | tr '[A-Z]' '[a-z]'
}

precmd() { 
  set_term_title
  set_term_tab
  set_prompt
}
