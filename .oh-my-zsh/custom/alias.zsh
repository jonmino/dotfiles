# Alias definitions

#cd aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# ls/k/nnn aliases
alias k="k -h"
alias kk="k -ah"
alias ll='ls -CFAlh'
alias la='ls -CFA'
alias l='ls -CF'
alias yazi="~/Downloads/yazi/target/release/yazi ."
alias y="yazicdonquit"

# WSL2/Windows
alias reveal="explorer.exe ." # Reveal current dir in File explorer

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
