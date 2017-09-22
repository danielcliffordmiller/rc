#!/bin/bash

sed -i -e '/^source '$(pwd | sed 's|/|\\/|g')'\/bashrc$/d' ~/.bashrc
sed -i -e '/^source '$(pwd | sed 's|/|\\/|g')'\/vimrc$/d' ~/.vimrc
sed -i -e '/^source '$(pwd | sed 's|/|\\/|g')'\/tmux.conf$/d' ~/.tmux.conf
sed -i -e '/^\$include '$(pwd | sed 's|/|\\/|g')'\/inputrc$/d' ~/.inputrc
