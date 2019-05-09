#!/bin/bash


# Iconizer shell script by Stefan Herold

# This is a simple tool to generate all necessary app icon sizes from one vector file.
# To use: specify the path to your vector graphic (PDF format)
# Example: sh iconizer.sh MyVectorGraphic.pdf

# Requires ImageMagick: http://www.imagemagick.org/
# Requires jq: https://stedolan.github.io/jq/

# set -e
# set -x

CONTENTS_FILE="Contents.json"

if [ $# -ne 2 ]
  then
        echo "\nUsage: sh iconizer.sh file.pdf FolderName"
elif [ ! -e "$1" ]
    then
        echo "Did not find file $1, expected path to a vector image file."
elif [ ${1: -4} != ".pdf" ]
    then
        echo "File $1 is not a vector image file! Expected PDF file."
elif [ ! -e "./$2/$CONTENTS_FILE" ]
    then
        echo "Did not find $2/$CONTENTS_FILE, expected folder which contains $CONTENTS_FILE"
else
    echo "Creating icons from $1 and updating $2/$CONTENTS_FILE..."

    i=0

    while :
    do
        image=$(jq ".images[$i]" ./$2/$CONTENTS_FILE)
        scale=$(echo $image | jq ".scale" | cut -d "\"" -f 2 | cut -d "x" -f 1 )
        sizePT=$(echo $image | jq ".size" | cut -d "\"" -f 2 | cut -d "x" -f 1 )
        sizePX=$(bc -l <<< "scale=1; $sizePT*$scale")
        newFileName="appicon_${sizePX}.png"

        if [[ "$image" == "null" ]]; then
          break
        fi

        jq ".images[$i].filename = \"$newFileName\"" "./$2/$CONTENTS_FILE" > tmp.$$.json && mv tmp.$$.json "./$2/$CONTENTS_FILE"

        if [ -e "$2/$newFileName" ]; then
            echo "File $newFileName already created... Continue"
            i=$(( $i + 1 ))
            continue
        fi

        echo -n "Creating $newFileName of size and update $CONTENTS_FILE..."

        convert -density 400 "$1" -scale "$sizePX" "$2/$newFileName"

        echo " ✅"
        i=$(( $i + 1 ))
    done
fi