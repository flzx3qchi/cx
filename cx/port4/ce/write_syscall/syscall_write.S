section .data
str_c_lib: db "C library says: hello world!", 0xa 
str_c_lib_len equ $-str_c_lib

str_syscall: db "syscall says: hello world!", 0xa
str_syscall_len equ $-str_syscall

section .stack 

section .text
global _start
_start:
	push str_c_lib_len
	push str_c_lib
	push 1
	
	call my_write
	add esp, 12
	
	mov eax, 4             
	mov ebx, 1               ; fd
	mov ecx, str_syscall     ; buf
	mov edx, str_syscall_len ; count
	int 0x80
	
	mov eax, 1 ; exit()
	int 0x80

my_write:
	push ebp
	mov ebp, esp
	mov eax, 4
	mov ebx, [ebp + 8]    ; fd
	mov ecx, [ebp + 0xc]  ; buf
	mov edx, [ebp + 0x10] ; count
	int 0x80
	pop ebp
	ret
