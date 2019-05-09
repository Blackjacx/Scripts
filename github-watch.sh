#! /bin/bash

# Load environment
env_file="$(dirname "$0")/.env"
if [ -f $env_file ]; then
  set -a; . $env_file; set +a # source .env file. works with comments.
fi

# Check if jq installed
command -v jq >/dev/null 2>&1 || { 
  echo >&2 "jq missing - Install using \"brew install jq\"."; exit 1; 
}

# Check if github token available
if [ -z "${GITHUB_TOKEN}" ]; then echo "Provide a token in a .env file in the scripts directory!"; exit 1; fi

urls=(
  "https://api.github.com/user/starred?per_page=100"
)
repo_names=()
releases_urls=()
html_urls=()
records=()

next="${urls[0]}"

# Get url to all starred repos by reading pagination info from headers
while [[ true ]]; do
  header=$(curl -I -H "Authorization: token $GITHUB_TOKEN" -s "$next")
  next=$(echo "$header" | grep "Link:" | sed -e 's/.*<\(.*\)>; rel="next".*/\1/')
  [[ $next != http* ]] && break
  urls+=("$next")
done

# Fetch starred repos
for next in "${urls[@]}"
do
  repo_json=$(curl -H "Authorization: token $GITHUB_TOKEN" -s "${next}")
  releases_urls+=($(echo "$repo_json" | jq '.[].releases_url' | sed -e 's/\"//g' | sed -e 's/{\/id}/\/latest/g'))
  html_urls+=($(echo "$repo_json" | jq '.[].html_url' | sed -e 's/\"//g'))  
  repo_names+=($(echo "$repo_json" | jq '.[].name' | sed -e 's/\"//g'))
done

# Fetch latest release
for i in "${!releases_urls[@]}"
do
  release_url="${releases_urls[$i]}"
  html_url="${html_urls[$i]}"
  repo_name="${repo_names[$i]}"

  release_json=$(curl -H "Authorization: token $GITHUB_TOKEN" -s "${release_url}")
  tag=$(echo "$release_json" | jq '.tag_name' | sed -e 's/\"//g')
  published_at=$(echo "$release_json" | jq '.published_at' | sed -e 's/\"//g')

  if [[ -z $tag || $tag == null ]]; then continue; fi

  records+=("$published_at • $repo_name • $tag • $html_url")
done

# Sort and display updates - latest first
IFS=$'\n' sorted=($(sort -r <<<"${records[*]}"))
unset IFS

sorted=("${sorted[@]}")
for record in "${sorted[@]}"; do
  echo $record
done