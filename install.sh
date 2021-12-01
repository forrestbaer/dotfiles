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

files="zshrc gitconfig vimrc zsh tmux.conf"

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

    rm ~/.$file
    links_made=$((links_made + 1))
  	echo "${cb}[${chg}+${cb}] ${nc}Creating symlink : ~/.$file => ${PWD}/$file"
   	ln -sfn ${PWD}/$file ~/.$file
done

if [ $links_made = 0 ]
then
    echo "${cb}[${chc}*${cb}] ${nc}No new links required!"
fi