#!/usr/bin/env bash

is_float=$(yabai -m query --spaces | jq -re ".[] | select(.focused == 1 and .type == \"float\").index")

# Detects if iTerm2 is running

if [[ $is_float == "" ]]; then
    if [[ $1 == "west" ]]; then
        yabai -m window --focus west || yabai -m display --focus west || yabai -m window --focus east
    elif [[ $1 == "south" ]]; then
        yabai -m window --focus south || yabai -m display --focus south || yabai -m window --focus north
    elif [[ $1 == "north" ]]; then
        yabai -m window --focus north || yabai -m display --focus north || yabai -m window --focus south
    elif [[ $1 == "east" ]]; then
        yabai -m window --focus east || yabai -m display --focus east || yabai -m window --focus west
    fi
else
    echo $is_float | xargs -I{} yabai -m query --windows --space {} \
        | jq -sre "add | sort_by(.display, .frame.x, .frame.y, .id) | reverse | nth(index(map(select(.focused == 1))) - 1).id" \
        | xargs -I{} yabai -m window --focus {}
fi
