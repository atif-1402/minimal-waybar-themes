#!/bin/bash

DIR="$HOME/.config/waybar"
STATE="$DIR/.mode"

BAR_CONFIG="$DIR/configs/bar.jsonc"
DOCK_CONFIG="$DIR/configs/dock.jsonc"

BAR_STYLE="$DIR/styles/bar.css"
DOCK_STYLE="$DIR/styles/dock.css"

ACTIVE_CONFIG="$DIR/config.jsonc"
ACTIVE_STYLE="$DIR/style.css"

# default state
[ ! -f "$STATE" ] && echo "bar" > "$STATE"

MODE=$(cat "$STATE")

if [ "$1" = "toggle" ]; then

    if [ "$MODE" = "bar" ]; then
        
        cp "$DOCK_CONFIG" "$ACTIVE_CONFIG"
        cp "$DOCK_STYLE" "$ACTIVE_STYLE"
        
        echo "dock" > "$STATE"

    else
        
        cp "$BAR_CONFIG" "$ACTIVE_CONFIG"
        cp "$BAR_STYLE" "$ACTIVE_STYLE"
        
        echo "bar" > "$STATE"

    fi

    killall -SIGUSR2 waybar
    exit
fi


if [ "$MODE" = "bar" ]; then
    echo '{"text":"Bar","tooltip":"Switch to dock style"}'
else
    echo '{"text":"Dock","tooltip":"Switch to bar style"}'
fi