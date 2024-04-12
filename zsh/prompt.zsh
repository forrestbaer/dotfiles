function set_prompt() {
  branch_name=$(git_branch_name)
  author_name=$(git_author_name)

  if (( $(id -u) ==0 )); then
      isroot='%F{red}'
  else
      isroot='%F{cyan}'
  fi
  
  PS1='%(?.%F{green}√.%F{red}%?)%f %b%F{7}%3~ %B%F{7}\$ %b%F{7}'
 
  if [ -n "$branch_name" ]; then
  RPROMPT='%F{magenta}$branch_name%f'
  fi
}

function git_branch_name() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function git_author_name() {
  git config --get user.name | sed 's/\([a-zA-Z+]\)[a-zA-Z]* */\1/g' | tr '[A-Z]' '[a-z]'
}

precmd() { 
  set_prompt
}
