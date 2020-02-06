#!/usr/bin/env bash

current_path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

# setup tmux
if [ ! -d "$HOME/.tmux/plugins" ]; then
	echo "Clone tmux-plugins to $HOME/.tmux/plugins/tmp"
	mkdir -p ~/.tmux/plugins/
	git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi
ln -sf ${current_path}/tmux.conf $HOME/.tmux.conf
ln -sf ${current_path}/.zshrc $HOME/.zshrc

# setup qutuebrowser
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	# ~/.config/qutebrowser/config.py
	mkdir -p $HOME/.config/qutebrowser/
	ln -sf ${current_path}/qutebrowser/config/config.py $HOME/.config/qutebrowser/config.py
    # set up i3wm
	ln -sf ${current_path}/config/i3 $HOME/.config/i3
	ln -sf ${current_path}/config/polybar $HOME/.config/polybar
	ln -sf ${current_path}/config/mpd $HOME/.config/mpd
	ln -sf ${current_path}/config/autorandr $HOME/.config/autorandr
elif [[ "$OSTYPE" == "darwin"* ]]; then
	# ~/.qutebrowser/config.py
	mkdir -p $HOME/.qutebrowser/
	ln -sf ${current_path}/qutebrowser/config/config.py $HOME/.qutebrowser/config.py
elif [[ "$OSTYPE" == "msys" || "OSTYPE" == "cygwin" || "OSTYPE" == "win32" ]]; then
	# %APPDATA%/qutebrowser/config/config.py
    # I'm not sure this can happen.
	# Not test on windows yet
else:
    # Unknown.
fi

