#!/usr/bin/env bash
set -e

freeze_screenshot() {
    region="$(slurp -w 0)"
    killall wayfreeze
    
    if [ "$region" = "selection cancelled" ]; then
        return
    fi

    grim -g "$region" -t ppm - | satty --filename - --copy-command "wl-copy" --early-exit --fullscreen --initial-tool brush
}

wayfreeze --hide-cursor --before-freeze-cmd "$(declare -f freeze_screenshot); freeze_screenshot"
