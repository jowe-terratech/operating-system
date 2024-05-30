# operating-system

I am using the [OsDev](https://wiki.osdev.org/Main_Page) wiki a lot during development. 

## Plan

For now the plan is as follows. After these initial steps I will decide on how to move forward.

### Coming Up

- Update the code from the [Babysteps Bootloader](https://wiki.osdev.org/Category:Babystep) into a [custom version](https://wiki.osdev.org/Rolling_Your_Own_Bootloader)

- Building my own Kernel, with the basic components lined out in [What Order Should I make things in?](https://wiki.osdev.org/What_Order_Should_I_Make_Things_In%3F)

- Adding a basic filesystem.

- Adding a basic shell.

- Adding a basic editor.

- Adding a basic compiler to enable on system development.

### Done

- [Babystep Tutorial](https://wiki.osdev.org/Babystep1): Adapt & Refactor to get a grip on assembly and the [Boot Sequence](https://wiki.osdev.org/Boot_Sequence).

- [Bare Bones Tutorial](https://wiki.osdev.org/User:Zesterer/Bare_Bones): Follow along to refresh understanding of C and learn about [Kernels](https://wiki.osdev.org/Kernel).

- [Real Mode Assembly](https://wiki.osdev.org/Real_mode_assembly_I): Follow along to deepen understanding of assembly and how Kernels work.

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
./build/bootloader.sh
```

### Cross-Compiler

To use the cross-compiler setup according to the link above, use:

```
$HOME/opt/cross/bin/i686-elf-gcc -ffreestanding
```

## Documentation

### Import Documentation not part of the repository

- [Quick Reference for Common Interrupts](https://wiki.osdev.org/BIOS)
- [Ralf Brown's Bios Interrupt List](https://wiki.osdev.org/RBIL)
- [GDT Segment Description](https://wiki.osdev.org/Global_Descriptor_Table#Segment_Descriptor)

### The Bootloader

The bootloader, due to its easy access to the BIOS needs to do a few things before transfering control to the kernel:
- Activate the [A20 Gate](https://wiki.osdev.org/A20_Line)
- Switch to [Unreal Mode](https://wiki.osdev.org/Unreal_Mode)
- Load the Kernel
- Gather Information: 
    - [Amount of RAM](https://wiki.osdev.org/How_Do_I_Determine_The_Amount_Of_RAM)
    - [Available Video Modes](https://wiki.osdev.org/Getting_VBE_Mode_Info)
- Enter [Protected Mode](https://wiki.osdev.org/Protected_Mode)

#### Outline

Before starting to work on the Bootloader, there are some design decisions to make. These include:
- Do I need a two-stage bootloader?
- Where is the Kernel stored? On an unformatted drive or i.e. a [FAT-formatted](https://wiki.osdev.org/FAT) USB?