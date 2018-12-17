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
  if [ -f $ENV_FILE ]; then
    export $(grep -v '^#' $ENV_FILE | xargs) 
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
## (ignore "latest" casks)
function brew-upgrade-all() {
  if ! which socat &> /dev/null; then
    echo "plz install socat, bro"
    return 1
  fi

  brew update
  brew upgrade

  # Get all casks that are upgradable, but ignore 
  # packages with "latest" as version set.
  # Those packages would be upgraded everytime, 
  # no matter whether there are actually new 
  # versions.
  # The "socat" workaround is required, as 
  # homebrew only displays the "latest" 
  # information when output is a TTY, so a simple 
  # pipe doesn't work
  local casks
  casks=$(socat - EXEC:'brew cask outdated --greedy',pty,setsid,ctty |grep -v latest |awk '{ print $1 }')
  if [ -n "$casks" ]; then
    brew cask upgrade --greedy $cask
  fi

  brew prune
  brew cleanup
  brew doctor
}