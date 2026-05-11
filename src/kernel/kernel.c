#include "stdint.h"
#include "idt.h"
#include "io.h"
#include "pci.h"
#include "../drivers/vga_text.h"
char msg[] = "OnixOS 0.0.1b01";

//Função main do kernel, chamado pelo assembly
//essa função vamos usar para Definir e Configurar algumas coisas
void kernel_main() {
    print_string(msg, 0);
    cli(); //Desativa as interrupçoes
    idt_init();
    while (1)
    {
       
    }
}
