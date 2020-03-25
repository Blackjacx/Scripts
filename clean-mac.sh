#!/bin/bash

echo "Clean up unused gem versions..."
gem cleanup

echo "Erase DerivedData folder..."
rm -rf ${HOME}/Library/Developer/Xcode/DerivedData/*

echo "Erase Caches Folder..."
rm -rf ${HOME}/Library/Caches

echo "Reset all simulators..."
osascript -e 'tell application "Simulator" to quit'
osascript -e 'tell application "iOS Simulator" to quit'
xcrun simctl shutdown all
xcrun simctl erase all

echo "Delete unneeded simulator devices..."
xcrun simctl delete unavailable

echo "Empty Trash..."
rm -rf ~/.Trash/*

echo "Create huge file and delete it again to re-claim hidden space from the system."
fname="DELETE_THIS_DUMMY_FILE_TO_FREE_UP_SPACE.txt"
pwd=$(pwd)
cd /tmp/
mkfile 13G $fname
rm -rf $fname
cd $pwd


# ##
# ## The following is highly experimental!!!
# ## It is used to automatically delete iOS device support files and keeps 
# ## the two most recent versions. Those are one of the biggest space
# ## killers in iOS world.
# ##

# # set -euo pipefail

# # 1: find all versions (folders) currently installed
# # 2: reverse sort folders - use file name major version as key
# folders=$(find ${HOME}/Library/Developer/Xcode/iOS\ DeviceSupport -type d -d 1 \
#   | sort -t. -nr)

# # 1: filter latest 2 major versions
# # 2: remove path components after the version number
# # 3: trim trailing whitespaces
# keep=$(echo "${folders[*]}" \
#   | awk -F. 'a[$1]++<1' \
#   | cut -d'(' -f1 \
#   | sed 's/ *$//g' \
#   | head -2 \
#   | paste -s -d '|' -)
# # echo "${folders[*]}" | grep -vE $keep
# echo "${folders[*]}" 
# echo "-----"
# echo "${keep}"