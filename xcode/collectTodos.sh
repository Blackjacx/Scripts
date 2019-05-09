#!/bin/bash

# Treats spaces correctly in filenames
IFS=$'\n'

TODOS_FILE_PATH="./todos.txt"

echo "Writing TODOs to $TODOS_FILE_PATH"

grep -i -n -A 4 -w "TODO\|FIXME\|HACK\|TEMP\|BUG" \
  $( find "$SRCROOT" -name "*.h" -o -name "*.m" -o -name "*.swift" -exec echo "{}" \; ) \
  | sed "s/.*Classes//g" \
  | sed "s/.*Sources//g" \
  | sed "s/.*src//g" \
  > "$TODOS_FILE_PATH"