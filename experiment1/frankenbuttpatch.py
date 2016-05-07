#!/usr/bin/python3
#
# take an elf file and run  avr-objdump -D filename on it
# parse the results
#
# 00003022 <replace_0x438>:
#   3022:       0c 94 00 18     jmp     0x3000  ; 0x3000 <loopmain>
#
# read the input binary file
# patch following the instructions above
# so in that case replacing bytes at 0x438 with 0c 94 00 18
# note the asm might go over multiple lines, stop at EOF or a blank line
#
import argparse

class ET312FirmwarePatcher(object):

    def __init__(self, input_hex, input_elf, output_hex):
        with open(input_hex, "rb") as f:
            self.input_hex = bytearray(f.read())
        self.output_hex_file = open(output_hex,"wb")

    def patch(self):

        # do thing here
        
        self.output_hex_file.write(bytearray(self.input_hex))
        return
        

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", dest="input_hex_file", help="input hex file")
    parser.add_argument("-e", "--elffile", dest="input_elf_file", help="ELF file to parse for patches")
    parser.add_argument("-o", "--output", dest="output_hex_file", help="output hex file")
    args=parser.parse_args()

    if not args.input_hex_file:
        print("ERROR: Input hex file required to run.")
        parser.print_help()
        return 1

    if not args.input_elf_file:
        print("ERROR: Input elf file required to run.")
        parser.print_help()
        return 1

    if not args.output_hex_file:
        print("ERROR: Output hex file required to run.")
        parser.print_help()
        return 1

    patcher = ET312FirmwarePatcher(args.input_hex_file,args.input_elf_file,args.output_hex_file)
    patcher.patch();
    return 0

if __name__ == "__main__":
    main()
            
