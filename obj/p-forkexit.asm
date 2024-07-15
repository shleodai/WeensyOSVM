
obj/p-forkexit.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	f3 0f 1e fa          	endbr64 
  100004:	55                   	push   %rbp
  100005:	48 89 e5             	mov    %rsp,%rbp
  100008:	41 55                	push   %r13
  10000a:	41 54                	push   %r12
  10000c:	53                   	push   %rbx
  10000d:	48 83 ec 08          	sub    $0x8,%rsp
  100011:	eb 02                	jmp    100015 <process_main+0x15>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  100013:	cd 32                	int    $0x32
    while (1) {
        if (rand() % ALLOC_SLOWDOWN == 0) {
  100015:	e8 35 03 00 00       	call   10034f <rand>
  10001a:	48 63 d0             	movslq %eax,%rdx
  10001d:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  100024:	48 c1 fa 25          	sar    $0x25,%rdx
  100028:	89 c1                	mov    %eax,%ecx
  10002a:	c1 f9 1f             	sar    $0x1f,%ecx
  10002d:	29 ca                	sub    %ecx,%edx
  10002f:	6b d2 64             	imul   $0x64,%edx,%edx
  100032:	39 d0                	cmp    %edx,%eax
  100034:	75 dd                	jne    100013 <process_main+0x13>
// sys_fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t sys_fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100036:	cd 34                	int    $0x34
            if (sys_fork() == 0) {
  100038:	85 c0                	test   %eax,%eax
  10003a:	75 d9                	jne    100015 <process_main+0x15>
    asm volatile ("int %1" : "=a" (result)
  10003c:	cd 31                	int    $0x31
  10003e:	89 c7                	mov    %eax,%edi
  100040:	89 c3                	mov    %eax,%ebx
            sys_yield();
        }
    }

    pid_t p = sys_getpid();
    srand(p);
  100042:	e8 46 03 00 00       	call   10038d <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100047:	48 8d 05 c9 1f 00 00 	lea    0x1fc9(%rip),%rax        # 102017 <end+0xfff>
  10004e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100054:	48 89 05 ad 0f 00 00 	mov    %rax,0xfad(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10005b:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  10005e:	48 83 e8 01          	sub    $0x1,%rax
  100062:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100068:	48 89 05 91 0f 00 00 	mov    %rax,0xf91(%rip)        # 101000 <stack_bottom>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
            heap_top += PAGESIZE;
            if (console[CPOS(24, 0)]) {
  10006f:	4c 8d 25 8a 7f fb ff 	lea    -0x48076(%rip),%r12        # b8000 <console>
                /* clear "Out of physical memory" msg */
                console_printf(CPOS(24, 0), 0, "\n");
  100076:	4c 8d 2d 63 0b 00 00 	lea    0xb63(%rip),%r13        # 100be0 <console_clear+0x2b>
  10007d:	eb 13                	jmp    100092 <process_main+0x92>
            }
        } else if (x == 8 * p) {
  10007f:	0f 84 8b 00 00 00    	je     100110 <process_main+0x110>
            if (sys_fork() == 0) {
                p = sys_getpid();
            }
        } else if (x == 8 * p + 1) {
  100085:	83 c0 01             	add    $0x1,%eax
  100088:	39 d0                	cmp    %edx,%eax
  10008a:	0f 84 93 00 00 00    	je     100123 <process_main+0x123>
    asm volatile ("int %0" : /* no result */
  100090:	cd 32                	int    $0x32
        int x = rand() % (8 * ALLOC_SLOWDOWN);
  100092:	e8 b8 02 00 00       	call   10034f <rand>
  100097:	48 63 d0             	movslq %eax,%rdx
  10009a:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  1000a1:	48 c1 fa 28          	sar    $0x28,%rdx
  1000a5:	89 c1                	mov    %eax,%ecx
  1000a7:	c1 f9 1f             	sar    $0x1f,%ecx
  1000aa:	29 ca                	sub    %ecx,%edx
  1000ac:	69 ca 20 03 00 00    	imul   $0x320,%edx,%ecx
  1000b2:	29 c8                	sub    %ecx,%eax
  1000b4:	89 c2                	mov    %eax,%edx
        if (x < 8 * p) {
  1000b6:	8d 04 dd 00 00 00 00 	lea    0x0(,%rbx,8),%eax
  1000bd:	39 d0                	cmp    %edx,%eax
  1000bf:	7e be                	jle    10007f <process_main+0x7f>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1000c1:	48 8b 3d 40 0f 00 00 	mov    0xf40(%rip),%rdi        # 101008 <heap_top>
  1000c8:	48 3b 3d 31 0f 00 00 	cmp    0xf31(%rip),%rdi        # 101000 <stack_bottom>
  1000cf:	74 56                	je     100127 <process_main+0x127>
    asm volatile ("int %1" : "=a" (result)
  1000d1:	cd 33                	int    $0x33
  1000d3:	85 c0                	test   %eax,%eax
  1000d5:	78 50                	js     100127 <process_main+0x127>
            *heap_top = p;      /* check we have write access to new page */
  1000d7:	48 8b 05 2a 0f 00 00 	mov    0xf2a(%rip),%rax        # 101008 <heap_top>
  1000de:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  1000e0:	48 81 05 1d 0f 00 00 	addq   $0x1000,0xf1d(%rip)        # 101008 <heap_top>
  1000e7:	00 10 00 00 
            if (console[CPOS(24, 0)]) {
  1000eb:	66 41 83 bc 24 00 0f 	cmpw   $0x0,0xf00(%r12)
  1000f2:	00 00 00 
  1000f5:	74 9b                	je     100092 <process_main+0x92>
                console_printf(CPOS(24, 0), 0, "\n");
  1000f7:	4c 89 ea             	mov    %r13,%rdx
  1000fa:	be 00 00 00 00       	mov    $0x0,%esi
  1000ff:	bf 80 07 00 00       	mov    $0x780,%edi
  100104:	b8 00 00 00 00       	mov    $0x0,%eax
  100109:	e8 e4 09 00 00       	call   100af2 <console_printf>
  10010e:	eb 82                	jmp    100092 <process_main+0x92>
    asm volatile ("int %1" : "=a" (result)
  100110:	cd 34                	int    $0x34
            if (sys_fork() == 0) {
  100112:	85 c0                	test   %eax,%eax
  100114:	0f 85 78 ff ff ff    	jne    100092 <process_main+0x92>
    asm volatile ("int %1" : "=a" (result)
  10011a:	cd 31                	int    $0x31
  10011c:	89 c3                	mov    %eax,%ebx
    return result;
  10011e:	e9 6f ff ff ff       	jmp    100092 <process_main+0x92>

// sys_exit()
//    Exit this process. Does not return.
static inline void sys_exit(void) __attribute__((noreturn));
static inline void sys_exit(void) {
    asm volatile ("int %0" : /* no result */
  100123:	cd 35                	int    $0x35
                  : "i" (INT_SYS_EXIT)
                  : "cc", "memory");
 spinloop: goto spinloop;       // should never get here
  100125:	eb fe                	jmp    100125 <process_main+0x125>
        }
    }

    // After running out of memory
    while (1) {
        if (rand() % (2 * ALLOC_SLOWDOWN) == 0) {
  100127:	e8 23 02 00 00       	call   10034f <rand>
  10012c:	48 63 d0             	movslq %eax,%rdx
  10012f:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  100136:	48 c1 fa 26          	sar    $0x26,%rdx
  10013a:	89 c1                	mov    %eax,%ecx
  10013c:	c1 f9 1f             	sar    $0x1f,%ecx
  10013f:	29 ca                	sub    %ecx,%edx
  100141:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
  100147:	39 d0                	cmp    %edx,%eax
  100149:	74 04                	je     10014f <process_main+0x14f>
    asm volatile ("int %0" : /* no result */
  10014b:	cd 32                	int    $0x32
}
  10014d:	eb d8                	jmp    100127 <process_main+0x127>
    asm volatile ("int %0" : /* no result */
  10014f:	cd 35                	int    $0x35
 spinloop: goto spinloop;       // should never get here
  100151:	eb fe                	jmp    100151 <process_main+0x151>

0000000000100153 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100153:	f3 0f 1e fa          	endbr64 
  100157:	48 89 f9             	mov    %rdi,%rcx
  10015a:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  10015c:	48 8d 05 3d 8e fb ff 	lea    -0x471c3(%rip),%rax        # b8fa0 <console+0xfa0>
  100163:	48 39 41 08          	cmp    %rax,0x8(%rcx)
  100167:	72 0b                	jb     100174 <console_putc+0x21>
        cp->cursor = console;
  100169:	48 8d 80 60 f0 ff ff 	lea    -0xfa0(%rax),%rax
  100170:	48 89 41 08          	mov    %rax,0x8(%rcx)
    }
    if (c == '\n') {
  100174:	40 80 fe 0a          	cmp    $0xa,%sil
  100178:	74 16                	je     100190 <console_putc+0x3d>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  10017a:	48 8b 41 08          	mov    0x8(%rcx),%rax
  10017e:	48 8d 50 02          	lea    0x2(%rax),%rdx
  100182:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  100186:	40 0f b6 f6          	movzbl %sil,%esi
  10018a:	09 fe                	or     %edi,%esi
  10018c:	66 89 30             	mov    %si,(%rax)
    }
}
  10018f:	c3                   	ret    
        int pos = (cp->cursor - console) % 80;
  100190:	48 8d 05 69 7e fb ff 	lea    -0x48197(%rip),%rax        # b8000 <console>
  100197:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  10019b:	49 29 c0             	sub    %rax,%r8
  10019e:	4c 89 c6             	mov    %r8,%rsi
  1001a1:	48 d1 fe             	sar    %rsi
  1001a4:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1001ab:	66 66 66 
  1001ae:	48 89 f0             	mov    %rsi,%rax
  1001b1:	48 f7 ea             	imul   %rdx
  1001b4:	48 c1 fa 05          	sar    $0x5,%rdx
  1001b8:	49 c1 f8 3f          	sar    $0x3f,%r8
  1001bc:	4c 29 c2             	sub    %r8,%rdx
  1001bf:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1001c3:	48 c1 e2 04          	shl    $0x4,%rdx
  1001c7:	89 f0                	mov    %esi,%eax
  1001c9:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1001cb:	83 cf 20             	or     $0x20,%edi
  1001ce:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1001d2:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  1001d6:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  1001da:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  1001dd:	83 c0 01             	add    $0x1,%eax
  1001e0:	83 f8 50             	cmp    $0x50,%eax
  1001e3:	75 e9                	jne    1001ce <console_putc+0x7b>
  1001e5:	c3                   	ret    

00000000001001e6 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  1001e6:	f3 0f 1e fa          	endbr64 
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1001ea:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1001ee:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1001f2:	73 0b                	jae    1001ff <string_putc+0x19>
        *sp->s++ = c;
  1001f4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1001f8:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1001fc:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1001ff:	c3                   	ret    

0000000000100200 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  100200:	f3 0f 1e fa          	endbr64 
  100204:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100207:	48 85 d2             	test   %rdx,%rdx
  10020a:	74 17                	je     100223 <memcpy+0x23>
  10020c:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  100211:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  100216:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  10021a:	48 83 c1 01          	add    $0x1,%rcx
  10021e:	48 39 d1             	cmp    %rdx,%rcx
  100221:	75 ee                	jne    100211 <memcpy+0x11>
}
  100223:	c3                   	ret    

0000000000100224 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  100224:	f3 0f 1e fa          	endbr64 
  100228:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  10022b:	48 39 fe             	cmp    %rdi,%rsi
  10022e:	72 1d                	jb     10024d <memmove+0x29>
        while (n-- > 0) {
  100230:	b9 00 00 00 00       	mov    $0x0,%ecx
  100235:	48 85 d2             	test   %rdx,%rdx
  100238:	74 12                	je     10024c <memmove+0x28>
            *d++ = *s++;
  10023a:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  10023e:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  100242:	48 83 c1 01          	add    $0x1,%rcx
  100246:	48 39 ca             	cmp    %rcx,%rdx
  100249:	75 ef                	jne    10023a <memmove+0x16>
}
  10024b:	c3                   	ret    
  10024c:	c3                   	ret    
    if (s < d && s + n > d) {
  10024d:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100251:	48 39 cf             	cmp    %rcx,%rdi
  100254:	73 da                	jae    100230 <memmove+0xc>
        while (n-- > 0) {
  100256:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  10025a:	48 85 d2             	test   %rdx,%rdx
  10025d:	74 ec                	je     10024b <memmove+0x27>
            *--d = *--s;
  10025f:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  100263:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  100266:	48 83 e9 01          	sub    $0x1,%rcx
  10026a:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  10026e:	75 ef                	jne    10025f <memmove+0x3b>
  100270:	c3                   	ret    

0000000000100271 <memset>:
void* memset(void* v, int c, size_t n) {
  100271:	f3 0f 1e fa          	endbr64 
  100275:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100278:	48 85 d2             	test   %rdx,%rdx
  10027b:	74 12                	je     10028f <memset+0x1e>
  10027d:	48 01 fa             	add    %rdi,%rdx
  100280:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  100283:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100286:	48 83 c1 01          	add    $0x1,%rcx
  10028a:	48 39 ca             	cmp    %rcx,%rdx
  10028d:	75 f4                	jne    100283 <memset+0x12>
}
  10028f:	c3                   	ret    

0000000000100290 <strlen>:
size_t strlen(const char* s) {
  100290:	f3 0f 1e fa          	endbr64 
    for (n = 0; *s != '\0'; ++s) {
  100294:	80 3f 00             	cmpb   $0x0,(%rdi)
  100297:	74 10                	je     1002a9 <strlen+0x19>
  100299:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  10029e:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1002a2:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1002a6:	75 f6                	jne    10029e <strlen+0xe>
  1002a8:	c3                   	ret    
  1002a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1002ae:	c3                   	ret    

00000000001002af <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1002af:	f3 0f 1e fa          	endbr64 
  1002b3:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1002b6:	ba 00 00 00 00       	mov    $0x0,%edx
  1002bb:	48 85 f6             	test   %rsi,%rsi
  1002be:	74 11                	je     1002d1 <strnlen+0x22>
  1002c0:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1002c4:	74 0c                	je     1002d2 <strnlen+0x23>
        ++n;
  1002c6:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1002ca:	48 39 d0             	cmp    %rdx,%rax
  1002cd:	75 f1                	jne    1002c0 <strnlen+0x11>
  1002cf:	eb 04                	jmp    1002d5 <strnlen+0x26>
  1002d1:	c3                   	ret    
  1002d2:	48 89 d0             	mov    %rdx,%rax
}
  1002d5:	c3                   	ret    

00000000001002d6 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1002d6:	f3 0f 1e fa          	endbr64 
  1002da:	48 89 f8             	mov    %rdi,%rax
  1002dd:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1002e2:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1002e6:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1002e9:	48 83 c2 01          	add    $0x1,%rdx
  1002ed:	84 c9                	test   %cl,%cl
  1002ef:	75 f1                	jne    1002e2 <strcpy+0xc>
}
  1002f1:	c3                   	ret    

00000000001002f2 <strcmp>:
int strcmp(const char* a, const char* b) {
  1002f2:	f3 0f 1e fa          	endbr64 
    while (*a && *b && *a == *b) {
  1002f6:	0f b6 07             	movzbl (%rdi),%eax
  1002f9:	84 c0                	test   %al,%al
  1002fb:	74 1a                	je     100317 <strcmp+0x25>
  1002fd:	0f b6 16             	movzbl (%rsi),%edx
  100300:	38 c2                	cmp    %al,%dl
  100302:	75 13                	jne    100317 <strcmp+0x25>
  100304:	84 d2                	test   %dl,%dl
  100306:	74 0f                	je     100317 <strcmp+0x25>
        ++a, ++b;
  100308:	48 83 c7 01          	add    $0x1,%rdi
  10030c:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  100310:	0f b6 07             	movzbl (%rdi),%eax
  100313:	84 c0                	test   %al,%al
  100315:	75 e6                	jne    1002fd <strcmp+0xb>
    return ((unsigned char) *a > (unsigned char) *b)
  100317:	3a 06                	cmp    (%rsi),%al
  100319:	0f 97 c0             	seta   %al
  10031c:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  10031f:	83 d8 00             	sbb    $0x0,%eax
}
  100322:	c3                   	ret    

0000000000100323 <strchr>:
char* strchr(const char* s, int c) {
  100323:	f3 0f 1e fa          	endbr64 
    while (*s && *s != (char) c) {
  100327:	0f b6 07             	movzbl (%rdi),%eax
  10032a:	84 c0                	test   %al,%al
  10032c:	74 10                	je     10033e <strchr+0x1b>
  10032e:	40 38 f0             	cmp    %sil,%al
  100331:	74 18                	je     10034b <strchr+0x28>
        ++s;
  100333:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  100337:	0f b6 07             	movzbl (%rdi),%eax
  10033a:	84 c0                	test   %al,%al
  10033c:	75 f0                	jne    10032e <strchr+0xb>
        return NULL;
  10033e:	40 84 f6             	test   %sil,%sil
  100341:	b8 00 00 00 00       	mov    $0x0,%eax
  100346:	48 0f 44 c7          	cmove  %rdi,%rax
}
  10034a:	c3                   	ret    
  10034b:	48 89 f8             	mov    %rdi,%rax
  10034e:	c3                   	ret    

000000000010034f <rand>:
int rand(void) {
  10034f:	f3 0f 1e fa          	endbr64 
    if (!rand_seed_set) {
  100353:	83 3d ba 0c 00 00 00 	cmpl   $0x0,0xcba(%rip)        # 101014 <rand_seed_set>
  10035a:	74 1b                	je     100377 <rand+0x28>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  10035c:	69 05 aa 0c 00 00 0d 	imul   $0x19660d,0xcaa(%rip),%eax        # 101010 <rand_seed>
  100363:	66 19 00 
  100366:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  10036b:	89 05 9f 0c 00 00    	mov    %eax,0xc9f(%rip)        # 101010 <rand_seed>
    return rand_seed & RAND_MAX;
  100371:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100376:	c3                   	ret    
    rand_seed = seed;
  100377:	c7 05 8f 0c 00 00 9e 	movl   $0x30d4879e,0xc8f(%rip)        # 101010 <rand_seed>
  10037e:	87 d4 30 
    rand_seed_set = 1;
  100381:	c7 05 89 0c 00 00 01 	movl   $0x1,0xc89(%rip)        # 101014 <rand_seed_set>
  100388:	00 00 00 
}
  10038b:	eb cf                	jmp    10035c <rand+0xd>

000000000010038d <srand>:
void srand(unsigned seed) {
  10038d:	f3 0f 1e fa          	endbr64 
    rand_seed = seed;
  100391:	89 3d 79 0c 00 00    	mov    %edi,0xc79(%rip)        # 101010 <rand_seed>
    rand_seed_set = 1;
  100397:	c7 05 73 0c 00 00 01 	movl   $0x1,0xc73(%rip)        # 101014 <rand_seed_set>
  10039e:	00 00 00 
}
  1003a1:	c3                   	ret    

00000000001003a2 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1003a2:	f3 0f 1e fa          	endbr64 
  1003a6:	55                   	push   %rbp
  1003a7:	48 89 e5             	mov    %rsp,%rbp
  1003aa:	41 57                	push   %r15
  1003ac:	41 56                	push   %r14
  1003ae:	41 55                	push   %r13
  1003b0:	41 54                	push   %r12
  1003b2:	53                   	push   %rbx
  1003b3:	48 83 ec 58          	sub    $0x58,%rsp
  1003b7:	49 89 fe             	mov    %rdi,%r14
  1003ba:	89 75 ac             	mov    %esi,-0x54(%rbp)
  1003bd:	49 89 d4             	mov    %rdx,%r12
  1003c0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1003c4:	0f b6 02             	movzbl (%rdx),%eax
  1003c7:	84 c0                	test   %al,%al
  1003c9:	0f 85 cd 04 00 00    	jne    10089c <printer_vprintf+0x4fa>
}
  1003cf:	48 83 c4 58          	add    $0x58,%rsp
  1003d3:	5b                   	pop    %rbx
  1003d4:	41 5c                	pop    %r12
  1003d6:	41 5d                	pop    %r13
  1003d8:	41 5e                	pop    %r14
  1003da:	41 5f                	pop    %r15
  1003dc:	5d                   	pop    %rbp
  1003dd:	c3                   	ret    
        for (++format; *format; ++format) {
  1003de:	4d 8d 7c 24 01       	lea    0x1(%r12),%r15
  1003e3:	41 0f b6 5c 24 01    	movzbl 0x1(%r12),%ebx
  1003e9:	84 db                	test   %bl,%bl
  1003eb:	0f 84 a4 06 00 00    	je     100a95 <printer_vprintf+0x6f3>
        int flags = 0;
  1003f1:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1003f7:	4c 8d 25 03 09 00 00 	lea    0x903(%rip),%r12        # 100d01 <flag_chars>
  1003fe:	0f be f3             	movsbl %bl,%esi
  100401:	4c 89 e7             	mov    %r12,%rdi
  100404:	e8 1a ff ff ff       	call   100323 <strchr>
  100409:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  10040c:	48 85 c0             	test   %rax,%rax
  10040f:	74 5c                	je     10046d <printer_vprintf+0xcb>
                flags |= 1 << (flagc - flag_chars);
  100411:	4c 29 e1             	sub    %r12,%rcx
  100414:	b8 01 00 00 00       	mov    $0x1,%eax
  100419:	d3 e0                	shl    %cl,%eax
  10041b:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  10041e:	49 83 c7 01          	add    $0x1,%r15
  100422:	41 0f b6 1f          	movzbl (%r15),%ebx
  100426:	84 db                	test   %bl,%bl
  100428:	75 d4                	jne    1003fe <printer_vprintf+0x5c>
  10042a:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
        int width = -1;
  10042e:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  100434:	c7 45 a8 ff ff ff ff 	movl   $0xffffffff,-0x58(%rbp)
        if (*format == '.') {
  10043b:	41 80 3f 2e          	cmpb   $0x2e,(%r15)
  10043f:	0f 84 b3 00 00 00    	je     1004f8 <printer_vprintf+0x156>
        int length = 0;
  100445:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  10044a:	41 0f b6 17          	movzbl (%r15),%edx
  10044e:	8d 42 bd             	lea    -0x43(%rdx),%eax
  100451:	3c 37                	cmp    $0x37,%al
  100453:	0f 87 e0 04 00 00    	ja     100939 <printer_vprintf+0x597>
  100459:	0f b6 c0             	movzbl %al,%eax
  10045c:	48 8d 3d 8d 07 00 00 	lea    0x78d(%rip),%rdi        # 100bf0 <console_clear+0x3b>
  100463:	48 63 04 87          	movslq (%rdi,%rax,4),%rax
  100467:	48 01 f8             	add    %rdi,%rax
  10046a:	3e ff e0             	notrack jmp *%rax
        if (*format >= '1' && *format <= '9') {
  10046d:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  100471:	8d 43 cf             	lea    -0x31(%rbx),%eax
  100474:	3c 08                	cmp    $0x8,%al
  100476:	77 31                	ja     1004a9 <printer_vprintf+0x107>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100478:	41 0f b6 07          	movzbl (%r15),%eax
  10047c:	8d 50 d0             	lea    -0x30(%rax),%edx
  10047f:	80 fa 09             	cmp    $0x9,%dl
  100482:	77 5e                	ja     1004e2 <printer_vprintf+0x140>
  100484:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  10048a:	49 83 c7 01          	add    $0x1,%r15
  10048e:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  100493:	0f be c0             	movsbl %al,%eax
  100496:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  10049b:	41 0f b6 07          	movzbl (%r15),%eax
  10049f:	8d 50 d0             	lea    -0x30(%rax),%edx
  1004a2:	80 fa 09             	cmp    $0x9,%dl
  1004a5:	76 e3                	jbe    10048a <printer_vprintf+0xe8>
  1004a7:	eb 8b                	jmp    100434 <printer_vprintf+0x92>
        } else if (*format == '*') {
  1004a9:	80 fb 2a             	cmp    $0x2a,%bl
  1004ac:	75 3f                	jne    1004ed <printer_vprintf+0x14b>
            width = va_arg(val, int);
  1004ae:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004b2:	8b 07                	mov    (%rdi),%eax
  1004b4:	83 f8 2f             	cmp    $0x2f,%eax
  1004b7:	77 17                	ja     1004d0 <printer_vprintf+0x12e>
  1004b9:	89 c2                	mov    %eax,%edx
  1004bb:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004bf:	83 c0 08             	add    $0x8,%eax
  1004c2:	89 07                	mov    %eax,(%rdi)
  1004c4:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1004c7:	49 83 c7 01          	add    $0x1,%r15
  1004cb:	e9 64 ff ff ff       	jmp    100434 <printer_vprintf+0x92>
            width = va_arg(val, int);
  1004d0:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004d4:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004d8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004dc:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1004e0:	eb e2                	jmp    1004c4 <printer_vprintf+0x122>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1004e2:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1004e8:	e9 47 ff ff ff       	jmp    100434 <printer_vprintf+0x92>
        int width = -1;
  1004ed:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1004f3:	e9 3c ff ff ff       	jmp    100434 <printer_vprintf+0x92>
            ++format;
  1004f8:	49 8d 57 01          	lea    0x1(%r15),%rdx
            if (*format >= '0' && *format <= '9') {
  1004fc:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  100501:	8d 48 d0             	lea    -0x30(%rax),%ecx
  100504:	80 f9 09             	cmp    $0x9,%cl
  100507:	76 13                	jbe    10051c <printer_vprintf+0x17a>
            } else if (*format == '*') {
  100509:	3c 2a                	cmp    $0x2a,%al
  10050b:	74 33                	je     100540 <printer_vprintf+0x19e>
            ++format;
  10050d:	49 89 d7             	mov    %rdx,%r15
                precision = 0;
  100510:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  100517:	e9 29 ff ff ff       	jmp    100445 <printer_vprintf+0xa3>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  10051c:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  100521:	48 83 c2 01          	add    $0x1,%rdx
  100525:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  100528:	0f be c0             	movsbl %al,%eax
  10052b:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  10052f:	0f b6 02             	movzbl (%rdx),%eax
  100532:	8d 70 d0             	lea    -0x30(%rax),%esi
  100535:	40 80 fe 09          	cmp    $0x9,%sil
  100539:	76 e6                	jbe    100521 <printer_vprintf+0x17f>
                    precision = 10 * precision + *format++ - '0';
  10053b:	49 89 d7             	mov    %rdx,%r15
  10053e:	eb 1c                	jmp    10055c <printer_vprintf+0x1ba>
                precision = va_arg(val, int);
  100540:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100544:	8b 01                	mov    (%rcx),%eax
  100546:	83 f8 2f             	cmp    $0x2f,%eax
  100549:	77 23                	ja     10056e <printer_vprintf+0x1cc>
  10054b:	89 c2                	mov    %eax,%edx
  10054d:	48 03 51 10          	add    0x10(%rcx),%rdx
  100551:	83 c0 08             	add    $0x8,%eax
  100554:	89 01                	mov    %eax,(%rcx)
  100556:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  100558:	49 83 c7 02          	add    $0x2,%r15
            if (precision < 0) {
  10055c:	85 c9                	test   %ecx,%ecx
  10055e:	b8 00 00 00 00       	mov    $0x0,%eax
  100563:	0f 49 c1             	cmovns %ecx,%eax
  100566:	89 45 a8             	mov    %eax,-0x58(%rbp)
  100569:	e9 d7 fe ff ff       	jmp    100445 <printer_vprintf+0xa3>
                precision = va_arg(val, int);
  10056e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100572:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100576:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10057a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10057e:	eb d6                	jmp    100556 <printer_vprintf+0x1b4>
        switch (*format) {
  100580:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100585:	e9 f6 00 00 00       	jmp    100680 <printer_vprintf+0x2de>
            ++format;
  10058a:	49 83 c7 01          	add    $0x1,%r15
            length = 1;
  10058e:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  100593:	e9 b2 fe ff ff       	jmp    10044a <printer_vprintf+0xa8>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100598:	85 c9                	test   %ecx,%ecx
  10059a:	74 56                	je     1005f2 <printer_vprintf+0x250>
  10059c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005a0:	8b 07                	mov    (%rdi),%eax
  1005a2:	83 f8 2f             	cmp    $0x2f,%eax
  1005a5:	77 39                	ja     1005e0 <printer_vprintf+0x23e>
  1005a7:	89 c2                	mov    %eax,%edx
  1005a9:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005ad:	83 c0 08             	add    $0x8,%eax
  1005b0:	89 07                	mov    %eax,(%rdi)
  1005b2:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1005b5:	48 89 d0             	mov    %rdx,%rax
  1005b8:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1005bc:	49 89 d0             	mov    %rdx,%r8
  1005bf:	49 f7 d8             	neg    %r8
  1005c2:	25 80 00 00 00       	and    $0x80,%eax
  1005c7:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1005cb:	0b 45 a0             	or     -0x60(%rbp),%eax
  1005ce:	83 c8 60             	or     $0x60,%eax
  1005d1:	89 45 a0             	mov    %eax,-0x60(%rbp)
        char* data = "";
  1005d4:	4c 8d 25 06 06 00 00 	lea    0x606(%rip),%r12        # 100be1 <console_clear+0x2c>
            break;
  1005db:	e9 39 01 00 00       	jmp    100719 <printer_vprintf+0x377>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1005e0:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005e4:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005e8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005ec:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005f0:	eb c0                	jmp    1005b2 <printer_vprintf+0x210>
  1005f2:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005f6:	8b 01                	mov    (%rcx),%eax
  1005f8:	83 f8 2f             	cmp    $0x2f,%eax
  1005fb:	77 10                	ja     10060d <printer_vprintf+0x26b>
  1005fd:	89 c2                	mov    %eax,%edx
  1005ff:	48 03 51 10          	add    0x10(%rcx),%rdx
  100603:	83 c0 08             	add    $0x8,%eax
  100606:	89 01                	mov    %eax,(%rcx)
  100608:	48 63 12             	movslq (%rdx),%rdx
  10060b:	eb a8                	jmp    1005b5 <printer_vprintf+0x213>
  10060d:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100611:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100615:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100619:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10061d:	eb e9                	jmp    100608 <printer_vprintf+0x266>
        int base = 10;
  10061f:	be 0a 00 00 00       	mov    $0xa,%esi
  100624:	eb 5a                	jmp    100680 <printer_vprintf+0x2de>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100626:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10062a:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10062e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100632:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100636:	eb 62                	jmp    10069a <printer_vprintf+0x2f8>
  100638:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10063c:	8b 07                	mov    (%rdi),%eax
  10063e:	83 f8 2f             	cmp    $0x2f,%eax
  100641:	77 10                	ja     100653 <printer_vprintf+0x2b1>
  100643:	89 c2                	mov    %eax,%edx
  100645:	48 03 57 10          	add    0x10(%rdi),%rdx
  100649:	83 c0 08             	add    $0x8,%eax
  10064c:	89 07                	mov    %eax,(%rdi)
  10064e:	44 8b 02             	mov    (%rdx),%r8d
  100651:	eb 4a                	jmp    10069d <printer_vprintf+0x2fb>
  100653:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100657:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10065b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10065f:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100663:	eb e9                	jmp    10064e <printer_vprintf+0x2ac>
  100665:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  100668:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
    const char* digits = upper_digits;
  10066f:	48 8d 3d 7a 06 00 00 	lea    0x67a(%rip),%rdi        # 100cf0 <upper_digits.1>
  100676:	e9 f3 02 00 00       	jmp    10096e <printer_vprintf+0x5cc>
            base = 16;
  10067b:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100680:	85 c9                	test   %ecx,%ecx
  100682:	74 b4                	je     100638 <printer_vprintf+0x296>
  100684:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100688:	8b 01                	mov    (%rcx),%eax
  10068a:	83 f8 2f             	cmp    $0x2f,%eax
  10068d:	77 97                	ja     100626 <printer_vprintf+0x284>
  10068f:	89 c2                	mov    %eax,%edx
  100691:	48 03 51 10          	add    0x10(%rcx),%rdx
  100695:	83 c0 08             	add    $0x8,%eax
  100698:	89 01                	mov    %eax,(%rcx)
  10069a:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  10069d:	83 4d a0 20          	orl    $0x20,-0x60(%rbp)
    if (base < 0) {
  1006a1:	85 f6                	test   %esi,%esi
  1006a3:	79 c0                	jns    100665 <printer_vprintf+0x2c3>
        base = -base;
  1006a5:	41 89 f1             	mov    %esi,%r9d
  1006a8:	f7 de                	neg    %esi
  1006aa:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
        digits = lower_digits;
  1006b1:	48 8d 3d 18 06 00 00 	lea    0x618(%rip),%rdi        # 100cd0 <lower_digits.0>
  1006b8:	e9 b1 02 00 00       	jmp    10096e <printer_vprintf+0x5cc>
            num = (uintptr_t) va_arg(val, void*);
  1006bd:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1006c1:	8b 01                	mov    (%rcx),%eax
  1006c3:	83 f8 2f             	cmp    $0x2f,%eax
  1006c6:	77 1c                	ja     1006e4 <printer_vprintf+0x342>
  1006c8:	89 c2                	mov    %eax,%edx
  1006ca:	48 03 51 10          	add    0x10(%rcx),%rdx
  1006ce:	83 c0 08             	add    $0x8,%eax
  1006d1:	89 01                	mov    %eax,(%rcx)
  1006d3:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1006d6:	81 4d a0 21 01 00 00 	orl    $0x121,-0x60(%rbp)
            base = -16;
  1006dd:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1006e2:	eb c1                	jmp    1006a5 <printer_vprintf+0x303>
            num = (uintptr_t) va_arg(val, void*);
  1006e4:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1006e8:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1006ec:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1006f0:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1006f4:	eb dd                	jmp    1006d3 <printer_vprintf+0x331>
            data = va_arg(val, char*);
  1006f6:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1006fa:	8b 07                	mov    (%rdi),%eax
  1006fc:	83 f8 2f             	cmp    $0x2f,%eax
  1006ff:	0f 87 b0 01 00 00    	ja     1008b5 <printer_vprintf+0x513>
  100705:	89 c2                	mov    %eax,%edx
  100707:	48 03 57 10          	add    0x10(%rdi),%rdx
  10070b:	83 c0 08             	add    $0x8,%eax
  10070e:	89 07                	mov    %eax,(%rdi)
  100710:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  100713:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  100719:	8b 45 a0             	mov    -0x60(%rbp),%eax
  10071c:	83 e0 20             	and    $0x20,%eax
  10071f:	89 45 98             	mov    %eax,-0x68(%rbp)
  100722:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  100728:	0f 85 2e 02 00 00    	jne    10095c <printer_vprintf+0x5ba>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  10072e:	8b 45 a0             	mov    -0x60(%rbp),%eax
  100731:	89 45 8c             	mov    %eax,-0x74(%rbp)
  100734:	83 e0 60             	and    $0x60,%eax
  100737:	83 f8 60             	cmp    $0x60,%eax
  10073a:	0f 84 63 02 00 00    	je     1009a3 <printer_vprintf+0x601>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100740:	8b 45 a0             	mov    -0x60(%rbp),%eax
  100743:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  100746:	48 8d 1d 94 04 00 00 	lea    0x494(%rip),%rbx        # 100be1 <console_clear+0x2c>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  10074d:	83 f8 21             	cmp    $0x21,%eax
  100750:	0f 84 8a 02 00 00    	je     1009e0 <printer_vprintf+0x63e>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  100756:	8b 7d a8             	mov    -0x58(%rbp),%edi
  100759:	89 f8                	mov    %edi,%eax
  10075b:	f7 d0                	not    %eax
  10075d:	c1 e8 1f             	shr    $0x1f,%eax
  100760:	89 45 88             	mov    %eax,-0x78(%rbp)
  100763:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  100767:	0f 85 b2 02 00 00    	jne    100a1f <printer_vprintf+0x67d>
  10076d:	84 c0                	test   %al,%al
  10076f:	0f 84 aa 02 00 00    	je     100a1f <printer_vprintf+0x67d>
            len = strnlen(data, precision);
  100775:	48 63 f7             	movslq %edi,%rsi
  100778:	4c 89 e7             	mov    %r12,%rdi
  10077b:	e8 2f fb ff ff       	call   1002af <strnlen>
  100780:	89 45 9c             	mov    %eax,-0x64(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  100783:	8b 45 8c             	mov    -0x74(%rbp),%eax
  100786:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  100789:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100790:	83 f8 22             	cmp    $0x22,%eax
  100793:	0f 84 be 02 00 00    	je     100a57 <printer_vprintf+0x6b5>
        width -= len + zeros + strlen(prefix);
  100799:	48 89 df             	mov    %rbx,%rdi
  10079c:	e8 ef fa ff ff       	call   100290 <strlen>
  1007a1:	8b 55 a8             	mov    -0x58(%rbp),%edx
  1007a4:	03 55 9c             	add    -0x64(%rbp),%edx
  1007a7:	44 89 e9             	mov    %r13d,%ecx
  1007aa:	29 d1                	sub    %edx,%ecx
  1007ac:	29 c1                	sub    %eax,%ecx
  1007ae:	89 4d 98             	mov    %ecx,-0x68(%rbp)
  1007b1:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1007b4:	f6 45 a0 04          	testb  $0x4,-0x60(%rbp)
  1007b8:	75 37                	jne    1007f1 <printer_vprintf+0x44f>
  1007ba:	85 c9                	test   %ecx,%ecx
  1007bc:	7e 33                	jle    1007f1 <printer_vprintf+0x44f>
        width -= len + zeros + strlen(prefix);
  1007be:	48 89 5d a0          	mov    %rbx,-0x60(%rbp)
  1007c2:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  1007c5:	89 da                	mov    %ebx,%edx
  1007c7:	be 20 00 00 00       	mov    $0x20,%esi
  1007cc:	4c 89 f7             	mov    %r14,%rdi
  1007cf:	41 ff 16             	call   *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1007d2:	41 83 ed 01          	sub    $0x1,%r13d
  1007d6:	45 85 ed             	test   %r13d,%r13d
  1007d9:	7f ea                	jg     1007c5 <printer_vprintf+0x423>
  1007db:	48 8b 5d a0          	mov    -0x60(%rbp),%rbx
  1007df:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1007e2:	85 ff                	test   %edi,%edi
  1007e4:	b8 01 00 00 00       	mov    $0x1,%eax
  1007e9:	0f 4f c7             	cmovg  %edi,%eax
  1007ec:	29 c7                	sub    %eax,%edi
  1007ee:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1007f1:	0f b6 03             	movzbl (%rbx),%eax
  1007f4:	84 c0                	test   %al,%al
  1007f6:	74 23                	je     10081b <printer_vprintf+0x479>
  1007f8:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  1007fc:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, *prefix, color);
  100800:	0f b6 f0             	movzbl %al,%esi
  100803:	44 89 e2             	mov    %r12d,%edx
  100806:	4c 89 f7             	mov    %r14,%rdi
  100809:	41 ff 16             	call   *(%r14)
        for (; *prefix; ++prefix) {
  10080c:	48 83 c3 01          	add    $0x1,%rbx
  100810:	0f b6 03             	movzbl (%rbx),%eax
  100813:	84 c0                	test   %al,%al
  100815:	75 e9                	jne    100800 <printer_vprintf+0x45e>
  100817:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; zeros > 0; --zeros) {
  10081b:	8b 5d a8             	mov    -0x58(%rbp),%ebx
  10081e:	85 db                	test   %ebx,%ebx
  100820:	7e 1f                	jle    100841 <printer_vprintf+0x49f>
  100822:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  100826:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, '0', color);
  10082a:	44 89 e2             	mov    %r12d,%edx
  10082d:	be 30 00 00 00       	mov    $0x30,%esi
  100832:	4c 89 f7             	mov    %r14,%rdi
  100835:	41 ff 16             	call   *(%r14)
        for (; zeros > 0; --zeros) {
  100838:	83 eb 01             	sub    $0x1,%ebx
  10083b:	75 ed                	jne    10082a <printer_vprintf+0x488>
  10083d:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; len > 0; ++data, --len) {
  100841:	8b 45 9c             	mov    -0x64(%rbp),%eax
  100844:	85 c0                	test   %eax,%eax
  100846:	7e 28                	jle    100870 <printer_vprintf+0x4ce>
  100848:	89 c3                	mov    %eax,%ebx
  10084a:	4c 01 e3             	add    %r12,%rbx
  10084d:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  100851:	44 8b 6d ac          	mov    -0x54(%rbp),%r13d
            p->putc(p, *data, color);
  100855:	41 0f b6 34 24       	movzbl (%r12),%esi
  10085a:	44 89 ea             	mov    %r13d,%edx
  10085d:	4c 89 f7             	mov    %r14,%rdi
  100860:	41 ff 16             	call   *(%r14)
        for (; len > 0; ++data, --len) {
  100863:	49 83 c4 01          	add    $0x1,%r12
  100867:	49 39 dc             	cmp    %rbx,%r12
  10086a:	75 e9                	jne    100855 <printer_vprintf+0x4b3>
  10086c:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
        for (; width > 0; --width) {
  100870:	45 85 ed             	test   %r13d,%r13d
  100873:	7e 16                	jle    10088b <printer_vprintf+0x4e9>
  100875:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  100878:	89 da                	mov    %ebx,%edx
  10087a:	be 20 00 00 00       	mov    $0x20,%esi
  10087f:	4c 89 f7             	mov    %r14,%rdi
  100882:	41 ff 16             	call   *(%r14)
        for (; width > 0; --width) {
  100885:	41 83 ed 01          	sub    $0x1,%r13d
  100889:	75 ed                	jne    100878 <printer_vprintf+0x4d6>
    for (; *format; ++format) {
  10088b:	4d 8d 67 01          	lea    0x1(%r15),%r12
  10088f:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  100894:	84 c0                	test   %al,%al
  100896:	0f 84 33 fb ff ff    	je     1003cf <printer_vprintf+0x2d>
        if (*format != '%') {
  10089c:	3c 25                	cmp    $0x25,%al
  10089e:	0f 84 3a fb ff ff    	je     1003de <printer_vprintf+0x3c>
            p->putc(p, *format, color);
  1008a4:	0f b6 f0             	movzbl %al,%esi
  1008a7:	8b 55 ac             	mov    -0x54(%rbp),%edx
  1008aa:	4c 89 f7             	mov    %r14,%rdi
  1008ad:	41 ff 16             	call   *(%r14)
            continue;
  1008b0:	4d 89 e7             	mov    %r12,%r15
  1008b3:	eb d6                	jmp    10088b <printer_vprintf+0x4e9>
            data = va_arg(val, char*);
  1008b5:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1008b9:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1008bd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1008c1:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1008c5:	e9 46 fe ff ff       	jmp    100710 <printer_vprintf+0x36e>
            color = va_arg(val, int);
  1008ca:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1008ce:	8b 01                	mov    (%rcx),%eax
  1008d0:	83 f8 2f             	cmp    $0x2f,%eax
  1008d3:	77 12                	ja     1008e7 <printer_vprintf+0x545>
  1008d5:	89 c2                	mov    %eax,%edx
  1008d7:	48 03 51 10          	add    0x10(%rcx),%rdx
  1008db:	83 c0 08             	add    $0x8,%eax
  1008de:	89 01                	mov    %eax,(%rcx)
  1008e0:	8b 02                	mov    (%rdx),%eax
  1008e2:	89 45 ac             	mov    %eax,-0x54(%rbp)
            goto done;
  1008e5:	eb a4                	jmp    10088b <printer_vprintf+0x4e9>
            color = va_arg(val, int);
  1008e7:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1008eb:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1008ef:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1008f3:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1008f7:	eb e7                	jmp    1008e0 <printer_vprintf+0x53e>
            numbuf[0] = va_arg(val, int);
  1008f9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1008fd:	8b 07                	mov    (%rdi),%eax
  1008ff:	83 f8 2f             	cmp    $0x2f,%eax
  100902:	77 23                	ja     100927 <printer_vprintf+0x585>
  100904:	89 c2                	mov    %eax,%edx
  100906:	48 03 57 10          	add    0x10(%rdi),%rdx
  10090a:	83 c0 08             	add    $0x8,%eax
  10090d:	89 07                	mov    %eax,(%rdi)
  10090f:	8b 02                	mov    (%rdx),%eax
  100911:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  100914:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100918:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  10091c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  100922:	e9 f2 fd ff ff       	jmp    100719 <printer_vprintf+0x377>
            numbuf[0] = va_arg(val, int);
  100927:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10092b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10092f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100933:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100937:	eb d6                	jmp    10090f <printer_vprintf+0x56d>
            numbuf[0] = (*format ? *format : '%');
  100939:	84 d2                	test   %dl,%dl
  10093b:	0f 85 3e 01 00 00    	jne    100a7f <printer_vprintf+0x6dd>
  100941:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  100945:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  100949:	49 83 ef 01          	sub    $0x1,%r15
            data = numbuf;
  10094d:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100951:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100957:	e9 bd fd ff ff       	jmp    100719 <printer_vprintf+0x377>
        if (flags & FLAG_NUMERIC) {
  10095c:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  100962:	48 8d 3d 87 03 00 00 	lea    0x387(%rip),%rdi        # 100cf0 <upper_digits.1>
        if (flags & FLAG_NUMERIC) {
  100969:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  10096e:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  100972:	4c 89 c1             	mov    %r8,%rcx
  100975:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  100979:	48 63 f6             	movslq %esi,%rsi
  10097c:	49 83 ec 01          	sub    $0x1,%r12
  100980:	48 89 c8             	mov    %rcx,%rax
  100983:	ba 00 00 00 00       	mov    $0x0,%edx
  100988:	48 f7 f6             	div    %rsi
  10098b:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  10098f:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  100993:	48 89 ca             	mov    %rcx,%rdx
  100996:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  100999:	48 39 d6             	cmp    %rdx,%rsi
  10099c:	76 de                	jbe    10097c <printer_vprintf+0x5da>
  10099e:	e9 8b fd ff ff       	jmp    10072e <printer_vprintf+0x38c>
                prefix = "-";
  1009a3:	48 8d 1d 3d 02 00 00 	lea    0x23d(%rip),%rbx        # 100be7 <console_clear+0x32>
            if (flags & FLAG_NEGATIVE) {
  1009aa:	8b 45 a0             	mov    -0x60(%rbp),%eax
  1009ad:	a8 80                	test   $0x80,%al
  1009af:	0f 85 a1 fd ff ff    	jne    100756 <printer_vprintf+0x3b4>
                prefix = "+";
  1009b5:	48 8d 1d 26 02 00 00 	lea    0x226(%rip),%rbx        # 100be2 <console_clear+0x2d>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1009bc:	a8 10                	test   $0x10,%al
  1009be:	0f 85 92 fd ff ff    	jne    100756 <printer_vprintf+0x3b4>
                prefix = " ";
  1009c4:	a8 08                	test   $0x8,%al
  1009c6:	48 8d 15 14 02 00 00 	lea    0x214(%rip),%rdx        # 100be1 <console_clear+0x2c>
  1009cd:	48 8d 05 15 02 00 00 	lea    0x215(%rip),%rax        # 100be9 <console_clear+0x34>
  1009d4:	48 0f 44 c2          	cmove  %rdx,%rax
  1009d8:	48 89 c3             	mov    %rax,%rbx
  1009db:	e9 76 fd ff ff       	jmp    100756 <printer_vprintf+0x3b4>
                   && (base == 16 || base == -16)
  1009e0:	41 8d 41 10          	lea    0x10(%r9),%eax
  1009e4:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1009e9:	0f 85 67 fd ff ff    	jne    100756 <printer_vprintf+0x3b4>
                   && (num || (flags & FLAG_ALT2))) {
  1009ef:	4d 85 c0             	test   %r8,%r8
  1009f2:	75 0d                	jne    100a01 <printer_vprintf+0x65f>
  1009f4:	f7 45 a0 00 01 00 00 	testl  $0x100,-0x60(%rbp)
  1009fb:	0f 84 55 fd ff ff    	je     100756 <printer_vprintf+0x3b4>
            prefix = (base == -16 ? "0x" : "0X");
  100a01:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  100a05:	48 8d 15 df 01 00 00 	lea    0x1df(%rip),%rdx        # 100beb <console_clear+0x36>
  100a0c:	48 8d 05 d1 01 00 00 	lea    0x1d1(%rip),%rax        # 100be4 <console_clear+0x2f>
  100a13:	48 0f 44 c2          	cmove  %rdx,%rax
  100a17:	48 89 c3             	mov    %rax,%rbx
  100a1a:	e9 37 fd ff ff       	jmp    100756 <printer_vprintf+0x3b4>
            len = strlen(data);
  100a1f:	4c 89 e7             	mov    %r12,%rdi
  100a22:	e8 69 f8 ff ff       	call   100290 <strlen>
  100a27:	89 45 9c             	mov    %eax,-0x64(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100a2a:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  100a2e:	0f 84 4f fd ff ff    	je     100783 <printer_vprintf+0x3e1>
  100a34:	80 7d 88 00          	cmpb   $0x0,-0x78(%rbp)
  100a38:	0f 84 45 fd ff ff    	je     100783 <printer_vprintf+0x3e1>
            zeros = precision > len ? precision - len : 0;
  100a3e:	8b 4d a8             	mov    -0x58(%rbp),%ecx
  100a41:	89 ca                	mov    %ecx,%edx
  100a43:	29 c2                	sub    %eax,%edx
  100a45:	39 c1                	cmp    %eax,%ecx
  100a47:	b8 00 00 00 00       	mov    $0x0,%eax
  100a4c:	0f 4f c2             	cmovg  %edx,%eax
  100a4f:	89 45 a8             	mov    %eax,-0x58(%rbp)
  100a52:	e9 42 fd ff ff       	jmp    100799 <printer_vprintf+0x3f7>
                   && len + (int) strlen(prefix) < width) {
  100a57:	48 89 df             	mov    %rbx,%rdi
  100a5a:	e8 31 f8 ff ff       	call   100290 <strlen>
  100a5f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  100a62:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  100a65:	44 89 e9             	mov    %r13d,%ecx
  100a68:	29 f9                	sub    %edi,%ecx
  100a6a:	29 c1                	sub    %eax,%ecx
  100a6c:	44 39 ea             	cmp    %r13d,%edx
  100a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  100a74:	0f 4c c1             	cmovl  %ecx,%eax
  100a77:	89 45 a8             	mov    %eax,-0x58(%rbp)
  100a7a:	e9 1a fd ff ff       	jmp    100799 <printer_vprintf+0x3f7>
            numbuf[0] = (*format ? *format : '%');
  100a7f:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  100a82:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100a86:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100a8a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100a90:	e9 84 fc ff ff       	jmp    100719 <printer_vprintf+0x377>
        int flags = 0;
  100a95:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%rbp)
  100a9c:	e9 8d f9 ff ff       	jmp    10042e <printer_vprintf+0x8c>

0000000000100aa1 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100aa1:	f3 0f 1e fa          	endbr64 
  100aa5:	55                   	push   %rbp
  100aa6:	48 89 e5             	mov    %rsp,%rbp
  100aa9:	53                   	push   %rbx
  100aaa:	48 83 ec 18          	sub    $0x18,%rsp
    cp.p.putc = console_putc;
  100aae:	48 8d 05 9e f6 ff ff 	lea    -0x962(%rip),%rax        # 100153 <console_putc>
  100ab5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        cpos = 0;
  100ab9:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  100abf:	b8 00 00 00 00       	mov    $0x0,%eax
  100ac4:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100ac7:	48 63 ff             	movslq %edi,%rdi
  100aca:	48 8d 1d 2f 75 fb ff 	lea    -0x48ad1(%rip),%rbx        # b8000 <console>
  100ad1:	48 8d 04 7b          	lea    (%rbx,%rdi,2),%rax
  100ad5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100ad9:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  100add:	e8 c0 f8 ff ff       	call   1003a2 <printer_vprintf>
    return cp.cursor - console;
  100ae2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100ae6:	48 29 d8             	sub    %rbx,%rax
  100ae9:	48 d1 f8             	sar    %rax
}
  100aec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100af0:	c9                   	leave  
  100af1:	c3                   	ret    

0000000000100af2 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  100af2:	f3 0f 1e fa          	endbr64 
  100af6:	55                   	push   %rbp
  100af7:	48 89 e5             	mov    %rsp,%rbp
  100afa:	48 83 ec 50          	sub    $0x50,%rsp
  100afe:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100b02:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100b06:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  100b0a:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100b11:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100b15:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100b19:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100b1d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100b21:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100b25:	e8 77 ff ff ff       	call   100aa1 <console_vprintf>
}
  100b2a:	c9                   	leave  
  100b2b:	c3                   	ret    

0000000000100b2c <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100b2c:	f3 0f 1e fa          	endbr64 
  100b30:	55                   	push   %rbp
  100b31:	48 89 e5             	mov    %rsp,%rbp
  100b34:	53                   	push   %rbx
  100b35:	48 83 ec 28          	sub    $0x28,%rsp
  100b39:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100b3c:	48 8d 05 a3 f6 ff ff 	lea    -0x95d(%rip),%rax        # 1001e6 <string_putc>
  100b43:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    sp.s = s;
  100b47:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100b4b:	48 85 f6             	test   %rsi,%rsi
  100b4e:	75 0b                	jne    100b5b <vsnprintf+0x2f>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100b50:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100b53:	29 d8                	sub    %ebx,%eax
}
  100b55:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100b59:	c9                   	leave  
  100b5a:	c3                   	ret    
        sp.end = s + size - 1;
  100b5b:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100b60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100b64:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100b68:	be 00 00 00 00       	mov    $0x0,%esi
  100b6d:	e8 30 f8 ff ff       	call   1003a2 <printer_vprintf>
        *sp.s = 0;
  100b72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100b76:	c6 00 00             	movb   $0x0,(%rax)
  100b79:	eb d5                	jmp    100b50 <vsnprintf+0x24>

0000000000100b7b <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100b7b:	f3 0f 1e fa          	endbr64 
  100b7f:	55                   	push   %rbp
  100b80:	48 89 e5             	mov    %rsp,%rbp
  100b83:	48 83 ec 50          	sub    $0x50,%rsp
  100b87:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100b8b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100b8f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100b93:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100b9a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100b9e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100ba2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100ba6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100baa:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100bae:	e8 79 ff ff ff       	call   100b2c <vsnprintf>
    va_end(val);
    return n;
}
  100bb3:	c9                   	leave  
  100bb4:	c3                   	ret    

0000000000100bb5 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  100bb5:	f3 0f 1e fa          	endbr64 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100bb9:	48 8d 05 40 74 fb ff 	lea    -0x48bc0(%rip),%rax        # b8000 <console>
  100bc0:	48 8d 90 a0 0f 00 00 	lea    0xfa0(%rax),%rdx
        console[i] = ' ' | 0x0700;
  100bc7:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100bcc:	48 83 c0 02          	add    $0x2,%rax
  100bd0:	48 39 d0             	cmp    %rdx,%rax
  100bd3:	75 f2                	jne    100bc7 <console_clear+0x12>
    }
    cursorpos = 0;
  100bd5:	c7 05 1d 84 fb ff 00 	movl   $0x0,-0x47be3(%rip)        # b8ffc <cursorpos>
  100bdc:	00 00 00 
}
  100bdf:	c3                   	ret    
