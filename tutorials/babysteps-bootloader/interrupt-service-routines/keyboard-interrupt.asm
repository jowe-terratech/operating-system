ivt_iqr1:
    cli                         ; Disable interrupts while we modify the interrupt vector table
    mov bx, 0x09                ; Set the interrupt vector table entry for IRQ1 (keyboard interrupt) to point to our handler
    shl bx, 2                   ; Multiply by 4 to get the correct offset in the IVT
    xor ax, ax                  ; Clear ax
    mov gs, ax                  ; Set the General Segment to point to the start of the memory
    mov [gs:bx], word get_key   ; Have the offset point to our handler
    mov [gs:bx+2], word ds      ; At this point ds is 0, so we set the segment to 0
    sti                         ; Re-enable interrupts
    ret                         ; Return to the caller

get_key:
    in al, 0x60             ; Read the current key pressed from port 0x60
    mov bl, al              ; Store the key in bl, used to check if released later
    mov byte [port60], bl   ; Store the key in port60

    in al, 0x61             ; Read the keyboard controller status from port 0x61
    mov ah, al              ; Store the status in ah
    or al, 0x80             ; Set the high bit (bit 7) of the status
    out 0x61, al            ; Write the modified status back to port 0x61 to disable the keyboard

    mov al, 0x20            ; Set the End of Interrupt (EOI) code
    out 0x20, al            ; Write the EOI code to the Programmable Interrupt Controller (PIC)

    and bl, 0x80            ; Check if the key was released (bit 7 set)
    jnz get_key_done        ; If the key was released, jump to get_key_done

    call scancode_to_ascii  ; Map the scancode to an ASCII character
    call cprint             ; Print the ASCII character to the screen

get_key_done:
    iret                    ; Return from the interrupt

scancode_to_ascii:                  ; Map the scancode to an ASCII character, stored in al
    movzx bx, byte[port60]          ; Move the scancode to bx
    cmp bx, 128                     ; Check if the scancode is within the valid range of scancodes
    jae unknown_scancode            ; If not, we're done

    mov al, [scancode_table + bx]   ; Move the ASCII character to al
    ret

unknown_scancode:
    mov al, 0                    ; If the scancode is unknown, return 0
    ret

scancode_table:
    db 0, 0x1b, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 0, 0x60, 0x10, 0x11   ; 0x00 - 0x0F
    db 'Q', 'W', 'E', 'R', 'T', 'Z', 'U', 'I', 'O', 'P', 0, '+', 0x15, 0, 'A', 'S'      ; 0x10 - 0x1F
    db 'D', 'F', 'G', 'H', 'J', 'K', 'L', 0, 0, '^', 0, '#', 'Y', 'X', 'C', 'V'         ; 0x20 - 0x2F
    db 'B', 'N', 'M', ',', '.', '-', 0, 0, 0, 0x20, 0, 0, 0, 0, 0, 0                    ; 0x30 - 0x3F