#!/usr/bin/env bash
set -euo pipefail

#> Mapfile reads an input into an array, -d means delimiter, and -t means remove that delimiter
mapfile -d $'\n' -t current_env < <(env)

exec sudo --non-interactive -- /home/pika/PubDoots/unique/sirius/launcher/second.sh "${current_env[@]}"
