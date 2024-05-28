set_cursor_pos:      ; Expects the target row in dl and the target column in dh
    mov ah, 0x02    ; BIOS function to set cursor position
    mov bh, 0x00    ; page number
    int 0x10        ; call BIOS
    ret

get_cursor_pos:     ; Store the current cursor position in the dl and dh registers
    mov ah, 0x03    ; BIOS function to get cursor position
    mov bh, 0x00    ; page number
    int 0x10        ; call BIOS
    ret