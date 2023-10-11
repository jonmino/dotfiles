export EDITOR=nvim
export BROWSER=firefox
export max_print_line=2147483647

export PATH="$HOME/.local/bin:$PATH"

export PATH="$HOME/.local/texlive/2023/bin/x86_64-linux:$PATH"
export MANPATH="$HOME/.local/texlive/2023/texmf-dist/doc/man:$MANPATH"
export INFOPATH="$HOME/.local/texlive/2023/texmf-dist/doc/man:$INFOPATH"
export XDG_CONFIG_HOME="$HOME/.config/"

export LIBGL_ALWAYS_INDIRECT=0

export DISPLAY=:0

export ZSH_AUTOSUGGEST_STRATEGY=(
    completion
    history
)
. "$HOME/.cargo/env"
