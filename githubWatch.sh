#! /bin/bash

# Load environment
env_file="$(dirname "$0")/.env"
if [ -f $env_file ]; then
  export $(cat $env_file | xargs)
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
tag_urls=()
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
  tag_urls+=($(echo "$repo_json" | jq '.[].tags_url' | sed -e 's/\"//g'))
  repo_names+=($(echo "$repo_json" | jq '.[].name' | sed -e 's/\"//g'))
done

# Fetch latest tag and all infor necessary
for i in "${!tag_urls[@]}"
do
  tag_url="${tag_urls[$i]}"
  repo_name="${repo_names[$i]}"

  tag_json=$(curl -H "Authorization: token $GITHUB_TOKEN" -s "${tag_url}?per_page=1")
  tag=$(echo "$tag_json" | jq '.[].name' | sed -e 's/\"//g')
  commit_url=$(echo "$tag_json" | jq '.[].commit.url' | sed -e 's/\"//g')

  if [ -z "${tag}" ]; then continue; fi

  commit_json=$(curl -H "Authorization: token $GITHUB_TOKEN" -s "${commit_url}")
  commit_date=$(echo "$commit_json" | jq '.commit.author.date' | sed -e 's/\"//g')

  records+=("$commit_date • $repo_name • $tag")
done

# Sort and display the 5 latest updates
IFS=$'\n' sorted=($(sort -r <<<"${records[*]}"))
unset IFS

sorted=("${sorted[@]:0:10}")
for record in "${sorted[@]}"; do
  echo "$record"
done