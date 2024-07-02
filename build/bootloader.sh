#!/bin/bash

# Re-create the out/ directory
rm -rf out
mkdir out

# Compile the bootloader using only the first bootloader stage
nasm -f elf32 src/boot-sector.asm -o out/boot-sector.o
nasm -f elf32 src/boot-loader.asm -o out/boot-loader.o
$HOME/opt/cross/bin/i686-elf-ld -T src/linker.ld -o out/bootloader.bin out/boot-sector.o out/boot-loader.o

# Create a blank USB image of 64MB
dd if=/dev/zero of=out/usb.img bs=1M count=64 

# Write the bootloader to the USB image
dd if=out/bootloader.bin of=out/usb.img conv=notrunc

# Run the USB image in QEMU
qemu-system-x86_64 -m 1024 -drive format=raw,file=out/usb.img
