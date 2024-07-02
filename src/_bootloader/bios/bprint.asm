bprint:
    ; ==========================================
    ; bprint - Print a null-terminated string using BIOS teletype
    ; Arguments: 
    ; - si points to the string
    ; ==========================================
    push ax     ; Save ax as it gets modified
    xor ax, ax  ; Clear ax
    lodsb       ; Load byte from si into al and increment si

    ; Check if the byte is null
    or al, al 
    jz .done

    ; Call the BIOS teletype function
    mov ah, 0x0e
    int 0x10
    
    jmp bprint

    .done:
        pop ax ; Restore ax to its original value
        ret