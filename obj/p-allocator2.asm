
obj/p-allocator2.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000140000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  140000:	f3 0f 1e fa          	endbr64 
  140004:	55                   	push   %rbp
  140005:	48 89 e5             	mov    %rsp,%rbp
  140008:	53                   	push   %rbx
  140009:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  14000d:	cd 31                	int    $0x31
  14000f:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  140011:	89 c7                	mov    %eax,%edi
  140013:	e8 b9 02 00 00       	call   1402d1 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  140018:	48 8d 05 f8 1f 00 00 	lea    0x1ff8(%rip),%rax        # 142017 <end+0xfff>
  14001f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  140025:	48 89 05 dc 0f 00 00 	mov    %rax,0xfdc(%rip)        # 141008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  14002c:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  14002f:	48 83 e8 01          	sub    $0x1,%rax
  140033:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  140039:	48 89 05 c0 0f 00 00 	mov    %rax,0xfc0(%rip)        # 141000 <stack_bottom>
  140040:	eb 02                	jmp    140044 <process_main+0x44>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  140042:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
#if !NO_SLOWDOWN
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  140044:	e8 4a 02 00 00       	call   140293 <rand>
  140049:	48 63 d0             	movslq %eax,%rdx
  14004c:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  140053:	48 c1 fa 25          	sar    $0x25,%rdx
  140057:	89 c1                	mov    %eax,%ecx
  140059:	c1 f9 1f             	sar    $0x1f,%ecx
  14005c:	29 ca                	sub    %ecx,%edx
  14005e:	6b d2 64             	imul   $0x64,%edx,%edx
  140061:	29 d0                	sub    %edx,%eax
  140063:	39 d8                	cmp    %ebx,%eax
  140065:	7d db                	jge    140042 <process_main+0x42>
#endif
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  140067:	48 8b 3d 9a 0f 00 00 	mov    0xf9a(%rip),%rdi        # 141008 <heap_top>
  14006e:	48 3b 3d 8b 0f 00 00 	cmp    0xf8b(%rip),%rdi        # 141000 <stack_bottom>
  140075:	74 1c                	je     140093 <process_main+0x93>
//    Allocate a page of memory at address `addr`. `Addr` must be page-aligned
//    (i.e., a multiple of PAGESIZE == 4096). Returns 0 on success and -1
//    on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  140077:	cd 33                	int    $0x33
  140079:	85 c0                	test   %eax,%eax
  14007b:	78 16                	js     140093 <process_main+0x93>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  14007d:	48 8b 05 84 0f 00 00 	mov    0xf84(%rip),%rax        # 141008 <heap_top>
  140084:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  140086:	48 81 05 77 0f 00 00 	addq   $0x1000,0xf77(%rip)        # 141008 <heap_top>
  14008d:	00 10 00 00 
  140091:	eb af                	jmp    140042 <process_main+0x42>
    asm volatile ("int %0" : /* no result */
  140093:	cd 32                	int    $0x32
  140095:	eb fc                	jmp    140093 <process_main+0x93>

0000000000140097 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  140097:	f3 0f 1e fa          	endbr64 
  14009b:	48 89 f9             	mov    %rdi,%rcx
  14009e:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1400a0:	48 8d 05 f9 8e f7 ff 	lea    -0x87107(%rip),%rax        # b8fa0 <console+0xfa0>
  1400a7:	48 39 41 08          	cmp    %rax,0x8(%rcx)
  1400ab:	72 0b                	jb     1400b8 <console_putc+0x21>
        cp->cursor = console;
  1400ad:	48 8d 80 60 f0 ff ff 	lea    -0xfa0(%rax),%rax
  1400b4:	48 89 41 08          	mov    %rax,0x8(%rcx)
    }
    if (c == '\n') {
  1400b8:	40 80 fe 0a          	cmp    $0xa,%sil
  1400bc:	74 16                	je     1400d4 <console_putc+0x3d>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1400be:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1400c2:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1400c6:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1400ca:	40 0f b6 f6          	movzbl %sil,%esi
  1400ce:	09 fe                	or     %edi,%esi
  1400d0:	66 89 30             	mov    %si,(%rax)
    }
}
  1400d3:	c3                   	ret    
        int pos = (cp->cursor - console) % 80;
  1400d4:	48 8d 05 25 7f f7 ff 	lea    -0x880db(%rip),%rax        # b8000 <console>
  1400db:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1400df:	49 29 c0             	sub    %rax,%r8
  1400e2:	4c 89 c6             	mov    %r8,%rsi
  1400e5:	48 d1 fe             	sar    %rsi
  1400e8:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1400ef:	66 66 66 
  1400f2:	48 89 f0             	mov    %rsi,%rax
  1400f5:	48 f7 ea             	imul   %rdx
  1400f8:	48 c1 fa 05          	sar    $0x5,%rdx
  1400fc:	49 c1 f8 3f          	sar    $0x3f,%r8
  140100:	4c 29 c2             	sub    %r8,%rdx
  140103:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  140107:	48 c1 e2 04          	shl    $0x4,%rdx
  14010b:	89 f0                	mov    %esi,%eax
  14010d:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  14010f:	83 cf 20             	or     $0x20,%edi
  140112:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140116:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  14011a:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  14011e:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  140121:	83 c0 01             	add    $0x1,%eax
  140124:	83 f8 50             	cmp    $0x50,%eax
  140127:	75 e9                	jne    140112 <console_putc+0x7b>
  140129:	c3                   	ret    

000000000014012a <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  14012a:	f3 0f 1e fa          	endbr64 
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  14012e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  140132:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  140136:	73 0b                	jae    140143 <string_putc+0x19>
        *sp->s++ = c;
  140138:	48 8d 50 01          	lea    0x1(%rax),%rdx
  14013c:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  140140:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  140143:	c3                   	ret    

0000000000140144 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  140144:	f3 0f 1e fa          	endbr64 
  140148:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  14014b:	48 85 d2             	test   %rdx,%rdx
  14014e:	74 17                	je     140167 <memcpy+0x23>
  140150:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  140155:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  14015a:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  14015e:	48 83 c1 01          	add    $0x1,%rcx
  140162:	48 39 d1             	cmp    %rdx,%rcx
  140165:	75 ee                	jne    140155 <memcpy+0x11>
}
  140167:	c3                   	ret    

0000000000140168 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  140168:	f3 0f 1e fa          	endbr64 
  14016c:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  14016f:	48 39 fe             	cmp    %rdi,%rsi
  140172:	72 1d                	jb     140191 <memmove+0x29>
        while (n-- > 0) {
  140174:	b9 00 00 00 00       	mov    $0x0,%ecx
  140179:	48 85 d2             	test   %rdx,%rdx
  14017c:	74 12                	je     140190 <memmove+0x28>
            *d++ = *s++;
  14017e:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  140182:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  140186:	48 83 c1 01          	add    $0x1,%rcx
  14018a:	48 39 ca             	cmp    %rcx,%rdx
  14018d:	75 ef                	jne    14017e <memmove+0x16>
}
  14018f:	c3                   	ret    
  140190:	c3                   	ret    
    if (s < d && s + n > d) {
  140191:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  140195:	48 39 cf             	cmp    %rcx,%rdi
  140198:	73 da                	jae    140174 <memmove+0xc>
        while (n-- > 0) {
  14019a:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  14019e:	48 85 d2             	test   %rdx,%rdx
  1401a1:	74 ec                	je     14018f <memmove+0x27>
            *--d = *--s;
  1401a3:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  1401a7:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  1401aa:	48 83 e9 01          	sub    $0x1,%rcx
  1401ae:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  1401b2:	75 ef                	jne    1401a3 <memmove+0x3b>
  1401b4:	c3                   	ret    

00000000001401b5 <memset>:
void* memset(void* v, int c, size_t n) {
  1401b5:	f3 0f 1e fa          	endbr64 
  1401b9:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1401bc:	48 85 d2             	test   %rdx,%rdx
  1401bf:	74 12                	je     1401d3 <memset+0x1e>
  1401c1:	48 01 fa             	add    %rdi,%rdx
  1401c4:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1401c7:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1401ca:	48 83 c1 01          	add    $0x1,%rcx
  1401ce:	48 39 ca             	cmp    %rcx,%rdx
  1401d1:	75 f4                	jne    1401c7 <memset+0x12>
}
  1401d3:	c3                   	ret    

00000000001401d4 <strlen>:
size_t strlen(const char* s) {
  1401d4:	f3 0f 1e fa          	endbr64 
    for (n = 0; *s != '\0'; ++s) {
  1401d8:	80 3f 00             	cmpb   $0x0,(%rdi)
  1401db:	74 10                	je     1401ed <strlen+0x19>
  1401dd:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1401e2:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1401e6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1401ea:	75 f6                	jne    1401e2 <strlen+0xe>
  1401ec:	c3                   	ret    
  1401ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1401f2:	c3                   	ret    

00000000001401f3 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1401f3:	f3 0f 1e fa          	endbr64 
  1401f7:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1401fa:	ba 00 00 00 00       	mov    $0x0,%edx
  1401ff:	48 85 f6             	test   %rsi,%rsi
  140202:	74 11                	je     140215 <strnlen+0x22>
  140204:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  140208:	74 0c                	je     140216 <strnlen+0x23>
        ++n;
  14020a:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  14020e:	48 39 d0             	cmp    %rdx,%rax
  140211:	75 f1                	jne    140204 <strnlen+0x11>
  140213:	eb 04                	jmp    140219 <strnlen+0x26>
  140215:	c3                   	ret    
  140216:	48 89 d0             	mov    %rdx,%rax
}
  140219:	c3                   	ret    

000000000014021a <strcpy>:
char* strcpy(char* dst, const char* src) {
  14021a:	f3 0f 1e fa          	endbr64 
  14021e:	48 89 f8             	mov    %rdi,%rax
  140221:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  140226:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  14022a:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  14022d:	48 83 c2 01          	add    $0x1,%rdx
  140231:	84 c9                	test   %cl,%cl
  140233:	75 f1                	jne    140226 <strcpy+0xc>
}
  140235:	c3                   	ret    

0000000000140236 <strcmp>:
int strcmp(const char* a, const char* b) {
  140236:	f3 0f 1e fa          	endbr64 
    while (*a && *b && *a == *b) {
  14023a:	0f b6 07             	movzbl (%rdi),%eax
  14023d:	84 c0                	test   %al,%al
  14023f:	74 1a                	je     14025b <strcmp+0x25>
  140241:	0f b6 16             	movzbl (%rsi),%edx
  140244:	38 c2                	cmp    %al,%dl
  140246:	75 13                	jne    14025b <strcmp+0x25>
  140248:	84 d2                	test   %dl,%dl
  14024a:	74 0f                	je     14025b <strcmp+0x25>
        ++a, ++b;
  14024c:	48 83 c7 01          	add    $0x1,%rdi
  140250:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  140254:	0f b6 07             	movzbl (%rdi),%eax
  140257:	84 c0                	test   %al,%al
  140259:	75 e6                	jne    140241 <strcmp+0xb>
    return ((unsigned char) *a > (unsigned char) *b)
  14025b:	3a 06                	cmp    (%rsi),%al
  14025d:	0f 97 c0             	seta   %al
  140260:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  140263:	83 d8 00             	sbb    $0x0,%eax
}
  140266:	c3                   	ret    

0000000000140267 <strchr>:
char* strchr(const char* s, int c) {
  140267:	f3 0f 1e fa          	endbr64 
    while (*s && *s != (char) c) {
  14026b:	0f b6 07             	movzbl (%rdi),%eax
  14026e:	84 c0                	test   %al,%al
  140270:	74 10                	je     140282 <strchr+0x1b>
  140272:	40 38 f0             	cmp    %sil,%al
  140275:	74 18                	je     14028f <strchr+0x28>
        ++s;
  140277:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  14027b:	0f b6 07             	movzbl (%rdi),%eax
  14027e:	84 c0                	test   %al,%al
  140280:	75 f0                	jne    140272 <strchr+0xb>
        return NULL;
  140282:	40 84 f6             	test   %sil,%sil
  140285:	b8 00 00 00 00       	mov    $0x0,%eax
  14028a:	48 0f 44 c7          	cmove  %rdi,%rax
}
  14028e:	c3                   	ret    
  14028f:	48 89 f8             	mov    %rdi,%rax
  140292:	c3                   	ret    

0000000000140293 <rand>:
int rand(void) {
  140293:	f3 0f 1e fa          	endbr64 
    if (!rand_seed_set) {
  140297:	83 3d 76 0d 00 00 00 	cmpl   $0x0,0xd76(%rip)        # 141014 <rand_seed_set>
  14029e:	74 1b                	je     1402bb <rand+0x28>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1402a0:	69 05 66 0d 00 00 0d 	imul   $0x19660d,0xd66(%rip),%eax        # 141010 <rand_seed>
  1402a7:	66 19 00 
  1402aa:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1402af:	89 05 5b 0d 00 00    	mov    %eax,0xd5b(%rip)        # 141010 <rand_seed>
    return rand_seed & RAND_MAX;
  1402b5:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1402ba:	c3                   	ret    
    rand_seed = seed;
  1402bb:	c7 05 4b 0d 00 00 9e 	movl   $0x30d4879e,0xd4b(%rip)        # 141010 <rand_seed>
  1402c2:	87 d4 30 
    rand_seed_set = 1;
  1402c5:	c7 05 45 0d 00 00 01 	movl   $0x1,0xd45(%rip)        # 141014 <rand_seed_set>
  1402cc:	00 00 00 
}
  1402cf:	eb cf                	jmp    1402a0 <rand+0xd>

00000000001402d1 <srand>:
void srand(unsigned seed) {
  1402d1:	f3 0f 1e fa          	endbr64 
    rand_seed = seed;
  1402d5:	89 3d 35 0d 00 00    	mov    %edi,0xd35(%rip)        # 141010 <rand_seed>
    rand_seed_set = 1;
  1402db:	c7 05 2f 0d 00 00 01 	movl   $0x1,0xd2f(%rip)        # 141014 <rand_seed_set>
  1402e2:	00 00 00 
}
  1402e5:	c3                   	ret    

00000000001402e6 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1402e6:	f3 0f 1e fa          	endbr64 
  1402ea:	55                   	push   %rbp
  1402eb:	48 89 e5             	mov    %rsp,%rbp
  1402ee:	41 57                	push   %r15
  1402f0:	41 56                	push   %r14
  1402f2:	41 55                	push   %r13
  1402f4:	41 54                	push   %r12
  1402f6:	53                   	push   %rbx
  1402f7:	48 83 ec 58          	sub    $0x58,%rsp
  1402fb:	49 89 fe             	mov    %rdi,%r14
  1402fe:	89 75 ac             	mov    %esi,-0x54(%rbp)
  140301:	49 89 d4             	mov    %rdx,%r12
  140304:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  140308:	0f b6 02             	movzbl (%rdx),%eax
  14030b:	84 c0                	test   %al,%al
  14030d:	0f 85 cd 04 00 00    	jne    1407e0 <printer_vprintf+0x4fa>
}
  140313:	48 83 c4 58          	add    $0x58,%rsp
  140317:	5b                   	pop    %rbx
  140318:	41 5c                	pop    %r12
  14031a:	41 5d                	pop    %r13
  14031c:	41 5e                	pop    %r14
  14031e:	41 5f                	pop    %r15
  140320:	5d                   	pop    %rbp
  140321:	c3                   	ret    
        for (++format; *format; ++format) {
  140322:	4d 8d 7c 24 01       	lea    0x1(%r12),%r15
  140327:	41 0f b6 5c 24 01    	movzbl 0x1(%r12),%ebx
  14032d:	84 db                	test   %bl,%bl
  14032f:	0f 84 a4 06 00 00    	je     1409d9 <printer_vprintf+0x6f3>
        int flags = 0;
  140335:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  14033b:	4c 8d 25 0f 09 00 00 	lea    0x90f(%rip),%r12        # 140c51 <flag_chars>
  140342:	0f be f3             	movsbl %bl,%esi
  140345:	4c 89 e7             	mov    %r12,%rdi
  140348:	e8 1a ff ff ff       	call   140267 <strchr>
  14034d:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  140350:	48 85 c0             	test   %rax,%rax
  140353:	74 5c                	je     1403b1 <printer_vprintf+0xcb>
                flags |= 1 << (flagc - flag_chars);
  140355:	4c 29 e1             	sub    %r12,%rcx
  140358:	b8 01 00 00 00       	mov    $0x1,%eax
  14035d:	d3 e0                	shl    %cl,%eax
  14035f:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  140362:	49 83 c7 01          	add    $0x1,%r15
  140366:	41 0f b6 1f          	movzbl (%r15),%ebx
  14036a:	84 db                	test   %bl,%bl
  14036c:	75 d4                	jne    140342 <printer_vprintf+0x5c>
  14036e:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
        int width = -1;
  140372:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  140378:	c7 45 a8 ff ff ff ff 	movl   $0xffffffff,-0x58(%rbp)
        if (*format == '.') {
  14037f:	41 80 3f 2e          	cmpb   $0x2e,(%r15)
  140383:	0f 84 b3 00 00 00    	je     14043c <printer_vprintf+0x156>
        int length = 0;
  140389:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  14038e:	41 0f b6 17          	movzbl (%r15),%edx
  140392:	8d 42 bd             	lea    -0x43(%rdx),%eax
  140395:	3c 37                	cmp    $0x37,%al
  140397:	0f 87 e0 04 00 00    	ja     14087d <printer_vprintf+0x597>
  14039d:	0f b6 c0             	movzbl %al,%eax
  1403a0:	48 8d 3d 99 07 00 00 	lea    0x799(%rip),%rdi        # 140b40 <console_clear+0x47>
  1403a7:	48 63 04 87          	movslq (%rdi,%rax,4),%rax
  1403ab:	48 01 f8             	add    %rdi,%rax
  1403ae:	3e ff e0             	notrack jmp *%rax
        if (*format >= '1' && *format <= '9') {
  1403b1:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  1403b5:	8d 43 cf             	lea    -0x31(%rbx),%eax
  1403b8:	3c 08                	cmp    $0x8,%al
  1403ba:	77 31                	ja     1403ed <printer_vprintf+0x107>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1403bc:	41 0f b6 07          	movzbl (%r15),%eax
  1403c0:	8d 50 d0             	lea    -0x30(%rax),%edx
  1403c3:	80 fa 09             	cmp    $0x9,%dl
  1403c6:	77 5e                	ja     140426 <printer_vprintf+0x140>
  1403c8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  1403ce:	49 83 c7 01          	add    $0x1,%r15
  1403d2:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  1403d7:	0f be c0             	movsbl %al,%eax
  1403da:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1403df:	41 0f b6 07          	movzbl (%r15),%eax
  1403e3:	8d 50 d0             	lea    -0x30(%rax),%edx
  1403e6:	80 fa 09             	cmp    $0x9,%dl
  1403e9:	76 e3                	jbe    1403ce <printer_vprintf+0xe8>
  1403eb:	eb 8b                	jmp    140378 <printer_vprintf+0x92>
        } else if (*format == '*') {
  1403ed:	80 fb 2a             	cmp    $0x2a,%bl
  1403f0:	75 3f                	jne    140431 <printer_vprintf+0x14b>
            width = va_arg(val, int);
  1403f2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1403f6:	8b 07                	mov    (%rdi),%eax
  1403f8:	83 f8 2f             	cmp    $0x2f,%eax
  1403fb:	77 17                	ja     140414 <printer_vprintf+0x12e>
  1403fd:	89 c2                	mov    %eax,%edx
  1403ff:	48 03 57 10          	add    0x10(%rdi),%rdx
  140403:	83 c0 08             	add    $0x8,%eax
  140406:	89 07                	mov    %eax,(%rdi)
  140408:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  14040b:	49 83 c7 01          	add    $0x1,%r15
  14040f:	e9 64 ff ff ff       	jmp    140378 <printer_vprintf+0x92>
            width = va_arg(val, int);
  140414:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140418:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  14041c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140420:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140424:	eb e2                	jmp    140408 <printer_vprintf+0x122>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  140426:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  14042c:	e9 47 ff ff ff       	jmp    140378 <printer_vprintf+0x92>
        int width = -1;
  140431:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  140437:	e9 3c ff ff ff       	jmp    140378 <printer_vprintf+0x92>
            ++format;
  14043c:	49 8d 57 01          	lea    0x1(%r15),%rdx
            if (*format >= '0' && *format <= '9') {
  140440:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  140445:	8d 48 d0             	lea    -0x30(%rax),%ecx
  140448:	80 f9 09             	cmp    $0x9,%cl
  14044b:	76 13                	jbe    140460 <printer_vprintf+0x17a>
            } else if (*format == '*') {
  14044d:	3c 2a                	cmp    $0x2a,%al
  14044f:	74 33                	je     140484 <printer_vprintf+0x19e>
            ++format;
  140451:	49 89 d7             	mov    %rdx,%r15
                precision = 0;
  140454:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  14045b:	e9 29 ff ff ff       	jmp    140389 <printer_vprintf+0xa3>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  140460:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  140465:	48 83 c2 01          	add    $0x1,%rdx
  140469:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  14046c:	0f be c0             	movsbl %al,%eax
  14046f:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  140473:	0f b6 02             	movzbl (%rdx),%eax
  140476:	8d 70 d0             	lea    -0x30(%rax),%esi
  140479:	40 80 fe 09          	cmp    $0x9,%sil
  14047d:	76 e6                	jbe    140465 <printer_vprintf+0x17f>
                    precision = 10 * precision + *format++ - '0';
  14047f:	49 89 d7             	mov    %rdx,%r15
  140482:	eb 1c                	jmp    1404a0 <printer_vprintf+0x1ba>
                precision = va_arg(val, int);
  140484:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140488:	8b 01                	mov    (%rcx),%eax
  14048a:	83 f8 2f             	cmp    $0x2f,%eax
  14048d:	77 23                	ja     1404b2 <printer_vprintf+0x1cc>
  14048f:	89 c2                	mov    %eax,%edx
  140491:	48 03 51 10          	add    0x10(%rcx),%rdx
  140495:	83 c0 08             	add    $0x8,%eax
  140498:	89 01                	mov    %eax,(%rcx)
  14049a:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  14049c:	49 83 c7 02          	add    $0x2,%r15
            if (precision < 0) {
  1404a0:	85 c9                	test   %ecx,%ecx
  1404a2:	b8 00 00 00 00       	mov    $0x0,%eax
  1404a7:	0f 49 c1             	cmovns %ecx,%eax
  1404aa:	89 45 a8             	mov    %eax,-0x58(%rbp)
  1404ad:	e9 d7 fe ff ff       	jmp    140389 <printer_vprintf+0xa3>
                precision = va_arg(val, int);
  1404b2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1404b6:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1404ba:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1404be:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1404c2:	eb d6                	jmp    14049a <printer_vprintf+0x1b4>
        switch (*format) {
  1404c4:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1404c9:	e9 f6 00 00 00       	jmp    1405c4 <printer_vprintf+0x2de>
            ++format;
  1404ce:	49 83 c7 01          	add    $0x1,%r15
            length = 1;
  1404d2:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  1404d7:	e9 b2 fe ff ff       	jmp    14038e <printer_vprintf+0xa8>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1404dc:	85 c9                	test   %ecx,%ecx
  1404de:	74 56                	je     140536 <printer_vprintf+0x250>
  1404e0:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1404e4:	8b 07                	mov    (%rdi),%eax
  1404e6:	83 f8 2f             	cmp    $0x2f,%eax
  1404e9:	77 39                	ja     140524 <printer_vprintf+0x23e>
  1404eb:	89 c2                	mov    %eax,%edx
  1404ed:	48 03 57 10          	add    0x10(%rdi),%rdx
  1404f1:	83 c0 08             	add    $0x8,%eax
  1404f4:	89 07                	mov    %eax,(%rdi)
  1404f6:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1404f9:	48 89 d0             	mov    %rdx,%rax
  1404fc:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  140500:	49 89 d0             	mov    %rdx,%r8
  140503:	49 f7 d8             	neg    %r8
  140506:	25 80 00 00 00       	and    $0x80,%eax
  14050b:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  14050f:	0b 45 a0             	or     -0x60(%rbp),%eax
  140512:	83 c8 60             	or     $0x60,%eax
  140515:	89 45 a0             	mov    %eax,-0x60(%rbp)
        char* data = "";
  140518:	4c 8d 25 19 06 00 00 	lea    0x619(%rip),%r12        # 140b38 <console_clear+0x3f>
            break;
  14051f:	e9 39 01 00 00       	jmp    14065d <printer_vprintf+0x377>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  140524:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140528:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  14052c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140530:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140534:	eb c0                	jmp    1404f6 <printer_vprintf+0x210>
  140536:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  14053a:	8b 01                	mov    (%rcx),%eax
  14053c:	83 f8 2f             	cmp    $0x2f,%eax
  14053f:	77 10                	ja     140551 <printer_vprintf+0x26b>
  140541:	89 c2                	mov    %eax,%edx
  140543:	48 03 51 10          	add    0x10(%rcx),%rdx
  140547:	83 c0 08             	add    $0x8,%eax
  14054a:	89 01                	mov    %eax,(%rcx)
  14054c:	48 63 12             	movslq (%rdx),%rdx
  14054f:	eb a8                	jmp    1404f9 <printer_vprintf+0x213>
  140551:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140555:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140559:	48 8d 42 08          	lea    0x8(%rdx),%rax
  14055d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140561:	eb e9                	jmp    14054c <printer_vprintf+0x266>
        int base = 10;
  140563:	be 0a 00 00 00       	mov    $0xa,%esi
  140568:	eb 5a                	jmp    1405c4 <printer_vprintf+0x2de>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  14056a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14056e:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  140572:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140576:	48 89 47 08          	mov    %rax,0x8(%rdi)
  14057a:	eb 62                	jmp    1405de <printer_vprintf+0x2f8>
  14057c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140580:	8b 07                	mov    (%rdi),%eax
  140582:	83 f8 2f             	cmp    $0x2f,%eax
  140585:	77 10                	ja     140597 <printer_vprintf+0x2b1>
  140587:	89 c2                	mov    %eax,%edx
  140589:	48 03 57 10          	add    0x10(%rdi),%rdx
  14058d:	83 c0 08             	add    $0x8,%eax
  140590:	89 07                	mov    %eax,(%rdi)
  140592:	44 8b 02             	mov    (%rdx),%r8d
  140595:	eb 4a                	jmp    1405e1 <printer_vprintf+0x2fb>
  140597:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  14059b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  14059f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1405a3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1405a7:	eb e9                	jmp    140592 <printer_vprintf+0x2ac>
  1405a9:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1405ac:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
    const char* digits = upper_digits;
  1405b3:	48 8d 3d 86 06 00 00 	lea    0x686(%rip),%rdi        # 140c40 <upper_digits.1>
  1405ba:	e9 f3 02 00 00       	jmp    1408b2 <printer_vprintf+0x5cc>
            base = 16;
  1405bf:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1405c4:	85 c9                	test   %ecx,%ecx
  1405c6:	74 b4                	je     14057c <printer_vprintf+0x296>
  1405c8:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1405cc:	8b 01                	mov    (%rcx),%eax
  1405ce:	83 f8 2f             	cmp    $0x2f,%eax
  1405d1:	77 97                	ja     14056a <printer_vprintf+0x284>
  1405d3:	89 c2                	mov    %eax,%edx
  1405d5:	48 03 51 10          	add    0x10(%rcx),%rdx
  1405d9:	83 c0 08             	add    $0x8,%eax
  1405dc:	89 01                	mov    %eax,(%rcx)
  1405de:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  1405e1:	83 4d a0 20          	orl    $0x20,-0x60(%rbp)
    if (base < 0) {
  1405e5:	85 f6                	test   %esi,%esi
  1405e7:	79 c0                	jns    1405a9 <printer_vprintf+0x2c3>
        base = -base;
  1405e9:	41 89 f1             	mov    %esi,%r9d
  1405ec:	f7 de                	neg    %esi
  1405ee:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
        digits = lower_digits;
  1405f5:	48 8d 3d 24 06 00 00 	lea    0x624(%rip),%rdi        # 140c20 <lower_digits.0>
  1405fc:	e9 b1 02 00 00       	jmp    1408b2 <printer_vprintf+0x5cc>
            num = (uintptr_t) va_arg(val, void*);
  140601:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140605:	8b 01                	mov    (%rcx),%eax
  140607:	83 f8 2f             	cmp    $0x2f,%eax
  14060a:	77 1c                	ja     140628 <printer_vprintf+0x342>
  14060c:	89 c2                	mov    %eax,%edx
  14060e:	48 03 51 10          	add    0x10(%rcx),%rdx
  140612:	83 c0 08             	add    $0x8,%eax
  140615:	89 01                	mov    %eax,(%rcx)
  140617:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  14061a:	81 4d a0 21 01 00 00 	orl    $0x121,-0x60(%rbp)
            base = -16;
  140621:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  140626:	eb c1                	jmp    1405e9 <printer_vprintf+0x303>
            num = (uintptr_t) va_arg(val, void*);
  140628:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14062c:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  140630:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140634:	48 89 47 08          	mov    %rax,0x8(%rdi)
  140638:	eb dd                	jmp    140617 <printer_vprintf+0x331>
            data = va_arg(val, char*);
  14063a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14063e:	8b 07                	mov    (%rdi),%eax
  140640:	83 f8 2f             	cmp    $0x2f,%eax
  140643:	0f 87 b0 01 00 00    	ja     1407f9 <printer_vprintf+0x513>
  140649:	89 c2                	mov    %eax,%edx
  14064b:	48 03 57 10          	add    0x10(%rdi),%rdx
  14064f:	83 c0 08             	add    $0x8,%eax
  140652:	89 07                	mov    %eax,(%rdi)
  140654:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  140657:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  14065d:	8b 45 a0             	mov    -0x60(%rbp),%eax
  140660:	83 e0 20             	and    $0x20,%eax
  140663:	89 45 98             	mov    %eax,-0x68(%rbp)
  140666:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  14066c:	0f 85 2e 02 00 00    	jne    1408a0 <printer_vprintf+0x5ba>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  140672:	8b 45 a0             	mov    -0x60(%rbp),%eax
  140675:	89 45 8c             	mov    %eax,-0x74(%rbp)
  140678:	83 e0 60             	and    $0x60,%eax
  14067b:	83 f8 60             	cmp    $0x60,%eax
  14067e:	0f 84 63 02 00 00    	je     1408e7 <printer_vprintf+0x601>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  140684:	8b 45 a0             	mov    -0x60(%rbp),%eax
  140687:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  14068a:	48 8d 1d a7 04 00 00 	lea    0x4a7(%rip),%rbx        # 140b38 <console_clear+0x3f>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  140691:	83 f8 21             	cmp    $0x21,%eax
  140694:	0f 84 8a 02 00 00    	je     140924 <printer_vprintf+0x63e>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  14069a:	8b 7d a8             	mov    -0x58(%rbp),%edi
  14069d:	89 f8                	mov    %edi,%eax
  14069f:	f7 d0                	not    %eax
  1406a1:	c1 e8 1f             	shr    $0x1f,%eax
  1406a4:	89 45 88             	mov    %eax,-0x78(%rbp)
  1406a7:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  1406ab:	0f 85 b2 02 00 00    	jne    140963 <printer_vprintf+0x67d>
  1406b1:	84 c0                	test   %al,%al
  1406b3:	0f 84 aa 02 00 00    	je     140963 <printer_vprintf+0x67d>
            len = strnlen(data, precision);
  1406b9:	48 63 f7             	movslq %edi,%rsi
  1406bc:	4c 89 e7             	mov    %r12,%rdi
  1406bf:	e8 2f fb ff ff       	call   1401f3 <strnlen>
  1406c4:	89 45 9c             	mov    %eax,-0x64(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1406c7:	8b 45 8c             	mov    -0x74(%rbp),%eax
  1406ca:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  1406cd:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1406d4:	83 f8 22             	cmp    $0x22,%eax
  1406d7:	0f 84 be 02 00 00    	je     14099b <printer_vprintf+0x6b5>
        width -= len + zeros + strlen(prefix);
  1406dd:	48 89 df             	mov    %rbx,%rdi
  1406e0:	e8 ef fa ff ff       	call   1401d4 <strlen>
  1406e5:	8b 55 a8             	mov    -0x58(%rbp),%edx
  1406e8:	03 55 9c             	add    -0x64(%rbp),%edx
  1406eb:	44 89 e9             	mov    %r13d,%ecx
  1406ee:	29 d1                	sub    %edx,%ecx
  1406f0:	29 c1                	sub    %eax,%ecx
  1406f2:	89 4d 98             	mov    %ecx,-0x68(%rbp)
  1406f5:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1406f8:	f6 45 a0 04          	testb  $0x4,-0x60(%rbp)
  1406fc:	75 37                	jne    140735 <printer_vprintf+0x44f>
  1406fe:	85 c9                	test   %ecx,%ecx
  140700:	7e 33                	jle    140735 <printer_vprintf+0x44f>
        width -= len + zeros + strlen(prefix);
  140702:	48 89 5d a0          	mov    %rbx,-0x60(%rbp)
  140706:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  140709:	89 da                	mov    %ebx,%edx
  14070b:	be 20 00 00 00       	mov    $0x20,%esi
  140710:	4c 89 f7             	mov    %r14,%rdi
  140713:	41 ff 16             	call   *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  140716:	41 83 ed 01          	sub    $0x1,%r13d
  14071a:	45 85 ed             	test   %r13d,%r13d
  14071d:	7f ea                	jg     140709 <printer_vprintf+0x423>
  14071f:	48 8b 5d a0          	mov    -0x60(%rbp),%rbx
  140723:	8b 7d 98             	mov    -0x68(%rbp),%edi
  140726:	85 ff                	test   %edi,%edi
  140728:	b8 01 00 00 00       	mov    $0x1,%eax
  14072d:	0f 4f c7             	cmovg  %edi,%eax
  140730:	29 c7                	sub    %eax,%edi
  140732:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  140735:	0f b6 03             	movzbl (%rbx),%eax
  140738:	84 c0                	test   %al,%al
  14073a:	74 23                	je     14075f <printer_vprintf+0x479>
  14073c:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  140740:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, *prefix, color);
  140744:	0f b6 f0             	movzbl %al,%esi
  140747:	44 89 e2             	mov    %r12d,%edx
  14074a:	4c 89 f7             	mov    %r14,%rdi
  14074d:	41 ff 16             	call   *(%r14)
        for (; *prefix; ++prefix) {
  140750:	48 83 c3 01          	add    $0x1,%rbx
  140754:	0f b6 03             	movzbl (%rbx),%eax
  140757:	84 c0                	test   %al,%al
  140759:	75 e9                	jne    140744 <printer_vprintf+0x45e>
  14075b:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; zeros > 0; --zeros) {
  14075f:	8b 5d a8             	mov    -0x58(%rbp),%ebx
  140762:	85 db                	test   %ebx,%ebx
  140764:	7e 1f                	jle    140785 <printer_vprintf+0x49f>
  140766:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  14076a:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, '0', color);
  14076e:	44 89 e2             	mov    %r12d,%edx
  140771:	be 30 00 00 00       	mov    $0x30,%esi
  140776:	4c 89 f7             	mov    %r14,%rdi
  140779:	41 ff 16             	call   *(%r14)
        for (; zeros > 0; --zeros) {
  14077c:	83 eb 01             	sub    $0x1,%ebx
  14077f:	75 ed                	jne    14076e <printer_vprintf+0x488>
  140781:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; len > 0; ++data, --len) {
  140785:	8b 45 9c             	mov    -0x64(%rbp),%eax
  140788:	85 c0                	test   %eax,%eax
  14078a:	7e 28                	jle    1407b4 <printer_vprintf+0x4ce>
  14078c:	89 c3                	mov    %eax,%ebx
  14078e:	4c 01 e3             	add    %r12,%rbx
  140791:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  140795:	44 8b 6d ac          	mov    -0x54(%rbp),%r13d
            p->putc(p, *data, color);
  140799:	41 0f b6 34 24       	movzbl (%r12),%esi
  14079e:	44 89 ea             	mov    %r13d,%edx
  1407a1:	4c 89 f7             	mov    %r14,%rdi
  1407a4:	41 ff 16             	call   *(%r14)
        for (; len > 0; ++data, --len) {
  1407a7:	49 83 c4 01          	add    $0x1,%r12
  1407ab:	49 39 dc             	cmp    %rbx,%r12
  1407ae:	75 e9                	jne    140799 <printer_vprintf+0x4b3>
  1407b0:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
        for (; width > 0; --width) {
  1407b4:	45 85 ed             	test   %r13d,%r13d
  1407b7:	7e 16                	jle    1407cf <printer_vprintf+0x4e9>
  1407b9:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  1407bc:	89 da                	mov    %ebx,%edx
  1407be:	be 20 00 00 00       	mov    $0x20,%esi
  1407c3:	4c 89 f7             	mov    %r14,%rdi
  1407c6:	41 ff 16             	call   *(%r14)
        for (; width > 0; --width) {
  1407c9:	41 83 ed 01          	sub    $0x1,%r13d
  1407cd:	75 ed                	jne    1407bc <printer_vprintf+0x4d6>
    for (; *format; ++format) {
  1407cf:	4d 8d 67 01          	lea    0x1(%r15),%r12
  1407d3:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  1407d8:	84 c0                	test   %al,%al
  1407da:	0f 84 33 fb ff ff    	je     140313 <printer_vprintf+0x2d>
        if (*format != '%') {
  1407e0:	3c 25                	cmp    $0x25,%al
  1407e2:	0f 84 3a fb ff ff    	je     140322 <printer_vprintf+0x3c>
            p->putc(p, *format, color);
  1407e8:	0f b6 f0             	movzbl %al,%esi
  1407eb:	8b 55 ac             	mov    -0x54(%rbp),%edx
  1407ee:	4c 89 f7             	mov    %r14,%rdi
  1407f1:	41 ff 16             	call   *(%r14)
            continue;
  1407f4:	4d 89 e7             	mov    %r12,%r15
  1407f7:	eb d6                	jmp    1407cf <printer_vprintf+0x4e9>
            data = va_arg(val, char*);
  1407f9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1407fd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140801:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140805:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140809:	e9 46 fe ff ff       	jmp    140654 <printer_vprintf+0x36e>
            color = va_arg(val, int);
  14080e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140812:	8b 01                	mov    (%rcx),%eax
  140814:	83 f8 2f             	cmp    $0x2f,%eax
  140817:	77 12                	ja     14082b <printer_vprintf+0x545>
  140819:	89 c2                	mov    %eax,%edx
  14081b:	48 03 51 10          	add    0x10(%rcx),%rdx
  14081f:	83 c0 08             	add    $0x8,%eax
  140822:	89 01                	mov    %eax,(%rcx)
  140824:	8b 02                	mov    (%rdx),%eax
  140826:	89 45 ac             	mov    %eax,-0x54(%rbp)
            goto done;
  140829:	eb a4                	jmp    1407cf <printer_vprintf+0x4e9>
            color = va_arg(val, int);
  14082b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14082f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  140833:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140837:	48 89 47 08          	mov    %rax,0x8(%rdi)
  14083b:	eb e7                	jmp    140824 <printer_vprintf+0x53e>
            numbuf[0] = va_arg(val, int);
  14083d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140841:	8b 07                	mov    (%rdi),%eax
  140843:	83 f8 2f             	cmp    $0x2f,%eax
  140846:	77 23                	ja     14086b <printer_vprintf+0x585>
  140848:	89 c2                	mov    %eax,%edx
  14084a:	48 03 57 10          	add    0x10(%rdi),%rdx
  14084e:	83 c0 08             	add    $0x8,%eax
  140851:	89 07                	mov    %eax,(%rdi)
  140853:	8b 02                	mov    (%rdx),%eax
  140855:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  140858:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  14085c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  140860:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  140866:	e9 f2 fd ff ff       	jmp    14065d <printer_vprintf+0x377>
            numbuf[0] = va_arg(val, int);
  14086b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  14086f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140873:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140877:	48 89 41 08          	mov    %rax,0x8(%rcx)
  14087b:	eb d6                	jmp    140853 <printer_vprintf+0x56d>
            numbuf[0] = (*format ? *format : '%');
  14087d:	84 d2                	test   %dl,%dl
  14087f:	0f 85 3e 01 00 00    	jne    1409c3 <printer_vprintf+0x6dd>
  140885:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  140889:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  14088d:	49 83 ef 01          	sub    $0x1,%r15
            data = numbuf;
  140891:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  140895:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  14089b:	e9 bd fd ff ff       	jmp    14065d <printer_vprintf+0x377>
        if (flags & FLAG_NUMERIC) {
  1408a0:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1408a6:	48 8d 3d 93 03 00 00 	lea    0x393(%rip),%rdi        # 140c40 <upper_digits.1>
        if (flags & FLAG_NUMERIC) {
  1408ad:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1408b2:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1408b6:	4c 89 c1             	mov    %r8,%rcx
  1408b9:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1408bd:	48 63 f6             	movslq %esi,%rsi
  1408c0:	49 83 ec 01          	sub    $0x1,%r12
  1408c4:	48 89 c8             	mov    %rcx,%rax
  1408c7:	ba 00 00 00 00       	mov    $0x0,%edx
  1408cc:	48 f7 f6             	div    %rsi
  1408cf:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1408d3:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1408d7:	48 89 ca             	mov    %rcx,%rdx
  1408da:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  1408dd:	48 39 d6             	cmp    %rdx,%rsi
  1408e0:	76 de                	jbe    1408c0 <printer_vprintf+0x5da>
  1408e2:	e9 8b fd ff ff       	jmp    140672 <printer_vprintf+0x38c>
                prefix = "-";
  1408e7:	48 8d 1d 47 02 00 00 	lea    0x247(%rip),%rbx        # 140b35 <console_clear+0x3c>
            if (flags & FLAG_NEGATIVE) {
  1408ee:	8b 45 a0             	mov    -0x60(%rbp),%eax
  1408f1:	a8 80                	test   $0x80,%al
  1408f3:	0f 85 a1 fd ff ff    	jne    14069a <printer_vprintf+0x3b4>
                prefix = "+";
  1408f9:	48 8d 1d 30 02 00 00 	lea    0x230(%rip),%rbx        # 140b30 <console_clear+0x37>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  140900:	a8 10                	test   $0x10,%al
  140902:	0f 85 92 fd ff ff    	jne    14069a <printer_vprintf+0x3b4>
                prefix = " ";
  140908:	a8 08                	test   $0x8,%al
  14090a:	48 8d 15 27 02 00 00 	lea    0x227(%rip),%rdx        # 140b38 <console_clear+0x3f>
  140911:	48 8d 05 1f 02 00 00 	lea    0x21f(%rip),%rax        # 140b37 <console_clear+0x3e>
  140918:	48 0f 44 c2          	cmove  %rdx,%rax
  14091c:	48 89 c3             	mov    %rax,%rbx
  14091f:	e9 76 fd ff ff       	jmp    14069a <printer_vprintf+0x3b4>
                   && (base == 16 || base == -16)
  140924:	41 8d 41 10          	lea    0x10(%r9),%eax
  140928:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  14092d:	0f 85 67 fd ff ff    	jne    14069a <printer_vprintf+0x3b4>
                   && (num || (flags & FLAG_ALT2))) {
  140933:	4d 85 c0             	test   %r8,%r8
  140936:	75 0d                	jne    140945 <printer_vprintf+0x65f>
  140938:	f7 45 a0 00 01 00 00 	testl  $0x100,-0x60(%rbp)
  14093f:	0f 84 55 fd ff ff    	je     14069a <printer_vprintf+0x3b4>
            prefix = (base == -16 ? "0x" : "0X");
  140945:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  140949:	48 8d 15 e9 01 00 00 	lea    0x1e9(%rip),%rdx        # 140b39 <console_clear+0x40>
  140950:	48 8d 05 db 01 00 00 	lea    0x1db(%rip),%rax        # 140b32 <console_clear+0x39>
  140957:	48 0f 44 c2          	cmove  %rdx,%rax
  14095b:	48 89 c3             	mov    %rax,%rbx
  14095e:	e9 37 fd ff ff       	jmp    14069a <printer_vprintf+0x3b4>
            len = strlen(data);
  140963:	4c 89 e7             	mov    %r12,%rdi
  140966:	e8 69 f8 ff ff       	call   1401d4 <strlen>
  14096b:	89 45 9c             	mov    %eax,-0x64(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  14096e:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  140972:	0f 84 4f fd ff ff    	je     1406c7 <printer_vprintf+0x3e1>
  140978:	80 7d 88 00          	cmpb   $0x0,-0x78(%rbp)
  14097c:	0f 84 45 fd ff ff    	je     1406c7 <printer_vprintf+0x3e1>
            zeros = precision > len ? precision - len : 0;
  140982:	8b 4d a8             	mov    -0x58(%rbp),%ecx
  140985:	89 ca                	mov    %ecx,%edx
  140987:	29 c2                	sub    %eax,%edx
  140989:	39 c1                	cmp    %eax,%ecx
  14098b:	b8 00 00 00 00       	mov    $0x0,%eax
  140990:	0f 4f c2             	cmovg  %edx,%eax
  140993:	89 45 a8             	mov    %eax,-0x58(%rbp)
  140996:	e9 42 fd ff ff       	jmp    1406dd <printer_vprintf+0x3f7>
                   && len + (int) strlen(prefix) < width) {
  14099b:	48 89 df             	mov    %rbx,%rdi
  14099e:	e8 31 f8 ff ff       	call   1401d4 <strlen>
  1409a3:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1409a6:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1409a9:	44 89 e9             	mov    %r13d,%ecx
  1409ac:	29 f9                	sub    %edi,%ecx
  1409ae:	29 c1                	sub    %eax,%ecx
  1409b0:	44 39 ea             	cmp    %r13d,%edx
  1409b3:	b8 00 00 00 00       	mov    $0x0,%eax
  1409b8:	0f 4c c1             	cmovl  %ecx,%eax
  1409bb:	89 45 a8             	mov    %eax,-0x58(%rbp)
  1409be:	e9 1a fd ff ff       	jmp    1406dd <printer_vprintf+0x3f7>
            numbuf[0] = (*format ? *format : '%');
  1409c3:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1409c6:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1409ca:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1409ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1409d4:	e9 84 fc ff ff       	jmp    14065d <printer_vprintf+0x377>
        int flags = 0;
  1409d9:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%rbp)
  1409e0:	e9 8d f9 ff ff       	jmp    140372 <printer_vprintf+0x8c>

00000000001409e5 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1409e5:	f3 0f 1e fa          	endbr64 
  1409e9:	55                   	push   %rbp
  1409ea:	48 89 e5             	mov    %rsp,%rbp
  1409ed:	53                   	push   %rbx
  1409ee:	48 83 ec 18          	sub    $0x18,%rsp
    cp.p.putc = console_putc;
  1409f2:	48 8d 05 9e f6 ff ff 	lea    -0x962(%rip),%rax        # 140097 <console_putc>
  1409f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        cpos = 0;
  1409fd:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  140a03:	b8 00 00 00 00       	mov    $0x0,%eax
  140a08:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  140a0b:	48 63 ff             	movslq %edi,%rdi
  140a0e:	48 8d 1d eb 75 f7 ff 	lea    -0x88a15(%rip),%rbx        # b8000 <console>
  140a15:	48 8d 04 7b          	lea    (%rbx,%rdi,2),%rax
  140a19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  140a1d:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  140a21:	e8 c0 f8 ff ff       	call   1402e6 <printer_vprintf>
    return cp.cursor - console;
  140a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  140a2a:	48 29 d8             	sub    %rbx,%rax
  140a2d:	48 d1 f8             	sar    %rax
}
  140a30:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  140a34:	c9                   	leave  
  140a35:	c3                   	ret    

0000000000140a36 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  140a36:	f3 0f 1e fa          	endbr64 
  140a3a:	55                   	push   %rbp
  140a3b:	48 89 e5             	mov    %rsp,%rbp
  140a3e:	48 83 ec 50          	sub    $0x50,%rsp
  140a42:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  140a46:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  140a4a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  140a4e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  140a55:	48 8d 45 10          	lea    0x10(%rbp),%rax
  140a59:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  140a5d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  140a61:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  140a65:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  140a69:	e8 77 ff ff ff       	call   1409e5 <console_vprintf>
}
  140a6e:	c9                   	leave  
  140a6f:	c3                   	ret    

0000000000140a70 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  140a70:	f3 0f 1e fa          	endbr64 
  140a74:	55                   	push   %rbp
  140a75:	48 89 e5             	mov    %rsp,%rbp
  140a78:	53                   	push   %rbx
  140a79:	48 83 ec 28          	sub    $0x28,%rsp
  140a7d:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  140a80:	48 8d 05 a3 f6 ff ff 	lea    -0x95d(%rip),%rax        # 14012a <string_putc>
  140a87:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    sp.s = s;
  140a8b:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  140a8f:	48 85 f6             	test   %rsi,%rsi
  140a92:	75 0b                	jne    140a9f <vsnprintf+0x2f>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  140a94:	8b 45 e0             	mov    -0x20(%rbp),%eax
  140a97:	29 d8                	sub    %ebx,%eax
}
  140a99:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  140a9d:	c9                   	leave  
  140a9e:	c3                   	ret    
        sp.end = s + size - 1;
  140a9f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  140aa4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  140aa8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  140aac:	be 00 00 00 00       	mov    $0x0,%esi
  140ab1:	e8 30 f8 ff ff       	call   1402e6 <printer_vprintf>
        *sp.s = 0;
  140ab6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  140aba:	c6 00 00             	movb   $0x0,(%rax)
  140abd:	eb d5                	jmp    140a94 <vsnprintf+0x24>

0000000000140abf <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  140abf:	f3 0f 1e fa          	endbr64 
  140ac3:	55                   	push   %rbp
  140ac4:	48 89 e5             	mov    %rsp,%rbp
  140ac7:	48 83 ec 50          	sub    $0x50,%rsp
  140acb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  140acf:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  140ad3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  140ad7:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  140ade:	48 8d 45 10          	lea    0x10(%rbp),%rax
  140ae2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  140ae6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  140aea:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  140aee:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  140af2:	e8 79 ff ff ff       	call   140a70 <vsnprintf>
    va_end(val);
    return n;
}
  140af7:	c9                   	leave  
  140af8:	c3                   	ret    

0000000000140af9 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  140af9:	f3 0f 1e fa          	endbr64 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  140afd:	48 8d 05 fc 74 f7 ff 	lea    -0x88b04(%rip),%rax        # b8000 <console>
  140b04:	48 8d 90 a0 0f 00 00 	lea    0xfa0(%rax),%rdx
        console[i] = ' ' | 0x0700;
  140b0b:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  140b10:	48 83 c0 02          	add    $0x2,%rax
  140b14:	48 39 d0             	cmp    %rdx,%rax
  140b17:	75 f2                	jne    140b0b <console_clear+0x12>
    }
    cursorpos = 0;
  140b19:	c7 05 d9 84 f7 ff 00 	movl   $0x0,-0x87b27(%rip)        # b8ffc <cursorpos>
  140b20:	00 00 00 
}
  140b23:	c3                   	ret    
