#!/usr/bin/env bash
#
# Update simulater preferred languages. It prevents the bug when en and 
# de-AT is set by default and Locale cannot get a region code for `en`.
#
# set -x

usage() {
  echo "$1"
  echo "Usage: $0 <device_id>"
  echo "Quit..."
}

local device_id=$1

if [ -z "${device_id:-}" ]; then
  usage "Device id parameter missing or wrong!"; exit 1
fi

local plist_path="${HOME}/Library/Developer/CoreSimulator/Devices/$device_id/data/Library/Preferences/.GlobalPreferences.plist"

killall "Simulator"
xcrun simctl shutdown $device_id

plutil -replace AppleLanguages -json '[ "en-US", "de-DE" ]' $plist_path
# open $plist_path