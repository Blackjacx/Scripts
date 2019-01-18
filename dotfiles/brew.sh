# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Packages
brew install ag
brew install carthage
brew install coreutils
brew install curl
brew install doxygen
brew install e2fsprogs
brew install ffmpeg
brew install figlet
brew install git
brew install grep
brew install htop
brew install httpie
brew install hub
brew install imagemagick
brew install jq
brew install man
brew install mplayer
brew install node
brew install openssl
brew install p0f
brew install pstree
brew install rbenv
brew install ripgrep
brew install tree
brew install watch
brew install wget
brew install zsh

# brew cask installs
brew tap caskroom/homebrew install-cask
# brew cask install 1password # this installs the pricy 1password 7
brew cask install alfred
brew cask install brisk
brew cask install charles
brew cask install dash
brew cask install deckset
brew cask install disk-inventory-x
brew cask install dropbox
brew cask install emacs
brew cask install fantastical
brew cask install flycut
# brew cask install firefox # to work correctly with 1password install it manually
brew cask install gpg-suite
# brew cask install google-chrome # to work correctly with 1password install it manually
brew cask install handbrake
brew cask install iterm2
brew cask install provisionql
brew cask install qlimagesize
brew cask install qlmarkdown
brew cask install qlstephen
brew cask install quicklook-json
brew cask install scummvm
brew cask install sketch
brew cask install skype
brew cask install slack
brew cask install sourcetree
brew cask install spectacle
brew cask install spotify
brew cask install sublime-text
brew cask install tunnelblick
brew cask install typora
brew cask install vlc
brew cask install wireshark
brew cask install wwdc

# Cleanup
brew cleanup
brew doctor