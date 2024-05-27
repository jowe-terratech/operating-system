bios_print_start:
    cld ; Clear the direction flag

bios_print_char:
    lodsb ; Load the byte at si into al, and increment si
    or al, al ; Equals zero if we've reached the end of the string
    jz bios_print_end ; If al is zero, jump to the end
    ; Otherwise we print the character
    mov ah, 0x0e ; Set ah to 0x0e, the BIOS teletype function
    mov bh, 0 ; Set bh to 0, the page number
    int 0x10 ; Call the BIOS teletype function
    jmp bios_print_char ; Jump back to print the next character

bios_print_end:
    ret ; Return from the function