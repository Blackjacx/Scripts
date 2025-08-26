#!/usr/bin/env zsh

# shellcheck shell=bash

#-------------------------------------------------------------------------------
# Security
#-------------------------------------------------------------------------------

# generate strong passphrase using bitwarden-cli (deprecated because slow)
# alias pwg="bw generate -p --capitalize --words 8 --includeNumber"
pwg() {
    printf '%s%s%s' \
        "$(shuf -i 0-9 -n 1)" \
        "$(xkcdpass --numwords 8 --delimiter '-' --case alternating)" \
        "$(shuf -i 0-9 -n 1)"
}

#-------------------------------------------------------------------------------
# Git
#-------------------------------------------------------------------------------

# List branches created by me
alias gbm='git branch -r | xargs -L1 git --no-pager show -s --oneline --author="$(git config user.name)"'
alias gb="git --no-pager branch"
# Prevent adding comments to git commit message file
# (removes --verbose). This triggers the git hook that prevents
# commmitting on failing  commit message lint. It also checks the
# comments whcih is wrong of course. Whenever the hook is fixed this
# can be removed again.
alias gc="git commit"
alias gcfu="git commit --fixup"
alias glogd="git --no-pager log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cI) %C(bold blue)<%an>%Creset' develop.."
alias glogm="git --no-pager log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cI) %C(bold blue)<%an>%Creset' main.."
# Re-define glog and diable pager
alias glog="git --no-pager log --oneline --decorate"
alias gst="git status -sb"
# Git add all and continue rebase
alias gac="git add . && git rebase --continue"
# New alias for setting back the current branch. It is faster than defining the function below.
alias greload='git fetch origin && git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)'
# TODO: DEPRECATED: Delete when alias above is working well.
# greload() {
#     local current_branch
#     current_branch="$(git branch --show-current)" && git switch develop && git branch -D "$current_branch" && git checkout "$current_branch" && git pull
# }
gupdate() {
    local branch="${1:-}"
    if [ -z "$branch" ]; then
        echo "🔴 Please specify a branch name."
        return
    elif ! git branch --list "$branch" | grep -q "$branch"; then
        echo "🔴 Branch \"$branch\" not found."
        return
    fi

    git fetch --all --prune --jobs=32
    git checkout "$branch"
    git pull
    git for-each-ref --format '%(refname) %(upstream:track)' refs/heads |
        awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}' |
        egrep -v '\*|master|main|develop' |
        xargs -I '{}' -n 1 git branch -D "{}"
}

# Checkout branch selected by browsing using fuzzy finder.
# - shown in a popup window when using tmux
gcof() {
    [[ ! -d ".git" ]] && return

    # IFS: split branches output at line break character
    # sed: replace everything up to and including last occurence of "origin/" by empty string
    # sed: delete lines starting with '*' (current branch)
    # awk: trim spaces
    IFS=$'\n' branches=($(git branch -a | sed 's/.*origin\///' | sed '/^*/d' | awk '{$1=$1};1' | sort -u | uniq))

    if [[ -z $TMUX ]]; then
        branch=$(printf '%s\n' "${branches[@]}" | fzf)
    else
        branch=$(printf '%s\n' "${branches[@]}" | fzf-tmux -p)
    fi
    git checkout "$branch"
}

# Show commit difference to parent branch
# - https://stackoverflow.com/a/42562318/971329
glogp() {
    git --no-pager log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=iso8601 $(git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//')..
}

# Create fixup commit for stashed changes (git commit fixup fzf)
gcfuf() {
    message="Please select a commit hash"
    glogd | fzf-tmux -p --header "$message" --info=inline | awk -F"[\*\-]" '{print $2}' | xargs -I {} git commit --fixup {}
}

# TODO: Find a shorter and more memorable alias
#
# Fixup directly into the selected git hash ([G]it [C]ommit [F]ix [U]p [F]zf [A]utoSquash)
gcfufas() {
    message="Please select a commit hash"
    hash=$(glogd | fzf-tmux -p90%,70% --header "$message" --info=inline | awk -F"[\*\-]" '{print $2}' | trim)
    if [[ -z $hash ]]; then
        echo "No git hash provided. Exit."
    else
        echo "Selected hash: \"$hash\""
        git commit --fixup "$hash"
        git rebase --autosquash "$hash"~1
    fi
}

#-------------------------------------------------------------------------------
# Developer
#-------------------------------------------------------------------------------

# Copy last select command from history and copy it to clipboard using fzf
alias cl="fc -ln 0 | awk '!a[\$0]++' | fzf --tac | pbcopy"
alias json="open http://jsonviewer.stack.hu"
alias regexp="open https://regex101.com/"
alias images="http://placehold.it/150x350"
alias sm="smerge ."
# Search hidden files and ignore some uninteresting folders - good for searching from home dir
alias ag="ag -i --hidden --skip-vcs-ignores --ignore-dir={\".tmp/*\",\"*Library*\",\"*.gem*\",\"*.build*\",\".git\",\"*bundle*\",\"*.zsh_history*\"}"
alias sz='source ${HOME}/.zshrc'
alias c="clear && tmux clear-history" # clear scrollback buffer and history

#-------------------------------------------------------------------------------
# GitHub
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# iOS Simulator Automation
#-------------------------------------------------------------------------------

sim-select() {
    local json=$(xcrun simctl list devices --json)

    local runtime=$(echo $json | jq '.devices | keys_unsorted | .[]' | fzf-tmux --header "Please select a runtime:" -p)
    if [ -z "$runtime" ]; then
        return
    fi

    local sim=$(echo $json | jq '.devices.'"$runtime"'.[].name' | fzf-tmux --header "Please select a simulator:" -p)
    if [ -z "$sim" ]; then
        return
    fi

    echo $json | jq -r '.devices.'"$runtime"'.[] | select(.name == '"$sim"').udid'
}

sim-boot() {
    xcrun simctl boot "$(sim-select)"
}

sim-set-lang() {
    xcrun simctl list -j "devices" |
        jq -r '.devices | map(.[])[].udid' |
        parallel 'xcrun simctl boot {}; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLanguages -array en_BZ; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLocale -string en_BZ; xcrun simctl shutdown {}'
}

# https://egeek.me/2021/06/12/how-to-save-and-restore-application-data-on-ios-simulator-quickly/
# https://medium.com/@liwp.stephen/find-app-data-path-for-ios-simulator-6bba3d2fbab6
# https://www.iosdev.recipes/simctl/#locate-an-app-bundle-app-data-or-app-group-data
sim-app-backup-or-restore() {
    trap "echo \"Cleaning up\" && unset BACKUP_DIR && unset APP_DATA_DIR" INT TERM HUP EXIT

    local COMMAND="${1:-}"
    if [[ "$COMMAND" != "backup" && "$COMMAND" != "restore" ]]; then
        echo "Please specify a sub command (backup || restore - is $COMMAND)!"
        return
    fi

    local BACKUP_DIR="${2:-}"
    if [ -z "$BACKUP_DIR" ]; then
        echo "Please specify a backup directory!"
        return
    elif [ ! -d "$BACKUP_DIR" ]; then
        echo "Backup directory $BACKUP_DIR not found!"
        return
    fi

    local SIM_ID="$(sim-select)"
    if [ -z "$SIM_ID" ]; then
        echo "SIM_ID was not determined!"
        return
    fi

    # Check if simulator is already booted
    local SIM_STATE="$(xcrun simctl list -j "devices" | jq -r '.devices | map(.[])[] | select(.udid == "'"$SIM_ID"'") | .state')"
    echo "Simulator state $SIM_STATE"

    local SIM_BOOTED=0
    if [[ "$SIM_STATE" == "Booted" ]]; then
        SIM_BOOTED=1
    elif [[ "$SIM_STATE" == "Shutdown" ]]; then
        echo "To be able to read the data dir, we boot simulator $SIM_ID now"
        xcrun simctl boot "$SIM_ID"
    else
        echo "Simulator state unhandled. Handle manually by either starting or closing it."
        return
    fi

    local APP_BUNDLE_ID="$(xcrun simctl listapps "$SIM_ID" | plutil -convert json - -o - | jq -r '.[].CFBundleIdentifier' | fzf-tmux --header "Please select an app to backup:" -p)"
    local APP_DATA_DIR="$(xcrun simctl get_app_container "$SIM_ID" "$APP_BUNDLE_ID" data)"
    echo "We received the data dir $APP_DATA_DIR"

    # Only shutdown when it was shutdown before
    if [[ "$SIM_BOOTED" == 0 ]]; then
        echo "Shutting down simulator $SIM_ID again"
        xcrun simctl shutdown "$SIM_ID"
    else
        echo "Keeping simulator $SIM_ID alive"
    fi

    if [ ! -d "$APP_DATA_DIR" ]; then
        echo "App data dir $APP_DATA_DIR not found"
        return
    fi

    # Encode simulator ID and bundle ID in backup path
    local BACKUP_DIR="$(echo $(realpath $BACKUP_DIR))/$SIM_ID/$APP_BUNDLE_ID"

    # Execute desired sub command
    if [[ "$COMMAND" == "backup" ]]; then

        # Clean BACKUP_DIR before backing up
        rm -rf "$BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        # -n: no prompt | -f: force | -r: recursive
        cp -nfr "$APP_DATA_DIR/" "$BACKUP_DIR"
        echo "Backup saved in $BACKUP_DIR"

    elif [[ "$COMMAND" == "restore" ]]; then

        # Make sure the new backup dir exists
        if [ ! -d "$BACKUP_DIR" ]; then
            echo "Backup directory $BACKUP_DIR not found!"
            return
        fi

        # Clean APP_DATA_DIR before backing up
        rm -rf "$APP_DATA_DIR"
        mkdir -p "$APP_DATA_DIR"
        # -n: no prompt | -f: force | -r: recursive
        cp -r "$BACKUP_DIR" "$APP_DATA_DIR/"
        echo "Backup restored to $APP_DATA_DIR"

    else

        echo "Unknown sub command \"$COMMAND\"."

    fi
}

sim-app-backup() {
    sim-app-backup-or-restore backup $1
}

sim-app-restore() {
    sim-app-backup-or-restore restore $1
}

#-------------------------------------------------------------------------------
# iCloud
#-------------------------------------------------------------------------------

# Kill iCloud - immediately starts syncing again
alias icloud-kill="killall cloudd"

#-------------------------------------------------------------------------------
# iOS | Xcode | Swift
#-------------------------------------------------------------------------------

alias swiftb='swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.15"'
alias sss='xcrun simctl io booted screenshot ${HOME}/Desktop/screenshots/`date +%Y-%m-%d.%H:%M:%S`.png'
# Not correct according to https://lapcatsoftware.com/articles/DerivedData.html
# alias ddd="rm -rf ${HOME}/Library/Developer/Xcode/DerivedData"
# Correct - including empty trash
# alias 'ddd=osascript -e "tell application \"Finder\" to move POSIX file \"${HOME}/Library/Developer/Xcode/DerivedData\" to trash" -e "tell application \"Finder\" to empty trash"'
#
# Semi-correct - without emptying trash
alias ddd='osascript -e "tell application \"Finder\" to move POSIX file \"${HOME}/Library/Developer/Xcode/DerivedData\" to trash"'

#-------------------------------------------------------------------------------
# Task Warrior • Scrum Daily
#-------------------------------------------------------------------------------

#alias twy="task scrum modified.after:now-1day"
#alias twf="task scrum modified.after:$(gdate --date="last friday" +%Y-%m-%d)"
#alias twt="task scrum modified:today"
#alias task-today="task scrum due.after:now due.before:tomorrow status:pending"

#-------------------------------------------------------------------------------
# Time Warrior
#-------------------------------------------------------------------------------

alias tw="timew"
alias twby="timew balance 2023-11-13 - today"   # balance from the beginning of all records (not including current day)
alias twb="timew balance 2023-11-13 - tomorrow" # balance from the beginning of all records (including today)
alias tws="timew summary :day :ids :annotations"
alias twsf="tw balance ioki 2023-11-13 - tomorrow && tws" # "tws full"
alias twsa="timew summary :all :ids :annotations"
alias twd="timew day summary :ids rc.reports.day.hours=auto"
alias tww="timew week summary :ids rc.reports.week.hours=auto"
alias twm="timew month summary :ids rc.reports.month.hours=auto"

#-------------------------------------------------------------------------------
# File System
#-------------------------------------------------------------------------------

alias df="df -h"

if command -v eza >/dev/null 2>&1; then
    alias la="eza --all --header --long --icons=always --color=always"
    alias tree="eza --tree"
else
    alias la="ls -lahF"
    alias tree="ls --tree"
fi

if command -v bat >/dev/null 2>&1; then
    alias cat="bat --paging=never"
elif command -v batcat >/dev/null 2>&1; then
    alias cat="batcat"
fi

#
# DEPRECATED
#
# Use zoxide instead:
# `cd b 1` - goes to beiwagen-1
# `cdi`    - launches fzf fuzzy finder with zoxide database sorted by rank
#
# alias cddb="cd ${HOME}/dev/projects/db/beiwagen-1"
# alias cddb2="cd ${HOME}/dev/projects/db/beiwagen-2"
# alias cddb3="cd ${HOME}/dev/projects/db/beiwagen-3"
# alias cdass="cd ${HOME}/dev/projects/private/Packages/Assist"
alias cdtemp='cd "$(mktemp -d)"'
alias o="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse --preview 'bat {}' | xargs nvim"
alias n="nvim"

# -----------------------------------------------
# Ruby Gems
# -----------------------------------------------
#
alias bu='bundle update'
alias bi='bundle install'
alias be='bundle exec'

# -----------------------------------------------
# Homebrew
# -----------------------------------------------

brewinfo() {
    # update homebrew-packages.json using `brew info --json=v2 --eval-all > ~/homebrew-packages.json`
    cat ~/homebrew-packages.json |
        jq -r '[.formulae.[].name, .casks.[].token].[]' |
        fzf --cycle --tmux --preview 'brew info {}' --color bg:#222222,preview-bg:#333333 --info=inline-right --ellipsis=… --tabstop=4 --highlight-line
}

#-------------------------------------------------------------------------------
# Temporary Fixes
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Remove alias rm -i to get rid of interactivity
#-------------------------------------------------------------------------------
# unalias rm
