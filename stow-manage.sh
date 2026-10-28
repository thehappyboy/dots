#! /bin/sh

MODULES="npm uv bat fish git nvim ruff tmux warp zsh zed ghostty starship"

for module in $MODULES; do
  stow "$module"
done

# Sublime Text - target 是 ~/Library/... 下的 Packages/User
stow --dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)" \
  --target="$HOME/Library/Application Support/Sublime Text/Packages/User" sublime
