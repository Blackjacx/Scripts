#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# This script takes the first argument and writes 
# it to a personal to-list file in markdown format

echo "$1"