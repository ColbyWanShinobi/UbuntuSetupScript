#! /bin/bash

SCRIPTLINK=$(readlink -f "$0")
SCRIPTDIR=$(dirname "${SCRIPTLINK}")

# Prompt the user for the drive to use
echo "Enter the partition to use (e.g., /dev/sda1 /dev/nvme0n1p1):"
read btrfs_partition

# Check if the drive exists
if [ ! -b "$btrfs_partition" ]; then
    echo "Error: The specified partition does not exist."
    exit 1
fi

# Confirm that the partition is BTRFS
if ! blkid "$btrfs_partition" | grep -q "TYPE=\"btrfs\""; then
    echo "Error: The specified partition is not a BTRFS filesystem."
    exit 1
fi

# ENaure that you're running on Ubuntu
if [ ! -f /etc/os-release ] || ! grep -q "Ubuntu" /etc/os-release; then
    echo "Error: This script is intended to run on Ubuntu."
    exit 1
fi

# Unmount everything
sudo umount -a

# Mount the root partition
sudo mount "$btrfs_partition" /mnt

sudo cp -vf /etc/resolv.conf /mnt/etc/resolv.conf

sudo btrfs su snapshot /mnt/@

sudo rm -rv /mnt/{bin,bin*,boot,cdrom,etc,home,lib,lib*,media,mnt,opt,root,run,sbin,sbin*,snap,srv,sys,tmp,usr,var}

sudo btrfs su create /mnt/@{home,cache,log,tmp,snapshots}

sudo cp -av /mnt/@/var/cache/* /mnt/@cache && rm -rv /mnt/@/var/cache/* || echo "No cache directory"
sudo cp -av /mnt/@/var/log/* /mnt/@log && rm -rv /mnt/@/var/log/* || echo "No log directory"

sudo umount /mnt

sudo mount -o subvol=@ $btrfs_partition /mnt
sudo mount -o subvol=@home $btrfs_partition /mnt/home
sudo mount -o subvol=@cache $btrfs_partition /mnt/var/cache
sudo mount -o subvol=@log $btrfs_partition /mnt/var/log
sudo mount -o subvol=@tmp $btrfs_partition /mnt/var/tmp
sudo mount -o subvol=@snapshots $btrfs_partition /mnt/.snapshots

sudo mount $btrfs_partition /mnt/boot/efi

for d in dev proc sys run; do sudo mount --rbind /$d /mnt/$d; done

sudo chroot /mnt /bin/bash -c "
    grub-mkconfig -o /boot/efi/EFI/ubuntu/grub.cfg
    update-grub
    cp -v /etc/fstab /etc/fstab.bak
    chmod +x ${SCRIPTDIR}/gen-fstab ; ${SCRIPTDIR}/gen-fstab
    exit
"







#sudo chroot /mnt /bin/bash.

#sudo grub-mkconfig -o /boot/efi/EFI/ubuntu/grub.cfg
#sudo update-grub

#cp -v /etc/fstab /etc/fstab.bak
#chmod +x ${SCRIPTDIR}/gen-fstab ; ${SCRIPTDIR}/gen-fstab

#exit
