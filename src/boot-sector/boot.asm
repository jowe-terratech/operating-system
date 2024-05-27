[ORG 0x7c00]    ; Set the origin to 0x7c00, where the boot sector is loaded
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

jmp start       ; Jump to the start label

%include "src/bios/print.asm" ; Imports need to be at the top of the file

section .text
start:
    xor ax, ax ; Clear ax
    mov ds, ax ; Set ds to 0
    mov si, msg ; Set si to the address of the message

    call bios_print_start ; Call the imported BIOS print function

hang:
    jmp hang

msg db 'Hello, World!', 13, 10, 0 ; String, newline, carriage return, null terminator

; Fill the rest of the 512-byte boot sector with zeros
times 510-($-$$) db 0 ; $ is the current address, $$ is the start of the section

; The last two bytes must be 0x55 and 0xAA
dw 0xAA55 ; Could also be written as `db 0x55 \n db 0xAA`
