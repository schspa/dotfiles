#!/bin/sh
#

# Default settings
DOTFILES=${DOTFILES:-~/.config/dotfiles}
REPO=${REPO:-schspa/dotfiles}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

fmt_error() {
    echo ${RED}"Error: $@"${RESET} >&2
}

fmt_underline() {
    echo "$(printf '\033[4m')$@$(printf '\033[24m')"
}

fmt_code() {
    echo "\`$(printf '\033[38;5;247m')$@${RESET}\`"
}

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

check_depencys() {
    packages=("git" "stow")

    for package in ${packages[@]}; do
        command_exists $package || {
            fmt_error "$package is not installed"
            exit 1
        }
    done
}

setup_dotfiles() {
    umask g-w,o-w

    echo "${BLUE}Cloning Dotfiles...${RESET}"

    command_exists git || {
        fmt_error "git is not installed"
        exit 1
    }

    git clone -c core.eol=lf -c core.autocrlf=false \
        -c fsck.zeroPaddedFilemode=ignore \
        -c fetch.fsck.zeroPaddedFilemode=ignore \
        -c receive.fsck.zeroPaddedFilemode=ignore \
        --depth=1 --branch "$BRANCH" "$REMOTE" "$DOTFILES" || {
        fmt_error "git clone of dotfiles repo failed"
        exit 1
    }

    pushd ~/dotfiles && ./dotfiles.sh install && popd

    echo
}

main() {
    setup_color

    check_depencys

    if [ -d "$DOTFILES" ]; then
        echo "${YELLOW}The $DOTFILES folder already exists ($ZSH).${RESET}"
        echo "You'll need to remove it if you want to reinstall."
        exit 1
    fi

    setup_dotfiles
    printf "$GREEN"
    cat <<'EOF'

                   __
(\,---------------'()'--o
 (_    _Dotfiles_    /~"
  (_)_)         (_)_)      ....is now installed!


EOF
    printf "$RESET"

}

main "$@"
