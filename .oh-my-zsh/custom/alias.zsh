# Alias definitions

#cd aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# ls/k/nnn aliases
alias k="k -ah"
alias ll='ls -CFAlh'
alias la='ls -CFA'
alias l='ls -CF'
alias yazi="~/Downloads/yazi/target/release/yazi ."
alias y="yazicdonquit"

# e5 / Bachelorarbeit
alias mounte5='sshfs interactive:/net/nfshome2/home/jminor ~/Studium/e5Interactive -o auto_cache,reconnect,follow_symlinks,no_readahead'
alias rebuildProton="cd ~/Studium/Bachelorarbeit/protonSim/ && rm -rf proton-build && mkdir proton-build && cd proton-build && cmake ../proton -DGeant4_DIR=~/geant4-v11.1.2-install/lib/Geant4-11.1.2/ -DGEANT4_USE_GDML=ON && make -j"
alias geant="mamba activate g4 && source ~/geant4-v11.1.2-install/bin/geant4.sh && cd ~/Studium/Bachelorarbeit/" # && export LD_LIBRARY_PATH=/home/jomino/geant4-v11.1.1-install/lib"

# configs
alias zshconf="nvim ~/.zshrc"
alias updateconf="nvim ~/update.sh"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias zshconf="nvim ~/.zshrc"
alias p10kconf="nvim ~/.p10k.zsh"
alias aliasconf="nvim ~/.oh-my-zsh/custom/alias.zsh" # <- this file
alias tmuxconf="nvim ~/.config/tmux/tmux.conf"

# make
alias remake='make clean && make'

# count files
alias count='find . -type f | wc -l'

# copy with progress bar
alias cpv='rsync -ah --info=progress2'

## Colorize the grep command output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# git
alias gits="git status -s"

# vim
alias vim=nvim
alias vi=nvim

# texlive
alias updatetl="tlmgr update --self --all --reinstall-forcibly-removed"


# misc 
alias sshagent="eval $(ssh-agent -s)"
alias hello="fortune | cowsay -f tux"
alias rm='rm -rfi'
alias update="zsh ~/update.sh"
alias praktikum="mamba activate prak && cd ~/Studium/Praktikum/Versuchsprotokolle"
