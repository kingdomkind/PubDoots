#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

./run-signal.sh &
vesktop &
sleep 1
blueman-manager &
