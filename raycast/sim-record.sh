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

filePath="~/Desktop/Sim-Rec-$(date +%F_%H-%M-%S)"
xcrun simctl io booted recordVideo "$filePath.mp4"
#ffmpeg -i "$filePath.mp4" -vf "scale=trunc(iw/4)*2:trunc(ih/4)*2,fps=60" -c:v libx265 -vtag hvc1 -crf 28 "$filePath_small_crf28_fps60.mp4"