#!/usr/bin/env bash

open=$(qs -c noctalia-shell ipc call state all | jq '.state.barVisible')

if [ "$open" = "true" ]; then
    hyprctl keyword general:gaps_out 0
    qs -c noctalia-shell ipc call bar hideBar
else
    hyprctl keyword general:gaps_out 50
    qs -c noctalia-shell ipc call bar showBar
fi
