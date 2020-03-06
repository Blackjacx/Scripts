#!/usr/bin/env bash

url="https://api.appstoreconnect.apple.com/v1"

email="$1"
first="$2"
last="$3"
group="$4"
token="$5"

usage() {
  echo "$1"
  echo "Usage: $0 <email> <first_name> <last_name> <tester_group>"
  echo "Quit..."
}

if [ -z "$email" ]; then usage "Email missing!"; exit 1; fi
if [ -z "$first" ]; then usage "First name missing!"; exit 1; fi
if [ -z "$last" ]; then usage "Last name missing!"; exit 1; fi
if [ -z "$group" ]; then usage "Tester group missing!"; exit 1; fi
if [ -z "$token" ]; then usage "Token missing!"; exit 1; fi

# Get all ioki / external group ids
group_ids=($(curl -g -s \
  "$url/betaGroups" \
  -H  "content-type: application/json" \
  -H "Authorization: Bearer $token" \
  | jq ".data[] | select(.attributes.name == \"$group\") | .id" \
  | tr -d \"))

# Add tester to all groups of given name
for id in "${group_ids[@]}"; do
  curl -g -s \
    "$url/betaTesters" \
    -d '{"data":{"type":"betaTesters", "attributes":{"email":"'"$email"'","firstName":"'"$first"'","lastName":"'"$last"'"},"relationships":{"betaGroups":{"data":[{"id":"'$id'","type":"betaGroups"}]}}}}' \
    -H  "content-type: application/json" \
    -H "Authorization: Bearer $token" \
    | jq '.data | ( .id, .attributes )'
done