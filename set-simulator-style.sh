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

appearance=$1

case $appearance in
     light) ;;
     dark)  ;;
     *)     usage "Style parameter missing or wrong!"; exit 1 ;;
esac

runtimes=( $( xcrun simctl list --json | jq ".runtimes | .[] | select(.identifier | contains(\"watchOS\") | not) | .identifier" ) )
runtime_ids=$( printf ".%s," "${runtimes[@]}" | cut -d "," -f 1-${#runtimes[@]} )
device_ids=( $(xcrun simctl list --json | jq ".devices | $runtime_ids | .[] | .udid" | cut -d\" -f2) )

# printf "%s\n" "${device_ids[@]}"

for device in "${device_ids[@]}"; do
  printf '\n%s\n' "Setting style $appearance for device $device"
  xcrun simctl boot $device
  xcrun simctl ui $device appearance $appearance
done