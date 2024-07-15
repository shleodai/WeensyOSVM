
obj/p-allocator.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	f3 0f 1e fa          	endbr64 
  100004:	55                   	push   %rbp
  100005:	48 89 e5             	mov    %rsp,%rbp
  100008:	53                   	push   %rbx
  100009:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  10000d:	cd 31                	int    $0x31
  10000f:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  100011:	89 c7                	mov    %eax,%edi
  100013:	e8 b9 02 00 00       	call   1002d1 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100018:	48 8d 05 f8 1f 00 00 	lea    0x1ff8(%rip),%rax        # 102017 <end+0xfff>
  10001f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100025:	48 89 05 dc 0f 00 00 	mov    %rax,0xfdc(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10002c:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  10002f:	48 83 e8 01          	sub    $0x1,%rax
  100033:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100039:	48 89 05 c0 0f 00 00 	mov    %rax,0xfc0(%rip)        # 101000 <stack_bottom>
  100040:	eb 02                	jmp    100044 <process_main+0x44>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  100042:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
#if !NO_SLOWDOWN
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  100044:	e8 4a 02 00 00       	call   100293 <rand>
  100049:	48 63 d0             	movslq %eax,%rdx
  10004c:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  100053:	48 c1 fa 25          	sar    $0x25,%rdx
  100057:	89 c1                	mov    %eax,%ecx
  100059:	c1 f9 1f             	sar    $0x1f,%ecx
  10005c:	29 ca                	sub    %ecx,%edx
  10005e:	6b d2 64             	imul   $0x64,%edx,%edx
  100061:	29 d0                	sub    %edx,%eax
  100063:	39 d8                	cmp    %ebx,%eax
  100065:	7d db                	jge    100042 <process_main+0x42>
#endif
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  100067:	48 8b 3d 9a 0f 00 00 	mov    0xf9a(%rip),%rdi        # 101008 <heap_top>
  10006e:	48 3b 3d 8b 0f 00 00 	cmp    0xf8b(%rip),%rdi        # 101000 <stack_bottom>
  100075:	74 1c                	je     100093 <process_main+0x93>
//    Allocate a page of memory at address `addr`. `Addr` must be page-aligned
//    (i.e., a multiple of PAGESIZE == 4096). Returns 0 on success and -1
//    on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  100077:	cd 33                	int    $0x33
  100079:	85 c0                	test   %eax,%eax
  10007b:	78 16                	js     100093 <process_main+0x93>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  10007d:	48 8b 05 84 0f 00 00 	mov    0xf84(%rip),%rax        # 101008 <heap_top>
  100084:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  100086:	48 81 05 77 0f 00 00 	addq   $0x1000,0xf77(%rip)        # 101008 <heap_top>
  10008d:	00 10 00 00 
  100091:	eb af                	jmp    100042 <process_main+0x42>
    asm volatile ("int %0" : /* no result */
  100093:	cd 32                	int    $0x32
  100095:	eb fc                	jmp    100093 <process_main+0x93>

0000000000100097 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100097:	f3 0f 1e fa          	endbr64 
  10009b:	48 89 f9             	mov    %rdi,%rcx
  10009e:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1000a0:	48 8d 05 f9 8e fb ff 	lea    -0x47107(%rip),%rax        # b8fa0 <console+0xfa0>
  1000a7:	48 39 41 08          	cmp    %rax,0x8(%rcx)
  1000ab:	72 0b                	jb     1000b8 <console_putc+0x21>
        cp->cursor = console;
  1000ad:	48 8d 80 60 f0 ff ff 	lea    -0xfa0(%rax),%rax
  1000b4:	48 89 41 08          	mov    %rax,0x8(%rcx)
    }
    if (c == '\n') {
  1000b8:	40 80 fe 0a          	cmp    $0xa,%sil
  1000bc:	74 16                	je     1000d4 <console_putc+0x3d>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1000be:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1000c2:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1000c6:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1000ca:	40 0f b6 f6          	movzbl %sil,%esi
  1000ce:	09 fe                	or     %edi,%esi
  1000d0:	66 89 30             	mov    %si,(%rax)
    }
}
  1000d3:	c3                   	ret    
        int pos = (cp->cursor - console) % 80;
  1000d4:	48 8d 05 25 7f fb ff 	lea    -0x480db(%rip),%rax        # b8000 <console>
  1000db:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1000df:	49 29 c0             	sub    %rax,%r8
  1000e2:	4c 89 c6             	mov    %r8,%rsi
  1000e5:	48 d1 fe             	sar    %rsi
  1000e8:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1000ef:	66 66 66 
  1000f2:	48 89 f0             	mov    %rsi,%rax
  1000f5:	48 f7 ea             	imul   %rdx
  1000f8:	48 c1 fa 05          	sar    $0x5,%rdx
  1000fc:	49 c1 f8 3f          	sar    $0x3f,%r8
  100100:	4c 29 c2             	sub    %r8,%rdx
  100103:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  100107:	48 c1 e2 04          	shl    $0x4,%rdx
  10010b:	89 f0                	mov    %esi,%eax
  10010d:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  10010f:	83 cf 20             	or     $0x20,%edi
  100112:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100116:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  10011a:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  10011e:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  100121:	83 c0 01             	add    $0x1,%eax
  100124:	83 f8 50             	cmp    $0x50,%eax
  100127:	75 e9                	jne    100112 <console_putc+0x7b>
  100129:	c3                   	ret    

000000000010012a <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  10012a:	f3 0f 1e fa          	endbr64 
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  10012e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100132:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  100136:	73 0b                	jae    100143 <string_putc+0x19>
        *sp->s++ = c;
  100138:	48 8d 50 01          	lea    0x1(%rax),%rdx
  10013c:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  100140:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  100143:	c3                   	ret    

0000000000100144 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  100144:	f3 0f 1e fa          	endbr64 
  100148:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  10014b:	48 85 d2             	test   %rdx,%rdx
  10014e:	74 17                	je     100167 <memcpy+0x23>
  100150:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  100155:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  10015a:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  10015e:	48 83 c1 01          	add    $0x1,%rcx
  100162:	48 39 d1             	cmp    %rdx,%rcx
  100165:	75 ee                	jne    100155 <memcpy+0x11>
}
  100167:	c3                   	ret    

0000000000100168 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  100168:	f3 0f 1e fa          	endbr64 
  10016c:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  10016f:	48 39 fe             	cmp    %rdi,%rsi
  100172:	72 1d                	jb     100191 <memmove+0x29>
        while (n-- > 0) {
  100174:	b9 00 00 00 00       	mov    $0x0,%ecx
  100179:	48 85 d2             	test   %rdx,%rdx
  10017c:	74 12                	je     100190 <memmove+0x28>
            *d++ = *s++;
  10017e:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  100182:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  100186:	48 83 c1 01          	add    $0x1,%rcx
  10018a:	48 39 ca             	cmp    %rcx,%rdx
  10018d:	75 ef                	jne    10017e <memmove+0x16>
}
  10018f:	c3                   	ret    
  100190:	c3                   	ret    
    if (s < d && s + n > d) {
  100191:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100195:	48 39 cf             	cmp    %rcx,%rdi
  100198:	73 da                	jae    100174 <memmove+0xc>
        while (n-- > 0) {
  10019a:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  10019e:	48 85 d2             	test   %rdx,%rdx
  1001a1:	74 ec                	je     10018f <memmove+0x27>
            *--d = *--s;
  1001a3:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  1001a7:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  1001aa:	48 83 e9 01          	sub    $0x1,%rcx
  1001ae:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  1001b2:	75 ef                	jne    1001a3 <memmove+0x3b>
  1001b4:	c3                   	ret    

00000000001001b5 <memset>:
void* memset(void* v, int c, size_t n) {
  1001b5:	f3 0f 1e fa          	endbr64 
  1001b9:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1001bc:	48 85 d2             	test   %rdx,%rdx
  1001bf:	74 12                	je     1001d3 <memset+0x1e>
  1001c1:	48 01 fa             	add    %rdi,%rdx
  1001c4:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1001c7:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1001ca:	48 83 c1 01          	add    $0x1,%rcx
  1001ce:	48 39 ca             	cmp    %rcx,%rdx
  1001d1:	75 f4                	jne    1001c7 <memset+0x12>
}
  1001d3:	c3                   	ret    

00000000001001d4 <strlen>:
size_t strlen(const char* s) {
  1001d4:	f3 0f 1e fa          	endbr64 
    for (n = 0; *s != '\0'; ++s) {
  1001d8:	80 3f 00             	cmpb   $0x0,(%rdi)
  1001db:	74 10                	je     1001ed <strlen+0x19>
  1001dd:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1001e2:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1001e6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1001ea:	75 f6                	jne    1001e2 <strlen+0xe>
  1001ec:	c3                   	ret    
  1001ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1001f2:	c3                   	ret    

00000000001001f3 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1001f3:	f3 0f 1e fa          	endbr64 
  1001f7:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001fa:	ba 00 00 00 00       	mov    $0x0,%edx
  1001ff:	48 85 f6             	test   %rsi,%rsi
  100202:	74 11                	je     100215 <strnlen+0x22>
  100204:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  100208:	74 0c                	je     100216 <strnlen+0x23>
        ++n;
  10020a:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10020e:	48 39 d0             	cmp    %rdx,%rax
  100211:	75 f1                	jne    100204 <strnlen+0x11>
  100213:	eb 04                	jmp    100219 <strnlen+0x26>
  100215:	c3                   	ret    
  100216:	48 89 d0             	mov    %rdx,%rax
}
  100219:	c3                   	ret    

000000000010021a <strcpy>:
char* strcpy(char* dst, const char* src) {
  10021a:	f3 0f 1e fa          	endbr64 
  10021e:	48 89 f8             	mov    %rdi,%rax
  100221:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  100226:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  10022a:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  10022d:	48 83 c2 01          	add    $0x1,%rdx
  100231:	84 c9                	test   %cl,%cl
  100233:	75 f1                	jne    100226 <strcpy+0xc>
}
  100235:	c3                   	ret    

0000000000100236 <strcmp>:
int strcmp(const char* a, const char* b) {
  100236:	f3 0f 1e fa          	endbr64 
    while (*a && *b && *a == *b) {
  10023a:	0f b6 07             	movzbl (%rdi),%eax
  10023d:	84 c0                	test   %al,%al
  10023f:	74 1a                	je     10025b <strcmp+0x25>
  100241:	0f b6 16             	movzbl (%rsi),%edx
  100244:	38 c2                	cmp    %al,%dl
  100246:	75 13                	jne    10025b <strcmp+0x25>
  100248:	84 d2                	test   %dl,%dl
  10024a:	74 0f                	je     10025b <strcmp+0x25>
        ++a, ++b;
  10024c:	48 83 c7 01          	add    $0x1,%rdi
  100250:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  100254:	0f b6 07             	movzbl (%rdi),%eax
  100257:	84 c0                	test   %al,%al
  100259:	75 e6                	jne    100241 <strcmp+0xb>
    return ((unsigned char) *a > (unsigned char) *b)
  10025b:	3a 06                	cmp    (%rsi),%al
  10025d:	0f 97 c0             	seta   %al
  100260:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  100263:	83 d8 00             	sbb    $0x0,%eax
}
  100266:	c3                   	ret    

0000000000100267 <strchr>:
char* strchr(const char* s, int c) {
  100267:	f3 0f 1e fa          	endbr64 
    while (*s && *s != (char) c) {
  10026b:	0f b6 07             	movzbl (%rdi),%eax
  10026e:	84 c0                	test   %al,%al
  100270:	74 10                	je     100282 <strchr+0x1b>
  100272:	40 38 f0             	cmp    %sil,%al
  100275:	74 18                	je     10028f <strchr+0x28>
        ++s;
  100277:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  10027b:	0f b6 07             	movzbl (%rdi),%eax
  10027e:	84 c0                	test   %al,%al
  100280:	75 f0                	jne    100272 <strchr+0xb>
        return NULL;
  100282:	40 84 f6             	test   %sil,%sil
  100285:	b8 00 00 00 00       	mov    $0x0,%eax
  10028a:	48 0f 44 c7          	cmove  %rdi,%rax
}
  10028e:	c3                   	ret    
  10028f:	48 89 f8             	mov    %rdi,%rax
  100292:	c3                   	ret    

0000000000100293 <rand>:
int rand(void) {
  100293:	f3 0f 1e fa          	endbr64 
    if (!rand_seed_set) {
  100297:	83 3d 76 0d 00 00 00 	cmpl   $0x0,0xd76(%rip)        # 101014 <rand_seed_set>
  10029e:	74 1b                	je     1002bb <rand+0x28>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1002a0:	69 05 66 0d 00 00 0d 	imul   $0x19660d,0xd66(%rip),%eax        # 101010 <rand_seed>
  1002a7:	66 19 00 
  1002aa:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1002af:	89 05 5b 0d 00 00    	mov    %eax,0xd5b(%rip)        # 101010 <rand_seed>
    return rand_seed & RAND_MAX;
  1002b5:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1002ba:	c3                   	ret    
    rand_seed = seed;
  1002bb:	c7 05 4b 0d 00 00 9e 	movl   $0x30d4879e,0xd4b(%rip)        # 101010 <rand_seed>
  1002c2:	87 d4 30 
    rand_seed_set = 1;
  1002c5:	c7 05 45 0d 00 00 01 	movl   $0x1,0xd45(%rip)        # 101014 <rand_seed_set>
  1002cc:	00 00 00 
}
  1002cf:	eb cf                	jmp    1002a0 <rand+0xd>

00000000001002d1 <srand>:
void srand(unsigned seed) {
  1002d1:	f3 0f 1e fa          	endbr64 
    rand_seed = seed;
  1002d5:	89 3d 35 0d 00 00    	mov    %edi,0xd35(%rip)        # 101010 <rand_seed>
    rand_seed_set = 1;
  1002db:	c7 05 2f 0d 00 00 01 	movl   $0x1,0xd2f(%rip)        # 101014 <rand_seed_set>
  1002e2:	00 00 00 
}
  1002e5:	c3                   	ret    

00000000001002e6 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1002e6:	f3 0f 1e fa          	endbr64 
  1002ea:	55                   	push   %rbp
  1002eb:	48 89 e5             	mov    %rsp,%rbp
  1002ee:	41 57                	push   %r15
  1002f0:	41 56                	push   %r14
  1002f2:	41 55                	push   %r13
  1002f4:	41 54                	push   %r12
  1002f6:	53                   	push   %rbx
  1002f7:	48 83 ec 58          	sub    $0x58,%rsp
  1002fb:	49 89 fe             	mov    %rdi,%r14
  1002fe:	89 75 ac             	mov    %esi,-0x54(%rbp)
  100301:	49 89 d4             	mov    %rdx,%r12
  100304:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  100308:	0f b6 02             	movzbl (%rdx),%eax
  10030b:	84 c0                	test   %al,%al
  10030d:	0f 85 cd 04 00 00    	jne    1007e0 <printer_vprintf+0x4fa>
}
  100313:	48 83 c4 58          	add    $0x58,%rsp
  100317:	5b                   	pop    %rbx
  100318:	41 5c                	pop    %r12
  10031a:	41 5d                	pop    %r13
  10031c:	41 5e                	pop    %r14
  10031e:	41 5f                	pop    %r15
  100320:	5d                   	pop    %rbp
  100321:	c3                   	ret    
        for (++format; *format; ++format) {
  100322:	4d 8d 7c 24 01       	lea    0x1(%r12),%r15
  100327:	41 0f b6 5c 24 01    	movzbl 0x1(%r12),%ebx
  10032d:	84 db                	test   %bl,%bl
  10032f:	0f 84 a4 06 00 00    	je     1009d9 <printer_vprintf+0x6f3>
        int flags = 0;
  100335:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  10033b:	4c 8d 25 0f 09 00 00 	lea    0x90f(%rip),%r12        # 100c51 <flag_chars>
  100342:	0f be f3             	movsbl %bl,%esi
  100345:	4c 89 e7             	mov    %r12,%rdi
  100348:	e8 1a ff ff ff       	call   100267 <strchr>
  10034d:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  100350:	48 85 c0             	test   %rax,%rax
  100353:	74 5c                	je     1003b1 <printer_vprintf+0xcb>
                flags |= 1 << (flagc - flag_chars);
  100355:	4c 29 e1             	sub    %r12,%rcx
  100358:	b8 01 00 00 00       	mov    $0x1,%eax
  10035d:	d3 e0                	shl    %cl,%eax
  10035f:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  100362:	49 83 c7 01          	add    $0x1,%r15
  100366:	41 0f b6 1f          	movzbl (%r15),%ebx
  10036a:	84 db                	test   %bl,%bl
  10036c:	75 d4                	jne    100342 <printer_vprintf+0x5c>
  10036e:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
        int width = -1;
  100372:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  100378:	c7 45 a8 ff ff ff ff 	movl   $0xffffffff,-0x58(%rbp)
        if (*format == '.') {
  10037f:	41 80 3f 2e          	cmpb   $0x2e,(%r15)
  100383:	0f 84 b3 00 00 00    	je     10043c <printer_vprintf+0x156>
        int length = 0;
  100389:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  10038e:	41 0f b6 17          	movzbl (%r15),%edx
  100392:	8d 42 bd             	lea    -0x43(%rdx),%eax
  100395:	3c 37                	cmp    $0x37,%al
  100397:	0f 87 e0 04 00 00    	ja     10087d <printer_vprintf+0x597>
  10039d:	0f b6 c0             	movzbl %al,%eax
  1003a0:	48 8d 3d 99 07 00 00 	lea    0x799(%rip),%rdi        # 100b40 <console_clear+0x47>
  1003a7:	48 63 04 87          	movslq (%rdi,%rax,4),%rax
  1003ab:	48 01 f8             	add    %rdi,%rax
  1003ae:	3e ff e0             	notrack jmp *%rax
        if (*format >= '1' && *format <= '9') {
  1003b1:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  1003b5:	8d 43 cf             	lea    -0x31(%rbx),%eax
  1003b8:	3c 08                	cmp    $0x8,%al
  1003ba:	77 31                	ja     1003ed <printer_vprintf+0x107>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1003bc:	41 0f b6 07          	movzbl (%r15),%eax
  1003c0:	8d 50 d0             	lea    -0x30(%rax),%edx
  1003c3:	80 fa 09             	cmp    $0x9,%dl
  1003c6:	77 5e                	ja     100426 <printer_vprintf+0x140>
  1003c8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  1003ce:	49 83 c7 01          	add    $0x1,%r15
  1003d2:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  1003d7:	0f be c0             	movsbl %al,%eax
  1003da:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1003df:	41 0f b6 07          	movzbl (%r15),%eax
  1003e3:	8d 50 d0             	lea    -0x30(%rax),%edx
  1003e6:	80 fa 09             	cmp    $0x9,%dl
  1003e9:	76 e3                	jbe    1003ce <printer_vprintf+0xe8>
  1003eb:	eb 8b                	jmp    100378 <printer_vprintf+0x92>
        } else if (*format == '*') {
  1003ed:	80 fb 2a             	cmp    $0x2a,%bl
  1003f0:	75 3f                	jne    100431 <printer_vprintf+0x14b>
            width = va_arg(val, int);
  1003f2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1003f6:	8b 07                	mov    (%rdi),%eax
  1003f8:	83 f8 2f             	cmp    $0x2f,%eax
  1003fb:	77 17                	ja     100414 <printer_vprintf+0x12e>
  1003fd:	89 c2                	mov    %eax,%edx
  1003ff:	48 03 57 10          	add    0x10(%rdi),%rdx
  100403:	83 c0 08             	add    $0x8,%eax
  100406:	89 07                	mov    %eax,(%rdi)
  100408:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  10040b:	49 83 c7 01          	add    $0x1,%r15
  10040f:	e9 64 ff ff ff       	jmp    100378 <printer_vprintf+0x92>
            width = va_arg(val, int);
  100414:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100418:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10041c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100420:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100424:	eb e2                	jmp    100408 <printer_vprintf+0x122>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100426:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  10042c:	e9 47 ff ff ff       	jmp    100378 <printer_vprintf+0x92>
        int width = -1;
  100431:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  100437:	e9 3c ff ff ff       	jmp    100378 <printer_vprintf+0x92>
            ++format;
  10043c:	49 8d 57 01          	lea    0x1(%r15),%rdx
            if (*format >= '0' && *format <= '9') {
  100440:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  100445:	8d 48 d0             	lea    -0x30(%rax),%ecx
  100448:	80 f9 09             	cmp    $0x9,%cl
  10044b:	76 13                	jbe    100460 <printer_vprintf+0x17a>
            } else if (*format == '*') {
  10044d:	3c 2a                	cmp    $0x2a,%al
  10044f:	74 33                	je     100484 <printer_vprintf+0x19e>
            ++format;
  100451:	49 89 d7             	mov    %rdx,%r15
                precision = 0;
  100454:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  10045b:	e9 29 ff ff ff       	jmp    100389 <printer_vprintf+0xa3>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100460:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  100465:	48 83 c2 01          	add    $0x1,%rdx
  100469:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  10046c:	0f be c0             	movsbl %al,%eax
  10046f:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100473:	0f b6 02             	movzbl (%rdx),%eax
  100476:	8d 70 d0             	lea    -0x30(%rax),%esi
  100479:	40 80 fe 09          	cmp    $0x9,%sil
  10047d:	76 e6                	jbe    100465 <printer_vprintf+0x17f>
                    precision = 10 * precision + *format++ - '0';
  10047f:	49 89 d7             	mov    %rdx,%r15
  100482:	eb 1c                	jmp    1004a0 <printer_vprintf+0x1ba>
                precision = va_arg(val, int);
  100484:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100488:	8b 01                	mov    (%rcx),%eax
  10048a:	83 f8 2f             	cmp    $0x2f,%eax
  10048d:	77 23                	ja     1004b2 <printer_vprintf+0x1cc>
  10048f:	89 c2                	mov    %eax,%edx
  100491:	48 03 51 10          	add    0x10(%rcx),%rdx
  100495:	83 c0 08             	add    $0x8,%eax
  100498:	89 01                	mov    %eax,(%rcx)
  10049a:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  10049c:	49 83 c7 02          	add    $0x2,%r15
            if (precision < 0) {
  1004a0:	85 c9                	test   %ecx,%ecx
  1004a2:	b8 00 00 00 00       	mov    $0x0,%eax
  1004a7:	0f 49 c1             	cmovns %ecx,%eax
  1004aa:	89 45 a8             	mov    %eax,-0x58(%rbp)
  1004ad:	e9 d7 fe ff ff       	jmp    100389 <printer_vprintf+0xa3>
                precision = va_arg(val, int);
  1004b2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004b6:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1004ba:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004be:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1004c2:	eb d6                	jmp    10049a <printer_vprintf+0x1b4>
        switch (*format) {
  1004c4:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1004c9:	e9 f6 00 00 00       	jmp    1005c4 <printer_vprintf+0x2de>
            ++format;
  1004ce:	49 83 c7 01          	add    $0x1,%r15
            length = 1;
  1004d2:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  1004d7:	e9 b2 fe ff ff       	jmp    10038e <printer_vprintf+0xa8>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1004dc:	85 c9                	test   %ecx,%ecx
  1004de:	74 56                	je     100536 <printer_vprintf+0x250>
  1004e0:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004e4:	8b 07                	mov    (%rdi),%eax
  1004e6:	83 f8 2f             	cmp    $0x2f,%eax
  1004e9:	77 39                	ja     100524 <printer_vprintf+0x23e>
  1004eb:	89 c2                	mov    %eax,%edx
  1004ed:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004f1:	83 c0 08             	add    $0x8,%eax
  1004f4:	89 07                	mov    %eax,(%rdi)
  1004f6:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1004f9:	48 89 d0             	mov    %rdx,%rax
  1004fc:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  100500:	49 89 d0             	mov    %rdx,%r8
  100503:	49 f7 d8             	neg    %r8
  100506:	25 80 00 00 00       	and    $0x80,%eax
  10050b:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  10050f:	0b 45 a0             	or     -0x60(%rbp),%eax
  100512:	83 c8 60             	or     $0x60,%eax
  100515:	89 45 a0             	mov    %eax,-0x60(%rbp)
        char* data = "";
  100518:	4c 8d 25 19 06 00 00 	lea    0x619(%rip),%r12        # 100b38 <console_clear+0x3f>
            break;
  10051f:	e9 39 01 00 00       	jmp    10065d <printer_vprintf+0x377>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100524:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100528:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10052c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100530:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100534:	eb c0                	jmp    1004f6 <printer_vprintf+0x210>
  100536:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10053a:	8b 01                	mov    (%rcx),%eax
  10053c:	83 f8 2f             	cmp    $0x2f,%eax
  10053f:	77 10                	ja     100551 <printer_vprintf+0x26b>
  100541:	89 c2                	mov    %eax,%edx
  100543:	48 03 51 10          	add    0x10(%rcx),%rdx
  100547:	83 c0 08             	add    $0x8,%eax
  10054a:	89 01                	mov    %eax,(%rcx)
  10054c:	48 63 12             	movslq (%rdx),%rdx
  10054f:	eb a8                	jmp    1004f9 <printer_vprintf+0x213>
  100551:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100555:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100559:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10055d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100561:	eb e9                	jmp    10054c <printer_vprintf+0x266>
        int base = 10;
  100563:	be 0a 00 00 00       	mov    $0xa,%esi
  100568:	eb 5a                	jmp    1005c4 <printer_vprintf+0x2de>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  10056a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10056e:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100572:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100576:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10057a:	eb 62                	jmp    1005de <printer_vprintf+0x2f8>
  10057c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100580:	8b 07                	mov    (%rdi),%eax
  100582:	83 f8 2f             	cmp    $0x2f,%eax
  100585:	77 10                	ja     100597 <printer_vprintf+0x2b1>
  100587:	89 c2                	mov    %eax,%edx
  100589:	48 03 57 10          	add    0x10(%rdi),%rdx
  10058d:	83 c0 08             	add    $0x8,%eax
  100590:	89 07                	mov    %eax,(%rdi)
  100592:	44 8b 02             	mov    (%rdx),%r8d
  100595:	eb 4a                	jmp    1005e1 <printer_vprintf+0x2fb>
  100597:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10059b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10059f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005a3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005a7:	eb e9                	jmp    100592 <printer_vprintf+0x2ac>
  1005a9:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1005ac:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
    const char* digits = upper_digits;
  1005b3:	48 8d 3d 86 06 00 00 	lea    0x686(%rip),%rdi        # 100c40 <upper_digits.1>
  1005ba:	e9 f3 02 00 00       	jmp    1008b2 <printer_vprintf+0x5cc>
            base = 16;
  1005bf:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1005c4:	85 c9                	test   %ecx,%ecx
  1005c6:	74 b4                	je     10057c <printer_vprintf+0x296>
  1005c8:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005cc:	8b 01                	mov    (%rcx),%eax
  1005ce:	83 f8 2f             	cmp    $0x2f,%eax
  1005d1:	77 97                	ja     10056a <printer_vprintf+0x284>
  1005d3:	89 c2                	mov    %eax,%edx
  1005d5:	48 03 51 10          	add    0x10(%rcx),%rdx
  1005d9:	83 c0 08             	add    $0x8,%eax
  1005dc:	89 01                	mov    %eax,(%rcx)
  1005de:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  1005e1:	83 4d a0 20          	orl    $0x20,-0x60(%rbp)
    if (base < 0) {
  1005e5:	85 f6                	test   %esi,%esi
  1005e7:	79 c0                	jns    1005a9 <printer_vprintf+0x2c3>
        base = -base;
  1005e9:	41 89 f1             	mov    %esi,%r9d
  1005ec:	f7 de                	neg    %esi
  1005ee:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
        digits = lower_digits;
  1005f5:	48 8d 3d 24 06 00 00 	lea    0x624(%rip),%rdi        # 100c20 <lower_digits.0>
  1005fc:	e9 b1 02 00 00       	jmp    1008b2 <printer_vprintf+0x5cc>
            num = (uintptr_t) va_arg(val, void*);
  100601:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100605:	8b 01                	mov    (%rcx),%eax
  100607:	83 f8 2f             	cmp    $0x2f,%eax
  10060a:	77 1c                	ja     100628 <printer_vprintf+0x342>
  10060c:	89 c2                	mov    %eax,%edx
  10060e:	48 03 51 10          	add    0x10(%rcx),%rdx
  100612:	83 c0 08             	add    $0x8,%eax
  100615:	89 01                	mov    %eax,(%rcx)
  100617:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  10061a:	81 4d a0 21 01 00 00 	orl    $0x121,-0x60(%rbp)
            base = -16;
  100621:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100626:	eb c1                	jmp    1005e9 <printer_vprintf+0x303>
            num = (uintptr_t) va_arg(val, void*);
  100628:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10062c:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100630:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100634:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100638:	eb dd                	jmp    100617 <printer_vprintf+0x331>
            data = va_arg(val, char*);
  10063a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10063e:	8b 07                	mov    (%rdi),%eax
  100640:	83 f8 2f             	cmp    $0x2f,%eax
  100643:	0f 87 b0 01 00 00    	ja     1007f9 <printer_vprintf+0x513>
  100649:	89 c2                	mov    %eax,%edx
  10064b:	48 03 57 10          	add    0x10(%rdi),%rdx
  10064f:	83 c0 08             	add    $0x8,%eax
  100652:	89 07                	mov    %eax,(%rdi)
  100654:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  100657:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  10065d:	8b 45 a0             	mov    -0x60(%rbp),%eax
  100660:	83 e0 20             	and    $0x20,%eax
  100663:	89 45 98             	mov    %eax,-0x68(%rbp)
  100666:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  10066c:	0f 85 2e 02 00 00    	jne    1008a0 <printer_vprintf+0x5ba>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100672:	8b 45 a0             	mov    -0x60(%rbp),%eax
  100675:	89 45 8c             	mov    %eax,-0x74(%rbp)
  100678:	83 e0 60             	and    $0x60,%eax
  10067b:	83 f8 60             	cmp    $0x60,%eax
  10067e:	0f 84 63 02 00 00    	je     1008e7 <printer_vprintf+0x601>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100684:	8b 45 a0             	mov    -0x60(%rbp),%eax
  100687:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  10068a:	48 8d 1d a7 04 00 00 	lea    0x4a7(%rip),%rbx        # 100b38 <console_clear+0x3f>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100691:	83 f8 21             	cmp    $0x21,%eax
  100694:	0f 84 8a 02 00 00    	je     100924 <printer_vprintf+0x63e>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  10069a:	8b 7d a8             	mov    -0x58(%rbp),%edi
  10069d:	89 f8                	mov    %edi,%eax
  10069f:	f7 d0                	not    %eax
  1006a1:	c1 e8 1f             	shr    $0x1f,%eax
  1006a4:	89 45 88             	mov    %eax,-0x78(%rbp)
  1006a7:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  1006ab:	0f 85 b2 02 00 00    	jne    100963 <printer_vprintf+0x67d>
  1006b1:	84 c0                	test   %al,%al
  1006b3:	0f 84 aa 02 00 00    	je     100963 <printer_vprintf+0x67d>
            len = strnlen(data, precision);
  1006b9:	48 63 f7             	movslq %edi,%rsi
  1006bc:	4c 89 e7             	mov    %r12,%rdi
  1006bf:	e8 2f fb ff ff       	call   1001f3 <strnlen>
  1006c4:	89 45 9c             	mov    %eax,-0x64(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1006c7:	8b 45 8c             	mov    -0x74(%rbp),%eax
  1006ca:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  1006cd:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1006d4:	83 f8 22             	cmp    $0x22,%eax
  1006d7:	0f 84 be 02 00 00    	je     10099b <printer_vprintf+0x6b5>
        width -= len + zeros + strlen(prefix);
  1006dd:	48 89 df             	mov    %rbx,%rdi
  1006e0:	e8 ef fa ff ff       	call   1001d4 <strlen>
  1006e5:	8b 55 a8             	mov    -0x58(%rbp),%edx
  1006e8:	03 55 9c             	add    -0x64(%rbp),%edx
  1006eb:	44 89 e9             	mov    %r13d,%ecx
  1006ee:	29 d1                	sub    %edx,%ecx
  1006f0:	29 c1                	sub    %eax,%ecx
  1006f2:	89 4d 98             	mov    %ecx,-0x68(%rbp)
  1006f5:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1006f8:	f6 45 a0 04          	testb  $0x4,-0x60(%rbp)
  1006fc:	75 37                	jne    100735 <printer_vprintf+0x44f>
  1006fe:	85 c9                	test   %ecx,%ecx
  100700:	7e 33                	jle    100735 <printer_vprintf+0x44f>
        width -= len + zeros + strlen(prefix);
  100702:	48 89 5d a0          	mov    %rbx,-0x60(%rbp)
  100706:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  100709:	89 da                	mov    %ebx,%edx
  10070b:	be 20 00 00 00       	mov    $0x20,%esi
  100710:	4c 89 f7             	mov    %r14,%rdi
  100713:	41 ff 16             	call   *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100716:	41 83 ed 01          	sub    $0x1,%r13d
  10071a:	45 85 ed             	test   %r13d,%r13d
  10071d:	7f ea                	jg     100709 <printer_vprintf+0x423>
  10071f:	48 8b 5d a0          	mov    -0x60(%rbp),%rbx
  100723:	8b 7d 98             	mov    -0x68(%rbp),%edi
  100726:	85 ff                	test   %edi,%edi
  100728:	b8 01 00 00 00       	mov    $0x1,%eax
  10072d:	0f 4f c7             	cmovg  %edi,%eax
  100730:	29 c7                	sub    %eax,%edi
  100732:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  100735:	0f b6 03             	movzbl (%rbx),%eax
  100738:	84 c0                	test   %al,%al
  10073a:	74 23                	je     10075f <printer_vprintf+0x479>
  10073c:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  100740:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, *prefix, color);
  100744:	0f b6 f0             	movzbl %al,%esi
  100747:	44 89 e2             	mov    %r12d,%edx
  10074a:	4c 89 f7             	mov    %r14,%rdi
  10074d:	41 ff 16             	call   *(%r14)
        for (; *prefix; ++prefix) {
  100750:	48 83 c3 01          	add    $0x1,%rbx
  100754:	0f b6 03             	movzbl (%rbx),%eax
  100757:	84 c0                	test   %al,%al
  100759:	75 e9                	jne    100744 <printer_vprintf+0x45e>
  10075b:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; zeros > 0; --zeros) {
  10075f:	8b 5d a8             	mov    -0x58(%rbp),%ebx
  100762:	85 db                	test   %ebx,%ebx
  100764:	7e 1f                	jle    100785 <printer_vprintf+0x49f>
  100766:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  10076a:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, '0', color);
  10076e:	44 89 e2             	mov    %r12d,%edx
  100771:	be 30 00 00 00       	mov    $0x30,%esi
  100776:	4c 89 f7             	mov    %r14,%rdi
  100779:	41 ff 16             	call   *(%r14)
        for (; zeros > 0; --zeros) {
  10077c:	83 eb 01             	sub    $0x1,%ebx
  10077f:	75 ed                	jne    10076e <printer_vprintf+0x488>
  100781:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; len > 0; ++data, --len) {
  100785:	8b 45 9c             	mov    -0x64(%rbp),%eax
  100788:	85 c0                	test   %eax,%eax
  10078a:	7e 28                	jle    1007b4 <printer_vprintf+0x4ce>
  10078c:	89 c3                	mov    %eax,%ebx
  10078e:	4c 01 e3             	add    %r12,%rbx
  100791:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  100795:	44 8b 6d ac          	mov    -0x54(%rbp),%r13d
            p->putc(p, *data, color);
  100799:	41 0f b6 34 24       	movzbl (%r12),%esi
  10079e:	44 89 ea             	mov    %r13d,%edx
  1007a1:	4c 89 f7             	mov    %r14,%rdi
  1007a4:	41 ff 16             	call   *(%r14)
        for (; len > 0; ++data, --len) {
  1007a7:	49 83 c4 01          	add    $0x1,%r12
  1007ab:	49 39 dc             	cmp    %rbx,%r12
  1007ae:	75 e9                	jne    100799 <printer_vprintf+0x4b3>
  1007b0:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
        for (; width > 0; --width) {
  1007b4:	45 85 ed             	test   %r13d,%r13d
  1007b7:	7e 16                	jle    1007cf <printer_vprintf+0x4e9>
  1007b9:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  1007bc:	89 da                	mov    %ebx,%edx
  1007be:	be 20 00 00 00       	mov    $0x20,%esi
  1007c3:	4c 89 f7             	mov    %r14,%rdi
  1007c6:	41 ff 16             	call   *(%r14)
        for (; width > 0; --width) {
  1007c9:	41 83 ed 01          	sub    $0x1,%r13d
  1007cd:	75 ed                	jne    1007bc <printer_vprintf+0x4d6>
    for (; *format; ++format) {
  1007cf:	4d 8d 67 01          	lea    0x1(%r15),%r12
  1007d3:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  1007d8:	84 c0                	test   %al,%al
  1007da:	0f 84 33 fb ff ff    	je     100313 <printer_vprintf+0x2d>
        if (*format != '%') {
  1007e0:	3c 25                	cmp    $0x25,%al
  1007e2:	0f 84 3a fb ff ff    	je     100322 <printer_vprintf+0x3c>
            p->putc(p, *format, color);
  1007e8:	0f b6 f0             	movzbl %al,%esi
  1007eb:	8b 55 ac             	mov    -0x54(%rbp),%edx
  1007ee:	4c 89 f7             	mov    %r14,%rdi
  1007f1:	41 ff 16             	call   *(%r14)
            continue;
  1007f4:	4d 89 e7             	mov    %r12,%r15
  1007f7:	eb d6                	jmp    1007cf <printer_vprintf+0x4e9>
            data = va_arg(val, char*);
  1007f9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1007fd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100801:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100805:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100809:	e9 46 fe ff ff       	jmp    100654 <printer_vprintf+0x36e>
            color = va_arg(val, int);
  10080e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100812:	8b 01                	mov    (%rcx),%eax
  100814:	83 f8 2f             	cmp    $0x2f,%eax
  100817:	77 12                	ja     10082b <printer_vprintf+0x545>
  100819:	89 c2                	mov    %eax,%edx
  10081b:	48 03 51 10          	add    0x10(%rcx),%rdx
  10081f:	83 c0 08             	add    $0x8,%eax
  100822:	89 01                	mov    %eax,(%rcx)
  100824:	8b 02                	mov    (%rdx),%eax
  100826:	89 45 ac             	mov    %eax,-0x54(%rbp)
            goto done;
  100829:	eb a4                	jmp    1007cf <printer_vprintf+0x4e9>
            color = va_arg(val, int);
  10082b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10082f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100833:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100837:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10083b:	eb e7                	jmp    100824 <printer_vprintf+0x53e>
            numbuf[0] = va_arg(val, int);
  10083d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100841:	8b 07                	mov    (%rdi),%eax
  100843:	83 f8 2f             	cmp    $0x2f,%eax
  100846:	77 23                	ja     10086b <printer_vprintf+0x585>
  100848:	89 c2                	mov    %eax,%edx
  10084a:	48 03 57 10          	add    0x10(%rdi),%rdx
  10084e:	83 c0 08             	add    $0x8,%eax
  100851:	89 07                	mov    %eax,(%rdi)
  100853:	8b 02                	mov    (%rdx),%eax
  100855:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  100858:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  10085c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100860:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  100866:	e9 f2 fd ff ff       	jmp    10065d <printer_vprintf+0x377>
            numbuf[0] = va_arg(val, int);
  10086b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10086f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100873:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100877:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10087b:	eb d6                	jmp    100853 <printer_vprintf+0x56d>
            numbuf[0] = (*format ? *format : '%');
  10087d:	84 d2                	test   %dl,%dl
  10087f:	0f 85 3e 01 00 00    	jne    1009c3 <printer_vprintf+0x6dd>
  100885:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  100889:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  10088d:	49 83 ef 01          	sub    $0x1,%r15
            data = numbuf;
  100891:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100895:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  10089b:	e9 bd fd ff ff       	jmp    10065d <printer_vprintf+0x377>
        if (flags & FLAG_NUMERIC) {
  1008a0:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1008a6:	48 8d 3d 93 03 00 00 	lea    0x393(%rip),%rdi        # 100c40 <upper_digits.1>
        if (flags & FLAG_NUMERIC) {
  1008ad:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1008b2:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1008b6:	4c 89 c1             	mov    %r8,%rcx
  1008b9:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1008bd:	48 63 f6             	movslq %esi,%rsi
  1008c0:	49 83 ec 01          	sub    $0x1,%r12
  1008c4:	48 89 c8             	mov    %rcx,%rax
  1008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  1008cc:	48 f7 f6             	div    %rsi
  1008cf:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1008d3:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1008d7:	48 89 ca             	mov    %rcx,%rdx
  1008da:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  1008dd:	48 39 d6             	cmp    %rdx,%rsi
  1008e0:	76 de                	jbe    1008c0 <printer_vprintf+0x5da>
  1008e2:	e9 8b fd ff ff       	jmp    100672 <printer_vprintf+0x38c>
                prefix = "-";
  1008e7:	48 8d 1d 47 02 00 00 	lea    0x247(%rip),%rbx        # 100b35 <console_clear+0x3c>
            if (flags & FLAG_NEGATIVE) {
  1008ee:	8b 45 a0             	mov    -0x60(%rbp),%eax
  1008f1:	a8 80                	test   $0x80,%al
  1008f3:	0f 85 a1 fd ff ff    	jne    10069a <printer_vprintf+0x3b4>
                prefix = "+";
  1008f9:	48 8d 1d 30 02 00 00 	lea    0x230(%rip),%rbx        # 100b30 <console_clear+0x37>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100900:	a8 10                	test   $0x10,%al
  100902:	0f 85 92 fd ff ff    	jne    10069a <printer_vprintf+0x3b4>
                prefix = " ";
  100908:	a8 08                	test   $0x8,%al
  10090a:	48 8d 15 27 02 00 00 	lea    0x227(%rip),%rdx        # 100b38 <console_clear+0x3f>
  100911:	48 8d 05 1f 02 00 00 	lea    0x21f(%rip),%rax        # 100b37 <console_clear+0x3e>
  100918:	48 0f 44 c2          	cmove  %rdx,%rax
  10091c:	48 89 c3             	mov    %rax,%rbx
  10091f:	e9 76 fd ff ff       	jmp    10069a <printer_vprintf+0x3b4>
                   && (base == 16 || base == -16)
  100924:	41 8d 41 10          	lea    0x10(%r9),%eax
  100928:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  10092d:	0f 85 67 fd ff ff    	jne    10069a <printer_vprintf+0x3b4>
                   && (num || (flags & FLAG_ALT2))) {
  100933:	4d 85 c0             	test   %r8,%r8
  100936:	75 0d                	jne    100945 <printer_vprintf+0x65f>
  100938:	f7 45 a0 00 01 00 00 	testl  $0x100,-0x60(%rbp)
  10093f:	0f 84 55 fd ff ff    	je     10069a <printer_vprintf+0x3b4>
            prefix = (base == -16 ? "0x" : "0X");
  100945:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  100949:	48 8d 15 e9 01 00 00 	lea    0x1e9(%rip),%rdx        # 100b39 <console_clear+0x40>
  100950:	48 8d 05 db 01 00 00 	lea    0x1db(%rip),%rax        # 100b32 <console_clear+0x39>
  100957:	48 0f 44 c2          	cmove  %rdx,%rax
  10095b:	48 89 c3             	mov    %rax,%rbx
  10095e:	e9 37 fd ff ff       	jmp    10069a <printer_vprintf+0x3b4>
            len = strlen(data);
  100963:	4c 89 e7             	mov    %r12,%rdi
  100966:	e8 69 f8 ff ff       	call   1001d4 <strlen>
  10096b:	89 45 9c             	mov    %eax,-0x64(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  10096e:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  100972:	0f 84 4f fd ff ff    	je     1006c7 <printer_vprintf+0x3e1>
  100978:	80 7d 88 00          	cmpb   $0x0,-0x78(%rbp)
  10097c:	0f 84 45 fd ff ff    	je     1006c7 <printer_vprintf+0x3e1>
            zeros = precision > len ? precision - len : 0;
  100982:	8b 4d a8             	mov    -0x58(%rbp),%ecx
  100985:	89 ca                	mov    %ecx,%edx
  100987:	29 c2                	sub    %eax,%edx
  100989:	39 c1                	cmp    %eax,%ecx
  10098b:	b8 00 00 00 00       	mov    $0x0,%eax
  100990:	0f 4f c2             	cmovg  %edx,%eax
  100993:	89 45 a8             	mov    %eax,-0x58(%rbp)
  100996:	e9 42 fd ff ff       	jmp    1006dd <printer_vprintf+0x3f7>
                   && len + (int) strlen(prefix) < width) {
  10099b:	48 89 df             	mov    %rbx,%rdi
  10099e:	e8 31 f8 ff ff       	call   1001d4 <strlen>
  1009a3:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1009a6:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1009a9:	44 89 e9             	mov    %r13d,%ecx
  1009ac:	29 f9                	sub    %edi,%ecx
  1009ae:	29 c1                	sub    %eax,%ecx
  1009b0:	44 39 ea             	cmp    %r13d,%edx
  1009b3:	b8 00 00 00 00       	mov    $0x0,%eax
  1009b8:	0f 4c c1             	cmovl  %ecx,%eax
  1009bb:	89 45 a8             	mov    %eax,-0x58(%rbp)
  1009be:	e9 1a fd ff ff       	jmp    1006dd <printer_vprintf+0x3f7>
            numbuf[0] = (*format ? *format : '%');
  1009c3:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1009c6:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1009ca:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1009ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1009d4:	e9 84 fc ff ff       	jmp    10065d <printer_vprintf+0x377>
        int flags = 0;
  1009d9:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%rbp)
  1009e0:	e9 8d f9 ff ff       	jmp    100372 <printer_vprintf+0x8c>

00000000001009e5 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1009e5:	f3 0f 1e fa          	endbr64 
  1009e9:	55                   	push   %rbp
  1009ea:	48 89 e5             	mov    %rsp,%rbp
  1009ed:	53                   	push   %rbx
  1009ee:	48 83 ec 18          	sub    $0x18,%rsp
    cp.p.putc = console_putc;
  1009f2:	48 8d 05 9e f6 ff ff 	lea    -0x962(%rip),%rax        # 100097 <console_putc>
  1009f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        cpos = 0;
  1009fd:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  100a03:	b8 00 00 00 00       	mov    $0x0,%eax
  100a08:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100a0b:	48 63 ff             	movslq %edi,%rdi
  100a0e:	48 8d 1d eb 75 fb ff 	lea    -0x48a15(%rip),%rbx        # b8000 <console>
  100a15:	48 8d 04 7b          	lea    (%rbx,%rdi,2),%rax
  100a19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100a1d:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  100a21:	e8 c0 f8 ff ff       	call   1002e6 <printer_vprintf>
    return cp.cursor - console;
  100a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100a2a:	48 29 d8             	sub    %rbx,%rax
  100a2d:	48 d1 f8             	sar    %rax
}
  100a30:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100a34:	c9                   	leave  
  100a35:	c3                   	ret    

0000000000100a36 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  100a36:	f3 0f 1e fa          	endbr64 
  100a3a:	55                   	push   %rbp
  100a3b:	48 89 e5             	mov    %rsp,%rbp
  100a3e:	48 83 ec 50          	sub    $0x50,%rsp
  100a42:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a46:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a4a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  100a4e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100a55:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100a59:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100a5d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100a61:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100a65:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a69:	e8 77 ff ff ff       	call   1009e5 <console_vprintf>
}
  100a6e:	c9                   	leave  
  100a6f:	c3                   	ret    

0000000000100a70 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100a70:	f3 0f 1e fa          	endbr64 
  100a74:	55                   	push   %rbp
  100a75:	48 89 e5             	mov    %rsp,%rbp
  100a78:	53                   	push   %rbx
  100a79:	48 83 ec 28          	sub    $0x28,%rsp
  100a7d:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100a80:	48 8d 05 a3 f6 ff ff 	lea    -0x95d(%rip),%rax        # 10012a <string_putc>
  100a87:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    sp.s = s;
  100a8b:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100a8f:	48 85 f6             	test   %rsi,%rsi
  100a92:	75 0b                	jne    100a9f <vsnprintf+0x2f>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100a94:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100a97:	29 d8                	sub    %ebx,%eax
}
  100a99:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100a9d:	c9                   	leave  
  100a9e:	c3                   	ret    
        sp.end = s + size - 1;
  100a9f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100aa4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100aa8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100aac:	be 00 00 00 00       	mov    $0x0,%esi
  100ab1:	e8 30 f8 ff ff       	call   1002e6 <printer_vprintf>
        *sp.s = 0;
  100ab6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100aba:	c6 00 00             	movb   $0x0,(%rax)
  100abd:	eb d5                	jmp    100a94 <vsnprintf+0x24>

0000000000100abf <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100abf:	f3 0f 1e fa          	endbr64 
  100ac3:	55                   	push   %rbp
  100ac4:	48 89 e5             	mov    %rsp,%rbp
  100ac7:	48 83 ec 50          	sub    $0x50,%rsp
  100acb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100acf:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100ad3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100ad7:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100ade:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100ae2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100ae6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100aea:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100aee:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100af2:	e8 79 ff ff ff       	call   100a70 <vsnprintf>
    va_end(val);
    return n;
}
  100af7:	c9                   	leave  
  100af8:	c3                   	ret    

0000000000100af9 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  100af9:	f3 0f 1e fa          	endbr64 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100afd:	48 8d 05 fc 74 fb ff 	lea    -0x48b04(%rip),%rax        # b8000 <console>
  100b04:	48 8d 90 a0 0f 00 00 	lea    0xfa0(%rax),%rdx
        console[i] = ' ' | 0x0700;
  100b0b:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b10:	48 83 c0 02          	add    $0x2,%rax
  100b14:	48 39 d0             	cmp    %rdx,%rax
  100b17:	75 f2                	jne    100b0b <console_clear+0x12>
    }
    cursorpos = 0;
  100b19:	c7 05 d9 84 fb ff 00 	movl   $0x0,-0x47b27(%rip)        # b8ffc <cursorpos>
  100b20:	00 00 00 
}
  100b23:	c3                   	ret    
