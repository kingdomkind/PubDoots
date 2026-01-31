#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

./run-signal.sh &
sleep 1
blueman-manager &
