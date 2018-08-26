#!/bin/bash

export GDK_SCALE=1.5
export SXHKD_SHELL='/usr/bin/sh'

xrandr --output eDP1 --mode 2560x1440 --scale 1.2x1.2 --dpi 209

Xcursor.theme: "Adwaita"
Xcursor.size: 48
Xft.dpi: 2000

feh --bg-fill $(find ~/.wallpapers -type f | shuf -n 1)

compton -b --config ~/.config/compton.conf

setxkbmap -layout us,gr -variant ,polytonic -option grp:caps_toggle -option compose:ralt

libinput-gestures &
sxhkd &
dropbox &

