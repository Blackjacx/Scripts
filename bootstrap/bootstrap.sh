#!/usr/bin/env zsh
#
# Script to setup a MacBook from scratch!
# These commands are collected throughout the internet over time. 
# It is not guaranteed that every command will work!
#
# DISCLAIMER: Don't execute it if you do not know what you are doing!!!
#
set -uo pipefail
#set -x

SCRIPT_DIR="${HOME}/dev/scripts"

# Imprort global functionality
[ -f "$SCRIPT_DIR/imports.sh" ] && source "$SCRIPT_DIR/imports.sh"

# TODOS
# https://nerdlogger.com/2012/07/30/get-control-of-mountain-lion-with-a-huge-list-of-command-line-tweaks/
# - new finder windows open home folder
#

configureSystem() {

  #
  # TODO: 
  #
  # - include essential entries from https://gist.github.com/brandonb927/3195465
  #

  printf "\n#################################################################\n"
  printf "Configure System\n"
  printf "#################################################################\n\n"

  #
  # Misc
  #

  # stop photos from opening automatically when connecting an iphone
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true 
  # Enable debug menu in Reminders to use the manual iCloud sync
  defaults write com.apple.reminders RemindersDebugMenu -boolean true

  # Enable tap-to-click
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  # Disable user interface sound effects
  defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0
  # Store screenshots in a dedicated place - not on desktop
  defaults write com.apple.screencapture location "${HOME}/Dropbox/img/screenshots"

  #
  # Text Edit
  #

  # Create an Untitled Document at Launch instead of showing the open dialog
  defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false
  # Use Plain Text Mode as Default
  defaults write com.apple.TextEdit RichText -int 0 

  #
  # Power Management
  #

  # Require password as soon as screensaver or sleep mode starts
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0
  
  #
  # Power Saving: Turn off
  #

  # # Disable screensaver
  # defaults -currentHost write com.apple.screensaver idleTime -int 0
  # # Turn off hard disk sleep
  # sudo systemsetup -setsleep off
  # # Prevent displaz sleep when on battery and power
  # sudo pmset -a displaysleep 0

  #
  # Global
  #

  # Show filename extensions by default
  defaults write -g AppleShowAllExtensions -bool false
  # Disable auto-correct
  defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
  # Set a shorter Delay until key repeat
  defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
  # Set super fast key repeat rate
  defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
  # disable animations when opening and closing windows
  defaults write -g NSAutomaticWindowAnimationsEnabled -bool false 
  # disable just smart dashes
  defaults write -g NSAutomaticDashSubstitutionEnabled 0
  # disable just smart quotes
  defaults write -g NSAutomaticQuoteSubstitutionEnabled 0

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
  # Desktop: Show item info below icons
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
  # Show columns view by default
  defaults write com.apple.finder FXPreferredViewStyle clmv
  # Show Statusbar
  defaults write com.apple.finder ShowStatusBar -bool true
  # Show Pathbar
  defaults write com.apple.finder ShowPathbar -bool true
  # Emptry trash securely by default
  defaults write com.apple.finder EmptyTrashSecurely -bool true
  # Remove items from the Trash after 30 days
  defaults write com.apple.finder FXRemoveOldTrashItems -bool true
  
  #
  # Dock
  #

  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true
  # Remove dock auto-hide delay
  defaults write com.apple.dock autohide-delay -float 0
  # Move the dock to the left
  defaults write com.apple.Dock orientation -string bottom
  # show app switcher on all displays - useful when you have a lot displays
  defaults write com.apple.Dock appswitcher-all-displays -bool true
  # Disable automatically rearrange Spaces based on recent use
  defaults write com.apple.dock mru-spaces -bool false

  killall Dock

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
  defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES 

  #
  # Restart all affected apps
  #

  for app in Safari Finder Dock Mail SystemUIServer; do 
    killall -HUP "$app" >/dev/null 2>&1; 
  done
}

#
# Installs all useful software, ruby gems, Homebrew packages and casks
#
installSoftware() {

  command -v brew >/dev/null 2>&1 || { 
    printf "\n#################################################################\n"
    printf "Installing Homebrew\n"
    printf "#################################################################\n\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  }


  printf "\n\n#################################################################\n"
  printf "Installing Xcode Command Line Tools\n"
  printf "#################################################################\n\n"

  log "Install Command Line Tools"
  xcode-select --install

  log "Agree to the Xcode license…"
  sudo xcodebuild -license accept
  
  # Link Xcode configuration
  DROPBOX_FOLDER="${HOME}/Library/CloudStorage/Dropbox"
  ln -sf ${DROPBOX_FOLDER}/job/xcode/KeyBindings ${HOME}/Library/Developer/Xcode/UserData/
  ln -sf ${DROPBOX_FOLDER}/job/xcode/FontAndColorThemes ${HOME}/Library/Developer/Xcode/UserData/
  ln -sf ${DROPBOX_FOLDER}/job/xcode/CodeSnippets ${HOME}/Library/Developer/Xcode/UserData/
  ln -sf ${DROPBOX_FOLDER}/job/xcode/Templates ${HOME}/Library/Developer/Xcode/
  # Link timewarrior & taskwarrior data bases
  ln -sf ${DROPBOX_FOLDER}/configs/.timewarrior ${HOME}/
  ln -sf ${DROPBOX_FOLDER}/configs/.task ${HOME}/

  printf "\n\n#################################################################\n"
  printf "Installing Software via Homebrew\n"
  printf "#################################################################\n\n"

  # Install/Upgrade software via Brewfile
  log "Update-reset Homebrew…"
  brew update-reset
  log "Update Homebrew…"
  brew update 
  log "Install all dependencies declared in global  ~/.Brewfile (eventually upgrade them)…"
  brew bundle -v --global
  log "Upgrade all dependencies (even those not declared in global ~/.Brewfile)…"
  brew upgrade
  log "Upgrade all casks declared in global ~/.Brewfile…"
  # Upgrades casks defined in Brewfile
  # brew upgrade --cask "$(sed -n -e '/^cask "/p' "${HOME}/.Brewfile" | cut -d \" -f2)"
  # Upgrades casks currently installed
  brew list --cask | xargs brew upgrade
  log "Cleanup…"
  brew cleanup
  log "Display homebrew system health…"
  brew doctor

  log "Disable read access to ZSH directories for other users…"
  chmod 700 /usr/local/share/zsh
  chmod 700 /usr/local/share/zsh/site-functions

  printf "\n\n#################################################################\n"
  printf "Installing Powerline Fonts For iTerm\n"
  printf "#################################################################\n\n"

  tmp="$(mktemp -d)/fonts"
  git clone https://github.com/powerline/fonts.git --depth=1 "$tmp"
  "$tmp"/install.sh
  rm -rf "$tmp"

  printf "\n\n#################################################################\n"
  printf "Install Ruby Gems\n"
  printf "#################################################################\n\n"

  gem install bundler --no-document
  gem install jwt --no-document

  if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    printf "\n\n#################################################################\n"
    printf "Setting up ZSH with Oh-My-Zsh\n"
    printf "#################################################################\n\n"
    
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

linkConfigurationFiles() {

  printf "\n#################################################################\n"
  printf "Link Configuration Files\n"
  printf "#################################################################\n\n"

  # Finds hidden dotfiles and uses safe syntax to execute loop
  find "$SCRIPT_DIR/bootstrap/dotfiles" -type f -iname ".*" -print0 | while read -r -d $'\0' file
  do
    log "Linking $file…"
    ln -sf "$file" "${HOME}/"
  done

  # [TODO]
  #log "Link .config directory to \$HOME"
  #ln -s "$SCRIPT_DIR/bootstrap/dotfiles/config/karabiner.json" "${HOME}/config/karabiner/karabiner.json"

  log "Source ~/.zshrc…"
  source "${HOME}"/.zshrc
}

cloneRepositories() {

  printf "\n#################################################################\n"
  printf "Clone Repos\n"
  printf "#################################################################\n\n"

  packages=(
    "git@github.com:Blackjacx/Columbus.git"
    "git@github.com:Blackjacx/SHDateFormatter.git"
    "git@github.com:Blackjacx/SHSearchBar.git"
    "git@github.com:Blackjacx/Source.git"
    "git@github.com:Blackjacx/Quickie.git"
    "git@github.com:Blackjacx/Engine.git"
    "git@github.com:Blackjacx/ASCKit.git"
    "git@github.com:Blackjacx/Assist.git"
  )
  base_dir="${HOME}/dev/projects/private"

  git clone "git@github.com:Blackjacx/Playgrounds.git" "$base_dir/playgrounds"

  for repo in "${packages[@]}"; do
    git clone "$repo" "$base_dir/packages/$(basename "$repo" | cut -d'.' -f1)"
  done
}

showUsage() {
# `cat << EOF` This means that cat should stop reading when EOF is detected
cat << EOF  
Usage: $0 [-hvacilr]

Sets up a development mac by setting system configurations, installing 
software and linking configuration (dotfiles) to your home and configuration folders.

-h     Display this help
-v     Run script in verbose mode. Will print out each step of execution
-a     Execute all, -clir
-c     Configure default values for the system
-l     Link configuration to your home folder
-i     Install software using brew and brew cask
-r     Repositories on the internet are cloned

EOF
# EOF is found above and hence cat command stops reading.
}

# Check for empty parameters
if [ -z "${1:-}" ]; then
	log "No parameters provided"
  showUsage
  exit 1
fi

while getopts "hvacilr" opt; do
  case ${opt} in
    h)
      showUsage; exit 0;;
    v)
      export verbose=1
      set -xv  # Set xtrace and verbose mode.
      ;;
    a)
      log "Execute all…"
      configureSystem
      linkConfigurationFiles
      installSoftware
      cloneRepositories
      ;;
    c)
      log "Configure System…"
      configureSystem
      ;;
    l)
      log "Link Configuration Files…"
      linkConfigurationFiles
      ;;
    i)
	    log "Install Software…"
      installSoftware
      ;;
    r)
      log "Clone Repositories…"
      cloneRepositories
      ;;
    \?)
      showUsage; exit 1;;
    *)
      showUsage; exit 1;;
  esac
done
