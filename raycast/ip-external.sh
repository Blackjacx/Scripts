#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Show External IP
# @raycast.mode inline

# Conditional parameters:
# @raycast.refreshTime 1h

# Optional parameters:
# @raycast.icon 🧑‍💻
# @raycast.currentDirectoryPath ~
# @raycast.packageName Raycast Scripts
#
# Documentation:
# @raycast.author Stefan Herold
# @raycast.authorURL https://github.com/blackjacx

echo "$(curl -s ifconfig.me)"