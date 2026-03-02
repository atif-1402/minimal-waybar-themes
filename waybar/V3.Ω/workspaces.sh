#!/bin/bash

# ---- HANDLE SCROLL ----
if [ "$1" = "up" ]; then
    hyprctl dispatch workspace e+1 >/dev/null 2>&1
    exit 0
elif [ "$1" = "down" ]; then
    hyprctl dispatch workspace e-1 >/dev/null 2>&1
    exit 0
fi

# ---- GET ACTIVE WORKSPACE ----
ACTIVE=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id')

[ -z "$ACTIVE" ] && exit 0

TEXT="[Workspace $ACTIVE]"
TOOLTIP="Active Workspace: $ACTIVE"

echo "{\"text\":\"$TEXT\"}"