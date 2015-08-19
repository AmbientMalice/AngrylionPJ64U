	.file	"config.c"
	.intel_syntax noprefix
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"angrylion's pixel-accurate RDP from MESS code\nWin32 GUI method of configuration contributed by RPGMaster."
	.text
	.globl	DllAbout
	.type	DllAbout, @function
DllAbout:
.LFB5:
	.cfi_startproc
	lea	rdi, .LC0[rip]
	jmp	puts@PLT
	.cfi_endproc
.LFE5:
	.size	DllAbout, .-DllAbout
	.section	.rodata.str1.1
.LC1:
	.string	"RDP_CONF.BIN"
.LC2:
	.string	"Could not open `RDP_CONF.BIN'."
.LC3:
	.string	"RAM capacity exceeds RCP hardware limit."
.LC4:
	.string	"wb"
.LC5:
	.string	"Failed to write file."
	.text
	.globl	DllConfig
	.type	DllConfig, @function
DllConfig:
.LFB6:
	.cfi_startproc
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	push	r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	push	r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	mov	r12, QWORD PTR emulation_running@GOTPCREL[rip]
	push	rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	push	rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	cmp	DWORD PTR [r12], 0
	jne	.L4
	mov	rsi, QWORD PTR cfg@GOTPCREL[rip]
	lea	rdi, .LC1[rip]
	mov	edx, 32
	call	file_in@PLT
	test	eax, eax
	jne	.L4
	lea	rdi, .LC2[rip]
	call	DisplayError@PLT
.L4:
	mov	rbx, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	lea	r8, digits[rip]
	mov	ecx, 28
	mov	r10d, 15
	mov	rax, QWORD PTR 136[rbx]
	mov	r9d, DWORD PTR [rax]
	mov	rax, QWORD PTR 128[rbx]
	mov	edi, DWORD PTR [rax]
	lea	rax, DRAM_name[rip+4]
	mov	BYTE PTR DRAM_name[rip], 82
	mov	BYTE PTR DRAM_name[rip+1], 67
	mov	BYTE PTR DRAM_name[rip+2], 80
	mov	BYTE PTR DRAM_name[rip+3], 95
.L7:
	mov	rdx, r10
	inc	rax
	lea	rsi, digits[rip]
	sal	rdx, cl
	and	edx, r9d
	shr	edx, cl
	sub	ecx, 4
	and	edx, 15
	mov	dl, BYTE PTR [r8+rdx]
	mov	BYTE PTR -1[rax], dl
	cmp	ecx, -4
	jne	.L7
	lea	rax, DRAM_name[rip+13]
	mov	BYTE PTR DRAM_name[rip+12], 95
	mov	ecx, 28
	mov	r8d, 15
.L9:
	mov	rdx, r8
	inc	rax
	sal	rdx, cl
	and	edx, edi
	shr	edx, cl
	sub	ecx, 4
	and	edx, 15
	mov	dl, BYTE PTR [rsi+rdx]
	mov	BYTE PTR -1[rax], dl
	cmp	ecx, -4
	jne	.L9
	mov	rbp, QWORD PTR plim@GOTPCREL[rip]
	mov	BYTE PTR DRAM_name[rip+21], 46
	lea	rdi, .LC3[rip]
	mov	BYTE PTR DRAM_name[rip+22], 98
	mov	BYTE PTR DRAM_name[rip+23], 105
	mov	BYTE PTR DRAM_name[rip+24], 110
	mov	BYTE PTR DRAM_name[rip+25], 0
	mov	edx, DWORD PTR 0[rbp]
	mov	eax, DWORD PTR 16[rbx]
	cmp	edx, 16777215
	ja	.L20
	test	eax, eax
	jne	.L12
	mov	rsi, QWORD PTR 32[rbx]
	lea	rdi, DRAM_name[rip]
	inc	edx
	call	file_out@PLT
	jmp	.L11
.L12:
	lea	rsi, .LC4[rip]
	lea	rdi, DRAM_name[rip]
	call	fopen@PLT
	test	rax, rax
	mov	r13, rax
	jne	.L13
.L16:
	lea	rdi, .LC5[rip]
.L20:
	call	DisplayError@PLT
	jmp	.L11
.L13:
	mov	r14d, DWORD PTR 0[rbp]
	lea	edi, 1[r14]
	call	malloc@PLT
	mov	rdx, QWORD PTR 32[rbx]
	mov	rbp, rax
	xor	ebx, ebx
.L15:
	lea	eax, 3[rbx]
	mov	ecx, ebx
	lea	edi, 1[rbx]
	mov	sil, BYTE PTR [rdx+rax]
	mov	BYTE PTR 0[rbp+rcx], sil
	lea	esi, 2[rbx]
	mov	r8b, BYTE PTR [rdx+rsi]
	mov	BYTE PTR 0[rbp+rdi], r8b
	mov	dil, BYTE PTR [rdx+rdi]
	mov	BYTE PTR 0[rbp+rsi], dil
	mov	cl, BYTE PTR [rdx+rcx]
	lea	edi, 5[rbx]
	mov	BYTE PTR 0[rbp+rax], cl
	lea	eax, 7[rbx]
	lea	ecx, 4[rbx]
	mov	sil, BYTE PTR [rdx+rax]
	mov	BYTE PTR 0[rbp+rcx], sil
	lea	esi, 6[rbx]
	add	ebx, 8
	cmp	ebx, r14d
	mov	r8b, BYTE PTR [rdx+rsi]
	mov	BYTE PTR 0[rbp+rdi], r8b
	mov	dil, BYTE PTR [rdx+rdi]
	mov	BYTE PTR 0[rbp+rsi], dil
	mov	cl, BYTE PTR [rdx+rcx]
	mov	BYTE PTR 0[rbp+rax], cl
	jbe	.L15
	mov	edx, ebx
	mov	rcx, r13
	mov	esi, 1
	mov	rdi, rbp
	call	fwrite@PLT
	mov	rdi, rbp
	mov	r14, rax
	call	free@PLT
	mov	rdi, r13
	call	fclose@PLT
	cmp	ebx, r14d
	jne	.L16
.L11:
	mov	rsi, QWORD PTR cfg@GOTPCREL[rip]
	mov	al, BYTE PTR 23[rsi]
	xor	eax, 1
	cmp	BYTE PTR 4[rsi], 2
	mov	BYTE PTR 23[rsi], al
	je	.L17
	and	eax, 1
	mov	BYTE PTR 4[rsi], al
.L17:
	cmp	DWORD PTR [r12], 0
	jne	.L18
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbp
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r13
	.cfi_def_cfa_offset 16
	pop	r14
	.cfi_def_cfa_offset 8
	lea	rdi, .LC1[rip]
	mov	edx, 32
	jmp	file_out@PLT
.L18:
	.cfi_restore_state
	mov	rax, QWORD PTR video_sync@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
	pop	rbx
	.cfi_def_cfa_offset 40
	pop	rbp
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r13
	.cfi_def_cfa_offset 16
	pop	r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6:
	.size	DllConfig, .-DllConfig
	.globl	DllTest
	.type	DllTest, @function
DllTest:
.LFB7:
	.cfi_startproc
	ret
	.cfi_endproc
.LFE7:
	.size	DllTest, .-DllTest
	.globl	cfg
	.data
	.align 16
	.type	cfg, @object
	.size	cfg, 32
cfg:
	.byte	2
	.byte	127
	.byte	1
	.byte	-33
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.comm	version,8,8
	.comm	renderer,8,8
	.comm	vendor,8,8
	.section	.rodata
	.align 16
	.type	digits, @object
	.size	digits, 16
digits:
	.byte	48
	.byte	49
	.byte	50
	.byte	51
	.byte	52
	.byte	53
	.byte	54
	.byte	55
	.byte	56
	.byte	57
	.byte	65
	.byte	66
	.byte	67
	.byte	68
	.byte	69
	.byte	70
	.local	DRAM_name
	.comm	DRAM_name,32,16
	.ident	"GCC: (GNU) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
