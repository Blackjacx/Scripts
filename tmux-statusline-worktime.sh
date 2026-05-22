# ~/bin/timew-today.sh
#!/usr/bin/env bash

# DEBUG: log each invocation
# echo "$(date '+%H:%M:%S') invoked" >> /tmp/timew-script.log

timew summary :day :ids :annotations 2>/dev/null | \
    awk '/^[[:space:]]+[0-9]+:[0-9]+:[0-9]+[[:space:]]*$/ {t=$1} END {print (t ? t : "n/a")}'