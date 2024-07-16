#!/bin/sh

pacman -S --needed --noconfirm git

git submodule update --init

git submodule foreach "
    if [ -f setup.sh ]; then
        sudo sh setup.sh
    fi
" # todo: rm sudo?

echo "[success]"
