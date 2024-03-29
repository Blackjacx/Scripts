#!/usr/bin/env bash
#
# Update the preferred language of each suported 
# simulator. 
#
# This is helpful since each new Xcode 
# installation created the simulators in their 
# default languages which might not fit your 
# development needs.
#

# Debug
# set -x

usage() {
  echo "$1"
  echo "Usage: $0"
  echo "Quit..."
}

DEVICES=$(xcrun simctl list -j "devices")
UDIDS=($(echo "$DEVICES" | jq -r '.devices | map(.[])[].udid'))

for ID in "${UDIDS[@]}"; do
  xcrun simctl boot "$ID"
  xcrun simctl spawn "$ID" defaults write "Apple Global Domain" AppleLanguages -array en_BZ
  xcrun simctl spawn "$ID" defaults write "Apple Global Domain" AppleLocale -string en_BZ
done

xcrun simctl shutdown all