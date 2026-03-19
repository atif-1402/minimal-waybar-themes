#!/usr/bin/env bash

FILE="$HOME/.config/omarchy/current/theme.name"

if [ -f "$FILE" ]; then
    THEME=$(cat "$FILE")
else
    THEME="unknown"
fi

echo "{\"text\":\"[theme = $THEME]\"}"