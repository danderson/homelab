#!/usr/bin/env bash

set -e

if [[ ! -f ~/.config/dave/layout_config.sh ]]; then
	echo "No display config, cannot do anything"
	exit 1
fi

. ~/.config/dave/layout_config.sh

emacs="1: emacs"
browsing="2: browsing"
comms="3: comms"
obs="8: obs"
game="9: game"
video="10: video"
misc="4 5 6 7"

randr_linux() {
	xrandr \
		--output $mid --primary --mode 2560x1440 --rate 75 --pos 2560x383 --rotate normal \
		--output $left --mode 2560x1440 --rate 75 --pos 0x383 --rotate normal \
		--output $rightup --mode 2560x1440 --rate 75 --pos 5120x0 --rotate normal \
		--output $rightdown --mode 2560x1440 --rate 75 --pos 5120x1440 --rotate normal
}

randr_linux_mac() {
	xrandr \
		--output $mid --primary --mode 2560x1440 --rate 75 --pos 2560x383 --rotate normal \
		--output $left --mode 2560x1440 --rate 75 --pos 0x383 --rotate normal \
		--output $rightup --mode 2560x1440 --rate 75 --pos 5120x0 --rotate normal \
		--output $rightdown --mode 2560x1440 --rate 75 --pos 5120x0 --rotate normal
}

set_ws() {
	output="$1"
	shift
	for ws in "$@"; do
		i3-msg "focus output $output" >/dev/null
		# The || true is a workaround for https://github.com/i3/i3/issues/4691
		i3-msg "[workspace=\"$ws\"] move workspace to output $output" >/dev/null || true
	done
	i3-msg "workspace $1" >/dev/null
}

focus() {
	i3-msg "focus output $mid" >/dev/null
}

set -x

case "$1" in
	code)
		randr_linux
		set_ws $mid "$emacs" "$obs" "$game" $misc
		set_ws $left "$comms"
		set_ws $rightup "$video"
		set_ws $rightdown "$browsing"
		focus
		;;
	bug)
		randr_linux
		set_ws $mid "$browsing" "$obs" "$game" $misc
		set_ws $left "$comms"
		set_ws $rightup "$video"
		set_ws $rightdown "$emacs"
		focus
		;;
	chat)
		$0 bug
		;;
	game)
		randr_linux
		set_ws $mid "$game"
		set_ws $left "$comms"
		set_ws $rightup "$video"
		set_ws $rightdown "$browsing" "$emacs" "$obs" $misc
		focus
		;;
	stream)
		randr_linux
		set_ws $mid "$game"
		set_ws $left "$browsing" "$emacs" "$comms" $misc
		set_ws $rightup "$video"
		set_ws $rightdown "$obs"
		focus
		;;
	_interactive)
		$0 _list | dmenu | xargs $0
		;;
	_list)
		egrep "	[a-z]+\)" $0 | tr -d ')	' | sort
		;;
esac
