#!/bin/bash

IMAGEMAGICK_DIR='../Tools/ImageMagick-6.9.2'

# check if tools installed
if ! type "${IMAGEMAGICK_DIR}/bin/composite" > /dev/null; then
  echo "Composite tool not found! Run 'brew install imagemagick' and 'brew install ghostcript'"
  exit 1
fi

if ! type "${IMAGEMAGICK_DIR}/bin/convert" > /dev/null; then
  echo "Convert tool not found! Run 'brew install imagemagick' and 'brew install ghostcript'"
  exit 1
fi

if ! type "${IMAGEMAGICK_DIR}/bin/identify" > /dev/null; then
  echo "Identify tool not found! Run 'brew install imagemagick' and 'brew install ghostcript'"
  exit 1
fi

if [ -z "${SCHEME_FILE}" ]; 
	then echo "Set 'SCHEME_FILE' build setting that points to the file containing the scheme name or enter in a pre build action for the scheme!";
	exit 1; 
fi

if [ ! -f "${SCHEME_FILE}" ]; then 
	echo "Scheme file $SCHEME_FILE file does not exist! Do not forget to set 'Provide the build settings' to the desired scheme in the scheme editor!"; 
	exit 1; 
fi

echo $SCHEME_FILE
SCHEME_NAME=`cat ${SCHEME_FILE}`
rm -rf $SCHEME_FILE
echo $SCHEME_NAME

if [ -z "${SCHEME_NAME}" ]; then 
	echo "You probably forgot to add pass the scheme name to createSchemeName.sh in the schemes pre-build action."; 
	exit 1; 
fi


IFS=$'\n'
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")
versionNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${PROJECT_DIR}/${INFOPLIST_FILE}")
TARGET_PATH=${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}

function generateIcon () {
  IMAGE_PATH="$TARGET_PATH/$1"

  echo "Image path: $IMAGE_PATH"

  WIDTH=$(${IMAGEMAGICK_DIR}/bin/identify -format %w ${IMAGE_PATH})
  FONT_SIZE=$(echo "$WIDTH * .15" | bc -l)

  echo "Target Path: $TARGET_PATH"
  echo "Image Path: $IMAGE_PATH"

  if [ "${SCHEME_NAME}" == "DEBUG" ]; then
    ${IMAGEMAGICK_DIR}/bin/convert debugRibbon.png -resize ${WIDTH}x${WIDTH} ${TEMP_DIR}/resizedRibbon.png
    ${IMAGEMAGICK_DIR}/bin/convert ${IMAGE_PATH} -fill white -font Helvetica-Bold -pointsize ${FONT_SIZE} -gravity south -annotate 0 "$versionNumber ($buildNumber)" - | ${IMAGEMAGICK_DIR}/bin/composite ${TEMP_DIR}/resizedRibbon.png - ${IMAGE_PATH}
  fi 
  
  if [ "${SCHEME_NAME}" == "RELEASE" ]; then
    ${IMAGEMAGICK_DIR}/bin/convert betaRibbon.png -resize ${WIDTH}x${WIDTH} ${TEMP_DIR}/resizedRibbon.png
    ${IMAGEMAGICK_DIR}/bin/convert ${IMAGE_PATH} -fill white -font Helvetica-Bold -pointsize ${FONT_SIZE} -gravity south -annotate 0 "$versionNumber ($buildNumber)" - | ${IMAGEMAGICK_DIR}/bin/composite ${TEMP_DIR}/resizedRibbon.png - ${IMAGE_PATH}
  fi
}

declare -a pngs=`ls $TARGET_PATH | grep AppIcon`

for i in $pngs; do
  generateIcon $i
done
