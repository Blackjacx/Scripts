#!/bin/bash
#
# Script to setup a MacBook from scratch!
# These commands are collected throughout the internet over time. 
# It is not guaranteed that every command will work!
#
# DISCLAIMER: Don't execute it if you do not know what you are doing!!!

#
# Dotfiles
########################################################################

# DOTFILES="$HOME/.dotfiles"
# git clone git@github.com:blackjacx/dotfiles.git $DOTFILES

#
# Defaults
########################################################################

#
# Misc
#

# Set fast key repeat rate
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# show file extensions
defaults write -g AppleShowAllExtensions -bool true 

# stop photos from opening automatically when connecting an iphone
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true 

# disable animations when opening and closing windows
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false 

# Enable debug menu in Reminders to use the manual iCloud sync
defaults write com.apple.reminders RemindersDebugMenu -boolean true

# Use plain text as default format in TextEdit
defaults write com.apple.TextEdit RichText -int 0 

# Disable automatically rearrange Spaces based on recent use
defaults write com.apple.dock mru-spaces -bool false

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write -g AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable user interface sound effects
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

#
# Terminal
#
defaults write com.googlecode.iterm2 HotkeyTermAnimationDuration -float 0.000001 # makes iTerm appear quick

#
# iOS Development
#
defaults write http://com.apple.iphonesimulator ShowSingleTouches 1 # Shows touches in simulator - nice for recording videos
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES # Shows build time in Xcode's top activity bar

killall Finder # restart finder

#
# Homebrew
########################################################################

# Install all neede software, Homebrew packages and casks
./software.sh

#
# Shell (ZSH)
# Install via Homebrew: https://stackoverflow.com/a/17649823/971329
########################################################################

export ZSH="$HOME/.oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"