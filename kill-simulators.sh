#!/bin/bash
# Get the sim list with the UUIDs
OUTPUT="$(xcrun simctl list)"
# Parse out the UUIDs and saves them to file
echo $OUTPUT | awk -F "[()]" '{ for (i=2; i<NF; i+=2) print $i }' | grep '^[-A-Z0-9]*$' > output.txt
# Iterate through file and reset sim
for UUID in `awk '{ print $1 }' output.txt`
do
	echo "Shutdown sims &UUID"
	xcrun simctl shutdown $UUID
done
echo "Kill running simulators..."
osascript -e 'tell application "Simulator" to quit'
echo "Erase all simulators..."
xcrun simctl erase all
echo "Reopen simulator application..."
open -a "Simulator"
