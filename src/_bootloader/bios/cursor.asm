cursor_set_pos:
    ; ==========================================
    ; cursor_set_pos - Update the cursor position using the dx register
    ; Arguments: 
    ; - dl: x position
    ; - dh: y position
    ; ==========================================
    mov ah, 0x02    ; BIOS function to set cursor position
    mov bh, 0x00    ; page number
    int 0x10        ; call BIOS
    ret

cursor_get_pos:     
    ; ==========================================
    ; cursor_get_pos - Get the current cursor position
    ; Returns:
    ; - dl: x position
    ; - dh: y position
    ; ==========================================
    mov ah, 0x03    ; BIOS function to get cursor position
    mov bh, 0x00    ; page number
    int 0x10        ; call BIOS
    ret

cursor_newline:
    ; ==========================================
    ; cursor_newline - Move the cursor to the next line
    ; ==========================================
    call cursor_get_pos
    mov dl, 0x00    ; x position
    inc dh          ; y position
    call cursor_set_pos
    ret