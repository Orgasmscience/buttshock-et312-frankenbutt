SOURCES=unifyboxes.S changeversion.S 

FWUTILS=python3 ../../buttshock-et312-firmware/scripts/fw-utils.py

OBJECTS=$(SOURCES:.S=.o)
ASFLAGS=-mmcu=atmega16
LDFLAGS=-mavr5

all: $(SOURCES) f003

f003.fwpatch: f003.elf 
	avr-objdump -D f003.elf > f003.fwpatch

f003: f003.fwpatch
# patch the firmware based on our asm and patches
	$(FWUTILS) -i ../../buttshock-et312-firmware/firmware/312-16-decrypted.bin -o f003.bin -p f003.fwpatch
# add checksum and convert ready to upload
	$(FWUTILS) -i f003.bin -e -o f003.upg

f003.elf: $(OBJECTS)
	avr-ld $(LDFLAGS) -o f003.elf $(OBJECTS)

.S.o:
	avr-as $(ASFLAGS) $< -o $@

clean:
	rm f003.bin f003.upg f003.elf *.o
