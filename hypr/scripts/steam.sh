#!/bin/bash

hyprctl dispatch workspace name:steam &
if ! pgrep -x steam > /dev/null; then
    steam &
fi
