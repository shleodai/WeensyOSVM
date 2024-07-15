
obj/bootsector.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000007c00 <boot_start>:
.set SEGSEL_BOOT_CODE,0x8       # code segment selector

.globl boot_start                               # Entry point
boot_start:
        .code16                         # This runs in real mode
        cli                             # Disable interrupts
    7c00:	fa                   	cli    
        cld                             # String operations increment
    7c01:	fc                   	cld    

        # All segments are initially 0.
        # Set up the stack pointer, growing downward from 0x7c00.
        movw    $boot_start, %sp
    7c02:	bc                   	.byte 0xbc
    7c03:	00                   	.byte 0x0
    7c04:	7c                   	.byte 0x7c

0000000000007c05 <seta20.1>:
#   and subsequent 80286-based PCs wanted to retain maximum compatibility),
#   physical address line 20 is tied to low when the machine boots.
#   Obviously this a bit of a drag for us, especially when trying to
#   address memory above 1MB.  This code undoes this.

seta20.1:       inb     $0x64, %al              # Get status
    7c05:	e4 64                	in     $0x64,%al
                testb   $0x2, %al               # Busy?
    7c07:	a8 02                	test   $0x2,%al
                jnz     seta20.1                # Yes
    7c09:	75 fa                	jne    7c05 <seta20.1>
                movb    $0xd1, %al              # Command: Write
    7c0b:	b0 d1                	mov    $0xd1,%al
                outb    %al, $0x64              #  output port
    7c0d:	e6 64                	out    %al,$0x64

0000000000007c0f <seta20.2>:
seta20.2:       inb     $0x64, %al              # Get status
    7c0f:	e4 64                	in     $0x64,%al
                testb   $0x2, %al               # Busy?
    7c11:	a8 02                	test   $0x2,%al
                jnz     seta20.2                # Yes
    7c13:	75 fa                	jne    7c0f <seta20.2>
                movb    $0xdf, %al              # Command: Enable
    7c15:	b0 df                	mov    $0xdf,%al
                outb    %al, $0x60              #  A20
    7c17:	e6 60                	out    %al,$0x60

0000000000007c19 <init_pt>:
        .set PTE_U,4
        .set PTE_PS,128

        .code16
init_pt:
        movl    $INITIAL_PT, %edi       # clear page table memory
    7c19:	66 bf 00 80          	mov    $0x8000,%di
    7c1d:	00 00                	add    %al,(%rax)
        xorl    %eax, %eax
    7c1f:	66 31 c0             	xor    %ax,%ax
        movl    $(0x3000 / 4), %ecx
    7c22:	66 b9 00 0c          	mov    $0xc00,%cx
    7c26:	00 00                	add    %al,(%rax)
        rep stosl
    7c28:	66 f3 ab             	rep stos %ax,%es:(%rdi)
        # 0x8000: L1 page table; entry 0 points to:
        # 0x9000: L2 page table; entry 0 points to:
        # 0xA000: L3 page table; entry 0 is a huge page covering 0-0x3FFFFFFF
        # Modern x86-64 processors support PTE_PS on L2 page entries,
        # but QEMU does not.
        movl    $INITIAL_PT, %edi       # set up page table: use a large page
    7c2b:	66 bf 00 80          	mov    $0x8000,%di
    7c2f:	00 00                	add    %al,(%rax)
        leal    0x1000 + PTE_P + PTE_W + PTE_U(%edi), %ecx
    7c31:	67 66 8d 8f 07 10 00 	lea    0x1007(%edi),%cx
    7c38:	00 
        movl    %ecx, (%edi)
    7c39:	67 66 89 0f          	mov    %cx,(%edi)
        leal    0x2000 + PTE_P + PTE_W + PTE_U(%edi), %ecx
    7c3d:	67 66 8d 8f 07 20 00 	lea    0x2007(%edi),%cx
    7c44:	00 
        movl    %ecx, 0x1000(%edi)
    7c45:	67 66 89 8f 00 10 00 	mov    %cx,0x1000(%edi)
    7c4c:	00 
        movl    $(PTE_P + PTE_W + PTE_U + PTE_PS), -7(%ecx)
    7c4d:	67 66 c7 41 f9 87 00 	movw   $0x87,-0x7(%ecx)
    7c54:	00 00                	add    %al,(%rax)
        movl    %edi, %cr3
    7c56:	0f 22 df             	mov    %rdi,%cr3

0000000000007c59 <real_to_prot>:
        .set IA32_EFER_SCE,1            # enable syscall/sysret
        .set IA32_EFER_LME,0x100        # enable 64-bit mode
        .set IA32_EFER_NXE,0x800

real_to_prot:
        movl    %cr4, %eax              # enable physical address extensions
    7c59:	0f 20 e0             	mov    %cr4,%rax
        orl     $(CR4_PSE | CR4_PAE), %eax
    7c5c:	66 83 c8 30          	or     $0x30,%ax
        movl    %eax, %cr4
    7c60:	0f 22 e0             	mov    %rax,%cr4

        movl    $MSR_IA32_EFER, %ecx    # turn on 64-bit mode
    7c63:	66 b9 80 00          	mov    $0x80,%cx
    7c67:	00 c0                	add    %al,%al
        rdmsr
    7c69:	0f 32                	rdmsr  
        orl     $(IA32_EFER_LME | IA32_EFER_SCE | IA32_EFER_NXE), %eax
    7c6b:	66 0d 01 09          	or     $0x901,%ax
    7c6f:	00 00                	add    %al,(%rax)
        wrmsr
    7c71:	0f 30                	wrmsr  

        movl    %cr0, %eax              # turn on protected mode
    7c73:	0f 20 c0             	mov    %cr0,%rax
        orl     $(CR0_PE | CR0_WP | CR0_PG), %eax
    7c76:	66 0d 01 00          	or     $0x1,%ax
    7c7a:	01 80 0f 22 c0 0f    	add    %eax,0xfc0220f(%rax)
        movl    %eax, %cr0

        lgdt    gdtdesc                 # load GDT
    7c80:	01 16                	add    %edx,(%rsi)
    7c82:	9c                   	pushf  
    7c83:	7c ea                	jl     7c6f <real_to_prot+0x16>

        # CPU magic: jump to relocation, flush prefetch queue, and
        # reload %cs.  Has the effect of just jmp to the next
        # instruction, but simultaneously loads CS with
        # $SEGSEL_BOOT_CODE.
        ljmp    $SEGSEL_BOOT_CODE, $boot
    7c85:	7d 7d                	jge    7d04 <boot_readseg+0x5e>
    7c87:	08 00                	or     %al,(%rax)
    7c89:	0f 1f 00             	nopl   (%rax)

0000000000007c8c <gdt>:
	...
    7c98:	00                   	.byte 0x0
    7c99:	98                   	cwtl   
    7c9a:	20 00                	and    %al,(%rax)

0000000000007c9c <gdtdesc>:
    7c9c:	0f 00 8c 7c 00 00 00 	str    0x0(%rsp,%rdi,2)
    7ca3:	00 
	...

0000000000007ca6 <boot_readseg>:
//    Load an ELF segment at virtual address `dst` from the IDE disk's sector
//    `src_sect`. Copies `filesz` bytes into memory at `dst` from sectors
//    `src_sect` and up, then clears memory in the range
//    `[dst+filesz, dst+memsz)`.
static void boot_readseg(uintptr_t ptr, uint32_t src_sect,
                         size_t filesz, size_t memsz) {
    7ca6:	41 57                	push   %r15
    uintptr_t end_ptr = ptr + filesz;
    memsz += ptr;
    7ca8:	48 8d 04 0f          	lea    (%rdi,%rcx,1),%rax
    uintptr_t end_ptr = ptr + filesz;
    7cac:	4c 8d 0c 17          	lea    (%rdi,%rdx,1),%r9
                 : "d" (port), "0" (addr), "1" (cnt)
                 : "memory", "cc");
}

static inline void outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7cb0:	41 b7 20             	mov    $0x20,%r15b
                         size_t filesz, size_t memsz) {
    7cb3:	41 56                	push   %r14
    asm volatile("cld\n\trepne\n\tinsl"
    7cb5:	41 bb f0 01 00 00    	mov    $0x1f0,%r11d
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7cbb:	41 be f6 01 00 00    	mov    $0x1f6,%r14d
    asm volatile("cld\n\trepne\n\tinsl"
    7cc1:	41 ba 80 00 00 00    	mov    $0x80,%r10d
    7cc7:	41 55                	push   %r13
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7cc9:	41 bd f5 01 00 00    	mov    $0x1f5,%r13d
    7ccf:	41 54                	push   %r12
    7cd1:	41 bc f4 01 00 00    	mov    $0x1f4,%r12d
    7cd7:	55                   	push   %rbp
    7cd8:	bd f3 01 00 00       	mov    $0x1f3,%ebp
    7cdd:	53                   	push   %rbx
    7cde:	bb f2 01 00 00       	mov    $0x1f2,%ebx
    7ce3:	41 50                	push   %r8
    7ce5:	41 89 f0             	mov    %esi,%r8d

    // round down to sector boundary
    ptr &= ~(SECTORSIZE - 1);
    7ce8:	48 89 fe             	mov    %rdi,%rsi
    7ceb:	48 81 e6 00 fe ff ff 	and    $0xfffffffffffffe00,%rsi
    memsz += ptr;
    7cf2:	48 89 04 24          	mov    %rax,(%rsp)

    // read sectors
    for (; ptr < end_ptr; ptr += SECTORSIZE, ++src_sect) {
    7cf6:	4c 39 ce             	cmp    %r9,%rsi
    7cf9:	73 67                	jae    7d62 <boot_readseg+0xbc>
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7cfb:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7d00:	ec                   	in     (%dx),%al
// boot_waitdisk
//    Wait for the disk to be ready.
static void boot_waitdisk(void) {
    // Wait until the ATA status register says ready (0x40 is on)
    // & not busy (0x80 is off)
    while ((inb(0x1F7) & 0xC0) != 0x40) {
    7d01:	83 e0 c0             	and    $0xffffffc0,%eax
    7d04:	3c 40                	cmp    $0x40,%al
    7d06:	75 f3                	jne    7cfb <boot_readseg+0x55>
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7d08:	b0 01                	mov    $0x1,%al
    7d0a:	89 da                	mov    %ebx,%edx
    7d0c:	ee                   	out    %al,(%dx)
    7d0d:	44 89 c0             	mov    %r8d,%eax
    7d10:	89 ea                	mov    %ebp,%edx
    7d12:	ee                   	out    %al,(%dx)
static void boot_readsect(uintptr_t dst, uint32_t src_sect) {
    // programmed I/O for "read sector"
    boot_waitdisk();
    outb(0x1F2, 1);             // send `count = 1` as an ATA argument
    outb(0x1F3, src_sect);      // send `src_sect`, the sector number
    outb(0x1F4, src_sect >> 8);
    7d13:	44 89 c0             	mov    %r8d,%eax
    7d16:	44 89 e2             	mov    %r12d,%edx
    7d19:	c1 e8 08             	shr    $0x8,%eax
    7d1c:	ee                   	out    %al,(%dx)
    outb(0x1F5, src_sect >> 16);
    7d1d:	44 89 c0             	mov    %r8d,%eax
    7d20:	44 89 ea             	mov    %r13d,%edx
    7d23:	c1 e8 10             	shr    $0x10,%eax
    7d26:	ee                   	out    %al,(%dx)
    outb(0x1F6, (src_sect >> 24) | 0xE0);
    7d27:	44 89 c0             	mov    %r8d,%eax
    7d2a:	44 89 f2             	mov    %r14d,%edx
    7d2d:	c1 e8 18             	shr    $0x18,%eax
    7d30:	83 c8 e0             	or     $0xffffffe0,%eax
    7d33:	ee                   	out    %al,(%dx)
    7d34:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7d39:	44 89 f8             	mov    %r15d,%eax
    7d3c:	ee                   	out    %al,(%dx)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7d3d:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7d42:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40) {
    7d43:	83 e0 c0             	and    $0xffffffc0,%eax
    7d46:	3c 40                	cmp    $0x40,%al
    7d48:	75 f3                	jne    7d3d <boot_readseg+0x97>
    asm volatile("cld\n\trepne\n\tinsl"
    7d4a:	48 89 f7             	mov    %rsi,%rdi
    7d4d:	44 89 d1             	mov    %r10d,%ecx
    7d50:	44 89 da             	mov    %r11d,%edx
    7d53:	fc                   	cld    
    7d54:	f2 6d                	repnz insl (%dx),%es:(%rdi)
    for (; ptr < end_ptr; ptr += SECTORSIZE, ++src_sect) {
    7d56:	48 81 c6 00 02 00 00 	add    $0x200,%rsi
    7d5d:	41 ff c0             	inc    %r8d
    7d60:	eb 94                	jmp    7cf6 <boot_readseg+0x50>
    for (; end_ptr < memsz; ++end_ptr) {
    7d62:	4c 3b 0c 24          	cmp    (%rsp),%r9
    7d66:	73 09                	jae    7d71 <boot_readseg+0xcb>
        *(uint8_t*) end_ptr = 0;
    7d68:	41 c6 01 00          	movb   $0x0,(%r9)
    for (; end_ptr < memsz; ++end_ptr) {
    7d6c:	49 ff c1             	inc    %r9
    7d6f:	eb f1                	jmp    7d62 <boot_readseg+0xbc>
}
    7d71:	58                   	pop    %rax
    7d72:	5b                   	pop    %rbx
    7d73:	5d                   	pop    %rbp
    7d74:	41 5c                	pop    %r12
    7d76:	41 5d                	pop    %r13
    7d78:	41 5e                	pop    %r14
    7d7a:	41 5f                	pop    %r15
    7d7c:	c3                   	ret    

0000000000007d7d <boot>:
void boot(void) {
    7d7d:	f3 0f 1e fa          	endbr64 
    7d81:	55                   	push   %rbp
    boot_readseg((uintptr_t) ELFHDR, 1, PAGESIZE, PAGESIZE);
    7d82:	b9 00 10 00 00       	mov    $0x1000,%ecx
    7d87:	ba 00 10 00 00       	mov    $0x1000,%edx
    7d8c:	be 01 00 00 00       	mov    $0x1,%esi
void boot(void) {
    7d91:	53                   	push   %rbx
    boot_readseg((uintptr_t) ELFHDR, 1, PAGESIZE, PAGESIZE);
    7d92:	bf 00 00 01 00       	mov    $0x10000,%edi
void boot(void) {
    7d97:	50                   	push   %rax
    boot_readseg((uintptr_t) ELFHDR, 1, PAGESIZE, PAGESIZE);
    7d98:	e8 09 ff ff ff       	call   7ca6 <boot_readseg>
    while (ELFHDR->e_magic != ELF_MAGIC) {
    7d9d:	8b 04 25 00 00 01 00 	mov    0x10000,%eax
    7da4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
    7da9:	75 f9                	jne    7da4 <boot+0x27>
    elf_program* eph = ph + ELFHDR->e_phnum;
    7dab:	0f b7 2c 25 38 00 01 	movzwl 0x10038,%ebp
    7db2:	00 
    elf_program* ph = (elf_program*) ((uint8_t*) ELFHDR + ELFHDR->e_phoff);
    7db3:	48 8b 04 25 20 00 01 	mov    0x10020,%rax
    7dba:	00 
    elf_program* eph = ph + ELFHDR->e_phnum;
    7dbb:	48 6b ed 38          	imul   $0x38,%rbp,%rbp
    elf_program* ph = (elf_program*) ((uint8_t*) ELFHDR + ELFHDR->e_phoff);
    7dbf:	48 8d 98 00 00 01 00 	lea    0x10000(%rax),%rbx
    elf_program* eph = ph + ELFHDR->e_phnum;
    7dc6:	48 01 dd             	add    %rbx,%rbp
    for (; ph < eph; ++ph) {
    7dc9:	48 39 eb             	cmp    %rbp,%rbx
    7dcc:	73 21                	jae    7def <boot+0x72>
        boot_readseg(ph->p_va, ph->p_offset / SECTORSIZE + 1,
    7dce:	48 8b 73 08          	mov    0x8(%rbx),%rsi
    7dd2:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
    for (; ph < eph; ++ph) {
    7dd6:	48 83 c3 38          	add    $0x38,%rbx
        boot_readseg(ph->p_va, ph->p_offset / SECTORSIZE + 1,
    7dda:	48 8b 53 e8          	mov    -0x18(%rbx),%rdx
    7dde:	48 8b 7b d8          	mov    -0x28(%rbx),%rdi
    7de2:	48 c1 ee 09          	shr    $0x9,%rsi
    7de6:	ff c6                	inc    %esi
    7de8:	e8 b9 fe ff ff       	call   7ca6 <boot_readseg>
    for (; ph < eph; ++ph) {
    7ded:	eb da                	jmp    7dc9 <boot+0x4c>
    kernel_entry();
    7def:	ff 14 25 18 00 01 00 	call   *0x10018
