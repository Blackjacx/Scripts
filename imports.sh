#!/bin/bash

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

## Function to upgrade all casks and packages 
function brew-upgrade-all() {
  
  echo "\nBrew update-reset && brew update:"  
  brew update-reset && brew update 
  
  # create a Brewfile of all installed formulas, casks, taps, mas
  # brew bundle dump --describe --global

  # upgrade all software defined in Brewfile
  echo "\nBrew bundle - update software defined in global Brewfile in HOME:"
  brew bundle -v --global
  
  echo "\nBrew cask upgrade - upgrade casks separately:"
  brew cask upgrade $(sed -n -e '/^cask "/p' "${HOME}/.Brewfile" |cut -d \" -f2)
  
  echo "\nBrew cleanup:"
  brew cleanup
  
  echo "\nBrew doctor:"
  brew doctor
}

function mdsee() { 
    HTMLFILE="$(mktemp -u).html"
    cat "$1" | \
      jq --slurp --raw-input '{"text": "\(.)", "mode": "markdown"}' | \
      curl -s --data @- https://api.github.com/markdown > "$HTMLFILE"
    echo $HTMLFILE
    open "$HTMLFILE"
}