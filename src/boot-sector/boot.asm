[ORG 0x7c00]    ; Set the origin to 0x7c00, where the boot sector is loaded
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

jmp start       ; Jump to the start label

; %include "src/bios/print.asm" ; Imports need to be at the top of the file
%include "src/video-memory/clear-screen.asm"
%include "src/video-memory/sprint16.asm"
%include "src/bios/cursor.asm"
%include "src/interrupt-service-routines/keyboard-interrupt.asm"
%include "src/bios/unreal-mode.asm"

section .text
start:
    xor ax, ax              ; Clear ax
    mov ds, ax              ; Set Data Segment to 0
    mov ss, ax              ; Set Stack Segment to 0
    mov sp, 0x9c00          ; Set Stack Pointer to 0x9c00 (just below the bootloader)

    call clear_screen       ; Call the imported clear screen function

    mov si, msg             ; Load the message into si
    call sprint             ; Call the imported sprint function, loads cursor target position into dx.
    call ivt_iqr1           ; Setup the keyboard interrupt handler

    call enter_unreal_mode  ; Enter Unreal Mode
    call newline            ; Move the cursor to the next line
    call verify_unreal_mode ; Verify Unreal Mode

    jmp $                   ; Infinite loop

msg db 'Hello from the Video Memory!', 0
port60 dw 0 ; Placeholder for values read from port 0x60 (keyboard input)

; Fill the rest of the 512-byte boot sector with zeros
times 510-($-$$) db 0 ; $ is the current address, $$ is the start of the section

; The last two bytes must be 0x55 and 0xAA
dw 0xAA55 ; Could also be written as `db 0x55 \n db 0xAA`