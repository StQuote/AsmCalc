.text
/*
 * Return len of string. String should ends with \0 char (in C manner)
 * long strlen( char *buf )
 */
.globl _strlen
.func
_strlen:
	mov $-1, %rcx
	xor %rax, %rax
	mov %rdi, %rsi
	cld
	repne scasb
	neg %rcx
	mov %rcx, %rax
	ret
.endfunc
.end
