set_cursor_pos:     ; x = dl, y = dh
    mov ah, 0x02    ; BIOS function to set cursor position
    mov bh, 0x00    ; page number
    int 0x10        ; call BIOS
    ret

get_cursor_pos:     ; dl <- x, dh <- y
    mov ah, 0x03    ; BIOS function to get cursor position
    mov bh, 0x00    ; page number
    int 0x10        ; call BIOS
    ret