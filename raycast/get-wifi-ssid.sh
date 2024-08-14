#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Wi-Fi Name
# @raycast.mode compact
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🛜
# @raycast.author Stefan Herold
# @raycast.authorURL https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fgithub.com%2Fblackjacx&screen_name=Blackjacxxx
# @raycast.description Prints the SSID of the current WiFi.

# SLACK_API_TOKEN="$(cat ~/.envrc | ag SLACK_API_TOKEN | cut -d'=' -f2)"
SSID=$(networksetup -getairportnetwork en0 | awk -F': ' '{print $NF}')

if [[ "$SSID" == "PrettyFlyForAWiFi" ]]; then
    # /usr/bin/curl https://slack.com/api/users.profile.set --data 'token='$SLACK_API_TOKEN'&profile=%7B%22status_text%22%3A%20%22Working%20remotely%22%2C%22status_emoji%22%3A%20%22%3Ahouse_with_garden%3A%22%7D' > /dev/null
    echo "Set Home WiFi"
elif [[ "$SSID" == "widrive" || "$SSID" == "widrive guest" ]]; then
    # /usr/bin/curl https://slack.com/api/users.profile.set --data 'token='$SLACK_API_TOKEN'&profile=%7B%22status_text%22%3A%20%22In%20the%20office%22%2C%22status_emoji%22%3A%20%22%3Aoffice%3A%22%7D' > /dev/null
    echo "Set Work WiFi"
else
    echo "$SSID"
fi