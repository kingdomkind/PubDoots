#!/usr/bin/env bash
set -eu

if [ "$(id -u)" -ne 0 ]; then
    echo "Must run as root"
    exit 1
fi

#> https://www.man7.org/linux/man-pages/man1/unshare.1.html
#> Unshare is a program, which creates namespaces. --moount, means create a mount/filesystem namespace / view
#> propagation slave means that when we mount something in the PID 1 mount namespace, our namespaced one will inherit it
#> and means if we mount anything, it won't propogate back to the PID 1 mount namespace

#> Previously I was just overwriting the card0 card to /dev/null, but that didn't work well as, when it came back from the
#> VM, it would not consistently return as card0 (sometimes as card 1 instead), so I just expose the only PCI device I want
#> in the first place (and that handle can't change, as it never gets unbound)
exec unshare --mount --propagation slave \
    sh -eu -c '
    pci=0000:07:00.0
    card=$(readlink -e "/dev/dri/by-path/pci-$pci-card")
    render=$(readlink -e "/dev/dri/by-path/pci-$pci-render")

    #> Mask all /dev/nvidia[0-9] nodes, other than the one pci uses
    minor=$(awk "/^Device Minor:/ {print \$3}" "/proc/driver/nvidia/gpus/$pci/information")
    for candidate in 0 1 2 3 4 5 6 7 8 9; do
        if [ "$candidate" = "$minor" ]; then
            continue
        fi
        node="/dev/nvidia$candidate"

        #> Bind null to the nodes
        if [ ! -e "$node" ]; then
            touch "$node"
        fi
        mount --bind /dev/null "$node"
    done

    #> Create the staging_dri where we will set up the new limited view dri
    staging_dri=$(mktemp -d /tmp/staging-dri.XXXXXX)
    cleanup_dri() {
        #> Incase we fail early, remove the mountpoints, so we dont delete the real nodes
        if mountpoint -q "$staging_dri"; then
            umount -R "$staging_dri" || return
        fi
        rmdir "$staging_dri"
    }
    trap cleanup_dri 0

    #> Mount a new tmpfs to it (so we can later move the entire tmpfs)
    mount --types tmpfs -o mode=0755 tmpfs "$staging_dri"

    #> Create the dri nodes
    for node in "$card" "$render"; do
        touch "$staging_dri/${node##*/}" #> Means, get just the file name
        mount --bind "$node" "$staging_dri/${node##*/}"
    done
    mkdir "$staging_dri/by-path"
    ln -s "../${card##*/}" "$staging_dri/by-path/pci-$pci-card"
    ln -s "../${render##*/}" "$staging_dri/by-path/pci-$pci-render"

    #> Move the tmpfs mounted at the staging dri, to /dev/dri now
    mount --move "$staging_dri" /dev/dri
    rmdir "$staging_dri"

    #> Unbind that previous trap we set
    trap - 0

    uid=$(id -u pika)
    gid=$(id -g pika)
    cd /home/pika

    exec setpriv --reuid="$uid" --regid="$gid" --init-groups \
        env --ignore-environment -- "$@" \
        dbus-run-session start-hyprland
' second.sh "$@"
