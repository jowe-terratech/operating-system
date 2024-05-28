sprint_next:
    call cprint                 ; Print the next character

sprint:                         ; Expects si to point to the string
    cld                         ; Clear the direction flag
    lodsb                       ; Load byte at ds:si into al, increment si
    cmp al, 0                   ; Check if byte is null (end of string)
    jne sprint_next             ; If null, end
    ret

cprint:                             ; Expects al to contain the character
    mov ah, 0x0f                    ; Set the attribute to white on black
    mov cx, ax                      ; Save character+attribute in cx
    movzx ax, byte [sprint_ypos]    ; Move sprint_ypos to ax
    mov dx, 160                     ; 2 bytes per character, 80 characters per line
    mul dx                          ; Calculate row offset
    movzx bx, byte [sprint_xpos]    ; Move sprint_xpos to bx
    shl bx, 1                       ; 2 bytes per character, so we need to multiply by 2

    mov di, 0                       ; Start at the beginning of the screen
    add di, ax                      ; Add the row offset
    add di, bx                      ; Add the column offset

    mov ax, cx                      ; Move character+attribute to ax
    stosw                           ; Store ax at es:di, increment di
    add byte [sprint_xpos], 1       ; Move to the next character
    mov dl, [sprint_xpos]           ; Move sprint_xpos to dl
    call set_cursor_pos             ; Update the visible cursor accordingly

    ; Check if we need to wrap to the next line
    cmp byte [sprint_xpos], 80
    jl sprint_no_wrap

    ; If xpos >= 80, reset xpos to 0 and increment ypos
    mov byte [sprint_xpos], 0
    inc byte [sprint_ypos]
    mov dl, [sprint_ypos]           ; Move sprint_ypos to dl
    mov dh, [sprint_ypos]           ; Move sprint_ypos to dh

sprint_no_wrap:
    ret

move_cursor_right:
    mov ah, 0x02    ; BIOS function to set cursor position
    mov bh, 0x00    ; page number
    int 0x10        ; call BIOS
    ret

sprint_xpos db 0 ; Horizontal position
sprint_ypos db 0 ; Vertical position