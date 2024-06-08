sprint:
    ; ==========================================
    ; sprint - Print a null-terminated string
    ; Arguments: 
    ; - si points to the string
    ; ==========================================
    push ax ; Save ax
    lodsb ; Load byte from si into al and increment si

    ; Check if the byte is null
    or al, al 
    jz .done

    ; Call the BIOS teletype function
    mov ah, 0x0e
    int 0x10
    
    jmp sprint

    .done:
        pop ax ; Restore ax
        ret