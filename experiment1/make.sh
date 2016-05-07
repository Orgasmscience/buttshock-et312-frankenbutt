# compile the asm
avr-as -mmcu=atmega16 -o hookmain.o hookmain.S

# link so we get relative jumps
avr-ld -mavr5 -o hookmain.elf hookmain.o

# and convert it to binary
avr-objcopy -Obinary hookmain.elf hookmain.bin

# grab the decrypted firmware
dd if=../../buttshock-et312-firmware/firmware/312-16-decrypted.bin of=frankenbutt.bin bs=12288 count=1

# and add our stuff to location 0x3000
dd if=hookmain.bin of=frankenbutt.bin skip=12288 seek=12288 bs=1

# and extend to the right length
dd if=/dev/zero of=frankenbutt.bin bs=1 count=0 seek=15872

# find what function we want to hook and the new location
python ./frankenbuttpatch.py -i frankenbutt.bin -o frankenbutt2.bin -e hookmain.elf
mv frankenbutt2.bin frankenbutt.bin

# add checksum and convert ready to upload
../../buttshock-et312-firmware/scripts/fw-utils.py -i frankenbutt.bin -e -o frankenbutt.upg

