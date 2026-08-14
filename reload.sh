#!/usr/bin/env bash
set -eo pipefail
cd "$(dirname "$0")"
start_time=$(date +%s%3N)
first_generator=true
orange=$'\033[38;5;208m'
reset=$'\033[0m'

elapsed() {
    local milliseconds=$(($(date +%s%3N) - start_time))
    printf '%d.%03ds' $((milliseconds / 1000)) $((milliseconds % 1000))
}

run_generator() {
    local prefix=""
    if [ "${2:-}" = "super" ]; then
        prefix="pkexec"
    fi
    if $first_generator; then
        printf "%s[NEXT]%s %s\n" "$orange" "$reset" $1
        first_generator=false
    else
        printf "%s[NEXT]%s [%s] %s\n" "$orange" "$reset" "$(elapsed)" $1
    fi
    path=/tmp/$1
    rm -f "$path" #> Technically unnecessary, but if something fails to generate the config again, i want to know
    printf '%s' "$config" | jq ".$1" >"$path"

    if test -d "../Software/$1"; then
        (cd "../Software/$1" && cargo build && $prefix "./target/debug/$1" "$path")
    else
        $prefix $1 $path
    fi

}

config=$(lx run --no-loader | sed -n '/^{/,$p')
if [ "$1" = "dry" ]; then
    printf '%s' "$config" | jq .
else
    run_generator desym super
    run_generator depac
    printf "%s[DONE]%s [%s]\n" "$orange" "$reset" "$(elapsed)"
fi
