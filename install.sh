#!/bin/sh 

cg="\033[0;32m"
chg="\033[1;32m"
cc="\033[0;36m"
chc="\033[1;36m"
cb="\033[1;30m"
cr="\033[0;33m"
chr="\033[1;33m"
nc="\033[0m"

dir=${PWD}
backupdir="$dir/dotfile_backup"
links_made=0

files="msmtprc xsessionrc Xdefaults zshrc gitconfig zsh tmux.conf eslintrc.js config/neomutt/mailcap config/neomutt/muttrc config/neomutt/forrestbaer.com config/i3/config config/i3status/config config/khard/khard.conf config/khal/config config/nvim/init.vim config/vdirsyncer/config"

echo "${cc}*** ${nc}Scanning your home folder for links."

for file in $files; do
    dir=`dirname $file`
    fn=`basename $file`
    conf_dir=`basename $dir`

    if [ ! -L ~/.$file ] &&
       [ -e ~/.$file ]
    then
        echo "${cb}[${cr}!${cb}] ${nc}Found existing non-link files."

        if [ ! -d $backupdir ]
        then
            echo "${cb}[${cr}!${cb}] ${nc}Creating backup directory."
            mkdir $backupdir
        fi

        echo "*** Copying ~/.$file to $backupdir/$file."
        mv ~/.$file $backupdir/$file
    fi

    if [ `dirname $dir` = "config" ]
    then
	if [ ! -d ~/.config ]
	then
	    echo "${cb}[${chg}+${cb}] ${nc}~/.config/ missing, creating."
	    mkdir ~/.config
    	fi

	if [ ! -d ~/.config/$conf_dir ]
	then
	    echo "${cb}[${cg}^${cb}] ${nc}Directory ~/.config/$conf_dir missing, creating."
	    mkdir ~/.config/$conf_dir
	fi
    fi

    if [ ! -L ~/.$file ]
    then
	links_made=$((links_made + 1))	
    	echo "${cb}[${chg}+${cb}] ${nc}Creating symlink : ~/.$file => ${PWD}/$file"
     	ln -sfn ${PWD}/$file ~/.$file
    fi
done

if [ $links_made = 0 ]
then
    echo "${cb}[${chc}*${cb}] ${nc}No new links required!"
fi

if [ `uname -s` = "Darwin" ]
then
    echo "*** Copying VS Code configurations"
    cp -R ./vscode/* $HOME/Library/Application\ Support/Code/User/
fi
