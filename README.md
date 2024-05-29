# operating-system

I am using the [OsDev](https://wiki.osdev.org/Main_Page) wiki a lot during development. 

For now the plan is as follows. After these initial steps I will decide on how to move forward.
- [Babystep Tutorial](https://wiki.osdev.org/Babystep1): Adapt & Refactor to get a grip on assembly and the [Boot Sequence](https://wiki.osdev.org/Boot_Sequence).
- [Bare Bones Tutorial](https://wiki.osdev.org/User:Zesterer/Bare_Bones): Follow along to refresh understanding of C and learn about [Kernels](https://wiki.osdev.org/Kernel).
- Update the code from the [Bootloader](https://wiki.osdev.org/Bootloader) into a [custom version](https://wiki.osdev.org/Rolling_Your_Own_Bootloader)
- [Real Mode Assembly](https://wiki.osdev.org/Real_mode_assembly_I): Follow along to deepen understanding of assembly and how Kernels work.
- Building my own Kernel, with the basic components lined out in [What Order Should I make things in?](https://wiki.osdev.org/What_Order_Should_I_Make_Things_In%3F)
- Adding a basic filesystem.
- Adding a basic shell.
- Adding a basic editor.
- Adding a basic compiler to enable on system development.

## Dependencies

### Bootloader

To install the dependencies run:

```Ubuntu
sudo apt install nasm
sudo apt install qemu-system
```

### Kernel (GCC Cross-Compiled)

To install the dependencies to build a [GCC Cross-Compiler](https://wiki.osdev.org/GCC_Cross-Compiler) run:

```
sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev textinfo libisl-dev
```

Download the source code for [GCC](https://www.gnu.org/software/gcc/) and [Binutils](https://www.gnu.org/software/binutils/) into `./cross-compiler`

### Kernel (GRUB & ISO)

To use `GRUB` and create an `.iso` file of the kernel we also need:

```
sudo apt install grub-pc-bin xorriso
``` 

and [GNU Mtools](https://www.gnu.org/software/mtools/#downloads).

## Build & Run the System

### Bootloader

To build & run the system simply call

```
./build-bootloader.sh
```

### Cross-Compiler

To use the cross-compiler setup according to the link above, use:

```
$HOME/opt/cross/bin/i686-elf-gcc -ffreestanding
```

## Documentation

### Kernel (Zesterer/Bare Bones)

The [Bare Bones Kernel](https://wiki.osdev.org/User:Zesterer/Bare_Bones) consists of 3 files:

```
start.s     - This file will contain our x86 assembly code that starts our kernel and sets up the x86
kernel.c    - This file will contain the majority of our kernel, written in C
linker.ld   - This file will give the compiler information about how it should construct our kernel executable by linking the previous files together
```

This kernel can be run using either:

```

```

### Import Documentation not part of the repository

- [Quick Reference for Common Interrupts](https://wiki.osdev.org/BIOS)
- [Ralf Brown's Bios Interrupt List](https://wiki.osdev.org/RBIL)
- [GDT Segment Description](https://wiki.osdev.org/Global_Descriptor_Table#Segment_Descriptor)