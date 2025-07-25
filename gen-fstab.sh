#!/bin/bash

function subvol () {
	for su in $(btrfs su list / | grep 'level 5' | awk '{print $9}'); do

	    if test "$su" = "@" ; then mountAt="/" ; fi
	    if test "$su" = "@home" ; then mountAt="/home" ; fi
	    if test "$su" = "@log" ; then mountAt="/var/log" ; fi
	    if test "$su" = "@tmp" ; then mountAt="/tmp" ; fi
	    if test "$su" = "@cache" ; then mountAt="/var/cache" ; fi
	    if test "$su" = "@snapshots" ; then mountAt="/.snapshots" ; fi

	    echo "${getRootFS} $mountAt btrfs ${btrfsOptions},subvol=${su} 0 0"
	done
}

btrfsOptions="ssd,noatime,space_cache=v2,compress=lzo"

getBootFS="$(cat /etc/fstab | grep "vfat" | awk '{print $1}')"
getBootFS="$(cat /etc/fstab | grep "btrfs" | awk '{print $1}')"
getSwapFS="$(cat /etc/fstab | grep "swap" | awk '{print $1}')"

cat <<EOF > /etc/fstab
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>

# EFI boot partition
${getBootFS} /boot/efi vfat defaults 0 1

# Mount btrfs subvolumes
$(subvol)

# Swap
${getSwapFS} none swap defaults 0 0
EOF

exit 0
