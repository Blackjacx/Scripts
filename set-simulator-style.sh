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

for device_id in "${device_ids[@]}"; do
  printf '\n%s\n' "Setting style $style for device $device_id"
  xcrun simctl ui $device appearance $style
done