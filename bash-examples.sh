#! /bin/bash

# Logging

function log {
    echo "🟢 $1"
}

# Global and local variables

function assignGlobalVariable() {
    MESSAGE="Global variables are great for function return variables in scripts since they are destroyed after the script ends."
}

function assignLocalVariable() {
    local MESSAGE="Local variables exist only in the context of this function."
    log "$MESSAGE"
}

function variables() {
    log "$MESSAGE"
    assignGlobalVariable
    log "$MESSAGE"  
    assignLocalVariable
    log "$MESSAGE"  
}

# Calculation

function calculation() {
    a=1
    b=2
    c=3

    log "$a + $b + $c = $(( a+b+c ))"  
}

# Numeric comparison

function numericCompare() {
    a=3
    b=2
    c=2

    [[ $a > $b ]] && log "$a is greater than $b"
    [[ $b > $c ]] || log "$b is smaller or equal than $c"
}


# Create empty file in multiple sub folders
function createEmptyFileInMultipleSubfolders() {
    find . -type d -path "./Targets/*/Config" -exec touch {}/Speisewagen-Shared.xcconfig \;  
}

# Rename a specific file in multiple sub folders
function renameSpecificFileInMultipleSubfolders() {
    # Load plugin in ZSH
    autoload zmv
    zmv -nW 'Targets/**/Config/*.xcconfig' 'Targets/**/Config/App-*.xcconfig'  
}

# Replace the same text in a specific file in multiple sub folders
function replaceTextInSameFileOfMultipleSubfolders() {
    sed -i '' 's/Shared.xcconfig/App-Shared.xcconfig/g' Targets/**/Config/App-Release.xcconfig
}

# Append text to specific files in multiple sub folders
function appendTextToSpecificFilesInMultipleSubfolders() {
    find . -type f -path "./Targets/*/Config/Speisewagen*.xcconfig" -not -path "./Targets/*/Config/Speisewagen-Shared.xcconfig" -exec sh -c 'echo "#include \"Speisewagen-Shared.xcconfig\"" >> {}' \;
}

function findScriptPathIfItIsExecutedViaSymlinkOrNot() {
    DIR=$(cd "$(dirname "$(readlink "$0" || echo "$0")")" && pwd)
    echo $DIR
}

## -----------------------------------------------

variables