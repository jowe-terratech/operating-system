OUTPUT_FORMAT("binary")
ENTRY(start)

/* Tell the linker where to place sections in the binary. */
SECTIONS
{
    /* Place the first stage bootloader as boot sector */
    . = 0x7c00; 
    .stage1 : { *(.stage1) }

    /* Place the second stage bootloader 
       below the first stage with some buffer
       at the 1MB mark */
    . = 0x10000;
    .stage2 : { *(.stage2) }

    /* Here we will be placing the kernel 64K below the second stage
       aligned in 4KB chunks
     */
    . = 0x20000;
    
    /* Executable Code */
    .text : { *(.text) }

    /* Read-Write Data */
    .data : { *(.data) }

    /* Read-Write Data & Stack */
    .bss  : { *(.bss) }
}