
obj/p-fork.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
extern uint8_t end[];

uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	f3 0f 1e fa          	endbr64 
  100004:	55                   	push   %rbp
  100005:	48 89 e5             	mov    %rsp,%rbp
  100008:	53                   	push   %rbx
  100009:	48 83 ec 08          	sub    $0x8,%rsp
// sys_fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t sys_fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  10000d:	cd 34                	int    $0x34
    // Fork a total of three new copies.
    pid_t p1 = sys_fork();
    assert(p1 >= 0);
  10000f:	85 c0                	test   %eax,%eax
  100011:	78 52                	js     100065 <process_main+0x65>
  100013:	89 c2                	mov    %eax,%edx
  100015:	cd 34                	int    $0x34
  100017:	89 c1                	mov    %eax,%ecx
    pid_t p2 = sys_fork();
    assert(p2 >= 0);
  100019:	85 c0                	test   %eax,%eax
  10001b:	78 60                	js     10007d <process_main+0x7d>
    asm volatile ("int %1" : "=a" (result)
  10001d:	cd 31                	int    $0x31

    // Check fork return values: fork should return 0 to child.
    if (sys_getpid() == 1) {
  10001f:	83 f8 01             	cmp    $0x1,%eax
  100022:	74 71                	je     100095 <process_main+0x95>
        assert(p1 != 0 && p2 != 0 && p1 != p2);
    } else {
        assert(p1 == 0 || p2 == 0);
  100024:	85 d2                	test   %edx,%edx
  100026:	74 08                	je     100030 <process_main+0x30>
  100028:	85 c9                	test   %ecx,%ecx
  10002a:	0f 85 8f 00 00 00    	jne    1000bf <process_main+0xbf>
  100030:	cd 31                	int    $0x31
  100032:	89 c3                	mov    %eax,%ebx
    }

    // The rest of this code is like p-allocator.c.

    pid_t p = sys_getpid();
    srand(p);
  100034:	89 c7                	mov    %eax,%edi
  100036:	e8 2b 03 00 00       	call   100366 <srand>

    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  10003b:	48 8d 05 d5 1f 00 00 	lea    0x1fd5(%rip),%rax        # 102017 <end+0xfff>
  100042:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100048:	48 89 05 b9 0f 00 00 	mov    %rax,0xfb9(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10004f:	48 89 e0             	mov    %rsp,%rax
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100052:	48 83 e8 01          	sub    $0x1,%rax
  100056:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10005c:	48 89 05 9d 0f 00 00 	mov    %rax,0xf9d(%rip)        # 101000 <stack_bottom>
  100063:	eb 74                	jmp    1000d9 <process_main+0xd9>
    assert(p1 >= 0);
  100065:	48 8d 15 f4 0c 00 00 	lea    0xcf4(%rip),%rdx        # 100d60 <assert_fail+0x38>
  10006c:	be 0d 00 00 00       	mov    $0xd,%esi
  100071:	48 8d 3d f0 0c 00 00 	lea    0xcf0(%rip),%rdi        # 100d68 <assert_fail+0x40>
  100078:	e8 ab 0c 00 00       	call   100d28 <assert_fail>
    assert(p2 >= 0);
  10007d:	48 8d 15 ed 0c 00 00 	lea    0xced(%rip),%rdx        # 100d71 <assert_fail+0x49>
  100084:	be 0f 00 00 00       	mov    $0xf,%esi
  100089:	48 8d 3d d8 0c 00 00 	lea    0xcd8(%rip),%rdi        # 100d68 <assert_fail+0x40>
  100090:	e8 93 0c 00 00       	call   100d28 <assert_fail>
        assert(p1 != 0 && p2 != 0 && p1 != p2);
  100095:	85 c9                	test   %ecx,%ecx
  100097:	0f 94 c0             	sete   %al
  10009a:	39 ca                	cmp    %ecx,%edx
  10009c:	0f 94 c1             	sete   %cl
  10009f:	08 c8                	or     %cl,%al
  1000a1:	75 04                	jne    1000a7 <process_main+0xa7>
  1000a3:	85 d2                	test   %edx,%edx
  1000a5:	75 89                	jne    100030 <process_main+0x30>
  1000a7:	48 8d 15 e2 0c 00 00 	lea    0xce2(%rip),%rdx        # 100d90 <assert_fail+0x68>
  1000ae:	be 13 00 00 00       	mov    $0x13,%esi
  1000b3:	48 8d 3d ae 0c 00 00 	lea    0xcae(%rip),%rdi        # 100d68 <assert_fail+0x40>
  1000ba:	e8 69 0c 00 00       	call   100d28 <assert_fail>
        assert(p1 == 0 || p2 == 0);
  1000bf:	48 8d 15 b3 0c 00 00 	lea    0xcb3(%rip),%rdx        # 100d79 <assert_fail+0x51>
  1000c6:	be 15 00 00 00       	mov    $0x15,%esi
  1000cb:	48 8d 3d 96 0c 00 00 	lea    0xc96(%rip),%rdi        # 100d68 <assert_fail+0x40>
  1000d2:	e8 51 0c 00 00       	call   100d28 <assert_fail>
    asm volatile ("int %0" : /* no result */
  1000d7:	cd 32                	int    $0x32

    while (1) {
#if !NO_SLOWDOWN
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  1000d9:	e8 4a 02 00 00       	call   100328 <rand>
  1000de:	48 63 d0             	movslq %eax,%rdx
  1000e1:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  1000e8:	48 c1 fa 25          	sar    $0x25,%rdx
  1000ec:	89 c1                	mov    %eax,%ecx
  1000ee:	c1 f9 1f             	sar    $0x1f,%ecx
  1000f1:	29 ca                	sub    %ecx,%edx
  1000f3:	6b d2 64             	imul   $0x64,%edx,%edx
  1000f6:	29 d0                	sub    %edx,%eax
  1000f8:	39 d8                	cmp    %ebx,%eax
  1000fa:	7d db                	jge    1000d7 <process_main+0xd7>
#endif
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1000fc:	48 8b 3d 05 0f 00 00 	mov    0xf05(%rip),%rdi        # 101008 <heap_top>
  100103:	48 3b 3d f6 0e 00 00 	cmp    0xef6(%rip),%rdi        # 101000 <stack_bottom>
  10010a:	74 1c                	je     100128 <process_main+0x128>
    asm volatile ("int %1" : "=a" (result)
  10010c:	cd 33                	int    $0x33
  10010e:	85 c0                	test   %eax,%eax
  100110:	78 16                	js     100128 <process_main+0x128>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  100112:	48 8b 05 ef 0e 00 00 	mov    0xeef(%rip),%rax        # 101008 <heap_top>
  100119:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  10011b:	48 81 05 e2 0e 00 00 	addq   $0x1000,0xee2(%rip)        # 101008 <heap_top>
  100122:	00 10 00 00 
  100126:	eb af                	jmp    1000d7 <process_main+0xd7>
    asm volatile ("int %0" : /* no result */
  100128:	cd 32                	int    $0x32
  10012a:	eb fc                	jmp    100128 <process_main+0x128>

000000000010012c <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  10012c:	f3 0f 1e fa          	endbr64 
  100130:	48 89 f9             	mov    %rdi,%rcx
  100133:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100135:	48 8d 05 64 8e fb ff 	lea    -0x4719c(%rip),%rax        # b8fa0 <console+0xfa0>
  10013c:	48 39 41 08          	cmp    %rax,0x8(%rcx)
  100140:	72 0b                	jb     10014d <console_putc+0x21>
        cp->cursor = console;
  100142:	48 8d 80 60 f0 ff ff 	lea    -0xfa0(%rax),%rax
  100149:	48 89 41 08          	mov    %rax,0x8(%rcx)
    }
    if (c == '\n') {
  10014d:	40 80 fe 0a          	cmp    $0xa,%sil
  100151:	74 16                	je     100169 <console_putc+0x3d>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  100153:	48 8b 41 08          	mov    0x8(%rcx),%rax
  100157:	48 8d 50 02          	lea    0x2(%rax),%rdx
  10015b:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  10015f:	40 0f b6 f6          	movzbl %sil,%esi
  100163:	09 fe                	or     %edi,%esi
  100165:	66 89 30             	mov    %si,(%rax)
    }
}
  100168:	c3                   	ret    
        int pos = (cp->cursor - console) % 80;
  100169:	48 8d 05 90 7e fb ff 	lea    -0x48170(%rip),%rax        # b8000 <console>
  100170:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  100174:	49 29 c0             	sub    %rax,%r8
  100177:	4c 89 c6             	mov    %r8,%rsi
  10017a:	48 d1 fe             	sar    %rsi
  10017d:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  100184:	66 66 66 
  100187:	48 89 f0             	mov    %rsi,%rax
  10018a:	48 f7 ea             	imul   %rdx
  10018d:	48 c1 fa 05          	sar    $0x5,%rdx
  100191:	49 c1 f8 3f          	sar    $0x3f,%r8
  100195:	4c 29 c2             	sub    %r8,%rdx
  100198:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  10019c:	48 c1 e2 04          	shl    $0x4,%rdx
  1001a0:	89 f0                	mov    %esi,%eax
  1001a2:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1001a4:	83 cf 20             	or     $0x20,%edi
  1001a7:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1001ab:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  1001af:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  1001b3:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  1001b6:	83 c0 01             	add    $0x1,%eax
  1001b9:	83 f8 50             	cmp    $0x50,%eax
  1001bc:	75 e9                	jne    1001a7 <console_putc+0x7b>
  1001be:	c3                   	ret    

00000000001001bf <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  1001bf:	f3 0f 1e fa          	endbr64 
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1001c3:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1001c7:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1001cb:	73 0b                	jae    1001d8 <string_putc+0x19>
        *sp->s++ = c;
  1001cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1001d1:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1001d5:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1001d8:	c3                   	ret    

00000000001001d9 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1001d9:	f3 0f 1e fa          	endbr64 
  1001dd:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001e0:	48 85 d2             	test   %rdx,%rdx
  1001e3:	74 17                	je     1001fc <memcpy+0x23>
  1001e5:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1001ea:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1001ef:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001f3:	48 83 c1 01          	add    $0x1,%rcx
  1001f7:	48 39 d1             	cmp    %rdx,%rcx
  1001fa:	75 ee                	jne    1001ea <memcpy+0x11>
}
  1001fc:	c3                   	ret    

00000000001001fd <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  1001fd:	f3 0f 1e fa          	endbr64 
  100201:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  100204:	48 39 fe             	cmp    %rdi,%rsi
  100207:	72 1d                	jb     100226 <memmove+0x29>
        while (n-- > 0) {
  100209:	b9 00 00 00 00       	mov    $0x0,%ecx
  10020e:	48 85 d2             	test   %rdx,%rdx
  100211:	74 12                	je     100225 <memmove+0x28>
            *d++ = *s++;
  100213:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  100217:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  10021b:	48 83 c1 01          	add    $0x1,%rcx
  10021f:	48 39 ca             	cmp    %rcx,%rdx
  100222:	75 ef                	jne    100213 <memmove+0x16>
}
  100224:	c3                   	ret    
  100225:	c3                   	ret    
    if (s < d && s + n > d) {
  100226:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  10022a:	48 39 cf             	cmp    %rcx,%rdi
  10022d:	73 da                	jae    100209 <memmove+0xc>
        while (n-- > 0) {
  10022f:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  100233:	48 85 d2             	test   %rdx,%rdx
  100236:	74 ec                	je     100224 <memmove+0x27>
            *--d = *--s;
  100238:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  10023c:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  10023f:	48 83 e9 01          	sub    $0x1,%rcx
  100243:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  100247:	75 ef                	jne    100238 <memmove+0x3b>
  100249:	c3                   	ret    

000000000010024a <memset>:
void* memset(void* v, int c, size_t n) {
  10024a:	f3 0f 1e fa          	endbr64 
  10024e:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100251:	48 85 d2             	test   %rdx,%rdx
  100254:	74 12                	je     100268 <memset+0x1e>
  100256:	48 01 fa             	add    %rdi,%rdx
  100259:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  10025c:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  10025f:	48 83 c1 01          	add    $0x1,%rcx
  100263:	48 39 ca             	cmp    %rcx,%rdx
  100266:	75 f4                	jne    10025c <memset+0x12>
}
  100268:	c3                   	ret    

0000000000100269 <strlen>:
size_t strlen(const char* s) {
  100269:	f3 0f 1e fa          	endbr64 
    for (n = 0; *s != '\0'; ++s) {
  10026d:	80 3f 00             	cmpb   $0x0,(%rdi)
  100270:	74 10                	je     100282 <strlen+0x19>
  100272:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  100277:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  10027b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  10027f:	75 f6                	jne    100277 <strlen+0xe>
  100281:	c3                   	ret    
  100282:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100287:	c3                   	ret    

0000000000100288 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  100288:	f3 0f 1e fa          	endbr64 
  10028c:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10028f:	ba 00 00 00 00       	mov    $0x0,%edx
  100294:	48 85 f6             	test   %rsi,%rsi
  100297:	74 11                	je     1002aa <strnlen+0x22>
  100299:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  10029d:	74 0c                	je     1002ab <strnlen+0x23>
        ++n;
  10029f:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1002a3:	48 39 d0             	cmp    %rdx,%rax
  1002a6:	75 f1                	jne    100299 <strnlen+0x11>
  1002a8:	eb 04                	jmp    1002ae <strnlen+0x26>
  1002aa:	c3                   	ret    
  1002ab:	48 89 d0             	mov    %rdx,%rax
}
  1002ae:	c3                   	ret    

00000000001002af <strcpy>:
char* strcpy(char* dst, const char* src) {
  1002af:	f3 0f 1e fa          	endbr64 
  1002b3:	48 89 f8             	mov    %rdi,%rax
  1002b6:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1002bb:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1002bf:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1002c2:	48 83 c2 01          	add    $0x1,%rdx
  1002c6:	84 c9                	test   %cl,%cl
  1002c8:	75 f1                	jne    1002bb <strcpy+0xc>
}
  1002ca:	c3                   	ret    

00000000001002cb <strcmp>:
int strcmp(const char* a, const char* b) {
  1002cb:	f3 0f 1e fa          	endbr64 
    while (*a && *b && *a == *b) {
  1002cf:	0f b6 07             	movzbl (%rdi),%eax
  1002d2:	84 c0                	test   %al,%al
  1002d4:	74 1a                	je     1002f0 <strcmp+0x25>
  1002d6:	0f b6 16             	movzbl (%rsi),%edx
  1002d9:	38 c2                	cmp    %al,%dl
  1002db:	75 13                	jne    1002f0 <strcmp+0x25>
  1002dd:	84 d2                	test   %dl,%dl
  1002df:	74 0f                	je     1002f0 <strcmp+0x25>
        ++a, ++b;
  1002e1:	48 83 c7 01          	add    $0x1,%rdi
  1002e5:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1002e9:	0f b6 07             	movzbl (%rdi),%eax
  1002ec:	84 c0                	test   %al,%al
  1002ee:	75 e6                	jne    1002d6 <strcmp+0xb>
    return ((unsigned char) *a > (unsigned char) *b)
  1002f0:	3a 06                	cmp    (%rsi),%al
  1002f2:	0f 97 c0             	seta   %al
  1002f5:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1002f8:	83 d8 00             	sbb    $0x0,%eax
}
  1002fb:	c3                   	ret    

00000000001002fc <strchr>:
char* strchr(const char* s, int c) {
  1002fc:	f3 0f 1e fa          	endbr64 
    while (*s && *s != (char) c) {
  100300:	0f b6 07             	movzbl (%rdi),%eax
  100303:	84 c0                	test   %al,%al
  100305:	74 10                	je     100317 <strchr+0x1b>
  100307:	40 38 f0             	cmp    %sil,%al
  10030a:	74 18                	je     100324 <strchr+0x28>
        ++s;
  10030c:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  100310:	0f b6 07             	movzbl (%rdi),%eax
  100313:	84 c0                	test   %al,%al
  100315:	75 f0                	jne    100307 <strchr+0xb>
        return NULL;
  100317:	40 84 f6             	test   %sil,%sil
  10031a:	b8 00 00 00 00       	mov    $0x0,%eax
  10031f:	48 0f 44 c7          	cmove  %rdi,%rax
}
  100323:	c3                   	ret    
  100324:	48 89 f8             	mov    %rdi,%rax
  100327:	c3                   	ret    

0000000000100328 <rand>:
int rand(void) {
  100328:	f3 0f 1e fa          	endbr64 
    if (!rand_seed_set) {
  10032c:	83 3d e1 0c 00 00 00 	cmpl   $0x0,0xce1(%rip)        # 101014 <rand_seed_set>
  100333:	74 1b                	je     100350 <rand+0x28>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  100335:	69 05 d1 0c 00 00 0d 	imul   $0x19660d,0xcd1(%rip),%eax        # 101010 <rand_seed>
  10033c:	66 19 00 
  10033f:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  100344:	89 05 c6 0c 00 00    	mov    %eax,0xcc6(%rip)        # 101010 <rand_seed>
    return rand_seed & RAND_MAX;
  10034a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  10034f:	c3                   	ret    
    rand_seed = seed;
  100350:	c7 05 b6 0c 00 00 9e 	movl   $0x30d4879e,0xcb6(%rip)        # 101010 <rand_seed>
  100357:	87 d4 30 
    rand_seed_set = 1;
  10035a:	c7 05 b0 0c 00 00 01 	movl   $0x1,0xcb0(%rip)        # 101014 <rand_seed_set>
  100361:	00 00 00 
}
  100364:	eb cf                	jmp    100335 <rand+0xd>

0000000000100366 <srand>:
void srand(unsigned seed) {
  100366:	f3 0f 1e fa          	endbr64 
    rand_seed = seed;
  10036a:	89 3d a0 0c 00 00    	mov    %edi,0xca0(%rip)        # 101010 <rand_seed>
    rand_seed_set = 1;
  100370:	c7 05 9a 0c 00 00 01 	movl   $0x1,0xc9a(%rip)        # 101014 <rand_seed_set>
  100377:	00 00 00 
}
  10037a:	c3                   	ret    

000000000010037b <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  10037b:	f3 0f 1e fa          	endbr64 
  10037f:	55                   	push   %rbp
  100380:	48 89 e5             	mov    %rsp,%rbp
  100383:	41 57                	push   %r15
  100385:	41 56                	push   %r14
  100387:	41 55                	push   %r13
  100389:	41 54                	push   %r12
  10038b:	53                   	push   %rbx
  10038c:	48 83 ec 58          	sub    $0x58,%rsp
  100390:	49 89 fe             	mov    %rdi,%r14
  100393:	89 75 ac             	mov    %esi,-0x54(%rbp)
  100396:	49 89 d4             	mov    %rdx,%r12
  100399:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  10039d:	0f b6 02             	movzbl (%rdx),%eax
  1003a0:	84 c0                	test   %al,%al
  1003a2:	0f 85 cd 04 00 00    	jne    100875 <printer_vprintf+0x4fa>
}
  1003a8:	48 83 c4 58          	add    $0x58,%rsp
  1003ac:	5b                   	pop    %rbx
  1003ad:	41 5c                	pop    %r12
  1003af:	41 5d                	pop    %r13
  1003b1:	41 5e                	pop    %r14
  1003b3:	41 5f                	pop    %r15
  1003b5:	5d                   	pop    %rbp
  1003b6:	c3                   	ret    
        for (++format; *format; ++format) {
  1003b7:	4d 8d 7c 24 01       	lea    0x1(%r12),%r15
  1003bc:	41 0f b6 5c 24 01    	movzbl 0x1(%r12),%ebx
  1003c2:	84 db                	test   %bl,%bl
  1003c4:	0f 84 a4 06 00 00    	je     100a6e <printer_vprintf+0x6f3>
        int flags = 0;
  1003ca:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1003d0:	4c 8d 25 fa 0a 00 00 	lea    0xafa(%rip),%r12        # 100ed1 <flag_chars>
  1003d7:	0f be f3             	movsbl %bl,%esi
  1003da:	4c 89 e7             	mov    %r12,%rdi
  1003dd:	e8 1a ff ff ff       	call   1002fc <strchr>
  1003e2:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1003e5:	48 85 c0             	test   %rax,%rax
  1003e8:	74 5c                	je     100446 <printer_vprintf+0xcb>
                flags |= 1 << (flagc - flag_chars);
  1003ea:	4c 29 e1             	sub    %r12,%rcx
  1003ed:	b8 01 00 00 00       	mov    $0x1,%eax
  1003f2:	d3 e0                	shl    %cl,%eax
  1003f4:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1003f7:	49 83 c7 01          	add    $0x1,%r15
  1003fb:	41 0f b6 1f          	movzbl (%r15),%ebx
  1003ff:	84 db                	test   %bl,%bl
  100401:	75 d4                	jne    1003d7 <printer_vprintf+0x5c>
  100403:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
        int width = -1;
  100407:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  10040d:	c7 45 a8 ff ff ff ff 	movl   $0xffffffff,-0x58(%rbp)
        if (*format == '.') {
  100414:	41 80 3f 2e          	cmpb   $0x2e,(%r15)
  100418:	0f 84 b3 00 00 00    	je     1004d1 <printer_vprintf+0x156>
        int length = 0;
  10041e:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  100423:	41 0f b6 17          	movzbl (%r15),%edx
  100427:	8d 42 bd             	lea    -0x43(%rdx),%eax
  10042a:	3c 37                	cmp    $0x37,%al
  10042c:	0f 87 e0 04 00 00    	ja     100912 <printer_vprintf+0x597>
  100432:	0f b6 c0             	movzbl %al,%eax
  100435:	48 8d 3d 84 09 00 00 	lea    0x984(%rip),%rdi        # 100dc0 <assert_fail+0x98>
  10043c:	48 63 04 87          	movslq (%rdi,%rax,4),%rax
  100440:	48 01 f8             	add    %rdi,%rax
  100443:	3e ff e0             	notrack jmp *%rax
        if (*format >= '1' && *format <= '9') {
  100446:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  10044a:	8d 43 cf             	lea    -0x31(%rbx),%eax
  10044d:	3c 08                	cmp    $0x8,%al
  10044f:	77 31                	ja     100482 <printer_vprintf+0x107>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100451:	41 0f b6 07          	movzbl (%r15),%eax
  100455:	8d 50 d0             	lea    -0x30(%rax),%edx
  100458:	80 fa 09             	cmp    $0x9,%dl
  10045b:	77 5e                	ja     1004bb <printer_vprintf+0x140>
  10045d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  100463:	49 83 c7 01          	add    $0x1,%r15
  100467:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  10046c:	0f be c0             	movsbl %al,%eax
  10046f:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100474:	41 0f b6 07          	movzbl (%r15),%eax
  100478:	8d 50 d0             	lea    -0x30(%rax),%edx
  10047b:	80 fa 09             	cmp    $0x9,%dl
  10047e:	76 e3                	jbe    100463 <printer_vprintf+0xe8>
  100480:	eb 8b                	jmp    10040d <printer_vprintf+0x92>
        } else if (*format == '*') {
  100482:	80 fb 2a             	cmp    $0x2a,%bl
  100485:	75 3f                	jne    1004c6 <printer_vprintf+0x14b>
            width = va_arg(val, int);
  100487:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10048b:	8b 07                	mov    (%rdi),%eax
  10048d:	83 f8 2f             	cmp    $0x2f,%eax
  100490:	77 17                	ja     1004a9 <printer_vprintf+0x12e>
  100492:	89 c2                	mov    %eax,%edx
  100494:	48 03 57 10          	add    0x10(%rdi),%rdx
  100498:	83 c0 08             	add    $0x8,%eax
  10049b:	89 07                	mov    %eax,(%rdi)
  10049d:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1004a0:	49 83 c7 01          	add    $0x1,%r15
  1004a4:	e9 64 ff ff ff       	jmp    10040d <printer_vprintf+0x92>
            width = va_arg(val, int);
  1004a9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004ad:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004b1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004b5:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1004b9:	eb e2                	jmp    10049d <printer_vprintf+0x122>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1004bb:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1004c1:	e9 47 ff ff ff       	jmp    10040d <printer_vprintf+0x92>
        int width = -1;
  1004c6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1004cc:	e9 3c ff ff ff       	jmp    10040d <printer_vprintf+0x92>
            ++format;
  1004d1:	49 8d 57 01          	lea    0x1(%r15),%rdx
            if (*format >= '0' && *format <= '9') {
  1004d5:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  1004da:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1004dd:	80 f9 09             	cmp    $0x9,%cl
  1004e0:	76 13                	jbe    1004f5 <printer_vprintf+0x17a>
            } else if (*format == '*') {
  1004e2:	3c 2a                	cmp    $0x2a,%al
  1004e4:	74 33                	je     100519 <printer_vprintf+0x19e>
            ++format;
  1004e6:	49 89 d7             	mov    %rdx,%r15
                precision = 0;
  1004e9:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  1004f0:	e9 29 ff ff ff       	jmp    10041e <printer_vprintf+0xa3>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1004f5:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  1004fa:	48 83 c2 01          	add    $0x1,%rdx
  1004fe:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  100501:	0f be c0             	movsbl %al,%eax
  100504:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100508:	0f b6 02             	movzbl (%rdx),%eax
  10050b:	8d 70 d0             	lea    -0x30(%rax),%esi
  10050e:	40 80 fe 09          	cmp    $0x9,%sil
  100512:	76 e6                	jbe    1004fa <printer_vprintf+0x17f>
                    precision = 10 * precision + *format++ - '0';
  100514:	49 89 d7             	mov    %rdx,%r15
  100517:	eb 1c                	jmp    100535 <printer_vprintf+0x1ba>
                precision = va_arg(val, int);
  100519:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10051d:	8b 01                	mov    (%rcx),%eax
  10051f:	83 f8 2f             	cmp    $0x2f,%eax
  100522:	77 23                	ja     100547 <printer_vprintf+0x1cc>
  100524:	89 c2                	mov    %eax,%edx
  100526:	48 03 51 10          	add    0x10(%rcx),%rdx
  10052a:	83 c0 08             	add    $0x8,%eax
  10052d:	89 01                	mov    %eax,(%rcx)
  10052f:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  100531:	49 83 c7 02          	add    $0x2,%r15
            if (precision < 0) {
  100535:	85 c9                	test   %ecx,%ecx
  100537:	b8 00 00 00 00       	mov    $0x0,%eax
  10053c:	0f 49 c1             	cmovns %ecx,%eax
  10053f:	89 45 a8             	mov    %eax,-0x58(%rbp)
  100542:	e9 d7 fe ff ff       	jmp    10041e <printer_vprintf+0xa3>
                precision = va_arg(val, int);
  100547:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10054b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10054f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100553:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100557:	eb d6                	jmp    10052f <printer_vprintf+0x1b4>
        switch (*format) {
  100559:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  10055e:	e9 f6 00 00 00       	jmp    100659 <printer_vprintf+0x2de>
            ++format;
  100563:	49 83 c7 01          	add    $0x1,%r15
            length = 1;
  100567:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  10056c:	e9 b2 fe ff ff       	jmp    100423 <printer_vprintf+0xa8>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100571:	85 c9                	test   %ecx,%ecx
  100573:	74 56                	je     1005cb <printer_vprintf+0x250>
  100575:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100579:	8b 07                	mov    (%rdi),%eax
  10057b:	83 f8 2f             	cmp    $0x2f,%eax
  10057e:	77 39                	ja     1005b9 <printer_vprintf+0x23e>
  100580:	89 c2                	mov    %eax,%edx
  100582:	48 03 57 10          	add    0x10(%rdi),%rdx
  100586:	83 c0 08             	add    $0x8,%eax
  100589:	89 07                	mov    %eax,(%rdi)
  10058b:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  10058e:	48 89 d0             	mov    %rdx,%rax
  100591:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  100595:	49 89 d0             	mov    %rdx,%r8
  100598:	49 f7 d8             	neg    %r8
  10059b:	25 80 00 00 00       	and    $0x80,%eax
  1005a0:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1005a4:	0b 45 a0             	or     -0x60(%rbp),%eax
  1005a7:	83 c8 60             	or     $0x60,%eax
  1005aa:	89 45 a0             	mov    %eax,-0x60(%rbp)
        char* data = "";
  1005ad:	4c 8d 25 2c 09 00 00 	lea    0x92c(%rip),%r12        # 100ee0 <flag_chars+0xf>
            break;
  1005b4:	e9 39 01 00 00       	jmp    1006f2 <printer_vprintf+0x377>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1005b9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005bd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005c1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005c5:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005c9:	eb c0                	jmp    10058b <printer_vprintf+0x210>
  1005cb:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005cf:	8b 01                	mov    (%rcx),%eax
  1005d1:	83 f8 2f             	cmp    $0x2f,%eax
  1005d4:	77 10                	ja     1005e6 <printer_vprintf+0x26b>
  1005d6:	89 c2                	mov    %eax,%edx
  1005d8:	48 03 51 10          	add    0x10(%rcx),%rdx
  1005dc:	83 c0 08             	add    $0x8,%eax
  1005df:	89 01                	mov    %eax,(%rcx)
  1005e1:	48 63 12             	movslq (%rdx),%rdx
  1005e4:	eb a8                	jmp    10058e <printer_vprintf+0x213>
  1005e6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005ea:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005ee:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005f2:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005f6:	eb e9                	jmp    1005e1 <printer_vprintf+0x266>
        int base = 10;
  1005f8:	be 0a 00 00 00       	mov    $0xa,%esi
  1005fd:	eb 5a                	jmp    100659 <printer_vprintf+0x2de>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1005ff:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100603:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100607:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10060b:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10060f:	eb 62                	jmp    100673 <printer_vprintf+0x2f8>
  100611:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100615:	8b 07                	mov    (%rdi),%eax
  100617:	83 f8 2f             	cmp    $0x2f,%eax
  10061a:	77 10                	ja     10062c <printer_vprintf+0x2b1>
  10061c:	89 c2                	mov    %eax,%edx
  10061e:	48 03 57 10          	add    0x10(%rdi),%rdx
  100622:	83 c0 08             	add    $0x8,%eax
  100625:	89 07                	mov    %eax,(%rdi)
  100627:	44 8b 02             	mov    (%rdx),%r8d
  10062a:	eb 4a                	jmp    100676 <printer_vprintf+0x2fb>
  10062c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100630:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100634:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100638:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10063c:	eb e9                	jmp    100627 <printer_vprintf+0x2ac>
  10063e:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  100641:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
    const char* digits = upper_digits;
  100648:	48 8d 3d 71 08 00 00 	lea    0x871(%rip),%rdi        # 100ec0 <upper_digits.1>
  10064f:	e9 f3 02 00 00       	jmp    100947 <printer_vprintf+0x5cc>
            base = 16;
  100654:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100659:	85 c9                	test   %ecx,%ecx
  10065b:	74 b4                	je     100611 <printer_vprintf+0x296>
  10065d:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100661:	8b 01                	mov    (%rcx),%eax
  100663:	83 f8 2f             	cmp    $0x2f,%eax
  100666:	77 97                	ja     1005ff <printer_vprintf+0x284>
  100668:	89 c2                	mov    %eax,%edx
  10066a:	48 03 51 10          	add    0x10(%rcx),%rdx
  10066e:	83 c0 08             	add    $0x8,%eax
  100671:	89 01                	mov    %eax,(%rcx)
  100673:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100676:	83 4d a0 20          	orl    $0x20,-0x60(%rbp)
    if (base < 0) {
  10067a:	85 f6                	test   %esi,%esi
  10067c:	79 c0                	jns    10063e <printer_vprintf+0x2c3>
        base = -base;
  10067e:	41 89 f1             	mov    %esi,%r9d
  100681:	f7 de                	neg    %esi
  100683:	c7 45 98 20 00 00 00 	movl   $0x20,-0x68(%rbp)
        digits = lower_digits;
  10068a:	48 8d 3d 0f 08 00 00 	lea    0x80f(%rip),%rdi        # 100ea0 <lower_digits.0>
  100691:	e9 b1 02 00 00       	jmp    100947 <printer_vprintf+0x5cc>
            num = (uintptr_t) va_arg(val, void*);
  100696:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10069a:	8b 01                	mov    (%rcx),%eax
  10069c:	83 f8 2f             	cmp    $0x2f,%eax
  10069f:	77 1c                	ja     1006bd <printer_vprintf+0x342>
  1006a1:	89 c2                	mov    %eax,%edx
  1006a3:	48 03 51 10          	add    0x10(%rcx),%rdx
  1006a7:	83 c0 08             	add    $0x8,%eax
  1006aa:	89 01                	mov    %eax,(%rcx)
  1006ac:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1006af:	81 4d a0 21 01 00 00 	orl    $0x121,-0x60(%rbp)
            base = -16;
  1006b6:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1006bb:	eb c1                	jmp    10067e <printer_vprintf+0x303>
            num = (uintptr_t) va_arg(val, void*);
  1006bd:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1006c1:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1006c5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1006c9:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1006cd:	eb dd                	jmp    1006ac <printer_vprintf+0x331>
            data = va_arg(val, char*);
  1006cf:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1006d3:	8b 07                	mov    (%rdi),%eax
  1006d5:	83 f8 2f             	cmp    $0x2f,%eax
  1006d8:	0f 87 b0 01 00 00    	ja     10088e <printer_vprintf+0x513>
  1006de:	89 c2                	mov    %eax,%edx
  1006e0:	48 03 57 10          	add    0x10(%rdi),%rdx
  1006e4:	83 c0 08             	add    $0x8,%eax
  1006e7:	89 07                	mov    %eax,(%rdi)
  1006e9:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1006ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  1006f2:	8b 45 a0             	mov    -0x60(%rbp),%eax
  1006f5:	83 e0 20             	and    $0x20,%eax
  1006f8:	89 45 98             	mov    %eax,-0x68(%rbp)
  1006fb:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  100701:	0f 85 2e 02 00 00    	jne    100935 <printer_vprintf+0x5ba>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100707:	8b 45 a0             	mov    -0x60(%rbp),%eax
  10070a:	89 45 8c             	mov    %eax,-0x74(%rbp)
  10070d:	83 e0 60             	and    $0x60,%eax
  100710:	83 f8 60             	cmp    $0x60,%eax
  100713:	0f 84 63 02 00 00    	je     10097c <printer_vprintf+0x601>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100719:	8b 45 a0             	mov    -0x60(%rbp),%eax
  10071c:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  10071f:	48 8d 1d ba 07 00 00 	lea    0x7ba(%rip),%rbx        # 100ee0 <flag_chars+0xf>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100726:	83 f8 21             	cmp    $0x21,%eax
  100729:	0f 84 8a 02 00 00    	je     1009b9 <printer_vprintf+0x63e>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  10072f:	8b 7d a8             	mov    -0x58(%rbp),%edi
  100732:	89 f8                	mov    %edi,%eax
  100734:	f7 d0                	not    %eax
  100736:	c1 e8 1f             	shr    $0x1f,%eax
  100739:	89 45 88             	mov    %eax,-0x78(%rbp)
  10073c:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  100740:	0f 85 b2 02 00 00    	jne    1009f8 <printer_vprintf+0x67d>
  100746:	84 c0                	test   %al,%al
  100748:	0f 84 aa 02 00 00    	je     1009f8 <printer_vprintf+0x67d>
            len = strnlen(data, precision);
  10074e:	48 63 f7             	movslq %edi,%rsi
  100751:	4c 89 e7             	mov    %r12,%rdi
  100754:	e8 2f fb ff ff       	call   100288 <strnlen>
  100759:	89 45 9c             	mov    %eax,-0x64(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  10075c:	8b 45 8c             	mov    -0x74(%rbp),%eax
  10075f:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  100762:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100769:	83 f8 22             	cmp    $0x22,%eax
  10076c:	0f 84 be 02 00 00    	je     100a30 <printer_vprintf+0x6b5>
        width -= len + zeros + strlen(prefix);
  100772:	48 89 df             	mov    %rbx,%rdi
  100775:	e8 ef fa ff ff       	call   100269 <strlen>
  10077a:	8b 55 a8             	mov    -0x58(%rbp),%edx
  10077d:	03 55 9c             	add    -0x64(%rbp),%edx
  100780:	44 89 e9             	mov    %r13d,%ecx
  100783:	29 d1                	sub    %edx,%ecx
  100785:	29 c1                	sub    %eax,%ecx
  100787:	89 4d 98             	mov    %ecx,-0x68(%rbp)
  10078a:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  10078d:	f6 45 a0 04          	testb  $0x4,-0x60(%rbp)
  100791:	75 37                	jne    1007ca <printer_vprintf+0x44f>
  100793:	85 c9                	test   %ecx,%ecx
  100795:	7e 33                	jle    1007ca <printer_vprintf+0x44f>
        width -= len + zeros + strlen(prefix);
  100797:	48 89 5d a0          	mov    %rbx,-0x60(%rbp)
  10079b:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  10079e:	89 da                	mov    %ebx,%edx
  1007a0:	be 20 00 00 00       	mov    $0x20,%esi
  1007a5:	4c 89 f7             	mov    %r14,%rdi
  1007a8:	41 ff 16             	call   *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1007ab:	41 83 ed 01          	sub    $0x1,%r13d
  1007af:	45 85 ed             	test   %r13d,%r13d
  1007b2:	7f ea                	jg     10079e <printer_vprintf+0x423>
  1007b4:	48 8b 5d a0          	mov    -0x60(%rbp),%rbx
  1007b8:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1007bb:	85 ff                	test   %edi,%edi
  1007bd:	b8 01 00 00 00       	mov    $0x1,%eax
  1007c2:	0f 4f c7             	cmovg  %edi,%eax
  1007c5:	29 c7                	sub    %eax,%edi
  1007c7:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1007ca:	0f b6 03             	movzbl (%rbx),%eax
  1007cd:	84 c0                	test   %al,%al
  1007cf:	74 23                	je     1007f4 <printer_vprintf+0x479>
  1007d1:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  1007d5:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, *prefix, color);
  1007d9:	0f b6 f0             	movzbl %al,%esi
  1007dc:	44 89 e2             	mov    %r12d,%edx
  1007df:	4c 89 f7             	mov    %r14,%rdi
  1007e2:	41 ff 16             	call   *(%r14)
        for (; *prefix; ++prefix) {
  1007e5:	48 83 c3 01          	add    $0x1,%rbx
  1007e9:	0f b6 03             	movzbl (%rbx),%eax
  1007ec:	84 c0                	test   %al,%al
  1007ee:	75 e9                	jne    1007d9 <printer_vprintf+0x45e>
  1007f0:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; zeros > 0; --zeros) {
  1007f4:	8b 5d a8             	mov    -0x58(%rbp),%ebx
  1007f7:	85 db                	test   %ebx,%ebx
  1007f9:	7e 1f                	jle    10081a <printer_vprintf+0x49f>
  1007fb:	4c 89 65 a0          	mov    %r12,-0x60(%rbp)
  1007ff:	44 8b 65 ac          	mov    -0x54(%rbp),%r12d
            p->putc(p, '0', color);
  100803:	44 89 e2             	mov    %r12d,%edx
  100806:	be 30 00 00 00       	mov    $0x30,%esi
  10080b:	4c 89 f7             	mov    %r14,%rdi
  10080e:	41 ff 16             	call   *(%r14)
        for (; zeros > 0; --zeros) {
  100811:	83 eb 01             	sub    $0x1,%ebx
  100814:	75 ed                	jne    100803 <printer_vprintf+0x488>
  100816:	4c 8b 65 a0          	mov    -0x60(%rbp),%r12
        for (; len > 0; ++data, --len) {
  10081a:	8b 45 9c             	mov    -0x64(%rbp),%eax
  10081d:	85 c0                	test   %eax,%eax
  10081f:	7e 28                	jle    100849 <printer_vprintf+0x4ce>
  100821:	89 c3                	mov    %eax,%ebx
  100823:	4c 01 e3             	add    %r12,%rbx
  100826:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  10082a:	44 8b 6d ac          	mov    -0x54(%rbp),%r13d
            p->putc(p, *data, color);
  10082e:	41 0f b6 34 24       	movzbl (%r12),%esi
  100833:	44 89 ea             	mov    %r13d,%edx
  100836:	4c 89 f7             	mov    %r14,%rdi
  100839:	41 ff 16             	call   *(%r14)
        for (; len > 0; ++data, --len) {
  10083c:	49 83 c4 01          	add    $0x1,%r12
  100840:	49 39 dc             	cmp    %rbx,%r12
  100843:	75 e9                	jne    10082e <printer_vprintf+0x4b3>
  100845:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
        for (; width > 0; --width) {
  100849:	45 85 ed             	test   %r13d,%r13d
  10084c:	7e 16                	jle    100864 <printer_vprintf+0x4e9>
  10084e:	8b 5d ac             	mov    -0x54(%rbp),%ebx
            p->putc(p, ' ', color);
  100851:	89 da                	mov    %ebx,%edx
  100853:	be 20 00 00 00       	mov    $0x20,%esi
  100858:	4c 89 f7             	mov    %r14,%rdi
  10085b:	41 ff 16             	call   *(%r14)
        for (; width > 0; --width) {
  10085e:	41 83 ed 01          	sub    $0x1,%r13d
  100862:	75 ed                	jne    100851 <printer_vprintf+0x4d6>
    for (; *format; ++format) {
  100864:	4d 8d 67 01          	lea    0x1(%r15),%r12
  100868:	41 0f b6 47 01       	movzbl 0x1(%r15),%eax
  10086d:	84 c0                	test   %al,%al
  10086f:	0f 84 33 fb ff ff    	je     1003a8 <printer_vprintf+0x2d>
        if (*format != '%') {
  100875:	3c 25                	cmp    $0x25,%al
  100877:	0f 84 3a fb ff ff    	je     1003b7 <printer_vprintf+0x3c>
            p->putc(p, *format, color);
  10087d:	0f b6 f0             	movzbl %al,%esi
  100880:	8b 55 ac             	mov    -0x54(%rbp),%edx
  100883:	4c 89 f7             	mov    %r14,%rdi
  100886:	41 ff 16             	call   *(%r14)
            continue;
  100889:	4d 89 e7             	mov    %r12,%r15
  10088c:	eb d6                	jmp    100864 <printer_vprintf+0x4e9>
            data = va_arg(val, char*);
  10088e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100892:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100896:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10089a:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10089e:	e9 46 fe ff ff       	jmp    1006e9 <printer_vprintf+0x36e>
            color = va_arg(val, int);
  1008a3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1008a7:	8b 01                	mov    (%rcx),%eax
  1008a9:	83 f8 2f             	cmp    $0x2f,%eax
  1008ac:	77 12                	ja     1008c0 <printer_vprintf+0x545>
  1008ae:	89 c2                	mov    %eax,%edx
  1008b0:	48 03 51 10          	add    0x10(%rcx),%rdx
  1008b4:	83 c0 08             	add    $0x8,%eax
  1008b7:	89 01                	mov    %eax,(%rcx)
  1008b9:	8b 02                	mov    (%rdx),%eax
  1008bb:	89 45 ac             	mov    %eax,-0x54(%rbp)
            goto done;
  1008be:	eb a4                	jmp    100864 <printer_vprintf+0x4e9>
            color = va_arg(val, int);
  1008c0:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1008c4:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1008c8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1008cc:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1008d0:	eb e7                	jmp    1008b9 <printer_vprintf+0x53e>
            numbuf[0] = va_arg(val, int);
  1008d2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1008d6:	8b 07                	mov    (%rdi),%eax
  1008d8:	83 f8 2f             	cmp    $0x2f,%eax
  1008db:	77 23                	ja     100900 <printer_vprintf+0x585>
  1008dd:	89 c2                	mov    %eax,%edx
  1008df:	48 03 57 10          	add    0x10(%rdi),%rdx
  1008e3:	83 c0 08             	add    $0x8,%eax
  1008e6:	89 07                	mov    %eax,(%rdi)
  1008e8:	8b 02                	mov    (%rdx),%eax
  1008ea:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1008ed:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1008f1:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1008f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1008fb:	e9 f2 fd ff ff       	jmp    1006f2 <printer_vprintf+0x377>
            numbuf[0] = va_arg(val, int);
  100900:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100904:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100908:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10090c:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100910:	eb d6                	jmp    1008e8 <printer_vprintf+0x56d>
            numbuf[0] = (*format ? *format : '%');
  100912:	84 d2                	test   %dl,%dl
  100914:	0f 85 3e 01 00 00    	jne    100a58 <printer_vprintf+0x6dd>
  10091a:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  10091e:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  100922:	49 83 ef 01          	sub    $0x1,%r15
            data = numbuf;
  100926:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  10092a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100930:	e9 bd fd ff ff       	jmp    1006f2 <printer_vprintf+0x377>
        if (flags & FLAG_NUMERIC) {
  100935:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  10093b:	48 8d 3d 7e 05 00 00 	lea    0x57e(%rip),%rdi        # 100ec0 <upper_digits.1>
        if (flags & FLAG_NUMERIC) {
  100942:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  100947:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  10094b:	4c 89 c1             	mov    %r8,%rcx
  10094e:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  100952:	48 63 f6             	movslq %esi,%rsi
  100955:	49 83 ec 01          	sub    $0x1,%r12
  100959:	48 89 c8             	mov    %rcx,%rax
  10095c:	ba 00 00 00 00       	mov    $0x0,%edx
  100961:	48 f7 f6             	div    %rsi
  100964:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  100968:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  10096c:	48 89 ca             	mov    %rcx,%rdx
  10096f:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  100972:	48 39 d6             	cmp    %rdx,%rsi
  100975:	76 de                	jbe    100955 <printer_vprintf+0x5da>
  100977:	e9 8b fd ff ff       	jmp    100707 <printer_vprintf+0x38c>
                prefix = "-";
  10097c:	48 8d 1d 31 04 00 00 	lea    0x431(%rip),%rbx        # 100db4 <assert_fail+0x8c>
            if (flags & FLAG_NEGATIVE) {
  100983:	8b 45 a0             	mov    -0x60(%rbp),%eax
  100986:	a8 80                	test   $0x80,%al
  100988:	0f 85 a1 fd ff ff    	jne    10072f <printer_vprintf+0x3b4>
                prefix = "+";
  10098e:	48 8d 1d 1a 04 00 00 	lea    0x41a(%rip),%rbx        # 100daf <assert_fail+0x87>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100995:	a8 10                	test   $0x10,%al
  100997:	0f 85 92 fd ff ff    	jne    10072f <printer_vprintf+0x3b4>
                prefix = " ";
  10099d:	a8 08                	test   $0x8,%al
  10099f:	48 8d 15 3a 05 00 00 	lea    0x53a(%rip),%rdx        # 100ee0 <flag_chars+0xf>
  1009a6:	48 8d 05 30 05 00 00 	lea    0x530(%rip),%rax        # 100edd <flag_chars+0xc>
  1009ad:	48 0f 44 c2          	cmove  %rdx,%rax
  1009b1:	48 89 c3             	mov    %rax,%rbx
  1009b4:	e9 76 fd ff ff       	jmp    10072f <printer_vprintf+0x3b4>
                   && (base == 16 || base == -16)
  1009b9:	41 8d 41 10          	lea    0x10(%r9),%eax
  1009bd:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1009c2:	0f 85 67 fd ff ff    	jne    10072f <printer_vprintf+0x3b4>
                   && (num || (flags & FLAG_ALT2))) {
  1009c8:	4d 85 c0             	test   %r8,%r8
  1009cb:	75 0d                	jne    1009da <printer_vprintf+0x65f>
  1009cd:	f7 45 a0 00 01 00 00 	testl  $0x100,-0x60(%rbp)
  1009d4:	0f 84 55 fd ff ff    	je     10072f <printer_vprintf+0x3b4>
            prefix = (base == -16 ? "0x" : "0X");
  1009da:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1009de:	48 8d 15 d1 03 00 00 	lea    0x3d1(%rip),%rdx        # 100db6 <assert_fail+0x8e>
  1009e5:	48 8d 05 c5 03 00 00 	lea    0x3c5(%rip),%rax        # 100db1 <assert_fail+0x89>
  1009ec:	48 0f 44 c2          	cmove  %rdx,%rax
  1009f0:	48 89 c3             	mov    %rax,%rbx
  1009f3:	e9 37 fd ff ff       	jmp    10072f <printer_vprintf+0x3b4>
            len = strlen(data);
  1009f8:	4c 89 e7             	mov    %r12,%rdi
  1009fb:	e8 69 f8 ff ff       	call   100269 <strlen>
  100a00:	89 45 9c             	mov    %eax,-0x64(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100a03:	83 7d 98 00          	cmpl   $0x0,-0x68(%rbp)
  100a07:	0f 84 4f fd ff ff    	je     10075c <printer_vprintf+0x3e1>
  100a0d:	80 7d 88 00          	cmpb   $0x0,-0x78(%rbp)
  100a11:	0f 84 45 fd ff ff    	je     10075c <printer_vprintf+0x3e1>
            zeros = precision > len ? precision - len : 0;
  100a17:	8b 4d a8             	mov    -0x58(%rbp),%ecx
  100a1a:	89 ca                	mov    %ecx,%edx
  100a1c:	29 c2                	sub    %eax,%edx
  100a1e:	39 c1                	cmp    %eax,%ecx
  100a20:	b8 00 00 00 00       	mov    $0x0,%eax
  100a25:	0f 4f c2             	cmovg  %edx,%eax
  100a28:	89 45 a8             	mov    %eax,-0x58(%rbp)
  100a2b:	e9 42 fd ff ff       	jmp    100772 <printer_vprintf+0x3f7>
                   && len + (int) strlen(prefix) < width) {
  100a30:	48 89 df             	mov    %rbx,%rdi
  100a33:	e8 31 f8 ff ff       	call   100269 <strlen>
  100a38:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  100a3b:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  100a3e:	44 89 e9             	mov    %r13d,%ecx
  100a41:	29 f9                	sub    %edi,%ecx
  100a43:	29 c1                	sub    %eax,%ecx
  100a45:	44 39 ea             	cmp    %r13d,%edx
  100a48:	b8 00 00 00 00       	mov    $0x0,%eax
  100a4d:	0f 4c c1             	cmovl  %ecx,%eax
  100a50:	89 45 a8             	mov    %eax,-0x58(%rbp)
  100a53:	e9 1a fd ff ff       	jmp    100772 <printer_vprintf+0x3f7>
            numbuf[0] = (*format ? *format : '%');
  100a58:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  100a5b:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100a5f:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100a63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100a69:	e9 84 fc ff ff       	jmp    1006f2 <printer_vprintf+0x377>
        int flags = 0;
  100a6e:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%rbp)
  100a75:	e9 8d f9 ff ff       	jmp    100407 <printer_vprintf+0x8c>

0000000000100a7a <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100a7a:	f3 0f 1e fa          	endbr64 
  100a7e:	55                   	push   %rbp
  100a7f:	48 89 e5             	mov    %rsp,%rbp
  100a82:	53                   	push   %rbx
  100a83:	48 83 ec 18          	sub    $0x18,%rsp
    cp.p.putc = console_putc;
  100a87:	48 8d 05 9e f6 ff ff 	lea    -0x962(%rip),%rax        # 10012c <console_putc>
  100a8e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        cpos = 0;
  100a92:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  100a98:	b8 00 00 00 00       	mov    $0x0,%eax
  100a9d:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100aa0:	48 63 ff             	movslq %edi,%rdi
  100aa3:	48 8d 1d 56 75 fb ff 	lea    -0x48aaa(%rip),%rbx        # b8000 <console>
  100aaa:	48 8d 04 7b          	lea    (%rbx,%rdi,2),%rax
  100aae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100ab2:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  100ab6:	e8 c0 f8 ff ff       	call   10037b <printer_vprintf>
    return cp.cursor - console;
  100abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100abf:	48 29 d8             	sub    %rbx,%rax
  100ac2:	48 d1 f8             	sar    %rax
}
  100ac5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100ac9:	c9                   	leave  
  100aca:	c3                   	ret    

0000000000100acb <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  100acb:	f3 0f 1e fa          	endbr64 
  100acf:	55                   	push   %rbp
  100ad0:	48 89 e5             	mov    %rsp,%rbp
  100ad3:	48 83 ec 50          	sub    $0x50,%rsp
  100ad7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100adb:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100adf:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  100ae3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100aea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100aee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100af2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100af6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100afa:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100afe:	e8 77 ff ff ff       	call   100a7a <console_vprintf>
}
  100b03:	c9                   	leave  
  100b04:	c3                   	ret    

0000000000100b05 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100b05:	f3 0f 1e fa          	endbr64 
  100b09:	55                   	push   %rbp
  100b0a:	48 89 e5             	mov    %rsp,%rbp
  100b0d:	53                   	push   %rbx
  100b0e:	48 83 ec 28          	sub    $0x28,%rsp
  100b12:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100b15:	48 8d 05 a3 f6 ff ff 	lea    -0x95d(%rip),%rax        # 1001bf <string_putc>
  100b1c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    sp.s = s;
  100b20:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100b24:	48 85 f6             	test   %rsi,%rsi
  100b27:	75 0b                	jne    100b34 <vsnprintf+0x2f>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100b29:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100b2c:	29 d8                	sub    %ebx,%eax
}
  100b2e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100b32:	c9                   	leave  
  100b33:	c3                   	ret    
        sp.end = s + size - 1;
  100b34:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100b39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100b3d:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100b41:	be 00 00 00 00       	mov    $0x0,%esi
  100b46:	e8 30 f8 ff ff       	call   10037b <printer_vprintf>
        *sp.s = 0;
  100b4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100b4f:	c6 00 00             	movb   $0x0,(%rax)
  100b52:	eb d5                	jmp    100b29 <vsnprintf+0x24>

0000000000100b54 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100b54:	f3 0f 1e fa          	endbr64 
  100b58:	55                   	push   %rbp
  100b59:	48 89 e5             	mov    %rsp,%rbp
  100b5c:	48 83 ec 50          	sub    $0x50,%rsp
  100b60:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100b64:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100b68:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100b6c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100b73:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100b77:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100b7b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100b7f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100b83:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100b87:	e8 79 ff ff ff       	call   100b05 <vsnprintf>
    va_end(val);
    return n;
}
  100b8c:	c9                   	leave  
  100b8d:	c3                   	ret    

0000000000100b8e <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  100b8e:	f3 0f 1e fa          	endbr64 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b92:	48 8d 05 67 74 fb ff 	lea    -0x48b99(%rip),%rax        # b8000 <console>
  100b99:	48 8d 90 a0 0f 00 00 	lea    0xfa0(%rax),%rdx
        console[i] = ' ' | 0x0700;
  100ba0:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100ba5:	48 83 c0 02          	add    $0x2,%rax
  100ba9:	48 39 d0             	cmp    %rdx,%rax
  100bac:	75 f2                	jne    100ba0 <console_clear+0x12>
    }
    cursorpos = 0;
  100bae:	c7 05 44 84 fb ff 00 	movl   $0x0,-0x47bbc(%rip)        # b8ffc <cursorpos>
  100bb5:	00 00 00 
}
  100bb8:	c3                   	ret    

0000000000100bb9 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  100bb9:	f3 0f 1e fa          	endbr64 
  100bbd:	55                   	push   %rbp
  100bbe:	48 89 e5             	mov    %rsp,%rbp
  100bc1:	48 83 ec 50          	sub    $0x50,%rsp
  100bc5:	49 89 f2             	mov    %rsi,%r10
  100bc8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  100bcc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100bd0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100bd4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  100bd8:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  100bdd:	85 ff                	test   %edi,%edi
  100bdf:	78 32                	js     100c13 <app_printf+0x5a>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  100be1:	48 63 ff             	movslq %edi,%rdi
  100be4:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  100beb:	cc cc cc 
  100bee:	48 89 f8             	mov    %rdi,%rax
  100bf1:	48 f7 e2             	mul    %rdx
  100bf4:	48 89 d0             	mov    %rdx,%rax
  100bf7:	48 c1 e8 02          	shr    $0x2,%rax
  100bfb:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  100bff:	48 01 c2             	add    %rax,%rdx
  100c02:	48 29 d7             	sub    %rdx,%rdi
  100c05:	48 8d 05 01 03 00 00 	lea    0x301(%rip),%rax        # 100f0d <col.0>
  100c0c:	0f b6 34 38          	movzbl (%rax,%rdi,1),%esi
  100c10:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  100c13:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  100c1a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100c1e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100c22:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100c26:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  100c2a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100c2e:	4c 89 d2             	mov    %r10,%rdx
  100c31:	8b 3d c5 83 fb ff    	mov    -0x47c3b(%rip),%edi        # b8ffc <cursorpos>
  100c37:	e8 3e fe ff ff       	call   100a7a <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  100c3c:	3d 30 07 00 00       	cmp    $0x730,%eax
  100c41:	ba 00 00 00 00       	mov    $0x0,%edx
  100c46:	0f 4d c2             	cmovge %edx,%eax
  100c49:	89 05 ad 83 fb ff    	mov    %eax,-0x47c53(%rip)        # b8ffc <cursorpos>
    }
}
  100c4f:	c9                   	leave  
  100c50:	c3                   	ret    

0000000000100c51 <panic>:


// panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void panic(const char* format, ...) {
  100c51:	f3 0f 1e fa          	endbr64 
  100c55:	55                   	push   %rbp
  100c56:	48 89 e5             	mov    %rsp,%rbp
  100c59:	53                   	push   %rbx
  100c5a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  100c61:	48 89 fb             	mov    %rdi,%rbx
  100c64:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  100c68:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  100c6c:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  100c70:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  100c74:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  100c78:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  100c7f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100c83:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  100c87:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  100c8b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  100c8f:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  100c96:	ba 07 00 00 00       	mov    $0x7,%edx
  100c9b:	48 8d 35 35 02 00 00 	lea    0x235(%rip),%rsi        # 100ed7 <flag_chars+0x6>
  100ca2:	e8 32 f5 ff ff       	call   1001d9 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  100ca7:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  100cab:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  100cb2:	48 89 da             	mov    %rbx,%rdx
  100cb5:	be 99 00 00 00       	mov    $0x99,%esi
  100cba:	e8 46 fe ff ff       	call   100b05 <vsnprintf>
  100cbf:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  100cc2:	85 d2                	test   %edx,%edx
  100cc4:	7e 0f                	jle    100cd5 <panic+0x84>
  100cc6:	83 c0 06             	add    $0x6,%eax
  100cc9:	48 98                	cltq   
  100ccb:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  100cd2:	0a 
  100cd3:	75 2b                	jne    100d00 <panic+0xaf>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  100cd5:	48 8d 8d 08 ff ff ff 	lea    -0xf8(%rbp),%rcx
  100cdc:	48 8d 15 fe 01 00 00 	lea    0x1fe(%rip),%rdx        # 100ee1 <flag_chars+0x10>
  100ce3:	be 00 c0 00 00       	mov    $0xc000,%esi
  100ce8:	bf 30 07 00 00       	mov    $0x730,%edi
  100ced:	b8 00 00 00 00       	mov    $0x0,%eax
  100cf2:	e8 d4 fd ff ff       	call   100acb <console_printf>
}

// sys_panic(msg)
//    Panic.
static inline pid_t __attribute__((noreturn)) sys_panic(const char* msg) {
    asm volatile ("int %0" : /* no result */
  100cf7:	bf 00 00 00 00       	mov    $0x0,%edi
  100cfc:	cd 30                	int    $0x30
                  : "i" (INT_SYS_PANIC), "D" (msg)
                  : "cc", "memory");
 loop: goto loop;
  100cfe:	eb fe                	jmp    100cfe <panic+0xad>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  100d00:	48 63 c2             	movslq %edx,%rax
  100d03:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  100d09:	0f 94 c2             	sete   %dl
  100d0c:	0f b6 d2             	movzbl %dl,%edx
  100d0f:	48 29 d0             	sub    %rdx,%rax
  100d12:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  100d19:	ff 
  100d1a:	48 8d 35 be 01 00 00 	lea    0x1be(%rip),%rsi        # 100edf <flag_chars+0xe>
  100d21:	e8 89 f5 ff ff       	call   1002af <strcpy>
  100d26:	eb ad                	jmp    100cd5 <panic+0x84>

0000000000100d28 <assert_fail>:
    sys_panic(NULL);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  100d28:	f3 0f 1e fa          	endbr64 
  100d2c:	55                   	push   %rbp
  100d2d:	48 89 e5             	mov    %rsp,%rbp
  100d30:	48 89 f9             	mov    %rdi,%rcx
  100d33:	41 89 f0             	mov    %esi,%r8d
  100d36:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  100d39:	48 8d 15 a8 01 00 00 	lea    0x1a8(%rip),%rdx        # 100ee8 <flag_chars+0x17>
  100d40:	be 00 c0 00 00       	mov    $0xc000,%esi
  100d45:	bf 30 07 00 00       	mov    $0x730,%edi
  100d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  100d4f:	e8 77 fd ff ff       	call   100acb <console_printf>
    asm volatile ("int %0" : /* no result */
  100d54:	bf 00 00 00 00       	mov    $0x0,%edi
  100d59:	cd 30                	int    $0x30
 loop: goto loop;
  100d5b:	eb fe                	jmp    100d5b <assert_fail+0x33>
