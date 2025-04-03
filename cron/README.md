This folder contains scripts that are intenden to be implemented as cron jobs. Most of them run at night, e.g. at 4am. They even run when the MacBook lid is closed. But I think it has to be connected to power.

View the logs by simply typing `mail` in your console. Cron sends a mail to localhost whenever the task is finished containing all the output.

The current list of cronjobs looks as below (`contab -l`). Check the different scripts for an explanation of what they're doing:

```shell
SHELL=/bin/zsh
PATH=/opt/homebrew/sbin:/opt/homebrew/bin:/usr/bin:/usr/sbin:/bin:/sbin:${PATH}"

# “At 04:00 every day”
0 4 * * * /Users/stherold/dev/scripts/cron/backup-zsh-history.sh
# “At 00:01 on every day-of-week from Tuesday through Saturday.”
1 0 * * 2-6 /Users/stherold/dev/scripts/cron/backup-timewarrior-daily.sh
0 4 * * * /Users/stherold/dev/scripts/cron/update-local-brew-package-library.sh
0 4 * * * /Users/stherold/dev/scripts/cron/delete-teams-folder.zsh
# * * * * * /opt/homebrew/bin/direnv exec . /Users/stherold/dev/scripts/cron/cronjobs.sh
```
