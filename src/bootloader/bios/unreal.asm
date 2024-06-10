enable_unreal:
    ; ==========================================
    ; enable_unreal - Enables 32 bit addressing
    ; ==========================================
    
    ; Load the GDT
    cli             ; We need to disable interrupts before replacing the GDT
    push ds         ; Save real mode data segment
    lgdt [gdtr]     ; Load the GDT defined below

    ; Enable protected mode
    mov eax, cr0    ; Get the current value of CR0
    or eax, 1       ; Set the protected mode bit
    mov cr0, eax    ; Enable protected mode by writing back to CR0

    ; Unlock 32 bit addressing
    mov bx, 0x08    ; Select Descriptor 1
    mov ds, bx      ; Load the data segment register, 0x08 = 1000b

    ; Disable protected mode
    mov al, 0xFE    ; Clear the protected mode bit
    mov cr0, eax    ; Disable protected mode by writing back to CR0

    ; Prepare return to real mode
    pop ds          ; Restore real mode data segment
    sti             ; Re-enable interrupts
    ret

verify_unreal:
    ; ==========================================
    ; verify_unreal - Verify that we are in 32 bit mode
    ; by writing to an address above 1MB
    ; Returns:
    ;   al = 1 if we are in 32 bit mode
    ;   al = 0 if we are not in 32 bit mode
    ; ==========================================
    
    ; Write an arbitrary value to an address above 1MB
    mov eax, 0x12345678 ; Arbitrary value
    mov ebx, 0x1000000  ; Address above 1MB (1MB + 0)
    mov [ds:ebx], eax   ; Write the value to the address in the data segment

    ; Try to read the value back
    mov eax, [ds:ebx]   ; Read the value back
    cmp eax, 0x12345678 ; Compare the value
    jne .error          ; If the value is not the same, we are not in 32 bit mode

    ; We are in 32 bit mode
    xor al, al
    mov al, 0x01
    ret

    .error:
        xor al, al
        mov al, 0x00
        ret

gdtr:
    dw gdt_end - gdt - 1                        ; Last byte of GDT
    dd gdt                                      ; Address of GDT

gdt dd 0, 0                                     ; Null Descriptor, Required
flatdesc db 0xff, 0xff, 0, 0, 0, 0x92, 0xcf, 0  ; 0x92 = 1001 0010b, 0xcf = 1100 1111b, 0xcf means 1MB - 4GB while 0xc means 64KB - 256MB
gdt_end: