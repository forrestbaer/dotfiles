alias weather='curl -s "wttr.in/?format=%l:+%c+%t+%h+%P+%m\n"'
alias ytaudio='youtube-dl --extract-audio --audio-quality 0 --audio-format mp3 -o "~/store/music/%(title)s-%(id)s.%(ext)s"'

alias ls='ls -GhF'
alias ll='ls -GhlFa'
alias la='ls -GalaF'
alias mv='mv -i'
alias c='clear'
alias md='mkdir'
alias rm='trash'
alias cat='bat'
alias dh='dirs -v'

# Git

alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias gf='git fetch'
alias hist='git hist'
alias ga='git add'

# Vim

alias vi='nvim'
alias vim='nvim'

# tmux

alias tmux='tmux new -As0'

# ad hoc

alias cdds='cd ~/code/design-system'

vdiff () {
    if [ "${#}" -ne 2 ] ; then
        echo "vdiff requires two arguments"
        echo "  comparing dirs:  vdiff dir_a dir_b"
        echo "  comparing files: vdiff file_a file_b"
        return 1
    fi

    local left="${1}"
    local right="${2}"

    if [ -d "${left}" ] && [ -d "${right}" ]; then
        vim +"DirDiff ${left} ${right}"
    else
        vim -d "${left}" "${right}"
    fi
}
