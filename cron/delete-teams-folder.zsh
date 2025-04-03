#!/usr/bin/env zsh

# Deletes the folder ~/Downloads/MSTeams since this is regenerated all the time and MS Teams
# stores some kind of VERY large data in there (>50GB)

folder="/Users/stherold/Downloads/MSTeams"

if [ -d "$folder" ]; then
    rm -rf "$folder"
fi
