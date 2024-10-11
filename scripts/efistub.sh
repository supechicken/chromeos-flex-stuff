#!/bin/bash -eu

default="quiet init=/sbin/init rootwait ro noresume loglevel=7 noinitrd console= kvm-intel.vmentry_l1d_flush=always i915.modeset=1 cros_efi"
verbose="panic=60 init=/sbin/init rootwait ro noresume loglevel=7 noinitrd kvm-intel.vmentry_l1d_flush=always i915.modeset=1 cros_efi"
devmode="${verbose} cros_debug"

function get_partuuid() {
  blkid | grep "/dev/${1}:" | sed 's/.*PARTUUID="\(.*\)"/\1/'
}

function new_entry() {
  efibootmgr --create \
    --label "${1}" \
    --disk /dev/sda \
    --part 12 \
    --loader /my-kernel \
    --unicode "root=PARTUUID=${2} ${3}"
}

new_entry 'ChromeOS Flex (ROOT-A)' "$(get_partuuid sda3)" "${devmode}"
new_entry 'ChromeOS Flex (ROOT-B)' "$(get_partuuid sda5)" "${devmode}"
