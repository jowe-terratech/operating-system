#!/bin/bash

# Re-create the out/ directory
rm -rf out
mkdir out

# Assemble the boot sector code
nasm -f bin src/real-mode-assembly/kernel.asm -o out/kernel.bin

# Create a blank USB image of 64MB
dd if=/dev/zero of=out/usb.img bs=1M count=64 

# Write the kernel to the USB image
dd if=out/kernel.bin of=out/usb.img conv=notrunc

# Clear the files that are no longer needed
rm out/kernel.bin

# Run the USB image in QEMU
qemu-system-x86_64 -m 1024 -drive format=raw,file=out/usb.img
