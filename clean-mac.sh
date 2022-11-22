#!/bin/bash

SCRIPT_DIR="${HOME}/dev/scripts"

# Imprort global functionality
[ -f "$SCRIPT_DIR/imports.sh" ] && source "$SCRIPT_DIR/imports.sh"

pwd="$(pwd)"

cleanup() {
  code=$?
  # Go back to original directory
  cd $pwd
  # Print statuscode if non successful
  if [[ ! $code -eq 0 ]]; then
      log_error "Exit with status code $code"
      exit $code
  fi
}
trap "cleanup" INT TERM HUP EXIT

log "Clean up unused gem versions..."
gem cleanup

log "Erase DerivedData folder..."
rm -rf ${HOME}/Library/Developer/Xcode/DerivedData/*

log "Erase Caches Folder..."
rm -rf ${HOME}/Library/Caches

log "Remove All Unavailable Simulators"
xcrun simctl delete unavailable

log "Reset all simulators..."
osascript -e 'tell application "Simulator" to quit'
osascript -e 'tell application "iOS Simulator" to quit'
xcrun simctl shutdown all
xcrun simctl erase all

log "Empty Trash"
rm -rf "~/.Trash/*"

log "Erase Spotlight Index and Rebuild"
sudo mdutil -E /

log "Reload Core Audio"
sudo kill -9 `ps ax|grep 'coreaudio[a-z]' | awk '{print $1}'`

log "Create huge file and delete it again to re-claim hidden space from the system."
fname="DELETE_THIS_DUMMY_FILE_TO_FREE_UP_SPACE.txt"
cd /tmp/
mkfile 50G $fname
rm -rf $fname

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