#!/usr/bin/env bash
# set -x

mypctl set --path /home/pika/.config/maypaper/wallpapers/Zelda
# if [ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]; then
# 	SCRIPT_DIRECTORY="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# 	WALLPAPER_FILE="/tmp/wallpaper.txt"
# 	DIRECTORY="$ST_CONFIG/PrivDoots/Modules/pictures"
  
# 	if [ ! -f "$WALLPAPER_FILE" ]; then
# 		touch "$WALLPAPER_FILE"
# 	fi

# 	while true; do
# 		WALLPAPER=$(ls "$DIRECTORY" | shuf -n 1)
# 		if [ "$WALLPAPER" != "$(cat "$WALLPAPER_FILE" 2>/dev/null)" ]; then
# 			break
# 		fi
# 	done
# 	echo "$WALLPAPER" > "$WALLPAPER_FILE"
# 	FINAL="$DIRECTORY/$WALLPAPER"

# 	hyprctl hyprpaper unload all
# 	hyprctl hyprpaper preload "$FINAL"
#     for monitor in $(hyprctl monitors | grep 'Monitor' | awk '{ print $2 }'); do
# 	    hyprctl hyprpaper wallpaper "$monitor,$FINAL"
#     done
# fi


