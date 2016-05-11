	# The 1.5 bootloader jumpsto 0x1476, but that's in the middle of
	# our routine. Let's move the 0x1476 code elsehwere so we can
	# see what happens
	# tested on 1.6bl/1.6box -- no change
	# not yet tested on 1.5bl/1.5box
	#
	
	.org 0x3000

stuffthatwasat1460:	
	cpi r26, 0x10
	brcc Label_0x1476
	inc r27
	cpi r27,0x40
	brcc Label_0x1492
	cpi r16, 0x00
	brne Label_0x1472
	std Y+11,r27 ;   Memory[[r28:r29]+11] = r27;
	jmp 0x1432

Label_0x1472:
	std Y+12,r27 ;;        Memory[[r28:r29]+12] = r27;
	jmp 0x1432

Label_0x1476:
	cpi r27,0
	breq Label_0x1492
	cpi r16, 0
	brne Label_0x1484
	ldi r16,1
	clr r27
	jmp 0x1416

Label_0x1484:
	jmp 0x1484
	
Label_0x1492:
	jmp 0x1492
	

	# hook a little counter into bottom right of screen as a demo
replace_0x1460:
	jmp stuffthatwasat1460

replace_0x1476:
	;; should set a flag here as we know we're a 1.5bl box
	jmp 0x14a6
	

	
