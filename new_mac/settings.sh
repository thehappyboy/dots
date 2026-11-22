#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# settings.sh - macOS System Configuration Script
#
# Configures macOS system preferences for developers and power users.
#
# Usage:
#   ./settings.sh                 # apply settings
#   DRY_RUN=1 ./settings.sh       # print commands without applying
#   CLEAN_DOCK=1 ./settings.sh    # also remove every icon from the Dock
#   DISABLE_GATEKEEPER=0 ./settings.sh
#                                 # keep Gatekeeper enabled (safer)
#
# Some changes (modifier keys, symbolic hotkeys) only take effect after a
# logout/login, or after reconnecting an external keyboard.
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

# --- Helpers ---

DRY_RUN="${DRY_RUN:-0}"

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '  [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# defaults write / defaults -currentHost write
dwrite() { run defaults write "$@"; }
dhost() { run defaults -currentHost write "$@"; }

os_major_version() {
  sw_vers -productVersion | cut -d. -f1
}

# --- Initialization ---

init_sudo() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "Dry run: skipping administrator prompt."
    return
  fi

  log_info "Closing 'System Settings' to prevent overrides..."
  osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

  log_info "Requesting administrator privileges..."
  if ! sudo -v; then
    log_error "Administrator privileges are required."
    exit 1
  fi

  # Keep-alive: update existing `sudo` time stamp until script has finished
  ( while true; do
      sudo -n true
      sleep 60
      kill -0 "$$" || exit
    done 2>/dev/null ) &
}

# --- Configuration Functions ---

config_security() {
  log_info "Configuring Security settings..."

  # Disable Gatekeeper (allow apps from anywhere).
  # Set DISABLE_GATEKEEPER=0 to keep the default protection.
  if [[ "${DISABLE_GATEKEEPER:-1}" == "1" ]]; then
    log_warn "Disabling Gatekeeper..."
    run sudo spctl --global-disable
  else
    log_info "Keeping Gatekeeper enabled."
  fi

  # Clear password policies
  run sudo pwpolicy -clearaccountpolicies

  # Disable the Guest user account
  run sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

  # Show IP/Hostname/OS ver on login screen (click clock)
  run sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
}

config_general_ui() {
  log_info "Configuring General UI/UX..."

  # Disable auto-fill heuristic
  dwrite -g NSAutoFillHeuristicControllerEnabled -bool false

  # Sidebar icon size: Medium
  dwrite NSGlobalDomain NSTableViewDefaultSizeMode -int 2

  # Always show scrollbars
  dwrite NSGlobalDomain AppleShowScrollBars -string "Always"

  # Fast window resize
  dwrite NSGlobalDomain NSWindowResizeTime -float 0.001

  # Don't minimize/zoom when double-clicking a title bar
  dwrite NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

  # Expanded save panels
  dwrite NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  dwrite NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  # Expanded print panels
  dwrite NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  dwrite NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Save to disk by default (not iCloud)
  dwrite NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Quit printer app when finished
  dwrite com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  # Disable "Are you sure you want to open this application?" dialog
  dwrite com.apple.LaunchServices LSQuarantine -bool false

  # Disable crash reporter
  dwrite com.apple.CrashReporter DialogType -string "none"
}

config_input() {
  log_info "Configuring Input (Keyboard/Typing)..."

  # Disable auto-correct/substitution features (annoying for coding)
  dwrite -g NSAutomaticCapitalizationEnabled -bool false
  dwrite -g NSAutomaticDashSubstitutionEnabled -bool false
  dwrite -g NSAutomaticPeriodSubstitutionEnabled -bool false
  dwrite -g NSAutomaticQuoteSubstitutionEnabled -bool false
  dwrite -g NSAutomaticSpellingCorrectionEnabled -bool false

  # Use F1-F12 as standard function keys
  dwrite NSGlobalDomain com.apple.keyboard.fnState -bool true

  # Fast keyboard repeat rate
  dwrite NSGlobalDomain KeyRepeat -int 1
  dwrite NSGlobalDomain InitialKeyRepeat -int 15
}

config_modifier_keys() {
  log_info "Configuring modifier keys (Caps Lock <-> Control)..."

  # macOS stores key remaps per keyboard in ByHost global preferences:
  #   com.apple.keyboard.modifiermapping.<vendorID>-<productID>-0
  # HID usages used below:
  #   30064771296 = Left Control
  #   30064771129 = Caps Lock
  #   30064771300 = Control
  # The three entries make Caps Lock act as Control, Control act as Caps Lock.
  local remap_src=(
    "30064771296"
    "30064771129"
    "30064771300"
  )
  local remap_dst=(
    "30064771129"
    "30064771300"
    "30064771129"
  )

  local ids=()
  local id vid pid existing

  # Keyboards currently attached (UsagePage 1 / Usage 6).
  while read -r vid pid; do
    [[ -n "$vid" && -n "$pid" ]] || continue
    ids+=("$((vid))-$((pid))-0")
  done < <(hidutil list 2>/dev/null | awk '$4 == "1" && $5 == "6" {print $1, $2}')

  # Keep mappings that already exist for keyboards that may be disconnected.
  while read -r existing; do
    [[ -n "$existing" ]] && ids+=("$existing")
  done < <(defaults -currentHost read -g 2>/dev/null \
             | grep -o 'com\.apple\.keyboard\.modifiermapping\.[0-9][0-9-]*' \
             | sed 's/.*modifiermapping\.//')

  # De-duplicate (avoid mapfile: macOS ships bash 3.2).
  if (( ${#ids[@]} > 0 )); then
    local sorted
    sorted=$(printf '%s\n' "${ids[@]}" | sort -u)
    ids=()
    while IFS= read -r id; do
      [[ -n "$id" ]] && ids+=("$id")
    done <<< "$sorted"
  fi

  # Fallback for a fresh Mac where hidutil reports nothing useful.
  if (( ${#ids[@]} == 0 )); then
    ids=("1452-641-0")
    log_warn "No keyboard detected; falling back to 1452-641-0 (Apple internal keyboard)."
  fi

  for id in "${ids[@]}"; do
    log_info "  -> keyboard ${id}"
    local args=()
    local i
    for i in "${!remap_src[@]}"; do
      args+=("{HIDKeyboardModifierMappingSrc = ${remap_src[$i]}; HIDKeyboardModifierMappingDst = ${remap_dst[$i]};}")
    done
    dhost -g "com.apple.keyboard.modifiermapping.${id}" -array "${args[@]}"
  done

  log_warn "Modifier remaps apply after logout/login or reconnecting the keyboard."
}

config_keyboard_shortcuts() {
  log_info "Disabling screenshot and Spotlight keyboard shortcuts..."

  # AppleSymbolicHotKeys:
  #   28/29/30/31 = screenshot shortcuts (Cmd+Shift+3/4 and clipboard variants)
  #   184         = screenshot & recording options (Cmd+Shift+5)
  #   64          = Spotlight search (Cmd+Space)
  local hotkey_ids=(28 29 30 31 184 64)
  local id
  for id in "${hotkey_ids[@]}"; do
    dwrite com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$id" '{ enabled = 0; }'
  done

  log_warn "Shortcut changes apply after logout/login."
}

config_peripherals() {
  log_info "Configuring Trackpad and Mouse..."

  # Trackpad: Enable tap to click (built-in and Bluetooth trackpads)
  dwrite com.apple.AppleMultitouchTrackpad Clicking -bool true
  dwrite com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  dhost -g com.apple.mouse.tapBehavior -int 1
  dwrite NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Trackpad: Enable three-finger drag
  dwrite com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
  dwrite com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
  dhost -g com.apple.trackpad.threeFingerDragGesture -bool true

  # Three-finger drag conflicts with three-finger swipe/tap gestures
  dwrite com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
  dwrite com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
  dwrite com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
  dhost -g com.apple.trackpad.threeFingerHorizSwipeGesture -int 0
  dhost -g com.apple.trackpad.threeFingerVertSwipeGesture -int 0
  dhost -g com.apple.trackpad.threeFingerTapGesture -int 0
}

config_window_manager() {
  log_info "Configuring Desktop & Stage Manager..."

  if (( $(os_major_version) < 13 )); then
    log_warn "Stage Manager settings require macOS 13 or later; skipping."
    return
  fi

  # "Click wallpaper to reveal desktop": Only in Stage Manager
  # (true = Always, false = Only in Stage Manager)
  dwrite com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

  # Stage Manager / desktop widget behavior
  dwrite com.apple.WindowManager AutoHide -bool false
  dwrite com.apple.WindowManager StageManagerHideWidgets -bool false
  dwrite com.apple.WindowManager StandardHideWidgets -bool false

  # Window tiling (macOS 15+): leave edge-drag tiling disabled
  if (( $(os_major_version) >= 15 )); then
    dwrite com.apple.WindowManager EnableTilingByEdgeDrag -bool false
    dwrite com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
    dwrite com.apple.WindowManager EnableTiledWindowMargins -bool false
    dwrite com.apple.WindowManager EnableTilingOptionAccelerator -bool false
  fi
}

config_screen() {
  log_info "Configuring Screen and Capture..."

  # Save screenshots to Desktop
  dwrite com.apple.screencapture location -string "${HOME}/Desktop"

  # Save screenshots as PNG
  dwrite com.apple.screencapture type -string "png"

  # Disable screenshot shadow
  dwrite com.apple.screencapture disable-shadow -bool true
}

config_finder() {
  log_info "Configuring Finder..."

  # Quit Finder via Cmd+Q
  dwrite com.apple.finder QuitMenuItem -bool true

  # Disable window animations
  dwrite com.apple.finder DisableAllAnimations -bool true

  # New window target: Desktop
  dwrite com.apple.finder NewWindowTarget -string "PfDe"
  dwrite com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

  # Desktop icons
  dwrite com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  dwrite com.apple.finder ShowHardDrivesOnDesktop -bool false
  dwrite com.apple.finder ShowMountedServersOnDesktop -bool false
  dwrite com.apple.finder ShowRemovableMediaOnDesktop -bool true

  # View options
  dwrite NSGlobalDomain AppleShowAllExtensions -bool true
  dwrite com.apple.finder ShowSidebar -bool true
  dwrite com.apple.finder ShowStatusBar -bool true
  dwrite com.apple.finder ShowPathbar -bool true
  dwrite com.apple.finder _FXShowPosixPathInTitle -bool true

  # Keep folders on top when sorting by name
  dwrite com.apple.finder _FXSortFoldersFirst -bool true

  # Search current folder by default
  dwrite com.apple.finder FXDefaultSearchScope -string "SCcf"

  # No warning when changing extension
  dwrite com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Avoid .DS_Store on network/USB
  dwrite com.apple.desktopservices DSDontWriteNetworkStores -bool true
  dwrite com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Disk images verification
  dwrite com.apple.frameworks.diskimages skip-verify -bool true
  dwrite com.apple.frameworks.diskimages skip-verify-locked -bool true
  dwrite com.apple.frameworks.diskimages skip-verify-remote -bool true

  # Auto-open new volumes
  dwrite com.apple.frameworks.diskimages auto-open-ro-root -bool true
  dwrite com.apple.frameworks.diskimages auto-open-rw-root -bool true
  dwrite com.apple.finder OpenWindowForNewRemovableDisk -bool true

  # Default view style: List view
  dwrite com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # No empty trash warning
  dwrite com.apple.finder WarnOnEmptyTrash -bool false

  # Show ~/Library
  run chflags nohidden ~/Library 2>/dev/null || true
}

config_dock() {
  log_info "Configuring Dock..."

  # Tile size
  dwrite com.apple.dock tilesize -int 36

  # Orientation: Bottom
  dwrite com.apple.dock orientation -string "bottom"

  # Minimize windows using the scale effect (not genie)
  dwrite com.apple.dock mineffect -string "scale"

  # Disable launch animation
  dwrite com.apple.dock launchanim -bool false

  # Fast Mission Control animation
  dwrite com.apple.dock expose-animation-duration -float 0.1

  # Don't auto-hide the Dock
  dwrite com.apple.dock autohide -bool false

  # Show hidden apps as translucent
  dwrite com.apple.dock showhidden -bool true

  # Don't show recent apps
  dwrite com.apple.dock show-recents -bool false

  # Bottom-right hot corner: Quick Note (14), no modifier
  dwrite com.apple.dock wvous-br-corner -int 14
  dwrite com.apple.dock wvous-br-modifier -int 0

  # Optionally start with an empty Dock.
  # Default is off so running this on an existing Mac does not remove icons.
  if [[ "${CLEAN_DOCK:-0}" == "1" ]]; then
    log_warn "CLEAN_DOCK=1: removing all Dock icons..."
    dwrite com.apple.dock persistent-apps -array
  fi
}

config_menu_bar() {
  log_info "Configuring menu bar..."

  # Clock: weekday only, no date, 12-hour with AM/PM
  dwrite com.apple.menuextra.clock ShowDate -bool false
  dwrite com.apple.menuextra.clock ShowDayOfWeek -bool true
  dwrite com.apple.menuextra.clock ShowAMPM -bool true

  # Control Center / menu bar items
  dwrite com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true
  dwrite com.apple.controlcenter "NSStatusItem Visible Battery" -bool true
  dwrite com.apple.controlcenter "NSStatusItem Visible BentoBox" -bool true
  dwrite com.apple.controlcenter "NSStatusItem Visible Clock" -bool true
  dwrite com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool false
  dwrite com.apple.controlcenter "NSStatusItem Visible AudioVideoModule" -bool false
  dwrite com.apple.controlcenter "NSStatusItem Visible Shortcuts" -bool false
}

config_privacy() {
  log_info "Configuring Privacy..."

  # Disable personalized Apple advertising
  dwrite com.apple.AdLib allowApplePersonalizedAdvertising -bool false
}

config_apps() {
  log_info "Configuring Applications..."

  # Photos: Prevent auto-open
  dhost com.apple.ImageCapture disableHotPlug -bool true
}

apply_changes() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "Dry run: skipping app restarts."
    return
  fi

  log_info "Restarting apps to apply changes..."

  for app in "Dock" "Finder" "SystemUIServer" "ControlCenter" "WindowManager"; do
    killall "${app}" >/dev/null 2>&1 || true
  done
}

# --- Main ---

main() {
  log_info "Starting macOS configuration script..."

  if [[ "$DRY_RUN" == "1" ]]; then
    log_warn "DRY_RUN=1: no settings will be changed."
  fi

  init_sudo

  config_security
  config_general_ui
  config_input
  config_modifier_keys
  config_keyboard_shortcuts
  config_peripherals
  config_window_manager
  config_screen
  config_finder
  config_dock
  config_menu_bar
  config_privacy
  config_apps

  apply_changes

  log_success "Configuration complete!"
  log_info "Log out and back in (or restart) to apply modifier keys and keyboard shortcuts."
}

main "$@"
