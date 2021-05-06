#!/usr/bin/env zsh
# -*- mode: shell-script -*-

set -euo pipefail

root="/var/lib/tailscale"

function list() {
	local cur="__none"
	if [[ -f "$root/_current" ]]; then
		read -r cur <$root/_current
	fi
	out=$(ls -1 ${root}/tailscaled.state.* | cut -f3 -d. | sort | sed -e "s/^\($cur\)$/%B%F{yellow}\\1%f%b/")
	print -lP "$out"
}

function switch() {
	profile="$1"

	if [[ ! -f "$root/tailscaled.state.$profile" ]]; then
		echo "Profile \"$profile\" doesn't exist" >&2
		exit 1
	fi

	systemctl stop tailscaled

	# If a profile is currently active, save it.
	if [[ -f "$root/_current" ]]; then
		read -r cur <"$root/_current"
		mv -f "$root/tailscaled.state" "$root/tailscaled.state.$cur"
		rm "$root/_current"
	elif [[ -f "$root/tailscaled.state" ]]; then
		# Safety: refuse to overwrite a tailscaled.state without a profile
		echo "Refusing to overwrite tailscaled.state. Name the profile in _current please." >&2
		exit 1
	fi

	# Activate the new profile
	cp -f "$root/tailscaled.state.$profile" "$root/tailscaled.state"
	echo "$profile" >"$root/_current"

	systemctl start tailscaled
}

function init() {
}

if [[ "$(id -u)" != 0 ]]; then
	echo "Need to be root" >&2
	exit 1
fi

profile="${1:-}"

if [[ -z "$profile" ]]; then
	list
elif [[ "$profile" == "init" ]]; then
	
else
	switch "$profile"
fi
