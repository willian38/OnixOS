#include "stdint.h"
#define VGA_ADDRES 0xB8000

void print_string(char* msg, int line) {
    volatile uint16_t* vga = (volatile uint16_t*)VGA_ADDRES;
    char endString = '\0';
    vga += 80 * line;
    while (*msg != endString)
    {
        *vga = (0x0F << 8) | *msg;
        vga++;
        msg++;
    }
}

void print_char(char* msg, int x, int y) {
    volatile uint16_t* vga = (volatile uint16_t*)VGA_ADDRES;
    char endString = '\0';
    vga += x + 80 * y;
    *vga = (0x0F << 8) | *msg;
}
