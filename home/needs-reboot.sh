#!/usr/bin/env bash

current_drv=$(readlink -f /run/booted-system/kernel | cut -f4 -d/)
next_drv=$(readlink -f /run/current-system/kernel | cut -f4 -d/)

current_ver=$(echo "$current_drv" | cut -f3- -d-)
next_ver=$(echo "$next_drv" | cut -f3- -d-)

current_hash=$(echo "$current_drv" | cut -f1 -d-)
next_hash=$(echo "$next_drv" | cut -f1 -d-)

if [[ "$current_hash" != "$next_hash" ]]; then
	cat <<EOF
Reboot required!
  Current: $current_ver ($current_hash)
     Next: $next_ver ($next_hash)
EOF
	exit 1
fi
