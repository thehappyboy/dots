#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# brew_install.sh - Automated macOS Setup Script
#
# Handles:
# 1. Proxy configuration
# 2. Homebrew installation (automatically handles Xcode Command Line Tools)
# 3. Dotfiles cloning/updating
# 4. Bundle installation (Brewfile)
# -----------------------------------------------------------------------------

set -uo pipefail

# --- Configuration ---
DOTFILES_REPO="https://github.com/thehappyboy/dots.git"
DOTFILES_DIR="${HOME}/dots"
BREWFILE_PATH="${DOTFILES_DIR}/new_mac/Brewfile"

# Proxy Settings
PROXY_HTTP="http://127.0.0.1:6152"
PROXY_SOCKS="socks5://127.0.0.1:6153"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Helpers ---

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

abort() {
  log_error "$1"
  exit 1
}

setup_proxy() {
  log_info "Configuring proxy settings for this session..."
  export http_proxy="$PROXY_HTTP"
  export https_proxy="$PROXY_HTTP"
  export all_proxy="$PROXY_SOCKS"
  log_success "Proxy set: HTTP=$PROXY_HTTP"
}

clone_dotfiles() {
  log_info "Checking dotfiles repository..."
  if [ -d "$DOTFILES_DIR" ]; then
    log_info "Directory '$DOTFILES_DIR' exists."
    if [ -d "$DOTFILES_DIR/.git" ]; then
      log_info "Pulling latest changes..."
      git -C "$DOTFILES_DIR" pull || log_warn "Failed to pull updates."
    else
      log_warn "'$DOTFILES_DIR' exists but is not a git repository."
    fi
  else
    log_info "Cloning '$DOTFILES_REPO' into '$DOTFILES_DIR'..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || abort "Failed to clone repository."
  fi
}

install_homebrew() {
  log_info "Checking Homebrew..."
  if ! command -v brew &>/dev/null; then
    log_info "Homebrew not found. Installing..."
    # This script will automatically trigger Xcode Command Line Tools installation if missing
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || abort "Homebrew installation failed."

    # Add to PATH for current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    log_success "Homebrew installed."
  else
    log_success "Homebrew is already installed."
  fi

  # Verify brew is working
  brew --version &>/dev/null || abort "Homebrew is installed but not working correctly."
}

install_dependencies() {
  if [ ! -f "$BREWFILE_PATH" ]; then
    log_warn "Brewfile not found at '$BREWFILE_PATH'. Skipping bundle install."
    return
  fi

  log_info "Installing dependencies from Brewfile..."
  # --verbose provides better feedback during long installs
  brew bundle --file "$BREWFILE_PATH" --verbose || log_warn "Some Brewfile items failed to install."
}

cleanup() {
  log_info "Cleaning up Homebrew..."
  brew cleanup --prune=all
}

# --- Main ---

main() {
  log_info "Starting new Mac setup script..."

  setup_proxy
  # Step 1: Install Homebrew (Handles Xcode Tools)
  install_homebrew
  # Step 2: Clone Dotfiles (Requires Git from Xcode Tools or System)
  clone_dotfiles
  # Step 3: Install Dependencies
  install_dependencies
  # cleanup

  log_success "Setup completed successfully!"
}

main "$@"
