#!/bin/sh

echo -e "\033[0;32m[.dotfiles] : setup...\033[0m"

# syu
pacman -Syu --noconfirm --needed

# ssh
pacman -S --noconfirm --needed openssh
if ! systemctl is-enabled sshd; then
    systemctl enable sshd
fi
if ! systemctl is-active sshd; then
    systemctl start sshd
fi

# git
pacman -S --noconfirm --needed git
git submodule update --init
git submodule foreach '
    if [ -f setup.sh ]; then
        sh setup.sh
    fi
'

echo -e "\033[0;32m[.dotfiles] : success\033[0m"
