#!/usr/bin/env sh
SOCKET=/run/user/1000/dinitctl

steal_gpu() {
    pci=0000:06:00.0
    info="/proc/driver/nvidia/gpus/$pci/information"

    #> Check the file exists, and is readable
    if [ ! -r "$info" ]; then
        return 0
    fi

    #> Get a dev minor, exiting if awk fails
    if ! minor=$(awk '/^Device Minor:/ {print $3}' "$info"); then
        return 0
    fi

    #> Check awk actually got something
    case "$minor" in
    '' | *[!0-9]*)
        return 0
        ;;
    esac

    #> Terminate, and then kill any PIDs
    node="/dev/nvidia$minor"
    #> -t means PID only.
    pids=$(lsof -t "$node")
    for pid in $pids; do
        kill -TERM "$pid" || :
    done

    if [ -n "$(lsof -t "$node")" ]; then
        sleep 3
        pids=$(lsof -t "$node")
        for pid in $pids; do
            kill -KILL "$pid" || :
        done
    fi
    return 0
}

case "$1" in
Altair | Antares) ;;
*) exit 0 ;;
esac

case "$2:$3" in
prepare:begin)
    dinitctl --socket-path "$SOCKET" stop llama
    steal_gpu
    ;;
release:end)
    dinitctl --socket-path "$SOCKET" start llama
    ;;
esac
