#include "stdint.h"
#define IDT_ENTRIES 256
extern void isr0();
void idt_set_gate(int num, uint32_t handler, uint16_t selector, uint8_t type_attr);
void idt_init();