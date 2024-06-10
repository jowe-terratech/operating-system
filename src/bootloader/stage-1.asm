; ======================================================
; First stage of the 2-stage Bootloader
; Enables unreal mode and then calls the second stage.
; ======================================================
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

global start
jmp start       ; Jump to the start label

%include "src/bootloader/bios/bprint.asm"
%include "src/bootloader/bios/cursor.asm"
%include "src/bootloader/bios/unreal.asm"
%include "src/bootloader/video-memory/clear-screen.asm"
%include "src/bootloader/video-memory/sprint16.asm"


section .text   ; This defines the entry point of the bootloader

start:
    ; Setup the segment registers
    xor ax, ax              ; Clear ax
    mov dx, ax              ; Clear dx
    mov ds, ax              ; Set Data Segment to 0
    mov ss, ax              ; Set Stack Segment to 0
    mov sp, 0x9c00          ; Set Stack Pointer to 0x9c00 (below the bootloader)

    ; Clear the screen before printing anything
    call clear_screen

    ; Set cursor position to 0, 0
    call cursor_set_pos     ; dx is already 0

    ; Log a success message
    mov si, success_msg
    call sprint_with_newline

    ; Enter unreal mode to support 32-bit addressing
    call enable_unreal
    call verify_unreal      ; Sets al to 0x01 if unreal mode is enabled, 0x00 otherwise
    ; Check if unreal mode was enabled
    cmp al, 0x01
    mov si, unreal_error_msg
    jne error              

    ; Log a success message
    mov si, unreal_success_msg
    call sprint_with_newline

    ; Load the second stage bootloader
    mov ax, 0x8000          ; Address of the second stage bootloader, specified in linker.ld
    mov es, ax              ; Set Extra Segment to 0x8000

    ; BIOS interrupt to read disk sectors
    mov bx, 0x0000          ; Offset of the second stage bootloader in its segment
    mov ah, 0x02            ; BIOS function to read sectors from disk
    mov al, 0x01            ; Number of sectors to read
    mov ch, 0x00            ; Cylinder number
    mov cl, 0x02            ; Sector number, (second sector)
    mov dh, 0x00            ; Head number
    int 0x13                ; Call the BIOS interrupt

    ; Show an error message if we couldn't load the second stage bootloader
    mov si, error_msg
    jc error                ; Jump if carry flag is set, set by the BIOS if an error occurs

    ; Call the second stage bootloader
    jmp 0x8000:0x0000       ; Far jump to the second stage bootloader

    jmp $                   ; Infinite loop

error:
    call sprint
    jmp $

success_msg db 'First stage bootloader loaded successfully!', 0x00
error_msg db 'Error loading the second stage bootloader!', 0x00

unreal_success_msg db 'Entered Unreal-Mode.', 0x00
unreal_error_msg db 'Unable to enter Unreal-Mode', 0x00

; Boot Sector Signature
times 510-($-$$) db 0
dw 0xAA55