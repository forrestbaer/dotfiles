fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

alias vim='nvim'
alias vi='nvim'
alias ls='ls -GhF'
alias ll='ls -GhlFa'
alias mv='mv -i'
alias md='mkdir'
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"

# Git
alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias gf='git fetch'
alias hist="git log --oneline --decorate --color | fzf --ansi --preview 'git show $(echo {} | cut -d" " -f1)'"
alias ga='git add'
alias gco='git checkout $(git branch | fzf| tr -d "[:space:]")'
alias gcx="git checkout \$(git branch -a | sed -E 's/remotes\/([a-zA-Z-]*\/)//' | grep -v '\*|HEAD' | sort |uniq | fzf --select-1)"

# tmux
alias tmux='tmux new -As0'

# easy directory jumps
alias cdds='cd ~/code/design-system'
alias cddf='cd ~/code/dotfiles'

export SHELL=/usr/local/bin/bash
export EDITOR=nvim

export GNUPGHOME=~/.config/gpg
export GPG_TTY="$TTY"
export PICO_SDK_PATH="$HOME/code/pico/pico-sdk"

[[ -r "/usr/local/etc/bash_completion.d/git-prompt.sh" ]] && . "/usr/local/etc/bash_completion.d/git-prompt.sh"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/usr/local/etc/bash_completion.d/git-completion.bash" ]] && . "/usr/local/etc/bash_completion.d/git-completion.bash"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh"

export GIT_PS1_SHOWDIRTYSTATE=1

export PS1='$? [\[\e[0;97m\]\w\[\e[0m\]] $(__git_ps1 "\[\e[0;38;5;242m\](\[\e[0;38;5;237m\]%s\[\e[0;38;5;242m\])") \[\e[0;90m\]\$ \[\e[0m\]'

export PATH=/usr/local/opt/python/libexec/bin:/usr/local/opt/texinfo/bin:/usr/local/bin:/usr/local/sbin:.local/bin:~/bin:/usr/bin:/bin:~/.bin:$PATH

export CLICOLOR=1
export LSCOLORS=dxfxcxdxGxegedabagacad

export FZF_DEFAULT_OPTS='--color=bg+:#222222,bg:#000000,border:#6B6B6B,spinner:#00A800,hl:#AA00AA,fg:#D9D9D9,header:#00A800,info:#A4722C,pointer:#00AAAA,marker:#55F7F7,fg+:#D9D9D9,preview-bg:#000000,prompt:#A4722C,hl+:#55F7F7'

[[ -r /usr/local/opt/fzf/bin ]] && PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
