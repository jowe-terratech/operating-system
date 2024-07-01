// Uses GNU Assembler syntax

// This defines the C entry point for the kernel
.extern kernel_main

// Defined as global since the linker needs to find this symbol
.global start

// To use the GRUB Bootloader, we need to define a Multiboot header
// This involves some constants
.set ALIGN, 1<<0                                // Align loaded modules on page boundaries
.set MEMINFO, 1<<1                              // Provide memory map
.set MB_MAGIC, 0x1badb002                       // Used by GRUB to detect the kernels location
.set MB_FLAGS, ALIGN | MEMINFO                  // Tells GRUB: 1) Load module on page boundaries 2) Provide a memory map
.set MB_CHECKSUM, (0 - (MB_MAGIC + MB_FLAGS))   // Checksum of the above values

// The multiboot header section
.section .multiboot     // Multiboot header section
    .align 4            // Make sure the header is aligned to a multiple of 4 bytes
    .long MB_MAGIC
    .long MB_FLAGS
    .long MB_CHECKSUM

// This section is initialized as zeros when the kernel is loaded
.section .bss
    .align 16
    stack_bottom:
        .skip 4096 // Reserve a 4KB stack for the C code
    stack_top:

// This is the entry point for the kernel
.section .text
    start:
        mov $stack_top, %esp // Set the stack pointer to the top of the stack
        call kernel_main     // Call the C kernel entry point

        // If the kernel ever returns, loop forever
        hang:
            cli         // Disable interrupts
            hlt         // Halt the CPU
            jmp hang    // Loop forever
