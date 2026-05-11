#include "stdint.h"
#include "io.h"
#define PCI_CONFIG_ADDRES 0xCF8
#define PCI_CONFIG_DATA 0xCFC
uint32_t pci_read(uint8_t bus, uint8_t device, uint8_t func, uint8_t offset);