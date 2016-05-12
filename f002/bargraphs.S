	# Let's hook into main() by overwriting the part that looks to see
	# if there is a command waiting in 0x4070 and have it jump here.
	# then when we're done replace the thing we overwrote!
	#
	# Let's display bargraphs on the main screen under the A and B levels
	# showing what's going on.  For now we'll use our approximation based
	# on levels and frequency, but we could just as easily use whatever
	# is being used to decide the LED brightness/pwm later.  The code is
	# a bit messy, it's a proof of concept!
	#
	# todo: dont bother displaying when ramp is showing
	#
	
	.org 0x3000

hookloopmain:	
	ldd r30, Y+19		; 0x60+19 is an existing counter used by the ET to schedule running things
	andi r30 ,0x3f		; we want to run a few times a second, so let's use 6 bits
	cpi r30, 0x06		;
	brne goback             ; not our time to run, so just go back to the main code

	ldd r30, Y+13		; $406D is "Menu State" 1 when in menu, 2 when running a program
	cpi r30, 0x02		; don't do anything when in a menu
	brne goback
	
	ldi r28,0x90

	clr r30
	ldd r31,Y+0		; 4x90 GateA
	sbrs r31, 0
	rjmp gota

	ldd r31,Y+0x15		; 4xA5 levelA
	lsr r31
	ldd r30,Y+0x27		; 4xB7 widthA
	lsr r30
	add r30, r31		; = (levelA+widthA)/2

gota:	
	lsr r30
	lsr r30
	lsr r30
	lsr r30
	lsr r30                 ; r30 is 0-8
	ldi r31, 64             ; start 2nd line 8 chars in
	add r30, r31            ; end of black blobs
	mov r0, r30

displaya:
	ldi r30, 0xff
	cp r0, r31
	brcc displaya2
	ldi r30,0x20
displaya2:	
	call 0x1278		; display char r30 at position r31

	inc r31
	cpi r31, 72
	brne displaya
	
	ldi r29,1

	clr r30
	ldd r31,Y+0		; 4x90 GateA
	sbrs r31, 0
	rjmp gotb

	ldd r31,Y+0x15		; 4xA5 levelA
	lsr r31
	ldd r30,Y+0x27		; 4xB7 widthA
	lsr r30
	add r30, r31		; = (levelA+widthA)/2

gotb:
				; r30 is 0-256 but we have 8 chars
	lsr r30
	lsr r30
	lsr r30
	lsr r30
	lsr r30                 ; r30 is 0-8
	ldi r31, 72             ; start 2nd line 8 chars in
	add r30, r31            ; end of black blobs
	mov r0, r30

displayb:
	ldi r30, 0xff
	cp r0, r31
	brcc displayb2
	ldi r30,0x20
displayb2:	
	call 0x1278		; display char r30 at position r31

	inc r31
	cpi r31, 80
	brne displayb
		
	;;  gatea 4090 4190
	;; levela 40A5 41A5
	;; widtha 40B7 41B7
	;; freqa
	;; a = max(0,la-128)+max(0,wa-128)

	ldi r29,0
	ldi r28,0x60		; save a push/pop we know its 0x0060

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
	
replace_0x438:
	jmp hookloopmain


	

	
