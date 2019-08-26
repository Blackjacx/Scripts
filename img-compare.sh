#!/usr/bin/env bash

# This script compares all the images from 2 folders assuming the image 
# names and count are the same for both folders. You have to provide the 
# folders to compare as 2 prameters. This sript requires imagemagick to 
# be installed.

# Import Global Functionality
. $(dirname "$0")/imports.sh --source-only

checkInstalledImageMagick

files1=( $( ls $1 ) )
files2=( $( ls $2 ) )

for i in $(seq 0 $((${#files1[*]}-1)))
do
    lhs="$1/${files1[i]}"
    rhs="$2/${files2[i]}"
    out="${files1[i]}"
    echo "Comparing $lhs with $rhs"
    magick compare "$lhs" "$rhs" $out
done