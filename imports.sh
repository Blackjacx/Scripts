#!/usr/bin/env zsh

## Define colors
red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
white=$'\e[0m'

function log () {
  echo "🟢 [$(date +'%H:%M:%S')] $1"
}

function log_warning () {
  echo "🟡 [$(date +'%H:%M:%S')] $1"
}

function log_error () {
  echo >&2 "🔴 [$(date +'%H:%M:%S')] $1"
}

# https://stackoverflow.com/a/17841619/971329
function join_by { 
  local IFS="$1"; shift; echo "$*"; 
}

function loadEnvironment () {
  # Ignores commented lines
  ENV_FILE="$(dirname "$0")/../.env"
  if [ -f "$ENV_FILE" ]; then
    export "$(grep -v '^#' "$ENV_FILE" | xargs)"
  fi
}

function checkInstalledJq () {
  command -v jq >/dev/null 2>&1 || { 
    echo >&2 "jq missing - Install using \"brew install jq\"."; exit 1; 
  }
}

function checkInstalledLocalise () {
  command -v lokalise >/dev/null 2>&1 || { 
    echo >&2 "lokalise missing - Install using \"brew tap lokalise/brew; brew install lokalise\"."; exit 1;
  }
}

function checkInstalledImageMagick () {
  command -v convert >/dev/null 2>&1 || { 
    echo >&2 "imagemagick missing - Install using \"brew install imagemagick\"."; exit 1;
  }
}

function trim () {
  awk '{$1=$1};1'
}

function mdsee() { 
    HTMLFILE="$(mktemp -u).html"
    jq --slurp --raw-input '{"text": "\(.)", "mode": "markdown"}' "$1" | \
      curl -s --data @- https://api.github.com/markdown > "$HTMLFILE"
    echo "$HTMLFILE"
    open "$HTMLFILE"
}

# Create and commit changelog item
function cci() {
  if [[ -z $1 ]]; then
    echo "Please provide a changelog title / issue number combination in the format <title #number>. Exit." && return
  fi

  title=$(echo $1 | sed 's/ #[0-9]*$//')
  number=$(echo $1 | sed 's/.*#//')
  account=$(git config github.user)

  while true; do
    printf 'Is the account name "%s" correct? [Y/n]: ' "$green$account$white"
    read yn
    case $yn in
      [Nn]* ) 
              echo "Please add your GitHub username to the local config using the following account and run the command again:$green git config --local github.user \<username\>"
              return;;

          * ) 
              break;; # continue with suggested account
    esac
  done

  entry="* [#$number](https://github.com/dbdrive/beiwagen/pull/$number): $title - [@$account](https://github.com/$account)."

  while true; do
    printf 'Do you want to commit the change log entry:%s? [Y/n]: ' "$green $entry $white"
    read yn
    case $yn in
      [Nn]* ) 
              break;; # cancel process

          * ) 
              echo "$entry" > "changelog/$number.md"
              git add "changelog/$number.md"
              git commit -m "Add Changelog Item"
              git push
              break;;
    esac
  done
}

# Open man page in textedit
function manv() {
  if [[ -z $1 ]]; then
    echo "Please provide the command you want to view the man page for. Exit." && return
  fi
  MANWIDTH=80 MANPAGER='col -bx' man "$1" | subl 
}

# Easily create ASC auth header
function asc_auth_header() {
  echo "Bearer $(ruby ~/dev/scripts/jwt.rb "$ASC_AUTH_KEY" "$ASC_AUTH_KEY_ID" "$ASC_AUTH_KEY_ISSUER_ID")"
}

function collage() {
  cd "$(mktemp -d)"

  # check if $@ only contain (PNG) images

  for IMAGE in "${@[@]}"
  do
    BASENAME="$(basename $IMAGE)"
    read -r width height <<< $(convert -ping "$IMAGE" -format "%w %h" info:)
    convert -size ${width}x${height} xc:none -fill white -draw "roundRectangle 0,0 ${width},${height} 50,50" "$IMAGE" -compose SrcIn -composite "$BASENAME"
  done

  montage * -background none -shadow -geometry '+25+25' collage.png
  read -r width height <<< $(convert -ping "collage.png" -format "%w %h" info:)
  convert -size ${width}x${height} radial-gradient:#fffffe-lightgray "gradient.png"
  composite -gravity center "collage.png" "gradient.png" "collage-gradient.png"
  convert -size ${width}x${height} xc:none -fill white -draw "roundRectangle 0,0 ${width},${height} 50,50" "collage-gradient.png" -compose SrcIn -composite final.png

  echo "Find your files in \"$(pwd)\""
  cd -

}