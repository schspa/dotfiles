#!/usr/bin/env bash

current_path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

# setup tmux
if [ ! -d "$HOME/.tmux/plugins" ]; then
	echo "Clone tmux-plugins to $HOME/.tmux/plugins/tmp"
	mkdir -p ~/.tmux/plugins/
	git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi
ln -sf ${current_path}/tmux.conf $HOME/.tmux.conf

# setup qutuebrowser
ln -sf ${current_path}/qutebrowser/config/config.py $HOME/.config/qutebrowser/config.py

ln -sf ${current_path}/config/i3 $HOME/.config/i3
ln -sf ${current_path}/config/polybar $HOME/.config/polybar
ln -sf ${current_path}/config/mpd $HOME/.config/mpd
