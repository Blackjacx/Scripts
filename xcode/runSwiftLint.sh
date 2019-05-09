#!/bin/bash

# make swiftlint acessible
export PATH=$PATH:/usr/local/bin/

# if command -v swiftlint 2>/dev/null; then
if ! which swiftlint > /dev/null; then
  echo echo "error: SwiftLint not installed in /usr/local/bin, download from https://github.com/realm/SwiftLint"
  exit 1
fi

swiftlint autocorrect
swiftlint