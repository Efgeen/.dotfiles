#!/bin/sh

# pacman
pacamn -Syu

# openssh
pacman -S --needed --noconfirm openssh
if ! systemctl is-enabled --quiet sshd; then
    systemctl enable sshd
fi
if ! systemctl is-active --quiet sshd; then
    systemctl start sshd
fi

# submodules
pacman -S --needed --noconfirm git
git submodule update --init
git submodule foreach "
    if [ -f setup.sh ]; then
        sudo sh setup.sh
    fi
" # todo: rm sudo?

echo "[success]"
