#!/usr/bin/env zsh

# Backs up the zsh history file
# Can be sues as cron job. Simply run `crontab -e` and add the following line to
# schedule this script once every day at 8 am:
#
# `0 8 * * * /Users/stherold/dev/scripts/cron-bachup-zsh-history.sh`

cp ~/.zsh_history ~/docs/_backups/zsh-history/$(date +%FT%T)-zsh_history
