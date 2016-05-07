# compile the asm
avr-as -mmcu=atmega16 -o hookmain.o hookmain.S

# link so we get relative jumps
avr-ld -mavr5 -o hookmain.elf hookmain.o

# patch the firmware based on our asm and patches
python ./frankenbuttpatch.py -i ../../buttshock-et312-firmware/firmware/312-16-decrypted.bin -o frankenbutt.bin -e hookmain.elf

# add checksum and convert ready to upload
../../buttshock-et312-firmware/scripts/fw-utils.py -i frankenbutt.bin -e -o frankenbutt.upg

