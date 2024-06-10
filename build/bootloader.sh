#!/bin/bash

# Re-create the out/ directory
rm -rf out
mkdir out

# Compile the bootloader using only the first bootloader stage
nasm -f elf32 src/bootloader/stage-1.asm -o out/stage1.o
nasm -f elf32 src/bootloader/stage-2.asm -o out/stage2.o
$HOME/opt/cross/bin/i686-elf-ld -T src/linker.ld -o out/bootloader.bin out/stage1.o out/stage2.o

# Create a blank USB image of 64MB
dd if=/dev/zero of=out/usb.img bs=1M count=64 

# Write the bootloader to the USB image
dd if=out/bootloader.bin of=out/usb.img conv=notrunc

# Run the USB image in QEMU
qemu-system-x86_64 -m 1024 -drive format=raw,file=out/usb.img
