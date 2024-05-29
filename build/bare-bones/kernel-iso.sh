$HOME/opt/cross/bin/i686-elf-gcc -std=gnu99 -ffreestanding -g -c src/bare-bones-kernel/start.s -o out/start.o
$HOME/opt/cross/bin/i686-elf-gcc -std=gnu99 -ffreestanding -g -c src/bare-bones-kernel/kernel.c -o out/kernel.o
$HOME/opt/cross/bin/i686-elf-gcc -ffreestanding -nostdlib -g -T src/bare-bones-kernel/linker.ld out/start.o out/kernel.o -o out/kernel.elf -lgcc
rm -rf out/iso
mkdir -p out/iso/boot/grub
cp src/bare-bones-kernel/grub.cfg out/iso/boot/grub/grub.cfg
cp out/kernel.elf out/iso/boot/kernel.elf
grub-mkrescue -o out/kernel.iso out/iso
qemu-system-i386 -cdrom out/kernel.iso