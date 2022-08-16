zmodload -i zsh/complist

unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' menu select
zstyle ':completion:*' complete-options true
zstyle ':completion:*' list-colors ${(s.:.)ZLS_COLORS}

zstyle ':completion:*:expand:*' keep-prefix true tag-order all-expansions
zstyle ':completion:*:*:*:*:*' menu select

zstyle ':completion:*:default' list-colors '' "ma=48;5;53;1"

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "- %{${fg[yellow]}%}%d%{${reset_color}%} -"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-separator '#'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:prefix:*' add-space true

zstyle ':completion:*:scp:*' tag-order files 'hosts:-domain:domain'
zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-domain:domain'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr

zstyle ':completion:*' users off
zstyle ':completion:*:*:kill:*' verbose yes
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:manuals'       separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections   true
zstyle ':completion:*' use-cache off

autoload -Uz compinit; compinit
