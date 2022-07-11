#!/bin/sh

links_made=0

folders="config/nvim config/gitui config/tmuxinator config/ncmpcpp"
files="alacritty.yml zshrc gitconfig mpdconf zsh tmux.conf config/nvim/init.lua config/gitui/theme.ron config/tmuxinator/home.yml config/ncmpcpp/config config/tmuxinator/work.yml"

for folder in $folders; do
  mkdir -p ~/.$folder
done

for file in $files; do
  rm ~/.$file
  echo "[+] Creating symlink : ~/.$file => ${PWD}/$file"
  ln -sfn ${PWD}/$file ~/.$file
done
