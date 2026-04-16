#!/usr/bin/env sh

if [ -r /proc/meminfo ]; then
  awk '
    /MemTotal/ {t=$2}
    /MemAvailable/ {a=$2}
    END {
      if (t > 0) printf "%d%%\n", 100*(t-a)/t
      else print "N/A"
    }
  ' /proc/meminfo
else
  printf 'N/A\n'
fi
