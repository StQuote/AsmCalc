.section .rodata
	PromptMessage:
		.ascii "Enter expression ('q' to exit):"
		.set PromptMessageSize, . - PromptMessage
	
	.set InputBufferSize, 255

.data
	QueueAddr:
		.quad 0x0
	QueueOffset:
		.byte 0x0

.bss
	.lcomm InputBuffer, InputBufferSize

.text
.globl _start
_start:
	cmp $1, (%rsp)
	jle _exit
	
	mov 16(%rsp), %rdi
	call _strlen

	mov 16(%rsp), %rdi
	mov %rax, %rsi
	dec %rsi	
	call _print
_exit:
	mov $60, %rax
	xor %rdi, %rdi
	syscall
.end
