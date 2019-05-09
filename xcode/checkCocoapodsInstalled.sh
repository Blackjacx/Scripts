#!/bin/bash

# make pod acessible
export PATH=$PATH:${HOME}/.gem/bin/

if ! which pod > /dev/null; then
  echo "error: Cocoapods not installed in ${HOME}/.gem/bin/, install using '[sudo] gem install cocoapods'"
  exit 1
fi