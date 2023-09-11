#!/bin/sh

# Send a notification if the laptop battery is either low 
# or is fully charged.
# This needs to be setup as a cron job to function properly
# Requirements: cron manager, acpi, and dunst

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

low_icon="/usr/share/icons/Papirus/48x48/status/battery-empty.svg"
full_icon="/usr/share/icons/Papirus/48x48/status/battery-full.svg"

# Battery percentage at which to notify
WARNING_LEVEL=15
BATTERY_DISCHARGING=$(acpi -b | grep "Battery 0" | grep -c "Discharging")
BATTERY_LEVEL=$(acpi -b | grep "Battery 0" | grep -P -o '[0-9]+(?=%)')

# Use two files to store whether we've shown a notification or not (to prevent multiple notifications)
EMPTY_FILE=/tmp/batteryempty
FULL_FILE=/tmp/batteryfull

# Reset notifications if the computer is charging/discharging
if [ "$BATTERY_DISCHARGING" -eq 1 ] && [ -f $FULL_FILE ]; then
    rm $FULL_FILE
elif [ "$BATTERY_DISCHARGING" -eq 0 ] && [ -f $EMPTY_FILE ]; then
    rm $EMPTY_FILE
fi
[]
# If the battery is charging and is full (and has not shown notification yet)
if [ "$BATTERY_LEVEL" -gt 95 ] && [ "$BATTERY_DISCHARGING" -eq 0 ] && [ ! -f $FULL_FILE ]; then
    notify-send "Battery Charged" "Battery is fully charged." -i ${full_icon} -r 9991
    touch $FULL_FILE
# If the battery is low and is not charging (and has not shown notification yet)
elif [ "$BATTERY_LEVEL" -le $WARNING_LEVEL ] && [ "$BATTERY_DISCHARGING" -eq 1 ] && [ ! -f $EMPTY_FILE ]; then
    notify-send "Low Battery" "${BATTERY_LEVEL}% of battery remaining." -u critical -i ${low_icon} -r 9991
    touch $EMPTY_FILE
fi
