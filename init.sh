#!/bin/bash
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
ln -sf ~/dotfiles/.vimperatorrc ~/.vimperatorrc
ln -sf ~/dotfiles/.bashrc ~/.bashrc

git submodule init
git submodule update
