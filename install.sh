#!/usr/bin/env bash

current_path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

# setup tmux
if [ ! -d "$HOME/.tmux/plugins" ]; then
	echo "Clone tmux-plugins to $HOME/.tmux/plugins/tmp"
	mkdir -p ~/.tmux/plugins/
	git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi
ln -sf ${current_path}/tmux.conf $HOME/.tmux.conf
