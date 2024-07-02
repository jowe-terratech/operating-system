extern get_cursor_pos
extern set_cursor_pos

sprint:
    ; Prints a null terminated string from si using the video memory.
    ; Updates the cursor accordingly. 
    pusha
    push es

    ; Set the video-memory as target
    mov ax, 0xb800
    mov es, ax

    ; Calculate where we need to display new character
    call get_cursor_pos     ; Loads cursor with dl = x, dh = y
    
    ; Compute the offset from video memory beginning
    movzx ax, dh
    mov cx, 160             ; 80 columns, 2 bytes (char+attr) each
    mul cx
    mov di, 0x00
    add di, cx              ; Offset is read from di
    movzx cx, dl
    shl bx, 1               ; Multiply by 2 with a byte shift
    add di, bx
    
    ; Set the attribute to white on black
    mov ah, 0x0f

    .main:
        lodsb               ; Get the next character al = [ds:si]

        ; Terminate on null character
        or al, al
        jz .done

        ; Display the character
        stosw               ; [ds:di] = ax, di += 2

        jmp .done

        ; Update the cursor, current position still stored in dx
        inc dl
        cmp dl, 81          ; We only have 80 columns
        jne .next

        ; If we get here, we need to go to the next line
        mov dl, 0
        inc dh

    .next:
        call set_cursor_pos
        jmp .main

    .done:
        pop es 
        popa
        ret