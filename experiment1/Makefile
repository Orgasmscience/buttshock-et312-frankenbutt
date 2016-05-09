SOURCES=hookmain.S changeversion.S removerandomxor.S serialdumpmemory.S

FRANKENBUTTPATCH=python ../scripts/frankenbuttpatch.py
FWUTILS=python ../../buttshock-et312-firmware/scripts/fw-utils.py 

OBJECTS=$(SOURCES:.S=.o)
ASFLAGS=-mmcu=atmega16
LDFLAGS=-mavr5

all: $(SOURCES) experiment1

experiment1: hookmain.elf 
# patch the firmware based on our asm and patches
	$(FRANKENBUTTPATCH) -i ../../buttshock-et312-firmware/firmware/312-16-decrypted.bin -o frankenbutt.bin -e hookmain.elf
# add checksum and convert ready to upload
	$(FWUTILS) -i frankenbutt.bin -e -o frankenbutt.upg

hookmain.elf: $(OBJECTS)
	avr-ld $(LDFLAGS) -o hookmain.elf $(OBJECTS)

.S.o:
	avr-as $(ASFLAGS) $< -o $@

clean:
	rm frankenbutt.bin frankenbutt.upg hookmain.elf *.o
