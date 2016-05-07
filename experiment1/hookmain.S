	# Let's hook into main() by overwriting the part that looks to see
	# if there is a command waiting in 0x4070 and have it jump here.
	# then when we're done replace the thing we overwrote!
	#
	# we stick a little counter in the bottom right of the screen, just a demo
	#
	
	.org 0x3000

loopmain:	
	ldd r30, Y+19		; it's a counter!
	andi r30 ,0x3f		; 
	cpi r30, 0x06		; let's use it so we only run a few times a second
	brne goback

	ldd r30, Y+15		; not used byte, just for our counter
	inc r30
	std Y+15, r30
	
#	push r28
#	ldi r28, 0xa5
#	ldd r30, Y+0		;this is a counter
	ldi r31, 77	        ; bottom line, far right
	call 0x12b8		; display_number_on_display:	Parameter r31 (position), r30 (number from 0-255) 
	; 0x12b8 keeps r26, r27, trashes r0, r31, r30, 
#	pop r28

goback:	
	; stuff we overwrote that we have to do here now
	ldd r30, Y+16		; r30 = Memory[[r28:r29]+16]  is 0x4070
	cpi r30, 0x28		; cmp(r30, 0x28)
	brcc	omk		; if (!Carry) goto 0x444
	jmp 0x43e
omk:	jmp 0x444


	# hook a little counter into bottom right of screen as a demo
replace_0x438:
	jmp loopmain

	# replace the V1.6 on startup screen with our own ID
replace_0x1ce4:
	.ascii "F002"

	# replace random xor key with 0 
replace_0x18e0:
	clr r26

	# allow serial protocol to dump all memory
replace_0x1924:
	mov r31, r27

	

	
