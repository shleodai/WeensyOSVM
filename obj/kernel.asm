
obj/kernel.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000040000 <entry_from_boot>:
# The entry_from_boot routine sets the stack pointer to the top of the
# OS kernel stack, then jumps to the `kernel` routine.

.globl entry_from_boot
entry_from_boot:
        movq $0x80000, %rsp
   40000:	48 c7 c4 00 00 08 00 	mov    $0x80000,%rsp
        movq %rsp, %rbp
   40007:	48 89 e5             	mov    %rsp,%rbp
        pushq $0
   4000a:	6a 00                	push   $0x0
        popfq
   4000c:	9d                   	popf   
        // Check for multiboot command line; if found pass it along.
        cmpl $0x2BADB002, %eax
   4000d:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
        jne 1f
   40012:	75 0d                	jne    40021 <entry_from_boot+0x21>
        testl $4, (%rbx)
   40014:	f7 03 04 00 00 00    	testl  $0x4,(%rbx)
        je 1f
   4001a:	74 05                	je     40021 <entry_from_boot+0x21>
        movl 16(%rbx), %edi
   4001c:	8b 7b 10             	mov    0x10(%rbx),%edi
        jmp 2f
   4001f:	eb 07                	jmp    40028 <entry_from_boot+0x28>
1:      movq $0, %rdi
   40021:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
2:      jmp kernel
   40028:	e9 3a 01 00 00       	jmp    40167 <kernel>
   4002d:	90                   	nop

000000000004002e <gpf_int_handler>:
# Interrupt handlers
.align 2

        .globl gpf_int_handler
gpf_int_handler:
        pushq $13               // trap number
   4002e:	6a 0d                	push   $0xd
        jmp generic_exception_handler
   40030:	eb 6e                	jmp    400a0 <generic_exception_handler>

0000000000040032 <pagefault_int_handler>:

        .globl pagefault_int_handler
pagefault_int_handler:
        pushq $14
   40032:	6a 0e                	push   $0xe
        jmp generic_exception_handler
   40034:	eb 6a                	jmp    400a0 <generic_exception_handler>

0000000000040036 <timer_int_handler>:

        .globl timer_int_handler
timer_int_handler:
        pushq $0                // error code
   40036:	6a 00                	push   $0x0
        pushq $32
   40038:	6a 20                	push   $0x20
        jmp generic_exception_handler
   4003a:	eb 64                	jmp    400a0 <generic_exception_handler>

000000000004003c <sys48_int_handler>:

sys48_int_handler:
        pushq $0
   4003c:	6a 00                	push   $0x0
        pushq $48
   4003e:	6a 30                	push   $0x30
        jmp generic_exception_handler
   40040:	eb 5e                	jmp    400a0 <generic_exception_handler>

0000000000040042 <sys49_int_handler>:

sys49_int_handler:
        pushq $0
   40042:	6a 00                	push   $0x0
        pushq $49
   40044:	6a 31                	push   $0x31
        jmp generic_exception_handler
   40046:	eb 58                	jmp    400a0 <generic_exception_handler>

0000000000040048 <sys50_int_handler>:

sys50_int_handler:
        pushq $0
   40048:	6a 00                	push   $0x0
        pushq $50
   4004a:	6a 32                	push   $0x32
        jmp generic_exception_handler
   4004c:	eb 52                	jmp    400a0 <generic_exception_handler>

000000000004004e <sys51_int_handler>:

sys51_int_handler:
        pushq $0
   4004e:	6a 00                	push   $0x0
        pushq $51
   40050:	6a 33                	push   $0x33
        jmp generic_exception_handler
   40052:	eb 4c                	jmp    400a0 <generic_exception_handler>

0000000000040054 <sys52_int_handler>:

sys52_int_handler:
        pushq $0
   40054:	6a 00                	push   $0x0
        pushq $52
   40056:	6a 34                	push   $0x34
        jmp generic_exception_handler
   40058:	eb 46                	jmp    400a0 <generic_exception_handler>

000000000004005a <sys53_int_handler>:

sys53_int_handler:
        pushq $0
   4005a:	6a 00                	push   $0x0
        pushq $53
   4005c:	6a 35                	push   $0x35
        jmp generic_exception_handler
   4005e:	eb 40                	jmp    400a0 <generic_exception_handler>

0000000000040060 <sys54_int_handler>:

sys54_int_handler:
        pushq $0
   40060:	6a 00                	push   $0x0
        pushq $54
   40062:	6a 36                	push   $0x36
        jmp generic_exception_handler
   40064:	eb 3a                	jmp    400a0 <generic_exception_handler>

0000000000040066 <sys55_int_handler>:

sys55_int_handler:
        pushq $0
   40066:	6a 00                	push   $0x0
        pushq $55
   40068:	6a 37                	push   $0x37
        jmp generic_exception_handler
   4006a:	eb 34                	jmp    400a0 <generic_exception_handler>

000000000004006c <sys56_int_handler>:

sys56_int_handler:
        pushq $0
   4006c:	6a 00                	push   $0x0
        pushq $56
   4006e:	6a 38                	push   $0x38
        jmp generic_exception_handler
   40070:	eb 2e                	jmp    400a0 <generic_exception_handler>

0000000000040072 <sys57_int_handler>:

sys57_int_handler:
        pushq $0
   40072:	6a 00                	push   $0x0
        pushq $57
   40074:	6a 39                	push   $0x39
        jmp generic_exception_handler
   40076:	eb 28                	jmp    400a0 <generic_exception_handler>

0000000000040078 <sys58_int_handler>:

sys58_int_handler:
        pushq $0
   40078:	6a 00                	push   $0x0
        pushq $58
   4007a:	6a 3a                	push   $0x3a
        jmp generic_exception_handler
   4007c:	eb 22                	jmp    400a0 <generic_exception_handler>

000000000004007e <sys59_int_handler>:

sys59_int_handler:
        pushq $0
   4007e:	6a 00                	push   $0x0
        pushq $59
   40080:	6a 3b                	push   $0x3b
        jmp generic_exception_handler
   40082:	eb 1c                	jmp    400a0 <generic_exception_handler>

0000000000040084 <sys60_int_handler>:

sys60_int_handler:
        pushq $0
   40084:	6a 00                	push   $0x0
        pushq $60
   40086:	6a 3c                	push   $0x3c
        jmp generic_exception_handler
   40088:	eb 16                	jmp    400a0 <generic_exception_handler>

000000000004008a <sys61_int_handler>:

sys61_int_handler:
        pushq $0
   4008a:	6a 00                	push   $0x0
        pushq $61
   4008c:	6a 3d                	push   $0x3d
        jmp generic_exception_handler
   4008e:	eb 10                	jmp    400a0 <generic_exception_handler>

0000000000040090 <sys62_int_handler>:

sys62_int_handler:
        pushq $0
   40090:	6a 00                	push   $0x0
        pushq $62
   40092:	6a 3e                	push   $0x3e
        jmp generic_exception_handler
   40094:	eb 0a                	jmp    400a0 <generic_exception_handler>

0000000000040096 <sys63_int_handler>:

sys63_int_handler:
        pushq $0
   40096:	6a 00                	push   $0x0
        pushq $63
   40098:	6a 3f                	push   $0x3f
        jmp generic_exception_handler
   4009a:	eb 04                	jmp    400a0 <generic_exception_handler>

000000000004009c <default_int_handler>:

        .globl default_int_handler
default_int_handler:
        pushq $0
   4009c:	6a 00                	push   $0x0
        jmp generic_exception_handler
   4009e:	eb 00                	jmp    400a0 <generic_exception_handler>

00000000000400a0 <generic_exception_handler>:


generic_exception_handler:
        pushq %gs
   400a0:	0f a8                	push   %gs
        pushq %fs
   400a2:	0f a0                	push   %fs
        pushq %r15
   400a4:	41 57                	push   %r15
        pushq %r14
   400a6:	41 56                	push   %r14
        pushq %r13
   400a8:	41 55                	push   %r13
        pushq %r12
   400aa:	41 54                	push   %r12
        pushq %r11
   400ac:	41 53                	push   %r11
        pushq %r10
   400ae:	41 52                	push   %r10
        pushq %r9
   400b0:	41 51                	push   %r9
        pushq %r8
   400b2:	41 50                	push   %r8
        pushq %rdi
   400b4:	57                   	push   %rdi
        pushq %rsi
   400b5:	56                   	push   %rsi
        pushq %rbp
   400b6:	55                   	push   %rbp
        pushq %rbx
   400b7:	53                   	push   %rbx
        pushq %rdx
   400b8:	52                   	push   %rdx
        pushq %rcx
   400b9:	51                   	push   %rcx
        pushq %rax
   400ba:	50                   	push   %rax
        movq %rsp, %rdi
   400bb:	48 89 e7             	mov    %rsp,%rdi
        call exception
   400be:	e8 3b 09 00 00       	call   409fe <exception>

00000000000400c3 <exception_return>:
        # `exception` should never return.


        .globl exception_return
exception_return:
        movq %rdi, %rsp
   400c3:	48 89 fc             	mov    %rdi,%rsp
        popq %rax
   400c6:	58                   	pop    %rax
        popq %rcx
   400c7:	59                   	pop    %rcx
        popq %rdx
   400c8:	5a                   	pop    %rdx
        popq %rbx
   400c9:	5b                   	pop    %rbx
        popq %rbp
   400ca:	5d                   	pop    %rbp
        popq %rsi
   400cb:	5e                   	pop    %rsi
        popq %rdi
   400cc:	5f                   	pop    %rdi
        popq %r8
   400cd:	41 58                	pop    %r8
        popq %r9
   400cf:	41 59                	pop    %r9
        popq %r10
   400d1:	41 5a                	pop    %r10
        popq %r11
   400d3:	41 5b                	pop    %r11
        popq %r12
   400d5:	41 5c                	pop    %r12
        popq %r13
   400d7:	41 5d                	pop    %r13
        popq %r14
   400d9:	41 5e                	pop    %r14
        popq %r15
   400db:	41 5f                	pop    %r15
        popq %fs
   400dd:	0f a1                	pop    %fs
        popq %gs
   400df:	0f a9                	pop    %gs
        addq $16, %rsp
   400e1:	48 83 c4 10          	add    $0x10,%rsp
        iretq
   400e5:	48 cf                	iretq  

00000000000400e7 <sys_int_handlers>:
   400e7:	3c 00                	cmp    $0x0,%al
   400e9:	04 00                	add    $0x0,%al
   400eb:	00 00                	add    %al,(%rax)
   400ed:	00 00                	add    %al,(%rax)
   400ef:	42 00 04 00          	add    %al,(%rax,%r8,1)
   400f3:	00 00                	add    %al,(%rax)
   400f5:	00 00                	add    %al,(%rax)
   400f7:	48 00 04 00          	rex.W add %al,(%rax,%rax,1)
   400fb:	00 00                	add    %al,(%rax)
   400fd:	00 00                	add    %al,(%rax)
   400ff:	4e 00 04 00          	rex.WRX add %r8b,(%rax,%r8,1)
   40103:	00 00                	add    %al,(%rax)
   40105:	00 00                	add    %al,(%rax)
   40107:	54                   	push   %rsp
   40108:	00 04 00             	add    %al,(%rax,%rax,1)
   4010b:	00 00                	add    %al,(%rax)
   4010d:	00 00                	add    %al,(%rax)
   4010f:	5a                   	pop    %rdx
   40110:	00 04 00             	add    %al,(%rax,%rax,1)
   40113:	00 00                	add    %al,(%rax)
   40115:	00 00                	add    %al,(%rax)
   40117:	60                   	(bad)  
   40118:	00 04 00             	add    %al,(%rax,%rax,1)
   4011b:	00 00                	add    %al,(%rax)
   4011d:	00 00                	add    %al,(%rax)
   4011f:	66 00 04 00          	data16 add %al,(%rax,%rax,1)
   40123:	00 00                	add    %al,(%rax)
   40125:	00 00                	add    %al,(%rax)
   40127:	6c                   	insb   (%dx),%es:(%rdi)
   40128:	00 04 00             	add    %al,(%rax,%rax,1)
   4012b:	00 00                	add    %al,(%rax)
   4012d:	00 00                	add    %al,(%rax)
   4012f:	72 00                	jb     40131 <sys_int_handlers+0x4a>
   40131:	04 00                	add    $0x0,%al
   40133:	00 00                	add    %al,(%rax)
   40135:	00 00                	add    %al,(%rax)
   40137:	78 00                	js     40139 <sys_int_handlers+0x52>
   40139:	04 00                	add    $0x0,%al
   4013b:	00 00                	add    %al,(%rax)
   4013d:	00 00                	add    %al,(%rax)
   4013f:	7e 00                	jle    40141 <sys_int_handlers+0x5a>
   40141:	04 00                	add    $0x0,%al
   40143:	00 00                	add    %al,(%rax)
   40145:	00 00                	add    %al,(%rax)
   40147:	84 00                	test   %al,(%rax)
   40149:	04 00                	add    $0x0,%al
   4014b:	00 00                	add    %al,(%rax)
   4014d:	00 00                	add    %al,(%rax)
   4014f:	8a 00                	mov    (%rax),%al
   40151:	04 00                	add    $0x0,%al
   40153:	00 00                	add    %al,(%rax)
   40155:	00 00                	add    %al,(%rax)
   40157:	90                   	nop
   40158:	00 04 00             	add    %al,(%rax,%rax,1)
   4015b:	00 00                	add    %al,(%rax)
   4015d:	00 00                	add    %al,(%rax)
   4015f:	96                   	xchg   %eax,%esi
   40160:	00 04 00             	add    %al,(%rax,%rax,1)
   40163:	00 00                	add    %al,(%rax)
	...

0000000000040167 <kernel>:
//    Initialize the hardware and processes and start running. The `command`
//    string is an optional string passed from the boot loader.

static void process_setup(pid_t pid, int program_number);

void kernel(const char* command) {
   40167:	f3 0f 1e fa          	endbr64 
   4016b:	55                   	push   %rbp
   4016c:	48 89 e5             	mov    %rsp,%rbp
   4016f:	48 83 ec 20          	sub    $0x20,%rsp
   40173:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    hardware_init();
   40177:	e8 4c 1a 00 00       	call   41bc8 <hardware_init>
    pageinfo_init();
   4017c:	e8 8e 0c 00 00       	call   40e0f <pageinfo_init>
    console_clear();
   40181:	e8 60 3f 00 00       	call   440e6 <console_clear>
    timer_init(HZ);
   40186:	bf 64 00 00 00       	mov    $0x64,%edi
   4018b:	e8 a0 1f 00 00       	call   42130 <timer_init>

    // Set up process descriptors
    memset(processes, 0, sizeof(processes));
   40190:	ba 80 0d 00 00       	mov    $0xd80,%edx
   40195:	be 00 00 00 00       	mov    $0x0,%esi
   4019a:	48 8d 05 7f 2e 01 00 	lea    0x12e7f(%rip),%rax        # 53020 <processes>
   401a1:	48 89 c7             	mov    %rax,%rdi
   401a4:	e8 f9 35 00 00       	call   437a2 <memset>
    for (pid_t i = 0; i < NPROC; i++) {
   401a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   401b0:	eb 61                	jmp    40213 <kernel+0xac>
        processes[i].p_pid = i;
   401b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401b5:	48 63 d0             	movslq %eax,%rdx
   401b8:	48 89 d0             	mov    %rdx,%rax
   401bb:	48 01 c0             	add    %rax,%rax
   401be:	48 01 d0             	add    %rdx,%rax
   401c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   401c8:	00 
   401c9:	48 01 d0             	add    %rdx,%rax
   401cc:	48 c1 e0 03          	shl    $0x3,%rax
   401d0:	48 89 c1             	mov    %rax,%rcx
   401d3:	48 8d 15 46 2e 01 00 	lea    0x12e46(%rip),%rdx        # 53020 <processes>
   401da:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401dd:	89 04 11             	mov    %eax,(%rcx,%rdx,1)
        processes[i].p_state = P_FREE;
   401e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401e3:	48 63 d0             	movslq %eax,%rdx
   401e6:	48 89 d0             	mov    %rdx,%rax
   401e9:	48 01 c0             	add    %rax,%rax
   401ec:	48 01 d0             	add    %rdx,%rax
   401ef:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   401f6:	00 
   401f7:	48 01 d0             	add    %rdx,%rax
   401fa:	48 c1 e0 03          	shl    $0x3,%rax
   401fe:	48 89 c2             	mov    %rax,%rdx
   40201:	48 8d 05 e0 2e 01 00 	lea    0x12ee0(%rip),%rax        # 530e8 <processes+0xc8>
   40208:	c7 04 02 00 00 00 00 	movl   $0x0,(%rdx,%rax,1)
    for (pid_t i = 0; i < NPROC; i++) {
   4020f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40213:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   40217:	7e 99                	jle    401b2 <kernel+0x4b>
        - The kernel should be isolated from the user processes.
        - However, user processes should be able to access section "console" in kernel
            to .
    */
    // map the kernel section to the kernel pagetable, and make it read-only to user processes
    virtual_memory_map(kernel_pagetable, 0, 0, 0x100000, PTE_P|PTE_W, NULL);
   40219:	48 8b 05 e0 4d 01 00 	mov    0x14de0(%rip),%rax        # 55000 <kernel_pagetable>
   40220:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40226:	41 b8 03 00 00 00    	mov    $0x3,%r8d
   4022c:	b9 00 00 10 00       	mov    $0x100000,%ecx
   40231:	ba 00 00 00 00       	mov    $0x0,%edx
   40236:	be 00 00 00 00       	mov    $0x0,%esi
   4023b:	48 89 c7             	mov    %rax,%rdi
   4023e:	e8 79 20 00 00       	call   422bc <virtual_memory_map>
    // allow user processes to access the console section
    uintptr_t console_ptr = (uintptr_t) &console;
   40243:	48 8d 05 b6 7d 07 00 	lea    0x77db6(%rip),%rax        # b8000 <console>
   4024a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    virtual_memory_map(kernel_pagetable, console_ptr, console_ptr, PAGESIZE, PTE_P|PTE_W|PTE_U, NULL);
   4024e:	48 8b 05 ab 4d 01 00 	mov    0x14dab(%rip),%rax        # 55000 <kernel_pagetable>
   40255:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40259:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   4025d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40263:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   40269:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4026e:	48 89 c7             	mov    %rax,%rdi
   40271:	e8 46 20 00 00       	call   422bc <virtual_memory_map>


#if FORCE_FORK
    process_setup(1, 4);
#else
    if (command && strcmp(command, "fork") == 0) {
   40276:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   4027b:	74 2b                	je     402a8 <kernel+0x141>
   4027d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40281:	48 8d 15 98 3e 00 00 	lea    0x3e98(%rip),%rdx        # 44120 <console_clear+0x3a>
   40288:	48 89 d6             	mov    %rdx,%rsi
   4028b:	48 89 c7             	mov    %rax,%rdi
   4028e:	e8 90 35 00 00       	call   43823 <strcmp>
   40293:	85 c0                	test   %eax,%eax
   40295:	75 11                	jne    402a8 <kernel+0x141>
        process_setup(1, 4);
   40297:	be 04 00 00 00       	mov    $0x4,%esi
   4029c:	bf 01 00 00 00       	mov    $0x1,%edi
   402a1:	e8 68 00 00 00       	call   4030e <process_setup>
   402a6:	eb 57                	jmp    402ff <kernel+0x198>
    } else if (command && strcmp(command, "forkexit") == 0) {
   402a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   402ad:	74 2b                	je     402da <kernel+0x173>
   402af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   402b3:	48 8d 15 6b 3e 00 00 	lea    0x3e6b(%rip),%rdx        # 44125 <console_clear+0x3f>
   402ba:	48 89 d6             	mov    %rdx,%rsi
   402bd:	48 89 c7             	mov    %rax,%rdi
   402c0:	e8 5e 35 00 00       	call   43823 <strcmp>
   402c5:	85 c0                	test   %eax,%eax
   402c7:	75 11                	jne    402da <kernel+0x173>
        process_setup(1, 5);
   402c9:	be 05 00 00 00       	mov    $0x5,%esi
   402ce:	bf 01 00 00 00       	mov    $0x1,%edi
   402d3:	e8 36 00 00 00       	call   4030e <process_setup>
   402d8:	eb 25                	jmp    402ff <kernel+0x198>
    } else {
        for (pid_t i = 1; i <= 4; ++i) {
   402da:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
   402e1:	eb 16                	jmp    402f9 <kernel+0x192>
            process_setup(i, i - 1);
   402e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
   402e6:	8d 50 ff             	lea    -0x1(%rax),%edx
   402e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
   402ec:	89 d6                	mov    %edx,%esi
   402ee:	89 c7                	mov    %eax,%edi
   402f0:	e8 19 00 00 00       	call   4030e <process_setup>
        for (pid_t i = 1; i <= 4; ++i) {
   402f5:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   402f9:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
   402fd:	7e e4                	jle    402e3 <kernel+0x17c>
#endif
    


    // Switch to the first process using run()
    run(&processes[1]);
   402ff:	48 8d 05 f2 2d 01 00 	lea    0x12df2(%rip),%rax        # 530f8 <processes+0xd8>
   40306:	48 89 c7             	mov    %rax,%rdi
   40309:	e8 96 0a 00 00       	call   40da4 <run>

000000000004030e <process_setup>:
// process_setup(pid, program_number)
//    Load application program `program_number` as process number `pid`.
//    This loads the application's code and data into memory, sets its
//    %rip and %rsp, gives it a stack page, and marks it as runnable.

void process_setup(pid_t pid, int program_number) {
   4030e:	f3 0f 1e fa          	endbr64 
   40312:	55                   	push   %rbp
   40313:	48 89 e5             	mov    %rsp,%rbp
   40316:	48 83 ec 30          	sub    $0x30,%rsp
   4031a:	89 7d dc             	mov    %edi,-0x24(%rbp)
   4031d:	89 75 d8             	mov    %esi,-0x28(%rbp)
    process_init(&processes[pid], 0);
   40320:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40323:	48 63 d0             	movslq %eax,%rdx
   40326:	48 89 d0             	mov    %rdx,%rax
   40329:	48 01 c0             	add    %rax,%rax
   4032c:	48 01 d0             	add    %rdx,%rax
   4032f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40336:	00 
   40337:	48 01 d0             	add    %rdx,%rax
   4033a:	48 c1 e0 03          	shl    $0x3,%rax
   4033e:	48 8d 15 db 2c 01 00 	lea    0x12cdb(%rip),%rdx        # 53020 <processes>
   40345:	48 01 d0             	add    %rdx,%rax
   40348:	be 00 00 00 00       	mov    $0x0,%esi
   4034d:	48 89 c7             	mov    %rax,%rdi
   40350:	e8 29 28 00 00       	call   42b7e <process_init>
        - Change the way initial pagetables are assigned to processes.
        - Initially, all processes share the same pagetable like this:
            processes[pid].p_pagetable = kernel_pagetable;
        - Change this so that each process has its own pagetable.
    */
    processes[pid].p_pagetable = copy_pagetable(kernel_pagetable, pid); 
   40355:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40358:	0f be d0             	movsbl %al,%edx
   4035b:	48 8b 05 9e 4c 01 00 	mov    0x14c9e(%rip),%rax        # 55000 <kernel_pagetable>
   40362:	89 d6                	mov    %edx,%esi
   40364:	48 89 c7             	mov    %rax,%rdi
   40367:	e8 8a 01 00 00       	call   404f6 <copy_pagetable>
   4036c:	48 89 c2             	mov    %rax,%rdx
   4036f:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40372:	48 63 c8             	movslq %eax,%rcx
   40375:	48 89 c8             	mov    %rcx,%rax
   40378:	48 01 c0             	add    %rax,%rax
   4037b:	48 01 c8             	add    %rcx,%rax
   4037e:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
   40385:	00 
   40386:	48 01 c8             	add    %rcx,%rax
   40389:	48 c1 e0 03          	shl    $0x3,%rax
   4038d:	48 89 c1             	mov    %rax,%rcx
   40390:	48 8d 05 59 2d 01 00 	lea    0x12d59(%rip),%rax        # 530f0 <processes+0xd0>
   40397:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
    //     }
    // }

    // This line should be removed after Step 2
    // ++pageinfo[PAGENUMBER(kernel_pagetable)].refcount;
    int r = program_load(&processes[pid], program_number, NULL);
   4039b:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4039e:	48 63 d0             	movslq %eax,%rdx
   403a1:	48 89 d0             	mov    %rdx,%rax
   403a4:	48 01 c0             	add    %rax,%rax
   403a7:	48 01 d0             	add    %rdx,%rax
   403aa:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   403b1:	00 
   403b2:	48 01 d0             	add    %rdx,%rax
   403b5:	48 c1 e0 03          	shl    $0x3,%rax
   403b9:	48 8d 15 60 2c 01 00 	lea    0x12c60(%rip),%rdx        # 53020 <processes>
   403c0:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
   403c4:	8b 45 d8             	mov    -0x28(%rbp),%eax
   403c7:	ba 00 00 00 00       	mov    $0x0,%edx
   403cc:	89 c6                	mov    %eax,%esi
   403ce:	48 89 cf             	mov    %rcx,%rdi
   403d1:	e8 da 2f 00 00       	call   433b0 <program_load>
   403d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
    assert(r >= 0);
   403d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   403dd:	79 1e                	jns    403fd <process_setup+0xef>
   403df:	48 8d 05 48 3d 00 00 	lea    0x3d48(%rip),%rax        # 4412e <console_clear+0x48>
   403e6:	48 89 c2             	mov    %rax,%rdx
   403e9:	be ab 00 00 00       	mov    $0xab,%esi
   403ee:	48 8d 05 40 3d 00 00 	lea    0x3d40(%rip),%rax        # 44135 <console_clear+0x4f>
   403f5:	48 89 c7             	mov    %rax,%rdi
   403f8:	e8 7a 2f 00 00       	call   43377 <assert_fail>
    // processes[pid].p_registers.reg_rsp = PROC_START_ADDR + PROC_SIZE * pid;
    // Step 4:
    processes[pid].p_registers.reg_rsp = MEMSIZE_VIRTUAL;
   403fd:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40400:	48 63 d0             	movslq %eax,%rdx
   40403:	48 89 d0             	mov    %rdx,%rax
   40406:	48 01 c0             	add    %rax,%rax
   40409:	48 01 d0             	add    %rdx,%rax
   4040c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40413:	00 
   40414:	48 01 d0             	add    %rdx,%rax
   40417:	48 c1 e0 03          	shl    $0x3,%rax
   4041b:	48 89 c2             	mov    %rax,%rdx
   4041e:	48 8d 05 b3 2c 01 00 	lea    0x12cb3(%rip),%rax        # 530d8 <processes+0xb8>
   40425:	48 c7 04 02 00 00 30 	movq   $0x300000,(%rdx,%rax,1)
   4042c:	00 
    uintptr_t stack_page = processes[pid].p_registers.reg_rsp - PAGESIZE;
   4042d:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40430:	48 63 d0             	movslq %eax,%rdx
   40433:	48 89 d0             	mov    %rdx,%rax
   40436:	48 01 c0             	add    %rax,%rax
   40439:	48 01 d0             	add    %rdx,%rax
   4043c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40443:	00 
   40444:	48 01 d0             	add    %rdx,%rax
   40447:	48 c1 e0 03          	shl    $0x3,%rax
   4044b:	48 89 c2             	mov    %rax,%rdx
   4044e:	48 8d 05 83 2c 01 00 	lea    0x12c83(%rip),%rax        # 530d8 <processes+0xb8>
   40455:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
   40459:	48 2d 00 10 00 00    	sub    $0x1000,%rax
   4045f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    uintptr_t stack_p_addr = get_free_addr((int8_t)pid);
   40463:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40466:	0f be c0             	movsbl %al,%eax
   40469:	89 c7                	mov    %eax,%edi
   4046b:	e8 8c 01 00 00       	call   405fc <get_free_addr>
   40470:	48 98                	cltq   
   40472:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    virtual_memory_map(processes[pid].p_pagetable, stack_page, stack_p_addr,
   40476:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40479:	48 63 d0             	movslq %eax,%rdx
   4047c:	48 89 d0             	mov    %rdx,%rax
   4047f:	48 01 c0             	add    %rax,%rax
   40482:	48 01 d0             	add    %rdx,%rax
   40485:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   4048c:	00 
   4048d:	48 01 d0             	add    %rdx,%rax
   40490:	48 c1 e0 03          	shl    $0x3,%rax
   40494:	48 89 c2             	mov    %rax,%rdx
   40497:	48 8d 05 52 2c 01 00 	lea    0x12c52(%rip),%rax        # 530f0 <processes+0xd0>
   4049e:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
   404a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   404a6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   404aa:	4c 8d 0d fe 00 00 00 	lea    0xfe(%rip),%r9        # 405af <pagetable_alloc>
   404b1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   404b7:	b9 00 10 00 00       	mov    $0x1000,%ecx
   404bc:	48 89 c7             	mov    %rax,%rdi
   404bf:	e8 f8 1d 00 00       	call   422bc <virtual_memory_map>
                       PAGESIZE, PTE_P | PTE_W | PTE_U, pagetable_alloc);
    processes[pid].p_state = P_RUNNABLE;    
   404c4:	8b 45 dc             	mov    -0x24(%rbp),%eax
   404c7:	48 63 d0             	movslq %eax,%rdx
   404ca:	48 89 d0             	mov    %rdx,%rax
   404cd:	48 01 c0             	add    %rax,%rax
   404d0:	48 01 d0             	add    %rdx,%rax
   404d3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   404da:	00 
   404db:	48 01 d0             	add    %rdx,%rax
   404de:	48 c1 e0 03          	shl    $0x3,%rax
   404e2:	48 89 c2             	mov    %rax,%rdx
   404e5:	48 8d 05 fc 2b 01 00 	lea    0x12bfc(%rip),%rax        # 530e8 <processes+0xc8>
   404ec:	c7 04 02 01 00 00 00 	movl   $0x1,(%rdx,%rax,1)
}
   404f3:	90                   	nop
   404f4:	c9                   	leave  
   404f5:	c3                   	ret    

00000000000404f6 <copy_pagetable>:

// copy_pagetable(pagetable, owner)
//    Copy the pagetable `pagetable` and set the owner of the new pagetable to `owner`.
//    Returns the address of the new pagetable, `NULL` on Faliure. 
//    Note: Only copy the mappings before process start address.
x86_64_pagetable* copy_pagetable(x86_64_pagetable* pagetable, int8_t owner) { 
   404f6:	f3 0f 1e fa          	endbr64 
   404fa:	55                   	push   %rbp
   404fb:	48 89 e5             	mov    %rsp,%rbp
   404fe:	48 83 ec 40          	sub    $0x40,%rsp
   40502:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   40506:	89 f0                	mov    %esi,%eax
   40508:	88 45 c4             	mov    %al,-0x3c(%rbp)
    __pagetable_owner__ = (int8_t)owner;
   4050b:	0f b6 45 c4          	movzbl -0x3c(%rbp),%eax
   4050f:	88 05 eb 4a 00 00    	mov    %al,0x4aeb(%rip)        # 45000 <__pagetable_owner__>
    x86_64_pagetable* new_pagetable = pagetable_alloc();
   40515:	b8 00 00 00 00       	mov    $0x0,%eax
   4051a:	e8 90 00 00 00       	call   405af <pagetable_alloc>
   4051f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (new_pagetable == NULL) {
   40523:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   40528:	75 07                	jne    40531 <copy_pagetable+0x3b>
        return NULL; // Oh my god, we are out of memory!
   4052a:	b8 00 00 00 00       	mov    $0x0,%eax
   4052f:	eb 7c                	jmp    405ad <copy_pagetable+0xb7>
    }
    // We iterate through every mapping in the old pagetable and copy it to the new pagetable
    // Improvements to do: We can optimize this by copying only the mappings that are present in the old pagetable
    // But, for now, we will copy all the mappings, one by one, from physical to virtual memory.
    for (uintptr_t va = 0; va < PROC_START_ADDR; va += PAGESIZE) {
   40531:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   40538:	00 
   40539:	eb 64                	jmp    4059f <copy_pagetable+0xa9>
        vamapping mapping = virtual_memory_lookup(pagetable, va);
   4053b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
   4053f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   40543:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   40547:	48 89 ce             	mov    %rcx,%rsi
   4054a:	48 89 c7             	mov    %rax,%rdi
   4054d:	e8 e4 21 00 00       	call   42736 <virtual_memory_lookup>
        if (mapping.perm != 0) { 
   40552:	8b 45 e8             	mov    -0x18(%rbp),%eax
   40555:	85 c0                	test   %eax,%eax
   40557:	74 3e                	je     40597 <copy_pagetable+0xa1>
            if (virtual_memory_map(new_pagetable, va, mapping.pa, PAGESIZE, mapping.perm, pagetable_alloc) != 0) {
   40559:	8b 4d e8             	mov    -0x18(%rbp),%ecx
   4055c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   40560:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   40564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40568:	4c 8d 0d 40 00 00 00 	lea    0x40(%rip),%r9        # 405af <pagetable_alloc>
   4056f:	41 89 c8             	mov    %ecx,%r8d
   40572:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40577:	48 89 c7             	mov    %rax,%rdi
   4057a:	e8 3d 1d 00 00       	call   422bc <virtual_memory_map>
   4057f:	85 c0                	test   %eax,%eax
   40581:	74 14                	je     40597 <copy_pagetable+0xa1>
                panic("Copy pagetable failed..."); // TESTING
   40583:	48 8d 05 b4 3b 00 00 	lea    0x3bb4(%rip),%rax        # 4413e <console_clear+0x58>
   4058a:	48 89 c7             	mov    %rax,%rdi
   4058d:	b8 00 00 00 00       	mov    $0x0,%eax
   40592:	e8 f0 2c 00 00       	call   43287 <panic>
    for (uintptr_t va = 0; va < PROC_START_ADDR; va += PAGESIZE) {
   40597:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   4059e:	00 
   4059f:	48 81 7d f8 ff ff 0f 	cmpq   $0xfffff,-0x8(%rbp)
   405a6:	00 
   405a7:	76 92                	jbe    4053b <copy_pagetable+0x45>
                // but I don't UNDERSTAND WHY
                // pageinfo[PAGENUMBER(mapping.pa)].refcount++;
            }
        }
    }
    return new_pagetable;
   405a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
   405ad:	c9                   	leave  
   405ae:	c3                   	ret    

00000000000405af <pagetable_alloc>:
//   Returns NULL otherwise.
//   Needs to specify the owner of the pagetable. (pid_t owner)
//   However, the library function does not allow allocator functions to take arguments.
//   So, I will use a global variable to identify the owner of the pagetable.
//   Which is, `__pagetable_owner__` .
x86_64_pagetable* pagetable_alloc() {
   405af:	f3 0f 1e fa          	endbr64 
   405b3:	55                   	push   %rbp
   405b4:	48 89 e5             	mov    %rsp,%rbp
   405b7:	48 83 ec 10          	sub    $0x10,%rsp
    x86_64_pagetable* new_pagetable = (x86_64_pagetable*)(uintptr_t) get_free_addr(__pagetable_owner__);
   405bb:	0f b6 05 3e 4a 00 00 	movzbl 0x4a3e(%rip),%eax        # 45000 <__pagetable_owner__>
   405c2:	0f be c0             	movsbl %al,%eax
   405c5:	89 c7                	mov    %eax,%edi
   405c7:	e8 30 00 00 00       	call   405fc <get_free_addr>
   405cc:	48 98                	cltq   
   405ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (new_pagetable == NULL) {
   405d2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   405d7:	75 07                	jne    405e0 <pagetable_alloc+0x31>
        return NULL;
   405d9:	b8 00 00 00 00       	mov    $0x0,%eax
   405de:	eb 1a                	jmp    405fa <pagetable_alloc+0x4b>
    }
    memset(new_pagetable, 0, sizeof(x86_64_pagetable));
   405e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   405e4:	ba 00 10 00 00       	mov    $0x1000,%edx
   405e9:	be 00 00 00 00       	mov    $0x0,%esi
   405ee:	48 89 c7             	mov    %rax,%rdi
   405f1:	e8 ac 31 00 00       	call   437a2 <memset>
    return new_pagetable;
   405f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   405fa:	c9                   	leave  
   405fb:	c3                   	ret    

00000000000405fc <get_free_addr>:

// get_free_addr(owner) 
//    Returns the first free address in the physical memory that can hold a pagetable.
//    Returns `OUTOFMEMORY` if there is no free space.
int get_free_addr(int8_t owner) {
   405fc:	f3 0f 1e fa          	endbr64 
   40600:	55                   	push   %rbp
   40601:	48 89 e5             	mov    %rsp,%rbp
   40604:	48 83 ec 20          	sub    $0x20,%rsp
   40608:	89 f8                	mov    %edi,%eax
   4060a:	88 45 ec             	mov    %al,-0x14(%rbp)
    // We will iterate through the kernal space and find the first free address that can hold a pagetable.
    for (int addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) { 
   4060d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   40614:	eb 66                	jmp    4067c <get_free_addr+0x80>
        if (pageinfo[PAGENUMBER(addr)].refcount == 0 && pageinfo[PAGENUMBER(addr)].owner == PO_FREE) {
   40616:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40619:	48 98                	cltq   
   4061b:	48 c1 e8 0c          	shr    $0xc,%rax
   4061f:	48 98                	cltq   
   40621:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   40625:	48 8d 05 95 37 01 00 	lea    0x13795(%rip),%rax        # 53dc1 <pageinfo+0x1>
   4062c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   40630:	84 c0                	test   %al,%al
   40632:	75 41                	jne    40675 <get_free_addr+0x79>
   40634:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40637:	48 98                	cltq   
   40639:	48 c1 e8 0c          	shr    $0xc,%rax
   4063d:	48 98                	cltq   
   4063f:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   40643:	48 8d 05 76 37 01 00 	lea    0x13776(%rip),%rax        # 53dc0 <pageinfo>
   4064a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   4064e:	84 c0                	test   %al,%al
   40650:	75 23                	jne    40675 <get_free_addr+0x79>
            if(assign_physical_page(addr, owner) == 0) {
   40652:	0f be 55 ec          	movsbl -0x14(%rbp),%edx
   40656:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40659:	48 98                	cltq   
   4065b:	89 d6                	mov    %edx,%esi
   4065d:	48 89 c7             	mov    %rax,%rdi
   40660:	e8 0c 03 00 00       	call   40971 <assign_physical_page>
   40665:	85 c0                	test   %eax,%eax
   40667:	75 05                	jne    4066e <get_free_addr+0x72>
                return addr;
   40669:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4066c:	eb 1c                	jmp    4068a <get_free_addr+0x8e>
            }
            return OUTOFMEMORY; // FAILED TO ASSIGN PHYSICAL PAGE
   4066e:	b8 00 00 00 00       	mov    $0x0,%eax
   40673:	eb 15                	jmp    4068a <get_free_addr+0x8e>
    for (int addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) { 
   40675:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
   4067c:	81 7d fc ff ff 1f 00 	cmpl   $0x1fffff,-0x4(%rbp)
   40683:	7e 91                	jle    40616 <get_free_addr+0x1a>
        }
    }
    return OUTOFMEMORY; // OUT OF MEMORY
   40685:	b8 00 00 00 00       	mov    $0x0,%eax
}
   4068a:	c9                   	leave  
   4068b:	c3                   	ret    

000000000004068c <fork>:
// fork()
//    Fork the current process.
//    Returns the child's process ID to the parent, 0 to the child.
//    Returns -1 on failure.
void fork() {
   4068c:	f3 0f 1e fa          	endbr64 
   40690:	55                   	push   %rbp
   40691:	48 89 e5             	mov    %rsp,%rbp
   40694:	48 83 ec 30          	sub    $0x30,%rsp
    for (pid_t i = 1; i < NPROC; i++) {
   40698:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   4069f:	e9 b2 02 00 00       	jmp    40956 <fork+0x2ca>
        if(processes[i].p_state == P_FREE) {
   406a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
   406a7:	48 63 d0             	movslq %eax,%rdx
   406aa:	48 89 d0             	mov    %rdx,%rax
   406ad:	48 01 c0             	add    %rax,%rax
   406b0:	48 01 d0             	add    %rdx,%rax
   406b3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   406ba:	00 
   406bb:	48 01 d0             	add    %rdx,%rax
   406be:	48 c1 e0 03          	shl    $0x3,%rax
   406c2:	48 89 c2             	mov    %rax,%rdx
   406c5:	48 8d 05 1c 2a 01 00 	lea    0x12a1c(%rip),%rax        # 530e8 <processes+0xc8>
   406cc:	8b 04 02             	mov    (%rdx,%rax,1),%eax
   406cf:	85 c0                	test   %eax,%eax
   406d1:	0f 85 7b 02 00 00    	jne    40952 <fork+0x2c6>
            // Copy process informations of parent process. 
            
            processes[i].p_state = P_RUNNABLE;
   406d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
   406da:	48 63 d0             	movslq %eax,%rdx
   406dd:	48 89 d0             	mov    %rdx,%rax
   406e0:	48 01 c0             	add    %rax,%rax
   406e3:	48 01 d0             	add    %rdx,%rax
   406e6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   406ed:	00 
   406ee:	48 01 d0             	add    %rdx,%rax
   406f1:	48 c1 e0 03          	shl    $0x3,%rax
   406f5:	48 89 c2             	mov    %rax,%rdx
   406f8:	48 8d 05 e9 29 01 00 	lea    0x129e9(%rip),%rax        # 530e8 <processes+0xc8>
   406ff:	c7 04 02 01 00 00 00 	movl   $0x1,(%rdx,%rax,1)
            processes[i].p_registers = current->p_registers;
   40706:	48 8b 0d f3 28 01 00 	mov    0x128f3(%rip),%rcx        # 53000 <current>
   4070d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40710:	48 63 d0             	movslq %eax,%rdx
   40713:	48 89 d0             	mov    %rdx,%rax
   40716:	48 01 c0             	add    %rax,%rax
   40719:	48 01 d0             	add    %rdx,%rax
   4071c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40723:	00 
   40724:	48 01 d0             	add    %rdx,%rax
   40727:	48 c1 e0 03          	shl    $0x3,%rax
   4072b:	48 89 c2             	mov    %rax,%rdx
   4072e:	48 8d 05 eb 28 01 00 	lea    0x128eb(%rip),%rax        # 53020 <processes>
   40735:	48 01 d0             	add    %rdx,%rax
   40738:	48 83 c0 08          	add    $0x8,%rax
   4073c:	48 8d 51 08          	lea    0x8(%rcx),%rdx
   40740:	b9 18 00 00 00       	mov    $0x18,%ecx
   40745:	48 89 c7             	mov    %rax,%rdi
   40748:	48 89 d6             	mov    %rdx,%rsi
   4074b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
            processes[i].p_pid = i;
   4074e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40751:	48 63 d0             	movslq %eax,%rdx
   40754:	48 89 d0             	mov    %rdx,%rax
   40757:	48 01 c0             	add    %rax,%rax
   4075a:	48 01 d0             	add    %rdx,%rax
   4075d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40764:	00 
   40765:	48 01 d0             	add    %rdx,%rax
   40768:	48 c1 e0 03          	shl    $0x3,%rax
   4076c:	48 89 c1             	mov    %rax,%rcx
   4076f:	48 8d 15 aa 28 01 00 	lea    0x128aa(%rip),%rdx        # 53020 <processes>
   40776:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40779:	89 04 11             	mov    %eax,(%rcx,%rdx,1)
            processes[i].p_pagetable = copy_pagetable(current->p_pagetable, (int8_t)i);
   4077c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4077f:	0f be d0             	movsbl %al,%edx
   40782:	48 8b 05 77 28 01 00 	mov    0x12877(%rip),%rax        # 53000 <current>
   40789:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40790:	89 d6                	mov    %edx,%esi
   40792:	48 89 c7             	mov    %rax,%rdi
   40795:	e8 5c fd ff ff       	call   404f6 <copy_pagetable>
   4079a:	48 89 c2             	mov    %rax,%rdx
   4079d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   407a0:	48 63 c8             	movslq %eax,%rcx
   407a3:	48 89 c8             	mov    %rcx,%rax
   407a6:	48 01 c0             	add    %rax,%rax
   407a9:	48 01 c8             	add    %rcx,%rax
   407ac:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
   407b3:	00 
   407b4:	48 01 c8             	add    %rcx,%rax
   407b7:	48 c1 e0 03          	shl    $0x3,%rax
   407bb:	48 89 c1             	mov    %rax,%rcx
   407be:	48 8d 05 2b 29 01 00 	lea    0x1292b(%rip),%rax        # 530f0 <processes+0xd0>
   407c5:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
            if (processes[i].p_pagetable == NULL) {
   407c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   407cc:	48 63 d0             	movslq %eax,%rdx
   407cf:	48 89 d0             	mov    %rdx,%rax
   407d2:	48 01 c0             	add    %rax,%rax
   407d5:	48 01 d0             	add    %rdx,%rax
   407d8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   407df:	00 
   407e0:	48 01 d0             	add    %rdx,%rax
   407e3:	48 c1 e0 03          	shl    $0x3,%rax
   407e7:	48 89 c2             	mov    %rax,%rdx
   407ea:	48 8d 05 ff 28 01 00 	lea    0x128ff(%rip),%rax        # 530f0 <processes+0xd0>
   407f1:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
   407f5:	48 85 c0             	test   %rax,%rax
   407f8:	75 14                	jne    4080e <fork+0x182>
                current->p_registers.reg_rax = FAILED;
   407fa:	48 8b 05 ff 27 01 00 	mov    0x127ff(%rip),%rax        # 53000 <current>
   40801:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40808:	ff 
                return;
   40809:	e9 61 01 00 00       	jmp    4096f <fork+0x2e3>
            }

            // Copy process memory. 
            // Copy from va -> mapping.pa 
            // Copy to va -> new_pa
            for (uintptr_t va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   4080e:	48 c7 45 f0 00 00 10 	movq   $0x100000,-0x10(%rbp)
   40815:	00 
   40816:	e9 e6 00 00 00       	jmp    40901 <fork+0x275>
                vamapping mapping = virtual_memory_lookup(current->p_pagetable, va);
   4081b:	48 8b 05 de 27 01 00 	mov    0x127de(%rip),%rax        # 53000 <current>
   40822:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   40829:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   4082d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40831:	48 89 ce             	mov    %rcx,%rsi
   40834:	48 89 c7             	mov    %rax,%rdi
   40837:	e8 fa 1e 00 00       	call   42736 <virtual_memory_lookup>
                if ((mapping.perm & PTE_W) != 0) {
   4083c:	8b 45 e0             	mov    -0x20(%rbp),%eax
   4083f:	48 98                	cltq   
   40841:	83 e0 02             	and    $0x2,%eax
   40844:	48 85 c0             	test   %rax,%rax
   40847:	0f 84 ac 00 00 00    	je     408f9 <fork+0x26d>
                    uintptr_t new_pa = get_free_addr((int8_t)i);
   4084d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40850:	0f be c0             	movsbl %al,%eax
   40853:	89 c7                	mov    %eax,%edi
   40855:	e8 a2 fd ff ff       	call   405fc <get_free_addr>
   4085a:	48 98                	cltq   
   4085c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                    if (new_pa == OUTOFMEMORY) {
   40860:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40865:	75 14                	jne    4087b <fork+0x1ef>
                        current->p_registers.reg_rax = FAILED;
   40867:	48 8b 05 92 27 01 00 	mov    0x12792(%rip),%rax        # 53000 <current>
   4086e:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40875:	ff 
                        return;
   40876:	e9 f4 00 00 00       	jmp    4096f <fork+0x2e3>
                        
                    }
                    memcpy((void*)new_pa, (void*)mapping.pa, PAGESIZE);
   4087b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4087f:	48 89 c1             	mov    %rax,%rcx
   40882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40886:	ba 00 10 00 00       	mov    $0x1000,%edx
   4088b:	48 89 ce             	mov    %rcx,%rsi
   4088e:	48 89 c7             	mov    %rax,%rdi
   40891:	e8 9b 2e 00 00       	call   43731 <memcpy>
                    if (virtual_memory_map(processes[i].p_pagetable, va, new_pa, PAGESIZE, mapping.perm, pagetable_alloc) != 0) {
   40896:	8b 4d e0             	mov    -0x20(%rbp),%ecx
   40899:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4089c:	48 63 d0             	movslq %eax,%rdx
   4089f:	48 89 d0             	mov    %rdx,%rax
   408a2:	48 01 c0             	add    %rax,%rax
   408a5:	48 01 d0             	add    %rdx,%rax
   408a8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   408af:	00 
   408b0:	48 01 d0             	add    %rdx,%rax
   408b3:	48 c1 e0 03          	shl    $0x3,%rax
   408b7:	48 89 c2             	mov    %rax,%rdx
   408ba:	48 8d 05 2f 28 01 00 	lea    0x1282f(%rip),%rax        # 530f0 <processes+0xd0>
   408c1:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
   408c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   408c9:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   408cd:	4c 8d 0d db fc ff ff 	lea    -0x325(%rip),%r9        # 405af <pagetable_alloc>
   408d4:	41 89 c8             	mov    %ecx,%r8d
   408d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
   408dc:	48 89 c7             	mov    %rax,%rdi
   408df:	e8 d8 19 00 00       	call   422bc <virtual_memory_map>
   408e4:	85 c0                	test   %eax,%eax
   408e6:	74 11                	je     408f9 <fork+0x26d>
                        current->p_registers.reg_rax = FAILED;
   408e8:	48 8b 05 11 27 01 00 	mov    0x12711(%rip),%rax        # 53000 <current>
   408ef:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   408f6:	ff 
                        return;
   408f7:	eb 76                	jmp    4096f <fork+0x2e3>
            for (uintptr_t va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   408f9:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
   40900:	00 
   40901:	48 81 7d f0 ff ff 2f 	cmpq   $0x2fffff,-0x10(%rbp)
   40908:	00 
   40909:	0f 86 0c ff ff ff    	jbe    4081b <fork+0x18f>
                    // } 
                }
            }

            // If succeed:
            current->p_registers.reg_rax = i;
   4090f:	48 8b 05 ea 26 01 00 	mov    0x126ea(%rip),%rax        # 53000 <current>
   40916:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40919:	48 63 d2             	movslq %edx,%rdx
   4091c:	48 89 50 08          	mov    %rdx,0x8(%rax)
            processes[i].p_registers.reg_rax = 0;
   40920:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40923:	48 63 d0             	movslq %eax,%rdx
   40926:	48 89 d0             	mov    %rdx,%rax
   40929:	48 01 c0             	add    %rax,%rax
   4092c:	48 01 d0             	add    %rdx,%rax
   4092f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40936:	00 
   40937:	48 01 d0             	add    %rdx,%rax
   4093a:	48 c1 e0 03          	shl    $0x3,%rax
   4093e:	48 89 c2             	mov    %rax,%rdx
   40941:	48 8d 05 e0 26 01 00 	lea    0x126e0(%rip),%rax        # 53028 <processes+0x8>
   40948:	48 c7 04 02 00 00 00 	movq   $0x0,(%rdx,%rax,1)
   4094f:	00 
            return;
   40950:	eb 1d                	jmp    4096f <fork+0x2e3>
    for (pid_t i = 1; i < NPROC; i++) {
   40952:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40956:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   4095a:	0f 8e 44 fd ff ff    	jle    406a4 <fork+0x18>
        }
    }
    current->p_registers.reg_rax = FAILED;
   40960:	48 8b 05 99 26 01 00 	mov    0x12699(%rip),%rax        # 53000 <current>
   40967:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   4096e:	ff 
    
}
   4096f:	c9                   	leave  
   40970:	c3                   	ret    

0000000000040971 <assign_physical_page>:
// assign_physical_page(addr, owner)
//    Allocates the page with physical address `addr` to the given owner.
//    Fails if physical page `addr` was already allocated. Returns 0 on
//    success and -1 on failure. Used by the program loader.

int assign_physical_page(uintptr_t addr, int8_t owner) {
   40971:	f3 0f 1e fa          	endbr64 
   40975:	55                   	push   %rbp
   40976:	48 89 e5             	mov    %rsp,%rbp
   40979:	48 83 ec 10          	sub    $0x10,%rsp
   4097d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   40981:	89 f0                	mov    %esi,%eax
   40983:	88 45 f4             	mov    %al,-0xc(%rbp)
    if ((addr & 0xFFF) != 0
   40986:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4098a:	25 ff 0f 00 00       	and    $0xfff,%eax
   4098f:	48 85 c0             	test   %rax,%rax
   40992:	75 27                	jne    409bb <assign_physical_page+0x4a>
        || addr >= MEMSIZE_PHYSICAL
   40994:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   4099b:	00 
   4099c:	77 1d                	ja     409bb <assign_physical_page+0x4a>
        || pageinfo[PAGENUMBER(addr)].refcount != 0) {
   4099e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   409a2:	48 c1 e8 0c          	shr    $0xc,%rax
   409a6:	48 98                	cltq   
   409a8:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   409ac:	48 8d 05 0e 34 01 00 	lea    0x1340e(%rip),%rax        # 53dc1 <pageinfo+0x1>
   409b3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   409b7:	84 c0                	test   %al,%al
   409b9:	74 07                	je     409c2 <assign_physical_page+0x51>
        return -1;
   409bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   409c0:	eb 3a                	jmp    409fc <assign_physical_page+0x8b>
    } else {
        pageinfo[PAGENUMBER(addr)].refcount = 1;
   409c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   409c6:	48 c1 e8 0c          	shr    $0xc,%rax
   409ca:	48 98                	cltq   
   409cc:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   409d0:	48 8d 05 ea 33 01 00 	lea    0x133ea(%rip),%rax        # 53dc1 <pageinfo+0x1>
   409d7:	c6 04 02 01          	movb   $0x1,(%rdx,%rax,1)
        pageinfo[PAGENUMBER(addr)].owner = owner;
   409db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   409df:	48 c1 e8 0c          	shr    $0xc,%rax
   409e3:	48 98                	cltq   
   409e5:	48 8d 0c 00          	lea    (%rax,%rax,1),%rcx
   409e9:	48 8d 15 d0 33 01 00 	lea    0x133d0(%rip),%rdx        # 53dc0 <pageinfo>
   409f0:	0f b6 45 f4          	movzbl -0xc(%rbp),%eax
   409f4:	88 04 11             	mov    %al,(%rcx,%rdx,1)
        return 0;
   409f7:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   409fc:	c9                   	leave  
   409fd:	c3                   	ret    

00000000000409fe <exception>:
//    k-exception.S). That code saves more registers on the kernel's stack,
//    then calls exception().
//
//    Note that hardware interrupts are disabled whenever the kernel is running.

void exception(x86_64_registers* reg) {
   409fe:	f3 0f 1e fa          	endbr64 
   40a02:	55                   	push   %rbp
   40a03:	48 89 e5             	mov    %rsp,%rbp
   40a06:	48 83 ec 50          	sub    $0x50,%rsp
   40a0a:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
    // Copy the saved registers into the `current` process descriptor
    // and always use the kernel's page table.
    current->p_registers = *reg;
   40a0e:	48 8b 05 eb 25 01 00 	mov    0x125eb(%rip),%rax        # 53000 <current>
   40a15:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   40a19:	48 83 c0 08          	add    $0x8,%rax
   40a1d:	48 89 d6             	mov    %rdx,%rsi
   40a20:	ba 18 00 00 00       	mov    $0x18,%edx
   40a25:	48 89 c7             	mov    %rax,%rdi
   40a28:	48 89 d1             	mov    %rdx,%rcx
   40a2b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    set_pagetable(kernel_pagetable);
   40a2e:	48 8b 05 cb 45 01 00 	mov    0x145cb(%rip),%rax        # 55000 <kernel_pagetable>
   40a35:	48 89 c7             	mov    %rax,%rdi
   40a38:	e8 ed 1d 00 00       	call   4282a <set_pagetable>
    // Events logged this way are stored in the host's `log.txt` file.
    /*log_printf("proc %d: exception %d\n", current->p_pid, reg->reg_intno);*/

    // Show the current cursor location and memory state
    // (unless this is a kernel fault).
    console_show_cursor(cursorpos);
   40a3d:	8b 05 b9 85 07 00    	mov    0x785b9(%rip),%eax        # b8ffc <cursorpos>
   40a43:	89 c7                	mov    %eax,%edi
   40a45:	e8 f7 21 00 00       	call   42c41 <console_show_cursor>
    if (reg->reg_intno != INT_PAGEFAULT || (reg->reg_err & PFERR_USER)) {
   40a4a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40a4e:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   40a55:	48 83 f8 0e          	cmp    $0xe,%rax
   40a59:	75 13                	jne    40a6e <exception+0x70>
   40a5b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40a5f:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40a66:	83 e0 04             	and    $0x4,%eax
   40a69:	48 85 c0             	test   %rax,%rax
   40a6c:	74 0f                	je     40a7d <exception+0x7f>
        check_virtual_memory();
   40a6e:	e8 de 07 00 00       	call   41251 <check_virtual_memory>
        memshow_physical();
   40a73:	e8 d4 09 00 00       	call   4144c <memshow_physical>
        memshow_virtual_animate();
   40a78:	e8 2c 0d 00 00       	call   417a9 <memshow_virtual_animate>
	}
#endif
    }

    // If Control-C was typed, exit the virtual machine.
    check_keyboard();
   40a7d:	e8 d5 26 00 00       	call   43157 <check_keyboard>


    // Actually handle the exception.
    switch (reg->reg_intno) {
   40a82:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40a86:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   40a8d:	48 83 e8 0e          	sub    $0xe,%rax
   40a91:	48 83 f8 26          	cmp    $0x26,%rax
   40a95:	0f 87 2b 02 00 00    	ja     40cc6 <exception+0x2c8>
   40a9b:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
   40aa2:	00 
   40aa3:	48 8d 05 6a 37 00 00 	lea    0x376a(%rip),%rax        # 44214 <console_clear+0x12e>
   40aaa:	8b 04 02             	mov    (%rdx,%rax,1),%eax
   40aad:	48 98                	cltq   
   40aaf:	48 8d 15 5e 37 00 00 	lea    0x375e(%rip),%rdx        # 44214 <console_clear+0x12e>
   40ab6:	48 01 d0             	add    %rdx,%rax
   40ab9:	3e ff e0             	notrack jmp *%rax

    case INT_SYS_PANIC:
        panic(NULL);
   40abc:	bf 00 00 00 00       	mov    $0x0,%edi
   40ac1:	b8 00 00 00 00       	mov    $0x0,%eax
   40ac6:	e8 bc 27 00 00       	call   43287 <panic>
        break;                  // will not be reached

    case INT_SYS_GETPID:
        current->p_registers.reg_rax = current->p_pid;
   40acb:	48 8b 05 2e 25 01 00 	mov    0x1252e(%rip),%rax        # 53000 <current>
   40ad2:	8b 10                	mov    (%rax),%edx
   40ad4:	48 8b 05 25 25 01 00 	mov    0x12525(%rip),%rax        # 53000 <current>
   40adb:	48 63 d2             	movslq %edx,%rdx
   40ade:	48 89 50 08          	mov    %rdx,0x8(%rax)
        break;
   40ae2:	e9 01 02 00 00       	jmp    40ce8 <exception+0x2ea>

    case INT_SYS_YIELD:
        schedule();
   40ae7:	e8 25 02 00 00       	call   40d11 <schedule>
        break;                  /* will not be reached */
   40aec:	e9 f7 01 00 00       	jmp    40ce8 <exception+0x2ea>

    case INT_SYS_PAGE_ALLOC: {
        uintptr_t addr = current->p_registers.reg_rdi;
   40af1:	48 8b 05 08 25 01 00 	mov    0x12508(%rip),%rax        # 53000 <current>
   40af8:	48 8b 40 38          	mov    0x38(%rax),%rax
   40afc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        /*
            Step 3: Page Allocation
            - It will be any free physical address, not definitely same as virtual address.
        */
        uintptr_t pa = get_free_addr((int8_t)current->p_pid); // Get a free physical address
   40b00:	48 8b 05 f9 24 01 00 	mov    0x124f9(%rip),%rax        # 53000 <current>
   40b07:	8b 00                	mov    (%rax),%eax
   40b09:	0f be c0             	movsbl %al,%eax
   40b0c:	89 c7                	mov    %eax,%edi
   40b0e:	e8 e9 fa ff ff       	call   405fc <get_free_addr>
   40b13:	48 98                	cltq   
   40b15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
        __pagetable_owner__ = (int8_t)current->p_pid;
   40b19:	48 8b 05 e0 24 01 00 	mov    0x124e0(%rip),%rax        # 53000 <current>
   40b20:	8b 00                	mov    (%rax),%eax
   40b22:	88 05 d8 44 00 00    	mov    %al,0x44d8(%rip)        # 45000 <__pagetable_owner__>
        if(pa != OUTOFMEMORY) {
   40b28:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   40b2d:	74 49                	je     40b78 <exception+0x17a>
            int result = virtual_memory_map(current->p_pagetable, addr, pa,
   40b2f:	48 8b 05 ca 24 01 00 	mov    0x124ca(%rip),%rax        # 53000 <current>
   40b36:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40b3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40b41:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   40b45:	4c 8d 0d 63 fa ff ff 	lea    -0x59d(%rip),%r9        # 405af <pagetable_alloc>
   40b4c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   40b52:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40b57:	48 89 c7             	mov    %rax,%rdi
   40b5a:	e8 5d 17 00 00       	call   422bc <virtual_memory_map>
   40b5f:	89 45 ec             	mov    %eax,-0x14(%rbp)
                               PAGESIZE, PTE_P | PTE_W | PTE_U, pagetable_alloc);
            current->p_registers.reg_rax = result;
   40b62:	48 8b 05 97 24 01 00 	mov    0x12497(%rip),%rax        # 53000 <current>
   40b69:	8b 55 ec             	mov    -0x14(%rbp),%edx
   40b6c:	48 63 d2             	movslq %edx,%rdx
   40b6f:	48 89 50 08          	mov    %rdx,0x8(%rax)
        } else {
            current->p_registers.reg_rax = FAILED;
            log_printf("Out of memory\n");
        }
        break;
   40b73:	e9 70 01 00 00       	jmp    40ce8 <exception+0x2ea>
            current->p_registers.reg_rax = FAILED;
   40b78:	48 8b 05 81 24 01 00 	mov    0x12481(%rip),%rax        # 53000 <current>
   40b7f:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40b86:	ff 
            log_printf("Out of memory\n");
   40b87:	48 8d 05 c9 35 00 00 	lea    0x35c9(%rip),%rax        # 44157 <console_clear+0x71>
   40b8e:	48 89 c7             	mov    %rax,%rdi
   40b91:	b8 00 00 00 00       	mov    $0x0,%eax
   40b96:	e8 b3 24 00 00       	call   4304e <log_printf>
        break;
   40b9b:	e9 48 01 00 00       	jmp    40ce8 <exception+0x2ea>
        /*
            Step 5: Fork.
            - Copy the pagetable and registers of the current process to the new process.
            - Allocate new physical memory and copy the data of the current process to the new process.
        */
        fork();
   40ba0:	b8 00 00 00 00       	mov    $0x0,%eax
   40ba5:	e8 e2 fa ff ff       	call   4068c <fork>
        break;
   40baa:	e9 39 01 00 00       	jmp    40ce8 <exception+0x2ea>

    case INT_TIMER:
        ++ticks;
   40baf:	8b 05 eb 31 01 00    	mov    0x131eb(%rip),%eax        # 53da0 <ticks>
   40bb5:	83 c0 01             	add    $0x1,%eax
   40bb8:	89 05 e2 31 01 00    	mov    %eax,0x131e2(%rip)        # 53da0 <ticks>
        schedule();
   40bbe:	e8 4e 01 00 00       	call   40d11 <schedule>
        break;                  /* will not be reached */
   40bc3:	e9 20 01 00 00       	jmp    40ce8 <exception+0x2ea>
    return val;
}

static inline uintptr_t rcr2(void) {
    uintptr_t val;
    asm volatile("movq %%cr2,%0" : "=r" (val));
   40bc8:	0f 20 d0             	mov    %cr2,%rax
   40bcb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return val;
   40bcf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax

    case INT_PAGEFAULT: {
        // Analyze faulting address and access type.
        uintptr_t addr = rcr2();
   40bd3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        const char* operation = reg->reg_err & PFERR_WRITE
   40bd7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40bdb:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40be2:	83 e0 02             	and    $0x2,%eax
                ? "write" : "read";
   40be5:	48 85 c0             	test   %rax,%rax
   40be8:	74 09                	je     40bf3 <exception+0x1f5>
   40bea:	48 8d 05 75 35 00 00 	lea    0x3575(%rip),%rax        # 44166 <console_clear+0x80>
   40bf1:	eb 07                	jmp    40bfa <exception+0x1fc>
   40bf3:	48 8d 05 72 35 00 00 	lea    0x3572(%rip),%rax        # 4416c <console_clear+0x86>
        const char* operation = reg->reg_err & PFERR_WRITE
   40bfa:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
        const char* problem = reg->reg_err & PFERR_PRESENT
   40bfe:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40c02:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40c09:	83 e0 01             	and    $0x1,%eax
                ? "protection problem" : "missing page";
   40c0c:	48 85 c0             	test   %rax,%rax
   40c0f:	74 09                	je     40c1a <exception+0x21c>
   40c11:	48 8d 05 59 35 00 00 	lea    0x3559(%rip),%rax        # 44171 <console_clear+0x8b>
   40c18:	eb 07                	jmp    40c21 <exception+0x223>
   40c1a:	48 8d 05 63 35 00 00 	lea    0x3563(%rip),%rax        # 44184 <console_clear+0x9e>
        const char* problem = reg->reg_err & PFERR_PRESENT
   40c21:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

        if (!(reg->reg_err & PFERR_USER)) {
   40c25:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40c29:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40c30:	83 e0 04             	and    $0x4,%eax
   40c33:	48 85 c0             	test   %rax,%rax
   40c36:	75 31                	jne    40c69 <exception+0x26b>
            panic("Kernel page fault for %p (%s %s, rip=%p)!\n",
   40c38:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40c3c:	48 8b b0 98 00 00 00 	mov    0x98(%rax),%rsi
   40c43:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
   40c47:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   40c4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40c4f:	49 89 f0             	mov    %rsi,%r8
   40c52:	48 89 c6             	mov    %rax,%rsi
   40c55:	48 8d 05 3c 35 00 00 	lea    0x353c(%rip),%rax        # 44198 <console_clear+0xb2>
   40c5c:	48 89 c7             	mov    %rax,%rdi
   40c5f:	b8 00 00 00 00       	mov    $0x0,%eax
   40c64:	e8 1e 26 00 00       	call   43287 <panic>
                  addr, operation, problem, reg->reg_rip);
        }
        console_printf(CPOS(24, 0), 0x0C00,
   40c69:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40c6d:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
                       "Process %d page fault for %p (%s %s, rip=%p)!\n",
                       current->p_pid, addr, operation, problem, reg->reg_rip);
   40c74:	48 8b 05 85 23 01 00 	mov    0x12385(%rip),%rax        # 53000 <current>
        console_printf(CPOS(24, 0), 0x0C00,
   40c7b:	8b 00                	mov    (%rax),%eax
   40c7d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
   40c81:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
   40c85:	52                   	push   %rdx
   40c86:	ff 75 d0             	push   -0x30(%rbp)
   40c89:	49 89 f1             	mov    %rsi,%r9
   40c8c:	49 89 c8             	mov    %rcx,%r8
   40c8f:	89 c1                	mov    %eax,%ecx
   40c91:	48 8d 05 30 35 00 00 	lea    0x3530(%rip),%rax        # 441c8 <console_clear+0xe2>
   40c98:	48 89 c2             	mov    %rax,%rdx
   40c9b:	be 00 0c 00 00       	mov    $0xc00,%esi
   40ca0:	bf 80 07 00 00       	mov    $0x780,%edi
   40ca5:	b8 00 00 00 00       	mov    $0x0,%eax
   40caa:	e8 74 33 00 00       	call   44023 <console_printf>
   40caf:	48 83 c4 10          	add    $0x10,%rsp
        current->p_state = P_BROKEN;
   40cb3:	48 8b 05 46 23 01 00 	mov    0x12346(%rip),%rax        # 53000 <current>
   40cba:	c7 80 c8 00 00 00 03 	movl   $0x3,0xc8(%rax)
   40cc1:	00 00 00 
        break;
   40cc4:	eb 22                	jmp    40ce8 <exception+0x2ea>
    }

    default:
        panic("Unexpected exception %d!\n", reg->reg_intno);
   40cc6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40cca:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   40cd1:	48 89 c6             	mov    %rax,%rsi
   40cd4:	48 8d 05 1c 35 00 00 	lea    0x351c(%rip),%rax        # 441f7 <console_clear+0x111>
   40cdb:	48 89 c7             	mov    %rax,%rdi
   40cde:	b8 00 00 00 00       	mov    $0x0,%eax
   40ce3:	e8 9f 25 00 00       	call   43287 <panic>

    }


    // Return to the current process (or run something else).
    if (current->p_state == P_RUNNABLE) {
   40ce8:	48 8b 05 11 23 01 00 	mov    0x12311(%rip),%rax        # 53000 <current>
   40cef:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
   40cf5:	83 f8 01             	cmp    $0x1,%eax
   40cf8:	75 0f                	jne    40d09 <exception+0x30b>
        run(current);
   40cfa:	48 8b 05 ff 22 01 00 	mov    0x122ff(%rip),%rax        # 53000 <current>
   40d01:	48 89 c7             	mov    %rax,%rdi
   40d04:	e8 9b 00 00 00       	call   40da4 <run>
    } else {
        schedule();
   40d09:	e8 03 00 00 00       	call   40d11 <schedule>
    }
}
   40d0e:	90                   	nop
   40d0f:	c9                   	leave  
   40d10:	c3                   	ret    

0000000000040d11 <schedule>:

// schedule
//    Pick the next process to run and then run it.
//    If there are no runnable processes, spins forever.

void schedule(void) {
   40d11:	f3 0f 1e fa          	endbr64 
   40d15:	55                   	push   %rbp
   40d16:	48 89 e5             	mov    %rsp,%rbp
   40d19:	48 83 ec 10          	sub    $0x10,%rsp
    pid_t pid = current->p_pid;
   40d1d:	48 8b 05 dc 22 01 00 	mov    0x122dc(%rip),%rax        # 53000 <current>
   40d24:	8b 00                	mov    (%rax),%eax
   40d26:	89 45 fc             	mov    %eax,-0x4(%rbp)
    while (1) {
        pid = (pid + 1) % NPROC;
   40d29:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40d2c:	83 c0 01             	add    $0x1,%eax
   40d2f:	99                   	cltd   
   40d30:	c1 ea 1c             	shr    $0x1c,%edx
   40d33:	01 d0                	add    %edx,%eax
   40d35:	83 e0 0f             	and    $0xf,%eax
   40d38:	29 d0                	sub    %edx,%eax
   40d3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (processes[pid].p_state == P_RUNNABLE) {
   40d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40d40:	48 63 d0             	movslq %eax,%rdx
   40d43:	48 89 d0             	mov    %rdx,%rax
   40d46:	48 01 c0             	add    %rax,%rax
   40d49:	48 01 d0             	add    %rdx,%rax
   40d4c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40d53:	00 
   40d54:	48 01 d0             	add    %rdx,%rax
   40d57:	48 c1 e0 03          	shl    $0x3,%rax
   40d5b:	48 89 c2             	mov    %rax,%rdx
   40d5e:	48 8d 05 83 23 01 00 	lea    0x12383(%rip),%rax        # 530e8 <processes+0xc8>
   40d65:	8b 04 02             	mov    (%rdx,%rax,1),%eax
   40d68:	83 f8 01             	cmp    $0x1,%eax
   40d6b:	75 30                	jne    40d9d <schedule+0x8c>
            run(&processes[pid]);
   40d6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40d70:	48 63 d0             	movslq %eax,%rdx
   40d73:	48 89 d0             	mov    %rdx,%rax
   40d76:	48 01 c0             	add    %rax,%rax
   40d79:	48 01 d0             	add    %rdx,%rax
   40d7c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40d83:	00 
   40d84:	48 01 d0             	add    %rdx,%rax
   40d87:	48 c1 e0 03          	shl    $0x3,%rax
   40d8b:	48 8d 15 8e 22 01 00 	lea    0x1228e(%rip),%rdx        # 53020 <processes>
   40d92:	48 01 d0             	add    %rdx,%rax
   40d95:	48 89 c7             	mov    %rax,%rdi
   40d98:	e8 07 00 00 00       	call   40da4 <run>
        }
        // If Control-C was typed, exit the virtual machine.
        check_keyboard();
   40d9d:	e8 b5 23 00 00       	call   43157 <check_keyboard>
        pid = (pid + 1) % NPROC;
   40da2:	eb 85                	jmp    40d29 <schedule+0x18>

0000000000040da4 <run>:
//    Run process `p`. This means reloading all the registers from
//    `p->p_registers` using the `popal`, `popl`, and `iret` instructions.
//
//    As a side effect, sets `current = p`.

void run(proc* p) {
   40da4:	f3 0f 1e fa          	endbr64 
   40da8:	55                   	push   %rbp
   40da9:	48 89 e5             	mov    %rsp,%rbp
   40dac:	48 83 ec 10          	sub    $0x10,%rsp
   40db0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    assert(p->p_state == P_RUNNABLE);
   40db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40db8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
   40dbe:	83 f8 01             	cmp    $0x1,%eax
   40dc1:	74 1e                	je     40de1 <run+0x3d>
   40dc3:	48 8d 05 e6 34 00 00 	lea    0x34e6(%rip),%rax        # 442b0 <console_clear+0x1ca>
   40dca:	48 89 c2             	mov    %rax,%rdx
   40dcd:	be dd 01 00 00       	mov    $0x1dd,%esi
   40dd2:	48 8d 05 5c 33 00 00 	lea    0x335c(%rip),%rax        # 44135 <console_clear+0x4f>
   40dd9:	48 89 c7             	mov    %rax,%rdi
   40ddc:	e8 96 25 00 00       	call   43377 <assert_fail>
    current = p;
   40de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40de5:	48 89 05 14 22 01 00 	mov    %rax,0x12214(%rip)        # 53000 <current>

    // Load the process's current pagetable.
    set_pagetable(p->p_pagetable);
   40dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40df0:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40df7:	48 89 c7             	mov    %rax,%rdi
   40dfa:	e8 2b 1a 00 00       	call   4282a <set_pagetable>

    // This function is defined in k-exception.S. It restores the process's
    // registers then jumps back to user mode.
    exception_return(&p->p_registers);
   40dff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40e03:	48 83 c0 08          	add    $0x8,%rax
   40e07:	48 89 c7             	mov    %rax,%rdi
   40e0a:	e8 b4 f2 ff ff       	call   400c3 <exception_return>

0000000000040e0f <pageinfo_init>:


// pageinfo_init
//    Initialize the `pageinfo[]` array.

void pageinfo_init(void) {
   40e0f:	f3 0f 1e fa          	endbr64 
   40e13:	55                   	push   %rbp
   40e14:	48 89 e5             	mov    %rsp,%rbp
   40e17:	48 83 ec 10          	sub    $0x10,%rsp
    extern char end[];

    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   40e1b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   40e22:	00 
   40e23:	e9 93 00 00 00       	jmp    40ebb <pageinfo_init+0xac>
        int owner;
        if (physical_memory_isreserved(addr)) {
   40e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40e2c:	48 89 c7             	mov    %rax,%rdi
   40e2f:	e8 68 1b 00 00       	call   4299c <physical_memory_isreserved>
   40e34:	85 c0                	test   %eax,%eax
   40e36:	74 09                	je     40e41 <pageinfo_init+0x32>
            owner = PO_RESERVED;
   40e38:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%rbp)
   40e3f:	eb 31                	jmp    40e72 <pageinfo_init+0x63>
        } else if ((addr >= KERNEL_START_ADDR && addr < (uintptr_t) end)
   40e41:	48 81 7d f8 ff ff 03 	cmpq   $0x3ffff,-0x8(%rbp)
   40e48:	00 
   40e49:	76 0d                	jbe    40e58 <pageinfo_init+0x49>
   40e4b:	48 8d 05 be b1 01 00 	lea    0x1b1be(%rip),%rax        # 5c010 <end>
   40e52:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40e56:	72 0a                	jb     40e62 <pageinfo_init+0x53>
                   || addr == KERNEL_STACK_TOP - PAGESIZE) {
   40e58:	48 81 7d f8 00 f0 07 	cmpq   $0x7f000,-0x8(%rbp)
   40e5f:	00 
   40e60:	75 09                	jne    40e6b <pageinfo_init+0x5c>
            owner = PO_KERNEL;
   40e62:	c7 45 f4 fe ff ff ff 	movl   $0xfffffffe,-0xc(%rbp)
   40e69:	eb 07                	jmp    40e72 <pageinfo_init+0x63>
        } else {
            owner = PO_FREE;
   40e6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
        }
        pageinfo[PAGENUMBER(addr)].owner = owner;
   40e72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40e76:	48 c1 e8 0c          	shr    $0xc,%rax
   40e7a:	89 c2                	mov    %eax,%edx
   40e7c:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40e7f:	89 c1                	mov    %eax,%ecx
   40e81:	48 63 c2             	movslq %edx,%rax
   40e84:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   40e88:	48 8d 05 31 2f 01 00 	lea    0x12f31(%rip),%rax        # 53dc0 <pageinfo>
   40e8f:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
        pageinfo[PAGENUMBER(addr)].refcount = (owner != PO_FREE);
   40e92:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   40e96:	0f 95 c2             	setne  %dl
   40e99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40e9d:	48 c1 e8 0c          	shr    $0xc,%rax
   40ea1:	89 d1                	mov    %edx,%ecx
   40ea3:	48 98                	cltq   
   40ea5:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   40ea9:	48 8d 05 11 2f 01 00 	lea    0x12f11(%rip),%rax        # 53dc1 <pageinfo+0x1>
   40eb0:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   40eb3:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   40eba:	00 
   40ebb:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   40ec2:	00 
   40ec3:	0f 86 5f ff ff ff    	jbe    40e28 <pageinfo_init+0x19>
    }
}
   40ec9:	90                   	nop
   40eca:	90                   	nop
   40ecb:	c9                   	leave  
   40ecc:	c3                   	ret    

0000000000040ecd <check_page_table_mappings>:

// check_page_table_mappings
//    Check operating system invariants about kernel mappings for page
//    table `pt`. Panic if any of the invariants are false.

void check_page_table_mappings(x86_64_pagetable* pt) {
   40ecd:	f3 0f 1e fa          	endbr64 
   40ed1:	55                   	push   %rbp
   40ed2:	48 89 e5             	mov    %rsp,%rbp
   40ed5:	48 83 ec 50          	sub    $0x50,%rsp
   40ed9:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
    extern char start_data[], end[];
    assert(PTE_ADDR(pt) == (uintptr_t) pt);
   40edd:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40ee1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   40ee7:	48 89 c2             	mov    %rax,%rdx
   40eea:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40eee:	48 39 c2             	cmp    %rax,%rdx
   40ef1:	74 1e                	je     40f11 <check_page_table_mappings+0x44>
   40ef3:	48 8d 05 d6 33 00 00 	lea    0x33d6(%rip),%rax        # 442d0 <console_clear+0x1ea>
   40efa:	48 89 c2             	mov    %rax,%rdx
   40efd:	be 07 02 00 00       	mov    $0x207,%esi
   40f02:	48 8d 05 2c 32 00 00 	lea    0x322c(%rip),%rax        # 44135 <console_clear+0x4f>
   40f09:	48 89 c7             	mov    %rax,%rdi
   40f0c:	e8 66 24 00 00       	call   43377 <assert_fail>

    // kernel memory is identity mapped; data is writable
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   40f11:	48 c7 45 f8 00 00 04 	movq   $0x40000,-0x8(%rbp)
   40f18:	00 
   40f19:	e9 b5 00 00 00       	jmp    40fd3 <check_page_table_mappings+0x106>
         va += PAGESIZE) {
        vamapping vam = virtual_memory_lookup(pt, va);
   40f1e:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
   40f22:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   40f26:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   40f2a:	48 89 ce             	mov    %rcx,%rsi
   40f2d:	48 89 c7             	mov    %rax,%rdi
   40f30:	e8 01 18 00 00       	call   42736 <virtual_memory_lookup>
        if (vam.pa != va) {
   40f35:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40f39:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40f3d:	74 2c                	je     40f6b <check_page_table_mappings+0x9e>
            console_printf(CPOS(22, 0), 0xC000, "%p vs %p\n", va, vam.pa);
   40f3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   40f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40f47:	49 89 d0             	mov    %rdx,%r8
   40f4a:	48 89 c1             	mov    %rax,%rcx
   40f4d:	48 8d 05 9b 33 00 00 	lea    0x339b(%rip),%rax        # 442ef <console_clear+0x209>
   40f54:	48 89 c2             	mov    %rax,%rdx
   40f57:	be 00 c0 00 00       	mov    $0xc000,%esi
   40f5c:	bf e0 06 00 00       	mov    $0x6e0,%edi
   40f61:	b8 00 00 00 00       	mov    $0x0,%eax
   40f66:	e8 b8 30 00 00       	call   44023 <console_printf>
        }
        assert(vam.pa == va);
   40f6b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40f6f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40f73:	74 1e                	je     40f93 <check_page_table_mappings+0xc6>
   40f75:	48 8d 05 7d 33 00 00 	lea    0x337d(%rip),%rax        # 442f9 <console_clear+0x213>
   40f7c:	48 89 c2             	mov    %rax,%rdx
   40f7f:	be 10 02 00 00       	mov    $0x210,%esi
   40f84:	48 8d 05 aa 31 00 00 	lea    0x31aa(%rip),%rax        # 44135 <console_clear+0x4f>
   40f8b:	48 89 c7             	mov    %rax,%rdi
   40f8e:	e8 e4 23 00 00       	call   43377 <assert_fail>
        if (va >= (uintptr_t) start_data) {
   40f93:	48 8d 05 66 40 00 00 	lea    0x4066(%rip),%rax        # 45000 <__pagetable_owner__>
   40f9a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40f9e:	72 2b                	jb     40fcb <check_page_table_mappings+0xfe>
            assert(vam.perm & PTE_W);
   40fa0:	8b 45 d0             	mov    -0x30(%rbp),%eax
   40fa3:	48 98                	cltq   
   40fa5:	83 e0 02             	and    $0x2,%eax
   40fa8:	48 85 c0             	test   %rax,%rax
   40fab:	75 1e                	jne    40fcb <check_page_table_mappings+0xfe>
   40fad:	48 8d 05 52 33 00 00 	lea    0x3352(%rip),%rax        # 44306 <console_clear+0x220>
   40fb4:	48 89 c2             	mov    %rax,%rdx
   40fb7:	be 12 02 00 00       	mov    $0x212,%esi
   40fbc:	48 8d 05 72 31 00 00 	lea    0x3172(%rip),%rax        # 44135 <console_clear+0x4f>
   40fc3:	48 89 c7             	mov    %rax,%rdi
   40fc6:	e8 ac 23 00 00       	call   43377 <assert_fail>
         va += PAGESIZE) {
   40fcb:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   40fd2:	00 
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   40fd3:	48 8d 05 36 b0 01 00 	lea    0x1b036(%rip),%rax        # 5c010 <end>
   40fda:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40fde:	0f 82 3a ff ff ff    	jb     40f1e <check_page_table_mappings+0x51>
        }
    }

    // kernel stack is identity mapped and writable
    uintptr_t kstack = KERNEL_STACK_TOP - PAGESIZE;
   40fe4:	48 c7 45 f0 00 f0 07 	movq   $0x7f000,-0x10(%rbp)
   40feb:	00 
    vamapping vam = virtual_memory_lookup(pt, kstack);
   40fec:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
   40ff0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40ff4:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   40ff8:	48 89 ce             	mov    %rcx,%rsi
   40ffb:	48 89 c7             	mov    %rax,%rdi
   40ffe:	e8 33 17 00 00       	call   42736 <virtual_memory_lookup>
    assert(vam.pa == kstack);
   41003:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41007:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   4100b:	74 1e                	je     4102b <check_page_table_mappings+0x15e>
   4100d:	48 8d 05 03 33 00 00 	lea    0x3303(%rip),%rax        # 44317 <console_clear+0x231>
   41014:	48 89 c2             	mov    %rax,%rdx
   41017:	be 19 02 00 00       	mov    $0x219,%esi
   4101c:	48 8d 05 12 31 00 00 	lea    0x3112(%rip),%rax        # 44135 <console_clear+0x4f>
   41023:	48 89 c7             	mov    %rax,%rdi
   41026:	e8 4c 23 00 00       	call   43377 <assert_fail>
    assert(vam.perm & PTE_W);
   4102b:	8b 45 e8             	mov    -0x18(%rbp),%eax
   4102e:	48 98                	cltq   
   41030:	83 e0 02             	and    $0x2,%eax
   41033:	48 85 c0             	test   %rax,%rax
   41036:	75 1e                	jne    41056 <check_page_table_mappings+0x189>
   41038:	48 8d 05 c7 32 00 00 	lea    0x32c7(%rip),%rax        # 44306 <console_clear+0x220>
   4103f:	48 89 c2             	mov    %rax,%rdx
   41042:	be 1a 02 00 00       	mov    $0x21a,%esi
   41047:	48 8d 05 e7 30 00 00 	lea    0x30e7(%rip),%rax        # 44135 <console_clear+0x4f>
   4104e:	48 89 c7             	mov    %rax,%rdi
   41051:	e8 21 23 00 00       	call   43377 <assert_fail>
}
   41056:	90                   	nop
   41057:	c9                   	leave  
   41058:	c3                   	ret    

0000000000041059 <check_page_table_ownership>:
//    counts for page table `pt`. Panic if any of the invariants are false.

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount);

void check_page_table_ownership(x86_64_pagetable* pt, pid_t pid) {
   41059:	f3 0f 1e fa          	endbr64 
   4105d:	55                   	push   %rbp
   4105e:	48 89 e5             	mov    %rsp,%rbp
   41061:	48 83 ec 20          	sub    $0x20,%rsp
   41065:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   41069:	89 75 e4             	mov    %esi,-0x1c(%rbp)
    // calculate expected reference count for page tables
    int owner = pid;
   4106c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   4106f:	89 45 fc             	mov    %eax,-0x4(%rbp)
    int expected_refcount = 1;
   41072:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
    if (pt == kernel_pagetable) {
   41079:	48 8b 05 80 3f 01 00 	mov    0x13f80(%rip),%rax        # 55000 <kernel_pagetable>
   41080:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
   41084:	0f 85 85 00 00 00    	jne    4110f <check_page_table_ownership+0xb6>
        owner = PO_KERNEL;
   4108a:	c7 45 fc fe ff ff ff 	movl   $0xfffffffe,-0x4(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   41091:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   41098:	eb 6f                	jmp    41109 <check_page_table_ownership+0xb0>
            if (processes[xpid].p_state != P_FREE
   4109a:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4109d:	48 63 d0             	movslq %eax,%rdx
   410a0:	48 89 d0             	mov    %rdx,%rax
   410a3:	48 01 c0             	add    %rax,%rax
   410a6:	48 01 d0             	add    %rdx,%rax
   410a9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   410b0:	00 
   410b1:	48 01 d0             	add    %rdx,%rax
   410b4:	48 c1 e0 03          	shl    $0x3,%rax
   410b8:	48 89 c2             	mov    %rax,%rdx
   410bb:	48 8d 05 26 20 01 00 	lea    0x12026(%rip),%rax        # 530e8 <processes+0xc8>
   410c2:	8b 04 02             	mov    (%rdx,%rax,1),%eax
   410c5:	85 c0                	test   %eax,%eax
   410c7:	74 3c                	je     41105 <check_page_table_ownership+0xac>
                && processes[xpid].p_pagetable == kernel_pagetable) {
   410c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
   410cc:	48 63 d0             	movslq %eax,%rdx
   410cf:	48 89 d0             	mov    %rdx,%rax
   410d2:	48 01 c0             	add    %rax,%rax
   410d5:	48 01 d0             	add    %rdx,%rax
   410d8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   410df:	00 
   410e0:	48 01 d0             	add    %rdx,%rax
   410e3:	48 c1 e0 03          	shl    $0x3,%rax
   410e7:	48 89 c2             	mov    %rax,%rdx
   410ea:	48 8d 05 ff 1f 01 00 	lea    0x11fff(%rip),%rax        # 530f0 <processes+0xd0>
   410f1:	48 8b 14 02          	mov    (%rdx,%rax,1),%rdx
   410f5:	48 8b 05 04 3f 01 00 	mov    0x13f04(%rip),%rax        # 55000 <kernel_pagetable>
   410fc:	48 39 c2             	cmp    %rax,%rdx
   410ff:	75 04                	jne    41105 <check_page_table_ownership+0xac>
                ++expected_refcount;
   41101:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   41105:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   41109:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
   4110d:	7e 8b                	jle    4109a <check_page_table_ownership+0x41>
            }
        }
    }
    check_page_table_ownership_level(pt, 0, owner, expected_refcount);
   4110f:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   41112:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41115:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41119:	be 00 00 00 00       	mov    $0x0,%esi
   4111e:	48 89 c7             	mov    %rax,%rdi
   41121:	e8 03 00 00 00       	call   41129 <check_page_table_ownership_level>
}
   41126:	90                   	nop
   41127:	c9                   	leave  
   41128:	c3                   	ret    

0000000000041129 <check_page_table_ownership_level>:

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount) {
   41129:	f3 0f 1e fa          	endbr64 
   4112d:	55                   	push   %rbp
   4112e:	48 89 e5             	mov    %rsp,%rbp
   41131:	48 83 ec 30          	sub    $0x30,%rsp
   41135:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   41139:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   4113c:	89 55 e0             	mov    %edx,-0x20(%rbp)
   4113f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
    assert(PAGENUMBER(pt) < NPAGES);
   41142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41146:	48 c1 e8 0c          	shr    $0xc,%rax
   4114a:	3d ff 01 00 00       	cmp    $0x1ff,%eax
   4114f:	7e 1e                	jle    4116f <check_page_table_ownership_level+0x46>
   41151:	48 8d 05 d0 31 00 00 	lea    0x31d0(%rip),%rax        # 44328 <console_clear+0x242>
   41158:	48 89 c2             	mov    %rax,%rdx
   4115b:	be 37 02 00 00       	mov    $0x237,%esi
   41160:	48 8d 05 ce 2f 00 00 	lea    0x2fce(%rip),%rax        # 44135 <console_clear+0x4f>
   41167:	48 89 c7             	mov    %rax,%rdi
   4116a:	e8 08 22 00 00       	call   43377 <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].owner == owner);
   4116f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41173:	48 c1 e8 0c          	shr    $0xc,%rax
   41177:	48 98                	cltq   
   41179:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   4117d:	48 8d 05 3c 2c 01 00 	lea    0x12c3c(%rip),%rax        # 53dc0 <pageinfo>
   41184:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   41188:	0f be c0             	movsbl %al,%eax
   4118b:	39 45 e0             	cmp    %eax,-0x20(%rbp)
   4118e:	74 1e                	je     411ae <check_page_table_ownership_level+0x85>
   41190:	48 8d 05 a9 31 00 00 	lea    0x31a9(%rip),%rax        # 44340 <console_clear+0x25a>
   41197:	48 89 c2             	mov    %rax,%rdx
   4119a:	be 38 02 00 00       	mov    $0x238,%esi
   4119f:	48 8d 05 8f 2f 00 00 	lea    0x2f8f(%rip),%rax        # 44135 <console_clear+0x4f>
   411a6:	48 89 c7             	mov    %rax,%rdi
   411a9:	e8 c9 21 00 00       	call   43377 <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].refcount == refcount);
   411ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   411b2:	48 c1 e8 0c          	shr    $0xc,%rax
   411b6:	48 98                	cltq   
   411b8:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   411bc:	48 8d 05 fe 2b 01 00 	lea    0x12bfe(%rip),%rax        # 53dc1 <pageinfo+0x1>
   411c3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   411c7:	0f be c0             	movsbl %al,%eax
   411ca:	39 45 dc             	cmp    %eax,-0x24(%rbp)
   411cd:	74 1e                	je     411ed <check_page_table_ownership_level+0xc4>
   411cf:	48 8d 05 92 31 00 00 	lea    0x3192(%rip),%rax        # 44368 <console_clear+0x282>
   411d6:	48 89 c2             	mov    %rax,%rdx
   411d9:	be 39 02 00 00       	mov    $0x239,%esi
   411de:	48 8d 05 50 2f 00 00 	lea    0x2f50(%rip),%rax        # 44135 <console_clear+0x4f>
   411e5:	48 89 c7             	mov    %rax,%rdi
   411e8:	e8 8a 21 00 00       	call   43377 <assert_fail>
    if (level < 3) {
   411ed:	83 7d e4 02          	cmpl   $0x2,-0x1c(%rbp)
   411f1:	7f 5b                	jg     4124e <check_page_table_ownership_level+0x125>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   411f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   411fa:	eb 49                	jmp    41245 <check_page_table_ownership_level+0x11c>
            if (pt->entry[index]) {
   411fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41200:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41203:	48 63 d2             	movslq %edx,%rdx
   41206:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   4120a:	48 85 c0             	test   %rax,%rax
   4120d:	74 32                	je     41241 <check_page_table_ownership_level+0x118>
                x86_64_pagetable* nextpt =
                    (x86_64_pagetable*) PTE_ADDR(pt->entry[index]);
   4120f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41213:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41216:	48 63 d2             	movslq %edx,%rdx
   41219:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   4121d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
                x86_64_pagetable* nextpt =
   41223:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                check_page_table_ownership_level(nextpt, level + 1, owner, 1);
   41227:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   4122a:	8d 70 01             	lea    0x1(%rax),%esi
   4122d:	8b 55 e0             	mov    -0x20(%rbp),%edx
   41230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   41234:	b9 01 00 00 00       	mov    $0x1,%ecx
   41239:	48 89 c7             	mov    %rax,%rdi
   4123c:	e8 e8 fe ff ff       	call   41129 <check_page_table_ownership_level>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   41241:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41245:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   4124c:	7e ae                	jle    411fc <check_page_table_ownership_level+0xd3>
            }
        }
    }
}
   4124e:	90                   	nop
   4124f:	c9                   	leave  
   41250:	c3                   	ret    

0000000000041251 <check_virtual_memory>:

// check_virtual_memory
//    Check operating system invariants about virtual memory. Panic if any
//    of the invariants are false.

void check_virtual_memory(void) {
   41251:	f3 0f 1e fa          	endbr64 
   41255:	55                   	push   %rbp
   41256:	48 89 e5             	mov    %rsp,%rbp
   41259:	48 83 ec 10          	sub    $0x10,%rsp
    // Process 0 must never be used.
    assert(processes[0].p_state == P_FREE);
   4125d:	8b 05 85 1e 01 00    	mov    0x11e85(%rip),%eax        # 530e8 <processes+0xc8>
   41263:	85 c0                	test   %eax,%eax
   41265:	74 1e                	je     41285 <check_virtual_memory+0x34>
   41267:	48 8d 05 2a 31 00 00 	lea    0x312a(%rip),%rax        # 44398 <console_clear+0x2b2>
   4126e:	48 89 c2             	mov    %rax,%rdx
   41271:	be 4c 02 00 00       	mov    $0x24c,%esi
   41276:	48 8d 05 b8 2e 00 00 	lea    0x2eb8(%rip),%rax        # 44135 <console_clear+0x4f>
   4127d:	48 89 c7             	mov    %rax,%rdi
   41280:	e8 f2 20 00 00       	call   43377 <assert_fail>
    // that don't have their own page tables.
    // Active processes have their own page tables. A process page table
    // should be owned by that process and have reference count 1.
    // All level-2-4 page tables must have reference count 1.

    check_page_table_mappings(kernel_pagetable);
   41285:	48 8b 05 74 3d 01 00 	mov    0x13d74(%rip),%rax        # 55000 <kernel_pagetable>
   4128c:	48 89 c7             	mov    %rax,%rdi
   4128f:	e8 39 fc ff ff       	call   40ecd <check_page_table_mappings>
    check_page_table_ownership(kernel_pagetable, -1);
   41294:	48 8b 05 65 3d 01 00 	mov    0x13d65(%rip),%rax        # 55000 <kernel_pagetable>
   4129b:	be ff ff ff ff       	mov    $0xffffffff,%esi
   412a0:	48 89 c7             	mov    %rax,%rdi
   412a3:	e8 b1 fd ff ff       	call   41059 <check_page_table_ownership>

    for (int pid = 0; pid < NPROC; ++pid) {
   412a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   412af:	e9 dc 00 00 00       	jmp    41390 <check_virtual_memory+0x13f>
        if (processes[pid].p_state != P_FREE
   412b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
   412b7:	48 63 d0             	movslq %eax,%rdx
   412ba:	48 89 d0             	mov    %rdx,%rax
   412bd:	48 01 c0             	add    %rax,%rax
   412c0:	48 01 d0             	add    %rdx,%rax
   412c3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   412ca:	00 
   412cb:	48 01 d0             	add    %rdx,%rax
   412ce:	48 c1 e0 03          	shl    $0x3,%rax
   412d2:	48 89 c2             	mov    %rax,%rdx
   412d5:	48 8d 05 0c 1e 01 00 	lea    0x11e0c(%rip),%rax        # 530e8 <processes+0xc8>
   412dc:	8b 04 02             	mov    (%rdx,%rax,1),%eax
   412df:	85 c0                	test   %eax,%eax
   412e1:	0f 84 a5 00 00 00    	je     4138c <check_virtual_memory+0x13b>
            && processes[pid].p_pagetable != kernel_pagetable) {
   412e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
   412ea:	48 63 d0             	movslq %eax,%rdx
   412ed:	48 89 d0             	mov    %rdx,%rax
   412f0:	48 01 c0             	add    %rax,%rax
   412f3:	48 01 d0             	add    %rdx,%rax
   412f6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   412fd:	00 
   412fe:	48 01 d0             	add    %rdx,%rax
   41301:	48 c1 e0 03          	shl    $0x3,%rax
   41305:	48 89 c2             	mov    %rax,%rdx
   41308:	48 8d 05 e1 1d 01 00 	lea    0x11de1(%rip),%rax        # 530f0 <processes+0xd0>
   4130f:	48 8b 14 02          	mov    (%rdx,%rax,1),%rdx
   41313:	48 8b 05 e6 3c 01 00 	mov    0x13ce6(%rip),%rax        # 55000 <kernel_pagetable>
   4131a:	48 39 c2             	cmp    %rax,%rdx
   4131d:	74 6d                	je     4138c <check_virtual_memory+0x13b>
            check_page_table_mappings(processes[pid].p_pagetable);
   4131f:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41322:	48 63 d0             	movslq %eax,%rdx
   41325:	48 89 d0             	mov    %rdx,%rax
   41328:	48 01 c0             	add    %rax,%rax
   4132b:	48 01 d0             	add    %rdx,%rax
   4132e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41335:	00 
   41336:	48 01 d0             	add    %rdx,%rax
   41339:	48 c1 e0 03          	shl    $0x3,%rax
   4133d:	48 89 c2             	mov    %rax,%rdx
   41340:	48 8d 05 a9 1d 01 00 	lea    0x11da9(%rip),%rax        # 530f0 <processes+0xd0>
   41347:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
   4134b:	48 89 c7             	mov    %rax,%rdi
   4134e:	e8 7a fb ff ff       	call   40ecd <check_page_table_mappings>
            check_page_table_ownership(processes[pid].p_pagetable, pid);
   41353:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41356:	48 63 d0             	movslq %eax,%rdx
   41359:	48 89 d0             	mov    %rdx,%rax
   4135c:	48 01 c0             	add    %rax,%rax
   4135f:	48 01 d0             	add    %rdx,%rax
   41362:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41369:	00 
   4136a:	48 01 d0             	add    %rdx,%rax
   4136d:	48 c1 e0 03          	shl    $0x3,%rax
   41371:	48 89 c2             	mov    %rax,%rdx
   41374:	48 8d 05 75 1d 01 00 	lea    0x11d75(%rip),%rax        # 530f0 <processes+0xd0>
   4137b:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
   4137f:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41382:	89 d6                	mov    %edx,%esi
   41384:	48 89 c7             	mov    %rax,%rdi
   41387:	e8 cd fc ff ff       	call   41059 <check_page_table_ownership>
    for (int pid = 0; pid < NPROC; ++pid) {
   4138c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41390:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   41394:	0f 8e 1a ff ff ff    	jle    412b4 <check_virtual_memory+0x63>
        }
    }

    // Check that all referenced pages refer to active processes
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   4139a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   413a1:	e9 95 00 00 00       	jmp    4143b <check_virtual_memory+0x1ea>
        if (pageinfo[pn].refcount > 0 && pageinfo[pn].owner >= 0) {
   413a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
   413a9:	48 98                	cltq   
   413ab:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   413af:	48 8d 05 0b 2a 01 00 	lea    0x12a0b(%rip),%rax        # 53dc1 <pageinfo+0x1>
   413b6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   413ba:	84 c0                	test   %al,%al
   413bc:	7e 79                	jle    41437 <check_virtual_memory+0x1e6>
   413be:	8b 45 f8             	mov    -0x8(%rbp),%eax
   413c1:	48 98                	cltq   
   413c3:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   413c7:	48 8d 05 f2 29 01 00 	lea    0x129f2(%rip),%rax        # 53dc0 <pageinfo>
   413ce:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   413d2:	84 c0                	test   %al,%al
   413d4:	78 61                	js     41437 <check_virtual_memory+0x1e6>
            assert(processes[pageinfo[pn].owner].p_state != P_FREE);
   413d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
   413d9:	48 98                	cltq   
   413db:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   413df:	48 8d 05 da 29 01 00 	lea    0x129da(%rip),%rax        # 53dc0 <pageinfo>
   413e6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   413ea:	0f be c0             	movsbl %al,%eax
   413ed:	48 63 d0             	movslq %eax,%rdx
   413f0:	48 89 d0             	mov    %rdx,%rax
   413f3:	48 01 c0             	add    %rax,%rax
   413f6:	48 01 d0             	add    %rdx,%rax
   413f9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41400:	00 
   41401:	48 01 d0             	add    %rdx,%rax
   41404:	48 c1 e0 03          	shl    $0x3,%rax
   41408:	48 89 c2             	mov    %rax,%rdx
   4140b:	48 8d 05 d6 1c 01 00 	lea    0x11cd6(%rip),%rax        # 530e8 <processes+0xc8>
   41412:	8b 04 02             	mov    (%rdx,%rax,1),%eax
   41415:	85 c0                	test   %eax,%eax
   41417:	75 1e                	jne    41437 <check_virtual_memory+0x1e6>
   41419:	48 8d 05 98 2f 00 00 	lea    0x2f98(%rip),%rax        # 443b8 <console_clear+0x2d2>
   41420:	48 89 c2             	mov    %rax,%rdx
   41423:	be 63 02 00 00       	mov    $0x263,%esi
   41428:	48 8d 05 06 2d 00 00 	lea    0x2d06(%rip),%rax        # 44135 <console_clear+0x4f>
   4142f:	48 89 c7             	mov    %rax,%rdi
   41432:	e8 40 1f 00 00       	call   43377 <assert_fail>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   41437:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   4143b:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
   41442:	0f 8e 5e ff ff ff    	jle    413a6 <check_virtual_memory+0x155>
        }
    }
}
   41448:	90                   	nop
   41449:	90                   	nop
   4144a:	c9                   	leave  
   4144b:	c3                   	ret    

000000000004144c <memshow_physical>:
    '6' | 0x0C00, '7' | 0x0A00, '8' | 0x0900, '9' | 0x0E00,
    'A' | 0x0F00, 'B' | 0x0C00, 'C' | 0x0A00, 'D' | 0x0900,
    'E' | 0x0E00, 'F' | 0x0F00
};

void memshow_physical(void) {
   4144c:	f3 0f 1e fa          	endbr64 
   41450:	55                   	push   %rbp
   41451:	48 89 e5             	mov    %rsp,%rbp
   41454:	48 83 ec 10          	sub    $0x10,%rsp
    console_printf(CPOS(0, 32), 0x0F00, "PHYSICAL MEMORY");
   41458:	48 8d 05 c5 2f 00 00 	lea    0x2fc5(%rip),%rax        # 44424 <memstate_colors+0x24>
   4145f:	48 89 c2             	mov    %rax,%rdx
   41462:	be 00 0f 00 00       	mov    $0xf00,%esi
   41467:	bf 20 00 00 00       	mov    $0x20,%edi
   4146c:	b8 00 00 00 00       	mov    $0x0,%eax
   41471:	e8 ad 2b 00 00       	call   44023 <console_printf>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   41476:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4147d:	e9 05 01 00 00       	jmp    41587 <memshow_physical+0x13b>
        if (pn % 64 == 0) {
   41482:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41485:	83 e0 3f             	and    $0x3f,%eax
   41488:	85 c0                	test   %eax,%eax
   4148a:	75 40                	jne    414cc <memshow_physical+0x80>
            console_printf(CPOS(1 + pn / 64, 3), 0x0F00, "0x%06X ", pn << 12);
   4148c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4148f:	c1 e0 0c             	shl    $0xc,%eax
   41492:	89 c2                	mov    %eax,%edx
   41494:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41497:	8d 48 3f             	lea    0x3f(%rax),%ecx
   4149a:	85 c0                	test   %eax,%eax
   4149c:	0f 48 c1             	cmovs  %ecx,%eax
   4149f:	c1 f8 06             	sar    $0x6,%eax
   414a2:	8d 48 01             	lea    0x1(%rax),%ecx
   414a5:	89 c8                	mov    %ecx,%eax
   414a7:	c1 e0 02             	shl    $0x2,%eax
   414aa:	01 c8                	add    %ecx,%eax
   414ac:	c1 e0 04             	shl    $0x4,%eax
   414af:	83 c0 03             	add    $0x3,%eax
   414b2:	89 d1                	mov    %edx,%ecx
   414b4:	48 8d 15 79 2f 00 00 	lea    0x2f79(%rip),%rdx        # 44434 <memstate_colors+0x34>
   414bb:	be 00 0f 00 00       	mov    $0xf00,%esi
   414c0:	89 c7                	mov    %eax,%edi
   414c2:	b8 00 00 00 00       	mov    $0x0,%eax
   414c7:	e8 57 2b 00 00       	call   44023 <console_printf>
        }

        int owner = pageinfo[pn].owner;
   414cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
   414cf:	48 98                	cltq   
   414d1:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   414d5:	48 8d 05 e4 28 01 00 	lea    0x128e4(%rip),%rax        # 53dc0 <pageinfo>
   414dc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   414e0:	0f be c0             	movsbl %al,%eax
   414e3:	89 45 f8             	mov    %eax,-0x8(%rbp)
        if (pageinfo[pn].refcount == 0) {
   414e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   414e9:	48 98                	cltq   
   414eb:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   414ef:	48 8d 05 cb 28 01 00 	lea    0x128cb(%rip),%rax        # 53dc1 <pageinfo+0x1>
   414f6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   414fa:	84 c0                	test   %al,%al
   414fc:	75 07                	jne    41505 <memshow_physical+0xb9>
            owner = PO_FREE;
   414fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
        }
        uint16_t color = memstate_colors[owner - PO_KERNEL];
   41505:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41508:	83 c0 02             	add    $0x2,%eax
   4150b:	48 98                	cltq   
   4150d:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   41511:	48 8d 05 e8 2e 00 00 	lea    0x2ee8(%rip),%rax        # 44400 <memstate_colors>
   41518:	0f b7 04 02          	movzwl (%rdx,%rax,1),%eax
   4151c:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
        // darker color for shared pages
        if (pageinfo[pn].refcount > 1) {
   41520:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41523:	48 98                	cltq   
   41525:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   41529:	48 8d 05 91 28 01 00 	lea    0x12891(%rip),%rax        # 53dc1 <pageinfo+0x1>
   41530:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   41534:	3c 01                	cmp    $0x1,%al
   41536:	7e 06                	jle    4153e <memshow_physical+0xf2>
            color &= 0x77FF;
   41538:	66 81 65 f6 ff 77    	andw   $0x77ff,-0xa(%rbp)
        }

        console[CPOS(1 + pn / 64, 12 + pn % 64)] = color;
   4153e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41541:	8d 50 3f             	lea    0x3f(%rax),%edx
   41544:	85 c0                	test   %eax,%eax
   41546:	0f 48 c2             	cmovs  %edx,%eax
   41549:	c1 f8 06             	sar    $0x6,%eax
   4154c:	8d 50 01             	lea    0x1(%rax),%edx
   4154f:	89 d0                	mov    %edx,%eax
   41551:	c1 e0 02             	shl    $0x2,%eax
   41554:	01 d0                	add    %edx,%eax
   41556:	c1 e0 04             	shl    $0x4,%eax
   41559:	89 c1                	mov    %eax,%ecx
   4155b:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4155e:	99                   	cltd   
   4155f:	c1 ea 1a             	shr    $0x1a,%edx
   41562:	01 d0                	add    %edx,%eax
   41564:	83 e0 3f             	and    $0x3f,%eax
   41567:	29 d0                	sub    %edx,%eax
   41569:	83 c0 0c             	add    $0xc,%eax
   4156c:	01 c8                	add    %ecx,%eax
   4156e:	48 98                	cltq   
   41570:	48 8d 0c 00          	lea    (%rax,%rax,1),%rcx
   41574:	48 8d 15 85 6a 07 00 	lea    0x76a85(%rip),%rdx        # b8000 <console>
   4157b:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   4157f:	66 89 04 11          	mov    %ax,(%rcx,%rdx,1)
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   41583:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41587:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   4158e:	0f 8e ee fe ff ff    	jle    41482 <memshow_physical+0x36>
    }
}
   41594:	90                   	nop
   41595:	90                   	nop
   41596:	c9                   	leave  
   41597:	c3                   	ret    

0000000000041598 <memshow_virtual>:

// memshow_virtual(pagetable, name)
//    Draw a picture of the virtual memory map `pagetable` (named `name`) on
//    the CGA console.

void memshow_virtual(x86_64_pagetable* pagetable, const char* name) {
   41598:	f3 0f 1e fa          	endbr64 
   4159c:	55                   	push   %rbp
   4159d:	48 89 e5             	mov    %rsp,%rbp
   415a0:	48 83 ec 40          	sub    $0x40,%rsp
   415a4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   415a8:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    assert((uintptr_t) pagetable == PTE_ADDR(pagetable));
   415ac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   415b0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   415b6:	48 89 c2             	mov    %rax,%rdx
   415b9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   415bd:	48 39 c2             	cmp    %rax,%rdx
   415c0:	74 1e                	je     415e0 <memshow_virtual+0x48>
   415c2:	48 8d 05 77 2e 00 00 	lea    0x2e77(%rip),%rax        # 44440 <memstate_colors+0x40>
   415c9:	48 89 c2             	mov    %rax,%rdx
   415cc:	be 8f 02 00 00       	mov    $0x28f,%esi
   415d1:	48 8d 05 5d 2b 00 00 	lea    0x2b5d(%rip),%rax        # 44135 <console_clear+0x4f>
   415d8:	48 89 c7             	mov    %rax,%rdi
   415db:	e8 97 1d 00 00       	call   43377 <assert_fail>

    console_printf(CPOS(10, 26), 0x0F00, "VIRTUAL ADDRESS SPACE FOR %s", name);
   415e0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   415e4:	48 89 c1             	mov    %rax,%rcx
   415e7:	48 8d 05 7f 2e 00 00 	lea    0x2e7f(%rip),%rax        # 4446d <memstate_colors+0x6d>
   415ee:	48 89 c2             	mov    %rax,%rdx
   415f1:	be 00 0f 00 00       	mov    $0xf00,%esi
   415f6:	bf 3a 03 00 00       	mov    $0x33a,%edi
   415fb:	b8 00 00 00 00       	mov    $0x0,%eax
   41600:	e8 1e 2a 00 00       	call   44023 <console_printf>
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   41605:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   4160c:	00 
   4160d:	e9 85 01 00 00       	jmp    41797 <memshow_virtual+0x1ff>
        vamapping vam = virtual_memory_lookup(pagetable, va);
   41612:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   41616:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   4161a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   4161e:	48 89 ce             	mov    %rcx,%rsi
   41621:	48 89 c7             	mov    %rax,%rdi
   41624:	e8 0d 11 00 00       	call   42736 <virtual_memory_lookup>
        uint16_t color;
        if (vam.pn < 0) {
   41629:	8b 45 d0             	mov    -0x30(%rbp),%eax
   4162c:	85 c0                	test   %eax,%eax
   4162e:	79 0b                	jns    4163b <memshow_virtual+0xa3>
            color = ' ';
   41630:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%rbp)
   41636:	e9 d0 00 00 00       	jmp    4170b <memshow_virtual+0x173>
        } else {
            assert(vam.pa < MEMSIZE_PHYSICAL);
   4163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4163f:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   41645:	76 1e                	jbe    41665 <memshow_virtual+0xcd>
   41647:	48 8d 05 3c 2e 00 00 	lea    0x2e3c(%rip),%rax        # 4448a <memstate_colors+0x8a>
   4164e:	48 89 c2             	mov    %rax,%rdx
   41651:	be 98 02 00 00       	mov    $0x298,%esi
   41656:	48 8d 05 d8 2a 00 00 	lea    0x2ad8(%rip),%rax        # 44135 <console_clear+0x4f>
   4165d:	48 89 c7             	mov    %rax,%rdi
   41660:	e8 12 1d 00 00       	call   43377 <assert_fail>
            int owner = pageinfo[vam.pn].owner;
   41665:	8b 45 d0             	mov    -0x30(%rbp),%eax
   41668:	48 98                	cltq   
   4166a:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   4166e:	48 8d 05 4b 27 01 00 	lea    0x1274b(%rip),%rax        # 53dc0 <pageinfo>
   41675:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   41679:	0f be c0             	movsbl %al,%eax
   4167c:	89 45 f0             	mov    %eax,-0x10(%rbp)
            if (pageinfo[vam.pn].refcount == 0) {
   4167f:	8b 45 d0             	mov    -0x30(%rbp),%eax
   41682:	48 98                	cltq   
   41684:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   41688:	48 8d 05 32 27 01 00 	lea    0x12732(%rip),%rax        # 53dc1 <pageinfo+0x1>
   4168f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   41693:	84 c0                	test   %al,%al
   41695:	75 07                	jne    4169e <memshow_virtual+0x106>
                owner = PO_FREE;
   41697:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
            }
            color = memstate_colors[owner - PO_KERNEL];
   4169e:	8b 45 f0             	mov    -0x10(%rbp),%eax
   416a1:	83 c0 02             	add    $0x2,%eax
   416a4:	48 98                	cltq   
   416a6:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   416aa:	48 8d 05 4f 2d 00 00 	lea    0x2d4f(%rip),%rax        # 44400 <memstate_colors>
   416b1:	0f b7 04 02          	movzwl (%rdx,%rax,1),%eax
   416b5:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            // reverse video for user-accessible pages
            if (vam.perm & PTE_U) {
   416b9:	8b 45 e0             	mov    -0x20(%rbp),%eax
   416bc:	48 98                	cltq   
   416be:	83 e0 04             	and    $0x4,%eax
   416c1:	48 85 c0             	test   %rax,%rax
   416c4:	74 27                	je     416ed <memshow_virtual+0x155>
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   416c6:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   416ca:	c1 e0 04             	shl    $0x4,%eax
   416cd:	66 25 00 f0          	and    $0xf000,%ax
   416d1:	89 c2                	mov    %eax,%edx
   416d3:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   416d7:	c1 f8 04             	sar    $0x4,%eax
   416da:	66 25 00 0f          	and    $0xf00,%ax
   416de:	09 c2                	or     %eax,%edx
                    | (color & 0x00FF);
   416e0:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   416e4:	0f b6 c0             	movzbl %al,%eax
   416e7:	09 d0                	or     %edx,%eax
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   416e9:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            }
            // darker color for shared pages
            if (pageinfo[vam.pn].refcount > 1) {
   416ed:	8b 45 d0             	mov    -0x30(%rbp),%eax
   416f0:	48 98                	cltq   
   416f2:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   416f6:	48 8d 05 c4 26 01 00 	lea    0x126c4(%rip),%rax        # 53dc1 <pageinfo+0x1>
   416fd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   41701:	3c 01                	cmp    $0x1,%al
   41703:	7e 06                	jle    4170b <memshow_virtual+0x173>
                color &= 0x77FF;
   41705:	66 81 65 f6 ff 77    	andw   $0x77ff,-0xa(%rbp)
            }
        }
        uint32_t pn = PAGENUMBER(va);
   4170b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4170f:	48 c1 e8 0c          	shr    $0xc,%rax
   41713:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (pn % 64 == 0) {
   41716:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41719:	83 e0 3f             	and    $0x3f,%eax
   4171c:	85 c0                	test   %eax,%eax
   4171e:	75 39                	jne    41759 <memshow_virtual+0x1c1>
            console_printf(CPOS(11 + pn / 64, 3), 0x0F00, "0x%06X ", va);
   41720:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41723:	c1 e8 06             	shr    $0x6,%eax
   41726:	89 c2                	mov    %eax,%edx
   41728:	89 d0                	mov    %edx,%eax
   4172a:	c1 e0 02             	shl    $0x2,%eax
   4172d:	01 d0                	add    %edx,%eax
   4172f:	c1 e0 04             	shl    $0x4,%eax
   41732:	05 73 03 00 00       	add    $0x373,%eax
   41737:	89 c7                	mov    %eax,%edi
   41739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4173d:	48 89 c1             	mov    %rax,%rcx
   41740:	48 8d 05 ed 2c 00 00 	lea    0x2ced(%rip),%rax        # 44434 <memstate_colors+0x34>
   41747:	48 89 c2             	mov    %rax,%rdx
   4174a:	be 00 0f 00 00       	mov    $0xf00,%esi
   4174f:	b8 00 00 00 00       	mov    $0x0,%eax
   41754:	e8 ca 28 00 00       	call   44023 <console_printf>
        }
        console[CPOS(11 + pn / 64, 12 + pn % 64)] = color;
   41759:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4175c:	c1 e8 06             	shr    $0x6,%eax
   4175f:	89 c2                	mov    %eax,%edx
   41761:	89 d0                	mov    %edx,%eax
   41763:	c1 e0 02             	shl    $0x2,%eax
   41766:	01 d0                	add    %edx,%eax
   41768:	c1 e0 04             	shl    $0x4,%eax
   4176b:	89 c2                	mov    %eax,%edx
   4176d:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41770:	83 e0 3f             	and    $0x3f,%eax
   41773:	01 d0                	add    %edx,%eax
   41775:	05 7c 03 00 00       	add    $0x37c,%eax
   4177a:	89 c0                	mov    %eax,%eax
   4177c:	48 8d 0c 00          	lea    (%rax,%rax,1),%rcx
   41780:	48 8d 15 79 68 07 00 	lea    0x76879(%rip),%rdx        # b8000 <console>
   41787:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   4178b:	66 89 04 11          	mov    %ax,(%rcx,%rdx,1)
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   4178f:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   41796:	00 
   41797:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   4179e:	00 
   4179f:	0f 86 6d fe ff ff    	jbe    41612 <memshow_virtual+0x7a>
    }
}
   417a5:	90                   	nop
   417a6:	90                   	nop
   417a7:	c9                   	leave  
   417a8:	c3                   	ret    

00000000000417a9 <memshow_virtual_animate>:

// memshow_virtual_animate
//    Draw a picture of process virtual memory maps on the CGA console.
//    Starts with process 1, then switches to a new process every 0.25 sec.

void memshow_virtual_animate(void) {
   417a9:	f3 0f 1e fa          	endbr64 
   417ad:	55                   	push   %rbp
   417ae:	48 89 e5             	mov    %rsp,%rbp
   417b1:	48 83 ec 10          	sub    $0x10,%rsp
    static unsigned last_ticks = 0;
    static int showing = 1;

    // switch to a new process every 0.25 sec
    if (last_ticks == 0 || ticks - last_ticks >= HZ / 2) {
   417b5:	8b 05 05 2a 01 00    	mov    0x12a05(%rip),%eax        # 541c0 <last_ticks.1>
   417bb:	85 c0                	test   %eax,%eax
   417bd:	74 13                	je     417d2 <memshow_virtual_animate+0x29>
   417bf:	8b 05 db 25 01 00    	mov    0x125db(%rip),%eax        # 53da0 <ticks>
   417c5:	8b 15 f5 29 01 00    	mov    0x129f5(%rip),%edx        # 541c0 <last_ticks.1>
   417cb:	29 d0                	sub    %edx,%eax
   417cd:	83 f8 31             	cmp    $0x31,%eax
   417d0:	76 2c                	jbe    417fe <memshow_virtual_animate+0x55>
        last_ticks = ticks;
   417d2:	8b 05 c8 25 01 00    	mov    0x125c8(%rip),%eax        # 53da0 <ticks>
   417d8:	89 05 e2 29 01 00    	mov    %eax,0x129e2(%rip)        # 541c0 <last_ticks.1>
        ++showing;
   417de:	8b 05 20 38 00 00    	mov    0x3820(%rip),%eax        # 45004 <showing.0>
   417e4:	83 c0 01             	add    $0x1,%eax
   417e7:	89 05 17 38 00 00    	mov    %eax,0x3817(%rip)        # 45004 <showing.0>
    }

    // the current process may have died -- don't display it if so
    while (showing <= 2*NPROC
   417ed:	eb 0f                	jmp    417fe <memshow_virtual_animate+0x55>
           && processes[showing % NPROC].p_state == P_FREE) {
        ++showing;
   417ef:	8b 05 0f 38 00 00    	mov    0x380f(%rip),%eax        # 45004 <showing.0>
   417f5:	83 c0 01             	add    $0x1,%eax
   417f8:	89 05 06 38 00 00    	mov    %eax,0x3806(%rip)        # 45004 <showing.0>
    while (showing <= 2*NPROC
   417fe:	8b 05 00 38 00 00    	mov    0x3800(%rip),%eax        # 45004 <showing.0>
           && processes[showing % NPROC].p_state == P_FREE) {
   41804:	83 f8 20             	cmp    $0x20,%eax
   41807:	7f 3d                	jg     41846 <memshow_virtual_animate+0x9d>
   41809:	8b 05 f5 37 00 00    	mov    0x37f5(%rip),%eax        # 45004 <showing.0>
   4180f:	99                   	cltd   
   41810:	c1 ea 1c             	shr    $0x1c,%edx
   41813:	01 d0                	add    %edx,%eax
   41815:	83 e0 0f             	and    $0xf,%eax
   41818:	29 d0                	sub    %edx,%eax
   4181a:	48 63 d0             	movslq %eax,%rdx
   4181d:	48 89 d0             	mov    %rdx,%rax
   41820:	48 01 c0             	add    %rax,%rax
   41823:	48 01 d0             	add    %rdx,%rax
   41826:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   4182d:	00 
   4182e:	48 01 d0             	add    %rdx,%rax
   41831:	48 c1 e0 03          	shl    $0x3,%rax
   41835:	48 89 c2             	mov    %rax,%rdx
   41838:	48 8d 05 a9 18 01 00 	lea    0x118a9(%rip),%rax        # 530e8 <processes+0xc8>
   4183f:	8b 04 02             	mov    (%rdx,%rax,1),%eax
   41842:	85 c0                	test   %eax,%eax
   41844:	74 a9                	je     417ef <memshow_virtual_animate+0x46>
    }
    showing = showing % NPROC;
   41846:	8b 05 b8 37 00 00    	mov    0x37b8(%rip),%eax        # 45004 <showing.0>
   4184c:	99                   	cltd   
   4184d:	c1 ea 1c             	shr    $0x1c,%edx
   41850:	01 d0                	add    %edx,%eax
   41852:	83 e0 0f             	and    $0xf,%eax
   41855:	29 d0                	sub    %edx,%eax
   41857:	89 05 a7 37 00 00    	mov    %eax,0x37a7(%rip)        # 45004 <showing.0>

    if (processes[showing].p_state != P_FREE) {
   4185d:	8b 05 a1 37 00 00    	mov    0x37a1(%rip),%eax        # 45004 <showing.0>
   41863:	48 63 d0             	movslq %eax,%rdx
   41866:	48 89 d0             	mov    %rdx,%rax
   41869:	48 01 c0             	add    %rax,%rax
   4186c:	48 01 d0             	add    %rdx,%rax
   4186f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41876:	00 
   41877:	48 01 d0             	add    %rdx,%rax
   4187a:	48 c1 e0 03          	shl    $0x3,%rax
   4187e:	48 89 c2             	mov    %rax,%rdx
   41881:	48 8d 05 60 18 01 00 	lea    0x11860(%rip),%rax        # 530e8 <processes+0xc8>
   41888:	8b 04 02             	mov    (%rdx,%rax,1),%eax
   4188b:	85 c0                	test   %eax,%eax
   4188d:	74 63                	je     418f2 <memshow_virtual_animate+0x149>
        char s[4];
        snprintf(s, 4, "%d ", showing);
   4188f:	8b 15 6f 37 00 00    	mov    0x376f(%rip),%edx        # 45004 <showing.0>
   41895:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
   41899:	89 d1                	mov    %edx,%ecx
   4189b:	48 8d 15 02 2c 00 00 	lea    0x2c02(%rip),%rdx        # 444a4 <memstate_colors+0xa4>
   418a2:	be 04 00 00 00       	mov    $0x4,%esi
   418a7:	48 89 c7             	mov    %rax,%rdi
   418aa:	b8 00 00 00 00       	mov    $0x0,%eax
   418af:	e8 f8 27 00 00       	call   440ac <snprintf>
        memshow_virtual(processes[showing].p_pagetable, s);
   418b4:	8b 05 4a 37 00 00    	mov    0x374a(%rip),%eax        # 45004 <showing.0>
   418ba:	48 63 d0             	movslq %eax,%rdx
   418bd:	48 89 d0             	mov    %rdx,%rax
   418c0:	48 01 c0             	add    %rax,%rax
   418c3:	48 01 d0             	add    %rdx,%rax
   418c6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   418cd:	00 
   418ce:	48 01 d0             	add    %rdx,%rax
   418d1:	48 c1 e0 03          	shl    $0x3,%rax
   418d5:	48 89 c2             	mov    %rax,%rdx
   418d8:	48 8d 05 11 18 01 00 	lea    0x11811(%rip),%rax        # 530f0 <processes+0xd0>
   418df:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
   418e3:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
   418e7:	48 89 d6             	mov    %rdx,%rsi
   418ea:	48 89 c7             	mov    %rax,%rdi
   418ed:	e8 a6 fc ff ff       	call   41598 <memshow_virtual>
    }
}
   418f2:	90                   	nop
   418f3:	c9                   	leave  
   418f4:	c3                   	ret    

00000000000418f5 <memdump_physical>:


// Dumps to the log file same information as memshow_physical

void memdump_physical(void) {
   418f5:	f3 0f 1e fa          	endbr64 
   418f9:	55                   	push   %rbp
   418fa:	48 89 e5             	mov    %rsp,%rbp
   418fd:	48 83 ec 10          	sub    $0x10,%rsp
  log_printf("PM_DUMP %u ", ticks);
   41901:	8b 05 99 24 01 00    	mov    0x12499(%rip),%eax        # 53da0 <ticks>
   41907:	89 c6                	mov    %eax,%esi
   41909:	48 8d 05 98 2b 00 00 	lea    0x2b98(%rip),%rax        # 444a8 <memstate_colors+0xa8>
   41910:	48 89 c7             	mov    %rax,%rdi
   41913:	b8 00 00 00 00       	mov    $0x0,%eax
   41918:	e8 31 17 00 00       	call   4304e <log_printf>
  for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   4191d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   41924:	eb 4c                	jmp    41972 <memdump_physical+0x7d>
    uint8_t owner = pageinfo[pn].owner;
   41926:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41929:	48 98                	cltq   
   4192b:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   4192f:	48 8d 05 8a 24 01 00 	lea    0x1248a(%rip),%rax        # 53dc0 <pageinfo>
   41936:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   4193a:	88 45 fb             	mov    %al,-0x5(%rbp)
    log_printf("%u %u ", owner, pageinfo[pn].refcount);
   4193d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41940:	48 98                	cltq   
   41942:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   41946:	48 8d 05 74 24 01 00 	lea    0x12474(%rip),%rax        # 53dc1 <pageinfo+0x1>
   4194d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   41951:	0f be d0             	movsbl %al,%edx
   41954:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41958:	89 c6                	mov    %eax,%esi
   4195a:	48 8d 05 53 2b 00 00 	lea    0x2b53(%rip),%rax        # 444b4 <memstate_colors+0xb4>
   41961:	48 89 c7             	mov    %rax,%rdi
   41964:	b8 00 00 00 00       	mov    $0x0,%eax
   41969:	e8 e0 16 00 00       	call   4304e <log_printf>
  for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   4196e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41972:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   41979:	7e ab                	jle    41926 <memdump_physical+0x31>
  }
  log_printf("\n");
   4197b:	48 8d 05 39 2b 00 00 	lea    0x2b39(%rip),%rax        # 444bb <memstate_colors+0xbb>
   41982:	48 89 c7             	mov    %rax,%rdi
   41985:	b8 00 00 00 00       	mov    $0x0,%eax
   4198a:	e8 bf 16 00 00       	call   4304e <log_printf>
}
   4198f:	90                   	nop
   41990:	c9                   	leave  
   41991:	c3                   	ret    

0000000000041992 <memdump_virtual>:


// Helper for memdump_virtual_all

void memdump_virtual(x86_64_pagetable* pagetable, const char* name) {
   41992:	f3 0f 1e fa          	endbr64 
   41996:	55                   	push   %rbp
   41997:	48 89 e5             	mov    %rsp,%rbp
   4199a:	48 83 ec 40          	sub    $0x40,%rsp
   4199e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   419a2:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  log_printf("VM_DUMP %s %u ", name, ticks);
   419a6:	8b 15 f4 23 01 00    	mov    0x123f4(%rip),%edx        # 53da0 <ticks>
   419ac:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   419b0:	48 89 c6             	mov    %rax,%rsi
   419b3:	48 8d 05 03 2b 00 00 	lea    0x2b03(%rip),%rax        # 444bd <memstate_colors+0xbd>
   419ba:	48 89 c7             	mov    %rax,%rdi
   419bd:	b8 00 00 00 00       	mov    $0x0,%eax
   419c2:	e8 87 16 00 00       	call   4304e <log_printf>
  assert((uintptr_t)pagetable == PTE_ADDR(pagetable));
   419c7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   419cb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   419d1:	48 89 c2             	mov    %rax,%rdx
   419d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   419d8:	48 39 c2             	cmp    %rax,%rdx
   419db:	74 1e                	je     419fb <memdump_virtual+0x69>
   419dd:	48 8d 05 ec 2a 00 00 	lea    0x2aec(%rip),%rax        # 444d0 <memstate_colors+0xd0>
   419e4:	48 89 c2             	mov    %rax,%rdx
   419e7:	be de 02 00 00       	mov    $0x2de,%esi
   419ec:	48 8d 05 42 27 00 00 	lea    0x2742(%rip),%rax        # 44135 <console_clear+0x4f>
   419f3:	48 89 c7             	mov    %rax,%rdi
   419f6:	e8 7c 19 00 00       	call   43377 <assert_fail>
  for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   419fb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   41a02:	00 
   41a03:	e9 8b 00 00 00       	jmp    41a93 <memdump_virtual+0x101>
    vamapping vam = virtual_memory_lookup(pagetable, va);
   41a08:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
   41a0c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   41a10:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   41a14:	48 89 ce             	mov    %rcx,%rsi
   41a17:	48 89 c7             	mov    %rax,%rdi
   41a1a:	e8 17 0d 00 00       	call   42736 <virtual_memory_lookup>
    if (vam.pn < 0) {
   41a1f:	8b 45 d8             	mov    -0x28(%rbp),%eax
   41a22:	85 c0                	test   %eax,%eax
   41a24:	79 16                	jns    41a3c <memdump_virtual+0xaa>
      log_printf("0 0 0 ");
   41a26:	48 8d 05 cf 2a 00 00 	lea    0x2acf(%rip),%rax        # 444fc <memstate_colors+0xfc>
   41a2d:	48 89 c7             	mov    %rax,%rdi
   41a30:	b8 00 00 00 00       	mov    $0x0,%eax
   41a35:	e8 14 16 00 00       	call   4304e <log_printf>
   41a3a:	eb 4f                	jmp    41a8b <memdump_virtual+0xf9>
      continue;
    }

    uint8_t owner = pageinfo[vam.pn].owner;
   41a3c:	8b 45 d8             	mov    -0x28(%rbp),%eax
   41a3f:	48 98                	cltq   
   41a41:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   41a45:	48 8d 05 74 23 01 00 	lea    0x12374(%rip),%rax        # 53dc0 <pageinfo>
   41a4c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   41a50:	88 45 f7             	mov    %al,-0x9(%rbp)
    uint8_t refcount = pageinfo[vam.pn].refcount;
   41a53:	8b 45 d8             	mov    -0x28(%rbp),%eax
   41a56:	48 98                	cltq   
   41a58:	48 8d 14 00          	lea    (%rax,%rax,1),%rdx
   41a5c:	48 8d 05 5e 23 01 00 	lea    0x1235e(%rip),%rax        # 53dc1 <pageinfo+0x1>
   41a63:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   41a67:	88 45 f6             	mov    %al,-0xa(%rbp)
    log_printf("%u %u %u ", owner, refcount, vam.perm);
   41a6a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
   41a6d:	0f b6 55 f6          	movzbl -0xa(%rbp),%edx
   41a71:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   41a75:	89 c6                	mov    %eax,%esi
   41a77:	48 8d 05 85 2a 00 00 	lea    0x2a85(%rip),%rax        # 44503 <memstate_colors+0x103>
   41a7e:	48 89 c7             	mov    %rax,%rdi
   41a81:	b8 00 00 00 00       	mov    $0x0,%eax
   41a86:	e8 c3 15 00 00       	call   4304e <log_printf>
  for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   41a8b:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   41a92:	00 
   41a93:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   41a9a:	00 
   41a9b:	0f 86 67 ff ff ff    	jbe    41a08 <memdump_virtual+0x76>
  }
  log_printf("\n");
   41aa1:	48 8d 05 13 2a 00 00 	lea    0x2a13(%rip),%rax        # 444bb <memstate_colors+0xbb>
   41aa8:	48 89 c7             	mov    %rax,%rdi
   41aab:	b8 00 00 00 00       	mov    $0x0,%eax
   41ab0:	e8 99 15 00 00       	call   4304e <log_printf>
}
   41ab5:	90                   	nop
   41ab6:	c9                   	leave  
   41ab7:	c3                   	ret    

0000000000041ab8 <memdump_virtual_all>:


// Dumps to the log file same information as memshow_virtual_animate

void memdump_virtual_all() {
   41ab8:	f3 0f 1e fa          	endbr64 
   41abc:	55                   	push   %rbp
   41abd:	48 89 e5             	mov    %rsp,%rbp
   41ac0:	48 83 ec 10          	sub    $0x10,%rsp
  for (uint32_t i = 0; i < NPROC; ++i) {
   41ac4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   41acb:	e9 8a 00 00 00       	jmp    41b5a <memdump_virtual_all+0xa2>
    if (processes[i].p_state != P_FREE) {
   41ad0:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41ad3:	48 89 d0             	mov    %rdx,%rax
   41ad6:	48 01 c0             	add    %rax,%rax
   41ad9:	48 01 d0             	add    %rdx,%rax
   41adc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41ae3:	00 
   41ae4:	48 01 d0             	add    %rdx,%rax
   41ae7:	48 c1 e0 03          	shl    $0x3,%rax
   41aeb:	48 89 c2             	mov    %rax,%rdx
   41aee:	48 8d 05 f3 15 01 00 	lea    0x115f3(%rip),%rax        # 530e8 <processes+0xc8>
   41af5:	8b 04 02             	mov    (%rdx,%rax,1),%eax
   41af8:	85 c0                	test   %eax,%eax
   41afa:	74 5a                	je     41b56 <memdump_virtual_all+0x9e>
      char s[4];
      snprintf(s, 4, "%d ", i);
   41afc:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41aff:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
   41b03:	89 d1                	mov    %edx,%ecx
   41b05:	48 8d 15 98 29 00 00 	lea    0x2998(%rip),%rdx        # 444a4 <memstate_colors+0xa4>
   41b0c:	be 04 00 00 00       	mov    $0x4,%esi
   41b11:	48 89 c7             	mov    %rax,%rdi
   41b14:	b8 00 00 00 00       	mov    $0x0,%eax
   41b19:	e8 8e 25 00 00       	call   440ac <snprintf>
      memdump_virtual(processes[i].p_pagetable, s);
   41b1e:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41b21:	48 89 d0             	mov    %rdx,%rax
   41b24:	48 01 c0             	add    %rax,%rax
   41b27:	48 01 d0             	add    %rdx,%rax
   41b2a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41b31:	00 
   41b32:	48 01 d0             	add    %rdx,%rax
   41b35:	48 c1 e0 03          	shl    $0x3,%rax
   41b39:	48 89 c2             	mov    %rax,%rdx
   41b3c:	48 8d 05 ad 15 01 00 	lea    0x115ad(%rip),%rax        # 530f0 <processes+0xd0>
   41b43:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
   41b47:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
   41b4b:	48 89 d6             	mov    %rdx,%rsi
   41b4e:	48 89 c7             	mov    %rax,%rdi
   41b51:	e8 3c fe ff ff       	call   41992 <memdump_virtual>
  for (uint32_t i = 0; i < NPROC; ++i) {
   41b56:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41b5a:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   41b5e:	0f 86 6c ff ff ff    	jbe    41ad0 <memdump_virtual_all+0x18>
    }
  }
}
   41b64:	90                   	nop
   41b65:	90                   	nop
   41b66:	c9                   	leave  
   41b67:	c3                   	ret    

0000000000041b68 <pageindex>:
static inline int pageindex(uintptr_t addr, int level) {
   41b68:	55                   	push   %rbp
   41b69:	48 89 e5             	mov    %rsp,%rbp
   41b6c:	48 83 ec 10          	sub    $0x10,%rsp
   41b70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41b74:	89 75 f4             	mov    %esi,-0xc(%rbp)
    assert(level >= 0 && level <= 3);
   41b77:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   41b7b:	78 06                	js     41b83 <pageindex+0x1b>
   41b7d:	83 7d f4 03          	cmpl   $0x3,-0xc(%rbp)
   41b81:	7e 1e                	jle    41ba1 <pageindex+0x39>
   41b83:	48 8d 05 96 29 00 00 	lea    0x2996(%rip),%rax        # 44520 <memstate_colors+0x120>
   41b8a:	48 89 c2             	mov    %rax,%rdx
   41b8d:	be 1e 00 00 00       	mov    $0x1e,%esi
   41b92:	48 8d 05 a0 29 00 00 	lea    0x29a0(%rip),%rax        # 44539 <memstate_colors+0x139>
   41b99:	48 89 c7             	mov    %rax,%rdi
   41b9c:	e8 d6 17 00 00       	call   43377 <assert_fail>
    return (int) (addr >> (PAGEOFFBITS + (3 - level) * PAGEINDEXBITS)) & 0x1FF; // keep last 9 bits
   41ba1:	b8 03 00 00 00       	mov    $0x3,%eax
   41ba6:	2b 45 f4             	sub    -0xc(%rbp),%eax
   41ba9:	89 c2                	mov    %eax,%edx
   41bab:	89 d0                	mov    %edx,%eax
   41bad:	c1 e0 03             	shl    $0x3,%eax
   41bb0:	01 d0                	add    %edx,%eax
   41bb2:	83 c0 0c             	add    $0xc,%eax
   41bb5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   41bb9:	89 c1                	mov    %eax,%ecx
   41bbb:	48 d3 ea             	shr    %cl,%rdx
   41bbe:	48 89 d0             	mov    %rdx,%rax
   41bc1:	25 ff 01 00 00       	and    $0x1ff,%eax
}
   41bc6:	c9                   	leave  
   41bc7:	c3                   	ret    

0000000000041bc8 <hardware_init>:

static void segments_init(void);
static void interrupt_init(void);
static void virtual_memory_init(void);

void hardware_init(void) {
   41bc8:	f3 0f 1e fa          	endbr64 
   41bcc:	55                   	push   %rbp
   41bcd:	48 89 e5             	mov    %rsp,%rbp
    segments_init();
   41bd0:	e8 5f 01 00 00       	call   41d34 <segments_init>
    interrupt_init();
   41bd5:	e8 44 04 00 00       	call   4201e <interrupt_init>
    virtual_memory_init();
   41bda:	e8 22 06 00 00       	call   42201 <virtual_memory_init>
}
   41bdf:	90                   	nop
   41be0:	5d                   	pop    %rbp
   41be1:	c3                   	ret    

0000000000041be2 <set_app_segment>:
#define SEGSEL_TASKSTATE        0x28            // task state segment

// Segments
static uint64_t segments[7];

static void set_app_segment(uint64_t* segment, uint64_t type, int dpl) {
   41be2:	f3 0f 1e fa          	endbr64 
   41be6:	55                   	push   %rbp
   41be7:	48 89 e5             	mov    %rsp,%rbp
   41bea:	48 83 ec 18          	sub    $0x18,%rsp
   41bee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41bf2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41bf6:	89 55 ec             	mov    %edx,-0x14(%rbp)
    *segment = type
        | X86SEG_S                    // code/data segment
        | ((uint64_t) dpl << 45)
   41bf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41bfc:	48 98                	cltq   
   41bfe:	48 c1 e0 2d          	shl    $0x2d,%rax
   41c02:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | X86SEG_P;                   // segment present
   41c06:	48 ba 00 00 00 00 00 	movabs $0x900000000000,%rdx
   41c0d:	90 00 00 
   41c10:	48 09 c2             	or     %rax,%rdx
    *segment = type
   41c13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41c17:	48 89 10             	mov    %rdx,(%rax)
}
   41c1a:	90                   	nop
   41c1b:	c9                   	leave  
   41c1c:	c3                   	ret    

0000000000041c1d <set_sys_segment>:

static void set_sys_segment(uint64_t* segment, uint64_t type, int dpl,
                            uintptr_t addr, size_t size) {
   41c1d:	f3 0f 1e fa          	endbr64 
   41c21:	55                   	push   %rbp
   41c22:	48 89 e5             	mov    %rsp,%rbp
   41c25:	48 83 ec 28          	sub    $0x28,%rsp
   41c29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41c2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41c31:	89 55 ec             	mov    %edx,-0x14(%rbp)
   41c34:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
   41c38:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   41c3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41c40:	48 c1 e0 10          	shl    $0x10,%rax
   41c44:	48 89 c2             	mov    %rax,%rdx
   41c47:	48 b8 00 00 ff ff ff 	movabs $0xffffff0000,%rax
   41c4e:	00 00 00 
   41c51:	48 21 c2             	and    %rax,%rdx
        | ((addr & 0x00000000FF000000UL) << 32)
   41c54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41c58:	48 c1 e0 20          	shl    $0x20,%rax
   41c5c:	48 89 c1             	mov    %rax,%rcx
   41c5f:	48 b8 00 00 00 00 00 	movabs $0xff00000000000000,%rax
   41c66:	00 00 ff 
   41c69:	48 21 c8             	and    %rcx,%rax
   41c6c:	48 09 c2             	or     %rax,%rdx
        | ((size - 1) & 0x0FFFFUL)
   41c6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   41c73:	48 83 e8 01          	sub    $0x1,%rax
   41c77:	0f b7 c0             	movzwl %ax,%eax
        | (((size - 1) & 0xF0000UL) << 48)
   41c7a:	48 09 d0             	or     %rdx,%rax
        | type
   41c7d:	48 0b 45 f0          	or     -0x10(%rbp),%rax
   41c81:	48 89 c2             	mov    %rax,%rdx
        | ((uint64_t) dpl << 45)
   41c84:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41c87:	48 98                	cltq   
   41c89:	48 c1 e0 2d          	shl    $0x2d,%rax
   41c8d:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P;                   // segment present
   41c90:	48 b8 00 00 00 00 00 	movabs $0x800000000000,%rax
   41c97:	80 00 00 
   41c9a:	48 09 c2             	or     %rax,%rdx
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   41c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41ca1:	48 89 10             	mov    %rdx,(%rax)
    segment[1] = addr >> 32;
   41ca4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41ca8:	48 83 c0 08          	add    $0x8,%rax
   41cac:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   41cb0:	48 c1 ea 20          	shr    $0x20,%rdx
   41cb4:	48 89 10             	mov    %rdx,(%rax)
}
   41cb7:	90                   	nop
   41cb8:	c9                   	leave  
   41cb9:	c3                   	ret    

0000000000041cba <set_gate>:

// Processor state for taking an interrupt
static x86_64_taskstate kernel_task_descriptor;

static void set_gate(x86_64_gatedescriptor* gate, uint64_t type, int dpl,
                     uintptr_t function) {
   41cba:	f3 0f 1e fa          	endbr64 
   41cbe:	55                   	push   %rbp
   41cbf:	48 89 e5             	mov    %rsp,%rbp
   41cc2:	48 83 ec 20          	sub    $0x20,%rsp
   41cc6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41cca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41cce:	89 55 ec             	mov    %edx,-0x14(%rbp)
   41cd1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41cd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41cd9:	0f b7 c0             	movzwl %ax,%eax
        | (SEGSEL_KERN_CODE << 16)
        | type
   41cdc:	48 0b 45 f0          	or     -0x10(%rbp),%rax
   41ce0:	48 89 c2             	mov    %rax,%rdx
        | ((uint64_t) dpl << 45)
   41ce3:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41ce6:	48 98                	cltq   
   41ce8:	48 c1 e0 2d          	shl    $0x2d,%rax
   41cec:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P
        | ((function & 0x00000000FFFF0000UL) << 32);
   41cef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41cf3:	48 c1 e0 20          	shl    $0x20,%rax
   41cf7:	48 89 c1             	mov    %rax,%rcx
   41cfa:	48 b8 00 00 00 00 00 	movabs $0xffff000000000000,%rax
   41d01:	00 ff ff 
   41d04:	48 21 c8             	and    %rcx,%rax
   41d07:	48 09 c2             	or     %rax,%rdx
   41d0a:	48 b8 00 00 08 00 00 	movabs $0x800000080000,%rax
   41d11:	80 00 00 
   41d14:	48 09 c2             	or     %rax,%rdx
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41d17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41d1b:	48 89 10             	mov    %rdx,(%rax)
    gate->gd_high = function >> 32;
   41d1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41d22:	48 c1 e8 20          	shr    $0x20,%rax
   41d26:	48 89 c2             	mov    %rax,%rdx
   41d29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41d2d:	48 89 50 08          	mov    %rdx,0x8(%rax)
}
   41d31:	90                   	nop
   41d32:	c9                   	leave  
   41d33:	c3                   	ret    

0000000000041d34 <segments_init>:
extern void default_int_handler(void);
extern void gpf_int_handler(void);
extern void pagefault_int_handler(void);
extern void timer_int_handler(void);

void segments_init(void) {
   41d34:	f3 0f 1e fa          	endbr64 
   41d38:	55                   	push   %rbp
   41d39:	48 89 e5             	mov    %rsp,%rbp
   41d3c:	48 83 ec 40          	sub    $0x40,%rsp
    // Segments for kernel & user code & data
    // The privilege level, which can be 0 or 3, differentiates between
    // kernel and user code. (Data segments are unused in WeensyOS.)
    segments[0] = 0;
   41d40:	48 c7 05 d5 32 01 00 	movq   $0x0,0x132d5(%rip)        # 55020 <segments>
   41d47:	00 00 00 00 
    set_app_segment(&segments[SEGSEL_KERN_CODE >> 3], X86SEG_X | X86SEG_L, 0);
   41d4b:	ba 00 00 00 00       	mov    $0x0,%edx
   41d50:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   41d57:	08 20 00 
   41d5a:	48 89 c6             	mov    %rax,%rsi
   41d5d:	48 8d 05 c4 32 01 00 	lea    0x132c4(%rip),%rax        # 55028 <segments+0x8>
   41d64:	48 89 c7             	mov    %rax,%rdi
   41d67:	e8 76 fe ff ff       	call   41be2 <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_CODE >> 3], X86SEG_X | X86SEG_L, 3);
   41d6c:	ba 03 00 00 00       	mov    $0x3,%edx
   41d71:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   41d78:	08 20 00 
   41d7b:	48 89 c6             	mov    %rax,%rsi
   41d7e:	48 8d 05 ab 32 01 00 	lea    0x132ab(%rip),%rax        # 55030 <segments+0x10>
   41d85:	48 89 c7             	mov    %rax,%rdi
   41d88:	e8 55 fe ff ff       	call   41be2 <set_app_segment>
    set_app_segment(&segments[SEGSEL_KERN_DATA >> 3], X86SEG_W, 0);
   41d8d:	ba 00 00 00 00       	mov    $0x0,%edx
   41d92:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   41d99:	02 00 00 
   41d9c:	48 89 c6             	mov    %rax,%rsi
   41d9f:	48 8d 05 92 32 01 00 	lea    0x13292(%rip),%rax        # 55038 <segments+0x18>
   41da6:	48 89 c7             	mov    %rax,%rdi
   41da9:	e8 34 fe ff ff       	call   41be2 <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_DATA >> 3], X86SEG_W, 3);
   41dae:	ba 03 00 00 00       	mov    $0x3,%edx
   41db3:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   41dba:	02 00 00 
   41dbd:	48 89 c6             	mov    %rax,%rsi
   41dc0:	48 8d 05 79 32 01 00 	lea    0x13279(%rip),%rax        # 55040 <segments+0x20>
   41dc7:	48 89 c7             	mov    %rax,%rdi
   41dca:	e8 13 fe ff ff       	call   41be2 <set_app_segment>
    set_sys_segment(&segments[SEGSEL_TASKSTATE >> 3], X86SEG_TSS, 0,
   41dcf:	48 8d 05 8a 42 01 00 	lea    0x1428a(%rip),%rax        # 56060 <kernel_task_descriptor>
   41dd6:	41 b8 60 00 00 00    	mov    $0x60,%r8d
   41ddc:	48 89 c1             	mov    %rax,%rcx
   41ddf:	ba 00 00 00 00       	mov    $0x0,%edx
   41de4:	48 b8 00 00 00 00 00 	movabs $0x90000000000,%rax
   41deb:	09 00 00 
   41dee:	48 89 c6             	mov    %rax,%rsi
   41df1:	48 8d 05 50 32 01 00 	lea    0x13250(%rip),%rax        # 55048 <segments+0x28>
   41df8:	48 89 c7             	mov    %rax,%rdi
   41dfb:	e8 1d fe ff ff       	call   41c1d <set_sys_segment>
                    (uintptr_t) &kernel_task_descriptor,
                    sizeof(kernel_task_descriptor));

    x86_64_pseudodescriptor gdt;
    gdt.pseudod_limit = sizeof(segments) - 1;
   41e00:	66 c7 45 d6 37 00    	movw   $0x37,-0x2a(%rbp)
    gdt.pseudod_base = (uint64_t) segments;
   41e06:	48 8d 05 13 32 01 00 	lea    0x13213(%rip),%rax        # 55020 <segments>
   41e0d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

    // Kernel task descriptor lets us receive interrupts
    memset(&kernel_task_descriptor, 0, sizeof(kernel_task_descriptor));
   41e11:	ba 60 00 00 00       	mov    $0x60,%edx
   41e16:	be 00 00 00 00       	mov    $0x0,%esi
   41e1b:	48 8d 05 3e 42 01 00 	lea    0x1423e(%rip),%rax        # 56060 <kernel_task_descriptor>
   41e22:	48 89 c7             	mov    %rax,%rdi
   41e25:	e8 78 19 00 00       	call   437a2 <memset>
    kernel_task_descriptor.ts_rsp[0] = KERNEL_STACK_TOP;
   41e2a:	48 c7 05 2f 42 01 00 	movq   $0x80000,0x1422f(%rip)        # 56064 <kernel_task_descriptor+0x4>
   41e31:	00 00 08 00 

    // Interrupt handler; most interrupts are effectively ignored
    memset(interrupt_descriptors, 0, sizeof(interrupt_descriptors));
   41e35:	ba 00 10 00 00       	mov    $0x1000,%edx
   41e3a:	be 00 00 00 00       	mov    $0x0,%esi
   41e3f:	48 8d 05 1a 32 01 00 	lea    0x1321a(%rip),%rax        # 55060 <interrupt_descriptors>
   41e46:	48 89 c7             	mov    %rax,%rdi
   41e49:	e8 54 19 00 00       	call   437a2 <memset>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   41e4e:	c7 45 fc 10 00 00 00 	movl   $0x10,-0x4(%rbp)
   41e55:	eb 3c                	jmp    41e93 <segments_init+0x15f>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 0,
   41e57:	48 c7 c0 9c 00 04 00 	mov    $0x4009c,%rax
   41e5e:	48 89 c2             	mov    %rax,%rdx
   41e61:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41e64:	48 c1 e0 04          	shl    $0x4,%rax
   41e68:	48 89 c1             	mov    %rax,%rcx
   41e6b:	48 8d 05 ee 31 01 00 	lea    0x131ee(%rip),%rax        # 55060 <interrupt_descriptors>
   41e72:	48 01 c8             	add    %rcx,%rax
   41e75:	48 89 d1             	mov    %rdx,%rcx
   41e78:	ba 00 00 00 00       	mov    $0x0,%edx
   41e7d:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41e84:	0e 00 00 
   41e87:	48 89 c7             	mov    %rax,%rdi
   41e8a:	e8 2b fe ff ff       	call   41cba <set_gate>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   41e8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41e93:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
   41e9a:	76 bb                	jbe    41e57 <segments_init+0x123>
                 (uint64_t) default_int_handler);
    }

    // Timer interrupt
    set_gate(&interrupt_descriptors[INT_TIMER], X86GATE_INTERRUPT, 0,
   41e9c:	48 c7 c0 36 00 04 00 	mov    $0x40036,%rax
   41ea3:	48 89 c1             	mov    %rax,%rcx
   41ea6:	ba 00 00 00 00       	mov    $0x0,%edx
   41eab:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41eb2:	0e 00 00 
   41eb5:	48 89 c6             	mov    %rax,%rsi
   41eb8:	48 8d 05 a1 33 01 00 	lea    0x133a1(%rip),%rax        # 55260 <interrupt_descriptors+0x200>
   41ebf:	48 89 c7             	mov    %rax,%rdi
   41ec2:	e8 f3 fd ff ff       	call   41cba <set_gate>
             (uint64_t) timer_int_handler);

    // GPF and page fault
    set_gate(&interrupt_descriptors[INT_GPF], X86GATE_INTERRUPT, 0,
   41ec7:	48 c7 c0 2e 00 04 00 	mov    $0x4002e,%rax
   41ece:	48 89 c1             	mov    %rax,%rcx
   41ed1:	ba 00 00 00 00       	mov    $0x0,%edx
   41ed6:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41edd:	0e 00 00 
   41ee0:	48 89 c6             	mov    %rax,%rsi
   41ee3:	48 8d 05 46 32 01 00 	lea    0x13246(%rip),%rax        # 55130 <interrupt_descriptors+0xd0>
   41eea:	48 89 c7             	mov    %rax,%rdi
   41eed:	e8 c8 fd ff ff       	call   41cba <set_gate>
             (uint64_t) gpf_int_handler);
    set_gate(&interrupt_descriptors[INT_PAGEFAULT], X86GATE_INTERRUPT, 0,
   41ef2:	48 c7 c0 32 00 04 00 	mov    $0x40032,%rax
   41ef9:	48 89 c1             	mov    %rax,%rcx
   41efc:	ba 00 00 00 00       	mov    $0x0,%edx
   41f01:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41f08:	0e 00 00 
   41f0b:	48 89 c6             	mov    %rax,%rsi
   41f0e:	48 8d 05 2b 32 01 00 	lea    0x1322b(%rip),%rax        # 55140 <interrupt_descriptors+0xe0>
   41f15:	48 89 c7             	mov    %rax,%rdi
   41f18:	e8 9d fd ff ff       	call   41cba <set_gate>
             (uint64_t) pagefault_int_handler);

    // System calls get special handling.
    // Note that the last argument is '3'.  This means that unprivileged
    // (level-3) applications may generate these interrupts.
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   41f1d:	c7 45 f8 30 00 00 00 	movl   $0x30,-0x8(%rbp)
   41f24:	eb 50                	jmp    41f76 <segments_init+0x242>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
                 (uint64_t) sys_int_handlers[i - INT_SYS]);
   41f26:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41f29:	83 e8 30             	sub    $0x30,%eax
   41f2c:	89 c0                	mov    %eax,%eax
   41f2e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41f35:	00 
   41f36:	48 8d 05 aa e1 ff ff 	lea    -0x1e56(%rip),%rax        # 400e7 <sys_int_handlers>
   41f3d:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
   41f41:	48 89 c2             	mov    %rax,%rdx
   41f44:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41f47:	48 c1 e0 04          	shl    $0x4,%rax
   41f4b:	48 89 c1             	mov    %rax,%rcx
   41f4e:	48 8d 05 0b 31 01 00 	lea    0x1310b(%rip),%rax        # 55060 <interrupt_descriptors>
   41f55:	48 01 c8             	add    %rcx,%rax
   41f58:	48 89 d1             	mov    %rdx,%rcx
   41f5b:	ba 03 00 00 00       	mov    $0x3,%edx
   41f60:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41f67:	0e 00 00 
   41f6a:	48 89 c7             	mov    %rax,%rdi
   41f6d:	e8 48 fd ff ff       	call   41cba <set_gate>
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   41f72:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41f76:	83 7d f8 3f          	cmpl   $0x3f,-0x8(%rbp)
   41f7a:	76 aa                	jbe    41f26 <segments_init+0x1f2>
    }

    x86_64_pseudodescriptor idt;
    idt.pseudod_limit = sizeof(interrupt_descriptors) - 1;
   41f7c:	66 c7 45 cc ff 0f    	movw   $0xfff,-0x34(%rbp)
    idt.pseudod_base = (uint64_t) interrupt_descriptors;
   41f82:	48 8d 05 d7 30 01 00 	lea    0x130d7(%rip),%rax        # 55060 <interrupt_descriptors>
   41f89:	48 89 45 ce          	mov    %rax,-0x32(%rbp)

    // Reload segment pointers
    asm volatile("lgdt %0\n\t"
   41f8d:	b8 28 00 00 00       	mov    $0x28,%eax
   41f92:	0f 01 55 d6          	lgdt   -0x2a(%rbp)
   41f96:	0f 00 d8             	ltr    %ax
   41f99:	0f 01 5d cc          	lidt   -0x34(%rbp)
    asm volatile("movq %%cr0,%0" : "=r" (val));
   41f9d:	0f 20 c0             	mov    %cr0,%rax
   41fa0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    return val;
   41fa4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
                     "r" ((uint16_t) SEGSEL_TASKSTATE),
                     "m" (idt)
                 : "memory");

    // Set up control registers: check alignment
    uint32_t cr0 = rcr0();
   41fa8:	89 45 f4             	mov    %eax,-0xc(%rbp)
    cr0 |= CR0_PE | CR0_PG | CR0_WP | CR0_AM | CR0_MP | CR0_NE;
   41fab:	81 4d f4 23 00 05 80 	orl    $0x80050023,-0xc(%rbp)
   41fb2:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41fb5:	89 45 f0             	mov    %eax,-0x10(%rbp)
    uint64_t xval = val;
   41fb8:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41fbb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    asm volatile("movq %0,%%cr0" : : "r" (xval));
   41fbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41fc3:	0f 22 c0             	mov    %rax,%cr0
}
   41fc6:	90                   	nop
    lcr0(cr0);
}
   41fc7:	90                   	nop
   41fc8:	c9                   	leave  
   41fc9:	c3                   	ret    

0000000000041fca <interrupt_mask>:
#define TIMER_FREQ      1193182
#define TIMER_DIV(x)    ((TIMER_FREQ+(x)/2)/(x))

static uint16_t interrupts_enabled;

static void interrupt_mask(void) {
   41fca:	f3 0f 1e fa          	endbr64 
   41fce:	55                   	push   %rbp
   41fcf:	48 89 e5             	mov    %rsp,%rbp
   41fd2:	48 83 ec 20          	sub    $0x20,%rsp
    uint16_t masked = ~interrupts_enabled;
   41fd6:	0f b7 05 e3 40 01 00 	movzwl 0x140e3(%rip),%eax        # 560c0 <interrupts_enabled>
   41fdd:	f7 d0                	not    %eax
   41fdf:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
    outb(IO_PIC1+1, masked & 0xFF);
   41fe3:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   41fe7:	0f b6 c0             	movzbl %al,%eax
   41fea:	c7 45 f0 21 00 00 00 	movl   $0x21,-0x10(%rbp)
   41ff1:	88 45 ef             	mov    %al,-0x11(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ff4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   41ff8:	8b 55 f0             	mov    -0x10(%rbp),%edx
   41ffb:	ee                   	out    %al,(%dx)
}
   41ffc:	90                   	nop
    outb(IO_PIC2+1, (masked >> 8) & 0xFF);
   41ffd:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   42001:	66 c1 e8 08          	shr    $0x8,%ax
   42005:	0f b6 c0             	movzbl %al,%eax
   42008:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%rbp)
   4200f:	88 45 f7             	mov    %al,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42012:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   42016:	8b 55 f8             	mov    -0x8(%rbp),%edx
   42019:	ee                   	out    %al,(%dx)
}
   4201a:	90                   	nop
}
   4201b:	90                   	nop
   4201c:	c9                   	leave  
   4201d:	c3                   	ret    

000000000004201e <interrupt_init>:

void interrupt_init(void) {
   4201e:	f3 0f 1e fa          	endbr64 
   42022:	55                   	push   %rbp
   42023:	48 89 e5             	mov    %rsp,%rbp
   42026:	48 83 ec 60          	sub    $0x60,%rsp
    // mask all interrupts
    interrupts_enabled = 0;
   4202a:	66 c7 05 8d 40 01 00 	movw   $0x0,0x1408d(%rip)        # 560c0 <interrupts_enabled>
   42031:	00 00 
    interrupt_mask();
   42033:	e8 92 ff ff ff       	call   41fca <interrupt_mask>
   42038:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%rbp)
   4203f:	c6 45 a3 11          	movb   $0x11,-0x5d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42043:	0f b6 45 a3          	movzbl -0x5d(%rbp),%eax
   42047:	8b 55 a4             	mov    -0x5c(%rbp),%edx
   4204a:	ee                   	out    %al,(%dx)
}
   4204b:	90                   	nop
   4204c:	c7 45 ac 21 00 00 00 	movl   $0x21,-0x54(%rbp)
   42053:	c6 45 ab 20          	movb   $0x20,-0x55(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42057:	0f b6 45 ab          	movzbl -0x55(%rbp),%eax
   4205b:	8b 55 ac             	mov    -0x54(%rbp),%edx
   4205e:	ee                   	out    %al,(%dx)
}
   4205f:	90                   	nop
   42060:	c7 45 b4 21 00 00 00 	movl   $0x21,-0x4c(%rbp)
   42067:	c6 45 b3 04          	movb   $0x4,-0x4d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4206b:	0f b6 45 b3          	movzbl -0x4d(%rbp),%eax
   4206f:	8b 55 b4             	mov    -0x4c(%rbp),%edx
   42072:	ee                   	out    %al,(%dx)
}
   42073:	90                   	nop
   42074:	c7 45 bc 21 00 00 00 	movl   $0x21,-0x44(%rbp)
   4207b:	c6 45 bb 03          	movb   $0x3,-0x45(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4207f:	0f b6 45 bb          	movzbl -0x45(%rbp),%eax
   42083:	8b 55 bc             	mov    -0x44(%rbp),%edx
   42086:	ee                   	out    %al,(%dx)
}
   42087:	90                   	nop
   42088:	c7 45 c4 a0 00 00 00 	movl   $0xa0,-0x3c(%rbp)
   4208f:	c6 45 c3 11          	movb   $0x11,-0x3d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42093:	0f b6 45 c3          	movzbl -0x3d(%rbp),%eax
   42097:	8b 55 c4             	mov    -0x3c(%rbp),%edx
   4209a:	ee                   	out    %al,(%dx)
}
   4209b:	90                   	nop
   4209c:	c7 45 cc a1 00 00 00 	movl   $0xa1,-0x34(%rbp)
   420a3:	c6 45 cb 28          	movb   $0x28,-0x35(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420a7:	0f b6 45 cb          	movzbl -0x35(%rbp),%eax
   420ab:	8b 55 cc             	mov    -0x34(%rbp),%edx
   420ae:	ee                   	out    %al,(%dx)
}
   420af:	90                   	nop
   420b0:	c7 45 d4 a1 00 00 00 	movl   $0xa1,-0x2c(%rbp)
   420b7:	c6 45 d3 02          	movb   $0x2,-0x2d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420bb:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
   420bf:	8b 55 d4             	mov    -0x2c(%rbp),%edx
   420c2:	ee                   	out    %al,(%dx)
}
   420c3:	90                   	nop
   420c4:	c7 45 dc a1 00 00 00 	movl   $0xa1,-0x24(%rbp)
   420cb:	c6 45 db 01          	movb   $0x1,-0x25(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420cf:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
   420d3:	8b 55 dc             	mov    -0x24(%rbp),%edx
   420d6:	ee                   	out    %al,(%dx)
}
   420d7:	90                   	nop
   420d8:	c7 45 e4 20 00 00 00 	movl   $0x20,-0x1c(%rbp)
   420df:	c6 45 e3 68          	movb   $0x68,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420e3:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   420e7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   420ea:	ee                   	out    %al,(%dx)
}
   420eb:	90                   	nop
   420ec:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%rbp)
   420f3:	c6 45 eb 0a          	movb   $0xa,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420f7:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   420fb:	8b 55 ec             	mov    -0x14(%rbp),%edx
   420fe:	ee                   	out    %al,(%dx)
}
   420ff:	90                   	nop
   42100:	c7 45 f4 a0 00 00 00 	movl   $0xa0,-0xc(%rbp)
   42107:	c6 45 f3 68          	movb   $0x68,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4210b:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   4210f:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42112:	ee                   	out    %al,(%dx)
}
   42113:	90                   	nop
   42114:	c7 45 fc a0 00 00 00 	movl   $0xa0,-0x4(%rbp)
   4211b:	c6 45 fb 0a          	movb   $0xa,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4211f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42123:	8b 55 fc             	mov    -0x4(%rbp),%edx
   42126:	ee                   	out    %al,(%dx)
}
   42127:	90                   	nop

    outb(IO_PIC2, 0x68);               /* OCW3 */
    outb(IO_PIC2, 0x0a);               /* OCW3 */

    // re-disable interrupts
    interrupt_mask();
   42128:	e8 9d fe ff ff       	call   41fca <interrupt_mask>
}
   4212d:	90                   	nop
   4212e:	c9                   	leave  
   4212f:	c3                   	ret    

0000000000042130 <timer_init>:

// timer_init(rate)
//    Set the timer interrupt to fire `rate` times a second. Disables the
//    timer interrupt if `rate <= 0`.

void timer_init(int rate) {
   42130:	f3 0f 1e fa          	endbr64 
   42134:	55                   	push   %rbp
   42135:	48 89 e5             	mov    %rsp,%rbp
   42138:	48 83 ec 28          	sub    $0x28,%rsp
   4213c:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (rate > 0) {
   4213f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   42143:	0f 8e 9f 00 00 00    	jle    421e8 <timer_init+0xb8>
   42149:	c7 45 ec 43 00 00 00 	movl   $0x43,-0x14(%rbp)
   42150:	c6 45 eb 34          	movb   $0x34,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42154:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   42158:	8b 55 ec             	mov    -0x14(%rbp),%edx
   4215b:	ee                   	out    %al,(%dx)
}
   4215c:	90                   	nop
        outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
        outb(IO_TIMER1, TIMER_DIV(rate) % 256);
   4215d:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42160:	89 c2                	mov    %eax,%edx
   42162:	c1 ea 1f             	shr    $0x1f,%edx
   42165:	01 d0                	add    %edx,%eax
   42167:	d1 f8                	sar    %eax
   42169:	05 de 34 12 00       	add    $0x1234de,%eax
   4216e:	99                   	cltd   
   4216f:	f7 7d dc             	idivl  -0x24(%rbp)
   42172:	89 c2                	mov    %eax,%edx
   42174:	89 d0                	mov    %edx,%eax
   42176:	c1 f8 1f             	sar    $0x1f,%eax
   42179:	c1 e8 18             	shr    $0x18,%eax
   4217c:	89 c1                	mov    %eax,%ecx
   4217e:	8d 04 0a             	lea    (%rdx,%rcx,1),%eax
   42181:	0f b6 c0             	movzbl %al,%eax
   42184:	29 c8                	sub    %ecx,%eax
   42186:	0f b6 c0             	movzbl %al,%eax
   42189:	c7 45 f4 40 00 00 00 	movl   $0x40,-0xc(%rbp)
   42190:	88 45 f3             	mov    %al,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42193:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   42197:	8b 55 f4             	mov    -0xc(%rbp),%edx
   4219a:	ee                   	out    %al,(%dx)
}
   4219b:	90                   	nop
        outb(IO_TIMER1, TIMER_DIV(rate) / 256);
   4219c:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4219f:	89 c2                	mov    %eax,%edx
   421a1:	c1 ea 1f             	shr    $0x1f,%edx
   421a4:	01 d0                	add    %edx,%eax
   421a6:	d1 f8                	sar    %eax
   421a8:	05 de 34 12 00       	add    $0x1234de,%eax
   421ad:	99                   	cltd   
   421ae:	f7 7d dc             	idivl  -0x24(%rbp)
   421b1:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   421b7:	85 c0                	test   %eax,%eax
   421b9:	0f 48 c2             	cmovs  %edx,%eax
   421bc:	c1 f8 08             	sar    $0x8,%eax
   421bf:	0f b6 c0             	movzbl %al,%eax
   421c2:	c7 45 fc 40 00 00 00 	movl   $0x40,-0x4(%rbp)
   421c9:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   421cc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   421d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
   421d3:	ee                   	out    %al,(%dx)
}
   421d4:	90                   	nop
        interrupts_enabled |= 1 << (INT_TIMER - INT_HARDWARE);
   421d5:	0f b7 05 e4 3e 01 00 	movzwl 0x13ee4(%rip),%eax        # 560c0 <interrupts_enabled>
   421dc:	83 c8 01             	or     $0x1,%eax
   421df:	66 89 05 da 3e 01 00 	mov    %ax,0x13eda(%rip)        # 560c0 <interrupts_enabled>
   421e6:	eb 11                	jmp    421f9 <timer_init+0xc9>
    } else {
        interrupts_enabled &= ~(1 << (INT_TIMER - INT_HARDWARE));
   421e8:	0f b7 05 d1 3e 01 00 	movzwl 0x13ed1(%rip),%eax        # 560c0 <interrupts_enabled>
   421ef:	83 e0 fe             	and    $0xfffffffe,%eax
   421f2:	66 89 05 c7 3e 01 00 	mov    %ax,0x13ec7(%rip)        # 560c0 <interrupts_enabled>
    }
    interrupt_mask();
   421f9:	e8 cc fd ff ff       	call   41fca <interrupt_mask>
}
   421fe:	90                   	nop
   421ff:	c9                   	leave  
   42200:	c3                   	ret    

0000000000042201 <virtual_memory_init>:
//    `kernel_pagetable`.

static x86_64_pagetable kernel_pagetables[5];
x86_64_pagetable* kernel_pagetable;

void virtual_memory_init(void) {
   42201:	f3 0f 1e fa          	endbr64 
   42205:	55                   	push   %rbp
   42206:	48 89 e5             	mov    %rsp,%rbp
   42209:	48 83 ec 10          	sub    $0x10,%rsp
    kernel_pagetable = &kernel_pagetables[0];
   4220d:	48 8d 05 ec 4d 01 00 	lea    0x14dec(%rip),%rax        # 57000 <kernel_pagetables>
   42214:	48 89 05 e5 2d 01 00 	mov    %rax,0x12de5(%rip)        # 55000 <kernel_pagetable>
    memset(kernel_pagetables, 0, sizeof(kernel_pagetables));
   4221b:	ba 00 50 00 00       	mov    $0x5000,%edx
   42220:	be 00 00 00 00       	mov    $0x0,%esi
   42225:	48 8d 05 d4 4d 01 00 	lea    0x14dd4(%rip),%rax        # 57000 <kernel_pagetables>
   4222c:	48 89 c7             	mov    %rax,%rdi
   4222f:	e8 6e 15 00 00       	call   437a2 <memset>
    kernel_pagetables[0].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   42234:	48 8d 05 c5 5d 01 00 	lea    0x15dc5(%rip),%rax        # 58000 <kernel_pagetables+0x1000>
   4223b:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[0].entry[0] =
   4223f:	48 89 05 ba 4d 01 00 	mov    %rax,0x14dba(%rip)        # 57000 <kernel_pagetables>
    kernel_pagetables[1].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   42246:	48 8d 05 b3 6d 01 00 	lea    0x16db3(%rip),%rax        # 59000 <kernel_pagetables+0x2000>
   4224d:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[1].entry[0] =
   42251:	48 89 05 a8 5d 01 00 	mov    %rax,0x15da8(%rip)        # 58000 <kernel_pagetables+0x1000>
    kernel_pagetables[2].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   42258:	48 8d 05 a1 7d 01 00 	lea    0x17da1(%rip),%rax        # 5a000 <kernel_pagetables+0x3000>
   4225f:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[0] =
   42263:	48 89 05 96 6d 01 00 	mov    %rax,0x16d96(%rip)        # 59000 <kernel_pagetables+0x2000>
    kernel_pagetables[2].entry[1] =
        (x86_64_pageentry_t) &kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   4226a:	48 8d 05 8f 8d 01 00 	lea    0x18d8f(%rip),%rax        # 5b000 <kernel_pagetables+0x4000>
   42271:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[1] =
   42275:	48 89 05 8c 6d 01 00 	mov    %rax,0x16d8c(%rip)        # 59008 <kernel_pagetables+0x2008>

    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0,
   4227c:	48 8b 05 7d 2d 01 00 	mov    0x12d7d(%rip),%rax        # 55000 <kernel_pagetable>
   42283:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   42289:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   4228f:	b9 00 00 20 00       	mov    $0x200000,%ecx
   42294:	ba 00 00 00 00       	mov    $0x0,%edx
   42299:	be 00 00 00 00       	mov    $0x0,%esi
   4229e:	48 89 c7             	mov    %rax,%rdi
   422a1:	e8 16 00 00 00       	call   422bc <virtual_memory_map>
                       MEMSIZE_PHYSICAL, PTE_P | PTE_W | PTE_U, NULL);

    lcr3((uintptr_t) kernel_pagetable);
   422a6:	48 8b 05 53 2d 01 00 	mov    0x12d53(%rip),%rax        # 55000 <kernel_pagetable>
   422ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
}

static inline void lcr3(uintptr_t val) {
    asm volatile("" : : : "memory");
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   422b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   422b5:	0f 22 d8             	mov    %rax,%cr3
}
   422b8:	90                   	nop
}
   422b9:	90                   	nop
   422ba:	c9                   	leave  
   422bb:	c3                   	ret    

00000000000422bc <virtual_memory_map>:
static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm, x86_64_pagetable* (*allocator)(void));

int virtual_memory_map(x86_64_pagetable* pagetable, uintptr_t va,
                       uintptr_t pa, size_t sz, int perm,
                       x86_64_pagetable* (*allocator)(void)) {
   422bc:	f3 0f 1e fa          	endbr64 
   422c0:	55                   	push   %rbp
   422c1:	48 89 e5             	mov    %rsp,%rbp
   422c4:	53                   	push   %rbx
   422c5:	48 83 ec 58          	sub    $0x58,%rsp
   422c9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   422cd:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   422d1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
   422d5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
   422d9:	44 89 45 ac          	mov    %r8d,-0x54(%rbp)
   422dd:	4c 89 4d a0          	mov    %r9,-0x60(%rbp)
    assert(va % PAGESIZE == 0); // virtual address is page-aligned
   422e1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   422e5:	25 ff 0f 00 00       	and    $0xfff,%eax
   422ea:	48 85 c0             	test   %rax,%rax
   422ed:	74 1e                	je     4230d <virtual_memory_map+0x51>
   422ef:	48 8d 05 4c 22 00 00 	lea    0x224c(%rip),%rax        # 44542 <memstate_colors+0x142>
   422f6:	48 89 c2             	mov    %rax,%rdx
   422f9:	be 3b 01 00 00       	mov    $0x13b,%esi
   422fe:	48 8d 05 50 22 00 00 	lea    0x2250(%rip),%rax        # 44555 <memstate_colors+0x155>
   42305:	48 89 c7             	mov    %rax,%rdi
   42308:	e8 6a 10 00 00       	call   43377 <assert_fail>
    assert(sz % PAGESIZE == 0); // size is a multiple of PAGESIZE
   4230d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42311:	25 ff 0f 00 00       	and    $0xfff,%eax
   42316:	48 85 c0             	test   %rax,%rax
   42319:	74 1e                	je     42339 <virtual_memory_map+0x7d>
   4231b:	48 8d 05 40 22 00 00 	lea    0x2240(%rip),%rax        # 44562 <memstate_colors+0x162>
   42322:	48 89 c2             	mov    %rax,%rdx
   42325:	be 3c 01 00 00       	mov    $0x13c,%esi
   4232a:	48 8d 05 24 22 00 00 	lea    0x2224(%rip),%rax        # 44555 <memstate_colors+0x155>
   42331:	48 89 c7             	mov    %rax,%rdi
   42334:	e8 3e 10 00 00       	call   43377 <assert_fail>
    assert(va + sz >= va || va + sz == 0); // va range does not wrap
   42339:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   4233d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42341:	48 01 d0             	add    %rdx,%rax
   42344:	48 39 45 c0          	cmp    %rax,-0x40(%rbp)
   42348:	76 2e                	jbe    42378 <virtual_memory_map+0xbc>
   4234a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   4234e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42352:	48 01 d0             	add    %rdx,%rax
   42355:	48 85 c0             	test   %rax,%rax
   42358:	74 1e                	je     42378 <virtual_memory_map+0xbc>
   4235a:	48 8d 05 14 22 00 00 	lea    0x2214(%rip),%rax        # 44575 <memstate_colors+0x175>
   42361:	48 89 c2             	mov    %rax,%rdx
   42364:	be 3d 01 00 00       	mov    $0x13d,%esi
   42369:	48 8d 05 e5 21 00 00 	lea    0x21e5(%rip),%rax        # 44555 <memstate_colors+0x155>
   42370:	48 89 c7             	mov    %rax,%rdi
   42373:	e8 ff 0f 00 00       	call   43377 <assert_fail>
    if (perm & PTE_P) {
   42378:	8b 45 ac             	mov    -0x54(%rbp),%eax
   4237b:	48 98                	cltq   
   4237d:	83 e0 01             	and    $0x1,%eax
   42380:	48 85 c0             	test   %rax,%rax
   42383:	0f 84 8c 00 00 00    	je     42415 <virtual_memory_map+0x159>
        assert(pa % PAGESIZE == 0); // physical addr is page-aligned
   42389:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   4238d:	25 ff 0f 00 00       	and    $0xfff,%eax
   42392:	48 85 c0             	test   %rax,%rax
   42395:	74 1e                	je     423b5 <virtual_memory_map+0xf9>
   42397:	48 8d 05 f5 21 00 00 	lea    0x21f5(%rip),%rax        # 44593 <memstate_colors+0x193>
   4239e:	48 89 c2             	mov    %rax,%rdx
   423a1:	be 3f 01 00 00       	mov    $0x13f,%esi
   423a6:	48 8d 05 a8 21 00 00 	lea    0x21a8(%rip),%rax        # 44555 <memstate_colors+0x155>
   423ad:	48 89 c7             	mov    %rax,%rdi
   423b0:	e8 c2 0f 00 00       	call   43377 <assert_fail>
        assert(pa + sz >= pa);      // physical address range does not wrap
   423b5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   423b9:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   423bd:	48 01 d0             	add    %rdx,%rax
   423c0:	48 39 45 b8          	cmp    %rax,-0x48(%rbp)
   423c4:	76 1e                	jbe    423e4 <virtual_memory_map+0x128>
   423c6:	48 8d 05 d9 21 00 00 	lea    0x21d9(%rip),%rax        # 445a6 <memstate_colors+0x1a6>
   423cd:	48 89 c2             	mov    %rax,%rdx
   423d0:	be 40 01 00 00       	mov    $0x140,%esi
   423d5:	48 8d 05 79 21 00 00 	lea    0x2179(%rip),%rax        # 44555 <memstate_colors+0x155>
   423dc:	48 89 c7             	mov    %rax,%rdi
   423df:	e8 93 0f 00 00       	call   43377 <assert_fail>
        assert(pa + sz <= MEMSIZE_PHYSICAL); // physical addresses exist
   423e4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   423e8:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   423ec:	48 01 d0             	add    %rdx,%rax
   423ef:	48 3d 00 00 20 00    	cmp    $0x200000,%rax
   423f5:	76 1e                	jbe    42415 <virtual_memory_map+0x159>
   423f7:	48 8d 05 b6 21 00 00 	lea    0x21b6(%rip),%rax        # 445b4 <memstate_colors+0x1b4>
   423fe:	48 89 c2             	mov    %rax,%rdx
   42401:	be 41 01 00 00       	mov    $0x141,%esi
   42406:	48 8d 05 48 21 00 00 	lea    0x2148(%rip),%rax        # 44555 <memstate_colors+0x155>
   4240d:	48 89 c7             	mov    %rax,%rdi
   42410:	e8 62 0f 00 00       	call   43377 <assert_fail>
    }
    assert(perm >= 0 && perm < 0x1000); // `perm` makes sense
   42415:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
   42419:	78 09                	js     42424 <virtual_memory_map+0x168>
   4241b:	81 7d ac ff 0f 00 00 	cmpl   $0xfff,-0x54(%rbp)
   42422:	7e 1e                	jle    42442 <virtual_memory_map+0x186>
   42424:	48 8d 05 a5 21 00 00 	lea    0x21a5(%rip),%rax        # 445d0 <memstate_colors+0x1d0>
   4242b:	48 89 c2             	mov    %rax,%rdx
   4242e:	be 43 01 00 00       	mov    $0x143,%esi
   42433:	48 8d 05 1b 21 00 00 	lea    0x211b(%rip),%rax        # 44555 <memstate_colors+0x155>
   4243a:	48 89 c7             	mov    %rax,%rdi
   4243d:	e8 35 0f 00 00       	call   43377 <assert_fail>
    assert((uintptr_t) pagetable % PAGESIZE == 0); // `pagetable` page-aligned
   42442:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42446:	25 ff 0f 00 00       	and    $0xfff,%eax
   4244b:	48 85 c0             	test   %rax,%rax
   4244e:	74 1e                	je     4246e <virtual_memory_map+0x1b2>
   42450:	48 8d 05 99 21 00 00 	lea    0x2199(%rip),%rax        # 445f0 <memstate_colors+0x1f0>
   42457:	48 89 c2             	mov    %rax,%rdx
   4245a:	be 44 01 00 00       	mov    $0x144,%esi
   4245f:	48 8d 05 ef 20 00 00 	lea    0x20ef(%rip),%rax        # 44555 <memstate_colors+0x155>
   42466:	48 89 c7             	mov    %rax,%rdi
   42469:	e8 09 0f 00 00       	call   43377 <assert_fail>

    int last_index123 = -1;
   4246e:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%rbp)
    x86_64_pagetable* l4pagetable = NULL;
   42475:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
   4247c:	00 
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   4247d:	e9 ce 00 00 00       	jmp    42550 <virtual_memory_map+0x294>
        int cur_index123 = (va >> (PAGEOFFBITS + PAGEINDEXBITS));
   42482:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42486:	48 c1 e8 15          	shr    $0x15,%rax
   4248a:	89 45 dc             	mov    %eax,-0x24(%rbp)
        if (cur_index123 != last_index123) { // need to look up L4 page table
   4248d:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42490:	3b 45 ec             	cmp    -0x14(%rbp),%eax
   42493:	74 21                	je     424b6 <virtual_memory_map+0x1fa>
            l4pagetable = lookup_l4pagetable(pagetable, va, perm, allocator);
   42495:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
   42499:	8b 55 ac             	mov    -0x54(%rbp),%edx
   4249c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
   424a0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   424a4:	48 89 c7             	mov    %rax,%rdi
   424a7:	e8 ba 00 00 00       	call   42566 <lookup_l4pagetable>
   424ac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            last_index123 = cur_index123;
   424b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
   424b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
        }
        if ((perm & PTE_P) && l4pagetable) {
   424b6:	8b 45 ac             	mov    -0x54(%rbp),%eax
   424b9:	48 98                	cltq   
   424bb:	83 e0 01             	and    $0x1,%eax
   424be:	48 85 c0             	test   %rax,%rax
   424c1:	74 34                	je     424f7 <virtual_memory_map+0x23b>
   424c3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   424c8:	74 2d                	je     424f7 <virtual_memory_map+0x23b>
            l4pagetable->entry[L4PAGEINDEX(va)] = pa | perm;
   424ca:	8b 45 ac             	mov    -0x54(%rbp),%eax
   424cd:	48 63 d8             	movslq %eax,%rbx
   424d0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   424d4:	be 03 00 00 00       	mov    $0x3,%esi
   424d9:	48 89 c7             	mov    %rax,%rdi
   424dc:	e8 87 f6 ff ff       	call   41b68 <pageindex>
   424e1:	89 c2                	mov    %eax,%edx
   424e3:	48 0b 5d b8          	or     -0x48(%rbp),%rbx
   424e7:	48 89 d9             	mov    %rbx,%rcx
   424ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   424ee:	48 63 d2             	movslq %edx,%rdx
   424f1:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   424f5:	eb 41                	jmp    42538 <virtual_memory_map+0x27c>
        } else if (l4pagetable) {
   424f7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   424fc:	74 26                	je     42524 <virtual_memory_map+0x268>
            l4pagetable->entry[L4PAGEINDEX(va)] = perm;
   424fe:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42502:	be 03 00 00 00       	mov    $0x3,%esi
   42507:	48 89 c7             	mov    %rax,%rdi
   4250a:	e8 59 f6 ff ff       	call   41b68 <pageindex>
   4250f:	89 c2                	mov    %eax,%edx
   42511:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42514:	48 63 c8             	movslq %eax,%rcx
   42517:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4251b:	48 63 d2             	movslq %edx,%rdx
   4251e:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   42522:	eb 14                	jmp    42538 <virtual_memory_map+0x27c>
        } else if (perm & PTE_P) {
   42524:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42527:	48 98                	cltq   
   42529:	83 e0 01             	and    $0x1,%eax
   4252c:	48 85 c0             	test   %rax,%rax
   4252f:	74 07                	je     42538 <virtual_memory_map+0x27c>
            return -1;
   42531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42536:	eb 28                	jmp    42560 <virtual_memory_map+0x2a4>
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   42538:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
   4253f:	00 
   42540:	48 81 45 b8 00 10 00 	addq   $0x1000,-0x48(%rbp)
   42547:	00 
   42548:	48 81 6d b0 00 10 00 	subq   $0x1000,-0x50(%rbp)
   4254f:	00 
   42550:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
   42555:	0f 85 27 ff ff ff    	jne    42482 <virtual_memory_map+0x1c6>
        }
    }
    return 0;
   4255b:	b8 00 00 00 00       	mov    $0x0,%eax
}
   42560:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   42564:	c9                   	leave  
   42565:	c3                   	ret    

0000000000042566 <lookup_l4pagetable>:
// This note is written by myself, not from the lab.
// lookup_l4pagetable(pagetable, va, perm, allocator)
//    This function is used to find the L4 page table for the virtual address `va`.
//    If the page table is not found, it will create all required page tables layer by layer.
static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm, x86_64_pagetable* (*allocator)(void)) {
   42566:	f3 0f 1e fa          	endbr64 
   4256a:	55                   	push   %rbp
   4256b:	48 89 e5             	mov    %rsp,%rbp
   4256e:	48 83 ec 40          	sub    $0x40,%rsp
   42572:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   42576:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   4257a:	89 55 cc             	mov    %edx,-0x34(%rbp)
   4257d:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    x86_64_pagetable* pt = pagetable;
   42581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42585:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 2; ++i) {
   42589:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   42590:	e9 91 01 00 00       	jmp    42726 <lookup_l4pagetable+0x1c0>
        x86_64_pageentry_t pe = pt->entry[PAGEINDEX(va, i)];
   42595:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42598:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   4259c:	89 d6                	mov    %edx,%esi
   4259e:	48 89 c7             	mov    %rax,%rdi
   425a1:	e8 c2 f5 ff ff       	call   41b68 <pageindex>
   425a6:	89 c2                	mov    %eax,%edx
   425a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   425ac:	48 63 d2             	movslq %edx,%rdx
   425af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   425b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        if (!(pe & PTE_P)) {
   425b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   425bb:	83 e0 01             	and    $0x1,%eax
   425be:	48 85 c0             	test   %rax,%rax
   425c1:	0f 85 af 00 00 00    	jne    42676 <lookup_l4pagetable+0x110>
            // allocate a new page table page if required
            if (!(perm & PTE_P) || !allocator) {
   425c7:	8b 45 cc             	mov    -0x34(%rbp),%eax
   425ca:	48 98                	cltq   
   425cc:	83 e0 01             	and    $0x1,%eax
   425cf:	48 85 c0             	test   %rax,%rax
   425d2:	74 07                	je     425db <lookup_l4pagetable+0x75>
   425d4:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
   425d9:	75 0a                	jne    425e5 <lookup_l4pagetable+0x7f>
                return NULL;
   425db:	b8 00 00 00 00       	mov    $0x0,%eax
   425e0:	e9 4f 01 00 00       	jmp    42734 <lookup_l4pagetable+0x1ce>
            }
            x86_64_pagetable* new_pt = allocator();
   425e5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   425e9:	ff d0                	call   *%rax
   425eb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            if (!new_pt) {
   425ef:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   425f4:	75 0a                	jne    42600 <lookup_l4pagetable+0x9a>
                return NULL;
   425f6:	b8 00 00 00 00       	mov    $0x0,%eax
   425fb:	e9 34 01 00 00       	jmp    42734 <lookup_l4pagetable+0x1ce>
            }
            assert((uintptr_t) new_pt % PAGESIZE == 0);
   42600:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42604:	25 ff 0f 00 00       	and    $0xfff,%eax
   42609:	48 85 c0             	test   %rax,%rax
   4260c:	74 1e                	je     4262c <lookup_l4pagetable+0xc6>
   4260e:	48 8d 05 03 20 00 00 	lea    0x2003(%rip),%rax        # 44618 <memstate_colors+0x218>
   42615:	48 89 c2             	mov    %rax,%rdx
   42618:	be 6b 01 00 00       	mov    $0x16b,%esi
   4261d:	48 8d 05 31 1f 00 00 	lea    0x1f31(%rip),%rax        # 44555 <memstate_colors+0x155>
   42624:	48 89 c7             	mov    %rax,%rdi
   42627:	e8 4b 0d 00 00       	call   43377 <assert_fail>
            pt->entry[PAGEINDEX(va, i)] = pe =
                PTE_ADDR(new_pt) | PTE_P | PTE_W | PTE_U;
   4262c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42630:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
            pt->entry[PAGEINDEX(va, i)] = pe =
   42636:	48 83 c8 07          	or     $0x7,%rax
   4263a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   4263e:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42641:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42645:	89 d6                	mov    %edx,%esi
   42647:	48 89 c7             	mov    %rax,%rdi
   4264a:	e8 19 f5 ff ff       	call   41b68 <pageindex>
   4264f:	89 c2                	mov    %eax,%edx
   42651:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42655:	48 63 d2             	movslq %edx,%rdx
   42658:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   4265c:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
            memset(new_pt, 0, PAGESIZE);
   42660:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42664:	ba 00 10 00 00       	mov    $0x1000,%edx
   42669:	be 00 00 00 00       	mov    $0x0,%esi
   4266e:	48 89 c7             	mov    %rax,%rdi
   42671:	e8 2c 11 00 00       	call   437a2 <memset>
        }

        // sanity-check page entry
        assert(PTE_ADDR(pe) < MEMSIZE_PHYSICAL); // at sensible address
   42676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4267a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42680:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   42686:	76 1e                	jbe    426a6 <lookup_l4pagetable+0x140>
   42688:	48 8d 05 b1 1f 00 00 	lea    0x1fb1(%rip),%rax        # 44640 <memstate_colors+0x240>
   4268f:	48 89 c2             	mov    %rax,%rdx
   42692:	be 72 01 00 00       	mov    $0x172,%esi
   42697:	48 8d 05 b7 1e 00 00 	lea    0x1eb7(%rip),%rax        # 44555 <memstate_colors+0x155>
   4269e:	48 89 c7             	mov    %rax,%rdi
   426a1:	e8 d1 0c 00 00       	call   43377 <assert_fail>
        if (perm & PTE_W) {       // if requester wants PTE_W,
   426a6:	8b 45 cc             	mov    -0x34(%rbp),%eax
   426a9:	48 98                	cltq   
   426ab:	83 e0 02             	and    $0x2,%eax
   426ae:	48 85 c0             	test   %rax,%rax
   426b1:	74 2a                	je     426dd <lookup_l4pagetable+0x177>
            assert(pe & PTE_W);   //   entry must allow PTE_W
   426b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   426b7:	83 e0 02             	and    $0x2,%eax
   426ba:	48 85 c0             	test   %rax,%rax
   426bd:	75 1e                	jne    426dd <lookup_l4pagetable+0x177>
   426bf:	48 8d 05 9a 1f 00 00 	lea    0x1f9a(%rip),%rax        # 44660 <memstate_colors+0x260>
   426c6:	48 89 c2             	mov    %rax,%rdx
   426c9:	be 74 01 00 00       	mov    $0x174,%esi
   426ce:	48 8d 05 80 1e 00 00 	lea    0x1e80(%rip),%rax        # 44555 <memstate_colors+0x155>
   426d5:	48 89 c7             	mov    %rax,%rdi
   426d8:	e8 9a 0c 00 00       	call   43377 <assert_fail>
        }
        if (perm & PTE_U) {       // if requester wants PTE_U,
   426dd:	8b 45 cc             	mov    -0x34(%rbp),%eax
   426e0:	48 98                	cltq   
   426e2:	83 e0 04             	and    $0x4,%eax
   426e5:	48 85 c0             	test   %rax,%rax
   426e8:	74 2a                	je     42714 <lookup_l4pagetable+0x1ae>
            assert(pe & PTE_U);   //   entry must allow PTE_U
   426ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   426ee:	83 e0 04             	and    $0x4,%eax
   426f1:	48 85 c0             	test   %rax,%rax
   426f4:	75 1e                	jne    42714 <lookup_l4pagetable+0x1ae>
   426f6:	48 8d 05 6e 1f 00 00 	lea    0x1f6e(%rip),%rax        # 4466b <memstate_colors+0x26b>
   426fd:	48 89 c2             	mov    %rax,%rdx
   42700:	be 77 01 00 00       	mov    $0x177,%esi
   42705:	48 8d 05 49 1e 00 00 	lea    0x1e49(%rip),%rax        # 44555 <memstate_colors+0x155>
   4270c:	48 89 c7             	mov    %rax,%rdi
   4270f:	e8 63 0c 00 00       	call   43377 <assert_fail>
        }

        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   42714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42718:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   4271e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 2; ++i) {
   42722:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   42726:	83 7d f4 02          	cmpl   $0x2,-0xc(%rbp)
   4272a:	0f 8e 65 fe ff ff    	jle    42595 <lookup_l4pagetable+0x2f>
    }
    return pt;
   42730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   42734:	c9                   	leave  
   42735:	c3                   	ret    

0000000000042736 <virtual_memory_lookup>:

// virtual_memory_lookup(pagetable, va)
//    Returns information about the mapping of the virtual address `va` in
//    `pagetable`. The information is returned as a `vamapping` object.

vamapping virtual_memory_lookup(x86_64_pagetable* pagetable, uintptr_t va) {
   42736:	f3 0f 1e fa          	endbr64 
   4273a:	55                   	push   %rbp
   4273b:	48 89 e5             	mov    %rsp,%rbp
   4273e:	48 83 ec 50          	sub    $0x50,%rsp
   42742:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42746:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   4274a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
    x86_64_pagetable* pt = pagetable;
   4274e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42752:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    x86_64_pageentry_t pe = 0;
   42756:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
   4275d:	00 
    uint8_t perms = PTE_W | PTE_U | PTE_P;
   4275e:	c6 45 ef 07          	movb   $0x7,-0x11(%rbp)

    for (int i = 0; i <= 3 && (perms & PTE_P); ++i) {
   42762:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
   42769:	eb 3b                	jmp    427a6 <virtual_memory_lookup+0x70>
        pe = pt->entry[PAGEINDEX(va,i)];
   4276b:	8b 55 e8             	mov    -0x18(%rbp),%edx
   4276e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42772:	89 d6                	mov    %edx,%esi
   42774:	48 89 c7             	mov    %rax,%rdi
   42777:	e8 ec f3 ff ff       	call   41b68 <pageindex>
   4277c:	89 c2                	mov    %eax,%edx
   4277e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42782:	48 63 d2             	movslq %edx,%rdx
   42785:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   42789:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
        perms &= PTE_FLAGS(pe);
   4278d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42791:	20 45 ef             	and    %al,-0x11(%rbp)
        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   42794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42798:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   4279e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 3 && (perms & PTE_P); ++i) {
   427a2:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
   427a6:	83 7d e8 03          	cmpl   $0x3,-0x18(%rbp)
   427aa:	7f 0c                	jg     427b8 <virtual_memory_lookup+0x82>
   427ac:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   427b0:	83 e0 01             	and    $0x1,%eax
   427b3:	48 85 c0             	test   %rax,%rax
   427b6:	75 b3                	jne    4276b <virtual_memory_lookup+0x35>
    }
    vamapping vam = { -1, (uintptr_t) -1, 0 };
   427b8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%rbp)
   427bf:	48 c7 45 d8 ff ff ff 	movq   $0xffffffffffffffff,-0x28(%rbp)
   427c6:	ff 
   427c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
    if (perms & PTE_P) {
   427ce:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   427d2:	83 e0 01             	and    $0x1,%eax
   427d5:	48 85 c0             	test   %rax,%rax
   427d8:	74 2f                	je     42809 <virtual_memory_lookup+0xd3>
        vam.pn = PAGENUMBER(pe);
   427da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   427de:	48 c1 e8 0c          	shr    $0xc,%rax
   427e2:	89 45 d0             	mov    %eax,-0x30(%rbp)
        vam.pa = PTE_ADDR(pe) + PAGEOFFSET(va);
   427e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   427e9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   427ef:	48 89 c2             	mov    %rax,%rdx
   427f2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   427f6:	25 ff 0f 00 00       	and    $0xfff,%eax
   427fb:	48 09 d0             	or     %rdx,%rax
   427fe:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
        vam.perm = perms;
   42802:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   42806:	89 45 e0             	mov    %eax,-0x20(%rbp)
    }
    return vam;
   42809:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4280d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   42811:	48 89 10             	mov    %rdx,(%rax)
   42814:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   42818:	48 89 50 08          	mov    %rdx,0x8(%rax)
   4281c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   42820:	48 89 50 10          	mov    %rdx,0x10(%rax)
}
   42824:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42828:	c9                   	leave  
   42829:	c3                   	ret    

000000000004282a <set_pagetable>:
// set_pagetable
//    Change page directory. lcr3() is the hardware instruction;
//    set_pagetable() additionally checks that important kernel procedures are
//    mappable in `pagetable`, and calls panic() if they aren't.

void set_pagetable(x86_64_pagetable* pagetable) {
   4282a:	f3 0f 1e fa          	endbr64 
   4282e:	55                   	push   %rbp
   4282f:	48 89 e5             	mov    %rsp,%rbp
   42832:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   42836:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
    assert(PAGEOFFSET(pagetable) == 0); // must be page aligned
   4283a:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   4283e:	25 ff 0f 00 00       	and    $0xfff,%eax
   42843:	48 85 c0             	test   %rax,%rax
   42846:	74 1e                	je     42866 <set_pagetable+0x3c>
   42848:	48 8d 05 27 1e 00 00 	lea    0x1e27(%rip),%rax        # 44676 <memstate_colors+0x276>
   4284f:	48 89 c2             	mov    %rax,%rdx
   42852:	be 9e 01 00 00       	mov    $0x19e,%esi
   42857:	48 8d 05 f7 1c 00 00 	lea    0x1cf7(%rip),%rax        # 44555 <memstate_colors+0x155>
   4285e:	48 89 c7             	mov    %rax,%rdi
   42861:	e8 11 0b 00 00       	call   43377 <assert_fail>
    assert(virtual_memory_lookup(pagetable, (uintptr_t) default_int_handler).pa
   42866:	48 c7 c0 9c 00 04 00 	mov    $0x4009c,%rax
   4286d:	48 89 c2             	mov    %rax,%rdx
   42870:	48 8d 45 98          	lea    -0x68(%rbp),%rax
   42874:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42878:	48 89 ce             	mov    %rcx,%rsi
   4287b:	48 89 c7             	mov    %rax,%rdi
   4287e:	e8 b3 fe ff ff       	call   42736 <virtual_memory_lookup>
   42883:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   42887:	48 c7 c2 9c 00 04 00 	mov    $0x4009c,%rdx
   4288e:	48 39 d0             	cmp    %rdx,%rax
   42891:	74 1e                	je     428b1 <set_pagetable+0x87>
   42893:	48 8d 05 fe 1d 00 00 	lea    0x1dfe(%rip),%rax        # 44698 <memstate_colors+0x298>
   4289a:	48 89 c2             	mov    %rax,%rdx
   4289d:	be 9f 01 00 00       	mov    $0x19f,%esi
   428a2:	48 8d 05 ac 1c 00 00 	lea    0x1cac(%rip),%rax        # 44555 <memstate_colors+0x155>
   428a9:	48 89 c7             	mov    %rax,%rdi
   428ac:	e8 c6 0a 00 00       	call   43377 <assert_fail>
           == (uintptr_t) default_int_handler);
    assert(virtual_memory_lookup(kernel_pagetable, (uintptr_t) pagetable).pa
   428b1:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
   428b5:	48 8b 0d 44 27 01 00 	mov    0x12744(%rip),%rcx        # 55000 <kernel_pagetable>
   428bc:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   428c0:	48 89 ce             	mov    %rcx,%rsi
   428c3:	48 89 c7             	mov    %rax,%rdi
   428c6:	e8 6b fe ff ff       	call   42736 <virtual_memory_lookup>
   428cb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   428cf:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   428d3:	48 39 c2             	cmp    %rax,%rdx
   428d6:	74 1e                	je     428f6 <set_pagetable+0xcc>
   428d8:	48 8d 05 21 1e 00 00 	lea    0x1e21(%rip),%rax        # 44700 <memstate_colors+0x300>
   428df:	48 89 c2             	mov    %rax,%rdx
   428e2:	be a1 01 00 00       	mov    $0x1a1,%esi
   428e7:	48 8d 05 67 1c 00 00 	lea    0x1c67(%rip),%rax        # 44555 <memstate_colors+0x155>
   428ee:	48 89 c7             	mov    %rax,%rdi
   428f1:	e8 81 0a 00 00       	call   43377 <assert_fail>
           == (uintptr_t) pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) kernel_pagetable).pa
   428f6:	48 8b 05 03 27 01 00 	mov    0x12703(%rip),%rax        # 55000 <kernel_pagetable>
   428fd:	48 89 c2             	mov    %rax,%rdx
   42900:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
   42904:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42908:	48 89 ce             	mov    %rcx,%rsi
   4290b:	48 89 c7             	mov    %rax,%rdi
   4290e:	e8 23 fe ff ff       	call   42736 <virtual_memory_lookup>
   42913:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42917:	48 8b 15 e2 26 01 00 	mov    0x126e2(%rip),%rdx        # 55000 <kernel_pagetable>
   4291e:	48 39 d0             	cmp    %rdx,%rax
   42921:	74 1e                	je     42941 <set_pagetable+0x117>
   42923:	48 8d 05 36 1e 00 00 	lea    0x1e36(%rip),%rax        # 44760 <memstate_colors+0x360>
   4292a:	48 89 c2             	mov    %rax,%rdx
   4292d:	be a3 01 00 00       	mov    $0x1a3,%esi
   42932:	48 8d 05 1c 1c 00 00 	lea    0x1c1c(%rip),%rax        # 44555 <memstate_colors+0x155>
   42939:	48 89 c7             	mov    %rax,%rdi
   4293c:	e8 36 0a 00 00       	call   43377 <assert_fail>
           == (uintptr_t) kernel_pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) virtual_memory_map).pa
   42941:	48 8d 15 74 f9 ff ff 	lea    -0x68c(%rip),%rdx        # 422bc <virtual_memory_map>
   42948:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   4294c:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42950:	48 89 ce             	mov    %rcx,%rsi
   42953:	48 89 c7             	mov    %rax,%rdi
   42956:	e8 db fd ff ff       	call   42736 <virtual_memory_lookup>
   4295b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4295f:	48 8d 15 56 f9 ff ff 	lea    -0x6aa(%rip),%rdx        # 422bc <virtual_memory_map>
   42966:	48 39 d0             	cmp    %rdx,%rax
   42969:	74 1e                	je     42989 <set_pagetable+0x15f>
   4296b:	48 8d 05 56 1e 00 00 	lea    0x1e56(%rip),%rax        # 447c8 <memstate_colors+0x3c8>
   42972:	48 89 c2             	mov    %rax,%rdx
   42975:	be a5 01 00 00       	mov    $0x1a5,%esi
   4297a:	48 8d 05 d4 1b 00 00 	lea    0x1bd4(%rip),%rax        # 44555 <memstate_colors+0x155>
   42981:	48 89 c7             	mov    %rax,%rdi
   42984:	e8 ee 09 00 00       	call   43377 <assert_fail>
           == (uintptr_t) virtual_memory_map);
    lcr3((uintptr_t) pagetable);
   42989:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   4298d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   42991:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42995:	0f 22 d8             	mov    %rax,%cr3
}
   42998:	90                   	nop
}
   42999:	90                   	nop
   4299a:	c9                   	leave  
   4299b:	c3                   	ret    

000000000004299c <physical_memory_isreserved>:
//    Returns non-zero iff `pa` is a reserved physical address.

#define IOPHYSMEM       0x000A0000
#define EXTPHYSMEM      0x00100000

int physical_memory_isreserved(uintptr_t pa) {
   4299c:	f3 0f 1e fa          	endbr64 
   429a0:	55                   	push   %rbp
   429a1:	48 89 e5             	mov    %rsp,%rbp
   429a4:	48 83 ec 08          	sub    $0x8,%rsp
   429a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    return pa == 0 || (pa >= IOPHYSMEM && pa < EXTPHYSMEM);
   429ac:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   429b1:	74 14                	je     429c7 <physical_memory_isreserved+0x2b>
   429b3:	48 81 7d f8 ff ff 09 	cmpq   $0x9ffff,-0x8(%rbp)
   429ba:	00 
   429bb:	76 11                	jbe    429ce <physical_memory_isreserved+0x32>
   429bd:	48 81 7d f8 ff ff 0f 	cmpq   $0xfffff,-0x8(%rbp)
   429c4:	00 
   429c5:	77 07                	ja     429ce <physical_memory_isreserved+0x32>
   429c7:	b8 01 00 00 00       	mov    $0x1,%eax
   429cc:	eb 05                	jmp    429d3 <physical_memory_isreserved+0x37>
   429ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
   429d3:	c9                   	leave  
   429d4:	c3                   	ret    

00000000000429d5 <pci_make_configaddr>:


// pci_make_configaddr(bus, slot, func)
//    Construct a PCI configuration space address from parts.

static int pci_make_configaddr(int bus, int slot, int func) {
   429d5:	f3 0f 1e fa          	endbr64 
   429d9:	55                   	push   %rbp
   429da:	48 89 e5             	mov    %rsp,%rbp
   429dd:	48 83 ec 10          	sub    $0x10,%rsp
   429e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
   429e4:	89 75 f8             	mov    %esi,-0x8(%rbp)
   429e7:	89 55 f4             	mov    %edx,-0xc(%rbp)
    return (bus << 16) | (slot << 11) | (func << 8);
   429ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
   429ed:	c1 e0 10             	shl    $0x10,%eax
   429f0:	89 c2                	mov    %eax,%edx
   429f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
   429f5:	c1 e0 0b             	shl    $0xb,%eax
   429f8:	09 c2                	or     %eax,%edx
   429fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
   429fd:	c1 e0 08             	shl    $0x8,%eax
   42a00:	09 d0                	or     %edx,%eax
}
   42a02:	c9                   	leave  
   42a03:	c3                   	ret    

0000000000042a04 <pci_config_readl>:
//    Read a 32-bit word in PCI configuration space.

#define PCI_HOST_BRIDGE_CONFIG_ADDR 0xCF8
#define PCI_HOST_BRIDGE_CONFIG_DATA 0xCFC

static uint32_t pci_config_readl(int configaddr, int offset) {
   42a04:	f3 0f 1e fa          	endbr64 
   42a08:	55                   	push   %rbp
   42a09:	48 89 e5             	mov    %rsp,%rbp
   42a0c:	48 83 ec 18          	sub    $0x18,%rsp
   42a10:	89 7d ec             	mov    %edi,-0x14(%rbp)
   42a13:	89 75 e8             	mov    %esi,-0x18(%rbp)
    outl(PCI_HOST_BRIDGE_CONFIG_ADDR, 0x80000000 | configaddr | offset);
   42a16:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42a19:	8b 45 e8             	mov    -0x18(%rbp),%eax
   42a1c:	09 d0                	or     %edx,%eax
   42a1e:	0d 00 00 00 80       	or     $0x80000000,%eax
   42a23:	c7 45 f4 f8 0c 00 00 	movl   $0xcf8,-0xc(%rbp)
   42a2a:	89 45 f0             	mov    %eax,-0x10(%rbp)
    asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
   42a2d:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42a30:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42a33:	ef                   	out    %eax,(%dx)
}
   42a34:	90                   	nop
   42a35:	c7 45 fc fc 0c 00 00 	movl   $0xcfc,-0x4(%rbp)
    asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
   42a3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42a3f:	89 c2                	mov    %eax,%edx
   42a41:	ed                   	in     (%dx),%eax
   42a42:	89 45 f8             	mov    %eax,-0x8(%rbp)
    return data;
   42a45:	8b 45 f8             	mov    -0x8(%rbp),%eax
    return inl(PCI_HOST_BRIDGE_CONFIG_DATA);
}
   42a48:	c9                   	leave  
   42a49:	c3                   	ret    

0000000000042a4a <pci_find_device>:

// pci_find_device
//    Search for a PCI device matching `vendor` and `device`. Return
//    the config base address or -1 if no device was found.

static int pci_find_device(int vendor, int device) {
   42a4a:	f3 0f 1e fa          	endbr64 
   42a4e:	55                   	push   %rbp
   42a4f:	48 89 e5             	mov    %rsp,%rbp
   42a52:	48 83 ec 28          	sub    $0x28,%rsp
   42a56:	89 7d dc             	mov    %edi,-0x24(%rbp)
   42a59:	89 75 d8             	mov    %esi,-0x28(%rbp)
    for (int bus = 0; bus != 256; ++bus) {
   42a5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42a63:	eb 73                	jmp    42ad8 <pci_find_device+0x8e>
        for (int slot = 0; slot != 32; ++slot) {
   42a65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   42a6c:	eb 60                	jmp    42ace <pci_find_device+0x84>
            for (int func = 0; func != 8; ++func) {
   42a6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   42a75:	eb 4a                	jmp    42ac1 <pci_find_device+0x77>
                int configaddr = pci_make_configaddr(bus, slot, func);
   42a77:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42a7a:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   42a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42a80:	89 ce                	mov    %ecx,%esi
   42a82:	89 c7                	mov    %eax,%edi
   42a84:	e8 4c ff ff ff       	call   429d5 <pci_make_configaddr>
   42a89:	89 45 f0             	mov    %eax,-0x10(%rbp)
                uint32_t vendor_device = pci_config_readl(configaddr, 0);
   42a8c:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42a8f:	be 00 00 00 00       	mov    $0x0,%esi
   42a94:	89 c7                	mov    %eax,%edi
   42a96:	e8 69 ff ff ff       	call   42a04 <pci_config_readl>
   42a9b:	89 45 ec             	mov    %eax,-0x14(%rbp)
                if (vendor_device == (uint32_t) (vendor | (device << 16))) {
   42a9e:	8b 45 d8             	mov    -0x28(%rbp),%eax
   42aa1:	c1 e0 10             	shl    $0x10,%eax
   42aa4:	0b 45 dc             	or     -0x24(%rbp),%eax
   42aa7:	39 45 ec             	cmp    %eax,-0x14(%rbp)
   42aaa:	75 05                	jne    42ab1 <pci_find_device+0x67>
                    return configaddr;
   42aac:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42aaf:	eb 35                	jmp    42ae6 <pci_find_device+0x9c>
                } else if (vendor_device == (uint32_t) -1 && func == 0) {
   42ab1:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%rbp)
   42ab5:	75 06                	jne    42abd <pci_find_device+0x73>
   42ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   42abb:	74 0c                	je     42ac9 <pci_find_device+0x7f>
            for (int func = 0; func != 8; ++func) {
   42abd:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   42ac1:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
   42ac5:	75 b0                	jne    42a77 <pci_find_device+0x2d>
   42ac7:	eb 01                	jmp    42aca <pci_find_device+0x80>
                    break;
   42ac9:	90                   	nop
        for (int slot = 0; slot != 32; ++slot) {
   42aca:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   42ace:	83 7d f8 20          	cmpl   $0x20,-0x8(%rbp)
   42ad2:	75 9a                	jne    42a6e <pci_find_device+0x24>
    for (int bus = 0; bus != 256; ++bus) {
   42ad4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   42ad8:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
   42adf:	75 84                	jne    42a65 <pci_find_device+0x1b>
                }
            }
        }
    }
    return -1;
   42ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
   42ae6:	c9                   	leave  
   42ae7:	c3                   	ret    

0000000000042ae8 <poweroff>:
//    that speaks ACPI; QEMU emulates a PIIX4 Power Management Controller.

#define PCI_VENDOR_ID_INTEL     0x8086
#define PCI_DEVICE_ID_PIIX4     0x7113

void poweroff(void) {
   42ae8:	f3 0f 1e fa          	endbr64 
   42aec:	55                   	push   %rbp
   42aed:	48 89 e5             	mov    %rsp,%rbp
   42af0:	48 83 ec 10          	sub    $0x10,%rsp
    int configaddr = pci_find_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PIIX4);
   42af4:	be 13 71 00 00       	mov    $0x7113,%esi
   42af9:	bf 86 80 00 00       	mov    $0x8086,%edi
   42afe:	e8 47 ff ff ff       	call   42a4a <pci_find_device>
   42b03:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if (configaddr >= 0) {
   42b06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   42b0a:	78 30                	js     42b3c <poweroff+0x54>
        // Read I/O base register from controller's PCI configuration space.
        int pm_io_base = pci_config_readl(configaddr, 0x40) & 0xFFC0;
   42b0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42b0f:	be 40 00 00 00       	mov    $0x40,%esi
   42b14:	89 c7                	mov    %eax,%edi
   42b16:	e8 e9 fe ff ff       	call   42a04 <pci_config_readl>
   42b1b:	25 c0 ff 00 00       	and    $0xffc0,%eax
   42b20:	89 45 f8             	mov    %eax,-0x8(%rbp)
        // Write `suspend enable` to the power management control register.
        outw(pm_io_base + 4, 0x2000);
   42b23:	8b 45 f8             	mov    -0x8(%rbp),%eax
   42b26:	83 c0 04             	add    $0x4,%eax
   42b29:	89 45 f4             	mov    %eax,-0xc(%rbp)
   42b2c:	66 c7 45 f2 00 20    	movw   $0x2000,-0xe(%rbp)
    asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
   42b32:	0f b7 45 f2          	movzwl -0xe(%rbp),%eax
   42b36:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42b39:	66 ef                	out    %ax,(%dx)
}
   42b3b:	90                   	nop
    }
    // No PIIX4; spin.
    console_printf(CPOS(24, 0), 0xC000, "Cannot power off!\n");
   42b3c:	48 8d 05 eb 1c 00 00 	lea    0x1ceb(%rip),%rax        # 4482e <memstate_colors+0x42e>
   42b43:	48 89 c2             	mov    %rax,%rdx
   42b46:	be 00 c0 00 00       	mov    $0xc000,%esi
   42b4b:	bf 80 07 00 00       	mov    $0x780,%edi
   42b50:	b8 00 00 00 00       	mov    $0x0,%eax
   42b55:	e8 c9 14 00 00       	call   44023 <console_printf>
 spinloop: goto spinloop;
   42b5a:	eb fe                	jmp    42b5a <poweroff+0x72>

0000000000042b5c <reboot>:


// reboot
//    Reboot the virtual machine.

void reboot(void) {
   42b5c:	f3 0f 1e fa          	endbr64 
   42b60:	55                   	push   %rbp
   42b61:	48 89 e5             	mov    %rsp,%rbp
   42b64:	48 83 ec 10          	sub    $0x10,%rsp
   42b68:	c7 45 fc 92 00 00 00 	movl   $0x92,-0x4(%rbp)
   42b6f:	c6 45 fb 03          	movb   $0x3,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42b73:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42b77:	8b 55 fc             	mov    -0x4(%rbp),%edx
   42b7a:	ee                   	out    %al,(%dx)
}
   42b7b:	90                   	nop
    outb(0x92, 3);
 spinloop: goto spinloop;
   42b7c:	eb fe                	jmp    42b7c <reboot+0x20>

0000000000042b7e <process_init>:


// process_init(p, flags)
//    Initialize special-purpose registers for process `p`.

void process_init(proc* p, int flags) {
   42b7e:	f3 0f 1e fa          	endbr64 
   42b82:	55                   	push   %rbp
   42b83:	48 89 e5             	mov    %rsp,%rbp
   42b86:	48 83 ec 10          	sub    $0x10,%rsp
   42b8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   42b8e:	89 75 f4             	mov    %esi,-0xc(%rbp)
    memset(&p->p_registers, 0, sizeof(p->p_registers));
   42b91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42b95:	48 83 c0 08          	add    $0x8,%rax
   42b99:	ba c0 00 00 00       	mov    $0xc0,%edx
   42b9e:	be 00 00 00 00       	mov    $0x0,%esi
   42ba3:	48 89 c7             	mov    %rax,%rdi
   42ba6:	e8 f7 0b 00 00       	call   437a2 <memset>
    p->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
   42bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42baf:	66 c7 80 a8 00 00 00 	movw   $0x13,0xa8(%rax)
   42bb6:	13 00 
    p->p_registers.reg_fs = SEGSEL_APP_DATA | 3;
   42bb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42bbc:	48 c7 80 80 00 00 00 	movq   $0x23,0x80(%rax)
   42bc3:	23 00 00 00 
    p->p_registers.reg_gs = SEGSEL_APP_DATA | 3;
   42bc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42bcb:	48 c7 80 88 00 00 00 	movq   $0x23,0x88(%rax)
   42bd2:	23 00 00 00 
    p->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
   42bd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42bda:	66 c7 80 c0 00 00 00 	movw   $0x23,0xc0(%rax)
   42be1:	23 00 
    p->p_registers.reg_rflags = EFLAGS_IF;
   42be3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42be7:	48 c7 80 b0 00 00 00 	movq   $0x200,0xb0(%rax)
   42bee:	00 02 00 00 

    if (flags & PROCINIT_ALLOW_PROGRAMMED_IO) {
   42bf2:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42bf5:	83 e0 01             	and    $0x1,%eax
   42bf8:	85 c0                	test   %eax,%eax
   42bfa:	74 1c                	je     42c18 <process_init+0x9a>
        p->p_registers.reg_rflags |= EFLAGS_IOPL_3;
   42bfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42c00:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
   42c07:	80 cc 30             	or     $0x30,%ah
   42c0a:	48 89 c2             	mov    %rax,%rdx
   42c0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42c11:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    }
    if (flags & PROCINIT_DISABLE_INTERRUPTS) {
   42c18:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42c1b:	83 e0 02             	and    $0x2,%eax
   42c1e:	85 c0                	test   %eax,%eax
   42c20:	74 1c                	je     42c3e <process_init+0xc0>
        p->p_registers.reg_rflags &= ~EFLAGS_IF;
   42c22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42c26:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
   42c2d:	80 e4 fd             	and    $0xfd,%ah
   42c30:	48 89 c2             	mov    %rax,%rdx
   42c33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42c37:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    }
}
   42c3e:	90                   	nop
   42c3f:	c9                   	leave  
   42c40:	c3                   	ret    

0000000000042c41 <console_show_cursor>:

// console_show_cursor(cpos)
//    Move the console cursor to position `cpos`, which should be between 0
//    and 80 * 25.

void console_show_cursor(int cpos) {
   42c41:	f3 0f 1e fa          	endbr64 
   42c45:	55                   	push   %rbp
   42c46:	48 89 e5             	mov    %rsp,%rbp
   42c49:	48 83 ec 28          	sub    $0x28,%rsp
   42c4d:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (cpos < 0 || cpos > CONSOLE_ROWS * CONSOLE_COLUMNS) {
   42c50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   42c54:	78 09                	js     42c5f <console_show_cursor+0x1e>
   42c56:	81 7d dc d0 07 00 00 	cmpl   $0x7d0,-0x24(%rbp)
   42c5d:	7e 07                	jle    42c66 <console_show_cursor+0x25>
        cpos = 0;
   42c5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
   42c66:	c7 45 e4 d4 03 00 00 	movl   $0x3d4,-0x1c(%rbp)
   42c6d:	c6 45 e3 0e          	movb   $0xe,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42c71:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   42c75:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   42c78:	ee                   	out    %al,(%dx)
}
   42c79:	90                   	nop
    }
    outb(0x3D4, 14);
    outb(0x3D5, cpos / 256);
   42c7a:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42c7d:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   42c83:	85 c0                	test   %eax,%eax
   42c85:	0f 48 c2             	cmovs  %edx,%eax
   42c88:	c1 f8 08             	sar    $0x8,%eax
   42c8b:	0f b6 c0             	movzbl %al,%eax
   42c8e:	c7 45 ec d5 03 00 00 	movl   $0x3d5,-0x14(%rbp)
   42c95:	88 45 eb             	mov    %al,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42c98:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   42c9c:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42c9f:	ee                   	out    %al,(%dx)
}
   42ca0:	90                   	nop
   42ca1:	c7 45 f4 d4 03 00 00 	movl   $0x3d4,-0xc(%rbp)
   42ca8:	c6 45 f3 0f          	movb   $0xf,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42cac:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   42cb0:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42cb3:	ee                   	out    %al,(%dx)
}
   42cb4:	90                   	nop
    outb(0x3D4, 15);
    outb(0x3D5, cpos % 256);
   42cb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42cb8:	99                   	cltd   
   42cb9:	c1 ea 18             	shr    $0x18,%edx
   42cbc:	01 d0                	add    %edx,%eax
   42cbe:	0f b6 c0             	movzbl %al,%eax
   42cc1:	29 d0                	sub    %edx,%eax
   42cc3:	0f b6 c0             	movzbl %al,%eax
   42cc6:	c7 45 fc d5 03 00 00 	movl   $0x3d5,-0x4(%rbp)
   42ccd:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42cd0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42cd4:	8b 55 fc             	mov    -0x4(%rbp),%edx
   42cd7:	ee                   	out    %al,(%dx)
}
   42cd8:	90                   	nop
}
   42cd9:	90                   	nop
   42cda:	c9                   	leave  
   42cdb:	c3                   	ret    

0000000000042cdc <keyboard_readc>:
    /*CKEY(16)*/ {{'\'', '"', 0, 0}},  /*CKEY(17)*/ {{'`', '~', 0, 0}},
    /*CKEY(18)*/ {{'\\', '|', 034, 0}},  /*CKEY(19)*/ {{',', '<', 0, 0}},
    /*CKEY(20)*/ {{'.', '>', 0, 0}},  /*CKEY(21)*/ {{'/', '?', 0, 0}}
};

int keyboard_readc(void) {
   42cdc:	f3 0f 1e fa          	endbr64 
   42ce0:	55                   	push   %rbp
   42ce1:	48 89 e5             	mov    %rsp,%rbp
   42ce4:	48 83 ec 20          	sub    $0x20,%rsp
   42ce8:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42cef:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42cf2:	89 c2                	mov    %eax,%edx
   42cf4:	ec                   	in     (%dx),%al
   42cf5:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   42cf8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
    static uint8_t modifiers;
    static uint8_t last_escape;

    if ((inb(KEYBOARD_STATUSREG) & KEYBOARD_STATUS_READY) == 0) {
   42cfc:	0f b6 c0             	movzbl %al,%eax
   42cff:	83 e0 01             	and    $0x1,%eax
   42d02:	85 c0                	test   %eax,%eax
   42d04:	75 0a                	jne    42d10 <keyboard_readc+0x34>
        return -1;
   42d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42d0b:	e9 fd 01 00 00       	jmp    42f0d <keyboard_readc+0x231>
   42d10:	c7 45 e8 60 00 00 00 	movl   $0x60,-0x18(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42d17:	8b 45 e8             	mov    -0x18(%rbp),%eax
   42d1a:	89 c2                	mov    %eax,%edx
   42d1c:	ec                   	in     (%dx),%al
   42d1d:	88 45 e7             	mov    %al,-0x19(%rbp)
    return data;
   42d20:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
    }

    uint8_t data = inb(KEYBOARD_DATAREG);
   42d24:	88 45 fb             	mov    %al,-0x5(%rbp)
    uint8_t escape = last_escape;
   42d27:	0f b6 05 d2 92 01 00 	movzbl 0x192d2(%rip),%eax        # 5c000 <last_escape.2>
   42d2e:	88 45 fa             	mov    %al,-0x6(%rbp)
    last_escape = 0;
   42d31:	c6 05 c8 92 01 00 00 	movb   $0x0,0x192c8(%rip)        # 5c000 <last_escape.2>

    if (data == 0xE0) {         // mode shift
   42d38:	80 7d fb e0          	cmpb   $0xe0,-0x5(%rbp)
   42d3c:	75 11                	jne    42d4f <keyboard_readc+0x73>
        last_escape = 0x80;
   42d3e:	c6 05 bb 92 01 00 80 	movb   $0x80,0x192bb(%rip)        # 5c000 <last_escape.2>
        return 0;
   42d45:	b8 00 00 00 00       	mov    $0x0,%eax
   42d4a:	e9 be 01 00 00       	jmp    42f0d <keyboard_readc+0x231>
    } else if (data & 0x80) {   // key release: matters only for modifier keys
   42d4f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42d53:	84 c0                	test   %al,%al
   42d55:	79 64                	jns    42dbb <keyboard_readc+0xdf>
        int ch = keymap[(data & 0x7F) | escape];
   42d57:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42d5b:	83 e0 7f             	and    $0x7f,%eax
   42d5e:	89 c2                	mov    %eax,%edx
   42d60:	0f b6 45 fa          	movzbl -0x6(%rbp),%eax
   42d64:	09 d0                	or     %edx,%eax
   42d66:	48 98                	cltq   
   42d68:	48 8d 15 f1 1a 00 00 	lea    0x1af1(%rip),%rdx        # 44860 <keymap>
   42d6f:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
   42d73:	0f b6 c0             	movzbl %al,%eax
   42d76:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (ch >= KEY_SHIFT && ch < KEY_CAPSLOCK) {
   42d79:	81 7d f4 f9 00 00 00 	cmpl   $0xf9,-0xc(%rbp)
   42d80:	7e 2f                	jle    42db1 <keyboard_readc+0xd5>
   42d82:	81 7d f4 fc 00 00 00 	cmpl   $0xfc,-0xc(%rbp)
   42d89:	7f 26                	jg     42db1 <keyboard_readc+0xd5>
            modifiers &= ~(1 << (ch - KEY_SHIFT));
   42d8b:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42d8e:	2d fa 00 00 00       	sub    $0xfa,%eax
   42d93:	ba 01 00 00 00       	mov    $0x1,%edx
   42d98:	89 c1                	mov    %eax,%ecx
   42d9a:	d3 e2                	shl    %cl,%edx
   42d9c:	89 d0                	mov    %edx,%eax
   42d9e:	f7 d0                	not    %eax
   42da0:	89 c2                	mov    %eax,%edx
   42da2:	0f b6 05 58 92 01 00 	movzbl 0x19258(%rip),%eax        # 5c001 <modifiers.1>
   42da9:	21 d0                	and    %edx,%eax
   42dab:	88 05 50 92 01 00    	mov    %al,0x19250(%rip)        # 5c001 <modifiers.1>
        }
        return 0;
   42db1:	b8 00 00 00 00       	mov    $0x0,%eax
   42db6:	e9 52 01 00 00       	jmp    42f0d <keyboard_readc+0x231>
    }

    int ch = (unsigned char) keymap[data | escape];
   42dbb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42dbf:	0a 45 fa             	or     -0x6(%rbp),%al
   42dc2:	0f b6 c0             	movzbl %al,%eax
   42dc5:	48 98                	cltq   
   42dc7:	48 8d 15 92 1a 00 00 	lea    0x1a92(%rip),%rdx        # 44860 <keymap>
   42dce:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
   42dd2:	0f b6 c0             	movzbl %al,%eax
   42dd5:	89 45 fc             	mov    %eax,-0x4(%rbp)

    if (ch >= 'a' && ch <= 'z') {
   42dd8:	83 7d fc 60          	cmpl   $0x60,-0x4(%rbp)
   42ddc:	7e 57                	jle    42e35 <keyboard_readc+0x159>
   42dde:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%rbp)
   42de2:	7f 51                	jg     42e35 <keyboard_readc+0x159>
        if (modifiers & MOD_CONTROL) {
   42de4:	0f b6 05 16 92 01 00 	movzbl 0x19216(%rip),%eax        # 5c001 <modifiers.1>
   42deb:	0f b6 c0             	movzbl %al,%eax
   42dee:	83 e0 02             	and    $0x2,%eax
   42df1:	85 c0                	test   %eax,%eax
   42df3:	74 09                	je     42dfe <keyboard_readc+0x122>
            ch -= 0x60;
   42df5:	83 6d fc 60          	subl   $0x60,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   42df9:	e9 0b 01 00 00       	jmp    42f09 <keyboard_readc+0x22d>
        } else if (!(modifiers & MOD_SHIFT) != !(modifiers & MOD_CAPSLOCK)) {
   42dfe:	0f b6 05 fc 91 01 00 	movzbl 0x191fc(%rip),%eax        # 5c001 <modifiers.1>
   42e05:	0f b6 c0             	movzbl %al,%eax
   42e08:	83 e0 01             	and    $0x1,%eax
   42e0b:	85 c0                	test   %eax,%eax
   42e0d:	0f 94 c2             	sete   %dl
   42e10:	0f b6 05 ea 91 01 00 	movzbl 0x191ea(%rip),%eax        # 5c001 <modifiers.1>
   42e17:	0f b6 c0             	movzbl %al,%eax
   42e1a:	83 e0 08             	and    $0x8,%eax
   42e1d:	85 c0                	test   %eax,%eax
   42e1f:	0f 94 c0             	sete   %al
   42e22:	31 d0                	xor    %edx,%eax
   42e24:	84 c0                	test   %al,%al
   42e26:	0f 84 dd 00 00 00    	je     42f09 <keyboard_readc+0x22d>
            ch -= 0x20;
   42e2c:	83 6d fc 20          	subl   $0x20,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   42e30:	e9 d4 00 00 00       	jmp    42f09 <keyboard_readc+0x22d>
        }
    } else if (ch >= KEY_CAPSLOCK) {
   42e35:	81 7d fc fc 00 00 00 	cmpl   $0xfc,-0x4(%rbp)
   42e3c:	7e 30                	jle    42e6e <keyboard_readc+0x192>
        modifiers ^= 1 << (ch - KEY_SHIFT);
   42e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42e41:	2d fa 00 00 00       	sub    $0xfa,%eax
   42e46:	ba 01 00 00 00       	mov    $0x1,%edx
   42e4b:	89 c1                	mov    %eax,%ecx
   42e4d:	d3 e2                	shl    %cl,%edx
   42e4f:	89 d0                	mov    %edx,%eax
   42e51:	89 c2                	mov    %eax,%edx
   42e53:	0f b6 05 a7 91 01 00 	movzbl 0x191a7(%rip),%eax        # 5c001 <modifiers.1>
   42e5a:	31 d0                	xor    %edx,%eax
   42e5c:	88 05 9f 91 01 00    	mov    %al,0x1919f(%rip)        # 5c001 <modifiers.1>
        ch = 0;
   42e62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42e69:	e9 9c 00 00 00       	jmp    42f0a <keyboard_readc+0x22e>
    } else if (ch >= KEY_SHIFT) {
   42e6e:	81 7d fc f9 00 00 00 	cmpl   $0xf9,-0x4(%rbp)
   42e75:	7e 2d                	jle    42ea4 <keyboard_readc+0x1c8>
        modifiers |= 1 << (ch - KEY_SHIFT);
   42e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42e7a:	2d fa 00 00 00       	sub    $0xfa,%eax
   42e7f:	ba 01 00 00 00       	mov    $0x1,%edx
   42e84:	89 c1                	mov    %eax,%ecx
   42e86:	d3 e2                	shl    %cl,%edx
   42e88:	89 d0                	mov    %edx,%eax
   42e8a:	89 c2                	mov    %eax,%edx
   42e8c:	0f b6 05 6e 91 01 00 	movzbl 0x1916e(%rip),%eax        # 5c001 <modifiers.1>
   42e93:	09 d0                	or     %edx,%eax
   42e95:	88 05 66 91 01 00    	mov    %al,0x19166(%rip)        # 5c001 <modifiers.1>
        ch = 0;
   42e9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42ea2:	eb 66                	jmp    42f0a <keyboard_readc+0x22e>
    } else if (ch >= CKEY(0) && ch <= CKEY(21)) {
   42ea4:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   42ea8:	7e 3f                	jle    42ee9 <keyboard_readc+0x20d>
   42eaa:	81 7d fc 95 00 00 00 	cmpl   $0x95,-0x4(%rbp)
   42eb1:	7f 36                	jg     42ee9 <keyboard_readc+0x20d>
        ch = complex_keymap[ch - CKEY(0)].map[modifiers & 3];
   42eb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42eb6:	8d 50 80             	lea    -0x80(%rax),%edx
   42eb9:	0f b6 05 41 91 01 00 	movzbl 0x19141(%rip),%eax        # 5c001 <modifiers.1>
   42ec0:	0f b6 c0             	movzbl %al,%eax
   42ec3:	83 e0 03             	and    $0x3,%eax
   42ec6:	48 63 c8             	movslq %eax,%rcx
   42ec9:	48 63 c2             	movslq %edx,%rax
   42ecc:	48 c1 e0 02          	shl    $0x2,%rax
   42ed0:	48 8d 14 08          	lea    (%rax,%rcx,1),%rdx
   42ed4:	48 8d 05 85 1a 00 00 	lea    0x1a85(%rip),%rax        # 44960 <complex_keymap>
   42edb:	48 01 d0             	add    %rdx,%rax
   42ede:	0f b6 00             	movzbl (%rax),%eax
   42ee1:	0f b6 c0             	movzbl %al,%eax
   42ee4:	89 45 fc             	mov    %eax,-0x4(%rbp)
   42ee7:	eb 21                	jmp    42f0a <keyboard_readc+0x22e>
    } else if (ch < 0x80 && (modifiers & MOD_CONTROL)) {
   42ee9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   42eed:	7f 1b                	jg     42f0a <keyboard_readc+0x22e>
   42eef:	0f b6 05 0b 91 01 00 	movzbl 0x1910b(%rip),%eax        # 5c001 <modifiers.1>
   42ef6:	0f b6 c0             	movzbl %al,%eax
   42ef9:	83 e0 02             	and    $0x2,%eax
   42efc:	85 c0                	test   %eax,%eax
   42efe:	74 0a                	je     42f0a <keyboard_readc+0x22e>
        ch = 0;
   42f00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42f07:	eb 01                	jmp    42f0a <keyboard_readc+0x22e>
        if (modifiers & MOD_CONTROL) {
   42f09:	90                   	nop
    }

    return ch;
   42f0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
   42f0d:	c9                   	leave  
   42f0e:	c3                   	ret    

0000000000042f0f <delay>:
#define IO_PARALLEL1_CONTROL    0x37A
# define IO_PARALLEL_CONTROL_SELECT     0x08
# define IO_PARALLEL_CONTROL_INIT       0x04
# define IO_PARALLEL_CONTROL_STROBE     0x01

static void delay(void) {
   42f0f:	f3 0f 1e fa          	endbr64 
   42f13:	55                   	push   %rbp
   42f14:	48 89 e5             	mov    %rsp,%rbp
   42f17:	48 83 ec 20          	sub    $0x20,%rsp
   42f1b:	c7 45 e4 84 00 00 00 	movl   $0x84,-0x1c(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42f22:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   42f25:	89 c2                	mov    %eax,%edx
   42f27:	ec                   	in     (%dx),%al
   42f28:	88 45 e3             	mov    %al,-0x1d(%rbp)
   42f2b:	c7 45 ec 84 00 00 00 	movl   $0x84,-0x14(%rbp)
   42f32:	8b 45 ec             	mov    -0x14(%rbp),%eax
   42f35:	89 c2                	mov    %eax,%edx
   42f37:	ec                   	in     (%dx),%al
   42f38:	88 45 eb             	mov    %al,-0x15(%rbp)
   42f3b:	c7 45 f4 84 00 00 00 	movl   $0x84,-0xc(%rbp)
   42f42:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42f45:	89 c2                	mov    %eax,%edx
   42f47:	ec                   	in     (%dx),%al
   42f48:	88 45 f3             	mov    %al,-0xd(%rbp)
   42f4b:	c7 45 fc 84 00 00 00 	movl   $0x84,-0x4(%rbp)
   42f52:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42f55:	89 c2                	mov    %eax,%edx
   42f57:	ec                   	in     (%dx),%al
   42f58:	88 45 fb             	mov    %al,-0x5(%rbp)
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
}
   42f5b:	90                   	nop
   42f5c:	c9                   	leave  
   42f5d:	c3                   	ret    

0000000000042f5e <parallel_port_putc>:

static void parallel_port_putc(printer* p, unsigned char c, int color) {
   42f5e:	f3 0f 1e fa          	endbr64 
   42f62:	55                   	push   %rbp
   42f63:	48 89 e5             	mov    %rsp,%rbp
   42f66:	48 83 ec 40          	sub    $0x40,%rsp
   42f6a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42f6e:	89 f0                	mov    %esi,%eax
   42f70:	89 55 c0             	mov    %edx,-0x40(%rbp)
   42f73:	88 45 c4             	mov    %al,-0x3c(%rbp)
    static int initialized;
    (void) p, (void) color;
    if (!initialized) {
   42f76:	8b 05 88 90 01 00    	mov    0x19088(%rip),%eax        # 5c004 <initialized.0>
   42f7c:	85 c0                	test   %eax,%eax
   42f7e:	75 1e                	jne    42f9e <parallel_port_putc+0x40>
   42f80:	c7 45 f8 7a 03 00 00 	movl   $0x37a,-0x8(%rbp)
   42f87:	c6 45 f7 00          	movb   $0x0,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42f8b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   42f8f:	8b 55 f8             	mov    -0x8(%rbp),%edx
   42f92:	ee                   	out    %al,(%dx)
}
   42f93:	90                   	nop
        outb(IO_PARALLEL1_CONTROL, 0);
        initialized = 1;
   42f94:	c7 05 66 90 01 00 01 	movl   $0x1,0x19066(%rip)        # 5c004 <initialized.0>
   42f9b:	00 00 00 
    }

    for (int i = 0;
   42f9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42fa5:	eb 09                	jmp    42fb0 <parallel_port_putc+0x52>
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
         ++i) {
        delay();
   42fa7:	e8 63 ff ff ff       	call   42f0f <delay>
         ++i) {
   42fac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
   42fb0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
   42fb7:	7f 18                	jg     42fd1 <parallel_port_putc+0x73>
   42fb9:	c7 45 f0 79 03 00 00 	movl   $0x379,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42fc0:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42fc3:	89 c2                	mov    %eax,%edx
   42fc5:	ec                   	in     (%dx),%al
   42fc6:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   42fc9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   42fcd:	84 c0                	test   %al,%al
   42fcf:	79 d6                	jns    42fa7 <parallel_port_putc+0x49>
    }
    outb(IO_PARALLEL1_DATA, c);
   42fd1:	0f b6 45 c4          	movzbl -0x3c(%rbp),%eax
   42fd5:	c7 45 d8 78 03 00 00 	movl   $0x378,-0x28(%rbp)
   42fdc:	88 45 d7             	mov    %al,-0x29(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42fdf:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
   42fe3:	8b 55 d8             	mov    -0x28(%rbp),%edx
   42fe6:	ee                   	out    %al,(%dx)
}
   42fe7:	90                   	nop
   42fe8:	c7 45 e0 7a 03 00 00 	movl   $0x37a,-0x20(%rbp)
   42fef:	c6 45 df 0d          	movb   $0xd,-0x21(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42ff3:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
   42ff7:	8b 55 e0             	mov    -0x20(%rbp),%edx
   42ffa:	ee                   	out    %al,(%dx)
}
   42ffb:	90                   	nop
   42ffc:	c7 45 e8 7a 03 00 00 	movl   $0x37a,-0x18(%rbp)
   43003:	c6 45 e7 0c          	movb   $0xc,-0x19(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   43007:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
   4300b:	8b 55 e8             	mov    -0x18(%rbp),%edx
   4300e:	ee                   	out    %al,(%dx)
}
   4300f:	90                   	nop
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT | IO_PARALLEL_CONTROL_STROBE);
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT);
}
   43010:	90                   	nop
   43011:	c9                   	leave  
   43012:	c3                   	ret    

0000000000043013 <log_vprintf>:

void log_vprintf(const char* format, va_list val) {
   43013:	f3 0f 1e fa          	endbr64 
   43017:	55                   	push   %rbp
   43018:	48 89 e5             	mov    %rsp,%rbp
   4301b:	48 83 ec 20          	sub    $0x20,%rsp
   4301f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43023:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    printer p;
    p.putc = parallel_port_putc;
   43027:	48 8d 05 30 ff ff ff 	lea    -0xd0(%rip),%rax        # 42f5e <parallel_port_putc>
   4302e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&p, 0, format, val);
   43032:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
   43036:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   4303a:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
   4303e:	be 00 00 00 00       	mov    $0x0,%esi
   43043:	48 89 c7             	mov    %rax,%rdi
   43046:	e8 88 08 00 00       	call   438d3 <printer_vprintf>
}
   4304b:	90                   	nop
   4304c:	c9                   	leave  
   4304d:	c3                   	ret    

000000000004304e <log_printf>:

void log_printf(const char* format, ...) {
   4304e:	f3 0f 1e fa          	endbr64 
   43052:	55                   	push   %rbp
   43053:	48 89 e5             	mov    %rsp,%rbp
   43056:	48 83 ec 60          	sub    $0x60,%rsp
   4305a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   4305e:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   43062:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   43066:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   4306a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   4306e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   43072:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
   43079:	48 8d 45 10          	lea    0x10(%rbp),%rax
   4307d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   43081:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   43085:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    log_vprintf(format, val);
   43089:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
   4308d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43091:	48 89 d6             	mov    %rdx,%rsi
   43094:	48 89 c7             	mov    %rax,%rdi
   43097:	e8 77 ff ff ff       	call   43013 <log_vprintf>
    va_end(val);
}
   4309c:	90                   	nop
   4309d:	c9                   	leave  
   4309e:	c3                   	ret    

000000000004309f <error_vprintf>:

// error_printf, error_vprintf
//    Print debugging messages to the console and to the host's
//    `log.txt` file via `log_printf`.

int error_vprintf(int cpos, int color, const char* format, va_list val) {
   4309f:	f3 0f 1e fa          	endbr64 
   430a3:	55                   	push   %rbp
   430a4:	48 89 e5             	mov    %rsp,%rbp
   430a7:	48 83 ec 40          	sub    $0x40,%rsp
   430ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
   430ae:	89 75 d8             	mov    %esi,-0x28(%rbp)
   430b1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
   430b5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
    va_list val2;
    __builtin_va_copy(val2, val);
   430b9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
   430bd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   430c1:	48 8b 0a             	mov    (%rdx),%rcx
   430c4:	48 89 08             	mov    %rcx,(%rax)
   430c7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   430cb:	48 89 48 08          	mov    %rcx,0x8(%rax)
   430cf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
   430d3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    log_vprintf(format, val2);
   430d7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
   430db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   430df:	48 89 d6             	mov    %rdx,%rsi
   430e2:	48 89 c7             	mov    %rax,%rdi
   430e5:	e8 29 ff ff ff       	call   43013 <log_vprintf>
    va_end(val2);
    return console_vprintf(cpos, color, format, val);
   430ea:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   430ee:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   430f2:	8b 75 d8             	mov    -0x28(%rbp),%esi
   430f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
   430f8:	89 c7                	mov    %eax,%edi
   430fa:	e8 d3 0e 00 00       	call   43fd2 <console_vprintf>
}
   430ff:	c9                   	leave  
   43100:	c3                   	ret    

0000000000043101 <error_printf>:

int error_printf(int cpos, int color, const char* format, ...) {
   43101:	f3 0f 1e fa          	endbr64 
   43105:	55                   	push   %rbp
   43106:	48 89 e5             	mov    %rsp,%rbp
   43109:	48 83 ec 60          	sub    $0x60,%rsp
   4310d:	89 7d ac             	mov    %edi,-0x54(%rbp)
   43110:	89 75 a8             	mov    %esi,-0x58(%rbp)
   43113:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
   43117:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   4311b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   4311f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   43123:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   4312a:	48 8d 45 10          	lea    0x10(%rbp),%rax
   4312e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   43132:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   43136:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = error_vprintf(cpos, color, format, val);
   4313a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   4313e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   43142:	8b 75 a8             	mov    -0x58(%rbp),%esi
   43145:	8b 45 ac             	mov    -0x54(%rbp),%eax
   43148:	89 c7                	mov    %eax,%edi
   4314a:	e8 50 ff ff ff       	call   4309f <error_vprintf>
   4314f:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
   43152:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
   43155:	c9                   	leave  
   43156:	c3                   	ret    

0000000000043157 <check_keyboard>:
//    Check for the user typing a control key. 'a', 'f', and 'e' cause a soft
//    reboot where the kernel runs the allocator programs, "fork", or
//    "forkexit", respectively. Control-C or 'q' exit the virtual machine.
//    Returns key typed or -1 for no key.

int check_keyboard(void) {
   43157:	f3 0f 1e fa          	endbr64 
   4315b:	55                   	push   %rbp
   4315c:	48 89 e5             	mov    %rsp,%rbp
   4315f:	53                   	push   %rbx
   43160:	48 83 ec 48          	sub    $0x48,%rsp
    int c = keyboard_readc();
   43164:	e8 73 fb ff ff       	call   42cdc <keyboard_readc>
   43169:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    if (c == 'a' || c == 'f' || c == 'e') {
   4316c:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   43170:	74 10                	je     43182 <check_keyboard+0x2b>
   43172:	83 7d e4 66          	cmpl   $0x66,-0x1c(%rbp)
   43176:	74 0a                	je     43182 <check_keyboard+0x2b>
   43178:	83 7d e4 65          	cmpl   $0x65,-0x1c(%rbp)
   4317c:	0f 85 dc 00 00 00    	jne    4325e <check_keyboard+0x107>
        // Install a temporary page table to carry us through the
        // process of reinitializing memory. This replicates work the
        // bootloader does.
        x86_64_pagetable* pt = (x86_64_pagetable*) 0x8000;
   43182:	48 c7 45 d8 00 80 00 	movq   $0x8000,-0x28(%rbp)
   43189:	00 
        memset(pt, 0, PAGESIZE * 3);
   4318a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4318e:	ba 00 30 00 00       	mov    $0x3000,%edx
   43193:	be 00 00 00 00       	mov    $0x0,%esi
   43198:	48 89 c7             	mov    %rax,%rdi
   4319b:	e8 02 06 00 00       	call   437a2 <memset>
        pt[0].entry[0] = 0x9000 | PTE_P | PTE_W | PTE_U;
   431a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   431a4:	48 c7 00 07 90 00 00 	movq   $0x9007,(%rax)
        pt[1].entry[0] = 0xA000 | PTE_P | PTE_W | PTE_U;
   431ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   431af:	48 05 00 10 00 00    	add    $0x1000,%rax
   431b5:	48 c7 00 07 a0 00 00 	movq   $0xa007,(%rax)
        pt[2].entry[0] = PTE_P | PTE_W | PTE_U | PTE_PS;
   431bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   431c0:	48 05 00 20 00 00    	add    $0x2000,%rax
   431c6:	48 c7 00 87 00 00 00 	movq   $0x87,(%rax)
        lcr3((uintptr_t) pt);
   431cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   431d1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   431d5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   431d9:	0f 22 d8             	mov    %rax,%cr3
}
   431dc:	90                   	nop
        // The soft reboot process doesn't modify memory, so it's
        // safe to pass `multiboot_info` on the kernel stack, even
        // though it will get overwritten as the kernel runs.
        uint32_t multiboot_info[5];
        multiboot_info[0] = 4;
   431dd:	c7 45 b4 04 00 00 00 	movl   $0x4,-0x4c(%rbp)
        const char* argument = "fork";
   431e4:	48 8d 05 cd 17 00 00 	lea    0x17cd(%rip),%rax        # 449b8 <complex_keymap+0x58>
   431eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        if (c == 'a') {
   431ef:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   431f3:	75 0d                	jne    43202 <check_keyboard+0xab>
            argument = "allocator";
   431f5:	48 8d 05 c1 17 00 00 	lea    0x17c1(%rip),%rax        # 449bd <complex_keymap+0x5d>
   431fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   43200:	eb 11                	jmp    43213 <check_keyboard+0xbc>
        } else if (c == 'e') {
   43202:	83 7d e4 65          	cmpl   $0x65,-0x1c(%rbp)
   43206:	75 0b                	jne    43213 <check_keyboard+0xbc>
            argument = "forkexit";
   43208:	48 8d 05 b8 17 00 00 	lea    0x17b8(%rip),%rax        # 449c7 <complex_keymap+0x67>
   4320f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        }
        uintptr_t argument_ptr = (uintptr_t) argument;
   43213:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43217:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        assert(argument_ptr < 0x100000000L);
   4321b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43220:	48 39 45 d0          	cmp    %rax,-0x30(%rbp)
   43224:	76 1e                	jbe    43244 <check_keyboard+0xed>
   43226:	48 8d 05 a3 17 00 00 	lea    0x17a3(%rip),%rax        # 449d0 <complex_keymap+0x70>
   4322d:	48 89 c2             	mov    %rax,%rdx
   43230:	be f9 02 00 00       	mov    $0x2f9,%esi
   43235:	48 8d 05 19 13 00 00 	lea    0x1319(%rip),%rax        # 44555 <memstate_colors+0x155>
   4323c:	48 89 c7             	mov    %rax,%rdi
   4323f:	e8 33 01 00 00       	call   43377 <assert_fail>
        multiboot_info[4] = (uint32_t) argument_ptr;
   43244:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   43248:	89 45 c4             	mov    %eax,-0x3c(%rbp)
        asm volatile("movl $0x2BADB002, %%eax; jmp entry_from_boot"
   4324b:	48 8d 45 b4          	lea    -0x4c(%rbp),%rax
   4324f:	48 89 c3             	mov    %rax,%rbx
   43252:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
   43257:	e9 a4 cd ff ff       	jmp    40000 <entry_from_boot>
    if (c == 'a' || c == 'f' || c == 'e') {
   4325c:	eb 11                	jmp    4326f <check_keyboard+0x118>
                     : : "b" (multiboot_info) : "memory");
    } else if (c == 0x03 || c == 'q') {
   4325e:	83 7d e4 03          	cmpl   $0x3,-0x1c(%rbp)
   43262:	74 06                	je     4326a <check_keyboard+0x113>
   43264:	83 7d e4 71          	cmpl   $0x71,-0x1c(%rbp)
   43268:	75 05                	jne    4326f <check_keyboard+0x118>
        poweroff();
   4326a:	e8 79 f8 ff ff       	call   42ae8 <poweroff>
    }
    return c;
   4326f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
}
   43272:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   43276:	c9                   	leave  
   43277:	c3                   	ret    

0000000000043278 <fail>:

// fail
//    Loop until user presses Control-C, then poweroff.

static void fail(void) __attribute__((noreturn));
static void fail(void) {
   43278:	f3 0f 1e fa          	endbr64 
   4327c:	55                   	push   %rbp
   4327d:	48 89 e5             	mov    %rsp,%rbp
    // unamanged and don't want to just hang.
    poweroff();
#endif
  
    while (1) {
        check_keyboard();
   43280:	e8 d2 fe ff ff       	call   43157 <check_keyboard>
   43285:	eb f9                	jmp    43280 <fail+0x8>

0000000000043287 <panic>:

// panic, assert_fail
//    Use console_printf() to print a failure message and then wait for
//    control-C. Also write the failure message to the log.

void panic(const char* format, ...) {
   43287:	f3 0f 1e fa          	endbr64 
   4328b:	55                   	push   %rbp
   4328c:	48 89 e5             	mov    %rsp,%rbp
   4328f:	48 83 ec 60          	sub    $0x60,%rsp
   43293:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   43297:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   4329b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   4329f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   432a3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   432a7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   432ab:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%rbp)
   432b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
   432b6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
   432ba:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   432be:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

    if (format) {
   432c2:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
   432c7:	0f 84 87 00 00 00    	je     43354 <panic+0xcd>
        // Print panic message to both the screen and the log
        int cpos = error_printf(CPOS(23, 0), 0xC000, "PANIC: ");
   432cd:	48 8d 05 18 17 00 00 	lea    0x1718(%rip),%rax        # 449ec <complex_keymap+0x8c>
   432d4:	48 89 c2             	mov    %rax,%rdx
   432d7:	be 00 c0 00 00       	mov    $0xc000,%esi
   432dc:	bf 30 07 00 00       	mov    $0x730,%edi
   432e1:	b8 00 00 00 00       	mov    $0x0,%eax
   432e6:	e8 16 fe ff ff       	call   43101 <error_printf>
   432eb:	89 45 cc             	mov    %eax,-0x34(%rbp)
        cpos = error_vprintf(cpos, 0xC000, format, val);
   432ee:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
   432f2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
   432f6:	8b 45 cc             	mov    -0x34(%rbp),%eax
   432f9:	be 00 c0 00 00       	mov    $0xc000,%esi
   432fe:	89 c7                	mov    %eax,%edi
   43300:	e8 9a fd ff ff       	call   4309f <error_vprintf>
   43305:	89 45 cc             	mov    %eax,-0x34(%rbp)
        if (CCOL(cpos)) {
   43308:	8b 4d cc             	mov    -0x34(%rbp),%ecx
   4330b:	48 63 c1             	movslq %ecx,%rax
   4330e:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
   43315:	48 c1 e8 20          	shr    $0x20,%rax
   43319:	c1 f8 05             	sar    $0x5,%eax
   4331c:	89 ce                	mov    %ecx,%esi
   4331e:	c1 fe 1f             	sar    $0x1f,%esi
   43321:	29 f0                	sub    %esi,%eax
   43323:	89 c2                	mov    %eax,%edx
   43325:	89 d0                	mov    %edx,%eax
   43327:	c1 e0 02             	shl    $0x2,%eax
   4332a:	01 d0                	add    %edx,%eax
   4332c:	c1 e0 04             	shl    $0x4,%eax
   4332f:	29 c1                	sub    %eax,%ecx
   43331:	89 ca                	mov    %ecx,%edx
   43333:	85 d2                	test   %edx,%edx
   43335:	74 3b                	je     43372 <panic+0xeb>
            error_printf(cpos, 0xC000, "\n");
   43337:	8b 45 cc             	mov    -0x34(%rbp),%eax
   4333a:	48 8d 15 b3 16 00 00 	lea    0x16b3(%rip),%rdx        # 449f4 <complex_keymap+0x94>
   43341:	be 00 c0 00 00       	mov    $0xc000,%esi
   43346:	89 c7                	mov    %eax,%edi
   43348:	b8 00 00 00 00       	mov    $0x0,%eax
   4334d:	e8 af fd ff ff       	call   43101 <error_printf>
   43352:	eb 1e                	jmp    43372 <panic+0xeb>
        }
    } else {
        error_printf(CPOS(23, 0), 0xC000, "PANIC");
   43354:	48 8d 05 9b 16 00 00 	lea    0x169b(%rip),%rax        # 449f6 <complex_keymap+0x96>
   4335b:	48 89 c2             	mov    %rax,%rdx
   4335e:	be 00 c0 00 00       	mov    $0xc000,%esi
   43363:	bf 30 07 00 00       	mov    $0x730,%edi
   43368:	b8 00 00 00 00       	mov    $0x0,%eax
   4336d:	e8 8f fd ff ff       	call   43101 <error_printf>
    }

    va_end(val);
    fail();
   43372:	e8 01 ff ff ff       	call   43278 <fail>

0000000000043377 <assert_fail>:
}

void assert_fail(const char* file, int line, const char* msg) {
   43377:	f3 0f 1e fa          	endbr64 
   4337b:	55                   	push   %rbp
   4337c:	48 89 e5             	mov    %rsp,%rbp
   4337f:	48 83 ec 20          	sub    $0x20,%rsp
   43383:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   43387:	89 75 f4             	mov    %esi,-0xc(%rbp)
   4338a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    panic("%s:%d: assertion '%s' failed\n", file, line, msg);
   4338e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   43392:	8b 55 f4             	mov    -0xc(%rbp),%edx
   43395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43399:	48 89 c6             	mov    %rax,%rsi
   4339c:	48 8d 05 59 16 00 00 	lea    0x1659(%rip),%rax        # 449fc <complex_keymap+0x9c>
   433a3:	48 89 c7             	mov    %rax,%rdi
   433a6:	b8 00 00 00 00       	mov    $0x0,%eax
   433ab:	e8 d7 fe ff ff       	call   43287 <panic>

00000000000433b0 <program_load>:
//    `assign_physical_page` to as required. Returns 0 on success and
//    -1 on failure (e.g. out-of-memory). `allocator` is passed to
//    `virtual_memory_map`.

int program_load(proc* p, int programnumber,
                 x86_64_pagetable* (*allocator)(void)) {
   433b0:	f3 0f 1e fa          	endbr64 
   433b4:	55                   	push   %rbp
   433b5:	48 89 e5             	mov    %rsp,%rbp
   433b8:	48 83 ec 40          	sub    $0x40,%rsp
   433bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   433c0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
   433c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    // is this a valid program?
    int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);
   433c7:	c7 45 f8 06 00 00 00 	movl   $0x6,-0x8(%rbp)
    assert(programnumber >= 0 && programnumber < nprograms);
   433ce:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   433d2:	78 08                	js     433dc <program_load+0x2c>
   433d4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   433d7:	3b 45 f8             	cmp    -0x8(%rbp),%eax
   433da:	7c 1e                	jl     433fa <program_load+0x4a>
   433dc:	48 8d 05 3d 16 00 00 	lea    0x163d(%rip),%rax        # 44a20 <complex_keymap+0xc0>
   433e3:	48 89 c2             	mov    %rax,%rdx
   433e6:	be 34 00 00 00       	mov    $0x34,%esi
   433eb:	48 8d 05 5e 16 00 00 	lea    0x165e(%rip),%rax        # 44a50 <complex_keymap+0xf0>
   433f2:	48 89 c7             	mov    %rax,%rdi
   433f5:	e8 7d ff ff ff       	call   43377 <assert_fail>
    elf_header* eh = (elf_header*) ramimages[programnumber].begin;
   433fa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   433fd:	48 98                	cltq   
   433ff:	48 c1 e0 04          	shl    $0x4,%rax
   43403:	48 89 c2             	mov    %rax,%rdx
   43406:	48 8d 05 13 1c 00 00 	lea    0x1c13(%rip),%rax        # 45020 <ramimages>
   4340d:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
   43411:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    assert(eh->e_magic == ELF_MAGIC);
   43415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43419:	8b 00                	mov    (%rax),%eax
   4341b:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
   43420:	74 1e                	je     43440 <program_load+0x90>
   43422:	48 8d 05 32 16 00 00 	lea    0x1632(%rip),%rax        # 44a5b <complex_keymap+0xfb>
   43429:	48 89 c2             	mov    %rax,%rdx
   4342c:	be 36 00 00 00       	mov    $0x36,%esi
   43431:	48 8d 05 18 16 00 00 	lea    0x1618(%rip),%rax        # 44a50 <complex_keymap+0xf0>
   43438:	48 89 c7             	mov    %rax,%rdi
   4343b:	e8 37 ff ff ff       	call   43377 <assert_fail>

    // load each loadable program segment into memory
    elf_program* ph = (elf_program*) ((const uint8_t*) eh + eh->e_phoff);
   43440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43444:	48 8b 50 20          	mov    0x20(%rax),%rdx
   43448:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4344c:	48 01 d0             	add    %rdx,%rax
   4344f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for (int i = 0; i < eh->e_phnum; ++i) {
   43453:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4345a:	e9 94 00 00 00       	jmp    434f3 <program_load+0x143>
        if (ph[i].p_type == ELF_PTYPE_LOAD) {
   4345f:	8b 45 fc             	mov    -0x4(%rbp),%eax
   43462:	48 63 d0             	movslq %eax,%rdx
   43465:	48 89 d0             	mov    %rdx,%rax
   43468:	48 c1 e0 03          	shl    $0x3,%rax
   4346c:	48 29 d0             	sub    %rdx,%rax
   4346f:	48 c1 e0 03          	shl    $0x3,%rax
   43473:	48 89 c2             	mov    %rax,%rdx
   43476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4347a:	48 01 d0             	add    %rdx,%rax
   4347d:	8b 00                	mov    (%rax),%eax
   4347f:	83 f8 01             	cmp    $0x1,%eax
   43482:	75 6b                	jne    434ef <program_load+0x13f>
            const uint8_t* pdata = (const uint8_t*) eh + ph[i].p_offset;
   43484:	8b 45 fc             	mov    -0x4(%rbp),%eax
   43487:	48 63 d0             	movslq %eax,%rdx
   4348a:	48 89 d0             	mov    %rdx,%rax
   4348d:	48 c1 e0 03          	shl    $0x3,%rax
   43491:	48 29 d0             	sub    %rdx,%rax
   43494:	48 c1 e0 03          	shl    $0x3,%rax
   43498:	48 89 c2             	mov    %rax,%rdx
   4349b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4349f:	48 01 d0             	add    %rdx,%rax
   434a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
   434a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   434aa:	48 01 d0             	add    %rdx,%rax
   434ad:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            if (program_load_segment(p, &ph[i], pdata, allocator) < 0) {
   434b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
   434b4:	48 63 d0             	movslq %eax,%rdx
   434b7:	48 89 d0             	mov    %rdx,%rax
   434ba:	48 c1 e0 03          	shl    $0x3,%rax
   434be:	48 29 d0             	sub    %rdx,%rax
   434c1:	48 c1 e0 03          	shl    $0x3,%rax
   434c5:	48 89 c2             	mov    %rax,%rdx
   434c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   434cc:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
   434d0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   434d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   434d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   434dc:	48 89 c7             	mov    %rax,%rdi
   434df:	e8 3d 00 00 00       	call   43521 <program_load_segment>
   434e4:	85 c0                	test   %eax,%eax
   434e6:	79 07                	jns    434ef <program_load+0x13f>
                return -1;
   434e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   434ed:	eb 30                	jmp    4351f <program_load+0x16f>
    for (int i = 0; i < eh->e_phnum; ++i) {
   434ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   434f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   434f7:	0f b7 40 38          	movzwl 0x38(%rax),%eax
   434fb:	0f b7 c0             	movzwl %ax,%eax
   434fe:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   43501:	0f 8c 58 ff ff ff    	jl     4345f <program_load+0xaf>
            }
        }
    }

    // set the entry point from the ELF header
    p->p_registers.reg_rip = eh->e_entry;
   43507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4350b:	48 8b 50 18          	mov    0x18(%rax),%rdx
   4350f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43513:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    return 0;
   4351a:	b8 00 00 00 00       	mov    $0x0,%eax
}
   4351f:	c9                   	leave  
   43520:	c3                   	ret    

0000000000043521 <program_load_segment>:
//    `[ph->p_va + ph->p_filesz, ph->p_va + ph->p_memsz)` to 0.
//    Calls `assign_physical_page` to allocate pages and `virtual_memory_map`
//    to map them in `p->p_pagetable`. Returns 0 on success and -1 on failure.
static int program_load_segment(proc* p, const elf_program* ph,
                                const uint8_t* src,
                                x86_64_pagetable* (*allocator)(void)) {
   43521:	f3 0f 1e fa          	endbr64 
   43525:	55                   	push   %rbp
   43526:	48 89 e5             	mov    %rsp,%rbp
   43529:	48 83 ec 40          	sub    $0x40,%rsp
   4352d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   43531:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   43535:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
   43539:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    uintptr_t va = (uintptr_t) ph->p_va;
   4353d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   43541:	48 8b 40 10          	mov    0x10(%rax),%rax
   43545:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    uintptr_t end_file = va + ph->p_filesz, end_mem = va + ph->p_memsz;
   43549:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   4354d:	48 8b 50 20          	mov    0x20(%rax),%rdx
   43551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43555:	48 01 d0             	add    %rdx,%rax
   43558:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   4355c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   43560:	48 8b 50 28          	mov    0x28(%rax),%rdx
   43564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43568:	48 01 d0             	add    %rdx,%rax
   4356b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    va &= ~(PAGESIZE - 1);                // round to page boundary
   4356f:	48 81 65 f0 00 f0 ff 	andq   $0xfffffffffffff000,-0x10(%rbp)
   43576:	ff 

    // allocate memory
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   43577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4357b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   4357f:	e9 8f 00 00 00       	jmp    43613 <program_load_segment+0xf2>
        if (assign_physical_page(addr, p->p_pid) < 0
   43584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43588:	8b 00                	mov    (%rax),%eax
   4358a:	0f be d0             	movsbl %al,%edx
   4358d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43591:	89 d6                	mov    %edx,%esi
   43593:	48 89 c7             	mov    %rax,%rdi
   43596:	e8 d6 d3 ff ff       	call   40971 <assign_physical_page>
   4359b:	85 c0                	test   %eax,%eax
   4359d:	78 31                	js     435d0 <program_load_segment+0xaf>
            || virtual_memory_map(p->p_pagetable, addr, addr, PAGESIZE,
   4359f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   435a3:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   435aa:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
   435ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   435b2:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   435b6:	49 89 c9             	mov    %rcx,%r9
   435b9:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   435bf:	b9 00 10 00 00       	mov    $0x1000,%ecx
   435c4:	48 89 c7             	mov    %rax,%rdi
   435c7:	e8 f0 ec ff ff       	call   422bc <virtual_memory_map>
   435cc:	85 c0                	test   %eax,%eax
   435ce:	79 3b                	jns    4360b <program_load_segment+0xea>
                                  PTE_P | PTE_W | PTE_U, allocator) < 0) {
            // console_printf(CPOS(22, 0), 0xC000, "program_load_segment(pid %d): can't assign address %p\n", p->p_pid, addr);
            console_printf(CPOS(22, 0), 0xC000, "program_load_segment(pid %d): can't assign address %p, with va: %p\n", p->p_pid, addr, va);
   435d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   435d4:	8b 00                	mov    (%rax),%eax
   435d6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
   435da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   435de:	49 89 c9             	mov    %rcx,%r9
   435e1:	49 89 d0             	mov    %rdx,%r8
   435e4:	89 c1                	mov    %eax,%ecx
   435e6:	48 8d 05 8b 14 00 00 	lea    0x148b(%rip),%rax        # 44a78 <complex_keymap+0x118>
   435ed:	48 89 c2             	mov    %rax,%rdx
   435f0:	be 00 c0 00 00       	mov    $0xc000,%esi
   435f5:	bf e0 06 00 00       	mov    $0x6e0,%edi
   435fa:	b8 00 00 00 00       	mov    $0x0,%eax
   435ff:	e8 1f 0a 00 00       	call   44023 <console_printf>
            return -1;
   43604:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43609:	eb 77                	jmp    43682 <program_load_segment+0x161>
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   4360b:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   43612:	00 
   43613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43617:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
   4361b:	0f 82 63 ff ff ff    	jb     43584 <program_load_segment+0x63>
        }
    }

    // ensure new memory mappings are active
    set_pagetable(p->p_pagetable);
   43621:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43625:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   4362c:	48 89 c7             	mov    %rax,%rdi
   4362f:	e8 f6 f1 ff ff       	call   4282a <set_pagetable>

    // copy data from executable image into process memory
    memcpy((uint8_t*) va, src, end_file - va);
   43634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43638:	48 2b 45 f0          	sub    -0x10(%rbp),%rax
   4363c:	48 89 c2             	mov    %rax,%rdx
   4363f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43643:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   43647:	48 89 ce             	mov    %rcx,%rsi
   4364a:	48 89 c7             	mov    %rax,%rdi
   4364d:	e8 df 00 00 00       	call   43731 <memcpy>
    memset((uint8_t*) end_file, 0, end_mem - end_file);
   43652:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43656:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
   4365a:	48 89 c2             	mov    %rax,%rdx
   4365d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43661:	be 00 00 00 00       	mov    $0x0,%esi
   43666:	48 89 c7             	mov    %rax,%rdi
   43669:	e8 34 01 00 00       	call   437a2 <memset>

    // restore kernel pagetable
    set_pagetable(kernel_pagetable);
   4366e:	48 8b 05 8b 19 01 00 	mov    0x1198b(%rip),%rax        # 55000 <kernel_pagetable>
   43675:	48 89 c7             	mov    %rax,%rdi
   43678:	e8 ad f1 ff ff       	call   4282a <set_pagetable>
    //             virtual_memory_map(p->p_pagetable, addr, mapping.pa, PAGESIZE, PTE_P | PTE_U, allocator);
    //         }
    //     }
    // }

    return 0;
   4367d:	b8 00 00 00 00       	mov    $0x0,%eax
}
   43682:	c9                   	leave  
   43683:	c3                   	ret    

0000000000043684 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
   43684:	f3 0f 1e fa          	endbr64 
   43688:	48 89 f9             	mov    %rdi,%rcx
   4368b:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
   4368d:	48 8d 05 0c 59 07 00 	lea    0x7590c(%rip),%rax        # b8fa0 <console+0xfa0>
   43694:	48 39 41 08          	cmp    %rax,0x8(%rcx)
   43698:	72 0b                	jb     436a5 <console_putc+0x21>
        cp->cursor = console;
   4369a:	48 8d 80 60 f0 ff ff 	lea    -0xfa0(%rax),%rax
   436a1:	48 89 41 08          	mov    %rax,0x8(%rcx)
    }
    if (c == '\n') {
   436a5:	40 80 fe 0a          	cmp    $0xa,%sil
   436a9:	74 16                	je     436c1 <console_putc+0x3d>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
   436ab:	48 8b 41 08          	mov    0x8(%rcx),%rax
   436af:	48 8d 50 02          	lea    0x2(%rax),%rdx
   436b3:	48 89 51 08          	mov    %rdx,0x8(%rcx)
   436b7:	40 0f b6 f6          	movzbl %sil,%esi
   436bb:	09 fe                	or     %edi,%esi
   436bd:	66 89 30             	mov    %si,(%rax)
    }
}
   436c0:	c3                   	ret    
        int pos = (cp->cursor - console) % 80;
   436c1:	48 8d 05 38 49 07 00 	lea    0x74938(%rip),%rax        # b8000 <console>
   436c8:	4c 8b 41 08          	mov    0x8(%rcx),%r8
   436cc:	49 29 c0             	sub    %rax,%r8
   436cf:	4c 89 c6             	mov    %r8,%rsi
   436d2:	48 d1 fe             	sar    %rsi
   436d5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
   436dc:	66 66 66 
   436df:	48 89 f0             	mov    %rsi,%rax
   436e2:	48 f7 ea             	imul   %rdx
   436e5:	48 c1 fa 05          	sar    $0x5,%rdx
   436e9:	49 c1 f8 3f          	sar    $0x3f,%r8
   436ed:	4c 29 c2             	sub    %r8,%rdx
   436f0:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
   436f4:	48 c1 e2 04          	shl    $0x4,%rdx
   436f8:	89 f0                	mov    %esi,%eax
   436fa:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
   436fc:	83 cf 20             	or     $0x20,%edi
   436ff:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43703:	48 8d 72 02          	lea    0x2(%rdx),%rsi
   43707:	48 89 71 08          	mov    %rsi,0x8(%rcx)
   4370b:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
   4370e:	83 c0 01             	add    $0x1,%eax
   43711:	83 f8 50             	cmp    $0x50,%eax
   43714:	75 e9                	jne    436ff <console_putc+0x7b>
   43716:	c3                   	ret    

0000000000043717 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
   43717:	f3 0f 1e fa          	endbr64 
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
   4371b:	48 8b 47 08          	mov    0x8(%rdi),%rax
   4371f:	48 3b 47 10          	cmp    0x10(%rdi),%rax
   43723:	73 0b                	jae    43730 <string_putc+0x19>
        *sp->s++ = c;
   43725:	48 8d 50 01          	lea    0x1(%rax),%rdx
   43729:	48 89 57 08          	mov    %rdx,0x8(%rdi)
   4372d:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
   43730:	c3                   	ret    

0000000000043731 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
   43731:	f3 0f 1e fa          	endbr64 
   43735:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   43738:	48 85 d2             	test   %rdx,%rdx
   4373b:	74 17                	je     43754 <memcpy+0x23>
   4373d:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
   43742:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
   43747:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   4374b:	48 83 c1 01          	add    $0x1,%rcx
   4374f:	48 39 d1             	cmp    %rdx,%rcx
   43752:	75 ee                	jne    43742 <memcpy+0x11>
}
   43754:	c3                   	ret    

0000000000043755 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
   43755:	f3 0f 1e fa          	endbr64 
   43759:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
   4375c:	48 39 fe             	cmp    %rdi,%rsi
   4375f:	72 1d                	jb     4377e <memmove+0x29>
        while (n-- > 0) {
   43761:	b9 00 00 00 00       	mov    $0x0,%ecx
   43766:	48 85 d2             	test   %rdx,%rdx
   43769:	74 12                	je     4377d <memmove+0x28>
            *d++ = *s++;
   4376b:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
   4376f:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
   43773:	48 83 c1 01          	add    $0x1,%rcx
   43777:	48 39 ca             	cmp    %rcx,%rdx
   4377a:	75 ef                	jne    4376b <memmove+0x16>
}
   4377c:	c3                   	ret    
   4377d:	c3                   	ret    
    if (s < d && s + n > d) {
   4377e:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
   43782:	48 39 cf             	cmp    %rcx,%rdi
   43785:	73 da                	jae    43761 <memmove+0xc>
        while (n-- > 0) {
   43787:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
   4378b:	48 85 d2             	test   %rdx,%rdx
   4378e:	74 ec                	je     4377c <memmove+0x27>
            *--d = *--s;
   43790:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
   43794:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
   43797:	48 83 e9 01          	sub    $0x1,%rcx
   4379b:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
   4379f:	75 ef                	jne    43790 <memmove+0x3b>
   437a1:	c3                   	ret    

00000000000437a2 <memset>:
void* memset(void* v, int c, size_t n) {
   437a2:	f3 0f 1e fa          	endbr64 
   437a6:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
   437a9:	48 85 d2             	test   %rdx,%rdx
   437ac:	74 12                	je     437c0 <memset+0x1e>
   437ae:	48 01 fa             	add    %rdi,%rdx
   437b1:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
   437b4:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
   437b7:	48 83 c1 01          	add    $0x1,%rcx
   437bb:	48 39 ca             	cmp    %rcx,%rdx
   437be:	75 f4                	jne    437b4 <memset+0x12>
}
   437c0:	c3                   	ret    

00000000000437c1 <strlen>:
size_t strlen(const char* s) {
   437c1:	f3 0f 1e fa          	endbr64 
    for (n = 0; *s != '\0'; ++s) {
   437c5:	80 3f 00             	cmpb   $0x0,(%rdi)
   437c8:	74 10                	je     437da <strlen+0x19>
   437ca:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
   437cf:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
   437d3:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
   437d7:	75 f6                	jne    437cf <strlen+0xe>
   437d9:	c3                   	ret    
   437da:	b8 00 00 00 00       	mov    $0x0,%eax
}
   437df:	c3                   	ret    

00000000000437e0 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
   437e0:	f3 0f 1e fa          	endbr64 
   437e4:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   437e7:	ba 00 00 00 00       	mov    $0x0,%edx
   437ec:	48 85 f6             	test   %rsi,%rsi
   437ef:	74 11                	je     43802 <strnlen+0x22>
   437f1:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
   437f5:	74 0c                	je     43803 <strnlen+0x23>
        ++n;
   437f7:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   437fb:	48 39 d0             	cmp    %rdx,%rax
   437fe:	75 f1                	jne    437f1 <strnlen+0x11>
   43800:	eb 04                	jmp    43806 <strnlen+0x26>
   43802:	c3                   	ret    
   43803:	48 89 d0             	mov    %rdx,%rax
}
   43806:	c3                   	ret    

0000000000043807 <strcpy>:
char* strcpy(char* dst, const char* src) {
   43807:	f3 0f 1e fa          	endbr64 
   4380b:	48 89 f8             	mov    %rdi,%rax
   4380e:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
   43813:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
   43817:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
   4381a:	48 83 c2 01          	add    $0x1,%rdx
   4381e:	84 c9                	test   %cl,%cl
   43820:	75 f1                	jne    43813 <strcpy+0xc>
}
   43822:	c3                   	ret    

0000000000043823 <strcmp>:
int strcmp(const char* a, const char* b) {
   43823:	f3 0f 1e fa          	endbr64 
    while (*a && *b && *a == *b) {
   43827:	0f b6 07             	movzbl (%rdi),%eax
   4382a:	84 c0                	test   %al,%al
   4382c:	74 1a                	je     43848 <strcmp+0x25>
   4382e:	0f b6 16             	movzbl (%rsi),%edx
   43831:	38 c2                	cmp    %al,%dl
   43833:	75 13                	jne    43848 <strcmp+0x25>
   43835:	84 d2                	test   %dl,%dl
   43837:	74 0f                	je     43848 <strcmp+0x25>
        ++a, ++b;
   43839:	48 83 c7 01          	add    $0x1,%rdi
   4383d:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
   43841:	0f b6 07             	movzbl (%rdi),%eax
   43844:	84 c0                	test   %al,%al
   43846:	75 e6                	jne    4382e <strcmp+0xb>
    return ((unsigned char) *a > (unsigned char) *b)
   43848:	3a 06                	cmp    (%rsi),%al
   4384a:	0f 97 c0             	seta   %al
   4384d:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
   43850:	83 d8 00             	sbb    $0x0,%eax
}
   43853:	c3                   	ret    

0000000000043854 <strchr>:
char* strchr(const char* s, int c) {
   43854:	f3 0f 1e fa          	endbr64 
    while (*s && *s != (char) c) {
   43858:	0f b6 07             	movzbl (%rdi),%eax
   4385b:	84 c0                	test   %al,%al
   4385d:	74 10                	je     4386f <strchr+0x1b>
   4385f:	40 38 f0             	cmp    %sil,%al
   43862:	74 18                	je     4387c <strchr+0x28>
        ++s;
   43864:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
   43868:	0f b6 07             	movzbl (%rdi),%eax
   4386b:	84 c0                	test   %al,%al
   4386d:	75 f0                	jne    4385f <strchr+0xb>
        return NULL;
   4386f:	40 84 f6             	test   %sil,%sil
   43872:	b8 00 00 00 00       	mov    $0x0,%eax
   43877:	48 0f 44 c7          	cmove  %rdi,%rax
}
   4387b:	c3                   	ret    
   4387c:	48 89 f8             	mov    %rdi,%rax
   4387f:	c3                   	ret    

0000000000043880 <rand>:
int rand(void) {
   43880:	f3 0f 1e fa          	endbr64 
    if (!rand_seed_set) {
   43884:	83 3d 81 87 01 00 00 	cmpl   $0x0,0x18781(%rip)        # 5c00c <rand_seed_set>
   4388b:	74 1b                	je     438a8 <rand+0x28>
    rand_seed = rand_seed * 1664525U + 1013904223U;
   4388d:	69 05 71 87 01 00 0d 	imul   $0x19660d,0x18771(%rip),%eax        # 5c008 <rand_seed>
   43894:	66 19 00 
   43897:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
   4389c:	89 05 66 87 01 00    	mov    %eax,0x18766(%rip)        # 5c008 <rand_seed>
    return rand_seed & RAND_MAX;
   438a2:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
   438a7:	c3                   	ret    
    rand_seed = seed;
   438a8:	c7 05 56 87 01 00 9e 	movl   $0x30d4879e,0x18756(%rip)        # 5c008 <rand_seed>
   438af:	87 d4 30 
    rand_seed_set = 1;
   438b2:	c7 05 50 87 01 00 01 	movl   $0x1,0x18750(%rip)        # 5c00c <rand_seed_set>
   438b9:	00 00 00 
}
   438bc:	eb cf                	jmp    4388d <rand+0xd>

00000000000438be <srand>:
void srand(unsigned seed) {
   438be:	f3 0f 1e fa          	endbr64 
    rand_seed = seed;
   438c2:	89 3d 40 87 01 00    	mov    %edi,0x18740(%rip)        # 5c008 <rand_seed>
    rand_seed_set = 1;
   438c8:	c7 05 3a 87 01 00 01 	movl   $0x1,0x1873a(%rip)        # 5c00c <rand_seed_set>
   438cf:	00 00 00 
}
   438d2:	c3                   	ret    

00000000000438d3 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
   438d3:	f3 0f 1e fa          	endbr64 
   438d7:	55                   	push   %rbp
   438d8:	48 89 e5             	mov    %rsp,%rbp
   438db:	41 57                	push   %r15
   438dd:	41 56                	push   %r14
   438df:	41 55                	push   %r13
   438e1:	41 54                	push   %r12
   438e3:	53                   	push   %rbx
   438e4:	48 83 ec 58          	sub    $0x58,%rsp
   438e8:	49 89 fe             	mov    %rdi,%r14
   438eb:	89 75 ac             	mov    %esi,-0x54(%rbp)
   438ee:	49 89 d4             	mov    %rdx,%r12
   438f1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
   438f5:	0f b6 02             	movzbl (%rdx),%eax
   438f8:	84 c0                	test   %al,%al
   438fa:	0f 85 cd 04 00 00    	jne    43dcd <printer_vprintf+0x4fa>
}
   43900:	48 83 c4 58          	add    $0x58,%rsp
   43904:	5b                   	pop    %rbx
   43905:	41 5c                	pop    %r12
   43907:	41 5d                	pop    %r13
   43909:	41 5e                	pop    %r14
   4390b:	41 5f                	pop    %r15
   4390d:	5d                   	pop    %rbp
   4390e:	c3                   	ret    
        for (++format; *format; ++format) {
   4390f:	4d 8d 7c 24 01       	lea    0x1(%r12),%r15
   43914:	41 0f b6 5c 24 01    	movzbl 0x1(%r12),%ebx
   4391a:	84 db                	test   %bl,%bl
   4391c:	0f 84 a4 06 00 00    	je     43fc6 <printer_vprintf+0x6f3>
        int flags = 0;
   43922:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
   43928:	4c 8d 25 b2 12 00 00 	lea    0x12b2(%rip),%r12        # 44be1 <flag_chars>
   4392f:	0f be f3             	movsbl %bl,%esi
   43932:	4c 89 e7             	mov    %r12,%rdi
   43935:	e8 1a ff ff ff       	call   43854 <strchr>
   4393a:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
   4393d:	48 85 c0             	test   %rax,%rax
   43940:	74 5c                	je     4399e <printer_vprintf+0xcb>
                flags |= 1 << (flagc - flag_chars);
   43942:	4c 29 e1             	sub    %r12,%rcx
   43945:	b8 01 00 00 00       	mov    $0x1,%eax
   4394a:	d3 e0                	shl    %cl,%eax
   4394c:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
   4394f:	49 83 c7 01          	add    $0x1,%r15
   43953:	41 0f b6 1f          	movzbl (%r15),%ebx
   43957:	84 db                	test   %bl,%bl
   43959:	75 d4                	jne    4392f <printer_vprintf+0x5c>
   4395b:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
        int width = -1;
   4395f:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
   43965:	c7 45 a8 ff ff ff ff 	movl   $0xffffffff,-0x58(%rbp)
        if (*format == '.') {
   4396c:	41 80 3f 2e          	cmpb   $0x2e,(%r15)
   43970:	0f 84 b3 00 00 00    	je     43a29 <printer_vprintf+0x156>
        int length = 0;
   43976:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
   4397b:	41 0f b6 17          	movzbl (%r15),%edx
   4397f:	8d 42 bd             	lea    -0x43(%rdx),%eax
   43982:	3c 37                	cmp    $0x37,%al
   43984:	0f 87 e0 04 00 00    	ja     43e6a <printer_vprintf+0x597>
   4398a:	0f b6 c0             	movzbl %al,%eax
   4398d:	48 8d 3d 3c 11 00 00 	lea    0x113c(%rip),%rdi        # 44ad0 <complex_keymap+0x170>
   43994:	48 63 04 87          	movslq (%rdi,%rax,4),%rax
   43998:	48 01 f8             	add    %rdi,%rax
   4399b:	3e ff e0             	notrack jmp *%rax
        if (*format >= '1' && *format <= '9') {
   4399e:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
   439a2:	8d 43 cf             	lea    -0x31(%rbx),%eax
   439a5:	3c 08                	cmp    $0x8,%al
   439a7:	77 31                	ja     439da <printer_vprintf+0x107>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   439a9:	41 0f b6 07          	movzbl (%r15),%eax
   439ad:	8d 50 d0             	lea    -0x30(%rax),%edx
   439b0:	80 fa 09             	cmp    $0x9,%dl
   439b3:	77 5e                	ja     43a13 <printer_vprintf+0x140>
   439b5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
   439bb:	49 83 c7 01          	add    $0x1,%r15
   439bf:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
   439c4:	0f be c0             	movsbl %al,%eax
   439c7:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   439cc:	41 0f b6 07          	movzbl (%r15),%eax
   439d0:	8d 50 d0             	lea    -0x30(%rax),%edx
   439d3:	80 fa 09             	cmp    $0x9,%dl
   439d6:	76 e3                	jbe    439bb <printer_vprintf+0xe8>
   439d8:	eb 8b                	jmp    43965 <printer_vprintf+0x92>
        } else if (*format == '*') {
   439da:	80 fb 2a             	cmp    $0x2a,%bl
   439dd:	75 3f                	jne    43a1e <printer_vprintf+0x14b>
            width = va_arg(val, int);
   439df:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   439e3:	8b 07                	mov    (%rdi),%eax
   439e5:	83 f8 2f             	cmp    $0x2f,%eax
   439e8:	77 17                	ja     43a01 <printer_vprintf+0x12e>
   439ea:	89 c2                	mov    %eax,%edx
   439ec:	48 03 57 10          	add    0x10(%rdi),%rdx
   439f0:	83 c0 08             	add    $0x8,%eax
   439f3:	89 07                	mov    %eax,(%rdi)
   439f5:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
   439f8:	49 83 c7 01          	add    $0x1,%r15
   439fc:	e9 64 ff ff ff       	jmp    43965 <printer_vprintf+0x92>
            width = va_arg(val, int);
   43a01:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43a05:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43a09:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43a0d:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43a11:	eb e2                	jmp    439f5 <printer_vprintf+0x122>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   43a13:	41 bd 00 00 00 00    	mov    $0x0,%r13d
   43a19:	e9 47 ff ff ff       	jmp    43965 <printer_vprintf+0x92>
        int width = -1;
   43a1e:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
   43a24:	e9 3c ff ff ff       	jmp    43965 <printer_vprintf+0x92>
            ++format;
   43a29:	49 8d 57 01          	lea    0x1(%r15),%rdx
            if (*format >= '0' && *format <= '9') {
   43a2d:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
   43a32:	8d 48 d0             	lea    -0x30(%rax),%ecx
   43a35:	80 f9 09             	cmp    $0x9,%cl
   43a38:	76 13                	jbe    43a4d <printer_vprintf+0x17a>
            } else if (*format == '*') {
   43a3a:	3c 2a                	cmp    $0x2a,%al
   43a3c:	74 33                	je     43a71 <printer_vprintf+0x19e>
            ++format;
   43a3e:	49 89 d7             	mov    %rdx,%r15
                precision = 0;
   43a41:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
   43a48:	e9 29 ff ff ff       	jmp    43976 <printer_vprintf+0xa3>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   43a4d:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
   43a52:	48 83 c2 01          	add    $0x1,%rdx
   43a56:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
   43a59:	0f be c0             	movsbl %al,%eax
   43a5c:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   43a60:	0f b6 02             	movzbl (%rdx),%eax
   43a63:	8d 70 d0             	lea    -0x30(%rax),%esi
   43a66:	40 80 fe 09          	cmp    $0x9,%sil
   43a6a:	76 e6                	jbe    43a52 <printer_vprintf+0x17f>
                    precision = 10 * precision + *format++ - '0';
   43a6c:	49 89 d7             	mov    %rdx,%r15
   43a6f:	eb 1c                	jmp    43a8d <printer_vprintf+0x1ba>
                precision = va_arg(val, int);
   43a71:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43a75:	8b 01                	mov    (%rcx),%eax
   43a77:	83 f8 2f             	cmp    $0x2f,%eax
   43a7a:	77 23                	ja     43a9f <printer_vprintf+0x1cc>
   43a7c:	89 c2                	mov    %eax,%edx
   43a7e:	48 03 51 10          	add    0x10(%rcx),%rdx
   43a82:	83 c0 08             	add    $0x8,%eax
   43a85:	89 01                	mov    %eax,(%rcx)
   43a87:	8b 0a                	mov    (%rdx),%ecx
                ++format;
   43a89:	49 83 c7 02          	add    $0x2,%r15
            if (precision < 0) {
   43a8d:	85 c9                	test   %ecx,%ecx
   43a8f:	b8 00 00 00 00       	mov    $0x0,%eax
   43a94:	0f 49 c1             	cmovns %ecx,%eax
   43a97:	89 45 a8             	mov    %eax,-0x58(%rbp)
   43a9a:	e9 d7 fe ff ff       	jmp    43976 <printer_vprintf+0xa3>
                precision = va_arg(val, int);
   43a9f:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43aa3:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43aa7:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43aab:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43aaf:	eb d6                	jmp    43a87 <printer_vprintf+0x1b4>
        switch (*format) {
   43ab1:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
   43ab6:	e9 f6 00 00 00       	jmp    43bb1 <printer_vprintf+0x2de>
            ++format;
   43abb:	49 83 c7 01          	add    $0x1,%r15
            length = 1;
   43abf:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
   43ac4:	e9 b2 fe ff ff       	jmp    4397b <printer_vprintf+0xa8>
            long x = length ? va_arg(val, long) : va_arg(val, int);
   43ac9:	85 c9                	test   %ecx,%ecx
   43acb:	74 56                	je     43b23 <printer_vprintf+0x250>
   43acd:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43ad1:	8b 07                	mov    (%rdi),%eax
   43ad3:	83 f8 2f             	cmp    $0x2f,%eax
   43ad6:	77 39                	ja     43b11 <printer_vprintf+0x23e>
   43ad8:	89 c2                	mov    %eax,%edx
   43ada:	48 03 57 10          	add    0x10(%rdi),%rdx
   43ade:	83 c0 08             	add    $0x8,%eax
   43ae1:	89 07                	mov    %eax,(%rdi)
   43ae3:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
   43ae6:	48 89 d0             	mov    %rdx,%rax
   43ae9:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
   43aed:	49 89 d0             	mov    %rdx,%r8
   43af0:	49 f7 d8             	neg    %r8
   43af3:	25 80 00 00 00       	and    $0x80,%eax
   43af8:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
   43afc:	0b 45 a0             	or     -0x60(%rbp),%eax
   43aff:	83 c8 60             	or     $0x60,%eax
   43b02:	89 45 a0             	mov    %eax,-0x60(%rbp)
        char* data = "";
   43b05:	4c 8d 25 b8 0f 00 00 	lea    0xfb8(%rip),%r12        # 44ac4 <complex_keymap+0x164>
            break;
   43b0c:	e9 39 01 00 00       	jmp    43c4a <printer_vprintf+0x377>
            long x = length ? va_arg(val, long) : va_arg(val, int);
   43b11:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43b15:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43b19:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43b1d:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43b21:	eb c0                	jmp    43ae3 <printer_vprintf+0x210>
   43b23:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43b27:	8b 01                	mov    (%rcx),%eax
   43b29:	83 f8 2f             	cmp    $0x2f,%eax
   43b2c:	77 10                	ja     43b3e <printer_vprintf+0x26b>
   43b2e:	89 c2                	mov    %eax,%edx
   43b30:	48 03 51 10          	add    0x10(%rcx),%rdx
   43b34:	83 c0 08             	add    $0x8,%eax
   43b37:	89 01                	mov    %eax,(%rcx)
   43b39:	48 63 12             	movslq (%rdx),%rdx
   43b3c:	eb a8                	jmp    43ae6 <printer_vprintf+0x213>
   43b3e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43b42:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43b46:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43b4a:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43b4e:	eb e9                	jmp    43b39 <printer_vprintf+0x266>
        int base = 10;
   43b50:	be 0a 00 00 00       	mov    $0xa,%esi
   43b55:	eb 5a                	jmp    43bb1 <printer_vprintf+0x2de>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   43b57:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43b5b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43b5f:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43b63:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43b67:	eb 62                	jmp    43bcb <printer_vprintf+0x2f8>
   43b69:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43b6d:	8b 07                	mov    (%rdi),%eax
   43b6f:	83 f8 2f             	cmp    $0x2f,%eax
   43b72:	77 10                	ja     43b84 <printer_vprintf+0x2b1>
   43b74:	89 c2                	mov    %eax,%edx
   43b76:	48 03 57 10          	add    0x10(%rdi),%rdx
   43b7a:	83 c0 08             	add    $0x8,%eax
   43b7d:	89 07                	mov    %eax,(%rdi)
   43b7f:	44 8b 02             	mov    (%rdx),%r8d
   43b82:	eb 4a                	jmp    43bce <printer_vprintf+0x2fb>
   43b84:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43b88:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43b8c:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43b90:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43b94:	eb e9                	jmp    43b7f <printer_vprintf+0x2ac>
   43b96:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
   43b99:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
    const char* digits = upper_digits;
   43ba0:	48 8d 3d 29 10 00 00 	lea    0x1029(%rip),%rdi        # 44bd0 <upper_digits.1>
   43ba7:	e9 f3 02 00 00       	jmp    43e9f <printer_vprintf+0x5cc>
            base = 16;
   43bac:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   43bb1:	85 c9                	test   %ecx,%ecx
   43bb3:	74 b4                	je     43b69 <printer_vprintf+0x296>
   43bb5:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43bb9:	8b 01                	mov    (%rcx),%eax
   43bbb:	83 f8 2f             	cmp    $0x2f,%eax
   43bbe:	77 97                	ja     43b57 <printer_vprintf+0x284>
   43bc0:	89 c2                	mov    %eax,%edx
   43bc2:	48 03 51 10          	add    0x10(%rcx),%rdx
   43bc6:	83 c0 08             	add    $0x8,%eax
   43bc9:	89 01                	mov    %eax,(%rcx)
   43bcb:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
   43bce:	83 4d a0 20          	orl    $0x20,-0x60(%rbp)
    if (base < 0) {
   43bd2:	85 f6                	test   %esi,%esi
   43bd4:	79 c0                	jns    43b96 <printer_vprintf+0x2c3>
        base = -base;
   43bd6:	41 89 f1             	mov    %esi,%r9d
   43bd9:	f7 de                	neg    %esi
   43bdb:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
        digits = lower_digits;
   43be2:	48 8d 3d c7 0f 00 00 	lea    0xfc7(%rip),%rdi        # 44bb0 <lower_digits.0>
   43be9:	e9 b1 02 00 00       	jmp    43e9f <printer_vprintf+0x5cc>
            num = (uintptr_t) va_arg(val, void*);
   43bee:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43bf2:	8b 01                	mov    (%rcx),%eax
   43bf4:	83 f8 2f             	cmp    $0x2f,%eax
   43bf7:	77 1c                	ja     43c15 <printer_vprintf+0x342>
   43bf9:	89 c2                	mov    %eax,%edx
   43bfb:	48 03 51 10          	add    0x10(%rcx),%rdx
   43bff:	83 c0 08             	add    $0x8,%eax
   43c02:	89 01                	mov    %eax,(%rcx)
   43c04:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
   43c07:	81 4d a0 21 01 00 00 	orl    $0x121,-0x60(%rbp)
            base = -16;
   43c0e:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
   43c13:	eb c1                	jmp    43bd6 <printer_vprintf+0x303>
            num = (uintptr_t) va_arg(val, void*);
   43c15:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43c19:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43c1d:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43c21:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43c25:	eb dd                	jmp    43c04 <printer_vprintf+0x331>
            data = va_arg(val, char*);
   43c27:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43c2b:	8b 07                	mov    (%rdi),%eax
   43c2d:	83 f8 2f             	cmp    $0x2f,%eax
   43c30:	0f 87 b0 01 00 00    	ja     43de6 <printer_vprintf+0x513>
   43c36:	89 c2                	mov    %eax,%edx
   43c38:	48 03 57 10          	add    0x10(%rdi),%rdx
   43c3c:	83 c0 08             	add    $0x8,%eax
   43c3f:	89 07                	mov    %eax,(%rdi)
   43c41:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
   43c44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
   43c4a:	8b 45 a0             	mov    -0x60(%rbp),%eax
   43c4d:	83 e0 20             	and    $0x20,%eax
   43c50:	89 45 98             	mov    %eax,-0x68(%rbp)
   43c53:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
   43c59:	0f 85 2e 02 00 00    	jne    43e8d <printer_vprintf+0x5ba>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
   43c5f:	8b 45 a0             	mov    -0x60(%rbp),%eax
   43c62:	89 45 8c             	mov    %eax,-0x74(%rbp)
   43c65:	83 e0 60             	and    $0x60,%eax
   43c68:	83 f8 60             	cmp    $0x60,%eax
   43c6b:	0f 84 63 02 00 00    	je     43ed4 <printer_vprintf+0x601>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   43c71:	8b 45 a0             	mov    -0x60(%rbp),%eax
   43c74:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
   43c77:	48 8d 1d 46 0e 00 00 	lea    0xe46(%rip),%rbx        # 44ac4 <complex_keymap+0x164>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   43c7e:	83 f8 21             	cmp    $0x21,%eax
   43c81:	0f 84 8a 02 00 00    	je     43f11 <printer_vprintf+0x63e>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
   43c87:	8b 7d a8             	mov    -0x58(%rbp),%edi
   43c8a:	89 f8                	mov    %edi,%eax
   43c8c:	f7 d0                	not    %eax
   43c8e:	c1 e8 1f             	shr    $0x1f,%eax
   43c91:	89 45 88             	mov    %eax,-0x78(%rbp)
   43c94:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
   43c98:	0f 85 b2 02 00 00    	jne    43f50 <printer_vprintf+0x67d>
   43c9e:	84 c0                	test   %al,%al
   43ca0:	0f 84 aa 02 00 00    	je     43f50 <printer_vprintf+0x67d>
            len = strnlen(data, precision);
   43ca6:	48 63 f7             	movslq %edi,%rsi
   43ca9:	4c 89 e7             	mov    %r12,%rdi
   43cac:	e8 2f fb ff ff       	call   437e0 <strnlen>
   43cb1:	89 45 9c             	mov    %eax,-0x64(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
   43cb4:	8b 45 8c             	mov    -0x74(%rbp),%eax
   43cb7:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
   43cba:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
   43cc1:	83 f8 22             	cmp    $0x22,%eax
   43cc4:	0f 84 be 02 00 00    	je     43f88 <printer_vprintf+0x6b5>
        width -= len + zeros + strlen(prefix);
   43cca:	48 89 df             	mov    %rbx,%rdi
   43ccd:	e8 ef fa ff ff       	call   437c1 <strlen>
   43cd2:	8b 55 a8             	mov    -0x58(%rbp),%edx
   43cd5:	03 55 9c             	add    -0x64(%rbp),%edx
   43cd8:	44 89 e9             	mov    %r13d,%ecx
   43cdb:	29 d1                	sub    %edx,%ecx
   43cdd:	29 c1                	sub    %eax,%ecx
   43cdf:	89 4d 98             	mov    %ecx,-0x68(%rbp)
   43ce2:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   43ce5:	f6 45 a0 04          	testb  $0x4,-0x60(%rbp)
   43ce9:	75 37                	jne    43d22 <printer_vprintf+0x44f>
   43ceb:	85 c9                	test   %ecx,%ecx
   43ced:	7e 33                	jle    43d22 <printer_vprintf+0x44f>
        width -= len + zeros + strlen(prefix);
   43cef:	48 89 5d a0          	mov    %rbx,-0x60(%rbp)
   43cf3:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
   43cf6:	89 da                	mov    %ebx,%edx
   43cf8:	be 20 00 00 00       	mov    $0x20,%esi
   43cfd:	4c 89 f7             	mov    %r14,%rdi
   43d00:	41 ff 16             	call   *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   43d03:	41 83 ed 01          	sub    $0x1,%r13d
   43d07:	45 85 ed             	test   %r13d,%r13d
   43d0a:	7f ea                	jg     43cf6 <printer_vprintf+0x423>
   43d0c:	48 8b 5d a0          	mov    -0x60(%rbp),%rbx
   43d10:	8b 7d 98             	mov    -0x68(%rbp),%edi
   43d13:	85 ff                	test   %edi,%edi
   43d15:	b8 01 00 00 00       	mov    $0x1,%eax
   43d1a:	0f 4f c7             	cmovg  %edi,%eax
   43d1d:	29 c7                	sub    %eax,%edi
   43d1f:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
   43d22:	0f b6 03             	movzbl (%rbx),%eax
   43d25:	84 c0                	test   %al,%al
   43d27:	74 23                	je     43d4c <printer_vprintf+0x479>
   43d29:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
   43d2d:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, *prefix, color);
   43d31:	0f b6 f0             	movzbl %al,%esi
   43d34:	44 89 e2             	mov    %r12d,%edx
   43d37:	4c 89 f7             	mov    %r14,%rdi
   43d3a:	41 ff 16             	call   *(%r14)
        for (; *prefix; ++prefix) {
   43d3d:	48 83 c3 01          	add    $0x1,%rbx
   43d41:	0f b6 03             	movzbl (%rbx),%eax
   43d44:	84 c0                	test   %al,%al
   43d46:	75 e9                	jne    43d31 <printer_vprintf+0x45e>
   43d48:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; zeros > 0; --zeros) {
   43d4c:	8b 5d a8             	mov    -0x58(%rbp),%ebx
   43d4f:	85 db                	test   %ebx,%ebx
   43d51:	7e 1f                	jle    43d72 <printer_vprintf+0x49f>
   43d53:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
   43d57:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, '0', color);
   43d5b:	44 89 e2             	mov    %r12d,%edx
   43d5e:	be 30 00 00 00       	mov    $0x30,%esi
   43d63:	4c 89 f7             	mov    %r14,%rdi
   43d66:	41 ff 16             	call   *(%r14)
        for (; zeros > 0; --zeros) {
   43d69:	83 eb 01             	sub    $0x1,%ebx
   43d6c:	75 ed                	jne    43d5b <printer_vprintf+0x488>
   43d6e:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; len > 0; ++data, --len) {
   43d72:	8b 45 9c             	mov    -0x64(%rbp),%eax
   43d75:	85 c0                	test   %eax,%eax
   43d77:	7e 28                	jle    43da1 <printer_vprintf+0x4ce>
   43d79:	89 c3                	mov    %eax,%ebx
   43d7b:	4c 01 e3             	add    %r12,%rbx
   43d7e:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
   43d82:	44 8b 6d ac          	mov    -0x54(%rbp),%r13d
            p->putc(p, *data, color);
   43d86:	41 0f b6 34 24       	movzbl (%r12),%esi
   43d8b:	44 89 ea             	mov    %r13d,%edx
   43d8e:	4c 89 f7             	mov    %r14,%rdi
   43d91:	41 ff 16             	call   *(%r14)
        for (; len > 0; ++data, --len) {
   43d94:	49 83 c4 01          	add    $0x1,%r12
   43d98:	49 39 dc             	cmp    %rbx,%r12
   43d9b:	75 e9                	jne    43d86 <printer_vprintf+0x4b3>
   43d9d:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
        for (; width > 0; --width) {
   43da1:	45 85 ed             	test   %r13d,%r13d
   43da4:	7e 16                	jle    43dbc <printer_vprintf+0x4e9>
   43da6:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
   43da9:	89 da                	mov    %ebx,%edx
   43dab:	be 20 00 00 00       	mov    $0x20,%esi
   43db0:	4c 89 f7             	mov    %r14,%rdi
   43db3:	41 ff 16             	call   *(%r14)
        for (; width > 0; --width) {
   43db6:	41 83 ed 01          	sub    $0x1,%r13d
   43dba:	75 ed                	jne    43da9 <printer_vprintf+0x4d6>
    for (; *format; ++format) {
   43dbc:	4d 8d 67 01          	lea    0x1(%r15),%r12
   43dc0:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
   43dc5:	84 c0                	test   %al,%al
   43dc7:	0f 84 33 fb ff ff    	je     43900 <printer_vprintf+0x2d>
        if (*format != '%') {
   43dcd:	3c 25                	cmp    $0x25,%al
   43dcf:	0f 84 3a fb ff ff    	je     4390f <printer_vprintf+0x3c>
            p->putc(p, *format, color);
   43dd5:	0f b6 f0             	movzbl %al,%esi
   43dd8:	8b 55 ac             	mov    -0x54(%rbp),%edx
   43ddb:	4c 89 f7             	mov    %r14,%rdi
   43dde:	41 ff 16             	call   *(%r14)
            continue;
   43de1:	4d 89 e7             	mov    %r12,%r15
   43de4:	eb d6                	jmp    43dbc <printer_vprintf+0x4e9>
            data = va_arg(val, char*);
   43de6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43dea:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43dee:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43df2:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43df6:	e9 46 fe ff ff       	jmp    43c41 <printer_vprintf+0x36e>
            color = va_arg(val, int);
   43dfb:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43dff:	8b 01                	mov    (%rcx),%eax
   43e01:	83 f8 2f             	cmp    $0x2f,%eax
   43e04:	77 12                	ja     43e18 <printer_vprintf+0x545>
   43e06:	89 c2                	mov    %eax,%edx
   43e08:	48 03 51 10          	add    0x10(%rcx),%rdx
   43e0c:	83 c0 08             	add    $0x8,%eax
   43e0f:	89 01                	mov    %eax,(%rcx)
   43e11:	8b 02                	mov    (%rdx),%eax
   43e13:	89 45 ac             	mov    %eax,-0x54(%rbp)
            goto done;
   43e16:	eb a4                	jmp    43dbc <printer_vprintf+0x4e9>
            color = va_arg(val, int);
   43e18:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43e1c:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43e20:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43e24:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43e28:	eb e7                	jmp    43e11 <printer_vprintf+0x53e>
            numbuf[0] = va_arg(val, int);
   43e2a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43e2e:	8b 07                	mov    (%rdi),%eax
   43e30:	83 f8 2f             	cmp    $0x2f,%eax
   43e33:	77 23                	ja     43e58 <printer_vprintf+0x585>
   43e35:	89 c2                	mov    %eax,%edx
   43e37:	48 03 57 10          	add    0x10(%rdi),%rdx
   43e3b:	83 c0 08             	add    $0x8,%eax
   43e3e:	89 07                	mov    %eax,(%rdi)
   43e40:	8b 02                	mov    (%rdx),%eax
   43e42:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
   43e45:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
   43e49:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43e4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
   43e53:	e9 f2 fd ff ff       	jmp    43c4a <printer_vprintf+0x377>
            numbuf[0] = va_arg(val, int);
   43e58:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43e5c:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43e60:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43e64:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43e68:	eb d6                	jmp    43e40 <printer_vprintf+0x56d>
            numbuf[0] = (*format ? *format : '%');
   43e6a:	84 d2                	test   %dl,%dl
   43e6c:	0f 85 3e 01 00 00    	jne    43fb0 <printer_vprintf+0x6dd>
   43e72:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
   43e76:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
   43e7a:	49 83 ef 01          	sub    $0x1,%r15
            data = numbuf;
   43e7e:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43e82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
   43e88:	e9 bd fd ff ff       	jmp    43c4a <printer_vprintf+0x377>
        if (flags & FLAG_NUMERIC) {
   43e8d:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
   43e93:	48 8d 3d 36 0d 00 00 	lea    0xd36(%rip),%rdi        # 44bd0 <upper_digits.1>
        if (flags & FLAG_NUMERIC) {
   43e9a:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
   43e9f:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
   43ea3:	4c 89 c1             	mov    %r8,%rcx
   43ea6:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
   43eaa:	48 63 f6             	movslq %esi,%rsi
   43ead:	49 83 ec 01          	sub    $0x1,%r12
   43eb1:	48 89 c8             	mov    %rcx,%rax
   43eb4:	ba 00 00 00 00       	mov    $0x0,%edx
   43eb9:	48 f7 f6             	div    %rsi
   43ebc:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
   43ec0:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
   43ec4:	48 89 ca             	mov    %rcx,%rdx
   43ec7:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
   43eca:	48 39 d6             	cmp    %rdx,%rsi
   43ecd:	76 de                	jbe    43ead <printer_vprintf+0x5da>
   43ecf:	e9 8b fd ff ff       	jmp    43c5f <printer_vprintf+0x38c>
                prefix = "-";
   43ed4:	48 8d 1d e6 0b 00 00 	lea    0xbe6(%rip),%rbx        # 44ac1 <complex_keymap+0x161>
            if (flags & FLAG_NEGATIVE) {
   43edb:	8b 45 a0             	mov    -0x60(%rbp),%eax
   43ede:	a8 80                	test   $0x80,%al
   43ee0:	0f 85 a1 fd ff ff    	jne    43c87 <printer_vprintf+0x3b4>
                prefix = "+";
   43ee6:	48 8d 1d cf 0b 00 00 	lea    0xbcf(%rip),%rbx        # 44abc <complex_keymap+0x15c>
            } else if (flags & FLAG_PLUSPOSITIVE) {
   43eed:	a8 10                	test   $0x10,%al
   43eef:	0f 85 92 fd ff ff    	jne    43c87 <printer_vprintf+0x3b4>
                prefix = " ";
   43ef5:	a8 08                	test   $0x8,%al
   43ef7:	48 8d 15 c6 0b 00 00 	lea    0xbc6(%rip),%rdx        # 44ac4 <complex_keymap+0x164>
   43efe:	48 8d 05 be 0b 00 00 	lea    0xbbe(%rip),%rax        # 44ac3 <complex_keymap+0x163>
   43f05:	48 0f 44 c2          	cmove  %rdx,%rax
   43f09:	48 89 c3             	mov    %rax,%rbx
   43f0c:	e9 76 fd ff ff       	jmp    43c87 <printer_vprintf+0x3b4>
                   && (base == 16 || base == -16)
   43f11:	41 8d 41 10          	lea    0x10(%r9),%eax
   43f15:	a9 df ff ff ff       	test   $0xffffffdf,%eax
   43f1a:	0f 85 67 fd ff ff    	jne    43c87 <printer_vprintf+0x3b4>
                   && (num || (flags & FLAG_ALT2))) {
   43f20:	4d 85 c0             	test   %r8,%r8
   43f23:	75 0d                	jne    43f32 <printer_vprintf+0x65f>
   43f25:	f7 45 a0 00 01 00 00 	testl  $0x100,-0x60(%rbp)
   43f2c:	0f 84 55 fd ff ff    	je     43c87 <printer_vprintf+0x3b4>
            prefix = (base == -16 ? "0x" : "0X");
   43f32:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
   43f36:	48 8d 15 88 0b 00 00 	lea    0xb88(%rip),%rdx        # 44ac5 <complex_keymap+0x165>
   43f3d:	48 8d 05 7a 0b 00 00 	lea    0xb7a(%rip),%rax        # 44abe <complex_keymap+0x15e>
   43f44:	48 0f 44 c2          	cmove  %rdx,%rax
   43f48:	48 89 c3             	mov    %rax,%rbx
   43f4b:	e9 37 fd ff ff       	jmp    43c87 <printer_vprintf+0x3b4>
            len = strlen(data);
   43f50:	4c 89 e7             	mov    %r12,%rdi
   43f53:	e8 69 f8 ff ff       	call   437c1 <strlen>
   43f58:	89 45 9c             	mov    %eax,-0x64(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
   43f5b:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
   43f5f:	0f 84 4f fd ff ff    	je     43cb4 <printer_vprintf+0x3e1>
   43f65:	80 7d 88 00          	cmpb   $0x0,-0x78(%rbp)
   43f69:	0f 84 45 fd ff ff    	je     43cb4 <printer_vprintf+0x3e1>
            zeros = precision > len ? precision - len : 0;
   43f6f:	8b 4d a8             	mov    -0x58(%rbp),%ecx
   43f72:	89 ca                	mov    %ecx,%edx
   43f74:	29 c2                	sub    %eax,%edx
   43f76:	39 c1                	cmp    %eax,%ecx
   43f78:	b8 00 00 00 00       	mov    $0x0,%eax
   43f7d:	0f 4f c2             	cmovg  %edx,%eax
   43f80:	89 45 a8             	mov    %eax,-0x58(%rbp)
   43f83:	e9 42 fd ff ff       	jmp    43cca <printer_vprintf+0x3f7>
                   && len + (int) strlen(prefix) < width) {
   43f88:	48 89 df             	mov    %rbx,%rdi
   43f8b:	e8 31 f8 ff ff       	call   437c1 <strlen>
   43f90:	8b 7d 9c             	mov    -0x64(%rbp),%edi
   43f93:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
   43f96:	44 89 e9             	mov    %r13d,%ecx
   43f99:	29 f9                	sub    %edi,%ecx
   43f9b:	29 c1                	sub    %eax,%ecx
   43f9d:	44 39 ea             	cmp    %r13d,%edx
   43fa0:	b8 00 00 00 00       	mov    $0x0,%eax
   43fa5:	0f 4c c1             	cmovl  %ecx,%eax
   43fa8:	89 45 a8             	mov    %eax,-0x58(%rbp)
   43fab:	e9 1a fd ff ff       	jmp    43cca <printer_vprintf+0x3f7>
            numbuf[0] = (*format ? *format : '%');
   43fb0:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
   43fb3:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
   43fb7:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43fbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
   43fc1:	e9 84 fc ff ff       	jmp    43c4a <printer_vprintf+0x377>
        int flags = 0;
   43fc6:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%rbp)
   43fcd:	e9 8d f9 ff ff       	jmp    4395f <printer_vprintf+0x8c>

0000000000043fd2 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
   43fd2:	f3 0f 1e fa          	endbr64 
   43fd6:	55                   	push   %rbp
   43fd7:	48 89 e5             	mov    %rsp,%rbp
   43fda:	53                   	push   %rbx
   43fdb:	48 83 ec 18          	sub    $0x18,%rsp
    cp.p.putc = console_putc;
   43fdf:	48 8d 05 9e f6 ff ff 	lea    -0x962(%rip),%rax        # 43684 <console_putc>
   43fe6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        cpos = 0;
   43fea:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
   43ff0:	b8 00 00 00 00       	mov    $0x0,%eax
   43ff5:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
   43ff8:	48 63 ff             	movslq %edi,%rdi
   43ffb:	48 8d 1d fe 3f 07 00 	lea    0x73ffe(%rip),%rbx        # b8000 <console>
   44002:	48 8d 04 7b          	lea    (%rbx,%rdi,2),%rax
   44006:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    printer_vprintf(&cp.p, color, format, val);
   4400a:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
   4400e:	e8 c0 f8 ff ff       	call   438d3 <printer_vprintf>
    return cp.cursor - console;
   44013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   44017:	48 29 d8             	sub    %rbx,%rax
   4401a:	48 d1 f8             	sar    %rax
}
   4401d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   44021:	c9                   	leave  
   44022:	c3                   	ret    

0000000000044023 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
   44023:	f3 0f 1e fa          	endbr64 
   44027:	55                   	push   %rbp
   44028:	48 89 e5             	mov    %rsp,%rbp
   4402b:	48 83 ec 50          	sub    $0x50,%rsp
   4402f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   44033:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   44037:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
   4403b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   44042:	48 8d 45 10          	lea    0x10(%rbp),%rax
   44046:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   4404a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   4404e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
   44052:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   44056:	e8 77 ff ff ff       	call   43fd2 <console_vprintf>
}
   4405b:	c9                   	leave  
   4405c:	c3                   	ret    

000000000004405d <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
   4405d:	f3 0f 1e fa          	endbr64 
   44061:	55                   	push   %rbp
   44062:	48 89 e5             	mov    %rsp,%rbp
   44065:	53                   	push   %rbx
   44066:	48 83 ec 28          	sub    $0x28,%rsp
   4406a:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
   4406d:	48 8d 05 a3 f6 ff ff 	lea    -0x95d(%rip),%rax        # 43717 <string_putc>
   44074:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    sp.s = s;
   44078:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
   4407c:	48 85 f6             	test   %rsi,%rsi
   4407f:	75 0b                	jne    4408c <vsnprintf+0x2f>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
   44081:	8b 45 e0             	mov    -0x20(%rbp),%eax
   44084:	29 d8                	sub    %ebx,%eax
}
   44086:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   4408a:	c9                   	leave  
   4408b:	c3                   	ret    
        sp.end = s + size - 1;
   4408c:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
   44091:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
   44095:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
   44099:	be 00 00 00 00       	mov    $0x0,%esi
   4409e:	e8 30 f8 ff ff       	call   438d3 <printer_vprintf>
        *sp.s = 0;
   440a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   440a7:	c6 00 00             	movb   $0x0,(%rax)
   440aa:	eb d5                	jmp    44081 <vsnprintf+0x24>

00000000000440ac <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
   440ac:	f3 0f 1e fa          	endbr64 
   440b0:	55                   	push   %rbp
   440b1:	48 89 e5             	mov    %rsp,%rbp
   440b4:	48 83 ec 50          	sub    $0x50,%rsp
   440b8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   440bc:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   440c0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   440c4:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   440cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
   440cf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   440d3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   440d7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
   440db:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   440df:	e8 79 ff ff ff       	call   4405d <vsnprintf>
    va_end(val);
    return n;
}
   440e4:	c9                   	leave  
   440e5:	c3                   	ret    

00000000000440e6 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
   440e6:	f3 0f 1e fa          	endbr64 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   440ea:	48 8d 05 0f 3f 07 00 	lea    0x73f0f(%rip),%rax        # b8000 <console>
   440f1:	48 8d 90 a0 0f 00 00 	lea    0xfa0(%rax),%rdx
        console[i] = ' ' | 0x0700;
   440f8:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   440fd:	48 83 c0 02          	add    $0x2,%rax
   44101:	48 39 d0             	cmp    %rdx,%rax
   44104:	75 f2                	jne    440f8 <console_clear+0x12>
    }
    cursorpos = 0;
   44106:	c7 05 ec 4e 07 00 00 	movl   $0x0,0x74eec(%rip)        # b8ffc <cursorpos>
   4410d:	00 00 00 
}
   44110:	c3                   	ret    
