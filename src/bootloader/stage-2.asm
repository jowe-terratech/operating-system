; ======================================================
; Second stage of the 2-stage Bootloader
; ======================================================

BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

jmp start       ; Jump to the start label

%include "src/bootloader/bios.asm"

section .text
start:
    ; Log a success message
    mov si, msg
    call sprint 

    cli            ; Disable interrupts
    hlt            ; Halt the CPU
    jmp $          ; Infinite loop

msg db 'Second stage bootloader loaded successfully!', 0