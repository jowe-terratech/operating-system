get_cursor_pos:
    ; Returns the cursor position with dl = x, dh = y
    push ax
    push bx

    mov ah, 0x03
    mov bh, 0x00
    int 0x10

    pop bx
    pop ax
    ret

set_cursor_pos:
    ; Sets the cursor position with x = dl, y = dh
    push ax
    push bx

    mov ah, 0x02
    mov bh, 0x00
    int 0x10

    pop bx
    pop ax
    ret