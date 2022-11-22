#!/bin/bash
set -euo pipefail

# Iconizer shell script by Stefan Herold and Yunus Tür

# This is a simple tool to generate all necessary app icon sizes from one vector file.
# To use: specify the path to your vector graphic (PDF format)
# Example: sh iconizer.sh VectorGraphic.pdf AppIcon.appiconset

# Requires ImageMagick: http://www.imagemagick.org/
# Requires jq: https://stedolan.github.io/jq/

# Variables

PDF_PATH=""
APP_ICON_SET_PATH=""
CONTENTS_FILE="Contents.json"
CONTENTS_PATH=""
IMAGES_LENGTH=0

# Functions

checkInputs() {
  ([ $1 != "null" ] && [ $2 != "null" ]) || die "Usage: sh iconizer.sh <IMAGE_PATH.pdf> <APP_ICON_PATH.appiconset>"
  ([ -e "$1" ] && [ ${1: -4} == ".pdf" ]) || die "Did not find file $1, expected path to an image file with .pdf extension."
  ([ -e "$2" ] && [ ${2: -11} == ".appiconset" ]) || die "Did not find folder $2, expected path should end with .appiconset extension."

  PDF_PATH=$1
  APP_ICON_SET_PATH=$2
  CONTENTS_PATH="$APP_ICON_SET_PATH/$CONTENTS_FILE"

  [ -e "$CONTENTS_PATH" ] || die "Did not find $CONTENTS_PATH. Appiconset must contain a $CONTENTS_FILE file."

  IMAGES_LENGTH=$(jq ".images | length" $CONTENTS_PATH)

  ([ "$IMAGES_LENGTH" != "null" ] && (($IMAGES_LENGTH > 0))) || die "Did not find any images in $CONTENTS_PATH"
}

generateImages() {
  echo "Creating icons from $APP_ICON_SET_PATH and updating $CONTENTS_PATH..."
  for ((i = 0; i < $IMAGES_LENGTH; ++i)); do
    generateImage $i
  done
  echo "All Done 🎉🎉🎉"
}

generateImage() {
  image=$(jq ".images[$1]" $CONTENTS_PATH)

  scale=$(echo $image | jq -r ".scale" | cut -d "x" -f 1)
  [ $scale != "null" ] || scale=1

  sizePT=$(echo $image | jq -r ".size" | cut -d "x" -f 1)
  sizePX=$(bc -l <<<"scale=1; $sizePT*$scale" | cut -d "." -f 1)
  newFileName="appicon_${sizePX}.png"

  echo -n "Updading $CONTENTS_FILE to $newFileName"
  jq ".images[$1].filename = \"$newFileName\"" "$CONTENTS_PATH" >tmp.$$.json && mv tmp.$$.json "$CONTENTS_PATH"
  echo " ✅"

  if [ -e "$APP_ICON_SET_PATH/$newFileName" ]; then
    echo "File $newFileName already created... Continue ✅"
  else
    echo -n "Generating $newFileName"
    convert -density 400 "$PDF_PATH" -scale "$sizePX" "$APP_ICON_SET_PATH/$newFileName"
    echo " ✅"
  fi
}

die() {
  echo >&2 "$@"
  exit 1
}

# Logics

checkInputs ${1-null} ${2-null}
generateImages
