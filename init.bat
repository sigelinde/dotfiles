mklink %HOMEPATH%"\.vimrc" %HOMEPATH%"\dotfiles\.vimrc"
mklink %HOMEPATH%"\.gvimrc" %HOMEPATH%"\dotfiles\.gvimrc"
mklink %HOMEPATH%"\.vimperatorrc" %HOMEPATH%"\dotfiles\.vimperatorrc"
mklink %HOMEPATH%"\.latexmkrc" %HOMEPATH%"\dotfiles\.latexmkrc"

git submodule init
git submodule update
