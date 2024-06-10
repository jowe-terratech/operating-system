; ======================================================
; Second stage of the 2-stage Bootloader
; ======================================================
; [ORG 0x8000]    ; Load address of the second stage bootloader
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

jmp start       ; Jump to the start label

%include "src/bootloader/bios.asm"

section .stage2  ; This defines the entry point of the second stage bootloader

start:
    ; Log a success message
    mov si, msg
    call sprint 

    cli            ; Disable interrupts
    hlt            ; Halt the CPU
    jmp $          ; Infinite loop

msg db 'Second stage bootloader loaded successfully!', 0