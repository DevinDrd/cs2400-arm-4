		;		ARM Programming Assignment #4: Count the ones in a binary number
		;
		;		Write a program that counts the number of ones in a binary number,
		;		stored in a word (4 bytes). Its loop should run no more times than there
		;		are ones in the number. Write the count in `numones`. For the example
		;		number given below, the loop should only run 8 times, counting 8 ones.
		;
		;		Hint:
		;		The first significant instruction in the loop is SUB r1, r1, 1, which
		;		decrements the number, assuming it's stored in register r1. Now,
		;		remember your logical operations.
		;
		;		Bonus:
		;		1. (20 extra points) For the shortest program (by instruction count),
		;		because this operation has to be FAST.
		;		2. (30 extra points) For extending the program to counting the ones
		;		in any word-aligned continuous region of memory.
		
		;		Your code here
		
example	DCD		0x0010070f
numones	FILL		4
		
		adr		r0, example
		ldr		r0, [r0]
		bl		count
		adr		r1, numones
		str		r0, [r1]
		end
		
		;takes	number in r0
count	mov		r2, #0	;initializes number of 1's
loop		sub		r1, r0, #1
		ands		r0, r0, r1
		add		r2, r2, #1
		bne		loop
		mov		r0, r2	;returns number in r0
		mov		pc, lr


;bonus (not used, only coded, but works)
;takes address in r0 and number of words in r1 (number of words has to be greater than 0)
countn	mov		r10, lr	;saves lr
		mov		r3, r0	;saves address
		mov		r4, r1	;saves number of words
		mov		r5, #0	;initializes accumulative number of 1's
		
loopwd	ldr		r0, [r3], #4
		bl		count
		add		r5, r5, r0	;adds to accumulative number of 1's based on current word
		sub		r4, r4, #1	;updates counter
		bne		loopwd
		mov		r0, r5		;return count in r0
		mov		r10, lr
		mov		pc, lr	;returns
		
		