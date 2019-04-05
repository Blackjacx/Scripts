#!/bin/bash
#
# Installs all needed software, ruby gems, Homebrew packages and casks
#
set -uo pipefail

command -v brew >/dev/null 2>&1 || { 
  echo "#################################################################"
  echo "Installing Homebrew"
  echo "#################################################################"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

echo "#################################################################"
echo "Installing Software via Homebrew"
echo "#################################################################"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Packages
brew tap jzaleski/homebrew-jzaleski # for apg
brew tap caskroom/fonts # for fonts

packages=(
  ag
  apg # generate strong passwords
  carthage
  coreutils
  curl
  doxygen
  e2fsprogs # e2fsprogs is a set of utilities for maintaining the ext2, ext3 and ext4 file systems.
  ffmpeg
  figlet
  git # Distributed version-control system for tracking changes in source code during software development
  grep
  htop
  httpie
  hub
  imagemagick
  jq # Command-line JSON processor
  mas # Mac App Store command line interface
  mplayer
  npm
  node
  openssl
  p0f
  pstree
  rbenv
  ripgrep
  shellcheck # static analysis tool for shell scripts
  tree
  watch
  wget
  zsh
)
brew install ${packages[@]}


casks=(
  # 1password # this installs the pricy 1password 7
  battle-net
  brisk
  charles
  dash
  deckset
  disk-inventory-x
  dropbox
  emacs
  fantastical
  flycut
  font-fira-code
  font-roboto
  font-source-code-pro
  # firefox # to work correctly with 1password install it manually
  gpg-suite
  # google-chrome # to work correctly with 1password install it manually
  handbrake
  iterm2
  provisionql
  qlimagesize
  qlmarkdown
  qlstephen
  quicklook-json
  scummvm
  sketch
  skype
  slack
  sourcetree
  spectacle
  spotify
  sublime-text
  telegram
  tunnelblick
  typora
  vlc
  wireshark
  wwdc
  zeplin
)
# Install brew cask
brew tap caskroom/cask
brew cask install ${casks[@]}

# Cleanup
brew cleanup
brew doctor

echo "#################################################################"
echo "Installing Xcode commandline tools"
echo "#################################################################"

xcode-select --install

echo "#################################################################"
echo "Installing Mac Appstore Apps"
echo "#################################################################"

mas install 497799835  # Xcode

echo "#################################################################"
echo "Installing Ruby Gems"
echo "#################################################################"

RUBY_GEMS=(
  bundler
)
sudo gem install ${RUBY_GEMS[@]}