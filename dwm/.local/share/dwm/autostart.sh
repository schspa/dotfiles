#!/usr/bin/env sh

killall dwmblocks; dwmblocks &
killall /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
killall pa-applet; pa-applet &
xss-lock -- i3lock-fancy &
blueman-applet &
nm-applet &
syncthing -no-browser &
usr/lib/gsd-xsettings &
compton -b &
