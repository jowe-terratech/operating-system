; ==================================================================
; This bootsector simply loads the second stage of the bootloader.
; ==================================================================
BITS 16         ; Specify 16-bit mode, as the CPU starts in real mode

global start    ; Enable linking to the start label
jmp start       ; Jump over the imports


section .text   ; This defines the entry point of the bootloader

start:
    ; Clear the segment registers to prepare code execution
    xor ax, ax              
    mov ds, ax              
    mov es, ax              
    mov ss, ax              
    mov sp, 0x7c00          ; Set Stack Pointer to beginning of the boot sector

    ; Prepare loading of the second stage
    mov ax, 0x8000          ; Address of the second stage bootloader, specified in linker.ld
    mov es, ax              ; Set Extra Segment to 0

    ; Read the disk to load the bootloader into the memory
    mov bx, 0x0000          ; Offset of the second stage bootloader in its segment
    mov ah, 0x02            ; BIOS function to read sectors from disk
    mov al, 0x01            ; Number of sectors to read
    mov ch, 0x00            ; Cylinder number
    mov cl, 0x03            ; Sector number, (second sector)
    mov dh, 0x00            ; Head number
    int 0x13                ; Call the BIOS interrupt, reads to es:bx
    jc .error               ; Jump if carry flag is set, set by the BIOS if an error occurs

    ; Far jump to the second stage
    jmp 0x8000:0x0000
    
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

error_msg db 'Error loading Second Stage.', 0x00

; Boot Sector Signature
times 510-($-$$) db 0
dw 0xAA55