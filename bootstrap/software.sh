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
brew cask upgrade

# Packages
packages=(
  ag # code-searching tool similar to ack, but faster
  apg # generate strong passwords
  bash # installs a modern version of bash
  carthage
  coreutils
  curl
  docker
  doxygen
  e2fsprogs # e2fsprogs is a set of utilities for maintaining the ext2, ext3 and ext4 file systems.
  ffmpeg
  figlet # making large letters out of ordinary text
  file
  git # distributed version-control system for tracking changes in source code during software development
  git-extras
  git-flow
  gource # software version control visualization
  grep
  htop
  httpie
  hub
  imagemagick
  jq # command-line JSON processor
  man
  mas # installs Mac App Store apps
  mplayer # free and open-source media player
  npm
  node
  openssl
  p0f
  pstree
  rbenv
  ripgrep # recursively searches directories for a regex pattern
  shellcheck # static analysis tool for shell scripts
  tree
  watch
  wget
  zsh
  zsh-completions
  zsh-syntax-highlighting
)
brew tap jzaleski/homebrew-jzaleski # support for apg
brew install ${packages[@]}

casks=(
  # 1password # this installs the pricy 1password 7
  aware # Menubar app for macOS that displays how long you've been actively using your computer.
  brisk # submitting radars
  charles
  cyberduck # FTP / Dropbox client 
  dash
  deckset
  disk-inventory-x
  docker
  dropbox
  emacs
  flycut
  font-fira-code
  font-microsoft-office
  font-roboto
  font-source-code-pro
  # firefox # to work correctly with 1password install it manually
  geektool
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
  sublime-merge
  sublime-text
  telegram
  texshop
  tunnelblick
  typora
  vlc
  wireshark
  wwdc
  zeplin
)
brew tap caskroom/cask # install cask system
brew tap caskroom/fonts # support for fonts
brew tap colindean/fonts-nonfree # Calibri, Cambria, ...
brew cask install ${casks[@]}

# Cleanup
brew cleanup
brew doctor

echo "#################################################################"
echo "Installing Python software"
echo "#################################################################"

# [ERROR] pip is not installed!
# pip install xkcdpass # memorable passsword generator

echo "#################################################################"
echo "Setting up ZSH with Oh-My-Zsh"
echo "Credits: https://stackoverflow.com/a/17649823/971329"
echo "#################################################################"

grep -q /usr/local/bin/zsh /etc/shells || {
  # append zsh to the end of /etc/shells
  sudo sh -c "echo /usr/local/bin/zsh >> /etc/shells"
  # change default shell
  chsh -s /usr/local/bin/zsh
  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

echo "#################################################################"
echo "Installing Ruby Gems"
echo "#################################################################"

RUBY_GEMS=(
  bundler
)
gem install ${RUBY_GEMS[@]}

echo "#################################################################"
echo "Installing AppStore Software"
echo "#################################################################"

# fantastical


