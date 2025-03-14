#! /bin/sh

MODULES="bat fish git nvim ruff tmux warp zsh"

for module in $MODULES; do
  stow $module
done
