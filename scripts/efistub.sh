#!/bin/bash -eu

default="quiet init=/sbin/init rootwait ro noresume loglevel=7 noinitrd console= kvm-intel.vmentry_l1d_flush=always i915.modeset=1 cros_efi"
verbose="init=/sbin/init rootwait ro noresume noinitrd kvm-intel.vmentry_l1d_flush=always i915.modeset=1 cros_efi"
devmode="iommu=pt iommu.passthrough=1 lsm=landlock,lockdown,yama,loadpin,safesetid,integrity,selinux ${verbose} cros_debug"

function get_partuuid() {
  blkid | grep "/dev/${1}:" | sed 's/.*PARTUUID="\(.*\)"/\1/'
}

function new_entry() {
  efibootmgr --create \
    --label "${1}" \
    --disk /dev/sda \
    --part 2 \
    --loader /ChromeOS/kernel \
    --unicode "root=PARTUUID=${2} ${3}"
}

new_entry 'ChromeOS Flex (ROOT-A)' "$(get_partuuid vda3)" "vdisk=PARTUUID=$(get_partuuid sda2) ${devmode}"
new_entry 'ChromeOS Flex (ROOT-B)' "$(get_partuuid vda5)" "vdisk=PARTUUID=$(get_partuuid sda2) ${devmode}"
