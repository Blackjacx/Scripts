#!/usr/bin/env bash

set -eo pipefail

url="https://api.appstoreconnect.apple.com/v1"
json_content_type="Content-Type: application/json"

usage() {
  echo "$1"
  echo 'Usage: export ASC_AUTH_HEADER="$(asc_auth_header)" && '$0''
  echo "Quit..."
}

if [ -z "$ASC_AUTH_HEADER" ]; then usage "Authorization header environment variable missing!"; exit 1; fi

# Get all group ids
raw_json=$(curl -g -s "$url/apps" -H  "$json_content_type" -H "Authorization: $ASC_AUTH_HEADER")

# ids=$(echo $raw_json | jq ".data[].id" | awk -F'"' '{print $2}')
ids=$(echo $raw_json | jq ".data[].id" | awk -F'"' '{print $2}')

echo $ids

# echo $raw_json | jq

# all_apps=$(echo $raw_json | jq '.data[] | ( .id, .attributes )')
# printf '%s\n' "${all_apps[@]}"