current_path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

if [ $1 == "install" ]; then
    dotfiles-rebuild yabai
fi
