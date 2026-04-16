#!/usr/bin/env sh
awk '/^cpu / {print int(100*(1-$5/($2+$3+$4+$5+$6+$7+$8))) "%"}' /proc/stat
