.text
/*
 * Prints message to std out
 * void _print( char *buf, size_t size )
 */
.globl _print
.func _print
_print:
	mov %rsi, %rdx # count = size (arg)
	mov %rdi, %rsi # buf = buf (arg)
	mov $1, %rax # sys write
	mov $1, %rdi # fd = std out
	syscall
	ret
.endfunc
.end
