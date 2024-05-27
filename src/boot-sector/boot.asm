[ORG 0x7c00]    ; Set the origin to 0x7c00, where the boot sector is loaded
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

jmp start       ; Jump to the start label

; %include "src/bios/print.asm" ; Imports need to be at the top of the file
%include "src/video-memory/clear-screen.asm"
%include "src/video-memory/sprint.asm"
%include "src/bios/set-cursor-position.asm"

section .text
start:
    xor ax, ax          ; Clear ax
    mov ds, ax          ; Set Data Segment to 0
    mov ss, ax          ; Set Stack Segment to 0
    mov sp, 0x9c00      ; Set Stack Pointer to 0x9c00 (just below the bootloader)

    call clear_screen   ; Call the imported clear screen function

    mov si, msg         ; Load the message into si
    call sprint         ; Call the imported sprint function, loads cursor target position into dx.
    call update_cursor  ; Call the imported set cursor position function


hang:
    jmp hang

msg db 'Hello from the Video Memory!', 0 ; Message to be printed

; Fill the rest of the 512-byte boot sector with zeros
times 510-($-$$) db 0 ; $ is the current address, $$ is the start of the section

; The last two bytes must be 0x55 and 0xAA
dw 0xAA55 ; Could also be written as `db 0x55 \n db 0xAA`
