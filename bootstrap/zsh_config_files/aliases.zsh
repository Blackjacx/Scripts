#-------------------------------------------------------------------------------
# Security
#-------------------------------------------------------------------------------

# generate strong passphrase using bitwarden-cli
alias pwg="bw generate -p --capitalize --words 8 --includeNumber"

#-------------------------------------------------------------------------------
# Git
#-------------------------------------------------------------------------------

# List branches created by me
alias gbm="git branch -r | xargs -L1 git --no-pager show -s --oneline --author="$(git config user.name)""
alias gb="git --no-pager branch"
# Prevent adding comments to git commit message file 
# (removes --verbose). This triggers the git hook that prevents 
# commmitting on failing  commit message lint. It also checks the 
# comments whcih is wrong of course. Whenever the hook is fixed this 
# can be removed again.
alias gc="git commit"
alias gcfu="git commit --fixup"
alias glogd="git --no-pager log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=iso8601 develop.."
alias gst="git status -sb"

greload () {
  local current_branch=$(git branch --show-current) && git switch develop && git branch -D $current_branch && git checkout $current_branch && git pull
}

gupdate () {
  git fetch --all --prune --jobs=32
  git checkout develop
  git pull
  git for-each-ref --format '%(refname) %(upstream:track)' refs/heads |
      awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}' |
      egrep -v '\*|master|main|develop' |
      xargs -I '{}' -n 1 git branch -D "{}"
}

# Checkout branch selected by browsing using fuzzy finder.
# - shown in a popup window when using tmux
gcof () {
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

# Create fixup commit for stashed changes
gfu() {
  message="Please select a commit hash"
  glogd | fzf-tmux -p --header "$message" --info=inline | awk -F"[\*\-]" '{print $2}' | xargs -I {} git commit --fixup {}
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
alias ag="ag --hidden --skip-vcs-ignores --ignore=\"*Library*\" --ignore=\"*.gem*\" --ignore=\"*.build*\" --ignore=\"*.git*\" --ignore=\"*bundle*\" --ignore=\"*.zsh_history*\""
alias sz="source ${HOME}/.zshrc"

#-------------------------------------------------------------------------------
# iOS Simulator Automation
#-------------------------------------------------------------------------------

sim-select() {
  json=$(xcrun simctl list devices --json)
  runtime=$(echo $json | jq '.devices | keys_unsorted | .[]' | fzf-tmux -p)
  sim=$(echo $json | jq '.devices.'"$runtime"'.[].name' | fzf-tmux -p)
  udid=$(echo $json | jq -r '.devices.'"$runtime"'.[] | select(.name == '"$sim"').udid')
  echo "$udid"
}

sim-boot() {
  xcrun simctl boot "$(sim-select)"
}

sim-set-lang() {
  xcrun simctl list -j "devices" | 
    jq -r '.devices | map(.[])[].udid' | 
    parallel 'xcrun simctl boot {}; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLanguages -array en_BZ; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLocale -string en_BZ; xcrun simctl shutdown {}'
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

alias twby="timew balance 2023-11-13 - today" # balance from the beginning of all records (not including current day)
alias twb="timew balance 2023-11-13 - tomorrow" # balance from the beginning of all records (including today)
alias tws="timew summary :day :ids"
alias twsa="timew summary :all :ids"
alias twd="timew day summary :ids rc.reports.day.hours=auto"
alias tww="timew week summary :ids rc.reports.week.hours=auto"
alias twm="timew month summary :ids rc.reports.month.hours=auto"

#-------------------------------------------------------------------------------
# File System
#-------------------------------------------------------------------------------
alias df="df -h"

if command -v exa >/dev/null 2>&1; then
  alias la="exa -laFh"
  alias tree="exa --tree"
else 
  alias la="ls -laFh"
  alias tree="ls --tree"
fi

if command -v bat > /dev/null 2>&1; then
  alias cat="bat --paging=never"
elif command -v batcat > /dev/null 2>&1; then
  alias cat="batcat"
fi
alias cddb="cd ${HOME}/dev/projects/db/beiwagen-1"
alias cddb2="cd ${HOME}/dev/projects/db/beiwagen-2"
alias cdass="cd ${HOME}/dev/projects/private/Packages/Assist"
alias cdtemp='cd "$(mktemp -d)"'
alias o="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs subl"
brewinfo () { brew info $(brew list | fzf --reverse) }

#-------------------------------------------------------------------------------
# CleanUp
#-------------------------------------------------------------------------------
alias kill_ca="sudo kill -9 `ps ax|grep 'coreaudio[a-z]' | awk '{print $1}'`"

#-------------------------------------------------------------------------------
# Remove alias rm -i to get rid of interactivity
#-------------------------------------------------------------------------------
# unalias rm