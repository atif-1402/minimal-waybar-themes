#!/usr/bin/env bash

STATE="/tmp/waybar_sysbar"
[ ! -f "$STATE" ] && echo "cpu" > "$STATE"

mode=$(cat "$STATE")

# Scroll handling
if [ "$1" = "up" ]; then

case $mode in
cpu) echo "mem" > "$STATE" ;;
mem) echo "swap" > "$STATE" ;;
swap) echo "cpu" > "$STATE" ;;
esac

mode=$(cat "$STATE")

fi

if [ "$1" = "down" ]; then

case $mode in
cpu) echo "swap" > "$STATE" ;;
mem) echo "cpu" > "$STATE" ;;
swap) echo "mem" > "$STATE" ;;
esac

mode=$(cat "$STATE")

fi

make_bar(){

percent=$1

# 8 segment bar (cleaner than 10)
filled=$((percent / 12))
empty=$((8 - filled))

bar=""

for ((i=0;i<filled;i++)); do
bar+=""
done

for ((i=0;i<empty;i++)); do
bar+=""
done

echo "$bar"
}

case $mode in

cpu)

cpu=$(top -bn1 | awk '/Cpu/ {print int($2)}')

bar=$(make_bar $cpu)

printf '{"text":"[cpu %2d%% %s ]"}\n' "$cpu" "$bar"

;;

mem)

mem=$(free | awk '/Mem:/ {print int($3/$2 *100)}')

bar=$(make_bar $mem)

printf '{"text":"[ mem %2d%% %s ]"}\n' "$mem" "$bar"

;;

swap)

swap=$(free | awk '/Swap:/ {if($2==0){print 0}else{print int($3/$2 *100)}}')

bar=$(make_bar $swap)

printf '{"text":"[ swap %2d%% %s ]"}\n' "$swap" "$bar"

;;

esac