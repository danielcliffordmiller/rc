#!/bin/bash

if [ ! -e ~/.bashrc ] || ! grep -q -e "source $(pwd)/bashrc" ~/.bashrc; then
    echo "source $(pwd)/bashrc" >> ~/.bashrc
else
    echo "~/.bashrc is already installed, skipping..."
fi
if [ ! -e ~/.vimrc ] || ! grep -q -e "source $(pwd)/vimrc" ~/.vimrc; then
    echo "source $(pwd)/vimrc" >> ~/.vimrc
else
    echo "~/.vimrc is already installed, skipping..."
fi
if [ ! -e ~/.tmux.conf ] || ! grep -q -e "source $(pwd)/tmux.conf" ~/.tmux.conf; then
    echo "source $(pwd)/tmux.conf" >> ~/.tmux.conf
else
    echo "~/.tmux.conf is already installed, skipping..."
fi
if [ ! -e ~/.inputrc ] || ! grep -q -e "\$include $(pwd)/inputrc" ~/.inputrc; then
    echo '$include' "$(pwd)/inputrc" >> ~/.inputrc
else
    echo "~/.inputrc is already installed, skipping..."
fi

if [ ! -e /usr/local/bin/tree.exp ]; then
    ln -s "$(pwd)/tree.exp" /usr/local/bin/tree.exp
else
    echo "tree.exp already installed, skipping..."
fi
