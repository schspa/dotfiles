#!/usr/bin/env sh

killall dwmstatus 2>/dev/null; dwmstatus &
killall /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 2>/dev/null
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
killall pa-applet 2>/dev/null; pa-applet &
xss-lock -- i3lock-fancy &
blueman-applet &
nm-applet &
syncthing -no-browser &
/usr/lib/gsd-xsettings &
compton -b &
killall fcitx5 2>/dev/null; fcitx5 &
##
