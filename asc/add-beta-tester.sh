#!/usr/bin/env bash

set -euo pipefail

# Check to see if a pipe exists on stdin.
if [ -p /dev/stdin ]; then
  # Grab all the data piped into this script by using cat
  group_ids=($(cat))
fi

url="https://api.appstoreconnect.apple.com/v1"
json_content_type="Content-Type: application/json"

email="$1"
first="$2"
last="$3"

usage() {
  echo "$1"
  echo 'Usage: export ASC_AUTH_HEADER="$(asc_auth_header)" && ./group-ids-for-name.sh ioki | '$0' <email> <first_name> <last_name>'
  echo "Quit..."
}

if [ -z "$ASC_AUTH_HEADER" ]; then usage "Authorization header environment variable missing!"; exit 1; fi
if [ -z "$email" ]; then usage "Email missing!"; exit 1; fi
if [ -z "$first" ]; then usage "First name missing!"; exit 1; fi
if [ -z "$last" ]; then usage "Last name missing!"; exit 1; fi
if [ -z "$group_ids" ]; then usage "Tester group ids missing!"; exit 1; fi

# Add tester to all groups of given name
for id in "${group_ids[@]}"; do
  curl -g -s "$url/betaTesters" -H  "$json_content_type" -H "$ASC_AUTH_HEADER" \
    -d '{"data":{"type":"betaTesters", "attributes":{"email":"'"$email"'","firstName":"'"$first"'","lastName":"'"$last"'"},"relationships":{"betaGroups":{"data":[{"id":"'$id'","type":"betaGroups"}]}}}}' \
    | jq '.data | ( .id, .attributes )'
done