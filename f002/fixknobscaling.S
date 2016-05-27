	# A few people noticed that the A and B levels displayed were not very linear,
	# indeed you'll notice a few numbers are missing like
	#
	# 6,13,20,27,34,41,48,55,62,69,76,83,90,97,98
	#
	# But when we looked, the A and B levels are actually stored 0-254 (but only evens)
	# So it's the scaling routine that's wonky.
	#
	# The scaling routine did this int(pot/18)+int(pot/3).  See the problem?  you
	# can never get 6 displayed, even though the levels are really changing.
	#
	# and if you're wondering, 254/3+254/18 is 98, and the code has a special case
	# which makes it display 99 instead.  I guess people might complain if the box
	# only went to 98.

	# We could use a lookup table, but we're only called a few times a second
	# so lets multiply by 39 and divide by 100. Sorted.

replace_0x128a:	
	ldi r31, 39
	call 0x1362		; r30:r31 = r30 * r31 preserves other registeres
	ldi r26, 100
	ldi r27, 0
	call 0x13bc		; divide_word
	ldi r27, 0		; we've 8 spare bytes and nops don't compile well, let's not jump either
	ldi r27, 0
	ldi r27, 0
	ldi r27, 0

	
	
