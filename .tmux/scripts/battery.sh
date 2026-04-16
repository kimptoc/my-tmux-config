#!/usr/bin/env sh

if ls /sys/class/power_supply/BAT* >/dev/null 2>&1; then
  cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)
  if [ -n "$cap" ]; then
    printf '#[bold,fg=#ffffff,bg=#5f5f00] BAT %s%% #[default]\n' "$cap"
  fi
elif command -v pmset >/dev/null 2>&1; then
  cap=$(pmset -g batt 2>/dev/null | awk -F'; *' '/InternalBattery/ {gsub(/%/,"",$2); print $2; exit}')
  if [ -n "$cap" ]; then
    printf '#[bold,fg=#ffffff,bg=#5f5f00] BAT %s%% #[default]\n' "$cap"
  fi
fi
