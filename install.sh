#!/bin/sh

links_made=0

folders="config/nvim config/gitui"
files="alacritty.yml zshrc gitconfig zsh tmux.conf config/nvim/init.lua config/gitui/theme.ron"

for folder in $folders; do
  mkdir -p ~/.$folder
done

for file in $files; do
  rm ~/.$file
  echo "[+] Creating symlink : ~/.$file => ${PWD}/$file"
  ln -sfn ${PWD}/$file ~/.$file
done
