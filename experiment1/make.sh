# compile the asm
avr-as -mmcu=atmega16 -o hookmain.o hookmain.S

# link so we get relative jumps
avr-ld -mavr5 -o hookmain.elf hookmain.o

# and convert it to binary
avr-objcopy -Obinary hookmain.elf hookmain.bin

# grab the decrypted firmware
dd if=../firmware/312-16-decrypted.bin of=frankenbutt.bin bs=12288 count=1

# and add our stuff to location 0x3000
dd if=hookmain.bin of=frankenbutt.bin skip=12288 seek=12288 bs=1

# and extend to the right length
dd if=/dev/zero of=frankenbutt.bin bs=1 count=0 seek=15872

# find what function we want to hook and the new location
avr-objdump -t hookmain.o | grep replace | sed  's/^\([0-9A-F]\+\).*replace_\([0-9a-f]\+\)/\2 0x\1/' | gawk --non-decimal-data '{printf "s/%s/0c94%02x%02x%s/g\n", $1, ($2-0x1800)%256,($2-0x1800)/256, substr($1,length($1)-2)}' > sed.txt
xxd -ps -c256 frankenbutt.bin | sed -f sed.txt | xxd -ps -r > frankenbutt2.bin
mv frankenbutt2.bin frankenbutt.bin

# add checksum and convert ready to upload
../scripts/fw-utils.py -i frankenbutt.bin -e -o frankenbutt.upg

# hack
cp frankenbutt.upg /tmp
