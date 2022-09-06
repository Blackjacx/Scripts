#!/usr/bin/env bash

#
# Sets up the project to start development
#

# fail on unset variables and if any piped command fails
set -uo pipefail

# fail if any command fails
set -e

function showUsage() {
# `cat << EOF` This means that cat should stop reading when EOF is detected
cat << EOF  
Usage: $0 [-hdv]

Sets up the environment for new developers or CI so everything is ready to build.

-h     Display this help
-d     Download configuration files
-v     Run script in verbose mode. Will print out each step of execution

EOF
# EOF is found above and hence cat command stops reading.
}

function download_config_files {
  echo "Download configuration files"
  # Download files using curl
  curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/Dangerfile -o Dangerfile
  curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/.swiftlint.yml -o .swiftlint.yml
  curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/Mintfile -o Mintfile
  curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/gitignore -o .gitignore
  curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/Gemfile -o Gemfile
  curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/Fastfile -o ./fastlane/Fastfile --create-dirs
  curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/Pluginfile -o ./fastlane/Pluginfile --create-dirs

  # Do not use custom script since Swift Package Index can host the docs automatically
  #curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/make-docc-documentation.sh -o ./scripts/make-docc-documentation.sh --create-dirs
  
  # Test workflow for SPM only packages - for now integrated manually where needed
  #curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/gh-actions/spm-only-test.yml -o ./.github/workflows/spm-only-test.yml --create-dirs
}

function install_current {
  echo "trying to update $1"
  brew upgrade $1 || brew install $1 || true
  brew link $1
}

function install_dependencies {
  echo "checking for homebrew updates";
  brew update

  if [ -e "Mintfile" ]; then
    install_current mint
    mint bootstrap
  fi

  # Install gems if a Gemfile exists
  if [ -e "Gemfile" ]; then
    echo "installing ruby gems";
    # install bundler gem for ruby dependency management
    gem install bundler --no-document || echo "failed to install bundle";
    bundle install || echo "failed to install bundle";
  fi

    # Install gems if a Gemfile exists
  if [ -e "Podfile" ]; then
    echo "installing cocoapods dependencies";
    bundle exec pod install
  fi
}


while getopts "hdv" opt; do
  case ${opt} in
    h)
      showUsage; exit 0 ;;
    d)
      download_config_files; exit 0 ;;
    v)
      export verbose=1
      set -xv  # set xtrace and verbose mode
      ;;
    \?)
      showUsage; exit 1 ;;
    *)
      showUsage; exit 1 ;;
  esac
done

download_config_files
install_dependencies