current_path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

ln -sf ${current_path}/yabairc ${HOME}/.yabairc
ln -sf ${current_path}/skhdrc ${HOME}/.skhdrc
mkdir -p ${HOME}/.config/spacebar
ln -sf ${current_path}/spacebarrc ${HOME}/.config/spacebar/spacebarrc
