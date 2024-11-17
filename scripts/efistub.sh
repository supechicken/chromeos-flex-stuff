#!/bin/bash -eu

function get_partuuid() {
  blkid | grep "/dev/${1}:" | sed 's/.*PARTUUID="\(.*\)"/\1/'
}

function new_entry() {
  efibootmgr --create \
    --label "${1}" \
    --disk /dev/sda \
    --part 1 \
    --loader /ChromeOS/kernel \
    --unicode "${2}"
}

new_entry 'ChromeOS Flex (EFI stub)' 'initrd=/ChromeOS/initramfs.img init=/sbin/init rootwait ro noresume kvm-intel.vmentry_l1d_flush=always i915.modeset=1 cros_efi cros_debug iommu.passthrough=1 lsm=landlock,lockdown,yama,loadpin,safesetid,integrity,selinux'
