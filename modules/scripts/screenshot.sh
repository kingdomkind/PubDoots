#!/usr/bin/env bash
set -e

#> Old way without grimblast, keeping for later custom comp
# freeze_screenshot() {
#     region="$(slurp -w 0)"
#     killall wayfreeze
    
#     if [ "$region" = "selection cancelled" ]; then
#         return
#     fi

#     grim -g "$region" -t ppm - | satty --filename - --copy-command "wl-copy" --early-exit --fullscreen --initial-tool brush
# }

# wayfreeze --hide-cursor --before-freeze-cmd "$(declare -f freeze_screenshot); freeze_screenshot"

case "$1" in
    markup)
        grimblast --freeze --filetype ppm save area - \
            | satty --filename - --copy-command "wl-copy" --early-exit --fullscreen --initial-tool brush
        ;;
    simple)
        grimblast --freeze copy area
        ;;
    *)
        echo "Invalid usage! Arg 1 must be \`markup\` or \`simple\`."
        exit 1
        ;;
esac
