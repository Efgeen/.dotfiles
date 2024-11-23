#!/bin/sh

# syu
pacman -Syu

# ssh
pacman -S --noconfirm openssh
if ! systemctl is-enabled sshd; then
    systemctl enable sshd
fi
if ! systemctl is-active sshd; then
    systemctl start sshd
fi

# git
pacman -S --noconfirm git
git submodule update --init
git submodule foreach '
    cd "$sm_path"
    if [ -f setup.sh ]; then
        sh setup.sh
    fi
    cd -
'
