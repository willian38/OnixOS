; ---------------------------------------------------------------------
; The bootloader for Jazz (github.com/coditva/Jazz)
; Author: Utkarsh Maheshwari
; vi:filetype=nasm
; ---------------------------------------------------------------------


bits  16
org   0x7c00
; enable A20 bit
mov [boot_drive], dl

load_kernel:
    mov bx, 0x1000
    mov ah, 0x02        ; INT 13h - ler setores
    mov al, 100          ; número de setores
    mov ch, 0           ; cilindro
    mov cl, 2           ; setor (1 = bootloader, então começa no 2)
    mov dh, 0           ; cabeça
    mov dl, [boot_drive]        ; HD (0x00 = floppy, 0x80 = HDD)

    int 0x13

    jmp 0x1000
; ---------------------------------------------------------------------
; we will enter 32bit protected mode now
; but first, gotta setup a Global Descriptor Table (GDT)
    
; ---------------------------------------------------------------------
; define the data structure for a GDT

boot_drive db 0
; ---------------------------------------------------------------------
; setup complete, let's get into 32bit!

; ---------------------------------------------------------------------
; mark this as bootable

times 510-($-$$) db 0     ; fill the remaining memory with 0
dw 0xaa55      ; add the magic number
