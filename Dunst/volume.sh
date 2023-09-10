#!/bin/bash

step="5"   # number of percentage points to increase/decrease volume
muted=$(amixer sget Master | grep -q '\[off\]' && echo "True" || echo "False")

down_icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-low.svg"
up_icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-high.svg"
mute_icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-muted.svg"


if [ $# -eq 0 ]; then
  echo "No argument supplied"
  echo "Usage should be: volume.sh <raise|lower|mute>"
  exit 1
fi

case ${1} in
  "lower")
    amixer set Master ${step}%- > /dev/null
    volume=$(amixer get Master | awk -F"[][]" '/Front Left:/ { print $2 }' | tr -d '[]')
    if [ $volume != "0%" ]; then
      down_icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-medium.svg"
    fi
    dunstify -r 9983 -t 2000 -h int:value:$volume "Volume: $volume" -i ${down_icon}
    ;;
  "raise")
    amixer set Master ${step}%+ > /dev/null
    volume=$(amixer get Master | awk -F"[][]" '/Front Left:/ { print $2 }' | tr -d '[]')
    dunstify -r 9983 -t 2000 -h int:value:$volume "Volume: $volume" -i ${up_icon}
    ;;
  "mute")
    amixer set Master toggle > /dev/null
    if [ $muted == "True" ]; then
    	dunstify -r 9983 -t 2000 -h int:value:$volume "Unmuted" -i ${down_icon}
    else
    	dunstify -r 9983 -t 2000 -h int:value:$volume "Muted" -i ${mute_icon}
    fi
    ;;
  *)
    echo "Unrecognized parameter: ${1}"
    echo "Usage should be: volume.sh <raise|lower|mute>"
    exit 1
    ;;
esac
