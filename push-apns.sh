#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function usage() {
  cat <<EOM
  $1
  Usage:
    $0 <message> <auth_token> <device_token>
EOM
  exit 0
}

message=${1:-}
auth_token=${2:-}
device_token=${3:-}

[[ -z "$message" ]] && usage "No message given!"
[[ -z "$auth_token" ]] && usage "No auth token given!"
[[ -z "$device_token" ]] && usage "No device token given!"

curl -v \
     -d '{"aps":{"alert":"'"$message"'"}}' \
     -H "apns-topic: com.ioki.passenger" \
     -H "Authorization: Bearer $auth_token" \
     --http2 \
     "https://api.push.apple.com/3/device/$device_token"