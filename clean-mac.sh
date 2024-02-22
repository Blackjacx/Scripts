#!/usr/bin/env bash
# set -euo pipefail

# Imprort global functionality
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/imports.sh"

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

log "Clean up unused gem versions..."
gem cleanup

log "Erase DerivedData folder..."
rm -rf "${HOME}/Library/Developer/Xcode/DerivedData/*"

log "Erase Caches Folder..."
sudo rm -rf "${HOME}/Library/Caches"

log "Remove All Unavailable Simulators"
xcrun simctl delete unavailable

log "Remove Homebrew cache"
brew cleanup --prune=all

log "Reset all simulators..."
killall "Simulator"
killall "iOS Simulator"
xcrun simctl shutdown all
xcrun simctl erase all

log "Empty Trash"
rm -rf "${HOME}/.Trash/*"

log "Erase Spotlight Index and Rebuild"
sudo mdutil -E /

log "Reload Core Audio"
sudo kill -9 `pgrep 'coreaudio[a-z]' | awk '{print $1}'`

log "Create huge file and delete it again to re-claim hidden space from the system."
fname="DELETE_THIS_DUMMY_FILE_TO_FREE_UP_SPACE.txt"
if cd /tmp/; then
    mkfile 50G $fname
    rm -rf $fname
fi

##
## The following is highly experimental!!!
## It is used to automatically delete iOS device support files and keeps
## the two most recent versions. Those are one of the biggest space
## killers in iOS world.
##

# set -euo pipefail

# 1: find all versions (folders) currently installed
# 2: reverse sort folders - use file name major version as key
# folders=$(find ${HOME}/Library/Developer/Xcode/iOS\ DeviceSupport -type d -d 1 \
    #   | sort -t. -nr)

# 1: filter latest 2 major versions
# 2: remove path components after the version number
# 3: trim trailing whitespaces
# keep=$(echo "${folders[*]}" \
    #   | awk -F. 'a[$1]++<1' \
    #   | cut -d'(' -f1 \
    #   | sed 's/ *$//g' \
    #   | head -2 \
    #   | paste -s -d '|' -)
# echo "${folders[*]}" | grep -vE $keep
# echo "-----"
# echo "${folders[*]}"
# echo "-----"
# echo "${keep}"


