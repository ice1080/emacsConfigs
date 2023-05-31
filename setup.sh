
if [ -f ~/.emacs ]; then
  mv -f ~/.emacs ~/.emacs.old
fi

ln -sf "$(pwd -P)/baseEmacsInitFile.el" ~/.emacs
