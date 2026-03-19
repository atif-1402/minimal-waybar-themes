#!/bin/bash

if pgrep -f "bottom/config" > /dev/null; then
    pkill -f "bottom/config"
else
    waybar -c ~/.config/waybar/bottom/config &
fi