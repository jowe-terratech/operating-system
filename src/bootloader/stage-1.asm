; ======================================================
; First stage of the 2-stage Bootloader
; Enables unreal mode and then calls the second stage.
; ======================================================
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

global start    ; Enable linking to the start label
jmp start       ; Jump over the imports

%include "src/bootloader/bios/unreal.asm"

section .text   ; This defines the entry point of the bootloader

start:
    ; Setup the segment registers
    xor ax, ax              ; Clear ax
    mov ds, ax              ; Set Data Segment to 0
    mov es, ax              ; Set Extra Segment to 0
    mov ss, ax              ; Set Stack Segment to 0
    mov sp, 0x7c00          ; Set Stack Pointer to beginning of the boot sector

    ; Log a success message
    mov si, success_msg
    call sprint

    ; Load the second stage
    mov ax, 0x8000          ; Address of the second stage bootloader, specified in linker.ld
    mov es, ax              ; Set Extra Segment to 0

    mov bx, 0x0000          ; Offset of the second stage bootloader in its segment
    mov ah, 0x02            ; BIOS function to read sectors from disk
    mov al, 0x01            ; Number of sectors to read
    mov ch, 0x00            ; Cylinder number
    mov cl, 0x03            ; Sector number, (second sector)
    mov dh, 0x00            ; Head number
    int 0x13                ; Call the BIOS interrupt
    jc .error               ; Jump if carry flag is set, set by the BIOS if an error occurs

    ; Log a success message
    mov si, read_success_msg
    call sprint

    call print_second_stage_bytes

    jmp 0x8000:0x0000       ; Jump to the second stage bootloader

    
    .error:
        mov si, error_msg
        call sprint
        jmp $

sprint:
    lodsb                   ; Load the next byte from si into al
    
    ; Print if al is not null
    or al, al               ; Check if al is null
    jz .done                ; If al is null, we are done
    
    mov ah, 0x0e            ; Set the BIOS teletype function
    int 0x10                ; Call the BIOS teletype function
    
    jmp sprint              ; Repeat the process
    
    .done:
        ; Add a newline
        mov al, 0x0d       ; Move to the beginning of the line
        int 0x10           ; Call the BIOS teletype function
        mov al, 0x0a       ; Move to the next line
        int 0x10           ; Call the BIOS teletype function
        ret

print_second_stage_bytes:
    mov ax, 0x8000
    mov ds, ax
    mov si, 0x0000
    mov cx, 128              ; Number of bytes to print
    xor dx, dx              ; Reset counter for spacing

.print_loop:
    lodsb                   ; Load byte at ds:si into al
    call print_hex_byte     ; Print the byte in al as hex

    inc dx                  ; Increment byte counter
    cmp dx, 2               ; Check if 2 bytes (4 hex digits) have been printed
    jne .no_space           ; If not, skip space printing
    call print_space        ; Print a space
    xor dx, dx              ; Reset the counter

.no_space:
    loop .print_loop        ; Repeat until cx is 0
    ret

print_hex_byte:
    pusha
    mov bl, al              ; Save the byte in bl

    ; Print high nibble
    mov al, bl
    shr al, 4               ; Shift right to get the high nibble
    call nibble_to_hex      ; Convert and print

    ; Print low nibble
    mov al, bl
    and al, 0x0F            ; Mask to get the low nibble
    call nibble_to_hex      ; Convert and print

    popa
    ret

nibble_to_hex:
    ; Convert nibble in al to hex character and print
    cmp al, 10
    jl .print_digit
    add al, 'A' - 10        ; Convert 10-15 to 'A'-'F'
    jmp .print

.print_digit:
    add al, '0'             ; Convert 0-9 to '0'-'9'

.print:
    mov ah, 0x0e            ; BIOS teletype function
    int 0x10                ; Call BIOS to print character in al
    ret

print_space:
    pusha
    mov al, ' '
    mov ah, 0x0e            ; BIOS teletype function
    int 0x10                ; Call BIOS to print character in al
    popa
    ret

success_msg db 'First Stage loaded.', 0x00
unreal_success_msg db 'Entered Unreal-Mode.', 0x00
unreal_error_msg db 'Error entering Unreal-Mode.', 0x00
read_success_msg db 'Second Stage read.', 0x00
error_msg db 'Error loading Second Stage.', 0x00

; Boot Sector Signature
times 510-($-$$) db 0
dw 0xAA55