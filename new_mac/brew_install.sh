##############################
# Prerequisite: Install Brew #
##############################

echo "Installing brew..."

if test ! $(which brew); then
	## Don't prompt for confirmation when installing homebrew
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
fi

echo "starting brew install..."

brew install bat
brew install fd
brew install ripgrep
brew install neofetch
brew install starship
brew install zoxide
brew install lazygit
brew install joshuto
brew install fish
brew install jq
brew install eza
brew install node
brew install stow
brew install nmap # use ncat for ssh proxy
brew install tmux

### Quicklook plugins https://github.com/sindresorhus/quick-look-plugins
brew install --cask qlcolorcode    # syntax highlighting in preview
brew install --cask qlstephen      # preview plaintext files without extension
brew install --cask qlmarkdown     # preview markdown files
brew install --cask quicklook-json # preview json files
brew install --cask epubquicklook  # preview epubs, make nice icons
brew install --cask quicklook-csv  # preview csvs

### Chat and work
brew install --cask feishu
brew install --cask wechat
brew install --cask obsidian
brew install --cask zotero
brew install --cask islide

### web tools
brew install adrive
brew install --cask microsoft-edge

### system enhancement
brew install --cask kitty
brew install --cask qspace-pro
brew install --cask easydict
brew install --cask tencent-lemnon
brew install --cask logi-options-plus
brew install --cask iina

### docker
brew install --cask docker
brew install docker-compose

### python
brew install python python-tk
brew install --cask miniconda

### fonts
font_list=(
	font-hurmit-nerd-font
	font-jetbrains-mono-nerd-font
	font-victor-mono-nerd-font
	font-hack-nerd-font
	font-sauce-code-pro-nerd-font
)

brew tap homebrew/cask-fonts

for font in "${fonts_list[@]}"; do
	brew install --cask "$font"
done

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

# remove default input method
cp ./com.apple.HIToolbox.plist ~/Library/Preferences/com.apple.HIToolbox.plist

exit
