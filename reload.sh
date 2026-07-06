#!/bin/bash
set -e
cd "$(dirname "$0")"

config=$(lx run)

(cd ../Software/desym && sudo cargo run -- "$(echo "$config" | jq -c '.desym')")
(cd ../Software/depac && sudo cargo run -- "$(echo "$config" | jq -c '.depac')")
