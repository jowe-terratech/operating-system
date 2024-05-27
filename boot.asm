[ORG 0x7c00]    ; Set the origin to 0x7c00, where the boot sector is loaded
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

section .text
start:
    xor ax, ax ; Clear ax
    mov ds, ax ; Set ds to 0
    mov si, msg ; Set si to the address of the message
    cld ; Clear the direction flag, so we can move forward in the string

print:
    lodsb ; Load the byte at si into al, and increment si
    or al, al ; Equals zero if we've reached the end of the string
    jz hang ; If al is zero, jump to hang
    ; Otherwise we print the character
    mov ah, 0x0e ; Set ah to 0x0e, the BIOS teletype function
    mov bh, 0 ; Set bh to 0, the page number
    int 0x10 ; Call the BIOS teletype function
    jmp print ; Jump back to print the next character

hang:
    jmp hang

msg db 'Hello, World!', 13, 10, 0 ; String, newline, carriage return, null terminator

; Fill the rest of the 512-byte boot sector with zeros
times 510-($-$$) db 0 ; $ is the current address, $$ is the start of the section

; The last two bytes must be 0x55 and 0xAA
dw 0xAA55 ; Could also be written as `db 0x55 \n db 0xAA`
