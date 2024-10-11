#!/bin/bash -eu

print '\000' | dd of=/dev/sda3 seek=1127 conv=notrunc bs=1 count=1
print '\000' | dd of=/dev/sda5 seek=1127 conv=notrunc bs=1 count=1
