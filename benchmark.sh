#!/bin/bash
set -euo pipefail

# Mac Perofrmance Benchmark
# 
# On my fastest Mac it takes 0:26:42 min

osascript -e 'tell app "Xcode" to quit'
rm -rf ${HOME}/Library/Developer/Xcode/DerivedData
tmp_dir=$(mktemp -d)
cd $tmp_dir
git clone git@github.com:Blackjacx/Columbus.git $tmp_dir/Columbus/
time xcodebuild -showBuildTimingSummary -destination "platform=iOS Simulator,name=iPhone 7" -workspace "$tmp_dir/Columbus/Columbus.xcworkspace" -scheme "Columbus-iOS" build > /dev/null