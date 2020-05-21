#!/usr/bin/env bash

set -euo pipefail

url="https://api.appstoreconnect.apple.com/v1"
json_content_type="Content-Type: application/json"

group="$1"

usage() {
  echo "$1"
  echo 'Usage: export ASC_AUTH_HEADER="$(asc_auth_header)" && '$0' <tester_group_name>'
  echo "Quit..."
}

if [ -z "$group" ]; then usage "Tester group name missing!"; exit 1; fi
if [ -z "$ASC_AUTH_HEADER" ]; then usage "Authorization header environment variable missing!"; exit 1; fi

# Get all group ids
ids=$(curl -g -s "$url/betaGroups" -H  "$json_content_type" -H "$ASC_AUTH_HEADER" \
  | jq ".data[] | select(.attributes.name == \"$group\") | .id" \
  | awk -F'"' '{print $2}')

echo $ids