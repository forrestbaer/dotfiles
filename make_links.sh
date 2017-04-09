#!/bin/bash

dir=~/code/dotfiles
backupdir=dotfile_backup
files="vimrc zshrc zsh"

cd $dir
mkdir $backupdir

for file in $files; do
    echo "Copying existing files to $backupdir if they exist."
    mv ~/.$file ./$backupdir/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
