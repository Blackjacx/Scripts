#!/usr/bin/env zsh

## Define colors
red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
white=$'\e[0m'

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
    echo "Please provide a changelog title. Exit." && return
  fi

  if [[ -z $2 ]]; then
    echo "Please provide the PR issue number. Exit." && return
  fi
  
  touch changelog/$2.md
  echo "* [#$2](https://github.com/dbdrive/beiwagen/pull/$2): $1 - [@Blackjacx](https://github.com/blackjacx)." > changelog/$2.md
  git add changelog/$2.md
  git commit -m "Add Changelog Item"
  git push
}

# Easily create ASC auth header
function asc_auth_header() {
  echo "Authorization: Bearer $(ruby ~/dev/scripts/jwt.rb $ASC_AUTH_KEY $ASC_AUTH_KEY_ID $ASC_AUTH_KEY_ISSUER_ID)"
}