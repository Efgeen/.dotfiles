#!/bin/sh

# pacman
pacman -Syu

# openssh
pacman -S --noconfirm openssh

# ssh
if ! systemctl is-enabled sshd; then
    systemctl enable sshd
fi
if ! systemctl is-active sshd; then
    systemctl start sshd
fi

# git
pacman -S --noconfirm git

# submodules
git submodule update --init
git submodule foreach '
    cd "$sm_path"
    if [ -f setup.sh ]; then
        sh setup.sh
    fi
    cd -
'

# github
pacman -S --noconfirm github-cli
echo "gh auth login -p https -h github.com -w"

