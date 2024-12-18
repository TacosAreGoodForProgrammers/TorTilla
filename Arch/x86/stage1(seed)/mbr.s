; mbr.s - Detects MBR on a disk using BIOS interrupts
; This is Stage 1 of the bootloader (seed.s) for x86 architecture.

BITS 16                 ; Real mode, 16-bit code
ORG 0x7C00              ; BIOS loads the bootloader here

start:
    cli                 ; Clear interrupts
    xor ax, ax          ; Zero out AX
    mov ds, ax          ; Set data segment to 0
    mov es, ax          ; Set extra segment to 0

    ; Display a message indicating we're detecting MBR
    mov si, mbr_msg
    call print_string

    ; Read MBR (first sector, LBA 0)
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

    ; If signature does not match, display error
    jmp not_mbr_error

is_mbr:
    ; MBR detected, proceed to load partition entries or Stage 2
    mov si, mbr_found_msg
    call print_string
    ; Proceed to Stage 2 (loading partition entry table)...
    jmp continue_boot

not_mbr_error:
    ; Not a valid MBR disk, handle the error
    mov si, not
