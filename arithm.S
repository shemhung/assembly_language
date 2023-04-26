@this is comment

@the information that tells arm-none-eabi-as what arch. to assemble to 
	.cpu arm926ej-s
	.fpu softvfp

@this is code section
@note, we must have the main function for the simulator's linker script
	.text
	.align	2   @align 4 byte
	.global	main
main:
    @prologue
	stmfd sp!, {r0-r9,fp,lr}


    @code body
	mov r3,#4   		@r3=4(參數)
	mov r4,r0,lsl #2	@r4=4* argc

	
	mov r3,#4		@r1[index]

	stmfd sp!, {lr}
	bl	str2int_array
	ldmfd sp!, {lr}
	
						
	bl output

	bl option

	stmfd sp!, {r0-r9,lr}
	ldr r0,=is_num
	mov r1,r6
	bl printf
	ldmfd sp!, {r0-r9,lr}
	@epilogue
	ldmfd	sp!, {r0-r9,fp, lr}
	bx	lr
output:
	ldr r4,[r1,#12]			@r4 option 
	stmfd sp!, {r0-r9,lr}
	cmp r4,#0
	ldreq r0,=func0_str
	cmp r4,#1
	ldreq r0,=func1_str
	cmp r4,#2
	ldreq r0,=func2_str
	cmp r4,#3
	ldreq r0,=func3_str
	cmp r4,#4
	ldreq r0,=func4_str
	cmp r4,#5
	ldreq r0,=func5_str
	cmp r4,#6
	ldreq r0,=func6_str
	cmp r4,#7
	ldreq r0,=func7_str
	cmp r4,#8
	ldreq r0,=func8_str
	bl printf
	ldmfd sp!, {r0-r9,lr}
	stmfd sp!, {r0-r9,lr}
	ldr r0,=num
	ldr r1,[r1,#4]
	bl printf
	ldmfd sp!, {r0-r9,lr}
	stmfd sp!, {r0-r9,lr}
	ldr r0,=and_str
	bl printf
	ldmfd sp!, {r0-r9,lr}
	stmfd sp!, {r0-r9,lr}
	ldr r0,=num
	ldr r1,[r1,#8]
	bl printf
	ldmfd sp!, {r0-r9,lr}
option:
    adr r5,jumptab
	ldr r4,[r1,#12]			@r4 option r4*4=r5
	add r5,r5,r4,lsl#2
	bx r5
jumptab:	
	b add
	b sub
	b pre_reverse
	b pre_divide
	b maximum
	b pre_exponent
	b pre_gcd
	b multiply
	b lcm
add:
	mov r3,#4
	ldr r8,[r1,r3]
	add r3,r3,#4
	ldr r9,[r1,r3]
	add r8,r8,r9
	mov r6,r8
	bx lr
sub:
	mov r3,#4
	ldr r8,[r1,r3]
	add r3,r3,#4
	ldr r9,[r1,r3]
	sub r8,r8,r9
	mov r6,r8
	bx lr
pre_reverse:
	mov r6,#0
	mov r2,#32
	ldr r8,[r1,#4]
	reverse:
		lsls r8,r8,#1	@左移再rrx
		rrx r6,r6
		sub r2,r2,#1
		cmp r2,#0
		bxeq lr
		b reverse
pre_divide:
	mov r3,#4
	ldr r8,[r1,r3]
	add r3,r3,#4
	ldr r9,[r1,r3]
	mov r7,#0		@count
	devide:
		cmp r8,r9
		movlt r6,r7
		bxlt lr
		sub r8,r8,r9
		add r7,r7,#1
		mov r6,r7	
		b devide
maximum:
	mov r3,#4
	ldr r8,[r1,r3]
	add r3,r3,#4
	ldr r9,[r1,r3]
	cmp r8,r9
	movgt r6,r8
	movlt r6,r9
	bx lr
pre_exponent:
	mov r3,#4
	ldr r8,[r1,r3]
	add r3,r3,#4
	ldr r9,[r1,r3]
	mov r7,#0		@count
	mov r6,#1		@target
	exponent:
		cmp r7,r9
		add r7,r7,#1
		bxeq lr
		mul r6,r8,r6
		b exponent
pre_gcd:
	mov r3,#4
	ldr r8,[r1,r3]
	add r3,r3,#4
	ldr r9,[r1,r3]
	gcd:
		cmp r8,r9
		subgt r8,r8,r9
		sublt r9,r9,r8
		mov r6,r8
		bxeq lr
		b gcd
multiply:
	mov r3,#4
	ldr r8,[r1,r3]
	add r3,r3,#4
	ldr r9,[r1,r3]
	mul r8,r9,r8
	mov r6,r8
	bx lr	
lcm:
	stmfd sp!, {r0,r1,lr}
	bl pre_gcd
	ldmfd sp!, {r0,r1,lr}
	mov r3,#4
	ldr r8,[r1,r3]
	add r3,r3,#4
	ldr r9,[r1,r3]
	
	mov r7,r6 					@r7 is gcm
	mov r3,#0					@r3=count
	mul r8,r9,r8
	stmfd sp!, {r0,r1,lr}
	bl lcm_divide
	ldmfd sp!, {r0,r1,lr}
	mov r6,r3
	bx lr
lcm_divide:
	cmp r8,r7
	bxlt lr
	sub r8,r8,r7
	add r3,r3,#1
	b lcm_divide
str2int_array:
	stmfd sp!, {r0-r6,fp,lr}
	mov r5,#0		@bit's index
	mov	r7,#0		@target number
	ldr r2,[r1,r3]	@r2=r1(array)的第4個開始
	bl str2int
	ldmfd sp!, {r0-r6,fp,lr}
	str r7, [r1, r3]
	add r3,r3,#4
	cmp r3,r4
	bxge lr
	b str2int_array

	
str2int:
	ldrb r6 , [r2,r5]  	@r2 [第r5個bit] =r6
	sub r6,#48			@r6 - 48
	cmp r6,#0			@check if r6 > 0
	bxlt lr				@return if r6 < 0
	cmp r6,#9			@check if r6 < 9
	bxgt lr				@return if r6 > 9
	add r7,r7,r7,lsl#2  @r7=r7*5
	mov r7,r7,lsl#1		@r7=r7*10
	add r7,r7,r6		@r7=r7+r6
	add r5,r5,#1		@r5+1換下一個bit
	b str2int
loop:
	stmfd sp!, {r0-r9,lr}
	ldr r0,=num
	ldr r1, [r1,r3]		@r2 is argv[r3]
	bl printf
	ldmfd sp!, {r0-r9,lr}
	add r3,r3,#4
	cmp r3,r4
	bxge lr
	b loop

   
is_num: 
	.asciz "is %d "
num:
	.asciz "%d "
func0_str:
	.asciz "Function 0: addition of "
func1_str:
	.asciz "Function 1: subtraction of "
func2_str:
	.asciz "Function 2: Bit reverse of "
func3_str:
	.asciz "Function 3: division of "
func4_str:
	.asciz "Function 4: maximum of "
func5_str:
	.asciz "Function 5: exponent of "
func6_str:
	.asciz "Function 6: greatest common divisor of "
func7_str:
	.asciz "Function 7: multiplication of "
func8_str:
	.asciz "Function 8: least common multiply of "	
and_str:
	.asciz "and "	


    .end
    
    