#!/bin/bash

step="5"   # number of percentage points to increase/decrease volume
muted=$(amixer sget Master | grep -q '\[off\]' && echo "True" || echo "False")

using_pulse_audio=$(pulseaudio --check >/dev/null 2>&1 && echo "True" || echo "False")

down_icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-low.svg"
up_icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-high.svg"
mute_icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-muted.svg"

get_volume () {
  if [ $using_pulse_audio == "True" ]; then
    volume=$(pactl list sinks | grep '^[[:space:]]Volume:' | \
        head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
    volume+="%"
  else
    volume=$(amixer get Master | awk -F"[][]" '/(Mono|Front Left):/ { print $2 }' | tr -d '[]')
  fi

  echo $volume
}

raise_sound () {
  if [ $using_pulse_audio == "True" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +${step}%
  else
    amixer set Master ${step}%+ > /dev/null
  fi
}

lower_sound () {
  if [ $using_pulse_audio == "True" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ -${step}%
  else
    amixer set Master ${step}%- > /dev/null
  fi
}

mute_sound () {
  if [ $using_pulse_audio == "True" ]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
  else
    amixer set Master toggle > /dev/null
  fi
}

if [ $# -eq 0 ]; then
  echo "No argument supplied"
  echo "Usage should be: volume.sh <raise|lower|mute>"
  exit 1
fi

case ${1} in
  "lower")
    lower_sound
    volume=$(get_volume)
    if [ $volume != "0%" ]; then
      down_icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-medium.svg"
    fi
    dunstify -r 9983 -t 2000 -h "int:value:$volume" "Volume: $volume" -i ${down_icon}
    ;;
  "raise")
    raise_sound
    volume=$(get_volume)
    dunstify -r 9983 -t 2000 -h "int:value:$volume" "Volume: $volume" -i ${up_icon}
    ;;
  "mute")
    mute_sound
    if [ $muted == "True" ]; then
    	dunstify -r 9983 -t 2000 "Unmuted" -i ${down_icon}
    else
    	dunstify -r 9983 -t 2000 "Muted" -i ${mute_icon}
    fi
    ;;
  *)
    echo "Unrecognized parameter: ${1}"
    echo "Usage should be: volume.sh <raise|lower|mute>"
    exit 1
    ;;
esac
