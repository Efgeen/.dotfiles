#!/bin/sh

echo -e "\033[0;32m[.dotfiles]\033[0m"

pacman -Syu --noconfirm --needed

pacman -S --noconfirm --needed git
git submodule update --init
git submodule foreach '
    if [ -f setup.sh ]; then
        sh setup.sh
    fi
'

echo -e "\033[0;32m[.dotfiles] : success\033[0m"
