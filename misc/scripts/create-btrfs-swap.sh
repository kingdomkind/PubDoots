#!/usr/bin/env bash
set -e

if [ $EUID != 0 ]; then
    echo "Script needs to be ran as root"
    exit 1
fi
pacman -S --needed btrfs-progs
#> The name of the subvolume is swap, the path just means, mount it there
#> automatically. Note that online, people use eg. @swap, @ means nothing it's
#> just that they named it @swap, rather than just swap
#> https://fedoramagazine.org/working-with-btrfs-subvolumes/
btrfs subvolume create /swap 
#> The C attribute means to disable copy-on-write
#> https://man7.org/linux/man-pages/man1/chattr.1.html
#> As per the manpage, when applied on a folder it means any new files made in it
#> will inherit +C
chattr +C /swap
read -rp "How large do you want the swapfile (GiB automatically appended, so just write for example, '16'): " size
mkswap --size "${size}GiB" --file /swap/swapfile
swapon /swap/swapfile

read -rp "Woud you like the swap subvolume + swapfile added to the fstab?: [y/n]": usefstab

if [ "${usefstab}" == "y" ]; then
    read -rp "Is the root drive NOT /dev/mapper/decryptdevice? [y/n]": isbase
    fstabname="/dev/mapper/decryptdevice"
    if [ "${isbase}" == "y" ]; then
        read -rp "What is the root drive then? ": fstabname
    fi
    if [ "${fstabname}" == "" ]; then
        echo "Dumbass you put nothing"
        exit 1
    fi
    printf "\n%s\n%s\n%s\n%s\n" \
        "#> BTRFS Swap Subvolume" \
        "${fstabname}  /swap   btrfs   subvol=swap,nofail   0   0" \
        "#> Swapfile" \
        "/swap/swapfile   none    swap    defaults,nofail    0    0" \
        >> /etc/fstab
    echo "Appended to fstab, good luck and God speed. New fstab:"
    cat /etc/fstab
else
    echo "Did not append to fstab :("
fi
