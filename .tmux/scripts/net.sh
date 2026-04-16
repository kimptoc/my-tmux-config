#!/usr/bin/env sh

state_file="/tmp/.tmux_net_anchor"

pick_iface() {
  ip route 2>/dev/null | awk '/^default/ {print $5; exit}'
}

human_rate() {
  bps=$1
  if [ "$bps" -ge 1073741824 ]; then
    awk -v v="$bps" 'BEGIN {printf "%.1fG", v/1073741824}'
  elif [ "$bps" -ge 1048576 ]; then
    awk -v v="$bps" 'BEGIN {printf "%.1fM", v/1048576}'
  elif [ "$bps" -ge 1024 ]; then
    awk -v v="$bps" 'BEGIN {printf "%.0fK", v/1024}'
  else
    printf '%dB' "$bps"
  fi
}

if [ ! -r /proc/net/dev ]; then
  printf 'N/A\n'
  exit 0
fi

iface=$(pick_iface)

if [ -n "$iface" ]; then
  set -- $(awk -F'[: ]+' -v ifc="$iface" '$1==ifc {print $3, $11}' /proc/net/dev)
else
  set -- $(awk -F'[: ]+' '
    NR>2 && $1 !~ /^(lo|docker[0-9]*|br-|veth|virbr|tailscale|tun|tap|zt)/ {
      rx += $3
      tx += $11
    }
    END {print rx, tx}
  ' /proc/net/dev)
fi

rx=$1
tx=$2
now=$(date +%s)

if [ -z "$rx" ] || [ -z "$tx" ]; then
  printf 'N/A\n'
  exit 0
fi

if [ -r "$state_file" ]; then
  read -r old_rx old_tx old_ts < "$state_file"
  dt=$((now - old_ts))

  if [ "$dt" -ge 180 ]; then
    printf '%s %s %s\n' "$rx" "$tx" "$now" > "$state_file"
    printf '...\n'
    exit 0
  fi

  if [ "$dt" -gt 0 ]; then
    down_bps=$(((rx - old_rx) / dt))
    up_bps=$(((tx - old_tx) / dt))

    [ "$down_bps" -lt 0 ] && down_bps=0
    [ "$up_bps" -lt 0 ] && up_bps=0

    printf '▼%s ▲%s\n' "$(human_rate "$down_bps")" "$(human_rate "$up_bps")"
  else
    printf '...\n'
  fi
else
  printf '...\n'
fi

printf '%s %s %s\n' "$rx" "$tx" "$now" > "$state_file"
