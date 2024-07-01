
enter_unreal_mode:
    cli             ; Disable Interrupts
    push ds         ; Save Real Mode Data Segment
    lgdt [gdtr]     ; Load GDT

    mov eax, cr0    ; Enable Protected Mode
    or al, 1        ; Set Protected Mode bit
    mov cr0, eax    ; Write back to CR0

    mov bx, 0x08    ; Select Descriptor 1
    mov ds, bx      ; Load Data Segment, 0x08 = 1000b

    and al, 0xFE    ; Clear Protected Mode bit
    mov cr0, eax    ; Write back to CR0 to return to Real Mode

    pop ds          ; Restore Real Mode Data Segment
    sti             ; Enable Interrupts

    ret

verify_unreal_mode:
    ; Write an example value to memory above 1MB
    mov eax, 0x12345678     ; Example value to write
    mov ebx, 0x100000       ; Address above 1MB (1MB + 0)
    mov [ds:ebx], eax       ; Write value to memory above 1MB

    ; Read back the value to verify we are in Unreal Mode
    mov eax, [ds:ebx]       ; Read the value back into eax
    cmp eax, 0x12345678     ; Compare the read value with the original
    jne not_unreal_mode     ; If not equal, jump to error handling

    mov si, unreal_success_msg     ; Load the success message into si
    call sprint             ; Print the verification message
    ret

not_unreal_mode:
    mov si, unreal_error_msg       ; Load the error message into si
    call sprint             ; Print the error message
    ret

unreal_success_msg db 'Entered Unreal-Mode.', 0
unreal_error_msg db 'Unable to enter Unreal-Mode', 0

gdtr:
    dw gdt_end - gdt - 1                        ; Last byte of GDT
    dd gdt                                      ; Address of GDT

gdt dd 0, 0                                     ; Null Descriptor, Required
flatdesc db 0xff, 0xff, 0, 0, 0, 0x92, 0xcf, 0  ; 0x92 = 1001 0010b, 0xcf = 1100 1111b, 0xcf means 1MB - 4GB while 0xc means 64KB - 256MB
gdt_end:
