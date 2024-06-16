; ======================================================
; Second stage of the 2-stage Bootloader
; ======================================================
BITS 16
section .stage2  ; This defines the entry point of the second stage bootloader

start:
    mov ax, 0x8000      ; The address where we loaded the second stage bootloader
    mov ds, ax          ; Set the data segment to the address where we loaded the second stage bootloader
    mov es, ax          ; Set the extra segment to the address where we loaded the second stage bootloader
    mov fs, ax          ; Set the fs segment to the address where we loaded the second stage bootloader
    mov gs, ax          ; Set the gs segment to the address where we loaded the second stage bootloader
    mov ss, ax          ; Set the stack segment to the address where we loaded the second stage bootloader

    call clear_screen
    ; jmp 0x0000:0x7c00   ; Jump to the bootloader


    cli            ; Disable interrupts
    hlt            ; Halt the CPU
    jmp $          ; Infinite loop

msg db 'Second stage bootloader loaded successfully!', 0x00

clear_screen:
    ; Save variables that will be used
    push di
    pusha

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
    popa
    pop di
    ret