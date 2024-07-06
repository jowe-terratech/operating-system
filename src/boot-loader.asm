; ======================================================
; The bootloader needs to:
; - Provide debug utilities
; - Enter protected mode
; - Set the A20 flag
; - Setup a filesystem
; - Load the kernel
; ======================================================
BITS 16
section .bootloader  ; This defines the entry point of the second stage bootloader
jmp main

extern get_cursor_pos
extern set_cursor_pos

%include "src/core/bios/cursor.asm"
%include "src/core/video-memory/clear-screen.asm"
%include "src/core/stdio.asm"


setup:
    ; Prepare the segments for the second stage bootloader
    mov ax, 0x8000      
    mov ds, ax          
    mov es, ax          
    mov fs, ax          
    mov gs, ax          
    mov ss, ax
    ret 

main:
    call setup
    ; Prepare an empty screen with the cursor in the top left
    call clear_screen
    mov dh, 0x00
    mov dl, 0x00
    call set_cursor_pos

    ; mov si, success_msg

    ; push ds
    ; call print_hex_word 

    ; mov dh, 0x00
    ; mov dl, 0x05
    ; call set_cursor_pos

    ; push si
    ; call print_hex_word 


    ; push ds 
    ; call print_hex_word
    ; mov dh, 0x00
    ; mov dl, 0x05
    ; call set_cursor_pos

    mov si, success_msg
    ; push si
    ; call print_hex_word
    ; mov dh, 0x00
    ; mov dl, 0x0A
    ; call set_cursor_pos

    ; TODO: Maybe I can get this to work, 
    ; if I use a stack-based implementation?
    ; Pushing the target message, and popping bytes until
    ; we reach the null terminator?
    call sprint

    ; push success_msg
    ; call print_hex_word

    cli            ; Disable interrupts
    hlt            ; Halt the CPU
    jmp $          ; Infinite loop

print_hex_word:   ; A word is 2 bytes, e.g. 0x1234
    push bp
    mov bp, sp
    mov bx, [bp+4]
    ; pop bx        ; Extract the word from the stack
    ; Extract the first nibble
    mov ax, bx    ; Copy the word to ax
    shr ax, 12     ; Move the highest nibble to the lowest nibble
    call print_hex_nibble
    ; Extract the second nibble
    mov ax, bx    ; Copy the word to ax
    shr ax, 8     ; Move the second highest nibble to the lowest nibble
    call print_hex_nibble
    ; Extract the third nibble
    mov ax, bx    ; Copy the word to ax
    shr ax, 4     ; Move the second lowest nibble to the lowest nibble
    call print_hex_nibble
    ; Extract the fourth nibble
    mov ax, bx    ; Copy the word to ax
    call print_hex_nibble
    pop bp
    ret

print_hex_nibble:
    pusha
    and al, 0xf    ; Mask anything but the lowest nibble
    cmp al, 0xa
    jl .print_digit
    add al, 0x07   ; For letters A-F, add 0x37 to get the ASCII value
    .print_digit:
        add al, 0x30   ; For numbers 0-9, add 0x30 to get the ASCII value
    mov ah, 0x0e
    int 0x10
    popa
    ret

success_msg db "Welcome", 0x00