.file 1 "quotes.txt"
.section .rodata
.bar_locals:
.string "Hello there %s\n"
.text
bar:
.globl bar
.type bar, @function
.loc 1 1
.cfi_startproc
pushq %rbp
.cfi_def_cfa_offset 16
.cfi_offset 6, -16
movq %rsp, %rbp
.cfi_def_cfa_register 6
.loc 1 7
# uncomment this to see a stack trace
int $3
subq $16, %rsp
movq %rdi, -8(%rbp)
movq -8(%rbp), %rax
movq %rax, %rsi
leaq .bar_locals(%rip), %rdi
movl $0, %eax
call printf@PLT
nop
leave
.cfi_def_cfa 7, 8
ret
.loc 1 18
.cfi_endproc
.size bar,.-bar
