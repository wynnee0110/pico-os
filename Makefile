ASM = nasm
CC = gcc
LD = ld

CFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector
LDFLAGS = -m elf_i386 -T linker.ld

all: pico.iso

boot/boot.o: boot/boot.asm
	$(ASM) -f elf32 boot/boot.asm -o boot/boot.o

kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c kernel/kernel.c -o kernel/kernel.o

pico.bin: boot/boot.o kernel/kernel.o
	$(LD) $(LDFLAGS) -o pico.bin boot/boot.o kernel/kernel.o

pico.iso: pico.bin
	mkdir -p iso/boot
	cp pico.bin iso/boot/pico.bin
	grub-mkrescue -o pico.iso iso

run: pico.iso
	qemu-system-i386 -cdrom pico.iso

clean:
	rm -f boot/*.o
	rm -f kernel/*.o
	rm -f pico.bin
	rm -f pico.iso
	rm -f iso/boot/pico.bin
