// A*B
// Schoolbook multiplication of four 64b limbs 
// result in r8 - r15
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

// Montgomery reduction 
// expects multiplication result in r8 - r15
// See algo 14.32 from Handbook of Applied Cryptography
.macro red_256 res name
   push   %rsi
   lea    .LM(%rip),   %rsi
   xor    %rax,        %rax
   mov    0x20(%rsi),  %rdx
   mulx   %r8,         %rdx,  %rbp
   mulx   0x00(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r8
   adcx   %rbx,        %r9
   mulx   0x08(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r9
   adcx   %rbx,        %r10
   mulx   0x10(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x18(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   adox   %rax,        %r12
   adcx   %rax,        %r13
   adox   %rax,        %r13
   adcx   %rax,        %r14
   adox   %rax,        %r14
   adcx   %rax,        %r15
   adox   %rax,        %r15
   mov    0x20(%rsi),  %rdx
   mulx   %r9,         %rdx,  %rbp
   mulx   0x00(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r9
   adcx   %rbx,        %r10
   mulx   0x08(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x10(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x18(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   adox   %rax,        %r13
   adcx   %rax,        %r14
   adox   %rax,        %r14
   adcx   %rax,        %r15
   adox   %rax,        %r15
   mov    0x20(%rsi),  %rdx
   mulx   %r10,        %rdx,  %rbp
   mulx   0x00(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x08(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x10(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   mulx   0x18(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r13
   adcx   %rbx,        %r14
   adox   %rax,        %r14
   adcx   %rax,        %r15
   adox   %rax,        %r15
   mov    0x20(%rsi),  %rdx
   mulx   %r11,        %rdx,  %rbp
   mov    0x00(%rsi),  %r8
   mulx   %r8,         %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mov    0x08(%rsi),  %r9
   mulx   %r9,         %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   mov    0x10(%rsi),  %r10
   mulx   %r10,        %rbp,  %rbx
   adox   %rbp,        %r13
   adcx   %rbx,        %r14
   mov    0x18(%rsi),  %r11
   mulx   %r11,        %rbp,  %rbx
   adox   %rbp,        %r14
   adcx   %rbx,        %r15
   adox   %rax,        %r15
   mov    %r12,        0x00\res
   mov    %r13,        0x08\res
   mov    %r14,        0x10\res
   mov    %r15,        0x18\res
   sub    %r8,         %r12
   sbb    %r9,         %r13
   sbb    %r10,        %r14
   sbb    %r11,        %r15
   jb     .Lred_256\name
   mov    %r12,        0x00\res
   mov    %r13,        0x08\res
   mov    %r14,        0x10\res
   mov    %r15,        0x18\res
.Lred_256\name:
   pop    %rsi
.endm

.macro mod_mul_256 a b res name
   mul_256 \a, \b
   red_256 \res, \name
.endm

// BLS12-381 G1 order r used as modulus
// Montgomery constant -m^-1 mod b
.LM:
   .quad 0xffffffff00000001
   .quad 0x53bda402fffe5bfe
   .quad 0x3339d80809a1d805
   .quad 0x73eda753299d7d48
   .quad 0xfffffffeffffffff
        
#ifdef __APPLE__
.global _mod_mul_4w
_mod_mul_4w:
#else
.global mod_mul_4w
mod_mul_4w:
#endif
   // x      = rdi
   // y      = rsi
   // result = rdx
   push %rbp
   push %rbx
   push %r12
   push %r13
   push %r14
   push %r15
   mov  %rdx,  %rcx  // rcx = result

   // x * y
   mod_mul_256 (%rdi), (%rsi), (%rcx), mm

   pop  %r15
   pop  %r14
   pop  %r13
   pop  %r12
   pop  %rbx
   pop  %rbp
   ret
