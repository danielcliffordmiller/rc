#!/bin/bash

sed -ie '/^source '$(pwd | sed 's|/|\\/|g')'\/bashrc$/d' ~/.bashrc
sed -ie '/^source '$(pwd | sed 's|/|\\/|g')'\/vimrc$/d' ~/.vimrc
