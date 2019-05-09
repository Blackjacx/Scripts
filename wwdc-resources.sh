#!/bin/bash

# 
# Bash script for downloading WWDC video and pdf ressources
# You can choose the year you're interested in by altering the variable YEAR (works only for 2014 until today).
# 
# IMPORTANT
# Please install wget prior running this script since this tool is used to download the pdf's and videos. I use it 
# since it is able to prevent re-downloading already existing content. So you can just run this script again and 
# again and it will just download new content. This is really useful in the week of the WWDC since videos are 
# offered on a daily basis.
# 

# Important for echoing results to prevent linebreaks everywhere...
IFS=$'\n'

verbose=1
# loadPDFContent=1
loadHDContent=1
YEAR=2016
BASE_URL="https://developer.apple.com"
META_DOWNLOAD_URL="$BASE_URL/videos/wwdc$YEAR/"
TITLE_DELIMITER="  #########  "
STARTTIME=$(date +%s)

ressourcePageURFile="/tmp/urls.txt"
ressourcePageContentFile="/tmp/ressourcePagesContent.txt"
pdfURLsFile="/tmp/pdfURLsFile.txt"
hdVideoURLsFile="/tmp/hdVideoURLsFile.txt"
sdVideoURLsFile="/tmp/sdVideoURLsFile.txt"

rm -f $ressourcePageURFile
rm -f $ressourcePageContentFile
rm -f $pdfURLsFile
rm -f $hdVideoURLsFile
rm -f $sdVideoURLsFile

if [ "$YEAR" -lt 2014 ]; then echo "This script does not work for years before 2014."; exit 1; fi

if [ "$YEAR" -lt 2015 ]; then VIDEO_EXT="mov"; else VIDEO_EXT="mp4"; fi


if [ -n "$verbose" ]; then 
	echo 
	echo "Downloading meta info from $META_DOWNLOAD_URL"
fi
            
metaPageContent=$(curl --silent $META_DOWNLOAD_URL)
META_CURL_RESULT=($(printf '%s' "$metaPageContent" | grep '<a href="/videos/play/.*h5' | sed -e 's/^[[:space:]]*//' | sort))
META_CURL_RESULT=($(printf '%s\n' "${META_CURL_RESULT[@]}" | awk -F'[\"><]' '{print "'"$BASE_URL"'" $3 "'"$TITLE_DELIMITER"'" $9}'))

if [ -n "$verbose" ]; then 
	printf '\nSorted curl meta info (%d items):\n' "${#META_CURL_RESULT[@]}"
	printf '%s\n' "${META_CURL_RESULT[@]}"
fi

# Put all urls in a curl config file
for item in "${META_CURL_RESULT[@]}"
do
	ressourcePageURL=$(printf "%s" "$item" | awk -F"$TITLE_DELIMITER" '{print $1}')
	echo "url = $ressourcePageURL" >> $ressourcePageURFile
done

# Loads all content pages using piping - fast approach
curl --silent -K $ressourcePageURFile >> $ressourcePageContentFile

cat /tmp/ressourcePagesContent.txt | grep -iIoh "http.*.pdf" | sed -e "s/.pdf.*/.pdf/g" | awk '{print $0}' >> $pdfURLsFile
cat /tmp/ressourcePagesContent.txt | grep -iIoh "http.*_sd_.*.$VIDEO_EXT" | sed -e "s/.$VIDEO_EXT.*/.$VIDEO_EXT/g" | awk '{print $0}' >> $sdVideoURLsFile
cat /tmp/ressourcePagesContent.txt | grep -iIoh "http.*_hd_.*.$VIDEO_EXT" | sed -e "s/.$VIDEO_EXT.*/.$VIDEO_EXT/g" | awk '{print $0}' >> $hdVideoURLsFile

if [ -n "$verbose" ]; then 
	printf ' PDF Files: %s\n SD Videos: %s\n HD Videos: %s\n' "$(cat $pdfURLsFile | wc -l)" "$(cat $sdVideoURLsFile | wc -l)" "$(cat $hdVideoURLsFile | wc -l)"
fi

# Loading PDF's in parallel
if [ -n "$loadPDFContent" ]; then 
	cat $pdfURLsFile | xargs -P 10 -n 1 wget -nc -c -T 10 -t 3
fi


# Loading HD or SD videos one by one and continue download if interrupted
if [ -n "$loadHDContent" ]; then 
	wget -c -T 10 -t 3 -i $hdVideoURLsFile
else
	wget -c -T 10 -t 3 -i $sdVideoURLsFile
fi

ENDTIME=$(date +%s)
DONE_MESSAGE="You waited $(($ENDTIME - $STARTTIME)) seconds..."
echo $DONE_MESSAGE
osascript \
  -e "on run(argv)" \
  -e 'return display notification item 1 of argv with title "Download Complete"' \
  -e "end" \
  -- "$DONE_MESSAGE"