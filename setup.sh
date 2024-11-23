#!/bin/sh

echo -e "\033[0;32m[.dotfiles]\033[0m"

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
    echo "${sm_path}"
    if [ -f "$sm_path/setup.sh" ]; then
        cd "$sm_path"
        sh setup.sh
        cd -
    else
        echo "nop"
    fi
'

echo -e "\033[0;32m[!.dotfiles]\033[0m"
