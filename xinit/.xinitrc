#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
userprofile=$HOME/.xprofile
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$userprofile" ]; then
	xrdb -merge "$userprofile"
fi

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

export XDG_DATA_HOME = $HOME/.local/share

xrandr --output eDP-1 --mode 2560x1440 --scale 1x1 --dpi 209

compton -b

setxkbmap -layout us,gr -variant ,polytonic -option grp:caps_toggle -option compose:ralt
xsetroot -cursor_name left_ptr

sxhkd &
libinput-gestures-setup start
dropbox &
dunst &

exec bspwm 
