#!/usr/bin/env bash

# set -euo pipefail

url="https://api.appstoreconnect.apple.com/v1"
json_content_type="Content-Type: application/json"

email=$1
group_ids=($2)

usage() {
  echo "$1"
  echo 'Usage: export ASC_AUTH_HEADER="$(asc_auth_header)" && '$0' "<email>"  "$(./group-ids-for-name.sh ioki)"'
  echo "Quit..."
}

if [ -z "$ASC_AUTH_HEADER" ]; then usage "Authorization header environment variable missing!"; exit 1; fi
if [ -z "$email" ]; then usage "Email missing!"; exit 1; fi
if [ -z "$group_ids" ]; then usage "Tester group ids missing!"; exit 1; fi

# Find user in each group nd delete it
for gid in "${group_ids[@]}"; do
  echo "Searching user $email in group with id $gid"
  response=$(curl -g -s "$url/betaGroups/$gid/betaTesters?fields[betaTesters]=email" -H  "$json_content_type" -H "Authorization: $ASC_AUTH_HEADER")
  uid=$(echo $response | jq ".data[] | select(.attributes.email ==\"$email\").id" | awk -F'"' '{print $2}')
  [[ $uid == "" ]] && echo "❌ Not found!" && continue
  echo "✅ $uid"

  curl -g s -X DELETE -s "$url/betaTesters/$uid/relationships/betaGroups" -H  "$json_content_type" -H "Authorization: $ASC_AUTH_HEADER" \
    -d '{"data": [{ "id": "$gid", "type": "betaGroups" }] }' \
    | jq '.data | ( .id, .attributes )'
done