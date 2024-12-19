; gpt_detect.s - Functions for detecting GPT partition tables
; Part of Stage 1 bootloader for x86 architecture.

BITS 16                 ; Real mode, 16-bit code

; Function: Detect GPT partition table
; Reads the GPT Header from LBA 1 (sector 2) and checks for the "EFI PART" signature
detect_gpt:
    mov ah, 0x02        ; BIOS interrupt: Read sectors
    mov al, 1           ; Read 1 sector
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Sector 2 (LBA 1)
    mov dh, 0           ; Head 0
    mov dl, 0x80        ; Disk 0 (First hard disk)
    mov bx, 0x600       ; Load GPT Header to 0x0600:0000
    int 0x13            ; BIOS interrupt to read disk
    jc .error           ; If carry flag is set, disk read error

    ; Check GPT signature (EFI PART)
    mov si, 0x600       ; Point to GPT Header in memory
    mov di, gpt_sig     ; Address of the "EFI PART" signature
    mov cx, 8           ; Length of the GPT signature
    repe cmpsb          ; Compare signature bytes
    jz .success         ; If match, GPT is detected
    stc                 ; Set carry flag to indicate failure
    ret

.success:
    clc                 ; Clear carry flag to indicate success
    ret

.error:
    stc                 ; Set carry flag to indicate error
    ret
