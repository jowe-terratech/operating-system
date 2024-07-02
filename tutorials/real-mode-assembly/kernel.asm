[ORG 0x7c00]    ; Set the origin to 0x7c00, where the boot sector is loaded
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

setup:
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00 ; Set the stack pointer to the beginning of the boot sector

main:
    mov si, prompt
    call sprint

    mov di, buffer
    call getstr

    ; Check if the buffer (user input) is empty
    mov si, buffer
    cmp byte [si], 0
    je main

    ; ========================
    ; Check for commands 
    ; ========================

    ; Check for the command "hi"
    mov si, buffer
    mov di, cmd_hi
    call strcmp
    jc .helloworld

    ; Check for the command "help"
    mov si, buffer
    mov di, cmd_help
    call strcmp
    jc .help

    ; If we get here, the command is invalid
    jmp .bad_command

.helloworld:
    mov si, msg_helloworld
    call sprint
    jmp main

.help:
    mov si, msg_help
    call sprint
    jmp main

.bad_command:
    mov si, msg_bad
    call sprint
    jmp main

; 0x0d = CR (Cursor to start of line), 0x0a = LF (Cursor to next line), 0 = Null terminator
welcome db 'Welcome to the Kernel!', 0x0d, 0x0a, 0 
prompt db '> ', 0
buffer times 64 db 0

; Predefined messages
msg_helloworld db 'Hello, World!', 0x0d, 0x0a, 0
msg_help db 'Available commands: hello, help', 0x0d, 0x0a, 0
msg_bad db 'Invalid command', 0x0d, 0x0a, 0

; Available commands
cmd_hi db 'hi', 0
cmd_help db 'help', 0

; ========================
; Functions of the kernel
; ========================
sprint:
    lodsb ; Load byte from si into al and increment si

    ; Check if the byte is null
    or al, al 
    jz .done

    ; Call the BIOS teletype function
    mov ah, 0x0e
    int 0x10
    
    jmp sprint

    .done:
        ret

getstr:
    xor cl, cl ; Clear cl

    .readchar:
        ; Wait for a key press using BIOS interrupt 0x16
        mov ah, 0
        int 0x16

        ; Special Case: Backspace
        cmp al, 0x08
        je .backspace

        ; Special Case: Enter
        cmp al, 0x0d
        je .done

        ; Almost at the end of buffer? Only allow backspace and enter
        cmp cl, 63
        je .readchar

        ; Display the character just read using BIOS teletype function
        mov ah, 0x0e
        int 0x10

        ; Store the character in the buffer
        stosb ; Store al in [di] and increment (decrement if direction flag is set) di
        inc cl
        jmp .readchar

    .backspace:
        ; Ignore backspace if buffer is empty
        cmp cl, 0
        je .readchar

        ; Clear the last character in the buffer
        dec di
        mov byte [di], 0
        dec cl

        ; Backspace on the screen
        mov ah, 0x0e
        mov al, 0x08
        int 0x10

        ; Clear the character from the screen by overwriting it with a space
        mov al, 0x20
        int 0x10

        ; Move the cursor back
        mov al, 0x08
        int 0x10

        jmp .readchar

    .done:
        ; Null terminate the buffer
        mov al, 0
        stosb

        ; Add a new line
        mov ah, 0x0e
        mov al, 0x0d
        int 0x10
        mov al, 0x0a
        int 0x10

        ret

strcmp:
    .loop:
        ; Load the next byte from si and di
        mov al, [si]
        mov bl, [di]
        
        ; Check if the bytes are equal
        cmp al, bl
        jne .notequal

        ; End of string?
        or al, al
        jz .equal

        ; Go to the next byte
        inc si
        inc di
        jmp .loop

    .equal:
        stc ; Set the carry flag
        ret

    .notequal:
        clc ; Clear the carry flag
        ret

; Set the boot signature
times 510-($-$$) db 0 ; Fill the rest of the boot sector with zeros
dw 0xaa55 ; Boot signature




