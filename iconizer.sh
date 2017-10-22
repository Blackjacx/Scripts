#!/bin/bash


# Iconizer shell script by Stefan Herold

# This is a simple tool to generate all necessary app icon sizes from one vector file.
# To use: specify the path to your vector graphic (PDF format)
# Example: sh iconizer.sh MyVectorGraphic.pdf

# Requires ImageMagick: http://www.imagemagick.org/
# Requires jq: https://stedolan.github.io/jq/

# set -x

CONTENTS_FILE="Contents.json"

die () {
  echo >&2 "$@"
  exit 1
}

[ $# == 2 ] || die "Usage: sh iconizer.sh file.pdf FolderName"
[ -e "$1" ] || die "Did not find file $1, expected path to a vector image file."
[ ${1: -4} == ".pdf" ] || die "File $1 is not a vector image file! Expected PDF file."

CONTENT_FILE_PATH="$2/$CONTENTS_FILE"

[ -e "$CONTENT_FILE_PATH" ] || die "Did not find $CONTENT_FILE_PATH, expected folder which contains $CONTENTS_FILE"

echo "Creating icons from $1 and updating $CONTENT_FILE_PATH..."

i=0

while :
do
    image=$(jq ".images[$i]" $CONTENT_FILE_PATH)
    scale=$(echo $image | jq ".scale" | cut -d "\"" -f 2 | cut -d "x" -f 1 )
    sizePT=$(echo $image | jq ".size" | cut -d "\"" -f 2 | cut -d "x" -f 1 )
    sizePX=$(bc -l <<< "scale=1; $sizePT*$scale" | cut -d "." -f 1)
    newFileName="appicon_${sizePX}.png"

    [ "$image" != "null" ] || break

    jq ".images[$i].filename = \"$newFileName\"" "$CONTENT_FILE_PATH" > tmp.$$.json && mv tmp.$$.json "$CONTENT_FILE_PATH"

    if [ -e "$2/$newFileName" ]; then
      echo "File $newFileName already created... Continue"
    else
      echo -n "Creating $newFileName and update $CONTENTS_FILE..."
      convert -density 400 "$1" -scale "$sizePX" "$2/$newFileName"
      echo "✅"
    fi

    i=$(( $i + 1 ))
done