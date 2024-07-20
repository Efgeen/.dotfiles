#!/bin/sh

f=false

while getopts ":f" opt; do
    case $opt in
	f)
	    f=true
	    ;;
	\?)
	    ;;
    esac
done

if ! pacman -Syu --noconfirm > /dev/null; then
    echo "[dotfiles] : fail (pacman -Syu)"
    exit 1
fi

if ! pacman -S --needed --noconfirm openssh > /dev/null 2>&1; then
    echo "[dotfiles] : fail (pacman -S openssh)"
    exit 2
fi

if ! systemctl is-enabled --quiet sshd; then
    systemctl enable sshd
fi

if ! systemctl is-active --quiet sshd; then
    systemctl start sshd
fi

if ! pacman -S --needed --noconfirm git > /dev/null 2>&1; then
    echo "[dotfiles] : fail (pacman -S git)"
    exit 3
fi

git submodule update --init

opts=""

if [ "$f" = true ]; then
    opts="${opts} -f"
fi

cd tmux
sh setup.sh $opts
cd - > /dev/null

cd nvim
# sh setup.sh
cd - > /dev/null

echo "[dotfiles] : success"
