# operating-system

I am using the [OsDev](https://wiki.osdev.org/Main_Page) wiki a lot during development. 

For now the plan is as follows. After these initial steps I will decide on how to move forward.
1) [Babystep Tutorial](https://wiki.osdev.org/Babystep1): Adapt & Refactor to get a grip on assembly and the [Boot Sequence](https://wiki.osdev.org/Boot_Sequence).
2) [Bare Bones Tutorial](https://wiki.osdev.org/User:Zesterer/Bare_Bones): Follow along to refresh understanding of C and learn about [Kernels](https://wiki.osdev.org/Kernel).
3) [Real Mode Assembly](https://wiki.osdev.org/Real_mode_assembly_I): Follow along to deepen understanding of assembly and how Kernels work.
4) Building my own Kernel, with the basic components lined out in [What Order Should I make things in?](https://wiki.osdev.org/What_Order_Should_I_Make_Things_In%3F)
5) Adding a basic filesystem.
6) Adding a basic shell.
7) Adding a basic editor.
8) Adding a basic compiler to enable on system development.

## Dependencies

To install the dependencies run:

```Ubuntu
sudo apt install nasm
sudo apt install qemu-system
```

## Build & Run the System

To build & run the system simply call

```
./build.sh
```

## Import Documentation not part of the repository

- [Quick Reference for Common Interrupts](https://wiki.osdev.org/BIOS)
- [Ralf Brown's Bios Interrupt List](https://wiki.osdev.org/RBIL)