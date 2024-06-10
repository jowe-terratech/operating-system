OUTPUT_FORMAT("binary")
ENTRY(start)

/* Tell the linker where to place sections in the binary. */
SECTIONS
{
    /* Place the first stage bootloader as boot sector */
    . = 0x7c00; 
    .text : { *(.text) }

    . = 0x8000;
    .stage2 : { *(.stage2) }

    /* Read-Write Data */
    .data : { *(.data) }

    /* Read-Write Data & Stack */
    .bss  : { *(.bss) }
}
