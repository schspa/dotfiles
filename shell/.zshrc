DOTFILES_DIR=$(dirname `realpath ~/.zshrc`)

if [ -d $DOTFILES_DIR ]; then
	source $DOTFILES_DIR/.shellrc
fi

DOTFILES_DIR=$(dirname $DOTFILES_DIR)

export PATH=$HOME/bin:$DOTFILES_DIR/bin:/usr/local/bin:$PATH

[[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return

source /usr/share/zsh/share/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

plugins=(
	docker
    git
    emacs
    pip
    command-not-found
    # Syntax highlighting bundle.
    zsh-users/zsh-syntax-highlighting
)

if [[ "$OSTYPE" == "darwin"* ]]; then
	plugins+=(
		brew
		osx
	)
fi

for plugin in $plugins; do
    antigen bundle $plugin
done

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    ANTIGEN_CACHE=$HOME/.antigen/init-vterm.zsh
    antigen theme agnoster
else
    antigen theme romkatv/powerlevel10k
    POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
fi

# Tell Antigen that you're done.
antigen apply

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    vterm_printf(){
        if [ -n "$TMUX" ]; then
            # Tell tmux to pass the escape sequences through
            # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
            printf "\ePtmux;\e\e]%s\007\e\\" "$1"
        elif [ "${TERM%%-*}" = "screen" ]; then
            # GNU screen (screen, screen-256color, screen-256color-bce)
            printf "\eP\e]%s\007\e\\" "$1"
        else
            printf "\e]%s\e\\" "$1"
        fi
    }
    vterm_prompt_end() {
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
    }
    setopt PROMPT_SUBST
    PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
    alias reset='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi

export EDITOR=editor
