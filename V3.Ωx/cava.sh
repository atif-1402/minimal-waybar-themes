#!/usr/bin/env bash

SOURCE="$(pactl get-default-sink).monitor"
CONFIG="/tmp/cava_waybar.conf"

cat > "$CONFIG" <<EOF
[general]
bars = 10
framerate = 60

[input]
method = pulse
source = $SOURCE

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 5
EOF

cava -p "$CONFIG" | while IFS=';' read -ra values; do
    bars=""
    for i in "${values[@]}"; do
        case $i in
            0) bars+="⣀" ;;
            1) bars+="⣄" ;;
            2) bars+="⣆" ;;
            3) bars+="⣇" ;;
            4) bars+="⣧" ;;
            5) bars+="⣷" ;;
            6) bars+="⣿" ;;
            7) bars+="⣿" ;;
        esac
    done
    printf '{"text":"[%s]"}\n' "$bars"
done