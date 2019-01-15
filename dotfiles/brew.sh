# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Packages
brew install git
brew install tree
brew install node
brew install jq
brew install ag
brew install curl
brew install wget
brew install doxygen
brew install rbenv
brew install openssl
brew install httpie
brew install htop
brew install p0f
brew install figlet
brew install e2fsprogs
brew install coreutils
brew install man
brew install grep
brew install watch
brew install pstree
brew install mplayer
brew install carthage
brew install hub
brew install ripgrep
brew install zsh
brew install ffmpeg --with-libass --with-fontconfig
brew install imagemagick --with-fontconfig

# brew cask installs
brew tap caskroom/homebrew install-cask || true
brew cask install alfred
brew cask install brisk
brew cask install emacs
brew cask install iterm2 
brew cask install typora
brew cask install provisionql
brew cask install qlimagesize
brew cask install qlmarkdown
brew cask install qlstephen
brew cask install quicklook-json
brew cask install sublime-text
brew cask install wireshark
brew cask install wwdc
brew cask install vlc
brew cask install tunnelblick
brew cask install spotify
brew cask install spectacle
brew cask install sourcetree
brew cask install slack
brew cask install skype
brew cask install sketch
brew cask install scummvm
brew cask install gpg-suite 
brew cask install google-chrome
brew cask install firefox
brew cask install flycut
brew cask install fantastical
brew cask install filezilla
brew cask install dropbox
brew cask install disk-inventory-x
brew cask install diffmerge
brew cask install deckset
brew cask install dash
brew cask install charles
brew cask install adobe-acrobat-reader
brew cask install 1password
brew cask install handbrake
brew cask install etcher
brew cask install audioslicer
brew cask install bettertouchtool
brew cask install geektool # http://projects.tynsoe.org/en/geektool/

# Cleanup
brew cleanup
brew doctor