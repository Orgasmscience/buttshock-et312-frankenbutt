	# replace random xor key with 0 
replace_0x18e0:
	clr r26			; r26=0 // chosen by fair dice roll.
				;       // guaranteed to be random -- https://xkcd.com/221/
