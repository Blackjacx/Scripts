#!/usr/bin/env bash

set -euo pipefail

url="https://api.appstoreconnect.apple.com/v1"
json_content_type="Content-Type: application/json"

usage() {
  echo "$1"
  echo 'Usage: export ASC_AUTH_HEADER="$(asc_auth_header)" && '$0
  echo "Quit..."
}

if [ -z "$ASC_AUTH_HEADER" ]; then usage "Authorization header environment variable missing!"; exit 1; fi

while true; do
  build_ids=($(curl -s -g "$url/builds?limit=50&filter[expired]=false" \
    -H "Authorization: $ASC_AUTH_HEADER" -H "$json_content_type" \
    | jq '.data[].id' | awk -F'"' '{print $2}'))

  if [[ $build_ids == "" ]]; then
    echo "No more ids found. Quit."
    break
  fi

  printf '%s\n' "${build_ids[@]}"

  for id in "${build_ids[@]}"; do
    curl -X PATCH \
      -g "$url/builds/$id" \
      -H "Authorization: $ASC_AUTH_HEADER" -H "$json_content_type" \
      --data '{"data":{"id":'"\"$id\""',"type": "builds", "attributes":{"expired":true}}}'
  done
done

