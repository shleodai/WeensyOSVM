
obj/p-allocator4.full:     file format elf64-x86-64


Disassembly of section .text:

00000000001c0000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  1c0000:	f3 0f 1e fa          	endbr64 
  1c0004:	55                   	push   %rbp
  1c0005:	48 89 e5             	mov    %rsp,%rbp
  1c0008:	53                   	push   %rbx
  1c0009:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  1c000d:	cd 31                	int    $0x31
  1c000f:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  1c0011:	89 c7                	mov    %eax,%edi
  1c0013:	e8 b9 02 00 00       	call   1c02d1 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  1c0018:	48 8d 05 f8 1f 00 00 	lea    0x1ff8(%rip),%rax        # 1c2017 <end+0xfff>
  1c001f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c0025:	48 89 05 dc 0f 00 00 	mov    %rax,0xfdc(%rip)        # 1c1008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  1c002c:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  1c002f:	48 83 e8 01          	sub    $0x1,%rax
  1c0033:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c0039:	48 89 05 c0 0f 00 00 	mov    %rax,0xfc0(%rip)        # 1c1000 <stack_bottom>
  1c0040:	eb 02                	jmp    1c0044 <process_main+0x44>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  1c0042:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
#if !NO_SLOWDOWN
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  1c0044:	e8 4a 02 00 00       	call   1c0293 <rand>
  1c0049:	48 63 d0             	movslq %eax,%rdx
  1c004c:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  1c0053:	48 c1 fa 25          	sar    $0x25,%rdx
  1c0057:	89 c1                	mov    %eax,%ecx
  1c0059:	c1 f9 1f             	sar    $0x1f,%ecx
  1c005c:	29 ca                	sub    %ecx,%edx
  1c005e:	6b d2 64             	imul   $0x64,%edx,%edx
  1c0061:	29 d0                	sub    %edx,%eax
  1c0063:	39 d8                	cmp    %ebx,%eax
  1c0065:	7d db                	jge    1c0042 <process_main+0x42>
#endif
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1c0067:	48 8b 3d 9a 0f 00 00 	mov    0xf9a(%rip),%rdi        # 1c1008 <heap_top>
  1c006e:	48 3b 3d 8b 0f 00 00 	cmp    0xf8b(%rip),%rdi        # 1c1000 <stack_bottom>
  1c0075:	74 1c                	je     1c0093 <process_main+0x93>
//    Allocate a page of memory at address `addr`. `Addr` must be page-aligned
//    (i.e., a multiple of PAGESIZE == 4096). Returns 0 on success and -1
//    on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  1c0077:	cd 33                	int    $0x33
  1c0079:	85 c0                	test   %eax,%eax
  1c007b:	78 16                	js     1c0093 <process_main+0x93>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  1c007d:	48 8b 05 84 0f 00 00 	mov    0xf84(%rip),%rax        # 1c1008 <heap_top>
  1c0084:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  1c0086:	48 81 05 77 0f 00 00 	addq   $0x1000,0xf77(%rip)        # 1c1008 <heap_top>
  1c008d:	00 10 00 00 
  1c0091:	eb af                	jmp    1c0042 <process_main+0x42>
    asm volatile ("int %0" : /* no result */
  1c0093:	cd 32                	int    $0x32
  1c0095:	eb fc                	jmp    1c0093 <process_main+0x93>

00000000001c0097 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  1c0097:	f3 0f 1e fa          	endbr64 
  1c009b:	48 89 f9             	mov    %rdi,%rcx
  1c009e:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1c00a0:	48 8d 05 f9 8e ef ff 	lea    -0x107107(%rip),%rax        # b8fa0 <console+0xfa0>
  1c00a7:	48 39 41 08          	cmp    %rax,0x8(%rcx)
  1c00ab:	72 0b                	jb     1c00b8 <console_putc+0x21>
        cp->cursor = console;
  1c00ad:	48 8d 80 60 f0 ff ff 	lea    -0xfa0(%rax),%rax
  1c00b4:	48 89 41 08          	mov    %rax,0x8(%rcx)
    }
    if (c == '\n') {
  1c00b8:	40 80 fe 0a          	cmp    $0xa,%sil
  1c00bc:	74 16                	je     1c00d4 <console_putc+0x3d>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1c00be:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1c00c2:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1c00c6:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1c00ca:	40 0f b6 f6          	movzbl %sil,%esi
  1c00ce:	09 fe                	or     %edi,%esi
  1c00d0:	66 89 30             	mov    %si,(%rax)
    }
}
  1c00d3:	c3                   	ret    
        int pos = (cp->cursor - console) % 80;
  1c00d4:	48 8d 05 25 7f ef ff 	lea    -0x1080db(%rip),%rax        # b8000 <console>
  1c00db:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1c00df:	49 29 c0             	sub    %rax,%r8
  1c00e2:	4c 89 c6             	mov    %r8,%rsi
  1c00e5:	48 d1 fe             	sar    %rsi
  1c00e8:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1c00ef:	66 66 66 
  1c00f2:	48 89 f0             	mov    %rsi,%rax
  1c00f5:	48 f7 ea             	imul   %rdx
  1c00f8:	48 c1 fa 05          	sar    $0x5,%rdx
  1c00fc:	49 c1 f8 3f          	sar    $0x3f,%r8
  1c0100:	4c 29 c2             	sub    %r8,%rdx
  1c0103:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1c0107:	48 c1 e2 04          	shl    $0x4,%rdx
  1c010b:	89 f0                	mov    %esi,%eax
  1c010d:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1c010f:	83 cf 20             	or     $0x20,%edi
  1c0112:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0116:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  1c011a:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  1c011e:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  1c0121:	83 c0 01             	add    $0x1,%eax
  1c0124:	83 f8 50             	cmp    $0x50,%eax
  1c0127:	75 e9                	jne    1c0112 <console_putc+0x7b>
  1c0129:	c3                   	ret    

00000000001c012a <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  1c012a:	f3 0f 1e fa          	endbr64 
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1c012e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1c0132:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1c0136:	73 0b                	jae    1c0143 <string_putc+0x19>
        *sp->s++ = c;
  1c0138:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1c013c:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1c0140:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1c0143:	c3                   	ret    

00000000001c0144 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1c0144:	f3 0f 1e fa          	endbr64 
  1c0148:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c014b:	48 85 d2             	test   %rdx,%rdx
  1c014e:	74 17                	je     1c0167 <memcpy+0x23>
  1c0150:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1c0155:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1c015a:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c015e:	48 83 c1 01          	add    $0x1,%rcx
  1c0162:	48 39 d1             	cmp    %rdx,%rcx
  1c0165:	75 ee                	jne    1c0155 <memcpy+0x11>
}
  1c0167:	c3                   	ret    

00000000001c0168 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  1c0168:	f3 0f 1e fa          	endbr64 
  1c016c:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  1c016f:	48 39 fe             	cmp    %rdi,%rsi
  1c0172:	72 1d                	jb     1c0191 <memmove+0x29>
        while (n-- > 0) {
  1c0174:	b9 00 00 00 00       	mov    $0x0,%ecx
  1c0179:	48 85 d2             	test   %rdx,%rdx
  1c017c:	74 12                	je     1c0190 <memmove+0x28>
            *d++ = *s++;
  1c017e:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  1c0182:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  1c0186:	48 83 c1 01          	add    $0x1,%rcx
  1c018a:	48 39 ca             	cmp    %rcx,%rdx
  1c018d:	75 ef                	jne    1c017e <memmove+0x16>
}
  1c018f:	c3                   	ret    
  1c0190:	c3                   	ret    
    if (s < d && s + n > d) {
  1c0191:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  1c0195:	48 39 cf             	cmp    %rcx,%rdi
  1c0198:	73 da                	jae    1c0174 <memmove+0xc>
        while (n-- > 0) {
  1c019a:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  1c019e:	48 85 d2             	test   %rdx,%rdx
  1c01a1:	74 ec                	je     1c018f <memmove+0x27>
            *--d = *--s;
  1c01a3:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  1c01a7:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  1c01aa:	48 83 e9 01          	sub    $0x1,%rcx
  1c01ae:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  1c01b2:	75 ef                	jne    1c01a3 <memmove+0x3b>
  1c01b4:	c3                   	ret    

00000000001c01b5 <memset>:
void* memset(void* v, int c, size_t n) {
  1c01b5:	f3 0f 1e fa          	endbr64 
  1c01b9:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c01bc:	48 85 d2             	test   %rdx,%rdx
  1c01bf:	74 12                	je     1c01d3 <memset+0x1e>
  1c01c1:	48 01 fa             	add    %rdi,%rdx
  1c01c4:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1c01c7:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c01ca:	48 83 c1 01          	add    $0x1,%rcx
  1c01ce:	48 39 ca             	cmp    %rcx,%rdx
  1c01d1:	75 f4                	jne    1c01c7 <memset+0x12>
}
  1c01d3:	c3                   	ret    

00000000001c01d4 <strlen>:
size_t strlen(const char* s) {
  1c01d4:	f3 0f 1e fa          	endbr64 
    for (n = 0; *s != '\0'; ++s) {
  1c01d8:	80 3f 00             	cmpb   $0x0,(%rdi)
  1c01db:	74 10                	je     1c01ed <strlen+0x19>
  1c01dd:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1c01e2:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1c01e6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1c01ea:	75 f6                	jne    1c01e2 <strlen+0xe>
  1c01ec:	c3                   	ret    
  1c01ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1c01f2:	c3                   	ret    

00000000001c01f3 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1c01f3:	f3 0f 1e fa          	endbr64 
  1c01f7:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c01fa:	ba 00 00 00 00       	mov    $0x0,%edx
  1c01ff:	48 85 f6             	test   %rsi,%rsi
  1c0202:	74 11                	je     1c0215 <strnlen+0x22>
  1c0204:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1c0208:	74 0c                	je     1c0216 <strnlen+0x23>
        ++n;
  1c020a:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c020e:	48 39 d0             	cmp    %rdx,%rax
  1c0211:	75 f1                	jne    1c0204 <strnlen+0x11>
  1c0213:	eb 04                	jmp    1c0219 <strnlen+0x26>
  1c0215:	c3                   	ret    
  1c0216:	48 89 d0             	mov    %rdx,%rax
}
  1c0219:	c3                   	ret    

00000000001c021a <strcpy>:
char* strcpy(char* dst, const char* src) {
  1c021a:	f3 0f 1e fa          	endbr64 
  1c021e:	48 89 f8             	mov    %rdi,%rax
  1c0221:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1c0226:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1c022a:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1c022d:	48 83 c2 01          	add    $0x1,%rdx
  1c0231:	84 c9                	test   %cl,%cl
  1c0233:	75 f1                	jne    1c0226 <strcpy+0xc>
}
  1c0235:	c3                   	ret    

00000000001c0236 <strcmp>:
int strcmp(const char* a, const char* b) {
  1c0236:	f3 0f 1e fa          	endbr64 
    while (*a && *b && *a == *b) {
  1c023a:	0f b6 07             	movzbl (%rdi),%eax
  1c023d:	84 c0                	test   %al,%al
  1c023f:	74 1a                	je     1c025b <strcmp+0x25>
  1c0241:	0f b6 16             	movzbl (%rsi),%edx
  1c0244:	38 c2                	cmp    %al,%dl
  1c0246:	75 13                	jne    1c025b <strcmp+0x25>
  1c0248:	84 d2                	test   %dl,%dl
  1c024a:	74 0f                	je     1c025b <strcmp+0x25>
        ++a, ++b;
  1c024c:	48 83 c7 01          	add    $0x1,%rdi
  1c0250:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1c0254:	0f b6 07             	movzbl (%rdi),%eax
  1c0257:	84 c0                	test   %al,%al
  1c0259:	75 e6                	jne    1c0241 <strcmp+0xb>
    return ((unsigned char) *a > (unsigned char) *b)
  1c025b:	3a 06                	cmp    (%rsi),%al
  1c025d:	0f 97 c0             	seta   %al
  1c0260:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1c0263:	83 d8 00             	sbb    $0x0,%eax
}
  1c0266:	c3                   	ret    

00000000001c0267 <strchr>:
char* strchr(const char* s, int c) {
  1c0267:	f3 0f 1e fa          	endbr64 
    while (*s && *s != (char) c) {
  1c026b:	0f b6 07             	movzbl (%rdi),%eax
  1c026e:	84 c0                	test   %al,%al
  1c0270:	74 10                	je     1c0282 <strchr+0x1b>
  1c0272:	40 38 f0             	cmp    %sil,%al
  1c0275:	74 18                	je     1c028f <strchr+0x28>
        ++s;
  1c0277:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1c027b:	0f b6 07             	movzbl (%rdi),%eax
  1c027e:	84 c0                	test   %al,%al
  1c0280:	75 f0                	jne    1c0272 <strchr+0xb>
        return NULL;
  1c0282:	40 84 f6             	test   %sil,%sil
  1c0285:	b8 00 00 00 00       	mov    $0x0,%eax
  1c028a:	48 0f 44 c7          	cmove  %rdi,%rax
}
  1c028e:	c3                   	ret    
  1c028f:	48 89 f8             	mov    %rdi,%rax
  1c0292:	c3                   	ret    

00000000001c0293 <rand>:
int rand(void) {
  1c0293:	f3 0f 1e fa          	endbr64 
    if (!rand_seed_set) {
  1c0297:	83 3d 76 0d 00 00 00 	cmpl   $0x0,0xd76(%rip)        # 1c1014 <rand_seed_set>
  1c029e:	74 1b                	je     1c02bb <rand+0x28>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1c02a0:	69 05 66 0d 00 00 0d 	imul   $0x19660d,0xd66(%rip),%eax        # 1c1010 <rand_seed>
  1c02a7:	66 19 00 
  1c02aa:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1c02af:	89 05 5b 0d 00 00    	mov    %eax,0xd5b(%rip)        # 1c1010 <rand_seed>
    return rand_seed & RAND_MAX;
  1c02b5:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1c02ba:	c3                   	ret    
    rand_seed = seed;
  1c02bb:	c7 05 4b 0d 00 00 9e 	movl   $0x30d4879e,0xd4b(%rip)        # 1c1010 <rand_seed>
  1c02c2:	87 d4 30 
    rand_seed_set = 1;
  1c02c5:	c7 05 45 0d 00 00 01 	movl   $0x1,0xd45(%rip)        # 1c1014 <rand_seed_set>
  1c02cc:	00 00 00 
}
  1c02cf:	eb cf                	jmp    1c02a0 <rand+0xd>

00000000001c02d1 <srand>:
void srand(unsigned seed) {
  1c02d1:	f3 0f 1e fa          	endbr64 
    rand_seed = seed;
  1c02d5:	89 3d 35 0d 00 00    	mov    %edi,0xd35(%rip)        # 1c1010 <rand_seed>
    rand_seed_set = 1;
  1c02db:	c7 05 2f 0d 00 00 01 	movl   $0x1,0xd2f(%rip)        # 1c1014 <rand_seed_set>
  1c02e2:	00 00 00 
}
  1c02e5:	c3                   	ret    

00000000001c02e6 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1c02e6:	f3 0f 1e fa          	endbr64 
  1c02ea:	55                   	push   %rbp
  1c02eb:	48 89 e5             	mov    %rsp,%rbp
  1c02ee:	41 57                	push   %r15
  1c02f0:	41 56                	push   %r14
  1c02f2:	41 55                	push   %r13
  1c02f4:	41 54                	push   %r12
  1c02f6:	53                   	push   %rbx
  1c02f7:	48 83 ec 58          	sub    $0x58,%rsp
  1c02fb:	49 89 fe             	mov    %rdi,%r14
  1c02fe:	89 75 ac             	mov    %esi,-0x54(%rbp)
  1c0301:	49 89 d4             	mov    %rdx,%r12
  1c0304:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1c0308:	0f b6 02             	movzbl (%rdx),%eax
  1c030b:	84 c0                	test   %al,%al
  1c030d:	0f 85 cd 04 00 00    	jne    1c07e0 <printer_vprintf+0x4fa>
}
  1c0313:	48 83 c4 58          	add    $0x58,%rsp
  1c0317:	5b                   	pop    %rbx
  1c0318:	41 5c                	pop    %r12
  1c031a:	41 5d                	pop    %r13
  1c031c:	41 5e                	pop    %r14
  1c031e:	41 5f                	pop    %r15
  1c0320:	5d                   	pop    %rbp
  1c0321:	c3                   	ret    
        for (++format; *format; ++format) {
  1c0322:	4d 8d 7c 24 01       	lea    0x1(%r12),%r15
  1c0327:	41 0f b6 5c 24 01    	movzbl 0x1(%r12),%ebx
  1c032d:	84 db                	test   %bl,%bl
  1c032f:	0f 84 a4 06 00 00    	je     1c09d9 <printer_vprintf+0x6f3>
        int flags = 0;
  1c0335:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1c033b:	4c 8d 25 0f 09 00 00 	lea    0x90f(%rip),%r12        # 1c0c51 <flag_chars>
  1c0342:	0f be f3             	movsbl %bl,%esi
  1c0345:	4c 89 e7             	mov    %r12,%rdi
  1c0348:	e8 1a ff ff ff       	call   1c0267 <strchr>
  1c034d:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1c0350:	48 85 c0             	test   %rax,%rax
  1c0353:	74 5c                	je     1c03b1 <printer_vprintf+0xcb>
                flags |= 1 << (flagc - flag_chars);
  1c0355:	4c 29 e1             	sub    %r12,%rcx
  1c0358:	b8 01 00 00 00       	mov    $0x1,%eax
  1c035d:	d3 e0                	shl    %cl,%eax
  1c035f:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1c0362:	49 83 c7 01          	add    $0x1,%r15
  1c0366:	41 0f b6 1f          	movzbl (%r15),%ebx
  1c036a:	84 db                	test   %bl,%bl
  1c036c:	75 d4                	jne    1c0342 <printer_vprintf+0x5c>
  1c036e:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
        int width = -1;
  1c0372:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1c0378:	c7 45 a8 ff ff ff ff 	movl   $0xffffffff,-0x58(%rbp)
        if (*format == '.') {
  1c037f:	41 80 3f 2e          	cmpb   $0x2e,(%r15)
  1c0383:	0f 84 b3 00 00 00    	je     1c043c <printer_vprintf+0x156>
        int length = 0;
  1c0389:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  1c038e:	41 0f b6 17          	movzbl (%r15),%edx
  1c0392:	8d 42 bd             	lea    -0x43(%rdx),%eax
  1c0395:	3c 37                	cmp    $0x37,%al
  1c0397:	0f 87 e0 04 00 00    	ja     1c087d <printer_vprintf+0x597>
  1c039d:	0f b6 c0             	movzbl %al,%eax
  1c03a0:	48 8d 3d 99 07 00 00 	lea    0x799(%rip),%rdi        # 1c0b40 <console_clear+0x47>
  1c03a7:	48 63 04 87          	movslq (%rdi,%rax,4),%rax
  1c03ab:	48 01 f8             	add    %rdi,%rax
  1c03ae:	3e ff e0             	notrack jmp *%rax
        if (*format >= '1' && *format <= '9') {
  1c03b1:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  1c03b5:	8d 43 cf             	lea    -0x31(%rbx),%eax
  1c03b8:	3c 08                	cmp    $0x8,%al
  1c03ba:	77 31                	ja     1c03ed <printer_vprintf+0x107>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c03bc:	41 0f b6 07          	movzbl (%r15),%eax
  1c03c0:	8d 50 d0             	lea    -0x30(%rax),%edx
  1c03c3:	80 fa 09             	cmp    $0x9,%dl
  1c03c6:	77 5e                	ja     1c0426 <printer_vprintf+0x140>
  1c03c8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  1c03ce:	49 83 c7 01          	add    $0x1,%r15
  1c03d2:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  1c03d7:	0f be c0             	movsbl %al,%eax
  1c03da:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c03df:	41 0f b6 07          	movzbl (%r15),%eax
  1c03e3:	8d 50 d0             	lea    -0x30(%rax),%edx
  1c03e6:	80 fa 09             	cmp    $0x9,%dl
  1c03e9:	76 e3                	jbe    1c03ce <printer_vprintf+0xe8>
  1c03eb:	eb 8b                	jmp    1c0378 <printer_vprintf+0x92>
        } else if (*format == '*') {
  1c03ed:	80 fb 2a             	cmp    $0x2a,%bl
  1c03f0:	75 3f                	jne    1c0431 <printer_vprintf+0x14b>
            width = va_arg(val, int);
  1c03f2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c03f6:	8b 07                	mov    (%rdi),%eax
  1c03f8:	83 f8 2f             	cmp    $0x2f,%eax
  1c03fb:	77 17                	ja     1c0414 <printer_vprintf+0x12e>
  1c03fd:	89 c2                	mov    %eax,%edx
  1c03ff:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c0403:	83 c0 08             	add    $0x8,%eax
  1c0406:	89 07                	mov    %eax,(%rdi)
  1c0408:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1c040b:	49 83 c7 01          	add    $0x1,%r15
  1c040f:	e9 64 ff ff ff       	jmp    1c0378 <printer_vprintf+0x92>
            width = va_arg(val, int);
  1c0414:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0418:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c041c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0420:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0424:	eb e2                	jmp    1c0408 <printer_vprintf+0x122>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c0426:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1c042c:	e9 47 ff ff ff       	jmp    1c0378 <printer_vprintf+0x92>
        int width = -1;
  1c0431:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1c0437:	e9 3c ff ff ff       	jmp    1c0378 <printer_vprintf+0x92>
            ++format;
  1c043c:	49 8d 57 01          	lea    0x1(%r15),%rdx
            if (*format >= '0' && *format <= '9') {
  1c0440:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  1c0445:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1c0448:	80 f9 09             	cmp    $0x9,%cl
  1c044b:	76 13                	jbe    1c0460 <printer_vprintf+0x17a>
            } else if (*format == '*') {
  1c044d:	3c 2a                	cmp    $0x2a,%al
  1c044f:	74 33                	je     1c0484 <printer_vprintf+0x19e>
            ++format;
  1c0451:	49 89 d7             	mov    %rdx,%r15
                precision = 0;
  1c0454:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  1c045b:	e9 29 ff ff ff       	jmp    1c0389 <printer_vprintf+0xa3>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c0460:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  1c0465:	48 83 c2 01          	add    $0x1,%rdx
  1c0469:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  1c046c:	0f be c0             	movsbl %al,%eax
  1c046f:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c0473:	0f b6 02             	movzbl (%rdx),%eax
  1c0476:	8d 70 d0             	lea    -0x30(%rax),%esi
  1c0479:	40 80 fe 09          	cmp    $0x9,%sil
  1c047d:	76 e6                	jbe    1c0465 <printer_vprintf+0x17f>
                    precision = 10 * precision + *format++ - '0';
  1c047f:	49 89 d7             	mov    %rdx,%r15
  1c0482:	eb 1c                	jmp    1c04a0 <printer_vprintf+0x1ba>
                precision = va_arg(val, int);
  1c0484:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0488:	8b 01                	mov    (%rcx),%eax
  1c048a:	83 f8 2f             	cmp    $0x2f,%eax
  1c048d:	77 23                	ja     1c04b2 <printer_vprintf+0x1cc>
  1c048f:	89 c2                	mov    %eax,%edx
  1c0491:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c0495:	83 c0 08             	add    $0x8,%eax
  1c0498:	89 01                	mov    %eax,(%rcx)
  1c049a:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  1c049c:	49 83 c7 02          	add    $0x2,%r15
            if (precision < 0) {
  1c04a0:	85 c9                	test   %ecx,%ecx
  1c04a2:	b8 00 00 00 00       	mov    $0x0,%eax
  1c04a7:	0f 49 c1             	cmovns %ecx,%eax
  1c04aa:	89 45 a8             	mov    %eax,-0x58(%rbp)
  1c04ad:	e9 d7 fe ff ff       	jmp    1c0389 <printer_vprintf+0xa3>
                precision = va_arg(val, int);
  1c04b2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c04b6:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c04ba:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c04be:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c04c2:	eb d6                	jmp    1c049a <printer_vprintf+0x1b4>
        switch (*format) {
  1c04c4:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1c04c9:	e9 f6 00 00 00       	jmp    1c05c4 <printer_vprintf+0x2de>
            ++format;
  1c04ce:	49 83 c7 01          	add    $0x1,%r15
            length = 1;
  1c04d2:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  1c04d7:	e9 b2 fe ff ff       	jmp    1c038e <printer_vprintf+0xa8>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c04dc:	85 c9                	test   %ecx,%ecx
  1c04de:	74 56                	je     1c0536 <printer_vprintf+0x250>
  1c04e0:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c04e4:	8b 07                	mov    (%rdi),%eax
  1c04e6:	83 f8 2f             	cmp    $0x2f,%eax
  1c04e9:	77 39                	ja     1c0524 <printer_vprintf+0x23e>
  1c04eb:	89 c2                	mov    %eax,%edx
  1c04ed:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c04f1:	83 c0 08             	add    $0x8,%eax
  1c04f4:	89 07                	mov    %eax,(%rdi)
  1c04f6:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1c04f9:	48 89 d0             	mov    %rdx,%rax
  1c04fc:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1c0500:	49 89 d0             	mov    %rdx,%r8
  1c0503:	49 f7 d8             	neg    %r8
  1c0506:	25 80 00 00 00       	and    $0x80,%eax
  1c050b:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1c050f:	0b 45 a0             	or     -0x60(%rbp),%eax
  1c0512:	83 c8 60             	or     $0x60,%eax
  1c0515:	89 45 a0             	mov    %eax,-0x60(%rbp)
        char* data = "";
  1c0518:	4c 8d 25 19 06 00 00 	lea    0x619(%rip),%r12        # 1c0b38 <console_clear+0x3f>
            break;
  1c051f:	e9 39 01 00 00       	jmp    1c065d <printer_vprintf+0x377>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c0524:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0528:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c052c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0530:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0534:	eb c0                	jmp    1c04f6 <printer_vprintf+0x210>
  1c0536:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c053a:	8b 01                	mov    (%rcx),%eax
  1c053c:	83 f8 2f             	cmp    $0x2f,%eax
  1c053f:	77 10                	ja     1c0551 <printer_vprintf+0x26b>
  1c0541:	89 c2                	mov    %eax,%edx
  1c0543:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c0547:	83 c0 08             	add    $0x8,%eax
  1c054a:	89 01                	mov    %eax,(%rcx)
  1c054c:	48 63 12             	movslq (%rdx),%rdx
  1c054f:	eb a8                	jmp    1c04f9 <printer_vprintf+0x213>
  1c0551:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0555:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0559:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c055d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0561:	eb e9                	jmp    1c054c <printer_vprintf+0x266>
        int base = 10;
  1c0563:	be 0a 00 00 00       	mov    $0xa,%esi
  1c0568:	eb 5a                	jmp    1c05c4 <printer_vprintf+0x2de>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c056a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c056e:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c0572:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0576:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c057a:	eb 62                	jmp    1c05de <printer_vprintf+0x2f8>
  1c057c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0580:	8b 07                	mov    (%rdi),%eax
  1c0582:	83 f8 2f             	cmp    $0x2f,%eax
  1c0585:	77 10                	ja     1c0597 <printer_vprintf+0x2b1>
  1c0587:	89 c2                	mov    %eax,%edx
  1c0589:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c058d:	83 c0 08             	add    $0x8,%eax
  1c0590:	89 07                	mov    %eax,(%rdi)
  1c0592:	44 8b 02             	mov    (%rdx),%r8d
  1c0595:	eb 4a                	jmp    1c05e1 <printer_vprintf+0x2fb>
  1c0597:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c059b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c059f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c05a3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c05a7:	eb e9                	jmp    1c0592 <printer_vprintf+0x2ac>
  1c05a9:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1c05ac:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
    const char* digits = upper_digits;
  1c05b3:	48 8d 3d 86 06 00 00 	lea    0x686(%rip),%rdi        # 1c0c40 <upper_digits.1>
  1c05ba:	e9 f3 02 00 00       	jmp    1c08b2 <printer_vprintf+0x5cc>
            base = 16;
  1c05bf:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c05c4:	85 c9                	test   %ecx,%ecx
  1c05c6:	74 b4                	je     1c057c <printer_vprintf+0x296>
  1c05c8:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c05cc:	8b 01                	mov    (%rcx),%eax
  1c05ce:	83 f8 2f             	cmp    $0x2f,%eax
  1c05d1:	77 97                	ja     1c056a <printer_vprintf+0x284>
  1c05d3:	89 c2                	mov    %eax,%edx
  1c05d5:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c05d9:	83 c0 08             	add    $0x8,%eax
  1c05dc:	89 01                	mov    %eax,(%rcx)
  1c05de:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  1c05e1:	83 4d a0 20          	orl    $0x20,-0x60(%rbp)
    if (base < 0) {
  1c05e5:	85 f6                	test   %esi,%esi
  1c05e7:	79 c0                	jns    1c05a9 <printer_vprintf+0x2c3>
        base = -base;
  1c05e9:	41 89 f1             	mov    %esi,%r9d
  1c05ec:	f7 de                	neg    %esi
  1c05ee:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
        digits = lower_digits;
  1c05f5:	48 8d 3d 24 06 00 00 	lea    0x624(%rip),%rdi        # 1c0c20 <lower_digits.0>
  1c05fc:	e9 b1 02 00 00       	jmp    1c08b2 <printer_vprintf+0x5cc>
            num = (uintptr_t) va_arg(val, void*);
  1c0601:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0605:	8b 01                	mov    (%rcx),%eax
  1c0607:	83 f8 2f             	cmp    $0x2f,%eax
  1c060a:	77 1c                	ja     1c0628 <printer_vprintf+0x342>
  1c060c:	89 c2                	mov    %eax,%edx
  1c060e:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c0612:	83 c0 08             	add    $0x8,%eax
  1c0615:	89 01                	mov    %eax,(%rcx)
  1c0617:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1c061a:	81 4d a0 21 01 00 00 	orl    $0x121,-0x60(%rbp)
            base = -16;
  1c0621:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1c0626:	eb c1                	jmp    1c05e9 <printer_vprintf+0x303>
            num = (uintptr_t) va_arg(val, void*);
  1c0628:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c062c:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c0630:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0634:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c0638:	eb dd                	jmp    1c0617 <printer_vprintf+0x331>
            data = va_arg(val, char*);
  1c063a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c063e:	8b 07                	mov    (%rdi),%eax
  1c0640:	83 f8 2f             	cmp    $0x2f,%eax
  1c0643:	0f 87 b0 01 00 00    	ja     1c07f9 <printer_vprintf+0x513>
  1c0649:	89 c2                	mov    %eax,%edx
  1c064b:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c064f:	83 c0 08             	add    $0x8,%eax
  1c0652:	89 07                	mov    %eax,(%rdi)
  1c0654:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1c0657:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  1c065d:	8b 45 a0             	mov    -0x60(%rbp),%eax
  1c0660:	83 e0 20             	and    $0x20,%eax
  1c0663:	89 45 98             	mov    %eax,-0x68(%rbp)
  1c0666:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  1c066c:	0f 85 2e 02 00 00    	jne    1c08a0 <printer_vprintf+0x5ba>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1c0672:	8b 45 a0             	mov    -0x60(%rbp),%eax
  1c0675:	89 45 8c             	mov    %eax,-0x74(%rbp)
  1c0678:	83 e0 60             	and    $0x60,%eax
  1c067b:	83 f8 60             	cmp    $0x60,%eax
  1c067e:	0f 84 63 02 00 00    	je     1c08e7 <printer_vprintf+0x601>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c0684:	8b 45 a0             	mov    -0x60(%rbp),%eax
  1c0687:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  1c068a:	48 8d 1d a7 04 00 00 	lea    0x4a7(%rip),%rbx        # 1c0b38 <console_clear+0x3f>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c0691:	83 f8 21             	cmp    $0x21,%eax
  1c0694:	0f 84 8a 02 00 00    	je     1c0924 <printer_vprintf+0x63e>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1c069a:	8b 7d a8             	mov    -0x58(%rbp),%edi
  1c069d:	89 f8                	mov    %edi,%eax
  1c069f:	f7 d0                	not    %eax
  1c06a1:	c1 e8 1f             	shr    $0x1f,%eax
  1c06a4:	89 45 88             	mov    %eax,-0x78(%rbp)
  1c06a7:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  1c06ab:	0f 85 b2 02 00 00    	jne    1c0963 <printer_vprintf+0x67d>
  1c06b1:	84 c0                	test   %al,%al
  1c06b3:	0f 84 aa 02 00 00    	je     1c0963 <printer_vprintf+0x67d>
            len = strnlen(data, precision);
  1c06b9:	48 63 f7             	movslq %edi,%rsi
  1c06bc:	4c 89 e7             	mov    %r12,%rdi
  1c06bf:	e8 2f fb ff ff       	call   1c01f3 <strnlen>
  1c06c4:	89 45 9c             	mov    %eax,-0x64(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1c06c7:	8b 45 8c             	mov    -0x74(%rbp),%eax
  1c06ca:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  1c06cd:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1c06d4:	83 f8 22             	cmp    $0x22,%eax
  1c06d7:	0f 84 be 02 00 00    	je     1c099b <printer_vprintf+0x6b5>
        width -= len + zeros + strlen(prefix);
  1c06dd:	48 89 df             	mov    %rbx,%rdi
  1c06e0:	e8 ef fa ff ff       	call   1c01d4 <strlen>
  1c06e5:	8b 55 a8             	mov    -0x58(%rbp),%edx
  1c06e8:	03 55 9c             	add    -0x64(%rbp),%edx
  1c06eb:	44 89 e9             	mov    %r13d,%ecx
  1c06ee:	29 d1                	sub    %edx,%ecx
  1c06f0:	29 c1                	sub    %eax,%ecx
  1c06f2:	89 4d 98             	mov    %ecx,-0x68(%rbp)
  1c06f5:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c06f8:	f6 45 a0 04          	testb  $0x4,-0x60(%rbp)
  1c06fc:	75 37                	jne    1c0735 <printer_vprintf+0x44f>
  1c06fe:	85 c9                	test   %ecx,%ecx
  1c0700:	7e 33                	jle    1c0735 <printer_vprintf+0x44f>
        width -= len + zeros + strlen(prefix);
  1c0702:	48 89 5d a0          	mov    %rbx,-0x60(%rbp)
  1c0706:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  1c0709:	89 da                	mov    %ebx,%edx
  1c070b:	be 20 00 00 00       	mov    $0x20,%esi
  1c0710:	4c 89 f7             	mov    %r14,%rdi
  1c0713:	41 ff 16             	call   *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c0716:	41 83 ed 01          	sub    $0x1,%r13d
  1c071a:	45 85 ed             	test   %r13d,%r13d
  1c071d:	7f ea                	jg     1c0709 <printer_vprintf+0x423>
  1c071f:	48 8b 5d a0          	mov    -0x60(%rbp),%rbx
  1c0723:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1c0726:	85 ff                	test   %edi,%edi
  1c0728:	b8 01 00 00 00       	mov    $0x1,%eax
  1c072d:	0f 4f c7             	cmovg  %edi,%eax
  1c0730:	29 c7                	sub    %eax,%edi
  1c0732:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1c0735:	0f b6 03             	movzbl (%rbx),%eax
  1c0738:	84 c0                	test   %al,%al
  1c073a:	74 23                	je     1c075f <printer_vprintf+0x479>
  1c073c:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  1c0740:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, *prefix, color);
  1c0744:	0f b6 f0             	movzbl %al,%esi
  1c0747:	44 89 e2             	mov    %r12d,%edx
  1c074a:	4c 89 f7             	mov    %r14,%rdi
  1c074d:	41 ff 16             	call   *(%r14)
        for (; *prefix; ++prefix) {
  1c0750:	48 83 c3 01          	add    $0x1,%rbx
  1c0754:	0f b6 03             	movzbl (%rbx),%eax
  1c0757:	84 c0                	test   %al,%al
  1c0759:	75 e9                	jne    1c0744 <printer_vprintf+0x45e>
  1c075b:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; zeros > 0; --zeros) {
  1c075f:	8b 5d a8             	mov    -0x58(%rbp),%ebx
  1c0762:	85 db                	test   %ebx,%ebx
  1c0764:	7e 1f                	jle    1c0785 <printer_vprintf+0x49f>
  1c0766:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  1c076a:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, '0', color);
  1c076e:	44 89 e2             	mov    %r12d,%edx
  1c0771:	be 30 00 00 00       	mov    $0x30,%esi
  1c0776:	4c 89 f7             	mov    %r14,%rdi
  1c0779:	41 ff 16             	call   *(%r14)
        for (; zeros > 0; --zeros) {
  1c077c:	83 eb 01             	sub    $0x1,%ebx
  1c077f:	75 ed                	jne    1c076e <printer_vprintf+0x488>
  1c0781:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; len > 0; ++data, --len) {
  1c0785:	8b 45 9c             	mov    -0x64(%rbp),%eax
  1c0788:	85 c0                	test   %eax,%eax
  1c078a:	7e 28                	jle    1c07b4 <printer_vprintf+0x4ce>
  1c078c:	89 c3                	mov    %eax,%ebx
  1c078e:	4c 01 e3             	add    %r12,%rbx
  1c0791:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  1c0795:	44 8b 6d ac          	mov    -0x54(%rbp),%r13d
            p->putc(p, *data, color);
  1c0799:	41 0f b6 34 24       	movzbl (%r12),%esi
  1c079e:	44 89 ea             	mov    %r13d,%edx
  1c07a1:	4c 89 f7             	mov    %r14,%rdi
  1c07a4:	41 ff 16             	call   *(%r14)
        for (; len > 0; ++data, --len) {
  1c07a7:	49 83 c4 01          	add    $0x1,%r12
  1c07ab:	49 39 dc             	cmp    %rbx,%r12
  1c07ae:	75 e9                	jne    1c0799 <printer_vprintf+0x4b3>
  1c07b0:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
        for (; width > 0; --width) {
  1c07b4:	45 85 ed             	test   %r13d,%r13d
  1c07b7:	7e 16                	jle    1c07cf <printer_vprintf+0x4e9>
  1c07b9:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  1c07bc:	89 da                	mov    %ebx,%edx
  1c07be:	be 20 00 00 00       	mov    $0x20,%esi
  1c07c3:	4c 89 f7             	mov    %r14,%rdi
  1c07c6:	41 ff 16             	call   *(%r14)
        for (; width > 0; --width) {
  1c07c9:	41 83 ed 01          	sub    $0x1,%r13d
  1c07cd:	75 ed                	jne    1c07bc <printer_vprintf+0x4d6>
    for (; *format; ++format) {
  1c07cf:	4d 8d 67 01          	lea    0x1(%r15),%r12
  1c07d3:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  1c07d8:	84 c0                	test   %al,%al
  1c07da:	0f 84 33 fb ff ff    	je     1c0313 <printer_vprintf+0x2d>
        if (*format != '%') {
  1c07e0:	3c 25                	cmp    $0x25,%al
  1c07e2:	0f 84 3a fb ff ff    	je     1c0322 <printer_vprintf+0x3c>
            p->putc(p, *format, color);
  1c07e8:	0f b6 f0             	movzbl %al,%esi
  1c07eb:	8b 55 ac             	mov    -0x54(%rbp),%edx
  1c07ee:	4c 89 f7             	mov    %r14,%rdi
  1c07f1:	41 ff 16             	call   *(%r14)
            continue;
  1c07f4:	4d 89 e7             	mov    %r12,%r15
  1c07f7:	eb d6                	jmp    1c07cf <printer_vprintf+0x4e9>
            data = va_arg(val, char*);
  1c07f9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c07fd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0801:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0805:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0809:	e9 46 fe ff ff       	jmp    1c0654 <printer_vprintf+0x36e>
            color = va_arg(val, int);
  1c080e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0812:	8b 01                	mov    (%rcx),%eax
  1c0814:	83 f8 2f             	cmp    $0x2f,%eax
  1c0817:	77 12                	ja     1c082b <printer_vprintf+0x545>
  1c0819:	89 c2                	mov    %eax,%edx
  1c081b:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c081f:	83 c0 08             	add    $0x8,%eax
  1c0822:	89 01                	mov    %eax,(%rcx)
  1c0824:	8b 02                	mov    (%rdx),%eax
  1c0826:	89 45 ac             	mov    %eax,-0x54(%rbp)
            goto done;
  1c0829:	eb a4                	jmp    1c07cf <printer_vprintf+0x4e9>
            color = va_arg(val, int);
  1c082b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c082f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c0833:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0837:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c083b:	eb e7                	jmp    1c0824 <printer_vprintf+0x53e>
            numbuf[0] = va_arg(val, int);
  1c083d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0841:	8b 07                	mov    (%rdi),%eax
  1c0843:	83 f8 2f             	cmp    $0x2f,%eax
  1c0846:	77 23                	ja     1c086b <printer_vprintf+0x585>
  1c0848:	89 c2                	mov    %eax,%edx
  1c084a:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c084e:	83 c0 08             	add    $0x8,%eax
  1c0851:	89 07                	mov    %eax,(%rdi)
  1c0853:	8b 02                	mov    (%rdx),%eax
  1c0855:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1c0858:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1c085c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c0860:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1c0866:	e9 f2 fd ff ff       	jmp    1c065d <printer_vprintf+0x377>
            numbuf[0] = va_arg(val, int);
  1c086b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c086f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0873:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0877:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c087b:	eb d6                	jmp    1c0853 <printer_vprintf+0x56d>
            numbuf[0] = (*format ? *format : '%');
  1c087d:	84 d2                	test   %dl,%dl
  1c087f:	0f 85 3e 01 00 00    	jne    1c09c3 <printer_vprintf+0x6dd>
  1c0885:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  1c0889:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  1c088d:	49 83 ef 01          	sub    $0x1,%r15
            data = numbuf;
  1c0891:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c0895:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1c089b:	e9 bd fd ff ff       	jmp    1c065d <printer_vprintf+0x377>
        if (flags & FLAG_NUMERIC) {
  1c08a0:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1c08a6:	48 8d 3d 93 03 00 00 	lea    0x393(%rip),%rdi        # 1c0c40 <upper_digits.1>
        if (flags & FLAG_NUMERIC) {
  1c08ad:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1c08b2:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1c08b6:	4c 89 c1             	mov    %r8,%rcx
  1c08b9:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1c08bd:	48 63 f6             	movslq %esi,%rsi
  1c08c0:	49 83 ec 01          	sub    $0x1,%r12
  1c08c4:	48 89 c8             	mov    %rcx,%rax
  1c08c7:	ba 00 00 00 00       	mov    $0x0,%edx
  1c08cc:	48 f7 f6             	div    %rsi
  1c08cf:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1c08d3:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1c08d7:	48 89 ca             	mov    %rcx,%rdx
  1c08da:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  1c08dd:	48 39 d6             	cmp    %rdx,%rsi
  1c08e0:	76 de                	jbe    1c08c0 <printer_vprintf+0x5da>
  1c08e2:	e9 8b fd ff ff       	jmp    1c0672 <printer_vprintf+0x38c>
                prefix = "-";
  1c08e7:	48 8d 1d 47 02 00 00 	lea    0x247(%rip),%rbx        # 1c0b35 <console_clear+0x3c>
            if (flags & FLAG_NEGATIVE) {
  1c08ee:	8b 45 a0             	mov    -0x60(%rbp),%eax
  1c08f1:	a8 80                	test   $0x80,%al
  1c08f3:	0f 85 a1 fd ff ff    	jne    1c069a <printer_vprintf+0x3b4>
                prefix = "+";
  1c08f9:	48 8d 1d 30 02 00 00 	lea    0x230(%rip),%rbx        # 1c0b30 <console_clear+0x37>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1c0900:	a8 10                	test   $0x10,%al
  1c0902:	0f 85 92 fd ff ff    	jne    1c069a <printer_vprintf+0x3b4>
                prefix = " ";
  1c0908:	a8 08                	test   $0x8,%al
  1c090a:	48 8d 15 27 02 00 00 	lea    0x227(%rip),%rdx        # 1c0b38 <console_clear+0x3f>
  1c0911:	48 8d 05 1f 02 00 00 	lea    0x21f(%rip),%rax        # 1c0b37 <console_clear+0x3e>
  1c0918:	48 0f 44 c2          	cmove  %rdx,%rax
  1c091c:	48 89 c3             	mov    %rax,%rbx
  1c091f:	e9 76 fd ff ff       	jmp    1c069a <printer_vprintf+0x3b4>
                   && (base == 16 || base == -16)
  1c0924:	41 8d 41 10          	lea    0x10(%r9),%eax
  1c0928:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1c092d:	0f 85 67 fd ff ff    	jne    1c069a <printer_vprintf+0x3b4>
                   && (num || (flags & FLAG_ALT2))) {
  1c0933:	4d 85 c0             	test   %r8,%r8
  1c0936:	75 0d                	jne    1c0945 <printer_vprintf+0x65f>
  1c0938:	f7 45 a0 00 01 00 00 	testl  $0x100,-0x60(%rbp)
  1c093f:	0f 84 55 fd ff ff    	je     1c069a <printer_vprintf+0x3b4>
            prefix = (base == -16 ? "0x" : "0X");
  1c0945:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1c0949:	48 8d 15 e9 01 00 00 	lea    0x1e9(%rip),%rdx        # 1c0b39 <console_clear+0x40>
  1c0950:	48 8d 05 db 01 00 00 	lea    0x1db(%rip),%rax        # 1c0b32 <console_clear+0x39>
  1c0957:	48 0f 44 c2          	cmove  %rdx,%rax
  1c095b:	48 89 c3             	mov    %rax,%rbx
  1c095e:	e9 37 fd ff ff       	jmp    1c069a <printer_vprintf+0x3b4>
            len = strlen(data);
  1c0963:	4c 89 e7             	mov    %r12,%rdi
  1c0966:	e8 69 f8 ff ff       	call   1c01d4 <strlen>
  1c096b:	89 45 9c             	mov    %eax,-0x64(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1c096e:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  1c0972:	0f 84 4f fd ff ff    	je     1c06c7 <printer_vprintf+0x3e1>
  1c0978:	80 7d 88 00          	cmpb   $0x0,-0x78(%rbp)
  1c097c:	0f 84 45 fd ff ff    	je     1c06c7 <printer_vprintf+0x3e1>
            zeros = precision > len ? precision - len : 0;
  1c0982:	8b 4d a8             	mov    -0x58(%rbp),%ecx
  1c0985:	89 ca                	mov    %ecx,%edx
  1c0987:	29 c2                	sub    %eax,%edx
  1c0989:	39 c1                	cmp    %eax,%ecx
  1c098b:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0990:	0f 4f c2             	cmovg  %edx,%eax
  1c0993:	89 45 a8             	mov    %eax,-0x58(%rbp)
  1c0996:	e9 42 fd ff ff       	jmp    1c06dd <printer_vprintf+0x3f7>
                   && len + (int) strlen(prefix) < width) {
  1c099b:	48 89 df             	mov    %rbx,%rdi
  1c099e:	e8 31 f8 ff ff       	call   1c01d4 <strlen>
  1c09a3:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1c09a6:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1c09a9:	44 89 e9             	mov    %r13d,%ecx
  1c09ac:	29 f9                	sub    %edi,%ecx
  1c09ae:	29 c1                	sub    %eax,%ecx
  1c09b0:	44 39 ea             	cmp    %r13d,%edx
  1c09b3:	b8 00 00 00 00       	mov    $0x0,%eax
  1c09b8:	0f 4c c1             	cmovl  %ecx,%eax
  1c09bb:	89 45 a8             	mov    %eax,-0x58(%rbp)
  1c09be:	e9 1a fd ff ff       	jmp    1c06dd <printer_vprintf+0x3f7>
            numbuf[0] = (*format ? *format : '%');
  1c09c3:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1c09c6:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1c09ca:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c09ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1c09d4:	e9 84 fc ff ff       	jmp    1c065d <printer_vprintf+0x377>
        int flags = 0;
  1c09d9:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%rbp)
  1c09e0:	e9 8d f9 ff ff       	jmp    1c0372 <printer_vprintf+0x8c>

00000000001c09e5 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1c09e5:	f3 0f 1e fa          	endbr64 
  1c09e9:	55                   	push   %rbp
  1c09ea:	48 89 e5             	mov    %rsp,%rbp
  1c09ed:	53                   	push   %rbx
  1c09ee:	48 83 ec 18          	sub    $0x18,%rsp
    cp.p.putc = console_putc;
  1c09f2:	48 8d 05 9e f6 ff ff 	lea    -0x962(%rip),%rax        # 1c0097 <console_putc>
  1c09f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        cpos = 0;
  1c09fd:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1c0a03:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0a08:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1c0a0b:	48 63 ff             	movslq %edi,%rdi
  1c0a0e:	48 8d 1d eb 75 ef ff 	lea    -0x108a15(%rip),%rbx        # b8000 <console>
  1c0a15:	48 8d 04 7b          	lea    (%rbx,%rdi,2),%rax
  1c0a19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1c0a1d:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  1c0a21:	e8 c0 f8 ff ff       	call   1c02e6 <printer_vprintf>
    return cp.cursor - console;
  1c0a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0a2a:	48 29 d8             	sub    %rbx,%rax
  1c0a2d:	48 d1 f8             	sar    %rax
}
  1c0a30:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1c0a34:	c9                   	leave  
  1c0a35:	c3                   	ret    

00000000001c0a36 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1c0a36:	f3 0f 1e fa          	endbr64 
  1c0a3a:	55                   	push   %rbp
  1c0a3b:	48 89 e5             	mov    %rsp,%rbp
  1c0a3e:	48 83 ec 50          	sub    $0x50,%rsp
  1c0a42:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c0a46:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c0a4a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1c0a4e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c0a55:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c0a59:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c0a5d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c0a61:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1c0a65:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c0a69:	e8 77 ff ff ff       	call   1c09e5 <console_vprintf>
}
  1c0a6e:	c9                   	leave  
  1c0a6f:	c3                   	ret    

00000000001c0a70 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1c0a70:	f3 0f 1e fa          	endbr64 
  1c0a74:	55                   	push   %rbp
  1c0a75:	48 89 e5             	mov    %rsp,%rbp
  1c0a78:	53                   	push   %rbx
  1c0a79:	48 83 ec 28          	sub    $0x28,%rsp
  1c0a7d:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  1c0a80:	48 8d 05 a3 f6 ff ff 	lea    -0x95d(%rip),%rax        # 1c012a <string_putc>
  1c0a87:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    sp.s = s;
  1c0a8b:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  1c0a8f:	48 85 f6             	test   %rsi,%rsi
  1c0a92:	75 0b                	jne    1c0a9f <vsnprintf+0x2f>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  1c0a94:	8b 45 e0             	mov    -0x20(%rbp),%eax
  1c0a97:	29 d8                	sub    %ebx,%eax
}
  1c0a99:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1c0a9d:	c9                   	leave  
  1c0a9e:	c3                   	ret    
        sp.end = s + size - 1;
  1c0a9f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  1c0aa4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  1c0aa8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  1c0aac:	be 00 00 00 00       	mov    $0x0,%esi
  1c0ab1:	e8 30 f8 ff ff       	call   1c02e6 <printer_vprintf>
        *sp.s = 0;
  1c0ab6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c0aba:	c6 00 00             	movb   $0x0,(%rax)
  1c0abd:	eb d5                	jmp    1c0a94 <vsnprintf+0x24>

00000000001c0abf <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  1c0abf:	f3 0f 1e fa          	endbr64 
  1c0ac3:	55                   	push   %rbp
  1c0ac4:	48 89 e5             	mov    %rsp,%rbp
  1c0ac7:	48 83 ec 50          	sub    $0x50,%rsp
  1c0acb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c0acf:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c0ad3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1c0ad7:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c0ade:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c0ae2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c0ae6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c0aea:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  1c0aee:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c0af2:	e8 79 ff ff ff       	call   1c0a70 <vsnprintf>
    va_end(val);
    return n;
}
  1c0af7:	c9                   	leave  
  1c0af8:	c3                   	ret    

00000000001c0af9 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  1c0af9:	f3 0f 1e fa          	endbr64 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c0afd:	48 8d 05 fc 74 ef ff 	lea    -0x108b04(%rip),%rax        # b8000 <console>
  1c0b04:	48 8d 90 a0 0f 00 00 	lea    0xfa0(%rax),%rdx
        console[i] = ' ' | 0x0700;
  1c0b0b:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c0b10:	48 83 c0 02          	add    $0x2,%rax
  1c0b14:	48 39 d0             	cmp    %rdx,%rax
  1c0b17:	75 f2                	jne    1c0b0b <console_clear+0x12>
    }
    cursorpos = 0;
  1c0b19:	c7 05 d9 84 ef ff 00 	movl   $0x0,-0x107b27(%rip)        # b8ffc <cursorpos>
  1c0b20:	00 00 00 
}
  1c0b23:	c3                   	ret    
