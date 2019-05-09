#!/bin/bash

cd /usr/local/MacMemoryReader/

rm -rf ~/memory.img
sudo ./MacMemoryReader -d -H SHA-256 ~/memory.img

rm -rf ~/memory-found-tokens.txt
strings - ~/memory.img | grep -A 4 -i $1 > ~/memory-found-tokens.txt

cd -
