#!/bin/bash

# shell settings
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
ln -sf ~/dotfiles/.vimperatorrc ~/.vimperatorrc
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.latexmkrc ~/.latexmkrc

# pyenv
pushd ~/dotfiles
	git submodule init
	git submodule update

	# Install pyenv if unavalable
	pyenv_root="${HOME}/.pyenv"
	if [ ! -e $pyenv_root ]; then
		git clone git://github.com/yyuu/pyenv.git $pyenv_root
		git clone git://github.com/yyuu/pyenv-virtualenv.git $pyenv_root/plugins/pyenv-virtualenv
	fi
popd

# vs code
if [ `uname` == 'Darwin' ]; then
	pathTocode=~/Library/Application\ Support/Code/User/
else 
	pathTocode=~/.config/Code/User/
fi
if [ -d "$pathTocode" ]; then
	echo Installing vs code to $pathTocode
	ln -sf ~/dotfiles/vscode/settings.json "$pathTocode"
	ln -sf ~/dotfiles/vscode/keybindings.json "$pathTocode"
fi

