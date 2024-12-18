; seed.s - Detects GPT or MBR on a disk and proceeds to Stage 2 (pit)
; This is Stage 1 of the bootloader for x86 architecture.

BITS 16                 ; Real mode, 16-bit code
ORG 0x7C00              ; BIOS loads the bootloader here

start:
    cli                 ; Clear interrupts
    xor ax, ax          ; Zero out AX
    mov ds, ax          ; Set data segment to 0
    mov es, ax          ; Set extra segment to 0

    ; Display a message indicating we're detecting partition table (GPT/MBR)
    mov si, detect_msg
    call print_string

    ; Try reading GPT first (LBA 1, sector 1)
    mov ah, 0x02        ; BIOS interrupt: Read sectors
    mov al, 1           ; Read 1 sector
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Sector 2 (LBA 1)
    mov dh, 0           ; Head 0
    mov dl, 0x80        ; Disk 0 (First hard disk)
    mov bx, 0x600       ; Load GPT Header to 0x0600:0000
    int 0x13            ; BIOS interrupt to read disk

    jc mbr_detect       ; If carry flag is set, there's an error reading, try MBR

    ; Check GPT signature (EFI PART)
    mov si, 0x600       ; Point to the GPT Header (memory location)
    mov di, gpt_sig     ; The "EFI PART" signature
    mov cx, 8           ; GPT signature length
    repe cmpsb          ; Compare the bytes of the signature
    jz is_gpt           ; If the signature matches, it's GPT

mbr_detect:
    ; If we reach here, GPT was not detected. Try MBR (LBA 0, sector 0)
    mov ah, 0x02        ; BIOS interrupt: Read sectors
    mov al, 1           ; Read 1 sector
    mov ch, 0           ; Cylinder 0
    mov cl, 1           ; Sector 1 (LBA 0)
    mov dh, 0           ; Head 0
    mov dl, 0x80        ; Disk 0 (First hard disk)
    mov bx, 0x600       ; Load MBR to 0x0600:0000
    int 0x13            ; BIOS interrupt to read disk

    jc disk_error       ; If carry flag is set, there's an error reading

    ; Check MBR boot signature (last two bytes: 0xAA55)
    mov si, 0x600       ; Point to the MBR (memory location)
    add si, 510         ; Move to the last 2 bytes
    mov ax, [si]        ; Load the 2-byte signature into AX
    cmp ax, 0xAA55      ; Check for the boot signature
    je is_mbr           ; If signature matches, it's MBR

    ; If neither GPT nor MBR is detected, display error
    jmp not_partition_error

is_gpt:
    ; GPT detected, proceed to Stage 2 (pit) for GPT
    mov si, gpt_found_msg
    call print_string
    ; Proceed to Stage 2 (processing GPT partitions)...
    jmp continue_boot

is_mbr:
    ; MBR detected, proceed to Stage 2 (pit) for MBR
    mov si, mbr_found_msg
    call print_string
    ; Proceed to Stage 2 (processing MBR partitions)...
    jmp continue_boot

not_partition_error:
    ; Neither GPT nor MBR detected, handle the error
    mov si, not_partition_msg
    call print_string
    jmp disk_error

disk_error:
    mov si, error_msg
    call print_string
    hlt                   ; Halt the CPU

continue_boot:
    ; Placeholder: Jump to Stage 2 (pit), handling partition entries and kernel loading
    ; This would involve loading the kernel based on partition entries.
    ; Here, we'll just loop for now.
    jmp continue_boot

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

; Messages
detect_msg db "Detecting GPT or MBR...", 0
gpt_sig db "EFI PART", 0       ; GPT Header signature
gpt_found_msg db "GPT Disk Found.", 0
mbr_found_msg db "MBR Disk Found.", 0
not_partition_msg db "No valid partition table found!", 0
error_msg db "Disk read error!", 0

times 510-($-$$) db 0  ; Pad with zeroes to 510 bytes
dw 0xAA55             ; Boot signature (MBR signature)
