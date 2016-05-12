#!/usr/bin/python
#
# take an elf file and run  avr-objdump -D filename on it
# parse the results as a patch file
#
# 00003022 <replace_0x438>:
#   3022:       0c 94 00 18     jmp     0x3000  ; 0x3000 <loopmain>
#
# read the input binary file
# patch following the instructions above
# so in that case replacing bytes at 0x438 with 0c 94 00 18
# note the asm might go over multiple lines, stop at EOF or a blank line
#
# Might as well patch everything compiled using this script!
#
import argparse

class ET312FirmwarePatcher(object):

    def __init__(self, input_hex, input_patch, output_hex, verbose=False):

        with open(input_patch,"r") as f:
            self.input_patch = f.read().splitlines()
            
        with open(input_hex, "rb") as f:
            self.input_hex = bytearray(f.read())
        self.output_hex_file = open(output_hex,"wb")
        self.verbose = verbose

    def patch(self):
        import re
        
        lines = iter(self.input_patch)
        for line in lines:
            replace = re.search('<replace_([^>]+)',line)
            if replace:
                replacestart = int(replace.group(1),16)
                line = next(lines)
                replacewith = ""
                try:
                    while (":" in line):
                        replacewith += line.split("\t")[1]
                        line = next(lines)
                except StopIteration:
                    pass
                for bytes in replacewith.split():
                    decbyte = int(bytes,16)
                    if (self.verbose):
                        print ("Patched %04x with %02x"%(replacestart,decbyte))
                    self.input_hex[replacestart] = decbyte
                    replacestart+=1
            elif (':' in line):
                try:
                    location = int(line.split("\t")[0].rstrip(':'),16)
                    hexbytes = line.split("\t")[1]
                    for bytes in hexbytes.split():
                        decbyte = int(bytes,16)
                        self.input_hex[location] = decbyte
                        if (self.verbose):
                            print ("Code %04x %02x"%(location,decbyte))
                        location+=1
                except:
                    pass
                  
        self.output_hex_file.write(bytearray(self.input_hex))
        return
        

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", dest="input_hex_file", help="input hex file")
    parser.add_argument("-p", "--patchfile", dest="input_patch_file", help="patch file created by avr-objdump -D your-elf-file")
    parser.add_argument("-o", "--output", dest="output_hex_file", help="output hex file")
    parser.add_argument("-v", "--verbose", dest="verbose", action='store_true', help="show what we patched")
    args=parser.parse_args()

    if not args.input_hex_file:
        print("ERROR: Input hex file required to run.")
        parser.print_help()
        return 1

    if not args.input_patch_file:
        print("ERROR: Input patch file required to run.")
        parser.print_help()
        return 1

    if not args.output_hex_file:
        print("ERROR: Output hex file required to run.")
        parser.print_help()
        return 1

    patcher = ET312FirmwarePatcher(args.input_hex_file,args.input_patch_file,args.output_hex_file,args.verbose)
    patcher.patch();
    return 0

if __name__ == "__main__":
    main()
            
