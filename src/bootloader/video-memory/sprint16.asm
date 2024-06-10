sprint_next:
    call cprint                 ; Print the next character

sprint:
    ; ==========================================
    ; sprint - Print a null-terminated string using the video memory
    ; Arguments: 
    ; - si points to the string
    ; ==========================================
    mov ax, 0xb800              ; Video memory segment (color text mode)
    mov es, ax                  ; Set Extra Segment to video memory segment
    cld                         ; Clear the direction flag
    lodsb                       ; Load byte at ds:si into al, increment si because di is clear
    cmp al, 0                   ; Check if byte is null (end of string)
    jne sprint_next             ; If null, end
    ret

sprint_with_newline:
    call sprint                 ; Print the string
    call sprint_newline         ; Update cursor position variables
    call sprint_update_cursor   ; Update cursor
    ret

cprint:
    ; ==========================================
    ; cprint - Print a single character using the video memory
    ; Arguments:
    ; - al contains the character to print
    ; ==========================================
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

    ; Check if we need to wrap to the next line
    cmp byte [sprint_xpos], 80
    jl sprint_update_cursor

    ; If xpos >= 80, reset xpos to 0 and increment ypos
    call sprint_newline

sprint_update_cursor:
    mov dl, [sprint_xpos]           ; Move sprint_ypos to dl
    mov dh, [sprint_ypos]           ; Move sprint_ypos to dh
    call cursor_set_pos             ; Update the visible cursor accordingly
    ret

sprint_newline:
    inc byte [sprint_ypos]          ; Set Cursor to the next line
    mov byte [sprint_xpos], 0       ; Reset Cursor to the beginning of the line
    ret

sprint_xpos db 0 ; Horizontal position
sprint_ypos db 0 ; Vertical position