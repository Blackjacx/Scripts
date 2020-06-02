#!/usr/bin/env bash

set -eo pipefail

url="https://api.appstoreconnect.apple.com/v1"
json_content_type="Content-Type: application/json"

group="$1"

usage() {
  echo "$1"
  echo 'Usage: export ASC_AUTH_HEADER="$(asc_auth_header)" && '$0' <tester_group_name>'
  echo "Quit..."
}

if [ -z "$ASC_AUTH_HEADER" ]; then usage "Authorization header environment variable missing!"; exit 1; fi

# Get all group ids
groups_json=$(curl -g -s "$url/betaGroups" -H  "$json_content_type" -H "Authorization: $ASC_AUTH_HEADER")

if [ -z "$group" ]; then 
  ids=$(echo $groups_json | jq ".data[].id" | awk -F'"' '{print $2}')
else
  ids=$(echo $groups_json | jq ".data[] | select(.attributes.name == \"$group\") | .id" | awk -F'"' '{print $2}')
fi

echo $ids
# printf '%s\n' "${ids[@]}"

# all_names=$(echo $groups_json | jq '.data[] | ( .id, .attributes )')
# printf '%s\n' "${all_names[@]}"

# names=$(echo $groups_json | jq ".data[] | select(.attributes.name == \"$group\") | (.id, .attributes)")
# printf '%s\n' "${names[@]}"

# all_ids=$(echo $groups_json | jq ".data[].id" | awk -F'"' '{print $2}')
# printf '%s\n' "${all_ids[@]}"

# printf '%s\n' "${ids[@]}"
# printf '%s\n' "${groups_json[@]}"


# app_links=($(echo $groups_json | jq ".data[] | select(.attributes.name == \"$group\") | .relationships.app.links.self" | awk -F'"' '{print $2}'))
# apps_json=$(curl -g -s "$url/apps" -H  "$json_content_type" -H "Authorization: $ASC_AUTH_HEADER")

# for link in "${app_links[@]}"; do
#   echo "Getting related app for beta group $link..."
#   app_id=$(curl -g -s "$link" -H  "$json_content_type" -H "Authorization: $ASC_AUTH_HEADER" \
#     | jq '.data.id' | awk -F'"' '{print $2}')

#   curl -g -s "$url/apps/$app_id" -H  "$json_content_type" -H "Authorization: $ASC_AUTH_HEADER" \
#     | jq '.data | ( .id, .attributes )'
# done