#!/bin/sh

# pacman
pacman -Syu

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
        if [ ! -x setup.sh ]; then
            chmod +x setup.sh
        fi
        ./setup.sh
    fi
"

echo "[.dotfiles] : success"
