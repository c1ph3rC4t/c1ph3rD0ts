#!/usr/bin/env bash
##################################################
## Generate 02-monitors.lua for Hyprland        ##
## Picks the highest refresh rate per monitor   ##
##################################################

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.d"
OUTPUT="$CONFIG_DIR/02-monitors.lua"

mkdir -p "$CONFIG_DIR"

cat > "$OUTPUT" << 'HEADER'
--#################################################
--#  _   _                  _                 _  ##
--# | | | |_   _ _ __  _ __| | __ _ _ __   __| | ##
--# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | ##
--# |  _  | |_| | |_) | |  | | (_| | | | | (_| | ##
--# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| ##
--#        |___/|_|                              ##
--#################################################
--# Config from c1ph3rD0ts by c1ph3rC4t          ##
--#################################################

HEADER

hyprctl monitors -j | jq -r '.[] | .name as $name | .width as $w | .height as $h |
  .availableModes | map(select(startswith("\($w)x\($h)@"))) |
  map(split("@")[1] | rtrimstr("Hz") | tonumber) | max |
  "hl.monitor({ output = \"\($name)\", mode = \"\($w)x\($h)@\(.)\", position = \"auto\", scale = 1 })"' >> "$OUTPUT"

echo "Generated: $OUTPUT"
cat "$OUTPUT"

hyprctl reload
