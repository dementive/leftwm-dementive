#!/bin/sh

down_icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-low.svg"
up_icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-full.svg"


send_notification() {
    brightness=$(echo "$(brightnessctl -m | awk -F, '{print $4}')")
    dunstify -a "changebrightness" -u low -r 9991 -h int:value:"$brightness" -i "${2}" "Brightness: $brightness" -t 2000
}

case ${1} in
up)
    brightnessctl -s s +5%
    send_notification "${1}" ${up_icon}
    ;;
down)
    brightnessctl -s s 5%-
    send_notification "${1}" ${down_icon}
    ;;
esac
