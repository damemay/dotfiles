#!/bin/bash
# This script assumes Arch Linux with X11.
# Make sure all submodules are cloned.

REPO_DIR=$(dirname "$0")

pacman -S - < $REPO_DIR/pacman_packages
sudo cp /etc/X11/xinit/xinitrc $HOME/.xinitrc
cat $REPO_DIR/.xinitrc >> $HOME/.xinitrc
cp $REPO_DIR/.bash_profile $HOME/
cp $REPO_DIR/.bashrc $HOME/
make -C $REPO_DIR/ble.sh install PREFIX=$HOME/.local
mkdir -p $HOME/.config/i3 && cp $REPO_DIR/i3-config $_/config
mkdir -p $HOME/.config/kitty && cp $REPO_DIR/kitty.conf $_/
mkdir -p $HOME/.config/polybar && cp $REPO_DIR/polybar-config.ini $_/config.ini
sudo ln -s /usr/bin/nvim /usr/bin/vim
mkdir -p $HOME/.config/nvim && cp $REPO_DIR/init.vim $_/
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
/usr/bin/nvim +PlugInstall +qa
