sprint_next:
    call cprint                 ; Print the next character

sprint:                         ; string = si
    cld                         ; Clear the direction flag
    lodsb                       ; Load byte at ds:esi into al, increment esi
    cmp al, 0                   ; Check if byte is null (end of string)
    jne sprint_next             ; If null, end
    ret

cprint:                             ; character = al
    mov ah, 0x0f                    ; Set the attribute to white on black
    mov ecx, eax                      ; Save character+attribute in ecx
    movzx eax, byte [sprint_ypos]    ; Move sprint_ypos to eax
    mov edx, 160                     ; 2 bytes per character, 80 characters per line
    mul edx                          ; Calculate row offset
    movzx ebx, byte [sprint_xpos]    ; Move sprint_xpos to ebx
    shl ebx, 1                       ; 2 bytes per character, so we need to multiply by 2

    mov edi, 0xb8000                ; Can use 2.5 bytes in 32-bit mode to specify video memory
    add edi, eax                      ; Add the row offset
    add edi, ebx                      ; Add the column offset

    mov eax, ecx                      ; Move character+attribute to ax
    mov word [ds:edi], ax             ; Write character+attribute to video memory
    add byte [sprint_xpos], 1       ; Move to the next character
    mov dl, [sprint_xpos]           ; Move sprint_xpos to dl

    ; Check if we need to wrap to the next line
    cmp byte [sprint_xpos], 80
    jl sprint_no_wrap

    ; If xpos >= 80, reset xpos to 0 and increment ypos
    call newline

sprint_no_wrap:
    mov dl, [sprint_xpos]           ; Move sprint_ypos to dl
    mov dh, [sprint_ypos]           ; Move sprint_ypos to dh
    call set_cursor_pos             ; Update the visible cursor accordingly
    ret

newline:
    inc byte [sprint_ypos]          ; Set Cursor to the next line
    mov byte [sprint_xpos], 0       ; Reset Cursor to the beginning of the line
    ret

move_cursor_right:
    mov ah, 0x02    ; BIOS function to set cursor position
    mov bh, 0x00    ; page number
    int 0x10        ; call BIOS
    ret

sprint_xpos db 0 ; Horizontal position
sprint_ypos db 0 ; Vertical position