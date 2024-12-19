; seed.s - Detects GPT or MBR on a disk and proceeds to Stage 2 (pit)
; This is Stage 1 of the bootloader for x86 architecture.
; Written for BIOS-based systems in 16-bit real mode.

BITS 16                 ; Real mode, 16-bit code
ORG 0x7C00              ; BIOS loads the bootloader here

; Entry point
start:
    cli                 ; Disable interrupts for safe initialization
    xor ax, ax          ; Zero out AX register
    mov ds, ax          ; Set data segment to 0
    mov es, ax          ; Set extra segment to 0

    ; Display a message indicating we're detecting partition table (GPT/MBR)
    mov si, detect_msg
    call print_string

    ; Attempt to detect GPT partition table
    call detect_gpt
    jc detect_mbr        ; If error reading GPT, jump to MBR detection

    ; GPT detected
    mov si, gpt_found_msg
    call print_string
    jmp continue_boot

detect_mbr:
    ; Attempt to detect MBR partition table
    call detect_mbr_table
    jc disk_error        ; If error reading MBR, jump to error handler

    ; MBR detected
    mov si, mbr_found_msg
    call print_string
    jmp continue_boot

disk_error:
    ; Handle disk read error
    mov si, error_msg
    call print_string
    hlt                 ; Halt the CPU

continue_boot:
    ; Placeholder: Jump to Stage 2 (pit), handling partition entries and kernel loading
    ; Infinite loop for now
    jmp continue_boot

times 510-($-$$) db 0  ; Pad with zeroes to make the bootloader 510 bytes
dw 0xAA55              ; Boot signature (required for bootable disks)
