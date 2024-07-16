#!/bin/sh

if ! command -v git; then
    echo "[fail] : no git"
    exit 1
fi

git submodule update --init

git submodule foreach "
    if [ -f setup.sh ]; then
        sh setup.sh
    fi
"

echo "[success]"
