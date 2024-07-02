; ======================================================
; The bootloader needs to:
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
    ; Prepare an empty screen with the cursor in the top left
    call clear_screen
    mov dh, 0x00
    mov dl, 0x00
    call set_cursor_pos

    ; Right now, we have a weird issue with loading the message using mov si, success_msg
    ; Using mov [ds:si], ax does work perfectly fine, so lodsb works as expected
    ; We somehow need to update ds and si, such that they point to the correct memory location
    ; But first we need a good debug print method for registers and memory locations
    mov si, success_msg
    call sprint

    cli            ; Disable interrupts
    hlt            ; Halt the CPU
    jmp $          ; Infinite loop

section .data
    success_msg db "Welcome", 0x00