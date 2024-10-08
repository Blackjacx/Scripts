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

on run argv
	set title to contents of selection
	set link to (get the clipboard as text)
	set markdownLink to ("[" & title & "](" & link & ")")
	set the clipboard to (markdownLink)
	
	tell application "System Events"
		tell application Slack
			activate
			keystroke "v" using command down
		end tell
	end tell	
end run

