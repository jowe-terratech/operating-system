/* The bootloader will start execution designated as the entry point. */
ENTRY(start)

/* Tell the linker where to place sections in the kernel executable. */
SECTIONS {
    /* Start the kernel at the 2MB mark. */
    . = 2M;

    /* Align sections in 4KB chunks, useful when adding paging. */

    /* Executable Code */
    .text BLOCK(4K) : ALIGN(4K) {
        *(.multiboot)
        *(.text)
    }

    /* Read-only Data */
    .rodata BLOCK(4K) : ALIGN(4K) {
        *(.rodata)
    }

    /* Read-write Data */
    .data BLOCK(4K) : ALIGN(4K) {
        *(.data)
    }

    /* Uninitialized Read-Write Data & Stack */
    .bss BLOCK(4K) : ALIGN(4K) {
        *(COMMON)
        *(.bss)
    }
}