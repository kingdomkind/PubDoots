#!/usr/bin/env sh

sudo efibootmgr --delete-bootnum --bootnum 0000

#> Not /boot, because it isn't mounted, this is directly in partition 1
#> We can also use / here because it's efibootmgr, not UEFI
sudo efibootmgr --create --bootnum 0000 \
    --disk /dev/nvme0n1 --part 1 \
    --label "Artix" \
    --loader /vmlinuz-linux \
    --unicode 'loglevel=3 quiet cryptdevice=/dev/nvme0n1p2:castle root=/dev/mapper/castle initrd=\intel-ucode.img initrd=\initramfs-linux.img' #> UEFI uses \ as the path seperator
