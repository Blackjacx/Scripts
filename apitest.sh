#!/bin/sh

#
# Requires the following parameters in a .env file in the projects directory:
#    STELLWERK_ACCESS_TOKEN=""
#    BASE_URL=""
#    CLIENT_ID=""
#

# Load environment
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

# Check if jq installed
command -v jq >/dev/null 2>&1 || { 
  echo >&2 "jq missing - Install using \"brew install jq\"."; exit 1; 
}

configurations=(
  "user#-XGET"
  "client#-XGET"
  "rides#-XGET"
  "rides/current#-XGET"
  "products#-XGET"
  "firebase_token#-XGET"
  "stripe_ephemeral_keys#-XPOST#{\"api_version\": \"2015-10-12\"}"
)

options=(
  "read user"
  "read client"
  "read rides"
  "read current ride"
  "read products"
  "read firebase token"
  "create stripe epermal key"
)

PS3='Choose an option: '
select opt in "${options[@]}" exit; do 
   case $REPLY in
      $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break ;;
                            * ) break;;
   esac
done

REPLY=$(($REPLY-1))
config="${configurations[$REPLY]}"

if [ -z "$opt" ]; then echo "Invalid option chosen. Quit..."; exit 1; fi
if [ -z "$config" ]; then echo "Configuration not found for choice $REPLY. Quit..."; exit 1; fi

IFS='#' read -r -a array <<< "$config"
path="${array[0]}"
method="${array[1]}"
data="${array[2]}"
url="$BASE_URL/$path"

echo "Curling $url ..."

RESULT=$(curl -s $method \
  -H 'X-Client-Version: 100.0.0' \
  -H 'X-Api-Version: 1' \
  -H "X-Client-Identifier: $CLIENT_ID" \
  -H 'Content-type: application/json' \
  -H "Authorization: Bearer ${STELLWERK_ACCESS_TOKEN}" "$url" -d "$data")

echo $RESULT | jq

# Apply filter
while true; do
 read -p "Do you wish to apply a jq filter? [y/N]: " yn
  case $yn in
    [Yy]* ) while true; do 
              read -p "Enter your jq filter: " filter 
              break 
            done
            echo $RESULT | jq $filter;
            break;;

        * ) break;;
  esac
done
