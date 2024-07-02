clear_screen:
    pusha
    push di
    push es 

    ; Set the video-memory as target
    mov ax, 0xb800
    mov es, ax

    ; Setup the main-loop
    ; We want to clear 80 columns * 25 rows = 2000
    mov cx, 2000

    .clear:
        mov ax, 0x0f20 ; Write a black on white space character.
        stosw          ; [es:di] = ax, di += 2
        loop .clear

    ; Restore register state
    pop es
    pop di
    popa
    ret