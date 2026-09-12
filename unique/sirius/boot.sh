#!/usr/bin/env sh

sudo efibootmgr --delete-bootnum --bootnum 0000

sudo efibootmgr --create --bootnum 0000 \
    --disk /dev/nvme0n1 --part 1 \
    --label "Artix" \
    --loader /vmlinuz-linux-cachyos \
    --unicode 'loglevel=3 quiet cryptdevices=/dev/nvme0n1p2:castle,/dev/disk/by-id/ata-PNY_CS900_120GB_SSD_PNY21422110190104439-part1:nomad root=/dev/mapper/castle resume=/dev/mapper/castle resume_offset=17355308 amd_iommu=on pcie_acs_override=downstream,multifunction initrd=\amd-ucode.img initrd=\initramfs-linux-cachyos.img'
