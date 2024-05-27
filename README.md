# operating-system

I am using the [OsDev](https://wiki.osdev.org/Main_Page) wiki a lot during development. 

For now the plan is as follows. After these initial steps I will decide on how to move forward.
1) [Babystep Tutorial](https://wiki.osdev.org/Babystep1): Adapt & Refactor to get a grip on assembly and the [Boot Sequence](https://wiki.osdev.org/Boot_Sequence).
2) [Bare Bones Tutorial](https://wiki.osdev.org/User:Zesterer/Bare_Bones): Follow along to refresh understanding of C and learn about [Kernels](https://wiki.osdev.org/Kernel).
3) [Real Mode Assembly](https://wiki.osdev.org/Real_mode_assembly_I): Follow along to deepen understanding of assembly and how Kernels work.

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