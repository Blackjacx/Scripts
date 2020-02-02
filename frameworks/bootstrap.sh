#!/usr/bin/env bash

#
# Sets up the project to start development
#

# fail on unset variables and if any piped command fails
set -uo pipefail

# fail if any command fails
set -e

# Download files using curl
curl https://raw.githubusercontent.com/Blackjacx/Scripts/master/frameworks/Dangerfile -o Dangerfile
curl https://raw.githubusercontent.com/Blackjacx/Scripts/master/frameworks/.swiftlint.yml -o .swiftlint.yml
curl https://raw.githubusercontent.com/Blackjacx/Scripts/master/frameworks/Mintfile -o Mintfile
curl https://raw.githubusercontent.com/Blackjacx/Scripts/master/frameworks/.gitignore -o .gitignore

echo "checking for homebrew updates";
brew update

function install_current {
  echo "trying to update $1"
  brew upgrade $1 || brew install $1 || true
  brew link $1
}

if [ -e "Mintfile" ]; then
  install_current mint
  mint bootstrap
fi

# Install gems if a Gemfile exists
if [ -e "Gemfile" ]; then
  echo "installing ruby gems";
  # install bundler gem for ruby dependency management
  gem install bundler --no-document || echo "failed to install bundle";
  bundle config set deployment 'true';
  bundle install || echo "failed to install bundle";
fi