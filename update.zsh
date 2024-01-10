#!/bin/zsh
while true; do 
    read "?Do you want to update? (y/n) " yn
    case $yn in 
	     [Yy]*) 
            echo ok updating
            sudo apt-get update
            sudo apt-get full-upgrade
            sudo apt-get autoremove
            sudo apt-get autoclean
            sudo apt update
            sudo apt upgrade
            sudo apt autoremove
            mamba upgrade all
            mamba clean --all --yes
            tlmgr update --self --all --reinstall-forcibly-removed
            break;;
	     [Nn]*) 
            echo Sure if you say so. Update then...
            break;;
    esac
done