#!/usr/bin/osascript


# Eject all devices currently plugged into your mac
#
# See full documentation here: https://github.com/raycast/script-commands
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Eject Devices
# @raycast.mode compact
#
# Optional parameters:
# @raycast.icon 💿
# @raycast.currentDirectoryPath ~
# @raycast.packageName Raycast Scripts
#
# Documentation:
# @raycast.author Stefan H.
# @raycast.authorURL https://github.com/blackjacx

on run argv
  try
    tell application "Finder"
      eject the disks
      display notification "Successfully ejected disks." with title "Disk Eject"
    end tell
  on error
    display notification "Unable to eject all disks." with title "Disk Eject"
  end try
end run