#!/bin/sh 

dir=${PWD}
backupdir="$dir/dotfile_backup"
files="vimrc zshrc gitconfig zsh tmux.conf eslintrc.js"

echo "*** Linking dotfiles into home directory"

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

echo
echo "*** Copying VS Code configurations"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # $HOME/Library/Application Support/Code/User/settings.json
    echo "*** OSX, copying to"
else
    # $HOME/.config/Code/User/settings.json
    echo "*** Other Unix, copying to"
fi