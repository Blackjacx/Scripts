#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Markdown Link From Selection and Clipboard Link
# @raycast.mode compact
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🔗
# @raycast.author Stefan Herold
# @raycast.authorURL https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fgithub.com%2Fblackjacx&screen_name=Blackjacxxx
# @raycast.description Script Command to switch between the system appearance, light and dark mode.

# tell application "System Events" to tell appearance preferences to set dark mode to not dark mode

-- on run argv
-- 	set title to contents of selection
-- 	set link to (get the clipboard as text)
-- 	set markdownLink to ("[" & title & "](" & link & ")")
-- 	set the clipboard to (markdownLink)
	
-- 	tell application "System Events"
-- 		tell application Slack
-- 			activate
-- 			keystroke "v" using command down
-- 		end tell
-- 	end tell	
-- end run

-- 🚨 The latest problem with the code below is that, 
-- 🚨 due to macOS security settings, it is not 
-- 🚨 possible to get the selected text 💥


-- Raycast Script: Transform selected text to a Markdown link
on run
    try
        -- Get the URL from the clipboard
        set theURL to the clipboard
        
        -- Check if clipboard has valid content
        if theURL is "" then
            display dialog "Clipboard is empty. Copy a URL first." buttons {"OK"} default button "OK"
            return
        end if

        -- Get the selected text from the frontmost app
        tell application "System Events"
            tell (first application process whose frontmost is true)
                set selectedText to (value of attribute "AXSelectedText" of UI element 1 of (first window whose value of attribute "AXMain" is true)) as text
            end tell
        end tell

        -- Check if selected text exists
        if selectedText is "" then
            display dialog "No text selected. Please select text and try again." buttons {"OK"} default button "OK"
            return
        end if

        -- Format as a Markdown link
        set markdownLink to "[" & selectedText & "](" & theURL & ")"

        -- Replace the selected text with the Markdown link
        tell application "System Events"
            keystroke markdownLink
        end tell

    on error errMsg
        display dialog "Error: " & errMsg buttons {"OK"} default button "OK"
    end try
end run

