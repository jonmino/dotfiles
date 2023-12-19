#!/bin/zsh
LIST_OF_APPS="ripgrep curl make"

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo installing basic tools and pre-requisites

sudo apt-get update # update package list
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
    perl
    unzip
    tar
    curl
    wget
    make
    ripgrep
    build-essential
    file
    git
    libgl1
    fonts-powerline
    fortune
    cowsay
    fzf
    sshfs
    cmake
    evince
    less
EOF
)
