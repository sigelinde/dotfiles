#!/bin/bash
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
ln -sf ~/dotfiles/.vimperatorrc ~/.vimperatorrc
ln -sf ~/dotfiles/.bashrc ~/.bashrc

git submodule init
git submodule update

# Install pyenv if unavalable
pyenv_root="${HOME}/.pyenv"
if [ ! -e $pyenv_root ]; then
	git clone git://github.com/yyuu/pyenv.git $pyenv_root
fi

