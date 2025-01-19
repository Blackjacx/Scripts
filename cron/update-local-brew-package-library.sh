#!/usr/bin/env zsh

# Updates the local version of the Homebrew package library. For efficiently running `brewinfo`.
# Intended to be run as cron job. Simply run `crontab -e` and add the following line to
# schedule this script once every day at 8 am:
#
# `0 8 * * * /Users/stherold/dev/scripts/update-local-brew-package-library.sh`

brew info --json=v2 --eval-all >~/homebrew-packages.json
