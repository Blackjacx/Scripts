#!/usr/bin/osascript

# Toggles the microphone using Apple Script
#
# See full documentation here: https://github.com/raycast/script-commands
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Microphone
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 🎤
# @raycast.currentDirectoryPath ~
# @raycast.packageName Raycast Scripts
#
# Documentation:
# @raycast.author Stefan Herold
# @raycast.authorURL https://github.com/blackjacx



-- on run argv
--   if input volume of (get volume settings) > 0 then
--     tell application "System Events" to set volume input volume 0
--     display notification "Microphone switched off." with title "Toggle Microphone"
--   else
--     tell application "System Events" to set volume input volume 100
--     display notification "Microphone switched on." with title "Toggle Microphone"
--   end if
-- end run


## 👆 toggle globally - not visible for people in call

## 👇 toggle only teams but then it's visible in the ui for everybody

tell application "Microsoft Teams"
  activate
  tell application "System Events"
    keystroke "m" using {shift down, command down}
  end tell
end tell