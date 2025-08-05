#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Wrap Clipboard 72C
# @raycast.mode silent
# @raycast.packageName Tools

# Optional parameters:
# @raycast.icon 🎁
# @raycast.author Stefan Herold
# @raycast.authorURL https://stherold.com
# @raycast.description Wraps your current clipboard text to 72 characters and pastes it in the current application.

on run
    try
        -- Get the text from the clipboard
        set longText to the clipboard
        
        -- Wrap text 
        set wrappedText to do shell script "echo " & quoted form of longText & " | fmt -w 72"       

        -- Paste said text in curretn window
        -- SOMETHING REALLY BAD HAPPENED LAST TIME I EXECUTED THAT!!!
        -- tell application "System Events"
        --     keystroke wrappedText
        -- end tell

    on error errMsg
        display dialog "Error: " & errMsg buttons {"OK"} default button "OK"
    end try
end run

