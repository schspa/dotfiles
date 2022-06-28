DOTFILES_DIR=$(dirname `realpath $HOME/.bashrc`)

if [ -d $DOTFILES_DIR ]; then
	source $DOTFILES_DIR/.shellrc
fi
