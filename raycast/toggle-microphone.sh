#!/bin/bash

# Raycast Script Command Template
#
# Duplicate this file and remove ".template." from the filename to get started.
# See full documentation here: https://github.com/raycast/script-commands
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Mic
# @raycast.mode compact
#
# Optional parameters:
# @raycast.icon 🎤
# @raycast.currentDirectoryPath ~
# @raycast.packageName Raycast Scripts

osascript <<EOD
  if input volume of (get volume settings) > 0 then
    tell application "System Events" to set volume input volume 0
  else
    tell application "System Events" to set volume input volume 100
  end if
EOD