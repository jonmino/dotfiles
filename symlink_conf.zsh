#!/bin/zsh
# Script to create the Symbolic links of the config files to their respective place

set -eu -o pipefail # fail on error and report it, debug all lines

echo "Creating symbolic links for all directories in ./config"

ls .config/ | {
    declare -a dirlist
    while read dirlist;
    do
        cp -rsf ~/dotfiles/.config/"${dirlist}"/. ~/.config/"${dirlist}"
    done 
}
