; Second stage of the 2-stage Bootloader
BITS 16
section .stage2

bootloader:
    ; Log a success message
    mov si, success_msg
    call sprint
    
    jmp 0x0000:0x7c00   ; Jump to the bootloader

    cli             ; Disable interrupts
    hlt             ; Halt the CPU
    jmp $           ; Infinite loop

success_msg db 'Second stage bootloader loaded successfully!', 0x00

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