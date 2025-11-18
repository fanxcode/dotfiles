#!/bin/bash

# create symlinks of my dotfiles (will not override if already exists)
[ -d "$HOME/.config" ] && ln -s $HOME/dotfiles/.config/* $HOME/.config || ln -s $HOME/dotfiles/.config $HOME
[ -f "$HOME/.zshrc" ] || { echo "source $HOME/dotfiles/zsh/zshrc" > $HOME/.zshrc; }

# finalize
source $HOME/.zshrc

# Homebrew fortune data dir
BREW_FORTUNE_DIR="/opt/homebrew/share/games/fortunes"

# create symlink for custom fortune quotes (will not override if already exists)
[ -f "$BREW_FORTUNE_DIR/myquotes" ] || ln -s "$HOME/dotfiles/fortune/myquotes" "$BREW_FORTUNE_DIR/myquotes"

# generate .dat if not exists
[ -f "$BREW_FORTUNE_DIR/myquotes.dat" ] || strfile "$BREW_FORTUNE_DIR/myquotes" "$BREW_FORTUNE_DIR/myquotes.dat"
