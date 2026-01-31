echo -e "\nDeleting Existing Entries \n"

sudo efibootmgr -b 0000 -B --quiet
sudo efibootmgr -b 0001 -B --quiet
sudo efibootmgr -b 0002 -B --quiet
sudo efibootmgr -b 0003 -B --quiet
sudo efibootmgr -b 0004 -B --quiet
sudo efibootmgr -b 0005 -B --quiet
sudo efibootmgr -b 0006 -B --quiet
sudo efibootmgr -b 0007 -B --quiet

echo -e "\nMaking Grub Backup\n"

#> Make backup grub config
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\nCreating EFI Stub \n"

sudo efibootmgr --create \
	--disk /dev/nvme0n1 --part 1 \
	--label "Arch Linux Stub" \
	--loader /vmlinuz-linux \
	--unicode "\initrd=booster-linux.img quiet rd.luks.name=ce98deb0-4c0c-4c51-acb5-1e0e0e883bfc=decryptdevice root=/dev/mapper/decryptdevice resume=/dev/mapper/decryptdevice resume_offset=60463104" 

echo -e "\nFinal Result:\n"

sudo efibootmgr
