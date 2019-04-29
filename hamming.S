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
		;adr		r1, eresult	for some reason i get an error here
		;str		r0, [r1]
		
		adr		r1, recv
		ldr		r0, [r1]
		bl		hdecode
		;adr		r1, corr		for some reason i get an error here
		;str		r0, [r1]
		end
		
		;uses	r0 for argument
hencode	mov		r1, #0		;used for encode
		mov		r2, #0		;used for the parity of the bits according to p1
		mov		r3, #0		;used for the parity of the bits according to p2
		mov		r4, #0		;used for the parity of the bits according to p4
		mov		r5, #0		;used for the parity of the bits according to p8
		
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
		addne	r1, r1, #0b10000000		;makes parity bit 1 if respective parity is odd
		
		tst		r4, #1		;checks the parity of p4
		addne	r1, r1, #0b100000000000	;makes parity bit 1 if respective parity is odd
		
		tst		r3, #1		;checks the parity of p2
		addne	r1, r1, #0b10000000000000	;makes parity bit 1 if respective parity is odd
		
		tst		r2, #1		;checks the parity of p1
		addne	r1, r1, #0b100000000000000	;makes parity bit 1 if respective parity is odd
		
		mov		r0, r1		;moves the encoded data into r0
		mov		pc, lr
		
		
hdecode	mov		r1, #0		;used for decode
		mov		r2, #0		;used for the parity of the bits revelent to p1
		mov		r3, #0		;used for the parity of the bits relevent to p2
		mov		r4, #0		;used for the parity of the bits relevent to p4
		mov		r5, #0		;used for the parity of the bits relevent to p8
		mov		r6, #0		;used for settings which parity bits have an odd parity with relevent bits
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r4, r4, #1
		addcs	r3, r3, #1
		addcs	r2, r2, #1
		addcs	r1, r1, #0b1	;starts decoding (d11)
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r4, r4, #1
		addcs	r3, r3, #1
		addcs	r1, r1, #0b10	;continues decoding (d10)
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r4, r4, #1
		addcs	r2, r2, #1
		addcs	r1, r1, #0b100	;continues decoding (d09)
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r4, r4, #1
		addcs	r1, r1, #0b1000	;continues decoding (d08)
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r3, r3, #1
		addcs	r2, r2, #1
		addcs	r1, r1, #0b10000	;continues decoding (d07)
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r3, r3, #1
		addcs	r1, r1, #0b100000	;continues decoding (d06)
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r5, r5, #1	;updates relevent parity bits
		addcs	r2, r2, #1
		addcs	r1, r1, #0b1000000	;continues decoding (d05)
		
		lsrs		r0, r0, #1	;NOTE: parity bit, doesn't get put into the decode
		addcs	r5, r5, #1	;updates relevent parity bit
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r4, r4, #1	;updates relevent parity bits
		addcs	r3, r3, #1
		addcs	r2, r2, #1
		addcs	r1, r1, #0b10000000	;continues decoding (d04)
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r4, r4, #1	;updates relevent parity bits
		addcs	r3, r3, #1
		addcs	r1, r1, #0b100000000	;continues decoding (d03)
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r4, r4, #1	;updates relevent parity bits
		addcs	r2, r2, #1
		addcs	r1, r1, #0b1000000000	;continues decoding (d02)
		
		lsrs		r0, r0, #1	;NOTE: parity bit, doesn't get put into the decode
		addcs	r4, r4, #1	;updates relevent parity bit
		
		lsrs		r0, r0, #1	;moves lsb into carry status bit
		addcs	r3, r3, #1	;updates relevent parity bits
		addcs	r2, r2, #1
		addcs	r1, r1, #0b10000000000	;continues decoding (d01)
		
		lsrs		r0, r0, #1	;NOTE: parity bit, doesn't get put into the decode
		addcs	r3, r3, #1	;updates relevent parity
		
		lsrs		r0, r0, #1	;NOTE: parity bit, doesn't get put into the decode
		addcs	r2, r2, #1	;updates relevent parity
		
		adr		r0, noer
		ldr		r7, [r0]		;for case
		adr		r0, onee
		
		tst		r2, #1		;checks the parity of p1
		addne	r6, r6, #0b0001
		ldrne	r7, [r0]
		
		tst		r3, #1		;checks the parity of p2
		addne	r6, r6, #0b0010
		ldrne	r7, [r0]
		
		tst		r4, #1		;checks the parity of p4
		addne	r6, r6, #0b0100
		ldrne	r7, [r0]
		
		tst		r5, #1		;checks the parity of p8
		addne	r6, r6, #0b1000
		ldrne	r7, [r0]
		
		adr		r0, case
		str		r7, [r0]		;stores case
		adr		r0, berr
		mov		r2, #0		;if no bit is wrong
		
		cmp		r6, #0b1111	;if d11 is wrong
		eoreq	r1, r1, #0b00000000001	;flip the appropriate bit
		mov		r2, #11
		
		cmp		r6, #0b1110	;if d10 is wrong
		eoreq	r1, r1, #0b00000000010	;flip the appropriate bit
		mov		r2, #10
		
		cmp		r6, #0b1101	;if d09 is wrong
		eoreq	r1, r1, #0b00000000100	;flip the appropriate bit
		mov		r2, #09
		
		cmp		r6, #0b1100	;if d08 is wrong
		eoreq	r1, r1, #0b00000001000	;flip the appropriate bit
		mov		r2, #08
		
		cmp		r6, #0b1011	;if d07 is wrong
		eoreq	r1, r1, #0b00000010000	;flip the appropriate bit
		mov		r2, #07
		
		cmp		r6, #0b1010	;if d06 is wrong
		eoreq	r1, r1, #0b00000100000	;flip the appropriate bit
		mov		r2, #06
		
		cmp		r6, #0b1001	;if d05 is wrong
		eoreq	r1, r1, #0b00001000000	;flip the appropriate bit
		mov		r2, #05
		
		cmp		r6, #0b0111	;if d04 is wrong
		eoreq	r1, r1, #0b00010000000	;flip the appropriate bit
		mov		r2, #04
		
		cmp		r6, #0b0110	;if d03 is wrong
		eoreq	r1, r1, #0b00100000000	;flip the appropriate bit
		mov		r2, #03
		
		cmp		r6, #0b0101	;if d02 is wrong
		eoreq	r1, r1, #0b01000000000	;flip the appropriate bit
		mov		r2, #02
		
		cmp		r6, #0b0011	;if d01 is wrong
		eoreq	r1, r1, #0b10000000000	;flip the appropriate bit
		mov		r2, #01
		
		str		r2, [r0]
		
		mov		r0, r1		;moves the decoded data into r0
		mov		pc, lr
