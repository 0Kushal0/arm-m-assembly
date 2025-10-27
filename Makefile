# Makefile for building and debugging ARM Cortex-M projects using GNU toolchain and QEMU.
#
# Variables:
#   PROJECT   - Name of the project (default: foo)
#   CPU       - Target CPU architecture (default: cortex-m3)
#   BOARD     - QEMU board model (default: stm32vldiscovery)
#
# Targets:
#   qemu      - Assembles, links, generates debug info, and runs the project in QEMU with GDB server enabled.
#   gdb       - Starts gdb-multiarch and connects to the QEMU GDB server.
#   bin       - Converts the ELF output to a raw binary file.
#   printbin  - Prints the binary file contents in a readable hex format (little-endian, 4 bytes per group).
#   clean     - Removes build artifacts and debug files.
PROJECT=foo
CPU ?= cortex-m3
BOARD ?= stm32vldiscovery

qemu:
# 	arm-none-eabi-gcc -mthumb -mcpu=$(CPU) -S foo.c -o foo_src.s
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -g -c test_foo.S -o foo.o
	arm-none-eabi-ld -Ttest_map.ld foo.o -o foo.elf
	arm-none-eabi-objdump -D -S foo.elf > foo.elf.lst
	arm-none-eabi-readelf -a foo.elf > foo.elf.debug
	qemu-system-arm -S -M $(BOARD) -cpu $(CPU) -nographic -kernel $(PROJECT).elf -gdb tcp::1234

gdb:
	gdb-multiarch -q $(PROJECT).elf -ex "target remote localhost:1234"

bin:
	arm-none-eabi-objcopy -O binary foo.elf foo.bin

printbin:
	xxd -e -c 4 -g 4 foo.bin

clean:
	rm -rf *.out *.elf .gdb_history *.lst *.debug *.o *_test*
