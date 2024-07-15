
obj/p-allocator3.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000180000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  180000:	f3 0f 1e fa          	endbr64 
  180004:	55                   	push   %rbp
  180005:	48 89 e5             	mov    %rsp,%rbp
  180008:	53                   	push   %rbx
  180009:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  18000d:	cd 31                	int    $0x31
  18000f:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  180011:	89 c7                	mov    %eax,%edi
  180013:	e8 b9 02 00 00       	call   1802d1 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  180018:	48 8d 05 f8 1f 00 00 	lea    0x1ff8(%rip),%rax        # 182017 <end+0xfff>
  18001f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  180025:	48 89 05 dc 0f 00 00 	mov    %rax,0xfdc(%rip)        # 181008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  18002c:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  18002f:	48 83 e8 01          	sub    $0x1,%rax
  180033:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  180039:	48 89 05 c0 0f 00 00 	mov    %rax,0xfc0(%rip)        # 181000 <stack_bottom>
  180040:	eb 02                	jmp    180044 <process_main+0x44>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  180042:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
#if !NO_SLOWDOWN
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  180044:	e8 4a 02 00 00       	call   180293 <rand>
  180049:	48 63 d0             	movslq %eax,%rdx
  18004c:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  180053:	48 c1 fa 25          	sar    $0x25,%rdx
  180057:	89 c1                	mov    %eax,%ecx
  180059:	c1 f9 1f             	sar    $0x1f,%ecx
  18005c:	29 ca                	sub    %ecx,%edx
  18005e:	6b d2 64             	imul   $0x64,%edx,%edx
  180061:	29 d0                	sub    %edx,%eax
  180063:	39 d8                	cmp    %ebx,%eax
  180065:	7d db                	jge    180042 <process_main+0x42>
#endif
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  180067:	48 8b 3d 9a 0f 00 00 	mov    0xf9a(%rip),%rdi        # 181008 <heap_top>
  18006e:	48 3b 3d 8b 0f 00 00 	cmp    0xf8b(%rip),%rdi        # 181000 <stack_bottom>
  180075:	74 1c                	je     180093 <process_main+0x93>
//    Allocate a page of memory at address `addr`. `Addr` must be page-aligned
//    (i.e., a multiple of PAGESIZE == 4096). Returns 0 on success and -1
//    on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  180077:	cd 33                	int    $0x33
  180079:	85 c0                	test   %eax,%eax
  18007b:	78 16                	js     180093 <process_main+0x93>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  18007d:	48 8b 05 84 0f 00 00 	mov    0xf84(%rip),%rax        # 181008 <heap_top>
  180084:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  180086:	48 81 05 77 0f 00 00 	addq   $0x1000,0xf77(%rip)        # 181008 <heap_top>
  18008d:	00 10 00 00 
  180091:	eb af                	jmp    180042 <process_main+0x42>
    asm volatile ("int %0" : /* no result */
  180093:	cd 32                	int    $0x32
  180095:	eb fc                	jmp    180093 <process_main+0x93>

0000000000180097 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  180097:	f3 0f 1e fa          	endbr64 
  18009b:	48 89 f9             	mov    %rdi,%rcx
  18009e:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1800a0:	48 8d 05 f9 8e f3 ff 	lea    -0xc7107(%rip),%rax        # b8fa0 <console+0xfa0>
  1800a7:	48 39 41 08          	cmp    %rax,0x8(%rcx)
  1800ab:	72 0b                	jb     1800b8 <console_putc+0x21>
        cp->cursor = console;
  1800ad:	48 8d 80 60 f0 ff ff 	lea    -0xfa0(%rax),%rax
  1800b4:	48 89 41 08          	mov    %rax,0x8(%rcx)
    }
    if (c == '\n') {
  1800b8:	40 80 fe 0a          	cmp    $0xa,%sil
  1800bc:	74 16                	je     1800d4 <console_putc+0x3d>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1800be:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1800c2:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1800c6:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1800ca:	40 0f b6 f6          	movzbl %sil,%esi
  1800ce:	09 fe                	or     %edi,%esi
  1800d0:	66 89 30             	mov    %si,(%rax)
    }
}
  1800d3:	c3                   	ret    
        int pos = (cp->cursor - console) % 80;
  1800d4:	48 8d 05 25 7f f3 ff 	lea    -0xc80db(%rip),%rax        # b8000 <console>
  1800db:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1800df:	49 29 c0             	sub    %rax,%r8
  1800e2:	4c 89 c6             	mov    %r8,%rsi
  1800e5:	48 d1 fe             	sar    %rsi
  1800e8:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1800ef:	66 66 66 
  1800f2:	48 89 f0             	mov    %rsi,%rax
  1800f5:	48 f7 ea             	imul   %rdx
  1800f8:	48 c1 fa 05          	sar    $0x5,%rdx
  1800fc:	49 c1 f8 3f          	sar    $0x3f,%r8
  180100:	4c 29 c2             	sub    %r8,%rdx
  180103:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  180107:	48 c1 e2 04          	shl    $0x4,%rdx
  18010b:	89 f0                	mov    %esi,%eax
  18010d:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  18010f:	83 cf 20             	or     $0x20,%edi
  180112:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180116:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  18011a:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  18011e:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  180121:	83 c0 01             	add    $0x1,%eax
  180124:	83 f8 50             	cmp    $0x50,%eax
  180127:	75 e9                	jne    180112 <console_putc+0x7b>
  180129:	c3                   	ret    

000000000018012a <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  18012a:	f3 0f 1e fa          	endbr64 
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  18012e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  180132:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  180136:	73 0b                	jae    180143 <string_putc+0x19>
        *sp->s++ = c;
  180138:	48 8d 50 01          	lea    0x1(%rax),%rdx
  18013c:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  180140:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  180143:	c3                   	ret    

0000000000180144 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  180144:	f3 0f 1e fa          	endbr64 
  180148:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  18014b:	48 85 d2             	test   %rdx,%rdx
  18014e:	74 17                	je     180167 <memcpy+0x23>
  180150:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  180155:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  18015a:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  18015e:	48 83 c1 01          	add    $0x1,%rcx
  180162:	48 39 d1             	cmp    %rdx,%rcx
  180165:	75 ee                	jne    180155 <memcpy+0x11>
}
  180167:	c3                   	ret    

0000000000180168 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  180168:	f3 0f 1e fa          	endbr64 
  18016c:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  18016f:	48 39 fe             	cmp    %rdi,%rsi
  180172:	72 1d                	jb     180191 <memmove+0x29>
        while (n-- > 0) {
  180174:	b9 00 00 00 00       	mov    $0x0,%ecx
  180179:	48 85 d2             	test   %rdx,%rdx
  18017c:	74 12                	je     180190 <memmove+0x28>
            *d++ = *s++;
  18017e:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  180182:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  180186:	48 83 c1 01          	add    $0x1,%rcx
  18018a:	48 39 ca             	cmp    %rcx,%rdx
  18018d:	75 ef                	jne    18017e <memmove+0x16>
}
  18018f:	c3                   	ret    
  180190:	c3                   	ret    
    if (s < d && s + n > d) {
  180191:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  180195:	48 39 cf             	cmp    %rcx,%rdi
  180198:	73 da                	jae    180174 <memmove+0xc>
        while (n-- > 0) {
  18019a:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  18019e:	48 85 d2             	test   %rdx,%rdx
  1801a1:	74 ec                	je     18018f <memmove+0x27>
            *--d = *--s;
  1801a3:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  1801a7:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  1801aa:	48 83 e9 01          	sub    $0x1,%rcx
  1801ae:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  1801b2:	75 ef                	jne    1801a3 <memmove+0x3b>
  1801b4:	c3                   	ret    

00000000001801b5 <memset>:
void* memset(void* v, int c, size_t n) {
  1801b5:	f3 0f 1e fa          	endbr64 
  1801b9:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1801bc:	48 85 d2             	test   %rdx,%rdx
  1801bf:	74 12                	je     1801d3 <memset+0x1e>
  1801c1:	48 01 fa             	add    %rdi,%rdx
  1801c4:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1801c7:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1801ca:	48 83 c1 01          	add    $0x1,%rcx
  1801ce:	48 39 ca             	cmp    %rcx,%rdx
  1801d1:	75 f4                	jne    1801c7 <memset+0x12>
}
  1801d3:	c3                   	ret    

00000000001801d4 <strlen>:
size_t strlen(const char* s) {
  1801d4:	f3 0f 1e fa          	endbr64 
    for (n = 0; *s != '\0'; ++s) {
  1801d8:	80 3f 00             	cmpb   $0x0,(%rdi)
  1801db:	74 10                	je     1801ed <strlen+0x19>
  1801dd:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1801e2:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1801e6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1801ea:	75 f6                	jne    1801e2 <strlen+0xe>
  1801ec:	c3                   	ret    
  1801ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1801f2:	c3                   	ret    

00000000001801f3 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1801f3:	f3 0f 1e fa          	endbr64 
  1801f7:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1801fa:	ba 00 00 00 00       	mov    $0x0,%edx
  1801ff:	48 85 f6             	test   %rsi,%rsi
  180202:	74 11                	je     180215 <strnlen+0x22>
  180204:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  180208:	74 0c                	je     180216 <strnlen+0x23>
        ++n;
  18020a:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  18020e:	48 39 d0             	cmp    %rdx,%rax
  180211:	75 f1                	jne    180204 <strnlen+0x11>
  180213:	eb 04                	jmp    180219 <strnlen+0x26>
  180215:	c3                   	ret    
  180216:	48 89 d0             	mov    %rdx,%rax
}
  180219:	c3                   	ret    

000000000018021a <strcpy>:
char* strcpy(char* dst, const char* src) {
  18021a:	f3 0f 1e fa          	endbr64 
  18021e:	48 89 f8             	mov    %rdi,%rax
  180221:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  180226:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  18022a:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  18022d:	48 83 c2 01          	add    $0x1,%rdx
  180231:	84 c9                	test   %cl,%cl
  180233:	75 f1                	jne    180226 <strcpy+0xc>
}
  180235:	c3                   	ret    

0000000000180236 <strcmp>:
int strcmp(const char* a, const char* b) {
  180236:	f3 0f 1e fa          	endbr64 
    while (*a && *b && *a == *b) {
  18023a:	0f b6 07             	movzbl (%rdi),%eax
  18023d:	84 c0                	test   %al,%al
  18023f:	74 1a                	je     18025b <strcmp+0x25>
  180241:	0f b6 16             	movzbl (%rsi),%edx
  180244:	38 c2                	cmp    %al,%dl
  180246:	75 13                	jne    18025b <strcmp+0x25>
  180248:	84 d2                	test   %dl,%dl
  18024a:	74 0f                	je     18025b <strcmp+0x25>
        ++a, ++b;
  18024c:	48 83 c7 01          	add    $0x1,%rdi
  180250:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  180254:	0f b6 07             	movzbl (%rdi),%eax
  180257:	84 c0                	test   %al,%al
  180259:	75 e6                	jne    180241 <strcmp+0xb>
    return ((unsigned char) *a > (unsigned char) *b)
  18025b:	3a 06                	cmp    (%rsi),%al
  18025d:	0f 97 c0             	seta   %al
  180260:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  180263:	83 d8 00             	sbb    $0x0,%eax
}
  180266:	c3                   	ret    

0000000000180267 <strchr>:
char* strchr(const char* s, int c) {
  180267:	f3 0f 1e fa          	endbr64 
    while (*s && *s != (char) c) {
  18026b:	0f b6 07             	movzbl (%rdi),%eax
  18026e:	84 c0                	test   %al,%al
  180270:	74 10                	je     180282 <strchr+0x1b>
  180272:	40 38 f0             	cmp    %sil,%al
  180275:	74 18                	je     18028f <strchr+0x28>
        ++s;
  180277:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  18027b:	0f b6 07             	movzbl (%rdi),%eax
  18027e:	84 c0                	test   %al,%al
  180280:	75 f0                	jne    180272 <strchr+0xb>
        return NULL;
  180282:	40 84 f6             	test   %sil,%sil
  180285:	b8 00 00 00 00       	mov    $0x0,%eax
  18028a:	48 0f 44 c7          	cmove  %rdi,%rax
}
  18028e:	c3                   	ret    
  18028f:	48 89 f8             	mov    %rdi,%rax
  180292:	c3                   	ret    

0000000000180293 <rand>:
int rand(void) {
  180293:	f3 0f 1e fa          	endbr64 
    if (!rand_seed_set) {
  180297:	83 3d 76 0d 00 00 00 	cmpl   $0x0,0xd76(%rip)        # 181014 <rand_seed_set>
  18029e:	74 1b                	je     1802bb <rand+0x28>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1802a0:	69 05 66 0d 00 00 0d 	imul   $0x19660d,0xd66(%rip),%eax        # 181010 <rand_seed>
  1802a7:	66 19 00 
  1802aa:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1802af:	89 05 5b 0d 00 00    	mov    %eax,0xd5b(%rip)        # 181010 <rand_seed>
    return rand_seed & RAND_MAX;
  1802b5:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1802ba:	c3                   	ret    
    rand_seed = seed;
  1802bb:	c7 05 4b 0d 00 00 9e 	movl   $0x30d4879e,0xd4b(%rip)        # 181010 <rand_seed>
  1802c2:	87 d4 30 
    rand_seed_set = 1;
  1802c5:	c7 05 45 0d 00 00 01 	movl   $0x1,0xd45(%rip)        # 181014 <rand_seed_set>
  1802cc:	00 00 00 
}
  1802cf:	eb cf                	jmp    1802a0 <rand+0xd>

00000000001802d1 <srand>:
void srand(unsigned seed) {
  1802d1:	f3 0f 1e fa          	endbr64 
    rand_seed = seed;
  1802d5:	89 3d 35 0d 00 00    	mov    %edi,0xd35(%rip)        # 181010 <rand_seed>
    rand_seed_set = 1;
  1802db:	c7 05 2f 0d 00 00 01 	movl   $0x1,0xd2f(%rip)        # 181014 <rand_seed_set>
  1802e2:	00 00 00 
}
  1802e5:	c3                   	ret    

00000000001802e6 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1802e6:	f3 0f 1e fa          	endbr64 
  1802ea:	55                   	push   %rbp
  1802eb:	48 89 e5             	mov    %rsp,%rbp
  1802ee:	41 57                	push   %r15
  1802f0:	41 56                	push   %r14
  1802f2:	41 55                	push   %r13
  1802f4:	41 54                	push   %r12
  1802f6:	53                   	push   %rbx
  1802f7:	48 83 ec 58          	sub    $0x58,%rsp
  1802fb:	49 89 fe             	mov    %rdi,%r14
  1802fe:	89 75 ac             	mov    %esi,-0x54(%rbp)
  180301:	49 89 d4             	mov    %rdx,%r12
  180304:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  180308:	0f b6 02             	movzbl (%rdx),%eax
  18030b:	84 c0                	test   %al,%al
  18030d:	0f 85 cd 04 00 00    	jne    1807e0 <printer_vprintf+0x4fa>
}
  180313:	48 83 c4 58          	add    $0x58,%rsp
  180317:	5b                   	pop    %rbx
  180318:	41 5c                	pop    %r12
  18031a:	41 5d                	pop    %r13
  18031c:	41 5e                	pop    %r14
  18031e:	41 5f                	pop    %r15
  180320:	5d                   	pop    %rbp
  180321:	c3                   	ret    
        for (++format; *format; ++format) {
  180322:	4d 8d 7c 24 01       	lea    0x1(%r12),%r15
  180327:	41 0f b6 5c 24 01    	movzbl 0x1(%r12),%ebx
  18032d:	84 db                	test   %bl,%bl
  18032f:	0f 84 a4 06 00 00    	je     1809d9 <printer_vprintf+0x6f3>
        int flags = 0;
  180335:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  18033b:	4c 8d 25 0f 09 00 00 	lea    0x90f(%rip),%r12        # 180c51 <flag_chars>
  180342:	0f be f3             	movsbl %bl,%esi
  180345:	4c 89 e7             	mov    %r12,%rdi
  180348:	e8 1a ff ff ff       	call   180267 <strchr>
  18034d:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  180350:	48 85 c0             	test   %rax,%rax
  180353:	74 5c                	je     1803b1 <printer_vprintf+0xcb>
                flags |= 1 << (flagc - flag_chars);
  180355:	4c 29 e1             	sub    %r12,%rcx
  180358:	b8 01 00 00 00       	mov    $0x1,%eax
  18035d:	d3 e0                	shl    %cl,%eax
  18035f:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  180362:	49 83 c7 01          	add    $0x1,%r15
  180366:	41 0f b6 1f          	movzbl (%r15),%ebx
  18036a:	84 db                	test   %bl,%bl
  18036c:	75 d4                	jne    180342 <printer_vprintf+0x5c>
  18036e:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
        int width = -1;
  180372:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  180378:	c7 45 a8 ff ff ff ff 	movl   $0xffffffff,-0x58(%rbp)
        if (*format == '.') {
  18037f:	41 80 3f 2e          	cmpb   $0x2e,(%r15)
  180383:	0f 84 b3 00 00 00    	je     18043c <printer_vprintf+0x156>
        int length = 0;
  180389:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  18038e:	41 0f b6 17          	movzbl (%r15),%edx
  180392:	8d 42 bd             	lea    -0x43(%rdx),%eax
  180395:	3c 37                	cmp    $0x37,%al
  180397:	0f 87 e0 04 00 00    	ja     18087d <printer_vprintf+0x597>
  18039d:	0f b6 c0             	movzbl %al,%eax
  1803a0:	48 8d 3d 99 07 00 00 	lea    0x799(%rip),%rdi        # 180b40 <console_clear+0x47>
  1803a7:	48 63 04 87          	movslq (%rdi,%rax,4),%rax
  1803ab:	48 01 f8             	add    %rdi,%rax
  1803ae:	3e ff e0             	notrack jmp *%rax
        if (*format >= '1' && *format <= '9') {
  1803b1:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  1803b5:	8d 43 cf             	lea    -0x31(%rbx),%eax
  1803b8:	3c 08                	cmp    $0x8,%al
  1803ba:	77 31                	ja     1803ed <printer_vprintf+0x107>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1803bc:	41 0f b6 07          	movzbl (%r15),%eax
  1803c0:	8d 50 d0             	lea    -0x30(%rax),%edx
  1803c3:	80 fa 09             	cmp    $0x9,%dl
  1803c6:	77 5e                	ja     180426 <printer_vprintf+0x140>
  1803c8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  1803ce:	49 83 c7 01          	add    $0x1,%r15
  1803d2:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  1803d7:	0f be c0             	movsbl %al,%eax
  1803da:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1803df:	41 0f b6 07          	movzbl (%r15),%eax
  1803e3:	8d 50 d0             	lea    -0x30(%rax),%edx
  1803e6:	80 fa 09             	cmp    $0x9,%dl
  1803e9:	76 e3                	jbe    1803ce <printer_vprintf+0xe8>
  1803eb:	eb 8b                	jmp    180378 <printer_vprintf+0x92>
        } else if (*format == '*') {
  1803ed:	80 fb 2a             	cmp    $0x2a,%bl
  1803f0:	75 3f                	jne    180431 <printer_vprintf+0x14b>
            width = va_arg(val, int);
  1803f2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1803f6:	8b 07                	mov    (%rdi),%eax
  1803f8:	83 f8 2f             	cmp    $0x2f,%eax
  1803fb:	77 17                	ja     180414 <printer_vprintf+0x12e>
  1803fd:	89 c2                	mov    %eax,%edx
  1803ff:	48 03 57 10          	add    0x10(%rdi),%rdx
  180403:	83 c0 08             	add    $0x8,%eax
  180406:	89 07                	mov    %eax,(%rdi)
  180408:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  18040b:	49 83 c7 01          	add    $0x1,%r15
  18040f:	e9 64 ff ff ff       	jmp    180378 <printer_vprintf+0x92>
            width = va_arg(val, int);
  180414:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180418:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  18041c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180420:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180424:	eb e2                	jmp    180408 <printer_vprintf+0x122>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  180426:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  18042c:	e9 47 ff ff ff       	jmp    180378 <printer_vprintf+0x92>
        int width = -1;
  180431:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  180437:	e9 3c ff ff ff       	jmp    180378 <printer_vprintf+0x92>
            ++format;
  18043c:	49 8d 57 01          	lea    0x1(%r15),%rdx
            if (*format >= '0' && *format <= '9') {
  180440:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  180445:	8d 48 d0             	lea    -0x30(%rax),%ecx
  180448:	80 f9 09             	cmp    $0x9,%cl
  18044b:	76 13                	jbe    180460 <printer_vprintf+0x17a>
            } else if (*format == '*') {
  18044d:	3c 2a                	cmp    $0x2a,%al
  18044f:	74 33                	je     180484 <printer_vprintf+0x19e>
            ++format;
  180451:	49 89 d7             	mov    %rdx,%r15
                precision = 0;
  180454:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  18045b:	e9 29 ff ff ff       	jmp    180389 <printer_vprintf+0xa3>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  180460:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  180465:	48 83 c2 01          	add    $0x1,%rdx
  180469:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  18046c:	0f be c0             	movsbl %al,%eax
  18046f:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  180473:	0f b6 02             	movzbl (%rdx),%eax
  180476:	8d 70 d0             	lea    -0x30(%rax),%esi
  180479:	40 80 fe 09          	cmp    $0x9,%sil
  18047d:	76 e6                	jbe    180465 <printer_vprintf+0x17f>
                    precision = 10 * precision + *format++ - '0';
  18047f:	49 89 d7             	mov    %rdx,%r15
  180482:	eb 1c                	jmp    1804a0 <printer_vprintf+0x1ba>
                precision = va_arg(val, int);
  180484:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180488:	8b 01                	mov    (%rcx),%eax
  18048a:	83 f8 2f             	cmp    $0x2f,%eax
  18048d:	77 23                	ja     1804b2 <printer_vprintf+0x1cc>
  18048f:	89 c2                	mov    %eax,%edx
  180491:	48 03 51 10          	add    0x10(%rcx),%rdx
  180495:	83 c0 08             	add    $0x8,%eax
  180498:	89 01                	mov    %eax,(%rcx)
  18049a:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  18049c:	49 83 c7 02          	add    $0x2,%r15
            if (precision < 0) {
  1804a0:	85 c9                	test   %ecx,%ecx
  1804a2:	b8 00 00 00 00       	mov    $0x0,%eax
  1804a7:	0f 49 c1             	cmovns %ecx,%eax
  1804aa:	89 45 a8             	mov    %eax,-0x58(%rbp)
  1804ad:	e9 d7 fe ff ff       	jmp    180389 <printer_vprintf+0xa3>
                precision = va_arg(val, int);
  1804b2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1804b6:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1804ba:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1804be:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1804c2:	eb d6                	jmp    18049a <printer_vprintf+0x1b4>
        switch (*format) {
  1804c4:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1804c9:	e9 f6 00 00 00       	jmp    1805c4 <printer_vprintf+0x2de>
            ++format;
  1804ce:	49 83 c7 01          	add    $0x1,%r15
            length = 1;
  1804d2:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  1804d7:	e9 b2 fe ff ff       	jmp    18038e <printer_vprintf+0xa8>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1804dc:	85 c9                	test   %ecx,%ecx
  1804de:	74 56                	je     180536 <printer_vprintf+0x250>
  1804e0:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1804e4:	8b 07                	mov    (%rdi),%eax
  1804e6:	83 f8 2f             	cmp    $0x2f,%eax
  1804e9:	77 39                	ja     180524 <printer_vprintf+0x23e>
  1804eb:	89 c2                	mov    %eax,%edx
  1804ed:	48 03 57 10          	add    0x10(%rdi),%rdx
  1804f1:	83 c0 08             	add    $0x8,%eax
  1804f4:	89 07                	mov    %eax,(%rdi)
  1804f6:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1804f9:	48 89 d0             	mov    %rdx,%rax
  1804fc:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  180500:	49 89 d0             	mov    %rdx,%r8
  180503:	49 f7 d8             	neg    %r8
  180506:	25 80 00 00 00       	and    $0x80,%eax
  18050b:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  18050f:	0b 45 a0             	or     -0x60(%rbp),%eax
  180512:	83 c8 60             	or     $0x60,%eax
  180515:	89 45 a0             	mov    %eax,-0x60(%rbp)
        char* data = "";
  180518:	4c 8d 25 19 06 00 00 	lea    0x619(%rip),%r12        # 180b38 <console_clear+0x3f>
            break;
  18051f:	e9 39 01 00 00       	jmp    18065d <printer_vprintf+0x377>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  180524:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180528:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  18052c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180530:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180534:	eb c0                	jmp    1804f6 <printer_vprintf+0x210>
  180536:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  18053a:	8b 01                	mov    (%rcx),%eax
  18053c:	83 f8 2f             	cmp    $0x2f,%eax
  18053f:	77 10                	ja     180551 <printer_vprintf+0x26b>
  180541:	89 c2                	mov    %eax,%edx
  180543:	48 03 51 10          	add    0x10(%rcx),%rdx
  180547:	83 c0 08             	add    $0x8,%eax
  18054a:	89 01                	mov    %eax,(%rcx)
  18054c:	48 63 12             	movslq (%rdx),%rdx
  18054f:	eb a8                	jmp    1804f9 <printer_vprintf+0x213>
  180551:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180555:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180559:	48 8d 42 08          	lea    0x8(%rdx),%rax
  18055d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180561:	eb e9                	jmp    18054c <printer_vprintf+0x266>
        int base = 10;
  180563:	be 0a 00 00 00       	mov    $0xa,%esi
  180568:	eb 5a                	jmp    1805c4 <printer_vprintf+0x2de>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  18056a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18056e:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  180572:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180576:	48 89 47 08          	mov    %rax,0x8(%rdi)
  18057a:	eb 62                	jmp    1805de <printer_vprintf+0x2f8>
  18057c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180580:	8b 07                	mov    (%rdi),%eax
  180582:	83 f8 2f             	cmp    $0x2f,%eax
  180585:	77 10                	ja     180597 <printer_vprintf+0x2b1>
  180587:	89 c2                	mov    %eax,%edx
  180589:	48 03 57 10          	add    0x10(%rdi),%rdx
  18058d:	83 c0 08             	add    $0x8,%eax
  180590:	89 07                	mov    %eax,(%rdi)
  180592:	44 8b 02             	mov    (%rdx),%r8d
  180595:	eb 4a                	jmp    1805e1 <printer_vprintf+0x2fb>
  180597:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  18059b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  18059f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1805a3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1805a7:	eb e9                	jmp    180592 <printer_vprintf+0x2ac>
  1805a9:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1805ac:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
    const char* digits = upper_digits;
  1805b3:	48 8d 3d 86 06 00 00 	lea    0x686(%rip),%rdi        # 180c40 <upper_digits.1>
  1805ba:	e9 f3 02 00 00       	jmp    1808b2 <printer_vprintf+0x5cc>
            base = 16;
  1805bf:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1805c4:	85 c9                	test   %ecx,%ecx
  1805c6:	74 b4                	je     18057c <printer_vprintf+0x296>
  1805c8:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1805cc:	8b 01                	mov    (%rcx),%eax
  1805ce:	83 f8 2f             	cmp    $0x2f,%eax
  1805d1:	77 97                	ja     18056a <printer_vprintf+0x284>
  1805d3:	89 c2                	mov    %eax,%edx
  1805d5:	48 03 51 10          	add    0x10(%rcx),%rdx
  1805d9:	83 c0 08             	add    $0x8,%eax
  1805dc:	89 01                	mov    %eax,(%rcx)
  1805de:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  1805e1:	83 4d a0 20          	orl    $0x20,-0x60(%rbp)
    if (base < 0) {
  1805e5:	85 f6                	test   %esi,%esi
  1805e7:	79 c0                	jns    1805a9 <printer_vprintf+0x2c3>
        base = -base;
  1805e9:	41 89 f1             	mov    %esi,%r9d
  1805ec:	f7 de                	neg    %esi
  1805ee:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
        digits = lower_digits;
  1805f5:	48 8d 3d 24 06 00 00 	lea    0x624(%rip),%rdi        # 180c20 <lower_digits.0>
  1805fc:	e9 b1 02 00 00       	jmp    1808b2 <printer_vprintf+0x5cc>
            num = (uintptr_t) va_arg(val, void*);
  180601:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180605:	8b 01                	mov    (%rcx),%eax
  180607:	83 f8 2f             	cmp    $0x2f,%eax
  18060a:	77 1c                	ja     180628 <printer_vprintf+0x342>
  18060c:	89 c2                	mov    %eax,%edx
  18060e:	48 03 51 10          	add    0x10(%rcx),%rdx
  180612:	83 c0 08             	add    $0x8,%eax
  180615:	89 01                	mov    %eax,(%rcx)
  180617:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  18061a:	81 4d a0 21 01 00 00 	orl    $0x121,-0x60(%rbp)
            base = -16;
  180621:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  180626:	eb c1                	jmp    1805e9 <printer_vprintf+0x303>
            num = (uintptr_t) va_arg(val, void*);
  180628:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18062c:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  180630:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180634:	48 89 47 08          	mov    %rax,0x8(%rdi)
  180638:	eb dd                	jmp    180617 <printer_vprintf+0x331>
            data = va_arg(val, char*);
  18063a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18063e:	8b 07                	mov    (%rdi),%eax
  180640:	83 f8 2f             	cmp    $0x2f,%eax
  180643:	0f 87 b0 01 00 00    	ja     1807f9 <printer_vprintf+0x513>
  180649:	89 c2                	mov    %eax,%edx
  18064b:	48 03 57 10          	add    0x10(%rdi),%rdx
  18064f:	83 c0 08             	add    $0x8,%eax
  180652:	89 07                	mov    %eax,(%rdi)
  180654:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  180657:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  18065d:	8b 45 a0             	mov    -0x60(%rbp),%eax
  180660:	83 e0 20             	and    $0x20,%eax
  180663:	89 45 98             	mov    %eax,-0x68(%rbp)
  180666:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  18066c:	0f 85 2e 02 00 00    	jne    1808a0 <printer_vprintf+0x5ba>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  180672:	8b 45 a0             	mov    -0x60(%rbp),%eax
  180675:	89 45 8c             	mov    %eax,-0x74(%rbp)
  180678:	83 e0 60             	and    $0x60,%eax
  18067b:	83 f8 60             	cmp    $0x60,%eax
  18067e:	0f 84 63 02 00 00    	je     1808e7 <printer_vprintf+0x601>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  180684:	8b 45 a0             	mov    -0x60(%rbp),%eax
  180687:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  18068a:	48 8d 1d a7 04 00 00 	lea    0x4a7(%rip),%rbx        # 180b38 <console_clear+0x3f>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  180691:	83 f8 21             	cmp    $0x21,%eax
  180694:	0f 84 8a 02 00 00    	je     180924 <printer_vprintf+0x63e>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  18069a:	8b 7d a8             	mov    -0x58(%rbp),%edi
  18069d:	89 f8                	mov    %edi,%eax
  18069f:	f7 d0                	not    %eax
  1806a1:	c1 e8 1f             	shr    $0x1f,%eax
  1806a4:	89 45 88             	mov    %eax,-0x78(%rbp)
  1806a7:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  1806ab:	0f 85 b2 02 00 00    	jne    180963 <printer_vprintf+0x67d>
  1806b1:	84 c0                	test   %al,%al
  1806b3:	0f 84 aa 02 00 00    	je     180963 <printer_vprintf+0x67d>
            len = strnlen(data, precision);
  1806b9:	48 63 f7             	movslq %edi,%rsi
  1806bc:	4c 89 e7             	mov    %r12,%rdi
  1806bf:	e8 2f fb ff ff       	call   1801f3 <strnlen>
  1806c4:	89 45 9c             	mov    %eax,-0x64(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1806c7:	8b 45 8c             	mov    -0x74(%rbp),%eax
  1806ca:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  1806cd:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1806d4:	83 f8 22             	cmp    $0x22,%eax
  1806d7:	0f 84 be 02 00 00    	je     18099b <printer_vprintf+0x6b5>
        width -= len + zeros + strlen(prefix);
  1806dd:	48 89 df             	mov    %rbx,%rdi
  1806e0:	e8 ef fa ff ff       	call   1801d4 <strlen>
  1806e5:	8b 55 a8             	mov    -0x58(%rbp),%edx
  1806e8:	03 55 9c             	add    -0x64(%rbp),%edx
  1806eb:	44 89 e9             	mov    %r13d,%ecx
  1806ee:	29 d1                	sub    %edx,%ecx
  1806f0:	29 c1                	sub    %eax,%ecx
  1806f2:	89 4d 98             	mov    %ecx,-0x68(%rbp)
  1806f5:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1806f8:	f6 45 a0 04          	testb  $0x4,-0x60(%rbp)
  1806fc:	75 37                	jne    180735 <printer_vprintf+0x44f>
  1806fe:	85 c9                	test   %ecx,%ecx
  180700:	7e 33                	jle    180735 <printer_vprintf+0x44f>
        width -= len + zeros + strlen(prefix);
  180702:	48 89 5d a0          	mov    %rbx,-0x60(%rbp)
  180706:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  180709:	89 da                	mov    %ebx,%edx
  18070b:	be 20 00 00 00       	mov    $0x20,%esi
  180710:	4c 89 f7             	mov    %r14,%rdi
  180713:	41 ff 16             	call   *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  180716:	41 83 ed 01          	sub    $0x1,%r13d
  18071a:	45 85 ed             	test   %r13d,%r13d
  18071d:	7f ea                	jg     180709 <printer_vprintf+0x423>
  18071f:	48 8b 5d a0          	mov    -0x60(%rbp),%rbx
  180723:	8b 7d 98             	mov    -0x68(%rbp),%edi
  180726:	85 ff                	test   %edi,%edi
  180728:	b8 01 00 00 00       	mov    $0x1,%eax
  18072d:	0f 4f c7             	cmovg  %edi,%eax
  180730:	29 c7                	sub    %eax,%edi
  180732:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  180735:	0f b6 03             	movzbl (%rbx),%eax
  180738:	84 c0                	test   %al,%al
  18073a:	74 23                	je     18075f <printer_vprintf+0x479>
  18073c:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  180740:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, *prefix, color);
  180744:	0f b6 f0             	movzbl %al,%esi
  180747:	44 89 e2             	mov    %r12d,%edx
  18074a:	4c 89 f7             	mov    %r14,%rdi
  18074d:	41 ff 16             	call   *(%r14)
        for (; *prefix; ++prefix) {
  180750:	48 83 c3 01          	add    $0x1,%rbx
  180754:	0f b6 03             	movzbl (%rbx),%eax
  180757:	84 c0                	test   %al,%al
  180759:	75 e9                	jne    180744 <printer_vprintf+0x45e>
  18075b:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; zeros > 0; --zeros) {
  18075f:	8b 5d a8             	mov    -0x58(%rbp),%ebx
  180762:	85 db                	test   %ebx,%ebx
  180764:	7e 1f                	jle    180785 <printer_vprintf+0x49f>
  180766:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  18076a:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, '0', color);
  18076e:	44 89 e2             	mov    %r12d,%edx
  180771:	be 30 00 00 00       	mov    $0x30,%esi
  180776:	4c 89 f7             	mov    %r14,%rdi
  180779:	41 ff 16             	call   *(%r14)
        for (; zeros > 0; --zeros) {
  18077c:	83 eb 01             	sub    $0x1,%ebx
  18077f:	75 ed                	jne    18076e <printer_vprintf+0x488>
  180781:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; len > 0; ++data, --len) {
  180785:	8b 45 9c             	mov    -0x64(%rbp),%eax
  180788:	85 c0                	test   %eax,%eax
  18078a:	7e 28                	jle    1807b4 <printer_vprintf+0x4ce>
  18078c:	89 c3                	mov    %eax,%ebx
  18078e:	4c 01 e3             	add    %r12,%rbx
  180791:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  180795:	44 8b 6d ac          	mov    -0x54(%rbp),%r13d
            p->putc(p, *data, color);
  180799:	41 0f b6 34 24       	movzbl (%r12),%esi
  18079e:	44 89 ea             	mov    %r13d,%edx
  1807a1:	4c 89 f7             	mov    %r14,%rdi
  1807a4:	41 ff 16             	call   *(%r14)
        for (; len > 0; ++data, --len) {
  1807a7:	49 83 c4 01          	add    $0x1,%r12
  1807ab:	49 39 dc             	cmp    %rbx,%r12
  1807ae:	75 e9                	jne    180799 <printer_vprintf+0x4b3>
  1807b0:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
        for (; width > 0; --width) {
  1807b4:	45 85 ed             	test   %r13d,%r13d
  1807b7:	7e 16                	jle    1807cf <printer_vprintf+0x4e9>
  1807b9:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  1807bc:	89 da                	mov    %ebx,%edx
  1807be:	be 20 00 00 00       	mov    $0x20,%esi
  1807c3:	4c 89 f7             	mov    %r14,%rdi
  1807c6:	41 ff 16             	call   *(%r14)
        for (; width > 0; --width) {
  1807c9:	41 83 ed 01          	sub    $0x1,%r13d
  1807cd:	75 ed                	jne    1807bc <printer_vprintf+0x4d6>
    for (; *format; ++format) {
  1807cf:	4d 8d 67 01          	lea    0x1(%r15),%r12
  1807d3:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  1807d8:	84 c0                	test   %al,%al
  1807da:	0f 84 33 fb ff ff    	je     180313 <printer_vprintf+0x2d>
        if (*format != '%') {
  1807e0:	3c 25                	cmp    $0x25,%al
  1807e2:	0f 84 3a fb ff ff    	je     180322 <printer_vprintf+0x3c>
            p->putc(p, *format, color);
  1807e8:	0f b6 f0             	movzbl %al,%esi
  1807eb:	8b 55 ac             	mov    -0x54(%rbp),%edx
  1807ee:	4c 89 f7             	mov    %r14,%rdi
  1807f1:	41 ff 16             	call   *(%r14)
            continue;
  1807f4:	4d 89 e7             	mov    %r12,%r15
  1807f7:	eb d6                	jmp    1807cf <printer_vprintf+0x4e9>
            data = va_arg(val, char*);
  1807f9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1807fd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180801:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180805:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180809:	e9 46 fe ff ff       	jmp    180654 <printer_vprintf+0x36e>
            color = va_arg(val, int);
  18080e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180812:	8b 01                	mov    (%rcx),%eax
  180814:	83 f8 2f             	cmp    $0x2f,%eax
  180817:	77 12                	ja     18082b <printer_vprintf+0x545>
  180819:	89 c2                	mov    %eax,%edx
  18081b:	48 03 51 10          	add    0x10(%rcx),%rdx
  18081f:	83 c0 08             	add    $0x8,%eax
  180822:	89 01                	mov    %eax,(%rcx)
  180824:	8b 02                	mov    (%rdx),%eax
  180826:	89 45 ac             	mov    %eax,-0x54(%rbp)
            goto done;
  180829:	eb a4                	jmp    1807cf <printer_vprintf+0x4e9>
            color = va_arg(val, int);
  18082b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18082f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  180833:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180837:	48 89 47 08          	mov    %rax,0x8(%rdi)
  18083b:	eb e7                	jmp    180824 <printer_vprintf+0x53e>
            numbuf[0] = va_arg(val, int);
  18083d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180841:	8b 07                	mov    (%rdi),%eax
  180843:	83 f8 2f             	cmp    $0x2f,%eax
  180846:	77 23                	ja     18086b <printer_vprintf+0x585>
  180848:	89 c2                	mov    %eax,%edx
  18084a:	48 03 57 10          	add    0x10(%rdi),%rdx
  18084e:	83 c0 08             	add    $0x8,%eax
  180851:	89 07                	mov    %eax,(%rdi)
  180853:	8b 02                	mov    (%rdx),%eax
  180855:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  180858:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  18085c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  180860:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  180866:	e9 f2 fd ff ff       	jmp    18065d <printer_vprintf+0x377>
            numbuf[0] = va_arg(val, int);
  18086b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  18086f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180873:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180877:	48 89 41 08          	mov    %rax,0x8(%rcx)
  18087b:	eb d6                	jmp    180853 <printer_vprintf+0x56d>
            numbuf[0] = (*format ? *format : '%');
  18087d:	84 d2                	test   %dl,%dl
  18087f:	0f 85 3e 01 00 00    	jne    1809c3 <printer_vprintf+0x6dd>
  180885:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  180889:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  18088d:	49 83 ef 01          	sub    $0x1,%r15
            data = numbuf;
  180891:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  180895:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  18089b:	e9 bd fd ff ff       	jmp    18065d <printer_vprintf+0x377>
        if (flags & FLAG_NUMERIC) {
  1808a0:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1808a6:	48 8d 3d 93 03 00 00 	lea    0x393(%rip),%rdi        # 180c40 <upper_digits.1>
        if (flags & FLAG_NUMERIC) {
  1808ad:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1808b2:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1808b6:	4c 89 c1             	mov    %r8,%rcx
  1808b9:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1808bd:	48 63 f6             	movslq %esi,%rsi
  1808c0:	49 83 ec 01          	sub    $0x1,%r12
  1808c4:	48 89 c8             	mov    %rcx,%rax
  1808c7:	ba 00 00 00 00       	mov    $0x0,%edx
  1808cc:	48 f7 f6             	div    %rsi
  1808cf:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1808d3:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1808d7:	48 89 ca             	mov    %rcx,%rdx
  1808da:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  1808dd:	48 39 d6             	cmp    %rdx,%rsi
  1808e0:	76 de                	jbe    1808c0 <printer_vprintf+0x5da>
  1808e2:	e9 8b fd ff ff       	jmp    180672 <printer_vprintf+0x38c>
                prefix = "-";
  1808e7:	48 8d 1d 47 02 00 00 	lea    0x247(%rip),%rbx        # 180b35 <console_clear+0x3c>
            if (flags & FLAG_NEGATIVE) {
  1808ee:	8b 45 a0             	mov    -0x60(%rbp),%eax
  1808f1:	a8 80                	test   $0x80,%al
  1808f3:	0f 85 a1 fd ff ff    	jne    18069a <printer_vprintf+0x3b4>
                prefix = "+";
  1808f9:	48 8d 1d 30 02 00 00 	lea    0x230(%rip),%rbx        # 180b30 <console_clear+0x37>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  180900:	a8 10                	test   $0x10,%al
  180902:	0f 85 92 fd ff ff    	jne    18069a <printer_vprintf+0x3b4>
                prefix = " ";
  180908:	a8 08                	test   $0x8,%al
  18090a:	48 8d 15 27 02 00 00 	lea    0x227(%rip),%rdx        # 180b38 <console_clear+0x3f>
  180911:	48 8d 05 1f 02 00 00 	lea    0x21f(%rip),%rax        # 180b37 <console_clear+0x3e>
  180918:	48 0f 44 c2          	cmove  %rdx,%rax
  18091c:	48 89 c3             	mov    %rax,%rbx
  18091f:	e9 76 fd ff ff       	jmp    18069a <printer_vprintf+0x3b4>
                   && (base == 16 || base == -16)
  180924:	41 8d 41 10          	lea    0x10(%r9),%eax
  180928:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  18092d:	0f 85 67 fd ff ff    	jne    18069a <printer_vprintf+0x3b4>
                   && (num || (flags & FLAG_ALT2))) {
  180933:	4d 85 c0             	test   %r8,%r8
  180936:	75 0d                	jne    180945 <printer_vprintf+0x65f>
  180938:	f7 45 a0 00 01 00 00 	testl  $0x100,-0x60(%rbp)
  18093f:	0f 84 55 fd ff ff    	je     18069a <printer_vprintf+0x3b4>
            prefix = (base == -16 ? "0x" : "0X");
  180945:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  180949:	48 8d 15 e9 01 00 00 	lea    0x1e9(%rip),%rdx        # 180b39 <console_clear+0x40>
  180950:	48 8d 05 db 01 00 00 	lea    0x1db(%rip),%rax        # 180b32 <console_clear+0x39>
  180957:	48 0f 44 c2          	cmove  %rdx,%rax
  18095b:	48 89 c3             	mov    %rax,%rbx
  18095e:	e9 37 fd ff ff       	jmp    18069a <printer_vprintf+0x3b4>
            len = strlen(data);
  180963:	4c 89 e7             	mov    %r12,%rdi
  180966:	e8 69 f8 ff ff       	call   1801d4 <strlen>
  18096b:	89 45 9c             	mov    %eax,-0x64(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  18096e:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  180972:	0f 84 4f fd ff ff    	je     1806c7 <printer_vprintf+0x3e1>
  180978:	80 7d 88 00          	cmpb   $0x0,-0x78(%rbp)
  18097c:	0f 84 45 fd ff ff    	je     1806c7 <printer_vprintf+0x3e1>
            zeros = precision > len ? precision - len : 0;
  180982:	8b 4d a8             	mov    -0x58(%rbp),%ecx
  180985:	89 ca                	mov    %ecx,%edx
  180987:	29 c2                	sub    %eax,%edx
  180989:	39 c1                	cmp    %eax,%ecx
  18098b:	b8 00 00 00 00       	mov    $0x0,%eax
  180990:	0f 4f c2             	cmovg  %edx,%eax
  180993:	89 45 a8             	mov    %eax,-0x58(%rbp)
  180996:	e9 42 fd ff ff       	jmp    1806dd <printer_vprintf+0x3f7>
                   && len + (int) strlen(prefix) < width) {
  18099b:	48 89 df             	mov    %rbx,%rdi
  18099e:	e8 31 f8 ff ff       	call   1801d4 <strlen>
  1809a3:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1809a6:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1809a9:	44 89 e9             	mov    %r13d,%ecx
  1809ac:	29 f9                	sub    %edi,%ecx
  1809ae:	29 c1                	sub    %eax,%ecx
  1809b0:	44 39 ea             	cmp    %r13d,%edx
  1809b3:	b8 00 00 00 00       	mov    $0x0,%eax
  1809b8:	0f 4c c1             	cmovl  %ecx,%eax
  1809bb:	89 45 a8             	mov    %eax,-0x58(%rbp)
  1809be:	e9 1a fd ff ff       	jmp    1806dd <printer_vprintf+0x3f7>
            numbuf[0] = (*format ? *format : '%');
  1809c3:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1809c6:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1809ca:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1809ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1809d4:	e9 84 fc ff ff       	jmp    18065d <printer_vprintf+0x377>
        int flags = 0;
  1809d9:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%rbp)
  1809e0:	e9 8d f9 ff ff       	jmp    180372 <printer_vprintf+0x8c>

00000000001809e5 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1809e5:	f3 0f 1e fa          	endbr64 
  1809e9:	55                   	push   %rbp
  1809ea:	48 89 e5             	mov    %rsp,%rbp
  1809ed:	53                   	push   %rbx
  1809ee:	48 83 ec 18          	sub    $0x18,%rsp
    cp.p.putc = console_putc;
  1809f2:	48 8d 05 9e f6 ff ff 	lea    -0x962(%rip),%rax        # 180097 <console_putc>
  1809f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        cpos = 0;
  1809fd:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  180a03:	b8 00 00 00 00       	mov    $0x0,%eax
  180a08:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  180a0b:	48 63 ff             	movslq %edi,%rdi
  180a0e:	48 8d 1d eb 75 f3 ff 	lea    -0xc8a15(%rip),%rbx        # b8000 <console>
  180a15:	48 8d 04 7b          	lea    (%rbx,%rdi,2),%rax
  180a19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  180a1d:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  180a21:	e8 c0 f8 ff ff       	call   1802e6 <printer_vprintf>
    return cp.cursor - console;
  180a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  180a2a:	48 29 d8             	sub    %rbx,%rax
  180a2d:	48 d1 f8             	sar    %rax
}
  180a30:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  180a34:	c9                   	leave  
  180a35:	c3                   	ret    

0000000000180a36 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  180a36:	f3 0f 1e fa          	endbr64 
  180a3a:	55                   	push   %rbp
  180a3b:	48 89 e5             	mov    %rsp,%rbp
  180a3e:	48 83 ec 50          	sub    $0x50,%rsp
  180a42:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  180a46:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  180a4a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  180a4e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  180a55:	48 8d 45 10          	lea    0x10(%rbp),%rax
  180a59:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  180a5d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  180a61:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  180a65:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  180a69:	e8 77 ff ff ff       	call   1809e5 <console_vprintf>
}
  180a6e:	c9                   	leave  
  180a6f:	c3                   	ret    

0000000000180a70 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  180a70:	f3 0f 1e fa          	endbr64 
  180a74:	55                   	push   %rbp
  180a75:	48 89 e5             	mov    %rsp,%rbp
  180a78:	53                   	push   %rbx
  180a79:	48 83 ec 28          	sub    $0x28,%rsp
  180a7d:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  180a80:	48 8d 05 a3 f6 ff ff 	lea    -0x95d(%rip),%rax        # 18012a <string_putc>
  180a87:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    sp.s = s;
  180a8b:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  180a8f:	48 85 f6             	test   %rsi,%rsi
  180a92:	75 0b                	jne    180a9f <vsnprintf+0x2f>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  180a94:	8b 45 e0             	mov    -0x20(%rbp),%eax
  180a97:	29 d8                	sub    %ebx,%eax
}
  180a99:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  180a9d:	c9                   	leave  
  180a9e:	c3                   	ret    
        sp.end = s + size - 1;
  180a9f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  180aa4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  180aa8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  180aac:	be 00 00 00 00       	mov    $0x0,%esi
  180ab1:	e8 30 f8 ff ff       	call   1802e6 <printer_vprintf>
        *sp.s = 0;
  180ab6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  180aba:	c6 00 00             	movb   $0x0,(%rax)
  180abd:	eb d5                	jmp    180a94 <vsnprintf+0x24>

0000000000180abf <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  180abf:	f3 0f 1e fa          	endbr64 
  180ac3:	55                   	push   %rbp
  180ac4:	48 89 e5             	mov    %rsp,%rbp
  180ac7:	48 83 ec 50          	sub    $0x50,%rsp
  180acb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  180acf:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  180ad3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  180ad7:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  180ade:	48 8d 45 10          	lea    0x10(%rbp),%rax
  180ae2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  180ae6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  180aea:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  180aee:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  180af2:	e8 79 ff ff ff       	call   180a70 <vsnprintf>
    va_end(val);
    return n;
}
  180af7:	c9                   	leave  
  180af8:	c3                   	ret    

0000000000180af9 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  180af9:	f3 0f 1e fa          	endbr64 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  180afd:	48 8d 05 fc 74 f3 ff 	lea    -0xc8b04(%rip),%rax        # b8000 <console>
  180b04:	48 8d 90 a0 0f 00 00 	lea    0xfa0(%rax),%rdx
        console[i] = ' ' | 0x0700;
  180b0b:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  180b10:	48 83 c0 02          	add    $0x2,%rax
  180b14:	48 39 d0             	cmp    %rdx,%rax
  180b17:	75 f2                	jne    180b0b <console_clear+0x12>
    }
    cursorpos = 0;
  180b19:	c7 05 d9 84 f3 ff 00 	movl   $0x0,-0xc7b27(%rip)        # b8ffc <cursorpos>
  180b20:	00 00 00 
}
  180b23:	c3                   	ret    
