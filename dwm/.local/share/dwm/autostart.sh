#!/usr/bin/env sh

killall dwmblocks; dwmblocks &
killall /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
killall volumeicon; volumeicon &
blueman-applet &
nm-applet &
