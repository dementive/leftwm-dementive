#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
# nmcli dev wifi rescan
notify-send "Getting list of available Wi-Fi networks..."
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

# Gives a list of known connections so we can parse it later
connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
  toggle="睊  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
  toggle="直  Enable Wi-Fi"
fi
if [ "$1" = "wayland" ]; then
  line_count=$(echo "$wifi_list" | wc -l)
  chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | wofi -d -i -L $line_count -p "Wi-Fi SSID: " )
else
  chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -p "Wi-Fi SSID: " )
fi
chosen_id=$(echo "${chosen_network:3}" | xargs)

# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
if [ "$chosen_network" = "" ]; then
  exit
elif [ "$chosen_network" = "直  Enable Wi-Fi" ]; then
  nmcli radio wifi on
elif [ "$chosen_network" = "睊  Disable Wi-Fi" ]; then
  nmcli radio wifi off
else
  # Message to show when connection is activated successfully
  success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
  # Get known connections
  saved_connections=$(nmcli -g NAME connection)
  if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
    nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
  else
    if [[ "$chosen_network" =~ "" ]]; then
      if [ "$1" = "wayland" ]; then
        wifi_password=$(wofi -d -p "Password: " )
      else
        wifi_password=$(rofi -dmenu -p "Password: " )
      fi
    fi
    nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
  fi
fi