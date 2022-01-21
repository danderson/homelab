#!/usr/bin/env bash

set -e

mid="DisplayPort-0"
left="DisplayPort-1"
rightdown="DisplayPort-2"
rightup="HDMI-A-0"

emacs="1: emacs"
browsing="2: browsing"
comms="3: comms"
obs="8: obs"
game="9: game"
video="10: video"
misc="4 5 6 7"

sn_rightup="6CM10500YX"
sn_rightdown="6CM1050103"
sn_mid="6CM105011L"
sn_left="6CM1050105"

input_dvi="x03"
input_displayport="x0f"
input_displayport2="x13"
input_hdmi="x11"

# set_basic_settings() {
# 	for sn in $sn_rightup $sn_rightdown $sn_mid $sn_left; do
# 		ddcutil -n $sn setvcp xCC x02 # English
# 		ddcutil -n $sn setvcp xD6 x1 # DPM=on, DPMS=off
# 		ddcutil -n $sn setvcp xDC x07 # Display mode = Professional (all signal processing off)
# 		ddcutil -n $sn setvcp x14 x04 # 5000K color temp
# 		ddcutil -n $sn setvcp x12 70 # Contrast=70
# 		ddcutil -n $sn setvcp x10 35 # Brightness=35
# 	done
# }

# set_input() {
# 	ddcutil -n "$1" setvcp x60 "$2"
# }

# inputs_linux() {
# 	set_input $sn_mid $input_displayport
# 	set_input $sn_rightdown $input_displayport
# 	set_input $sn_left $input_displayport
# 	set_input $sn_rightup $input_hdmi
# }

randr_linux() {
	xrandr \
		--output $mid --primary --mode 2560x1440 --rate 75 --pos 2560x383 --rotate normal \
		--output $left --mode 2560x1440 --rate 75 --pos 0x383 --rotate normal \
		--output $rightup --mode 2560x1440 --rate 75 --pos 5120x0 --rotate normal \
		--output $rightdown --mode 2560x1440 --rate 75 --pos 5120x1440 --rotate normal
}

# inputs_linux_mac() {
# 	set_input $sn_mid $input_displayport
# 	set_input $sn_rightdown $input_hdmi
# 	set_input $sn_left $input_displayport
# 	set_input $sn_rightup $input_hdmi
# }

randr_linux_mac() {
	xrandr \
		--output $mid --primary --mode 2560x1440 --rate 75 --pos 2560x383 --rotate normal \
		--output $left --mode 2560x1440 --rate 75 --pos 0x383 --rotate normal \
		--output $rightup --mode 2560x1440 --rate 75 --pos 5120x0 --rotate normal \
		--output $rightdown --mode 2560x1440 --rate 75 --pos 5120x0 --rotate normal
}

# inputs_linux_corp() {
# 	set_input $sn_mid $input_hdmi
# 	set_input $sn_rightdown $input_displayport
# 	set_input $sn_left $input_displayport
# 	set_input $sn_rightup $input_displayport
# }

randr_linux_corp() {
	xrandr \
		--output $mid --mode 2560x1440 --rate 75 --pos 0x383 --rotate normal \
		--output $left --primary --mode 2560x1440 --rate 75 --pos 0x383 --rotate normal \
		--output $rightup --mode 2560x1440 --rate 75 --pos 2560x0 --rotate normal \
		--output $rightdown --mode 2560x1440 --rate 75 --pos 2560x0 --rotate normal
}

# brightness_sun() {
# 	for sn in $sn_rightup $sn_rightdown $sn_mid $sn_left; do
# 		ddcutil -n $sn setvcp x10 100 # Brightness=90
# 		ddcutil -n $sn setvcp x12 100 # Contrast=70
# 	done
# }

# brightness_dark() {
# 	for sn in $sn_rightup $sn_rightdown $sn_mid $sn_left; do
# 		ddcutil -n $sn setvcp x10 35 # Brightness=35
# 		ddcutil -n $sn setvcp x12 70 # Contrast=70
# 	done
# }

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
	# mac)
	# 	randr_linux_mac
	# 	inputs_linux_mac
	# 	set_ws $mid "$emacs" "$game" $misc
	# 	set_ws $left "$comms"
	# 	set_ws $rightup "$browsing" "$video" "$obs"
	# 	focus
	# 	;;
	# linux)
	# 	inputs_linux
	# 	$0 code
	# 	;;
	# corp)
	# 	inputs_linux_corp
	# 	;;
	# reset)
	# 	set_basic_settings
	# 	$0 linux
	# 	;;
	# sun)
	# 	brightness_sun
	# 	;;
	# dark)
	# 	brightness_dark
	# 	;;
	_interactive)
		$0 _list | dmenu | xargs $0
		;;
	_list)
		egrep "	[a-z]+\)" $0 | tr -d ')	' | sort
		;;
esac
