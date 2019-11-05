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
  
  # create working dir
  # temp=$(mktemp -d)
  # brewfile="$temp/Brewfile"
  brewfile="${HOME}/dev/scripts/bootstrap/Brewfile"
  # echo "Created temporary directory at $temp"
  # update homebrew
  echo "Brew update:"  
  brew update
  # create a Brewfile of all installed formulas, casks, taps, mas
  # brew bundle dump --describe --file="$brewfile"
  # upgrade all software from the created Brewfile
  echo "Brew bundle - update outdated software:"
  brew bundle -v --file="$brewfile"
  # upgrade casks since the approach with the Brewfile doesn't work
  # brew cask upgrade $(sed -n -e '/^cask "/p' "$brewfile" |cut -d \" -f2)
  echo "Brew cask upgrade - upgrade casks separately:"
  brew cask upgrade $(sed -n -e '/^cask "/p' "$brewfile" |cut -d \" -f2)
  # cleanup old versions
  echo "Brew cleanup:"
  brew cleanup
  # check if the system is ready to brew
  echo "Brew doctor:"
  brew doctor
}