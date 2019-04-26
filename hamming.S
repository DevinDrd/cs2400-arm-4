		;		ARM Programming Assignment #4: Encode in Hamming(15, 11)
		;
		;		Write a subroutine that encodes 11 bits of data into a 15-bit
		;		block, using 4 parity bits. Assume even parity, that is,
		;		the parity of the bits covered by a parity bit, including
		;		the parity bit, has to be an even number. Assume the bits are
		;		written in the following sequence: p1, p2, d1, p3, d2, d3, d4,
		;		p4, d5, d6, d7, d8, d9, d10, d11, p5, d12, d13, d14, d15.
		;		Call the subroutine `hencode`.
		;
		;		Write a subroutine that decodes a H(15, 11) block to extract
		;		the 11 data bits. Call it `hdecode`. It should:
		;		- calculate the correcting code
		;		- Identify the case: no error (noer), one-bit error (onee)
		;		- write the result in `case` using the encoding provided
		;		- if there is a one-bit error, write the number of the
		;		erroneous bit in `berr`
		;		- if there is a one-bit error, correct the data
		;		- write the result in `corr`
		;
		;		Now, write a main function which uses `hencode` and `decode`
		;		to encode `data` and then, after a simulated transmission,
		;		decode `recv`. Assume that `recv` contains what is received
		;		at the other end.
		
		;		Your code here
		
data		DCD		0b10100100101
recv		DCD		0b101111010100101
		;		------*----------
		
eresult	FILL		4
		
noer		DCD		0x00
onee		DCD		0x01
		
case		FILL		4
berr		FILL		4
corr		FILL		4
		
main		adr		r1, data
		ldr		r0, [r1]		;loads data into r0
		bl		hencode
		adr		r1, eresult
		str		r0, [r1]
		end
		
		
		;uses	r0 for argument
hencode	mov		r1, #0		;used for encode
		mov		r2, #0		;used for the parity of the bits according to p1
		mov		r3, #0		;used for the parity of the bits according to p2
		mov		r4, #0		;used for the parity of the bits according to p3
		mov		r5, #0		;used for the parity of the bits according to p1
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r4, r4, #1
		addcs	r3, r3, #1
		addcs	r2, r2, #1
		addcs	r1, r1, #0b1	;starts encoding
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r4, r4, #1
		addcs	r3, r3, #1
		addcs	r1, r1, #0b10	;continues encoding
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r4, r4, #1
		addcs	r2, r2, #1
		addcs	r1, r1, #0b100	;continues encoding
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r4, r4, #1
		addcs	r1, r1, #0b1000	;continues encoding
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r3, r3, #1
		addcs	r2, r2, #1
		addcs	r1, r1, #0b10000	;continues encoding
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r3, r3, #1
		addcs	r1, r1, #0b100000	;continues encoding
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r2, r2, #1
		addcs	r1, r1, #0b1000000	;continues encoding
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r4, r4, #1	;updates relevent parity bits
		addcs	r3, r3, #1
		addcs	r2, r2, #1
		addcs	r1, r1, #0b100000000	;continues encoding NOTE:extra zero for parity bit
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r4, r4, #1	;updates relevent parity bits
		addcs	r3, r3, #1
		addcs	r1, r1, #0b1000000000	;continues encoding
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r4, r4, #1	;updates relevent parity bits
		addcs	r2, r2, #1
		addcs	r1, r1, #0b10000000000	;continues encoding
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r3, r3, #1	;updates relevent parity bits
		addcs	r2, r2, #1
		addcs	r1, r1, #0b1000000000000	;continues encoding NOTE:extra zero for parity bit
		
		tst		r5, #1		;checks the parity of p8
		addne	r1, r1, #0b10000000		;makes parity bit 1 if parity is odd
		
		tst		r4, #1		;checks the parity of p4
		addne	r1, r1, #0b100000000000	;makes parity bit 1 if parity is odd
		
		tst		r3, #1		;checks the parity of p2
		addne	r1, r1, #0b10000000000000	;makes parity bit 1 if parity is odd
		
		tst		r2, #1		;checks the parity of p1
		addne	r1, r1, #0b100000000000000	;makes parity bit 1 if parity is odd
		
		mov		r0, r1		;moves the encoded data into r0
		mov		pc, lr
