#include "stdint.h"
#include "io.h"
#define PCI_CONFIG_ADDRES 0xCF8
#define PCI_CONFIG_DATA 0xCFC

uint32_t pci_read(uint8_t bus, uint8_t device, uint8_t func, uint8_t offset) {
    uint32_t addres = (1 << 31) | 
                        (bus << 16) |
                        (device << 11) |
                        (func << 8) |
                        (offset & 0xFC);
    
    outl(PCI_CONFIG_ADDRES, addres);
    return inl(PCI_CONFIG_DATA);
}