#!/usr/bin/env bash
#
# Update styles of preferred devices to light or dark mode
#
# set -x

usage() {
  echo "$1"
  echo "Usage: $0 [light|dark]>"
  echo "Quit..."
}

# Import Global Functionality
. $(dirname "$0")/imports.sh --source-only
loadEnvironment
checkInstalledJq

case $1 in
     light) appearance=1 ;;
     dark)  appearance=2 ;;
     *)     usage "Style parameter missing or wrong!"; exit 1 ;;
esac

raw=$(xcrun simctl list --json)
# ios_runtime=$(echo $raw | jq ".runtimes[] | select(.identifier | test(\"iOS\")).identifier" | cut -d\" -f2)
device_ids=($(echo $raw | jq ".devices[][].udid" | cut -d\" -f2))

killall "Simulator"
xcrun simctl shutdown booted
xcrun simctl erase $(printf "%s " "${device_ids[@]}")

for device_id in "${device_ids[@]}"; do
  plist="${HOME}/Library/Developer/CoreSimulator/Devices/${device_id}/data/Library/Preferences/com.apple.uikitservices.userInterfaceStyleMode.plist"  
  printf '\n%s\n' "Set style $style for device $device_id ($plist)"

  [[ ! -f "$plist" ]] && /usr/libexec/PlistBuddy -c "save" $plist
  plutil -replace UserInterfaceStyleMode -integer $appearance $plist
done