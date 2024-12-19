; mbr_detect.s - Functions for detecting MBR partition tables
; Part of Stage 1 bootloader for x86 architecture.

BITS 16                 ; Real mode, 16-bit code

; Function: Detect MBR partition table
; Reads the MBR from LBA 0 (sector 1) and checks for the 0xAA55 signature
detect_mbr_table:
    mov ah, 0x02        ; BIOS interrupt: Read sectors
    mov al, 1           ; Read 1 sector
    mov ch, 0           ; Cylinder 0
    mov cl, 1           ; Sector 1 (LBA 0)
    mov dh, 0           ; Head 0
    mov dl, 0x80        ; Disk 0 (First hard disk)
    mov bx, 0x600       ; Load MBR to 0x0600:0000
    int 0x13            ; BIOS interrupt to read disk
    jc .error           ; If carry flag is set, disk read error

    ; Check MBR boot signature (last two bytes: 0xAA55)
    mov si, 0x600       ; Point to MBR in memory
    add si, 510         ; Move to last two bytes
    mov ax, [si]        ; Load the 2-byte signature into AX
    cmp ax, 0xAA55      ; Check for the MBR signature
    je .success         ; If match, MBR is detected
    stc                 ; Set carry flag to indicate failure
    ret

.success:
    clc                 ; Clear carry flag to indicate success
    ret

.error:
    stc                 ; Set carry flag to indicate error
    ret
