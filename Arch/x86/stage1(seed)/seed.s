; Bootloader Stage 1 (Seed)
; Fits in 512 bytes (MBR)
; Assembles with: nasm -f bin -o seed.bin seed.asm

BITS 16               ; 16-bit real mode
ORG 0x7C00            ; BIOS loads the bootloader here

start:
    cli               ; Clear interrupts
    xor ax, ax        ; Zero out AX
    mov ds, ax        ; Set data segment to 0
    mov es, ax        ; Set extra segment to 0

    ; Display a message
    mov si, boot_msg
    call print_string

    ; Load Stage 2 (located on the first sector after MBR)
    mov ah, 0x02      ; BIOS read sectors function
    mov al, 1         ; Read 1 sector
    mov ch, 0         ; Cylinder 0
    mov cl, 2         ; Sector 2 (Stage 2 starts here)
    mov dh, 0         ; Head 0
    mov dl, 0x80      ; First hard disk
    mov bx, 0x600     ; Load Stage 2 to 0x0600:0000
    int 0x13          ; BIOS interrupt to read disk

    jc disk_error     ; Jump if carry flag set (error)

    ; Jump to Stage 2 (0x0600:0000)
    jmp 0x0000:0x0600

disk_error:
    mov si, error_msg
    call print_string
    hlt               ; Halt the CPU

print_string:
    ; Print a null-terminated string pointed by SI
    mov ah, 0x0E      ; Teletype output function
.print_char:
    lodsb             ; Load next character from [SI] into AL
    or al, al         ; Check if character is null
    jz .done          ; If null, end of string
    int 0x10          ; BIOS interrupt to print character
    jmp .print_char
.done:
    ret

boot_msg db "Loading Stage 2...", 0
error_msg db "Disk read error!", 0

times 510-($-$$) db 0 ; Pad with zeros to make 510 bytes
dw 0xAA55             ; Boot signature
