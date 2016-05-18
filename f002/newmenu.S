	# Let's replace the Link Slave Unit? menu option with a "More Options" menu!
	# and that menu has a "Link Slave Unit?" and a "Debug Mode?" options
	
	# First we have to hook the display routine, currently you get garbage if you try to
	# display strings <0x64 (which means they are 16 characters long) outside the table
	# so anything 0x20 to 0x64 is okay for us to replace.
	
hook_show_Text_on_Display:
	ldi r28, 0x10		; we overwrote this
	mov r18, r28		; we overwrote this

	cpi r26, 0x20		; < 0x20 not for us
	brcc new_display
goback:	
	jmp 0x1330		; back to the start

new_display:	
	ldi r28, 0x20
	sub r26, r28
	ldi r28, 4	
loop0: 				; r27:r26=r26*(2^4)
	clc
	rol r26			
	rol r27			
	dec r28
	brne loop0
	ldi r28, lo8(string_0x20) ; add offset of string_0x20 start
	add r26, r28
	ldi r28, hi8(string_0x20)
	adc r27, r28
	jmp 0x1344

	# If they selected menu_option_0e, take them to the new menu
	
got_menu_option_0b:
	ldi r26, 0x21
	std Y+26, r26		; Menu Max
	std Y+24, r26		; Menu Current (start at 0x21)
	ldi r26, 0x20
	std Y+25, r26		; Menu Min
	call 0x12ec		; show_text_on_display
	ldi r21, 10
	ldi r18, 8		; previous
	ldi r20, 9		; next
	ldi r22, 3
	ret

				; Now we patch the part that looks at which menu option was selected
				; so we can add our new options
	
add_new_menu_options:
	; replace overwritten stuff from 93e
	cpi r26, 0x0d		;  93e:   ad 30           cmp(r26, 0x0d);                     ; 13
	brne not_0xd            ;  940:   21 f4           if (c1 != c2) goto Label_0x94a;
	jmp 0x942		; was option 0d - reset settings

not_0xd:
	cpi r26, 0x20
	brne not_0x20
				; 0x20 so link box! replace stuff we overwrote from 8f8
	ldi r26, 14		; 8f8:   ae e0           r26 = 14;                           ; 0x0e
	call 0x1a06		; 8fa:   0e 94 03 0d     write_r26_to_com_buffer();          ; Parameters r26
	jmp 0x8fe		; back to where we were, continue with the link box command

not_0x20:
	cpi r26, 0x21		
	brne not_0x21		; 0x21 "toggle debug mode"
	ldi r26, 1
	ldd r27, Y+14		; debug mode if bit 0 set
	eor r27, r26
	std Y+14, r27		; toggle bit0
	andi r27 , 1
	
	ldi r26, 0x22
	add r26, r27		; display 0x22 (debug now off) or 0x23 (debug now on)
	call 0x12ec		; show_text_on_display
	ldi r26, 4		; "Press any key"
	call 0x12dc		; show_text_on_display2
	
	ldi r22, 4
	ldi r19, 4
	ldi r20, 4
	ldi r21, 4
	jmp 0x966

not_0x21:
	jmp 0x94a		; back to check it's it's 0e...

	
string_0x20:
	.ascii "Link Slave Unit?"
string_0x21:	
	.ascii "Debug Mode?     "
string_0x22:	
	.ascii "Debug Disabled  "	
string_0x23:	
	.ascii "Debug Enabled   "
	
	# Stuff below is compiled but not patched into the binary, any routines starting
	# with keyword "replace_" will cause our patch utility to add the compiled code
	# to the location that follows.  i.e. "replace_0x300: nop" would write a 0 to
	# 0x300 in the original firmware.

replace_0x93e:
	jmp add_new_menu_options
	
replace_0x132c:
	jmp hook_show_Text_on_Display

replace_0x8f8:
	jmp got_menu_option_0b

replace_0x1d78:
	.ascii "More Options?   "

	
