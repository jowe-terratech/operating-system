# Compile the kernel
$HOME/opt/cross/bin/i686-elf-gcc -std=gnu99 -ffreestanding -g -c src/bare-bones-kernel/start.s -o out/start.o
$HOME/opt/cross/bin/i686-elf-gcc -std=gnu99 -ffreestanding -g -c src/bare-bones-kernel/kernel.c -o out/kernel.o
$HOME/opt/cross/bin/i686-elf-gcc -ffreestanding -nostdlib -g -T src/bare-bones-kernel/linker.ld out/start.o out/kernel.o -o out/kernel.elf -lgcc

# Clear the files that are no longer needed
rm out/start.o
rm out/kernel.o

# Run the kernel in QEMU
qemu-system-i386 -kernel out/kernel.elf