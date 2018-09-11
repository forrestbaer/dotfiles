#!/bin/sh

dir=${PWD}
backupdir=dotfile_backup
files="vimrc zshrc gitconfig zsh tmux.conf"

cd $dir

if [ ! -d "$backupdir"]; then
    mkdir $backupdir
fi

for file in $files; do
    echo "Copying existing files to $backupdir if they exist."
    if [ -f "$file" ]; then
        mv ~/.$file ./$backupdir/
    fi
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
