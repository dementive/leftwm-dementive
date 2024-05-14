#! /bin/sh

if [ "$1" = "wayland" ]; then
  chosen=$(printf "  Power Off\n  Restart\n  Suspend\n  Hibernate\n" | wofi -d -L 5)
else
  chosen=$(printf "  Power Off\n  Restart\n  Suspend\n  Hibernate\n" | rofi -dmenu -i -theme-str '@import "~/.config/leftwm/themes/current/rofi/power.rasi"')
fi

case "$chosen" in
  "  Power Off") poweroff ;;
  "  Restart") reboot ;;
  "  Suspend") systemctl suspend-then-hibernate ;;
  "  Hibernate") systemctl hibernate ;;
  *) exit 1 ;;
esac