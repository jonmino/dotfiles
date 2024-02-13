#!/bin/zsh
# Script to install the tools I use for work everyday

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo "Installing Oh-my-zsh and Plugins ..."
OMZDIR="$HOME/.oh-my-zsh/"
if [ ! -d $OMZDIR ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM="$OMZDIR/custom"
P10KDIR="${ZSH_CUSTOM:$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d $P10KDIR ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${P10KDIR}
fi
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
git clone https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k

echo "Installing Lazygit ..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz
rm -rf lazygit

echo "Restarting the Shell, when restarted you can execute the Symlink Script"
exec zsh
