clear_screen:
    ; Save variables that will be used
    push ax
    push es
    push di
    push cx

    ; Setup video-memory
    mov ax, 0xb800  ; Video memory segment (color text mode)
    mov es, ax      ; Set Extra Segment to video memory segment
    mov di, 0       ; Start at the beginning of video memory
    mov cx, 2000    ; Clear 80 columns * 25 rows * 2 bytes (character and attribute)

clear_screen_main:
    ; Print " " (space) character with attribute 0x0f (white on black)
    mov ax, 0x0f20          ; Space character in attribute 0x0f (white on black)
    stosw                   ; Store ax at es:di and increment di by 2
    loop clear_screen_main  ; Loop cx times

clear_screen_end:
    ; Restore variables
    pop cx
    pop di
    pop es
    pop ax
    ret