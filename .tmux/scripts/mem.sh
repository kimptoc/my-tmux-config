#!/usr/bin/env sh
awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf "%d%%",100*(t-a)/t}' /proc/meminfo
