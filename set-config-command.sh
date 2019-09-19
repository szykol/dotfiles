#!/bin/zsh

git init --bare $HOME/.dotfiles-git

if alias config 2>/dev/null; then 
    echo "Config 'alias' already exists"
else
    echo "Creating alias 'config'"
    echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME'" >> $HOME/.zshrc
    source $HOME/.zshrc
fi

config config --local status.showUntrackedFiles no
