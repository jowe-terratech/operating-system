#!/bin/bash

# Create the out/ directory if it does not exist
mkdir -p out

# Assemble the boot sector code
nasm -f bin src/bootloader/boot-sector/boot.asm -o out/boot.bin

# Create a blank USB image of 64MB
dd if=/dev/zero of=out/usb.img bs=1M count=64 

# Write the boot sector to the USB image
dd if=out/boot.bin of=out/usb.img conv=notrunc

# Run the USB image in QEMU
qemu-system-x86_64 -m 1024 -drive format=raw,file=out/usb.img
