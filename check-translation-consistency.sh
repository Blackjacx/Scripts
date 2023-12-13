#!/bin/bash

# Import Global Functionality
. "$(dirname "$0")"/imports.sh --source-only

# Treats spaces correctly in filenames
IFS=$'\n'

# Find files that contain localization keys
ITEMS=( $( find . -name "*.strings" -type f ) )

UNUSED=()
KEYS=()

# Iterate over all localization files
for ITEM in "${ITEMS[@]}"; do
    LINES=( $(grep '^\".*\"' "$ITEM") )

    # LINES=( $(cat $ITEM | grep '^\".*\"') )
    echo "$red$ITEM $blue(${#LINES[@]} Keys)$white"

    # iterate over lines of the translation file and collect all keys
    for LINE in "${LINES[@]}"; do
        KEY=$(echo "$LINE" | cut -d'"' -f2 | cut -d'"' -f1)
        KEYS+=("$KEY")
    done
done

# sort and uniqueing all keys
KEYS=( $(printf "%s\n" "${KEYS[@]}" | sort -u) )
echo -e "Found $red${#KEYS[@]}$white keys in $red${#ITEMS[@]}$white files!\n"

# Iterate over all keys
for KEY in "${KEYS[@]}"; do
    # Find usages of localization keys - ignore paths from .strings files
    CMD_FIND="find $(pwd) -name \"*.swift\" -type f ! -path \"*.strings*\" -exec grep -n --quiet \"$KEY\" {} +"
    if ! eval "$CMD_FIND"; then
        UNUSED+=("$KEY")
    fi
done

# Status Reporting
echo -e "The following translation keys are unused:\n"
printf '\t%s\n' "${UNUSED[@]}"
echo
