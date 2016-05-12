SOURCES=15bootloader.S changeversion.S removerandomxor.S serialdumpmemory.S

FWUTILS=python3 ../../buttshock-et312-firmware/scripts/fw-utils.py

OBJECTS=$(SOURCES:.S=.o)
ASFLAGS=-mmcu=atmega16
LDFLAGS=-mavr5

all: $(SOURCES) f002

f002.fwpatch: f002.elf 
	avr-objdump -D f002.elf > f002.fwpatch

f002: f002.fwpatch
# patch the firmware based on our asm and patches
	$(FWUTILS) -i ../../buttshock-et312-firmware/firmware/312-16-decrypted.bin -o f002.bin -p f002.fwpatch
# add checksum and convert ready to upload
	$(FWUTILS) -i f002.bin -e -o f002.upg

f002.elf: $(OBJECTS)
	avr-ld $(LDFLAGS) -o f002.elf $(OBJECTS)

.S.o:
	avr-as $(ASFLAGS) $< -o $@

clean:
	rm f002.bin f002.upg f002.elf *.o
