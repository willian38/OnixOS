#include "stdint.h"
#define IDT_ENTRIES 256
//define que a função que será o handler está no assembly, por isso usamos EXTERN
extern void isr0();

//Criando a IDT
//Basicamente isso descreve uma unica chamada
//@offset_low é o endereço da instrução
//@selector segmento de codigo da GDT
//@zero é sempre zero

struct idt_entry {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t zero;
    uint8_t type_attr;
    uint16_t offset_high;
} __attribute__((packed));

//@idt_ptr é basicmente uma descrição para o processador de onde está a IDT, basicamente um ponteiro
struct idt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

//Aqui definimos a IDT
struct idt_entry idt[IDT_ENTRIES];
struct idt_ptr idt_descriptor;
//Aqui essa função seta os parametros de cada Interrupção, colocando o endereço da função (Handler), o tipo da Interrupção...
//...Podendo ser 0 modo kernel ou Modo Usuario
void idt_set_gate(int num, uint32_t handler, uint16_t selector, uint8_t type_attr) {
    idt[num].offset_low = handler & 0xFFFF;
    idt[num].selector = selector;
    idt[num].zero = 0;
    idt[num].type_attr = type_attr;
    idt[num].offset_high = (handler >> 16) & 0xFFFF;
}

void idt_init() {
    idt_descriptor.limit = sizeof(idt) - 1;
    idt_descriptor.base = (uint32_t)&idt;

    idt_set_gate(0, (uint32_t)isr0, 0x08, 0x8E);

    asm volatile ("lidt %0" : : "m"(idt_descriptor));
}