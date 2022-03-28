#!/usr/bin/env zsh

## Define colors
red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
white=$'\e[0m'

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
    cat "$1" | \
      jq --slurp --raw-input '{"text": "\(.)", "mode": "markdown"}' | \
      curl -s --data @- https://api.github.com/markdown > "$HTMLFILE"
    echo $HTMLFILE
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
    printf "Is the account name \"$green$account$white\" correct? [Y/n]: "
    read yn
    case $yn in
      [Nn]* ) 
              echo "Please add your GitHub username to the local config using the following account and run the command again:$green git config --local github.user "\<username\>""
              return;;

          * ) 
              break;; # continue with suggested account
    esac
  done

  entry="* [#$number](https://github.com/dbdrive/beiwagen/pull/$number): $title - [@$account](https://github.com/$account)."

  while true; do
    printf "Do you want to commit the change log entry:$green $entry $white? [Y/n]: "
    read yn
    case $yn in
      [Nn]* ) 
              break;; # cancel process

          * ) 
              echo $entry > changelog/$number.md
              git add changelog/$number.md
              git commit -m "Add Changelog Item"
              git push
              break;;
    esac
  done
}

# Open man page in Preview 
function manv() {
  if [[ -z $1 ]]; then
    echo "Please provide the command you want to view the man page for. Exit." && return
  fi
  man -t $1 | open -f -a Preview
}

# Easily create ASC auth header
function asc_auth_header() {
  echo "Bearer $(ruby ~/dev/scripts/jwt.rb $ASC_AUTH_KEY $ASC_AUTH_KEY_ID $ASC_AUTH_KEY_ISSUER_ID)"
}