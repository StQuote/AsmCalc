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
	mov $1, %rax			# call write
	mov $1, %rdi			# fd = STD_OUT
	mov $PromptMessage, %rsi 	# *buf = PromptMessage
	mov $PromptMessageSize, %rdx	# count = PromptMessageSize
	syscall
	
	xor %rax, %rax			# call read
	xor %rdi, %rdi			# fd = STD_IN
	mov $InputBuffer, %rsi		# *buf = InputBuffer
	mov $InputBufferSize, %rdx	# count = InputBufferSize
	syscall

	mov %rax, %rbx	# %rbx = count of readed bytes (%rax)
	
	# allocate memory with size of readed bytes*8 to store parsed value
	mov $0x9, %rax  # call mmap
	xor %rdi, %rdi  # addr = NULL
	mov %rbx, %rsi  # len = count of readed bytes 
	imul $0x8, %rsi # len = len * 8 (8 is register size in bytes)
	mov $0x3, %rdx  # prot = PROT_READ|PROT_WRITE
	mov $0x22, %r10 # flags = MAP_ANONYMOUS|MAP_PRIVATE
	mov $-1, %r8    # fd = -1
	xor %r9,  %r9	# off = 0
	syscall
	
	mov %rbx, %rcx
	xor %rdx, %rdx
	xor %rbx, %rbx

l_convexpr:
	mov InputBuffer(,%rdx), %bl
	
	cmp $0x0a, %bl # if char == '\n'
	je _exit
	
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
	#cmp $0x6b, %bl
	# if char == '-'
	#cmp $0x6d, %bl
	# if char == '*'
	#cmp $0x6a, %bl
	# if char == '/'
	#cmp $0x6f, %bl
	add $0x01, %rdx
	loop l_convexpr

l_convexpr_bracket:
	# if char == '('
	# 
l_convexpr_skip:
	add $0x01, %rdx
	loop l_convexpr


_exit:
	mov $60, %rax
	xor %rdi, %rdi
	syscall

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
