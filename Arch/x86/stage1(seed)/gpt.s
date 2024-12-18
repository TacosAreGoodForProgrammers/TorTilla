; gpt.s - Detects GPT on a disk using BIOS interrupts
; This is Stage 1 of the bootloader (seed.s) for x86 architecture.

BITS 16                 ; Real mode, 16-bit code
ORG 0x7C00              ; BIOS loads the bootloader here

start:
    cli                 ; Clear interrupts
    xor ax, ax          ; Zero out AX
    mov ds, ax          ; Set data segment to 0
    mov es, ax          ; Set extra segment to 0

    ; Display a message indicating we're detecting GPT
    mov si, gpt_msg
    call print_string

    ; Read GPT Header from LBA 1 (sector 1)
    mov ah, 0x02        ; BIOS interrupt: Read sectors
    mov al, 1           ; Read 1 sector
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Sector 2 (LBA 1)
    mov dh, 0           ; Head 0
    mov dl, 0x80        ; Disk 0 (First hard disk)
    mov bx, 0x600       ; Load GPT Header to 0x0600:0000
    int 0x13            ; BIOS interrupt to read disk

    jc disk_error       ; If carry flag is set, there's an error reading

    ; Check GPT signature at the beginning of the GPT Header
    mov si, 0x600       ; Point to the GPT Header (memory location)
    mov di, gpt_sig     ; The "EFI PART" signature
    mov cx, 8           ; GPT signature length
    repe cmpsb          ; Compare the bytes of the signature
    jz is_gpt           ; If the signature matches, it's GPT

    ; If signature does not match, display error
    jmp not_gpt_error

is_gpt:
    ; GPT detected, proceed to load partition entries or Stage 2
    mov si, gpt_found_msg
    call print_string
    ; Proceed to Stage 2 (loading partition entry array)...
    jmp continue_boot

not_gpt_error:
    ; Not a GPT disk, handle the error
    mov si, not_gpt_msg
    call print_string
    jmp disk_error

disk_error:
    mov si, error_msg
    call print_string
    hlt                   ; Halt the CPU

print_string:
    ; Print a null-terminated string pointed to by SI
    mov ah, 0x0E          ; Teletype output function
.print_char:
    lodsb                 ; Load next byte from [SI] into AL
    or al, al             ; Check if it's null (end of string)
    jz .done              ; If null, end of string
    int 0x10              ; BIOS interrupt to print character
    jmp .print_char
.done:
    ret

gpt_msg db "Detecting GPT...", 0
gpt_sig db "EFI PART", 0       ; GPT Header signature
gpt_found_msg db "GPT Disk Found.", 0
not_gpt_msg db "Not a GPT disk!", 0
error_msg db "Disk read error!", 0

times 510-($-$$) db 0  ; Pad with zeroes to 510 bytes
dw 0xAA55             ; Boot signature
