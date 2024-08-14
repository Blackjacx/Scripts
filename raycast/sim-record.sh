#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Record Simulator
# @raycast.mode compact
# @raycast.packageName Developer Utilities

# Optional parameters:
# @raycast.author Maxim Krouk
# @raycast.authorURL https://github.com/maximkrouk
# @raycast.description Records simulator to Desktop folder
# @raycast.needsConfirmation false
# @raycast.icon 📱
# @raycast.currentDirectoryPath ~/Desktop

filePath="~/Desktop/Sim-Rec-$(date +%F_%H-%M-%S).mp4"
xcrun simctl io booted recordVideo $filePath
open -R $filePath