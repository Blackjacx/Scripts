#!/usr/bin/osascript


# Toggles the microphone using Apple Script
#
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
#
# Documentation:
# @raycast.author Stefan H.
# @raycast.authorURL https://github.com/blackjacx

on run argv
  if input volume of (get volume settings) > 0 then
    tell application "System Events" to set volume input volume 0
    display notification "Microphone switched off." with title "Toggle Microphone"
  else
    tell application "System Events" to set volume input volume 100
    display notification "Microphone switched on." with title "Toggle Microphone"
  end if
end run