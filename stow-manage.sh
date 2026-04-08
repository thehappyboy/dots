#! /bin/sh

MODULES="npm uv bat fish git nvim ruff tmux warp zsh zed ghostty starship"

for module in $MODULES; do
  stow $module
done
