#!/usr/bin/env bash

ram=0
mobo=1
mobo_limit=36

case $1 in
	magenta)
		mobo_color="FF00FF"
		ram_color="770077"
		;;
	darkmagenta)
		mobo_color="770077"
		ram_color="330033"
		;;
	off)
		mobo_color="000000"
		ram_color="000000"
		;;
	*)
		mobo_color="$1"
		ram_color="$2"
		;;
esac

mobo_colors=""
for i in `seq 9`; do
	mobo_colors="$mobo_colors,$mobo_color"
done
for i in `seq 120`; do
	mobo_colors="$mobo_colors,000000"
done
for i in `seq 1 $mobo_limit`; do
	case $i in
		1|2|7|8|9|34|35)
			mobo_colors="$mobo_colors,000000"
			;;
		*)
			mobo_colors="$mobo_colors,$mobo_color"
			;;
	esac
done

mobo_colors="${mobo_colors#,}"

openrgb -d "$mobo" -z 0 -c "$mobo_colors"
openrgb -d "$ram" -c "$ram_color"
