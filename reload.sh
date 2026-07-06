#!/bin/bash
set -e
cd "$(dirname "$0")"

config=$(lx run)
for generator in desym depac; do
    echo -e "\033[38;5;208m[NEXT]\033[0m $generator"
    (cd "../Software/$generator" && sudo cargo run -- "$(echo "$config" | jq -c ".$generator")")
done
