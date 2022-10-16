#!/usr/bin/env bash

set -e

case "$XDG_SESSION_DESKTOP" in
	sway)
		wmcmd=swaymsg
		;;
	i3)
		wmcmd=i3-msg
		;;
	*)
		echo "Unknown wm '$XDG_SESSION_DESKTOP'"
		exit 1
		;;
esac

emacs="1: emacs"
browsing="2: browsing"
comms="3: comms"
obs="8: obs"
game="9: game"
video="10: video"
misc="4 5 6 7"

randr_linux() {
	case "$XDG_SESSION_DESKTOP" in
		i3)
			@xrandrReset@
			;;
		*)
			# Do nothing
			;;
	esac
}

set_ws() {
	output="$1"
	shift
	for ws in "$@"; do
		$wmcmd "focus output $output" >/dev/null
		# The || true is a workaround for https://github.com/i3/i3/issues/4691
		$wmcmd "[workspace=\"$ws\"] move workspace to output $output" >/dev/null || true
	done
	$wmcmd "workspace $1" >/dev/null
}

focus() {
	$wmcmd "focus output $main" >/dev/null
}

set -x

case "$1" in
	code)
		#randr_linux
		set_ws @mainM@ "$emacs" "$obs" "$game" $misc
		set_ws @commsM@ "$comms"
		set_ws @videoM@ "$video"
		set_ws @secondaryM@ "$browsing"
		focus
		;;
	bug)
		#randr_linux
		set_ws @mainM@ "$browsing" "$obs" "$game" $misc
		set_ws @commsM@ "$comms"
		set_ws @videoM@ "$video"
		set_ws @secondaryM@ "$emacs"
		focus
		;;
	chat)
		$0 bug
		;;
	game)
		#randr_linux
		set_ws @mainM@ "$game"
		set_ws @commsM@ "$comms"
		set_ws @videoM@ "$video"
		set_ws @secondaryM@ "$browsing" "$emacs" "$obs" $misc
		focus
		;;
	stream)
		#randr_linux
		set_ws @mainM@ "$game"
		set_ws @commsM@ "$browsing" "$emacs" "$comms" $misc
		set_ws @videoM@ "$video"
		set_ws @secondaryM@ "$obs"
		focus
		;;
	_interactive)
		$0 _list | dmenu | xargs $0
		;;
	_list)
		egrep "	[a-z]+\)" $0 | tr -d ')	' | sort
		;;
esac
