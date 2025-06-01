#!/bin/bash

CONFIG_DIR=~/dotfiles

mkdir -p $CONFIG_DIR/{hyprland,rofi,sway,dunst,kitty}

cp -r ~/.config/hypr/* $CONFIG_DIR/hyprland/
cp -r ~/.config/rofi/* $CONFIG_DIR/rofi/
cp -r ~/.config/sway/* $CONFIG_DIR/sway/
cp -r ~/.config/dunst/* $CONFIG_DIR/dunst/
cp -r ~/.config/kitty/* $CONFIG_DIR/kitty/

cp ~/.zshrc $CONFIG_DIR/
[ -f ~/.zsh_aliases ] && cp ~/.zsh_aliases $CONFIG_DIR/

cd $CONFIG_DIR
git add .
git commit -m "Update all config files on $(date)"
git push
