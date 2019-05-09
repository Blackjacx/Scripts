#/bin/bash
#
# Converts scanned TIFF files to shrinked PDF's
#

EXT="tif"
# use xargs to trim whitespaces
COUNT=`ls -1 *.$EXT 2>/dev/null | wc -l | xargs`
THRESHOLD="50%"

# check if there are files of the specified extension
if [ $COUNT != 0 ]
then
  echo "Converting $COUNT $EXT's to black and white and merge them to one PDF..."

  # create temp dir
  TEMP="$(mktemp -d)"

  # convert all found images to black and white and merge them in one pdf
  convert *.tif -depth 1 -colorspace Gray -threshold "$THRESHOLD" -type bilevel -colors 2 $TEMP/out_%04d.png && convert $TEMP/*.png combined.pdf

  # delete temp dir
  rm -rf $TEMP
 
else
  echo "No $EXT's found!"
fi
