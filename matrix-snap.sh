#!/usr/bin/env bash

# This script runs our screenshot tests with the goal to automatically 
# generate as many screenshot varaints as possible in as less time as 
# possible. 
#
# These variants are:
#
# - all supported device classes
# - all supported languages
# - dark | light mode
# - normal | high contrast mode
# - selected dynamic font sizes (smallest, normal, largest)
#
# To speed up this process we do the following:
# 
# - run only one unit test: our screenshot test
# - first builds the app using `build-for-testing` and then runs tests 
#   in parallel using `test-without-building` with all variants.
#
# To finish things up we create a nice static webpage from the results 
# which can cycle through the screenshots automatically so they can be 
# viewed on a big screen. This way bugs can be detected early.
#
# The generated screens will also be automatically put into nice device 
# mockups so the output will actually look like a real phone.
#
# I explicitly try to avoid fastlane since this is such an easy task 
# with the power xcodebuild offers today. Therefore the uge Fastlane 
# dependency is not really needed here.
#

# set -x

usage() {
  echo "$1"
  echo "Usage: matrix-snap.sh <workspace> <deploy_dir> \"\$(cat <scheme_file>)\" <fast | full>"
  echo "Quit..."
}

workspace="$1"
if [ -z "$workspace" ]; then usage "Workspace parameter missing!"; exit 1; fi
[[ ! -d $workspace ]] && { echo "Workspace folder $workspace not found!"; exit 1; }

deploy_dir="$2"
if [ -z "$deploy_dir" ]; then usage "Deploy directory not specified!"; exit 1; fi
[[ ! -d $deploy_dir ]] && { echo "Deploy directory $deploy_dir not found!"; exit 1; }

schemes="$3"
if [ -z "$schemes" ]; then usage "Schemes parameter missing!"; exit 1; fi

config="$4"
if [ -z "$config" ]; then usage "Config parameter missing. Use \"fast\" or \"full\"!"; exit 1; fi
if [ "$config" == "fast" ]; then 
  styles=("light")
  device_names=("iPhone 11 Pro")
else 
  styles=("light" "dark")
  device_names=("iPhone SE (2nd generation)" "iPhone 11 Pro" "iPhone 11 Pro Max")
fi

schemes=($schemes)
working_dir=$(mktemp -d)
platform="iOS 13.4"
device_ids=()
destinations=()
results=()

# Update appearance of preferred devices to light or dark
update_style() {
  for device in "${device_ids[@]}"; do
    printf '\n%s\n' "Setting style $style for device $device_id"
    xcrun simctl boot $device
    xcrun simctl ui $device appearance $style
  done
}

# Customize the status bar of each device
setup_statusbars() {
  for device_id in "${device_ids[@]}"; do
    # Statusbar can only be modified on booted devices
    xcrun simctl boot "${device_id}"
    xcrun simctl status_bar "${device_id}" override \
      --time '12:00' \
      --dataNetwork 'wifi' \
      --wifiMode 'active' \
      --wifiBars 3 \
      --cellularMode 'active' \
      --cellularBars 4 \
      --operatorName 'T-Mobile' \
      --batteryState 'charged' \
      --batteryLevel 100  
  done
}

take_screenshots() {

  results_path="$working_dir/${scheme}/${style}/result_bundle.xcresult"
  screens_path="$working_dir/${scheme}/${style}/screens"
  
  printf '\n%s\n' "Generate screenshots for $scheme..."
  
  # This command just needs the binaries and the path to the xctestrun 
  # file created before the actual testing. There everything can be 
  # configured to run the tests without needing the source code, i.e. 
  # the tests can be performed on different machines.
  cmd="xcrun xcodebuild test-without-building \
    -workspace \"$workspace\" \
    -scheme \"$scheme\" \
    -resultBundlePath \"$results_path\" \
    $destinations \
    -testPlan \"${scheme}-Screenshots\""
  echo "Running command: $cmd"
  eval "$cmd"

  printf '\n%s\n' "Extracting screenshots from xcresult bundle..."

  mkdir -p "$screens_path"
  # extract screenshots from result bundle
  mint run ChargePoint/xcparse xcparse screenshots --test-plan-config --model "$results_path" "$screens_path"
}

#
# Programm Start
#

killall "Simulator"

# Find runtime id of desired platform
runtime_id=$(xcrun simctl list --json | jq ".runtimes | .[] | select(.name == \"$platform\") | .identifier" | cut -d\" -f2)
echo "Found runtime id for platform $platform: $runtime_id"

# Find ids of preferred devices. If device not available - create it.
for name in "${device_names[@]}"; do
  echo "Following devices available for runtime_id \"$runtime_id\""
  xcrun simctl list --json | jq ".devices | .\"$runtime_id\""

  id=$(xcrun simctl list --json | jq ".devices | .\"$runtime_id\" | .[] | select(.name == \"$name\") | .udid" | cut -d\" -f2)
  if [ "$id" != "" ]; then
    device_ids+=("$id")
  else 
    device_ids+=("$(xcrun simctl create "$name" "$name" "$runtime_id")")
  fi 
done
destinations=$(printf -- "-destination \'platform=iOS Simulator,id=%s\' " "${device_ids[@]}")

# Build withouit testing for all schemes
for scheme in "${schemes[@]}"; do
  printf '\n%s\n' "Build $scheme to prepare tests..."
  cmd="xcrun xcodebuild build-for-testing \
    -workspace \"$workspace\" \
    -scheme \"$scheme\" \
    $destinations"
  echo "Running command: $cmd"
  eval "$cmd"
done

# Take screenshots for all schemes
for style in "${styles[@]}"; do    
  update_style
  setup_statusbars

  for scheme in "${schemes[@]}"; do
    take_screenshots
  done
done

# shrink png
# printf '\n%s\n' "Shrinking PNGs using PNGQuant..."
# find "$working_dir" -type f -name "*.png" -print0 | xargs -0 pngquant --ext .png --force

for scheme in "${schemes[@]}"; do
  # create archive - cd into folder to prevent storage of absolute path
  cd "$working_dir"
  zip -r0 "${deploy_dir}/Screens_${scheme}.zip" "./${scheme}" -x \*.xcresult\*
  cd -
done

# Status Reporting
printf '\n%s\n' "The test results can be found in: $working_dir"
