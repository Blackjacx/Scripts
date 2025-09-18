#!/usr/bin/env bash
# set -euo pipefail

# Imprort global functionality
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/imports.sh"

pwd="$(pwd)"

cleanup() {
    code=$?
    # Go back to original directory
    if cd "$pwd"; then
        log "Success!"
    else
        log_error "Exit with status code $code"
        exit $code
    fi
}
trap "cleanup" INT TERM HUP EXIT

log "Clean up unused gem versions"
gem cleanup

log "Erase Caches Folder..."
sudo rm -rf "${HOME}/Library/Caches"

log "Remove Homebrew cache"
brew cleanup --prune=all

log "Remove All Unavailable Xcode Simulators"
xcrun simctl delete unavailable

log "Reset all Xcode Simulators"
killall "Simulator"
killall "iOS Simulator"
xcrun simctl shutdown all
xcrun simctl erase all

log "Cleanup Xcode DerivedData folder"
rm -rf "${HOME}/Library/Developer/Xcode/DerivedData/*"

log "Cleanup Xcode device logs"
rm -rf ~/Library/Developer/Xcode/iOS\ Device\ Logs/

log "Cleanup Xcode archives"
rm -rf ~/Library/Developer/Xcode/Archives

log "Cleanup CocoaPods Cache"
rm -rf ~/Library/Caches/CocoaPods

log "Cleanup Carthage Cache"
# rm -rf ~/Library/Caches/org.carthage.CarthageKit

log "Empty Trash"
# The -P option overwrites the deleted files for extra security (but that takes long)
sudo rm -rf "${HOME}/.Trash/*"

log "Erase Spotlight Index and Rebuild"
sudo mdutil -E /

log "Reload Core Audio"
sudo kill -9 "$(pgrep 'coreaudio[a-z]' | awk '{print $1}')"

# The below does not seem to be necessary naymore.
# log "Create huge file and delete it again to re-claim hidden space from the system."
# file="$(mktemp -d)/DELETE_THIS_DUMMY_FILE_TO_FREE_UP_SPACE.txt"
# mkfile 200G "$file"
# rm -rf "$file"

# ====================================================================================================================
# The following is highly experimental!!!
#
# It is used to automatically delete iOS device support files and keeps
# the 3 most recent versions. Those are one of the biggest space
# killers on a Mac.
# ====================================================================================================================

delete_unused_device_support_files() {
    local device_support_folder=~/Library/Developer/Xcode/iOS\ DeviceSupport/
    log "The following device support files exist:"
    printf '%s\n\n' "$(ls -1 "$device_support_folder")"

    # Keeps device support files of latest 3 versions.
    # 1: find all versions (folders) currently installed
    # 2: extract the version number
    # 3: reverse sort folders - use file name major version as key
    # 4: keep the first 3
    local keep
    keep="$(ls -1 "$device_support_folder" | cut -d' ' -f2 | sort -unrt. | head -3)"
    log "Keep the following versions:"
    printf '%s\n\n' "${keep[*]}"

    local purge
    purge=$(find "$device_support_folder" -type d -d 1 | grep -vE "$keep")
    log "Purge the following folders:"
    printf '%s\n\n' "${purge[*]}"
}
delete_unused_device_support_files
