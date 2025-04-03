#!/usr/bin/env zsh

#
# Special script that is used for debugging and demonstration purposes only.
#
# The crontab entry must look like below to execute the script at midnight
# every day and properly load the .envrc file so we have access to the loaded
# environment in the script:
#
# * * * * * /opt/homebrew/bin/direnv exec . /Users/stherold/dev/scripts/cron/cronjobs.sh
#
# View the logs by simply typing `mail` in your console. Cron sends a mail to
# localhost whenever the task is finished containing all the output.

printf "User: %s\n" "$(whoami)"
printf "PWD: %s\n" "$(pwd)"
printf "Shell: %s\n" "$SHELL"
printf "Direnv status:\n %s\n" "$(/opt/homebrew/bin/direnv status)"

osascript -e "display notification \"This is a value from the .envrc file: ASC_AUTH_KEY_ID=$ASC_AUTH_KEY_ID\" with title \"Cron\" subtitle \".envrc test\" sound name \"Submarine\""

#
# Test sending a slack message
##################################################

# echo "🟢 [$(date)] Post download link to slack"
# SLACK_URL="https://slack.com/api/chat.postMessage"

# IFS='' read -r -d '' PAYLOAD <<EOF
# {
#   "channel": "${SLACK_SCREENSHOTS_CHANNEL}",
#   "username": "iOS Team",
#   "text": "Cronjob - Slack integration from iOS team server still working 👍"
# }
# EOF
# curl -v \
#   -H "Authorization: Bearer ${SLACK_API_TOKEN}" \
#   -H "Content-type: application/json" \
#   --data "${PAYLOAD}" "${SLACK_URL}"

#
# Check SSH Access
##################################################

# echo "🟢 [$(date)] Checking SSH Github Login"
# ssh -T -i ~/.ssh/id_ioki_ed25519 git@github.com

#
# Test Cloning a repo
#
# Turns out it works when specifying the following in .envrc:
# export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ioki_ed25519"
##################################################

# echo "🟢 [$(date)] Checking Github Clone via SSH"
# git clone git@github.com:Blackjacx/WWDC.git TMP_wwdc_clone_by_cron
# ls -la TMP_wwdc_clone_by_cron
# rm -rf TMP_wwdc_clone_by_cron
