bits 16
;Define as Variaveis globais para o C poder usar em algumas configurações
global boot
global CODE_SEG
global DATA_SEG
boot:
;Pede para a Bios colocar o modo de video em modo de texto
mov ah, 00h
mov al, 03h
int 0x10

;Função da Bios para ativar a linha A20
mov ax, 0x2401
int 0x15

;Necessario dativar interrupçoes para carregar a GDT(Global Descriptor Table)
cli
lgdt [gdt_pointer]
;Agora precisamos ativar o registrador da cpu CR0 para ativar o modo 32 Bits(Modo Protegido)
mov  eax, cr0
or   eax, 0x1
mov  cr0, eax

;Agora é nessessário um pulo longo para setar o registrador CS (Code Segment)
jmp CODE_SEG:boot2
hlt

; GDT -------------------------- GDT
gdt_start:
  dq 0x0
gdt_code:
  dw 0xFFFF
  dw 0x0
  db 0x0
  db 0x9a
  db 0xCF
  db 0x0
gdt_data:
  dw 0xFFFF
  dw 0x0
  db 0x0
  db 0x92
  db 0xCF
  db 0x0
gdt_end:

gdt_pointer:
  dw gdt_end - gdt_start - 1
  dd gdt_start

; ---------------------------------------------------------------------

;Aqui é definido onde fica na GDT o Code Segmente e Data Segment
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

;Aqui estamos oficialmente em Modo Protegido 32 Bits
bits 32
boot2:
;Desativando as interrupçoes para configurar os registradores com o DATA_SEG (Segmento de dados da GDT)
cli
mov ax, DATA_SEG
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
mov esp, stack_end
mov ebp, esp
cld
[extern kernel_main]
jmp kernel_main
hlt

;Aqui chamamos as interrupçoes da IDT
;Definimos manualmente cada uma e qual codigo do Kernel Chamar
;Chamamos isso de ISR, basicamente onde ficam os handlers das instruções
global isr0
isr0:
  cli
  jmp $
  hlt

;Aqui definimos um tamanho para a noss stack, e ela é beeemm grande
;Definimos ela nos registradores ESP e EBP
SECTION .bss
stack_start: resb (1024 * 1024 * 10)
stack_end: