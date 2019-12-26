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
xcrun simctl erase all

echo "Delete unneeded simulator devices..."
xcrun simctl delete unavailable

echo "Empty Trash..."
rm -rf ~/.Trash/*



##
## The following is highly experimental!!!
## It is used to automatically delete iOS device support files and keeps 
## the two most recent versions. Those are one of the biggest space
## killers in iOS world.
##

# set -euo pipefail
# IFS=$'\n\t'

# # # files=$(ls -v Versions |awk '{print $1}' |uniq |cut -d'.' -f1 |uniq |tail -c -2)
# # # folders=$(ls -v ${HOME}/Library/Developer/Xcode/iOS\ DeviceSupport |awk '{print $1}')
# # folders=$(ls -vd ${HOME}/Desktop/Versions/*/ | sed 's/.$//')
# # # folders=$(cat ~/list.txt)
# # MAX_VERSION=$(echo $folders | awk -F/ '{print $NF}')
# # # printf '%s\n' ${folders[@]}
# # # printf '%s\n' ${#folders[@]}
# # printf '%s\n' $MAX_VERSION

# folders=$(ls -vd ${HOME}/Library/Developer/Xcode/iOS\ DeviceSupport/*/ | sed 's/.$//')
# keep=$(echo "${folders[*]}" | sort -t. -nr | awk -F. 'a[$1]++<1' | cut -d' ' -f1 | head -2 | paste -s -d '|' -)
# echo "${folders[*]}" | grep -vE $keep