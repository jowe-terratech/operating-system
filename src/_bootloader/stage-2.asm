; ======================================================
; Second stage of the 2-stage Bootloader
; ======================================================
BITS 16
section .stage2  ; This defines the entry point of the second stage bootloader
jmp main

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
    ; Empty screen and set cursor to the top left corner
    call clear_screen
    xor dx, dx
    call cursor_set_pos

    mov al, 0x30
    call cprint

    cli            ; Disable interrupts
    hlt            ; Halt the CPU
    jmp $          ; Infinite loop

%include "src/bootloader/bios/cursor.asm"
%include "src/bootloader/video-memory/clear-screen.asm"
%include "src/bootloader/video-memory/sprint16.asm"