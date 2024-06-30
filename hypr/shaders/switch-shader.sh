#!/usr/bin/env bash

set -e

cfg=~/.config/hypr/shaders

blank="blank.glsl"
alt="temperature.glsl"

current="$(hyprctl getoption decoration:screen_shader -j | gojq -r '.str')"

if [[ "$current" =~ (blank|EMPTY) ]] || [[ "$current" == "" ]]; then
    hyprctl keyword decoration:screen_shader "$cfg/$alt"
    echo set $alt
else
    hyprctl keyword decoration:screen_shader "$cfg/$blank"
    echo set $blank
fi
