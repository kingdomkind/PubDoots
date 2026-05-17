#!/bin/bash
set -e
cd "$(dirname "$0")"

config=$(lx run)

(cd ../Software/desym && cargo run -- "$(echo "$config" | jq -c '.desym')")
