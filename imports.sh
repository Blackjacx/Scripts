#!/usr/bin/env zsh

## Define colors
red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
white=$'\e[0m'

# ====================================================================================================================
# Utility Functions
# ====================================================================================================================

function trim () {
  awk '{$1=$1};1'
}

function is_integer() {
    local string=$1
    if [[ $string =~ ^-?[0-9]+$ ]]; then
        return 0  # True
    else
        return 1  # False
    fi
}

# https://stackoverflow.com/a/17841619/971329
function join_by { 
  local IFS="$1"; shift; echo "$*"; 
}

# ====================================================================================================================
# Logging Functions
# ====================================================================================================================

function log () {
  echo "✅ [$(date +'%H:%M:%S')] $1"
}

function log_warning () {
  echo "⚠️ [$(date +'%H:%M:%S')] $1"
}

function log_error () {
  echo >&2 "🚨 [$(date +'%H:%M:%S')] $1"
}

function loadEnvironment () {
  # Ignores commented lines
  ENV_FILE="$(dirname "$0")/../.env"
  if [ -f "$ENV_FILE" ]; then
    export "$(grep -v '^#' "$ENV_FILE" | xargs)"
  fi
}

function checkInstalledJq () {
  command -v jq >/dev/null 2>&1 || { 
    echo >&2 "jq missing - Install using \"brew install jq\"."; exit 1; 
  }
}

function checkInstalledLocalise () {
  command -v lokalise >/dev/null 2>&1 || { 
    echo >&2 "lokalise missing - Install using \"brew tap lokalise/brew; brew install lokalise\"."; exit 1;
  }
}

function checkInstalledImageMagick () {
  command -v convert >/dev/null 2>&1 || { 
    echo >&2 "imagemagick missing - Install using \"brew install imagemagick\"."; exit 1;
  }
}

function mdsee() { 
    HTMLFILE="$(mktemp -u).html"
    jq --slurp --raw-input '{"text": "\(.)", "mode": "markdown"}' "$1" | \
      curl -s --data @- https://api.github.com/markdown > "$HTMLFILE"
    echo "$HTMLFILE"
    open "$HTMLFILE"
}

# ====================================================================================================================
# Use advanced FZF if in tmux environment
# ====================================================================================================================

# Add this to your ~/.zshrc or ~/.bashrc file
function fzf_command {
    # Check if the $TMUX environment variable is set and not empty
    # ${TMUX:-} gives a default empty string if unset — so it won’t crash when using `set -u`.
    # -n tests for non-empty
    if [ -n "${TMUX:-}" ]; then
        # We are in tmux, so run fzf-tmux
        fzf-tmux -p90%,70% "$@"
    else
        # We are not in tmux, so run fzf normally
        fzf "$@"
    fi
}

# ====================================================================================================================
# Working with GIT
# ====================================================================================================================

# Create and commit changelog item
function cci() {
  if [[ -z $1 ]]; then
    log_error "Please provide a changelog title / issue number combination in the format <title #number>."
    return
  fi

  title=$(echo $1 | sed 's/ #[0-9]*$//')
  number=$(echo $1 | sed 's/.*#//')
  account=$(git config github.user)

  if ! is_integer "$number"; then
    log_error "The PR number '$number' is not a valid integer."
    return
  fi

  if [[ -z $account ]]; then
    log_error "Please specify your GitHub username either globally using$green git config --global github.user \"<username>\"$white or locally for only the current checkout using$green git config --local github.user \"<username>\"$white."
    return
  fi

  while true; do
    printf 'Is the account name "%s" correct? [Y/n]: ' "$green$account$white"
    read yn
    case $yn in
      [Nn]* ) 
              log_error "Please add your GitHub username to the local config using the following account and run the command again:$green git config --local github.user \<username\>"
              return;;

          * ) 
              break;; # continue with suggested account
    esac
  done

  entry="* [#$number](https://github.com/dbdrive/beiwagen/pull/$number): $title - [@$account](https://github.com/$account)."

  while true; do
    printf 'Do you want to commit the change log entry:%s? [Y/n]: ' "$green $entry $white"
    read yn
    case $yn in
      [Nn]* ) 
              break;; # cancel process

          * ) 
              echo "$entry" > "changelog/$number.md"
              git add "changelog/$number.md"
              git commit -m "chore: add changelog item"
              git push
              break;;
    esac
  done
}

# Git commit extended
#
# This script is used to write a conventional commit message.
# It prompts the user to choose the type of commit as specified in the
# conventional commit spec. And then prompts for the summary and detailed
# description of the message and uses the values provided. as the summary and
# details of the message.
# function gce() {
#     # If you want to add a simpler version of this script to your dotfiles, use:
#     #
#     # alias gcm='git commit -m "$(gum input)" -m "$(gum write)"'
    
#     TYPE="$(gum choose "build" "ci" "fix" "feat" "docs" "style" "refactor" "perf" "test" "chore" "revert")"
#     SCOPE="$(gum input --placeholder "scope")"
    
#     # Since the scope is optional, wrap it in parentheses if it has a value.
#     test -n "$SCOPE" && SCOPE="($SCOPE)"

#     # Pre-populate the input with the type(scope): so that the user may change it
#     SUMARY="$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")"
#     BODY=$(gum write --placeholder "Details of this change")
    
#     # Commit these changes if user confirms
#     gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$BODY"
# }
function gce() {
        local type scope summary body prefix
        local -a commit_args
 
        type="$(
                gum choose \
                        "build" "ci" "fix" "feat" "docs" "style" \
                        "refactor" "perf" "test" "chore" "revert"
        )" || return 130
 
        scope="$(gum input --placeholder "scope (optional)")" || return 130
        [[ -n "$scope" ]] && scope="($scope)"
 
        prefix="$type$scope: "
        summary="$(
                gum input \
                        --value "$prefix" \
                        --placeholder "Summary of this change"
        )" || return 130
 
        [[ -z "${summary//[[:space:]]/}" ]] && {
                echo "Summary must not be empty."
                return 1
        }
 
        body="$(gum write --placeholder "Commit body (optional)")" || return 130
 
        echo
        echo "Commit message preview:"
        echo "$summary"
        [[ -n "${body//[[:space:]]/}" ]] && printf '\n%s\n' "$body"
        echo
 
        gum confirm "Commit changes?" || return 1
 
        commit_args=(
                -m "$summary"
        )
 
        [[ -n "${body//[[:space:]]/}" ]] && commit_args+=(
                -m "$body"
        )
 
        git commit "${commit_args[@]}"
 }

# ====================================================================================================================
# App Store Connect
# ====================================================================================================================

# Easily create ASC auth header
function asc_auth_header() {
  echo "Bearer $(ruby ~/dev/scripts/jwt.rb "$ASC_AUTH_KEY" "$ASC_AUTH_KEY_ID" "$ASC_AUTH_KEY_ISSUER_ID")"
}

# ====================================================================================================================
# Image Processing
# ====================================================================================================================

function collage() {
  cd "$(mktemp -d)"
  
  # Array to store processed image arguments for montage
  montage_args=()
  
  # Round corners of each input image
  for IMAGE in "${@[@]}"
  do
    BASENAME="$(basename "$IMAGE")"
    read -r width height <<< $(magick -ping "$IMAGE" -format "%w %h" info:)
    
    magick \
      -size ${width}x${height} xc:none \
      -fill white \
      -draw "roundRectangle 0,0 ${width},${height} 50,50" "$IMAGE" \
      -compose SrcIn \
      -composite "$BASENAME"
    
    # Add to montage args with label
    montage_args+=( \( "$BASENAME" -set label "$BASENAME" \) )
  done
  
  # Make the collage with captions
  montage "${montage_args[@]}" \
    -font Courier \
    -pointsize 36 \
    -fill black \
    -background none \
    -gravity South \
    -shadow \
    -geometry '+25+25' \
    '01_collage.heic'
  
  # Make gradient background
  read -r width height <<< $(magick -ping '01_collage.heic' -format "%w %h" info:)
  magick -size ${width}x${height} radial-gradient:#fffffe-lightgray '02_gradient.heic'
  
  # Put collage on gradient background
  composite -gravity center '01_collage.heic' '02_gradient.heic' '03_collage_gradient.heic'
  
  # Round corners of final image
  magick \
    -size ${width}x${height} xc:none \
    -fill white \
    -draw "roundRectangle 0,0 ${width},${height} 50,50" '03_collage_gradient.heic' \
    -compose SrcIn \
    -composite '04_final.heic'
    
  echo "Find your files in \"$(pwd)\""
  cd -
}
