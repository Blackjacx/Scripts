#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# TODOs
#
# - generate jwt token using NODE.js : https://medium.com/@ThatJenPerson/authenticating-firebase-cloud-messaging-http-v1-api-requests-e9af3e0827b8
# - update the payload: https://firebase.google.com/docs/cloud-messaging/migrate-v1#example_simple_notification_message
# - fint out if sending to specific device is supported
#

function usage() {
  cat <<EOM
  $1
  Usage:
    $0 <message> <project> <access_token> <device_token>
EOM
  exit 0
}
message=${1:-}
project=${2:-}
access_token=${3:-}
device_token=${4:-}

[[ -z "$message" ]] && usage "No message given!"
[[ -z "$project" ]] && usage "No project id given!"
[[ -z "$access_token" ]] && usage "No access token given!"
[[ -z "$device_token" ]] && usage "No device token given!"

curl --header "Content-Type: application/json" \
     --header "Authorization: Bearer $access_token" \
     "https://fcm.googleapis.com/v1/projects/$project/messages:send" \
     -d '{"notification": {"body": "'"$message"'", "sound": "default"},
        "priority": "high",
        "to": "'"$device_token"'"}'