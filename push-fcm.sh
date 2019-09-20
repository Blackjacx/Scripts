#!/usr/bin/env bash

# Script for testing Firebase push service.
#
# Links:
#
#   https://firebase.google.com/docs/database/rest/auth
#   https://firebase.google.com/docs/cloud-messaging/migrate-v1
#   https://firebase.google.com/docs/cloud-messaging/send-message

set -euo pipefail
IFS=$'\n\t'

function usage() {
  cat <<EOM
  $1
  Usage:
    $0 <message> <fcm_project_name> <access_token> <device_token>
EOM
  exit 0
}

message=${1:-}
fcm_project_name=${2:-}
access_token=${3:-}
device_token=${4:-}

[[ -z "$message" ]] && usage "No message given!"
[[ -z "$fcm_project_name" ]] && usage "No FCM project name given!"
[[ -z "$access_token" ]] && usage "No access token given!"
[[ -z "$device_token" ]] && usage "No device token given!"

curl --verbose \
     -H "Authorization: Bearer $access_token" \
     -H "Content-Type: application/json" \
     -d '{
          "message": {
            "notification": {
              "title":"FCM Message",
              "body":"'"$message"'"
            },
            "token":"'"$device_token"'"
          }
        }' \
     "https://fcm.googleapis.com/v1/projects/$fcm_project_name/messages:send"