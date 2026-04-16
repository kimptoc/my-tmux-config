#!/usr/bin/env sh

if [ -r /proc/loadavg ]; then
  awk '{printf "%s %s %s\n", $1, $2, $3}' /proc/loadavg
else
  uptime | sed 's/.*average[s]*: *//; s/ */, /g'
fi
