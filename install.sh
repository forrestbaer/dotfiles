#!/bin/sh 

dir=${PWD}
backupdir="$dir/dotfile_backup"
files="vimrc zshrc gitconfig zsh tmux.conf"

for file in $files; do
    if [ ! -L ~/.$file ] &&
       [ -e ~/.$file ]
    then
	if [ ! -d $backupdir ]
	then
	    echo "*** Found existing configurations, creating backup directory."
	    mkdir $backupdir
	fi

	echo "*** Copying ~/.$file to $backupdir/$file."
        mv ~/.$file $backupdir/$file
    fi

    if [ ! -e ~/.$file ]
    then
    	echo "*** Creating symlink to $file in home directory."
    	ln -sfn $dir/$file ~/.$file
    fi
done
