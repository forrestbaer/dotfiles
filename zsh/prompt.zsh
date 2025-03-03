function vii() {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function set_prompt() {
  branch_name=$(git_branch_name)
  author_name=$(git_author_name)

  if (( $(id -u) ==0 )); then
      isroot='%F{#AF5F5F}'
  else
      isroot='%F{#5fafaf}'
  fi

  PS1='%(?.%F{green}√ %b%F{7}[$isroot%m%F{7}].%F{#AF5F5F}%?)%f %b%F{7}%3~ %B%F{7}$(vii)\$ %b%F{7}'
  RPROMPT=''

  if [ -n "$branch_name" ]; then
    RPROMPT+='%b%F{7}[ %F{#6f5faf}$branch_name%b%F{7} ] '
  fi

  RPROMPT+='%b%F{#183273}%*%b%F{7}'
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
