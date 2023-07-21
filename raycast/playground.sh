#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Playground
# @raycast.mode fullOutput

# Conditional parameters:
# @raycast.refreshTime 1h

# Optional parameters:
# @raycast.icon 🛝
# @raycast.currentDirectoryPath ~
# @raycast.packageName Raycast Scripts
#
# Documentation:
# @raycast.author Stefan Herold
# @raycast.authorURL https://github.com/blackjacx

SCRIPT_DIR="${HOME}/dev/projects/db/beiwagen-2"

echo "Run mint-based SwiftLint script without auto-correction..."
# When the below doesn't work see: See: https://github.com/yonaskolb/Mint/issues/179#issuecomment-732682750
/Users/stherold/.mint/bin/swiftlint "$SCRIPT_DIR" --config "$SCRIPT_DIR/.swiftlint.yml"