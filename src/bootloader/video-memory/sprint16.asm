sprint:
    ; ==========================================
    ; sprint - Print a null-terminated string using the video memory
    ; Arguments: 
    ; - si points to the string
    ; ==========================================
    pusha
    push es 
    jmp .sprint_start

    .sprint_next:
        call cprint                 ; Print the next character

    .sprint_start:
        mov ax, 0xb800              ; Video memory segment (color text mode)
        mov es, ax                  ; Set Extra Segment to video memory segment
        cld                         ; Clear the direction flag
        lodsb                       ; Load byte at ds:si into al, increment si because di is clear
        cmp al, 0                   ; Check if byte is null (end of string)
        jne .sprint_next             ; If null, end

    pop es
    popa
    ret

sprint_hex:
    ; ==========================================
    ; sprint_hex - Print a 16-bit number as a 4-digit hex string using the video memory
    ; Arguments:
    ; - al contains the value to print
    ; ==========================================

    ; Clear registers we will use, except al as that is the input
    xor ah, ah
    xor bx, bx
    xor cx, cx

    ; Build a 4-digit hex string
    mov cx, 0x04                ; Set loop counter to 4

    .hex_loop:
        rol ax, 0x04                ; Rotate ax left by 4 bits (1 digit)
        mov bl, al                  ; Move al to bl
        and bl, 0x0f                ; Mask the upper 4 bits
        
        or bl, bl                  ; Check if we reached the end of the number
        je .done                    ; If we did, we are done

        cmp bl, 0x09                ; Check if its a number
        jbe .number                 ; If it is, jump to .number
        add bl, 0x07                ; If not, add 7 to get the correct ASCII value of a-f

    .number:
        add bl, 0x30                ; Convert to ASCII
        mov al, bl                  ; Move bl to al
        call cprint                 ; Print the character
        loop .hex_loop              ; Loop until cx is 0

    .done:

    ret

cprint:
    ; ==========================================
    ; cprint - Print a single character using the video memory
    ; Arguments:
    ; - al contains the character to print
    ; ==========================================
    ; Safe registers: ax, bx, cx
    push ax
    push bx
    push cx

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
    jl .sprint_update_cursor

    ; If xpos >= 80, reset xpos to 0 and increment ypos
    call sprint_newline

    .sprint_update_cursor:
        mov dl, [sprint_xpos]           ; Move sprint_ypos to dl
        mov dh, [sprint_ypos]           ; Move sprint_ypos to dh
        call cursor_set_pos             ; Update the visible cursor accordingly

    ; Restore registers
    pop cx
    pop bx
    pop ax

    ret

sprint_newline:
    inc byte [sprint_ypos]          ; Set Cursor to the next line
    mov byte [sprint_xpos], 0       ; Reset Cursor to the beginning of the line
    ret

sprint_xpos db 0 ; Horizontal position
sprint_ypos db 0 ; Vertical position