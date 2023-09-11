#! /bin/sh

chosen=$(printf "  Power Off\n  Restart\n  Suspend\n  Hibernate\n" | rofi -dmenu -i -theme-str '@import "~/.config/leftwm/themes/current/rofi/power.rasi"')

case "$chosen" in
  "  Power Off") poweroff ;;
  "  Restart") reboot ;;
  "  Suspend") systemctl suspend-then-hibernate ;;
  "  Hibernate") systemctl hibernate ;;
  *) exit 1 ;;
esac