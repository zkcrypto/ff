.macro mul_256 a  b
   xor    %rax,       %rax
   mov    0x00\a,     %rdx
   mulx   0x00\b,     %r8,   %r9
   mulx   0x08\b,     %rbx,  %r10
   adcx   %rbx,       %r9
   mulx   0x10\b,     %rbx,  %r11
   adcx   %rbx,       %r10
   mulx   0x18\b,     %rbx,  %r12
   adcx   %rbx,       %r11
   adcx   %rax,       %r12
   xor    %rax,       %rax
   mov    0x08\a,     %rdx
   mulx   0x00\b,     %rbp,  %rbx
   adcx   %rbp,       %r9
   adox   %rbx,       %r10
   mulx   0x08\b,     %rbp,  %rbx
   adcx   %rbp,       %r10
   adox   %rbx,       %r11
   mulx   0x10\b,     %rbp,  %rbx
   adcx   %rbp,       %r11
   adox   %rbx,       %r12
   mulx   0x18\b,     %rbp,  %r13
   adcx   %rbp,       %r12
   adox   %rax,       %r13
   adcx   %rax,       %r13
   xor    %rax,       %rax
   mov    0x10\a,     %rdx
   mulx   0x00\b,     %rbp,  %rbx
   adcx   %rbp,       %r10
   adox   %rbx,       %r11
   mulx   0x08\b,     %rbp,  %rbx
   adcx   %rbp,       %r11
   adox   %rbx,       %r12
   mulx   0x10\b,     %rbp,  %rbx
   adcx   %rbp,       %r12
   adox   %rbx,       %r13
   mulx   0x18\b,     %rbp,  %r14
   adcx   %rbp,       %r13
   adox   %rax,       %r14
   adcx   %rax,       %r14
   xor    %rax,       %rax
   mov    0x18\a,     %rdx
   mulx   0x00\b,     %rbp,  %rbx
   adcx   %rbp,       %r11
   adox   %rbx,       %r12
   mulx   0x08\b,     %rbp,  %rbx
   adcx   %rbp,       %r12
   adox   %rbx,       %r13
   mulx   0x10\b,     %rbp,  %rbx
   adcx   %rbp,       %r13
   adox   %rbx,       %r14
   mulx   0x18\b,     %rbp,  %r15
   adcx   %rbp,       %r14
   adox   %rax,       %r15
   adcx   %rax,       %r15
.endm

.macro red_256 res
   mov    %rsi,        0x200(%rsp)
   lea    .LM(%rip),   %rsi
   mov    %r13,        0x1e8(%rsp)
   mov    %r14,        0x1f0(%rsp)
   mov    %r15,        0x1f8(%rsp)
   xor    %r13,        %r13
   xor    %r14,        %r14
   xor    %r15,        %r15
   xor    %rax,        %rax
   mov    0x300(%rsi), %rdx
   mulx   %r8,         %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r8
   adcx   %rbx,        %r9
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r9
   adcx   %rbx,        %r10
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   adox   %rax,        %r12
   adcx   %rax,        %r13
   adox   %rax,        %r13
   mov    0x300(%rsi), %rdx
   mulx   %r9,         %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r9
   adcx   %rbx,        %r10
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   adox   0x1e8(%rsp), %r13
   adcx   %rax,        %r14
   adox   %rax,        %r14
   mov    0x300(%rsi), %rdx
   mulx   %r10,        %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r13
   adcx   %rbx,        %r14
   adox   0x1f0(%rsp), %r14
   adcx   %rax,        %r15
   adox   %rax,        %r15
   mov    0x300(%rsi), %rdx
   mulx   %r11,        %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r13
   adcx   %rbx,        %r14
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r14
   adcx   %rbx,        %r15
   adox   0x1f8(%rsp), %r15
   adcx   %rax,        %r8
   adox   %rax,        %r8
   shl    $0x3,        %r8
   sub    0x00(%rsi,%r8,1),  %r12
   sbb    0x08(%r8,%rsi,1),  %r13
   sbb    0x10(%r8,%rsi,1),  %r14
   sbb    0x18(%r8,%rsi,1),  %r15
   mov    0x200(%rsp), %rsi
   mov    %r12,        0x00\res
   mov    %r13,        0x08\res
   mov    %r14,        0x10\res
   mov    %r15,        0x18\res
.endm

.macro mod_mul_256 a b res
   mul_256 \a, \b
   red_256 \res
.endm


.LM:
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xffffffff00000001
   .quad 0x53bda402fffe5bfe
   .quad 0x3339d80809a1d805
   .quad 0x73eda753299d7d48
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffe00000002
   .quad 0xa77b4805fffcb7fd
   .quad 0x6673b0101343b00a
   .quad 0xe7db4ea6533afa90
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffd00000003
   .quad 0xfb38ec08fffb13fc
   .quad 0x99ad88181ce5880f
   .quad 0x5bc8f5f97cd877d8
   .quad 0x0000000000000001
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffc00000004
   .quad 0x4ef6900bfff96ffb
   .quad 0xcce7602026876015
   .quad 0xcfb69d4ca675f520
   .quad 0x0000000000000001
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffb00000005
   .quad 0xa2b4340efff7cbfa
   .quad 0x2138283029381a
   .quad 0x43a4449fd0137269
   .quad 0x0000000000000002
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffa00000006
   .quad 0xf671d811fff627f9
   .quad 0x335b103039cb101f
   .quad 0xb791ebf2f9b0efb1
   .quad 0x0000000000000002
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffff900000007
   .quad 0x4a2f7c14fff483f8
   .quad 0x6694e838436ce825
   .quad 0x2b7f9346234e6cf9
   .quad 0x0000000000000003
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xffffffff00000001
   .quad 0x53bda402fffe5bfe
   .quad 0x3339d80809a1d805
   .quad 0x73eda753299d7d48
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffe00000002
   .quad 0xa77b4805fffcb7fd
   .quad 0x6673b0101343b00a
   .quad 0xe7db4ea6533afa90
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffe00000002
   .quad 0xa77b4805fffcb7fd
   .quad 0x6673b0101343b00a
   .quad 0xe7db4ea6533afa90
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffeffffffff
        
#ifdef __APPLE__
.global _mod_mul_4w
_mod_mul_4w:
#else
.global mod_mul_4w
mod_mul_4w:
#endif
   // p1     = rdi
   // p2     = rsi
   // result = rdx
   push %rbp
   push %rbx
   push %r12
   push %r13
   push %r14
   push %r15
   sub  $8*65, %rsp
   mov  %rdx,  %rcx  // rcx = result
   // p1 * p2
   mod_mul_256 (%rdi), (%rsi), (%rcx)
   //mov (%rcx), %rdx
   //add $100, %rdx
   //mov %rdx, (%rcx)
   add  $8*65, %rsp
   pop  %r15
   pop  %r14
   pop  %r13
   pop  %r12
   pop  %rbx
   pop  %rbp
   ret
