C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

run: os.ico
	qemu-system-i386 $<

os.ico: boot/boot.bin kernel/kernel.bin
	cat $^ > $@

boot/boot.bin: boot/boot.asm
	cd boot && nasm -o boot.bin -f bin boot.asm && cd ..
	
	

kernel/kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ $^ -Ttext 0x1000 --oformat binary -m elf_i386

%.o: %.asm
	nasm -o $@ -f elf32 $<

%.o: %.c ${HEADERS}
	gcc -o $@ $< -m32 -c -ffreestanding

clear:
	rm -fr *.bin *.dis *.o os.ico
	rm -fr kernel/*.o boot/*.bin drivers/*.o
