#!/usr/bin/env sh
iface=$(ip route | awk '/default/ {print $5; exit}')
awk -F'[: ]+' -v i="$iface" '$1==i {print "RX:" $3 " TX:" $11}' /proc/net/dev
