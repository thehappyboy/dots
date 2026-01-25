#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# settings.sh - macOS System Configuration Script
#
# Configures macOS system preferences for developers and power users.
# -----------------------------------------------------------------------------

set -uo pipefail

# --- Colors & Logging ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- Initialization ---

init_sudo() {
  log_info "Closing 'System Settings' to prevent overrides..."
  osascript -e 'tell application "System Preferences" to quit'

  log_info "Requesting administrator privileges..."
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until script has finished
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
}

# --- Configuration Functions ---

config_security() {
  log_info "Configuring Security settings..."

  # Disable Gatekeeper (Allow apps from anywhere)
  log_warn "Disabling Gatekeeper..."
  sudo spctl --global-disable
  open "x-apple.systempreferences:com.apple.preference.security?Security"

  # Clear password policies
  sudo pwpolicy -clearaccountpolicies
}

config_general_ui() {
  log_info "Configuring General UI/UX..."

  # Disable auto-fill heuristic
  defaults write -g NSAutoFillHeuristicControllerEnabled -bool false

  # Sidebar icon size: Medium
  defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

  # Always show scrollbars
  defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

  # Fast window resize
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

  # Expanded save panels
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  # Expanded print panels
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Save to disk by default (not iCloud)
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Quit printer app when finished
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  # Disable "Are you sure you want to open this application?" dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Disable crash reporter
  defaults write com.apple.CrashReporter DialogType -string "none"

  # Show IP/Hostname/OS ver on login screen (click clock)
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
}

config_input() {
  log_info "Configuring Input (Keyboard/Typing)..."

  # Disable auto-correct/substitution features (annoying for coding)
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
}

config_peripherals() {
  log_info "Configuring Trackpad, Mouse, and Keyboard..."

  # Use F1-F12 as standard function keys
  defaults write -globalDomain com.apple.keyboard.fnState -int 1

  # Trackpad: Enable tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
}

config_screen() {
  log_info "Configuring Screen and Capture..."

  # Save screenshots to Desktop
  defaults write com.apple.screencapture location -string "${HOME}/Desktop"

  # Save screenshots as PNG
  defaults write com.apple.screencapture type -string "png"

  # Disable screenshot shadow
  defaults write com.apple.screencapture disable-shadow -bool true
}

config_finder() {
  log_info "Configuring Finder..."

  # Quit Finder via Cmd+Q
  defaults write com.apple.finder QuitMenuItem -bool true

  # Disable window animations
  defaults write com.apple.finder DisableAllAnimations -bool true

  # New window target: Desktop
  defaults write com.apple.finder NewWindowTarget -string "PfDe"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

  # Desktop icons
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  # View options
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

  # Keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  # Search current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # No warning when changing extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Avoid .DS_Store on network/USB
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Disk images verification
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

  # Auto-open new volumes
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

  # Default view style: List view
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # No empty trash warning
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  # Show ~/Library
  chflags nohidden ~/Library
}

config_dock() {
  log_info "Configuring Dock..."

  # Tile size
  defaults write com.apple.dock tilesize -int 36

  # Remove all persistent apps (start clean)
  defaults write com.apple.dock persistent-apps -array

  # Orientation: Bottom
  defaults write com.apple.dock orientation -string "bottom"

  # Disable launch animation
  defaults write com.apple.dock launchanim -bool false

  # Fast Mission Control animation
  defaults write com.apple.dock expose-animation-duration -float 0.1

  # Auto-hide Dock
  defaults write com.apple.dock autohide -bool false

  # Show hidden apps as translucent
  defaults write com.apple.dock showhidden -bool true

  # Don't show recent apps
  defaults write com.apple.dock show-recents -bool false
}

config_apps() {
  log_info "Configuring Applications..."

  # Photos: Prevent auto-open
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
}

apply_changes() {
  log_info "Restarting apps to apply changes..."

  for app in "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" >/dev/null 2>&1
  done
}

# --- Main ---

main() {
  log_info "Starting macOS configuration script..."

  init_sudo

  config_security
  config_general_ui
  config_input
  config_peripherals
  config_screen
  config_finder
  config_dock
  config_apps

  apply_changes

  log_success "Configuration complete!"
  log_info "Note: A restart is recommended for all changes to take effect."
}

main "$@"
