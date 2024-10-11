#!/bin/bash -eux
set -eux

ROOTDIR="$(readlink -f "${PWD}/../")"

mount -o remount,size=8G /run/archiso/cowspace || true
mount -o remount,size=8G /tmp || true

pacman -Sy git

cd /tmp
git clone https://gitlab.com/kernel-firmware/linux-firmware.git --depth=1

#print '\000' | dd of=/dev/sda3 seek=1127 conv=notrunc bs=1 count=1
#print '\000' | dd of=/dev/sda5 seek=1127 conv=notrunc bs=1 count=1

e2fsck -f /dev/sda1
tune2fs -m 0 /dev/sda1

for i in 3 5; do
  mkdir -p mnt
  mount -o ro /dev/sda$i mnt

  tar -cpPf /tmp/rootfs-backup.tar mnt/*

  umount mnt
  yes | mkfs.ext4 /dev/sda$i
  e2fsck -f /dev/sda$i
  tune2fs -m 0 /dev/sda$i

  mount -o rw /dev/sda$i mnt
  tar -xpPf /tmp/rootfs-backup.tar -C mnt/
  rm -f /tmp/rootfs-backup.tar

  (
    cd mnt
    rm -rf lib/modules lib/firmware

    cp -r /tmp/linux-firmware lib/firmware
    tar -xf $ROOTDIR/kernel/6.6.54/modules-6.6.54.tar.xz
  )

  umount mnt
done
