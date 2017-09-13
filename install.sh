#!/bin/bash

echo "source $(pwd)/bashrc" >> ~/.bashrc
echo "source $(pwd)/vimrc" >> ~/.vimrc
echo "source $(pwd)/tmux.conf" >> ~/.tmux.conf
echo '$include' "$(pwd)/inputrc" >> ~/.inputrc
