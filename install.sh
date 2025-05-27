#!/bin/bash
# This script assumes Arch Linux with X11.
# Make sure all submodules are cloned.

REPO_DIR=$(dirname -- "$(readlink -f -- "$0")")

sudo pacman -S - < $REPO_DIR/pacman-packages

sudo ln -sf $REPO_DIR/.bash_profile $HOME/
sudo ln -sf $REPO_DIR/.bashrc $HOME/
mkdir -p $HOME/.config/nvim && sudo ln -sf $REPO_DIR/init.vim $_/
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
/usr/bin/nvim +PlugInstall +qa

make -C $REPO_DIR/ble.sh install PREFIX=$HOME/.local
ln -s /usr/bin/nvim /usr/bin/vim
