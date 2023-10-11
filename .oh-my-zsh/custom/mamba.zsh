#!/bin/zsh
function mambas() {
  environments=$(eval mamba env list | rg -v '^#|base' | cut -d ' ' -f 1) #  | rg -v '^[\#|base]' | cut -d ' ' -f 1)
  items=("base" "deactivate" "$environments")

  # config for fuzzy finder selection window
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt="🐍 Mamba Config >> " --height=50% --info=inline --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
  mambastatus="Changed Nothing"
  elif [[ $config == "deactivate" ]]; then
    mamba deactivate
  mambastatus="Deactivated"
  else
    mamba activate "$config"
  mambastatus="Activated $config"
  fi
  printf "%s\n" "$mambastatus"
  echo # final newline to show status in shell
  zle accept-line
}

zle -N mambas
bindkey '^q' mambas # ctrl + q as shortcut keybinding
