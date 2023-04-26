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

	@ mov r3,#4
	@ bl loop

	

	mov r3,#0				@r3=temp
	mov	r5,#0				@i
	mov	r6,#0				@j

	
	stmfd sp!, {lr}
	bl outer_bubble
	ldmfd sp!, {lr}

	stmfd sp!, {r1}
	ldr r0,=string0
	bl printf
	ldmfd sp!, {r1}

	mov r3,#4
	bl loop	
	@epilogue
	ldmfd	sp!, {r0-r9,fp, lr}
	bx	lr


outer_bubble:			@參數用r4(argc)、r5(i)、r6(j)
	cmp	r5,r4			@chack if i <i*argc
	bxge lr				@if i>= i*argc	return
	mov r6,#4			@j歸零
	sub r7,r4,r5		@argc-1-i
	sub r7,r7,#4
	b inner_bubble
label:
	add r5,r5,#4 		@i=i+4
	b outer_bubble
	
inner_bubble:
	cmp r6,r7			@j<=argc-1-i
	bge label			@if r6>=argc-1-i
	ldr r8,[r1,r6]		@r8 =arr[j]
	add r6,r6,#4
	ldr r9,[r1,r6]		@r9 =arr[j+1]
	cmp r8,r9
	sub r6, r6, #4
	strgt r9,[r1, r6]		@arr[j]=r9 arr[j+1]
	add r6,r6,#4
	strgt r8,[r1, r6]		@arr[j+1]=r8 arr[j]
	@add r6,r6,#4			@j=j+4
	b inner_bubble

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
	

   
num: 
	.asciz "%d "
string0:
	.asciz "sorting result is : "
string1: 
	.asciz "Argv: %s"



    .end
    
    