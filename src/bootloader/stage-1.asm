; ======================================================
; First stage of the 2-stage Bootloader
; Enables unreal mode and then calls the second stage.
; ======================================================

[ORG 0x7c00]    ; Boot sector location
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

global start
jmp start       ; Jump to the start label

%include "src/bootloader/bios.asm"


; Initialize the Boot Sector
section .text

start:
    ; Setup the segment registers
    xor ax, ax              ; Clear ax
    mov ds, ax              ; Set Data Segment to 0
    mov ss, ax              ; Set Stack Segment to 0
    mov sp, 0x9c00          ; Set Stack Pointer to 0x9c00 (below the bootloader)

    ; Log a success message
    mov si, msg
    call sprint 

    jmp $                   ; Infinite loop


msg db 'First stage bootloader loaded successfully!', 0

; Boot Sector Signature
times 510-($-$$) db 0
dw 0xAA55