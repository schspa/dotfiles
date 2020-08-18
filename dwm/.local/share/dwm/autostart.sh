#!/usr/bin/env sh

killall dwmblocks; dwmblocks &
killall /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
blueman-applet &
nm-applet &
