#!/bin/bash
#
# Script to setup a MacBook from scratch!
# These commands are collected throughout the internet over time. 
# It is not guaranteed that every command will work!
#
# DISCLAIMER: Don't execute it if you do not know what you are doing!!!
#
set -uo pipefail

#
# Dotfiles
########################################################################

# export DOTFILES="$(cd "$(dirname "$0")"; pwd -P)/dotfiles"

#
# Defaults
########################################################################

#
# Misc
#

# stop photos from opening automatically when connecting an iphone
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true 
# Enable debug menu in Reminders to use the manual iCloud sync
defaults write com.apple.reminders RemindersDebugMenu -boolean true
# Use plain text as default format in TextEdit
defaults write com.apple.TextEdit RichText -int 0 
# Disable automatically rearrange Spaces based on recent use
defaults write com.apple.dock mru-spaces -bool false
# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Disable user interface sound effects
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

#
# Global
#

# Show filename extensions by default
defaults write -g AppleShowAllExtensions -bool true
# Disable auto-correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# Set a shorter Delay until key repeat
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
# Set super fast key repeat rate
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
# disable animations when opening and closing windows
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false 

#
# Finder
#

# Desktop: Show External hard drives
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# Desktop: Show Hard drives
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
# Desktop: Show Removable media
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Desktop: Show Mounted servers
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
# Show Statusbar
defaults write com.apple.finder ShowStatusBar -bool true
# Show Pathbar
defaults write com.apple.finder ShowPathbar -bool true
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# Remove dock auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

#
# Terminal
#

# iTerm appears quickly
defaults write com.googlecode.iterm2 HotkeyTermAnimationDuration -float 0.000001

#
# iOS Development
#

# Shows touches in simulator - nice for recording videos
defaults write http://com.apple.iphonesimulator ShowSingleTouches 1 
# Shows build time in Xcode's top activity bar
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES 

#
# Finally: restart all affected apps
#

for app in Safari Finder Dock Mail SystemUIServer; do 
  killall -HUP "$app" >/dev/null 2>&1; 
done

#
# Homebrew
########################################################################

# Install all neede software, Homebrew packages and casks
./software.sh