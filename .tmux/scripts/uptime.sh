#!/usr/bin/env sh

if [ -r /proc/uptime ]; then
  s=$(awk '{printf "%d", $1}' /proc/uptime)
  d=$((s / 86400))
  h=$(((s % 86400) / 3600))
  m=$(((s % 3600) / 60))

  if [ "$d" -gt 0 ]; then
    printf '%sd%sh\n' "$d" "$h"
  elif [ "$h" -gt 0 ]; then
    printf '%sh%sm\n' "$h" "$m"
  else
    printf '%sm\n' "$m"
  fi
else
  uptime | sed 's/.*up *//; s/,.*//; s/ *$//'
fi
