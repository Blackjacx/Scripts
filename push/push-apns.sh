#!/usr/bin/env bash

#
# Script for testing APNS push service directly.
#

set -euo pipefail
IFS=$'\n\t'

function usage() {
  cat <<EOM
  $1
  Usage:
    $0 <message> <auth_token> <device_token> <bundle_id>
EOM
  exit 0
}

# endpoint=https://api.push.apple.com:443
endpoint=https://api.sandbox.push.apple.com:443
urlPath=/3/device/

message=${1:-}
auth_token=${2:-}
device_token=${3:-}
bundleId=${4:-}

[[ -z "$message" ]] && usage "No message given!"
[[ -z "$auth_token" ]] && usage "No auth token given!"
[[ -z "$device_token" ]] && usage "No device token given!"
[[ -z "$bundleId" ]] && usage "No bundle id given!"

url=$endpoint$urlPath$device_token

curl -v \
     --http2 \
     -H "apns-topic: ${bundleId}" \
     -H "apns-push-type: alert" \
     -H "Authorization: bearer ${auth_token}" \
     -d '{
            "aps": {
              "alert": "'"$message"'"
            }
          }' \
     "${url}"