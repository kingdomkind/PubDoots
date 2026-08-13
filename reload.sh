#!/bin/bash
set -eo pipefail
cd "$(dirname "$0")"

config=$(lx run --no-loader | sed -n '/^{/,$p')
if [ "$1" = "dry" ]; then
    printf '%s' "$config" | jq .
else
    for generator in desym depac; do
        printf "\033[38;5;208m[NEXT]\033[0m %s\n" $generator
        path=/tmp/$generator
        rm -f "$path" #> Technically unnecessary, but if something fails to generate the config again, i want to know
        printf '%s' "$config" | jq ".$generator" > "$path"
        (cd "../Software/$generator" && cargo build && pkexec "./target/debug/$generator" "$path")
    done
fi

