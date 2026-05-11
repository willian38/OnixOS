#Ferramentas usadas
CC = gcc
LD = ld
AS = nasm

#flags/args das ferramentas usadas
CFLAGS = -m32 -ffreestanding -nostdlib -fno-pic -fno-pie -no-pie
LDFLAGS = -m elf_i386 -T linker.ld
ASFLAGS = -f elf32
ASBINFLAG = -f bin 

#Arquivos binarios do Kernel
BINS = boot.bin kernel.bin

#Pastas do Kernel
KERNEL_SRC = \
	src/kernel/kernel.c \
	src/kernel/idt.c \
	src/kernel/io.c \
	src/kernel/pci.c

#Drivers do Kernel
KERNEL_SRC_DRIVERS = \
	src/drivers/vga_text.c

#JUNTA TUDO as PASTAS do KERNEL
SRC = $(KERNEL_SRC) $(KERNEL_SRC_DRIVERS)

#DEPENDENCIAS
OBJS = $(SRC:src/%.c=build/%.o);

all: os.bin


#Compile Object Files
build/%.o : src/%.c
	@echo "Compilando arquivos...."
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

#Bootloader
boot.bin: src/boot/bootloader.asm
	@echo "Compilando Bootloader..."
	$(AS) $(ASBINFLAG) $^ -o $@

#Bootloader Stage 2
build/boot/stage2.o: src/boot/stage2.asm
	@echo "Compilando segundo estagio do Bootloader..."
	mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $^ 

#Kernel BIN
kernel.bin: build/boot/stage2.o $(OBJS)
	@echo "Linkando e compilando Kernel e suas dependencias..."
	$(LD) $(LDFLAGS) -o $@ $^ 

#Bin Files
os.bin: $(BINS)
	@echo "Criando os.bin..."
	cat $(BINS) > os.bin

.PHONY: all clean

clean:
	rm -rf build kernel.bin boot.bin

	@echo "Tudo Pronto!!!"
