#!/usr/bin/env bash

MAX_LEN=50

print_window() {

window=$(hyprctl activewindow -j)

title=$(jq -r '.title' <<< "$window")
class=$(jq -r '.class' <<< "$window")

if [[ "$title" == "null" || -z "$title" ]]; then
    ws=$(hyprctl activeworkspace -j | jq -r '.id')
    echo "{\"text\":\"[Desktop = Workspace $ws]\"}"
    return
fi

# Calculate safe title length (reserve space for brackets + class)
reserve=$(( ${#class} + 7 ))
limit=$(( MAX_LEN - reserve ))

if (( ${#title} > limit )); then
    title="${title:0:$((limit-3))}.."
fi

echo "{\"text\":\"[$class = $title]\"}"

}

print_window

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
while read -r event
do
    case "$event" in
        activewindow*|workspace*|focusedmon*)
            print_window
        ;;
    esac
done