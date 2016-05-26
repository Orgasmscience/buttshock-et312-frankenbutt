# Buttshock - ET-312 Frankenfirmware

## Project Goals

This project exists to add small bug fixes, security fixes, and
features to the ET-312 Electrostimulation Device Firmware.

## Requirements

To apply firmware patches you'll need

- a copy of repo https://github.com/metafetish/buttshock-et312-firmware/
- base firmware created from above repo
- a firmware patch file (it's plain text)

To create firmware patches you'll need

- Some Linux box
- packages avr-as (avr-binutils package or similar)
- a knowledge of AVR assembler

## Quick Start to create new firmware patches

Run Make.  It will compile some example patches and create the patch
file.  It will also run the commands to do the patching, ready to
upload to your box.  Then put the box in bootloader upload mode (hold
"Menu" and "UP" while turning on and both lights should flash).  Use
the utils part of the firmware repo to upload to your box.

f002 is an example which

- changes the box xor byte to 0 instead of random
- allows serial connections to read more memory locations
- adds a new sub-menu "More Options" and moves serial link to that menu
- adds a menu item "Debug Mode" to the new sub-menu
- adds a counter in the bottom right of the LCD that just increments when debug mode is enabled
- adds a menu item "Random3" to the new sub-menu
  Random3 mode turns on a favourite mode for a random time, then turns off the outputs for
  another random time, repeating this.  A bit like Random1 but without the random MA knob
  and with random periods with no stimulation
[- moves the reset code out of the way of the 1.5 bootloader jump]

## FAQ

### WHY?!

There's probably hundreds if not thousands of ET-312 boxes around the
world. We'd like them to work better.

## License

All original code and documentation is
covered under the following BSD license:

    Copyright (c) 2016, The Buttshock Project
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name of The Buttshock Project nor the names of
          its contributors may be used to endorse or promote products
          derived from this software without specific prior written
          permission.

    THIS SOFTWARE IS PROVIDED BY The Buttshock Project ''AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
    THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Kyle
    Machulis/Nonpolynomial Labs BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
    OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
    EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE

