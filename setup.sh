#!/bin/bash

# create symlinks of my dotfiles (will not override if already exists)
[ -d "$HOME/.config" ] && ln -s $HOME/dotfiles/.config/* $HOME/.config || ln -s $HOME/dotfiles/.config $HOME
[ -f "$HOME/.zshrc" ] || { echo "source $HOME/dotfiles/zsh/zshrc" > $HOME/.zshrc; }

# finalize
source $HOME/.zshrc
