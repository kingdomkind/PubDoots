#!/usr/bin/env bash

VAR=$(wpctl status | awk '/Sinks:/ {found=1; print; next} found && /^[[:space:]]*│[[:space:]]*$/ {exit} found {print}' | grep "$1" | tail -n 1 | grep -o '[0-9]*' | head -n 1)
echo "$1 is $VAR"

wpctl set-default "$VAR" 
