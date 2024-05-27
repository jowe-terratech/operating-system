update_cursor:
    mov ah, 0x02    ; BIOS function to set cursor position
    mov bh, 0x00    ; page number
    int 0x10        ; call BIOS
    ret