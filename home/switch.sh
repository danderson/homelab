#!/usr/bin/env bash

tgt="$1"
if [[ -z "$tgt" ]]; then
    case "$(hostname)" in
        vega)
            tgt="rigel"
            ;;
        rigel)
            tgt="vega"
            ;;
        *)
            echo "Don't know how to switch away from $tgt"
            exit 1
            ;;
    esac
fi

case "$tgt" in
  vega)
    @ddcutil@ --sn 6CM1050103 setvcp 0x60 0x0f
    @ddcutil@ --sn 6CM105011L setvcp 0x60 0x0f
    @ddcutil@ --sn 6CM10500YX setvcp 0x60 0x11
    @ddcutil@ --sn 6CM1050105 setvcp 0x60 0x0f
  ;;
  rigel)
    @ddcutil@ --sn 6CM1050103 setvcp 0x60 0x11
    @ddcutil@ --sn 6CM105011L setvcp 0x60 0x11
    @ddcutil@ --sn 6CM10500YX setvcp 0x60 0x0f
    @ddcutil@ --sn 6CM1050105 setvcp 0x60 0x11
  ;;
esac
