#!/bin/bash
# This script assumes Arch Linux with X11.
# Make sure all submodules are cloned.

REPO_DIR=$(dirname -- "$(readlink -f -- "$0")")

pacman -S - < $REPO_DIR/pacman_packages

sudo ln -sf $REPO_DIR/xorg-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
ln -sf $REPO_DIR/.xinitrc $HOME/.xinitrc
ln -sf $REPO_DIR/.bash_profile $HOME/
ln -sf $REPO_DIR/.bashrc $HOME/
mkdir -p $HOME/.config/i3 && ln -sf $REPO_DIR/i3-config $_/config
mkdir -p $HOME/.config/kitty && ln -sf $REPO_DIR/kitty.conf $_/
mkdir -p $HOME/.config/polybar && ln -sf $REPO_DIR/polybar-config.ini $_/config.ini
mkdir -p $HOME/.config/nvim && ln -sf $REPO_DIR/init.vim $_/
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
/usr/bin/nvim +PlugInstall +qa

make -C $REPO_DIR/ble.sh install PREFIX=$HOME/.local
sudo ln -s /usr/bin/nvim /usr/bin/vim
