#!/usr/bin/env sh
sudo efibootmgr | grep -oP '^Boot\K[0-9A-Fa-f]{4}' |
while read -r n; do
    sudo efibootmgr -b "$n" -B
done
