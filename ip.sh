#!/bin/bash
#
# Display the internal and external IP.
#
if [ -z $1 ]; then
  echo Please add the network device connected to the internet as parameter!
  exit
fi

device=$1

echo "Internal: $(ifconfig -a | awk '$1=="inet" && $5=="broadcast"{print $2}')"
echo "External: $(curl -s ifconfig.me)"
