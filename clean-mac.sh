#!/bin/bash

echo "Erase DerivedData folder..."
rm -rf ${HOME}/Library/Developer/Xcode/DerivedData/*

# echo "Erase Caches Folder..."
# rm -rf ${HOME}/Library/Caches

echo "Reset all simulators..."
osascript -e 'tell application "Simulator" to quit'
osascript -e 'tell application "iOS Simulator" to quit'
xcrun simctl erase all

echo "Delete unneeded simulator devices..."
xcrun simctl delete unavailable

echo "Empty Trash..."
rm -rf ~/.Trash/*