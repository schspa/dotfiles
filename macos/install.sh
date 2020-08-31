current_path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

if [ "x"$1 = x"install" ]; then
    DOTFILES=$current_path dotfiles-rebuild yabai
fi
