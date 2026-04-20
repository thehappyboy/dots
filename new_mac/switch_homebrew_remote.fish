#!/usr/bin/env fish

set -e HOMEBREW_BREW_GIT_REMOTE
git -C (brew --repo) remote set-url origin https://github.com/Homebrew/brew

set -e HOMEBREW_API_DOMAIN
set -e HOMEBREW_CORE_GIT_REMOTE
set BREW_TAPS (string join ':' (brew tap 2>/dev/null))

for tap in core cask cask-fonts cask-versions command-not-found services
    if string match -q "*:homebrew/$tap:*" ":$BREW_TAPS:"
        brew tap --custom-remote "homebrew/$tap" "https://github.com/Homebrew/homebrew-$tap"
    end
end

brew update

echo "Done. 如果之前永久配置了 HOMEBREW 环境变量，记得去 ~/.config/fish/config.fish 里删掉对应行。"
