#!/bin/bash

STATE_FILE="/tmp/waybar_stack_state"
MAX=5

[ ! -f "$STATE_FILE" ] && echo 0 > "$STATE_FILE"
STATE=$(cat "$STATE_FILE")

# ---- HANDLE SCROLL ----
if [ "$1" = "up" ]; then
    STATE=$(( (STATE + 1) % MAX ))
    echo "$STATE" > "$STATE_FILE"
elif [ "$1" = "down" ]; then
    STATE=$(( (STATE - 1 + MAX) % MAX ))
    echo "$STATE" > "$STATE_FILE"
fi

# ---- STATS ----
CPU=$(grep 'cpu ' /proc/stat | awk '{print int(($2+$4)*100/($2+$4+$5))}')
MEM=$(free | awk '/Mem:/ {print int($3/$2*100)}')
LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1 | xargs)
TEMP=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -n1)
[ -n "$TEMP" ] && TEMP=$((TEMP/1000))

# ---- UPTIME ----
UPTIME=$(awk '{print int($1)}' /proc/uptime)
DAYS=$((UPTIME/86400))
HOURS=$(( (UPTIME%86400)/3600 ))
MINS=$(( (UPTIME%3600)/60 ))

if [ "$DAYS" -gt 0 ]; then
    UPTIME_STR="${DAYS}d ${HOURS}h"
else
    UPTIME_STR="${HOURS}h ${MINS}m"
fi

# ---- OUTPUT ----
case "$STATE" in
    0)
        echo "[CPU $CPU%]"
        ;;
    1)
        echo "[MEM $MEM%]"
        ;;
    2)
        echo "[LOAD $LOAD]"
        ;;
    3)
        [ -n "$TEMP" ] && echo "[TEMP ${TEMP}°C]" || echo "[TEMP N/A]"
        ;;
    4)
        echo "[UP $UPTIME_STR]"
        ;;
esac