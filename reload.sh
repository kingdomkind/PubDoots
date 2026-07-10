#!/bin/bash
set -e
cd "$(dirname "$0")"

config=$(lx run)
if [ "$1" = "dry" ]; then
    printf '%s' "$config" | jq .
else
    for generator in desym depac; do
        echo -e "\033[38;5;208m[NEXT]\033[0m $generator"
        (cd "../Software/$generator" && cargo build && printf '%s' "$config"| jq ".$generator" | sudo ./target/debug/$generator)
    done
fi

