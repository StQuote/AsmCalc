.text

.macro syswrite Message:req, MessageSize:req, fd
	mov $1, %rax
	.ifb \fd
	mov $1, %rdi
	.endif
	.ifnb \fd
	mov \fd, %rdi
	.endif
	mov \Message, %rsi
	mov \MessageSize, %rdx
	syscall
.endm

.macro sysread Buffer, Size, fd
	xor %rax, %rax
	.ifb \fd
	xor %rdi, %rdi
	.endif
	.ifnb \fd
	mov \fd, %rdi
	.endif
	mov \Buffer, %rsi
	mov \Size, %rdx
	syscall
.endm

.macro sysexit Code
	mov $60, %rax
	.ifb \Code
	xor %rdi, %rdi
	.endif
	.ifnb \Code
	mov \Code, %rdi
	.endif
	syscall
.endm
