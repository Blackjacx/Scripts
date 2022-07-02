#!/usr/bin/env zsh

#
# Builds the package documentation using Apple's DocC
#
# This script was derived from 
# https://www.createwithswift.com/publishing-docc-documention-as-a-static-website-on-github-pages/
#
# Distributing Documentation to External Developers
# https://developer.apple.com/documentation/xcode/distributing-documentation-to-external-developers

local usage()
{
  echo "$2"
  echo "Usage: $1 <PACKAGE_NAME>"
  echo "Quit..."
}

PACKAGE_NAME="${1:-}"
if [ -z $PACKAGE_NAME ]; then usage $0 "Package name missing!"; exit 1; fi

# Root of the package project
PROJECT_ROOT_PATH="$(dirname "$0")/.."
DOCS_PATH="${PROJECT_ROOT_PATH}/docs"
DERIVED_DATA="$(mktemp -d)"
DOC_ARCHIVE_PATH="${DERIVED_DATA}/Build/Products/Debug-iphonesimulator/${PACKAGE_NAME}.doccarchive"
HOSTING_BASE_PATH="${PACKAGE_NAME}"

xcodebuild docbuild \
    -scheme "${PACKAGE_NAME}" \
    -derivedDataPath "${DERIVED_DATA}" \
    -destination 'platform=iOS Simulator,name=iPhone 13'

$(xcrun --find docc) process-archive \
    transform-for-static-hosting  "${DOC_ARCHIVE_PATH}" \
    --output-path "${DOCS_PATH}" \
    --hosting-base-path "${HOSTING_BASE_PATH}"

printf "🟢 Find the docarchive in ${DOC_ARCHIVE_PATH}\n"
printf "🟢 Find the static web page in ${DOCS_PATH}/index.html\n"