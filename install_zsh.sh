#! /bin/bash
# Script to install Zsh, my favorite shell

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo "Installing Zsh ..."
sudo apt install zsh
echo "Installed Zsh version is $(zsh --version)"

read -p "?Is it a newer version than 5.0.8? (y/n) " yn
case $yn in 
    [Yy]*) 
        echo ok continuing...
        chsh -s $(which zsh) # Make it the default shell
        echo All done, now restart to use zsh
        echo "Confirm via echo \$SHELL and \$SHELL --version";;
    [Nn]*) 
        echo Head to https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH to solve;;
esac
