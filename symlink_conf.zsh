#!/bin/zsh
# Script to create the Symbolic links of the config files to their respective place

set -eu -o pipefail # fail on error and report it, debug all lines

echo "Creating symbolic links for all directories in ./.config"

ls .config/ | {
    declare -a dirlist
    while read dirlist;
    do
        cp -rsf ~/dotfiles/.config/"${dirlist}"/. ~/.config/"${dirlist}"
    done 
}

echo "Creating symbolic links for all directories in ./.oh-my-zsh"

ls .oh-my-zsh/ | {
    declare -a dirlist
    while read dirlist;
    do
        cp -rsf ~/dotfiles/.oh-my-zsh/"${dirlist}"/. ~/.oh-my-zsh/"${dirlist}"
    done 
}

echo "Creating symbolic links for chosen files in ./"

files=(.p10k.zsh .zshenv .zshrc .gitconfig .condarc)
for file in $files; do
    ln -sf ~/dotfiles/$file ~/$file
done

echo "Finished executing the Script"
