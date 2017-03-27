.include "syscall.s"

.section .rodata
	PromptMessage:
		.ascii "Enter expression ('q' to exit):"
		.set PromptMessageSize, . - PromptMessage
	
	.set InputBufferSize, 255
.bss
	.lcomm InputBuffer, InputBufferSize

.text
.globl _start
_start:
	syswrite $PromptMessage, $PromptMessageSize
	sysread $InputBuffer, $InputBufferSize
	mov %rax, %rcx
	xor %rdx, %rdx
	xor %rbx, %rbx

l_convexpr:
	mov InputBuffer(,%rdx), %bl
	
	cmp $0x0a, %bl # if char == '\n'
	je l_exit
	
	cmp $0x20, %bl # if char == ' '
	je l_convexpr_skip
	cmp $0x09, %bl # if char == '\t'
	je l_convexpr_skip
	
	cmp $0x30, %bl # if char < '0'
	jl l_convexpr_opr
	cmp $0x39, %bl # if char > '9'
	jg l_convexpr_opr
	
	lea InputBuffer, %rdi
	mov %rdx, %rsi
	call fn_atoi
	push %rax # save parsed value
	loop l_convexpr

l_convexpr_opr:
	# if char == '+'
	# if char == '-'
	# if char == '*'
	# if char == '/'
	add $0x01, %rdx
	loop l_convexpr

l_convexpr_skip:
	add $0x01, %rdx
	loop l_convexpr


l_exit:
	sysexit


/*
 * read int from char array. Read each char while is digit char (in ascii)
 * @param  %rdi - char *
 * @param  %rsi - int offset to start reading
 * @return %rax - int, %rdx - offset where reading is finished
 */
.type fn_atoi @function
fn_atoi:
	push %rbx
	xor %rbx, %rbx # current readed char
	xor %rax, %rax # result
	xor %rsi, %rdx # current offset
fn_atoi_loop:
	mov (%rdi, %rdx), %bl
	# if char is digit ascii representation
	cmp $0x30, %bl
	jl fn_atoi_end
	cmp $0x39, %bl
	jg fn_atoi_end	
	sub $0x30, %bl  # %rbx = char - '0'
	imul $0xa, %rax # result *= 10
	add %rbx, %rax  # result += %rbx
	inc %rdx	# inc current offset
	jmp fn_atoi_loop
fn_atoi_end:
	pop %rbx
	ret
