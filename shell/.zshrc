# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -d /opt/homebrew ]; then
    export MY_HOMEBREW_BASE=/opt/homebrew
else
    export MY_HOMEBREW_BASE=/usr/local
fi

if [ -d ${MY_HOMEBREW_BASE}/bin ]; then
    export PATH="${MY_HOMEBREW_BASE}/bin:$PATH"
fi

DOTFILES_DIR=$(dirname `realpath ~/.zshrc`)

if [ -d $DOTFILES_DIR ]; then
	source $DOTFILES_DIR/.shellrc
fi

DOTFILES_DIR=$(dirname $DOTFILES_DIR)

export PATH=$HOME/bin:$DOTFILES_DIR/bin:/usr/local/bin:$PATH

eval "$(direnv hook zsh)"

[[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return
if [[ "$INSIDE_EMACS" == 'vterm' ]]; then
    export ANTIGEN_CACHE=$HOME/.antigen/init-vterm.zsh
fi

antigen_bases=(
    "${HOME}/.config/antigen.zsh"
    "/usr/local/share/antigen/antigen.zsh"
    "/usr/share/zsh/share/antigen.zsh"
    "/usr/share/zsh-antigen/antigen.zsh"
    "/opt/homebrew/share/antigen/antigen.zsh")

for antigen_base in "${antigen_bases[@]}"
do
    if [ -e $antigen_base ]; then
        source $antigen_base
    fi
done

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

plugins=(
    wd
    z
    sudo
	docker
    git
    emacs
    pip
    command-not-found
    # Syntax highlighting bundle.
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-autosuggestions
)

if [[ "$OSTYPE" == "darwin"* ]]; then
	plugins+=(
		brew
		macos
	)
fi

for plugin in $plugins; do
    antigen bundle $plugin
done

if [[ "$INSIDE_EMACS" == 'vterm' ]]; then
    antigen theme agnoster
else
    antigen theme romkatv/powerlevel10k
    POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
fi

# Tell Antigen that you're done.
antigen apply

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
    OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
    zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
    zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
