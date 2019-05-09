#!/bin/bash

APP_PATH="$TARGET_BUILD_DIR/$EXECUTABLE_FOLDER_PATH"

if [ ! -d "$APP_PATH" ]; then
	echo "error: $APP_PATH does not exist!"
	exit 1
fi

INFO_PLIST="$TARGET_BUILD_DIR/$INFOPLIST_PATH"
ROOT_PLIST="$APP_PATH/Settings.bundle/Root.plist"
VERSION_STRING=$(git rev-parse --short HEAD)

echo "Writing git hash ($VERSION_STRING) to $INFO_PLIST"

defaults write $INFO_PLIST GitCommitHash $VERSION_STRING

if [ -f "$ROOT_PLIST" ]; then
	echo "Writing git hash ($VERSION_STRING) to $ROOT_PLIST"
    defaults write $ROOT_PLIST GitCommitHash $VERSION_STRING
fi