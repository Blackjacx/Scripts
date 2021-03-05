#!/usr/bin/env bash

set -euo pipefail

url="https://api.appstoreconnect.apple.com/v1"
json_content_type="Content-Type: application/json"

email=$1
first=$2
last=$3
group_ids=($4)

usage() {
  echo "$1"
  echo 'Usage: export ASC_AUTH_HEADER="$(asc_auth_header)" && '$0' "<email>" "<first_name>" <last_name>" "$(./group-ids-for-name.sh ioki)"'
  echo "Quit..."
}

if [ -z "$ASC_AUTH_HEADER" ]; then usage "Authorization header environment variable missing!"; exit 1; fi
if [ -z "$email" ]; then usage "Email missing!"; exit 1; fi
if [ -z "$first" ]; then usage "First name missing!"; exit 1; fi
if [ -z "$last" ]; then usage "Last name missing!"; exit 1; fi
if [ -z "$group_ids" ]; then usage "Tester group ids missing!"; exit 1; fi

# Add tester to all groups of given name
for id in "${group_ids[@]}"; do
  echo "Inviting $first $last $email to group with id \"$id\""
  curl -g -s "$url/betaTesters" -H  "$json_content_type" -H "Authorization: $ASC_AUTH_HEADER" \
    -d '{"data":{"type":"betaTesters", "attributes":{"email":"'"$email"'","firstName":"'"$first"'","lastName":"'"$last"'"},"relationships":{"betaGroups":{"data":[{"id":"'$id'","type":"betaGroups"}]}}}}' \
    | jq '.data | ( .id, .attributes )'

  # Add users to an internal App Store Conect app (they must exist and thus have an ID)
  # tester_id=""
  # curl -g -s "$url/betaGroups/$id/relationships/betaTesters" -H  "$json_content_type" -H "Authorization: $ASC_AUTH_HEADER" \
  #   -d '{ "data": [{ "type": "betaTesters", "id": "'"$tester_id"'" }] }' \
  #   | jq '.data | ( .id, .attributes )'
done