#!/usr/bin/env sh

if [ -r /proc/stat ]; then
  cpu_line() {
    awk '/^cpu / {print $2+$3+$4+$5+$6+$7+$8, $5}' /proc/stat
  }

  set -- $(cpu_line)
  t1=$1
  i1=$2
  sleep 0.2
  set -- $(cpu_line)
  t2=$1
  i2=$2

  dt=$((t2 - t1))
  di=$((i2 - i1))

  if [ "$dt" -gt 0 ]; then
    printf '%s%%\n' "$((100 * (dt - di) / dt))"
  else
    printf 'N/A\n'
  fi
elif command -v top >/dev/null 2>&1; then
  top -l 1 2>/dev/null | awk -F'[:,% ]+' '/CPU usage/ {printf "%d%%\n", 100-$8; exit}'
else
  printf 'N/A\n'
fi
