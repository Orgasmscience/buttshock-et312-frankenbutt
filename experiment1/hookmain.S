	# Let's hook into main() by overwriting the part that looks to see
	# if there is a command waiting in 0x4070 and have it jump here.
	# then when we're done replace the thing we overwrote!
	#
	# we stick a little counter in the bottom right of the screen, just a demo
	#
	
	.org 0x3000

hookloopmain:	
	ldd r30, Y+19		; 0x60+19 is an existing counter used by the ET to schedule running things
	andi r30 ,0x3f		; we want to run a few times a second, so let's use 6 bits
	cpi r30, 0x06		;
	brne goback             ; not our time to run, so just go back to the main code

	ldd r30, Y+15		; 0x60+15 is a byte not used in the ET fw, let's use it for our counter
	inc r30
	std Y+15, r30
	
#	push r28
#	ldi r28, 0xa5
#	ldd r30, Y+0		
	ldi r31, 77	        ; bottom line, far right
	call 0x12b8		; display_number_on_display:	Parameter r31 (position), r30 (number from 0-255) 
	; note 0x12b8 keeps r26, r27, trashes r0, r31, r30, 
#	pop r28

goback:	
	; stuff we overwrote that we have to do here now
	ldd r30, Y+16		; r30 = Memory[[r28:r29]+16]  is 0x4070
	cpi r30, 0x28		; cmp(r30, 0x28)
	brcc	omk		; if (!Carry) goto 0x444
	jmp 0x43e
omk:	jmp 0x444

	# Stuff below is compiled but not patched into the binary, any routines starting
	# with keyword "replace_" will cause our patch utility to add the compiled code
	# to the location that follows.  i.e. "replace_0x300: nop" would write a 0 to
	# 0x300 in the original firmware.
	
	# hook a little counter into bottom right of screen as a demo
replace_0x438:
	jmp hookloopmain


	

	
