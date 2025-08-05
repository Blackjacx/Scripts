#!/bin/bash

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

pbpaste | fmt -w 72 | pbcopy
