#!/usr/bin/env zsh

# Backs up my timewarrior daily working time info from YESTERDAY so that I 
# have a chance to find  out what went wrong with balance report. 
#
# It should run one minute after midnight so it does not capture the time when 
# working past midnight.
# 
# The generated timestamp always prints the time from yesterday.

echo "$(timew balance ioki 2023-11-13 - today && timew summary :yesterday :ids)" > "~/docs/_backups/timewarrior/working-time/$(date -v-1d +%F-%A)"
