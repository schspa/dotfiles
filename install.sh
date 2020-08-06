#!/usr/bin/env bash

# dotfiles utility - https://gist.github.com/Jamesits/9bc4adfb1f299380c79e
# Set $DOTFILES to where you want to put your dotfiles.
# then run dotfiles-init someSoftware,
# and it will move all files starting with `.someSoftware` to the correct location
# then link them back,
# Which will produce a directory structure like:
#
# $ tree -aL 2 ~/projects-private/dotfiles
# ~/projects-private/dotfiles :
# ├── dotfiles.sh
# └── shell
#     └── .zshrc
#

current_path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

export DOTFILES=$current_path

dotfiles-count() {
    pushd >/dev/null 2>&1
    cd $HOME
    ls -ald .* | grep -v ^l | tee >(wc -l)
    popd >/dev/null 2>&1
}

dotfiles-init() {
    pushd >/dev/null 2>&1
    cd $HOME
    ls -ald .$1*;
    mkdir -p $DOTFILES/$1;
    mv .$1* $DOTFILES/$1;
    stow --dir=$DOTFILES --target=$HOME -vv $1
    popd >/dev/null 2>&1
}

dotfiles-rebuild() {
    stow --dir=$DOTFILES --target=$HOME -vv $@
}

if [ $1 == "install" ]; then
    dotfiles-rebuild i3wm
    dotfiles-rebuild tmux
    dotfiles-rebuild shell
    dotfiles-rebuild ssh
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        dotfiles-rebuild qutebrowser
        dotfiles-rebuild rime
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        mkdir -p $HOME/.qutebrowser/
        ln -sf ${current_path}/qutebrowser/config/config.py $HOME/.qutebrowser/config.py
        stow --dir=$DOTFILES/rime/.config/ibus --target=$HOME/Library/Rime -vv rime
    fi
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    source ${current_path}/macos/install.sh $@
fi
