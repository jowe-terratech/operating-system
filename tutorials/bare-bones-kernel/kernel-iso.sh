#!/bin/bash

# Re-create the out/ directory
rm -rf out
mkdir out

# Compile the kernel
$HOME/opt/cross/bin/i686-elf-gcc -std=gnu99 -ffreestanding -g -c src/bare-bones-kernel/start.s -o out/start.o
$HOME/opt/cross/bin/i686-elf-gcc -std=gnu99 -ffreestanding -g -c src/bare-bones-kernel/kernel.c -o out/kernel.o
$HOME/opt/cross/bin/i686-elf-gcc -ffreestanding -nostdlib -g -T src/bare-bones-kernel/linker.ld out/start.o out/kernel.o -o out/kernel.elf -lgcc

# Clear the out/iso directory and create the necessary directories
rm -rf out/iso
mkdir -p out/iso/boot/grub

# Copy the GRUB configuration file and the kernel to the out/iso directory
cp src/bare-bones-kernel/grub.cfg out/iso/boot/grub/grub.cfg
cp out/kernel.elf out/iso/boot/kernel.elf

# Create the ISO image
grub-mkrescue -o out/kernel.iso out/iso

# Clear the the files that are no longer needed
rm out/kernel.elf
rm out/start.o
rm out/kernel.o

# Run the ISO image in QEMU
qemu-system-i386 -cdrom out/kernel.iso