##############################
# Prerequisite: Install Brew #
##############################

echo "Installing brew..."

if test ! $(which brew); then
	## Don't prompt for confirmation when installing homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
fi

echo "starting brew install..."

brew install bat
brew install fd
brew install ripgrep
brew install neofetch
brew install starship
brew install zoxide
brew install lazygit
brew install pandoc
brew install gh
brew install joshuto
brew install fish
brew install jq
brew install eza
brew install node
brew install stow
brew install nmap # use ncat for ssh proxy
brew install tmux
brew install gnu-sed
brew install fzf
$(brew --prefix)/opt/fzf/install --all

brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

### Chat and work
brew install --cask lark
brew install --cask wechat
brew install --cask obsidian
brew install --cask zotero-beta
brew install --cask islide

### web tools
brew install adrive
brew install --cask microsoft-edge-dev
brew install --cask arc

### system enhancement
brew install --cask kitty
brew install --cask qspace-pro
brew install --cask easydict
brew install --cask tencent-lemon
brew install --cask logi-options-plus
brew install --cask iina
brew install --cask macfuse
brew install --cask plistedit-pro

### docker
brew install --cask docker
brew install docker-compose
mkdir -p ~/.docker/cli-plugins
ln -sfn /usr/local/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose

### python
brew install --cask miniconda
brew install --HEAD neovim

### fonts
#

brew install --cask font-sauce-code-pro-nerd-font font-victor-mono-nerd-font

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

exit
