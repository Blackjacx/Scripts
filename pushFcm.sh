#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function usage() {
  cat <<EOM
  $1
  Usage:
    $0 <message> <server_key> <device_token>
EOM
  exit 0
}

message=${1:-}
server_key=${2:-}
device_token=${3:-}

[[ -z "$message" ]] && usage "No message given!"
[[ -z "$server_key" ]] && usage "No server key given!"
[[ -z "$device_token" ]] && usage "No device token given!"

curl --header "Content-Type: application/json" \
     --header "Authorization: key=$server_key" \
     https://fcm.googleapis.com/fcm/send \
     -d '{"notification": {"body": "'"$message"'", "sound": "default"},
        "priority": "high",
        "to": "'"$device_token"'"}'