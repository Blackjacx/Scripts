#!/usr/bin/env zsh
#
# Script to setup a MacBook from scratch!
# These commands are collected throughout the internet over time.
# It is not guaranteed that every command will work!
#
# DISCLAIMER: Don't execute it if you do not know what you are doing!!!
#
# Check https://youtu.be/r_MpUP6aKiQ?si=dBAQnWCIeKkJmBHD&t=718 for steps to setup a new mac
#
set -uo pipefail
#set -x

SCRIPT_DIR="${HOME}/dev/scripts"
DROPBOX_FOLDER="${HOME}/Library/CloudStorage/Dropbox"

# Imprort global functionality
[ -f "$SCRIPT_DIR/imports.sh" ] && source "$SCRIPT_DIR/imports.sh"

# TODOS
# https://nerdlogger.com/2012/07/30/get-control-of-mountain-lion-with-a-huge-list-of-command-line-tweaks/
# - new finder windows open home folder
#

configureSystem() {

	#
	# Extendes Settings - Include here too
	#
	# https://github.com/webpro/awesome-dotfiles
	# https://github.com/mathiasbynens/dotfiles/blob/master/.macos
	# https://gist.github.com/alanzeino/42b6d983c7aa2f29d64ea2749621f7cf
	# https://apple.stackexchange.com/questions/408716/setting-safari-preferences-from-script-on-big-sur
	#

	if [[ $(uname) == "Darwin" ]]; then

		printf "\n#################################################################\n"
		printf "Configure System (MacOS)\n"
		printf "#################################################################\n\n"

		#
		# System
		#

		# Reduce Motion - uses cross fade instead
		defaults write com.apple.universalaccess reduceMotion -int 1

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
		defaults write com.apple.screencapture location "${DROPBOX_FOLDER}/images/screenshots"
		# Always expand Save Panel by default:
		defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

		#
		# Safari
		#

		# Don't open files in Safari after downloading
		defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
		# Hide favorites bar in Safari by default
		defaults write com.apple.Safari ShowFavoritesBar -bool false
		# Show status bar in Safari
		defaults write com.apple.Safari ShowOverlayStatusBar -bool true
		# Show the full URL in the address bar (note: this still hides the scheme)
		defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
		# Safari opens with: last session
		defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool true
		# Do not open private window on startup
		defaults write com.apple.Safari OpenPrivateWindowWhenNotRestoringSessionAtLaunch -bool false
		# Enable the Develop menu and the Web Inspector in Safari
		defaults write com.apple.Safari IncludeDevelopMenu -bool true
		# Enable Safari’s debug menu
		defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
		# Update extensions automatically
		defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
		# Make Safari’s search banners default to Contains instead of Starts With
		defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
		# Website use of location services
		# 0 = Deny without prompting
		# 1 = Prompt for each website once each day
		# 2 = Prompt for each website one time only
		defaults write com.apple.Safari SafariGeolocationPermissionPolicy -int 2

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
		# Disabling press-and-hold for special keys in favor of key repeat
		defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
		# Set a shorter Delay until key repeat
		defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
		# Set super fast key repeat rate
		defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
		# disable animations when opening and closing windows
		defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
		# disable just smart dashes
		defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
		# disable just smart quotes
		defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

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
		# Disable the warning when changing a file extension
		defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
		# Show Statusbar
		defaults write com.apple.finder ShowStatusBar -bool true
		# Show Pathbar
		defaults write com.apple.finder ShowPathbar -bool true
		# Emptry trash securely by default
		defaults write com.apple.finder EmptyTrashSecurely -bool true
		# Remove items from the Trash after 30 days
		defaults write com.apple.finder FXRemoveOldTrashItems -bool true
		# Enable Text Selection in QuickLook previews
		defaults write com.apple.finder QLEnableTextSelection -bool true
		# Avoid creation of .DS_Store files on network volumes?
		defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

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
		# Disable Dock magnification
		defaults write com.apple.dock magnification -bool false
		# Wipe all (default) app icons from the Dock?
		defaults write com.apple.dock persistent-apps -array

		#
		# Terminal
		#

		# iTerm appears quickly
		defaults write com.googlecode.iterm2 HotkeyTermAnimationDuration -float 0.000001

		#
		# Xcode
		#

		# Shows touches in simulator - nice for recording videos
		defaults write http://com.apple.iphonesimulator ShowSingleTouches 1
		# Xcode Show Build Times in Toolba
		defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true
		# Show Xcode Line Numbers
		defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true
		# Xcode Show Code Folding Ribbons
		defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar -bool true

		#
		# Restart all affected apps
		#
		for app in Safari Finder Dock Mail SystemUIServer iterm2; do
			killall -HUP "$app" >/dev/null 2>&1
		done

	elif [[ $(uname) == "Linux" ]]; then

		printf "\n#################################################################\n"
		printf "Configure System (Linux)\n"
		printf "#################################################################\n\n"

	fi
}

configureSoftware() {

	printf "\n\n#################################################################\n"
	printf "Configure Sotware\n"
	printf "#################################################################\n\n"

	command -v bat &>/dev/null && {
		if ! cat $(bat --config-file) | grep -q "\-\-theme\="; then
			log "Install 'Catppuccin' theme for Bat"
			return

			local tmp="$(mktemp -d)"
			local config_dir="$(bat --config-dir)"
			git clone -v git@github.com:catppuccin/bat.git $tmp
			mkdir -p "$config_dir/themes"
			cp -f "${tmp}"/*.tmTheme "${config_dir}/themes/" &&
				bat cache --build &&
				log 'Preview themes using $ bat --list-themes | fzf --preview="bat --theme={} --color=always <path to file>"'
		fi
	}

	#-----------------------------------------------------------------------------
	# ZSH Plugins Platform Independent
	# e.g. no homebrew on Raspberry Pi
	#-----------------------------------------------------------------------------

	github_plugins=(
		"aloxaf/fzf-tab"
		"zsh-users/zsh-autosuggestions"
	)

	for plugin in "${github_plugins[@]}"; do
		plugin_name=$(echo $plugin | cut -d"/" -f2)
		plugin_dir="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/$plugin_name"

		if [[ ! -d $plugin_dir ]]; then
			log "Installing ZSH plugin '$plugin'"
			git clone "https://github.com/$plugin" "$plugin_dir"
		fi
	done
}

#
# Installs all useful software, ruby gems, Homebrew packages and casks
#
installSoftware() {

	if [ ! -d "${HOME}/.oh-my-zsh" ]; then
		printf "\n\n#################################################################\n"
		printf "Set up ZSH with Oh-My-Zsh\n"
		printf "#################################################################\n\n"
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi

	command -v brew >/dev/null 2>&1 || {
		printf "\n#################################################################\n"
		printf "Install Homebrew\n"
		printf "#################################################################\n\n"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	}

	command -v mise >/dev/null 2>&1 || {
		printf "\n#################################################################\n"
		printf "Install Mise\n"
		printf "#################################################################\n\n"
		curl https://mise.run | sh
	}

	printf "\n\n#################################################################\n"
	printf "Install Xcode Command Line Tools\n"
	printf "#################################################################\n\n"

	log "Install Command Line Tools"
	xcode-select --install

	log "Agree to the Xcode license…"
	sudo xcodebuild -license accept

	# Link Xcode configuration
	ln -sf ${DROPBOX_FOLDER}/job/xcode/KeyBindings ${HOME}/Library/Developer/Xcode/UserData/
	ln -sf ${DROPBOX_FOLDER}/job/xcode/FontAndColorThemes ${HOME}/Library/Developer/Xcode/UserData/
	ln -sf ${DROPBOX_FOLDER}/job/xcode/CodeSnippets ${HOME}/Library/Developer/Xcode/UserData/
	ln -sf ${DROPBOX_FOLDER}/job/xcode/Templates ${HOME}/Library/Developer/Xcode/
	# Link timewarrior & taskwarrior data bases
	ln -sf ${DROPBOX_FOLDER}/configs/.timewarrior ${HOME}/
	ln -sf ${DROPBOX_FOLDER}/configs/.task ${HOME}/

	printf "\n\n#################################################################\n"
	printf "Install Homebrew Dependencies\n"
	printf "#################################################################\n\n"

	log "Update-reset Homebrew…"
	brew update-reset

	log "Update Homebrew…"
	brew update

	log "Install all dependencies declared in global  ~/.Brewfile (eventually upgrade them)…"
	brew bundle -v --global --force --cleanup --no-lock

	log "Upgrade all dependencies (even those not declared in global ~/.Brewfile)…"
	brew upgrade

	# Upgrades casks defined in Brewfile
	# brew upgrade --cask "$(sed -n -e '/^cask "/p' "${HOME}/.Brewfile" | cut -d \" -f2)"
	# Upgrades casks currently installed
	log "Upgrade all casks declared in global ~/.Brewfile…"
	brew list --cask | xargs brew upgrade --cask

	log "Cleanup…"
	brew cleanup

	log "Display homebrew system health…"
	brew doctor

	printf "\n\n#################################################################\n"
	printf "Install Mise Dependencies\n"
	printf "#################################################################\n\n"

	log "Update Mise itself"
	mise self-update

	log "Install all dependencies declared in global ~/.config/mise/config.toml"
	mise install

	log "List all installed tools"
	mise list

	log "Display mise system health"
	mise doctor

	printf "\n\n#################################################################\n"
	printf "Install Powerline Fonts For iTerm\n"
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
}

linkConfigurationFiles() {

	printf "\n#################################################################\n"
	printf "Link Configuration Files\n"
	printf "#################################################################\n\n"

	# Finds hidden dotfiles and uses safe syntax to execute loop
	find "$SCRIPT_DIR/bootstrap/dotfiles" -type f -iname ".*" -print0 | while read -r -d $'\0' file; do
		link_dir="${HOME}/"
		log "Link dotfile $file --> $link_dir$(basename $file)"
		ln -sf "$file" "$link_dir/"
	done

	# Finds configuration directories for various tools that should be linked into ~/.config/
	find "$SCRIPT_DIR/bootstrap/config_dirs" -type d -depth 1 -print0 | while read -r -d $'\0' tool_config_dir; do
		link_dir="${HOME}/.config/"
		log "Link dir $tool_config_dir --> $link_dir$tool_config_dir:t" # ':t' ~ Remove all leading pathname components, leaving the tail.
		ln -sf "$tool_config_dir" "$link_dir/"
	done

	find "$SCRIPT_DIR/bootstrap/zsh_config_files" -type f -iname "*" -print0 | while read -r -d $'\0' file; do
		link_dir="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/"
		log "Link zsh-config file $file --> $link_dir$(basename $file)"
		ln -sf "$file" "$link_dir/"
	done

	# [TODO]
	#log "Link .config directory to \$HOME"
	#ln -s "$SCRIPT_DIR/bootstrap/dotfiles/config/karabiner.json" "${HOME}/config/karabiner/karabiner.json"
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
	cat <<EOF
Usage: $0 [-hvacilr]

Sets up a development mac by setting system configurations, installing 
software and linking configuration (dotfiles) to your home and configuration folders.

-h     Display this help
-v     Run script in verbose mode. Will print out each step of execution
-a     Execute all, -clir
-c     Configure default values for system and software installed previously
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
		showUsage
		exit 0
		;;
	v)
		export verbose=1
		set -xv # Set xtrace and verbose mode.
		;;
	a)
		log "Execute all…"
		configureSystem
		linkConfigurationFiles
		installSoftware
		configureSoftware
		cloneRepositories
		;;
	c)
		log "Configure System and Software…"
		configureSystem
		configureSoftware
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
		showUsage
		exit 1
		;;
	*)
		showUsage
		exit 1
		;;
	esac
done
