##############################
# Prerequisite: Install Brew #
##############################

# Install apple command line tools
echo "Installing command line tools..."
xcode-select --install

# Clone git repo containing config files
echo "Cloning config files..."
git clone https://github.com/thehappyboy/dots.git ~/.dotfiles

# Install Brew
echo "Installing brew..."
if [[ ! -e /usr/local/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "You have installed brew"

echo "Installing Brewfile contents..."
brew bundle --file ~/.dotfiles/new_mac/Brewfile

# Clear brew cache
brew cleanup --prune=all
