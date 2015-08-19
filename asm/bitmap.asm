	.file	"bitmap.c"
	.intel_syntax noprefix
	.text
	.globl	set_bitmap_header
	.type	set_bitmap_header, @function
set_bitmap_header:
.LFB5:
	.cfi_startproc
	mov	rcx, QWORD PTR file_data@GOTPCREL[rip]
	mov	eax, edi
	mov	r8b, dl
	sar	eax, 8
	shr	r8b, 3
	mov	BYTE PTR 19[rcx], al
	mov	eax, edi
	mov	BYTE PTR 18[rcx], dil
	sar	eax, 16
	mov	BYTE PTR 28[rcx], dl
	mov	BYTE PTR [rcx], 66
	mov	BYTE PTR 20[rcx], al
	mov	eax, edi
	mov	BYTE PTR 1[rcx], 77
	shr	eax, 24
	mov	BYTE PTR 10[rcx], 64
	mov	BYTE PTR 11[rcx], 0
	mov	BYTE PTR 21[rcx], al
	mov	eax, esi
	mov	BYTE PTR 12[rcx], 0
	sar	eax, 8
	mov	BYTE PTR 13[rcx], 0
	mov	BYTE PTR 14[rcx], 40
	mov	BYTE PTR 23[rcx], al
	mov	eax, esi
	mov	BYTE PTR 15[rcx], 0
	sar	eax, 16
	mov	BYTE PTR 16[rcx], 0
	mov	BYTE PTR 17[rcx], 0
	mov	BYTE PTR 24[rcx], al
	mov	eax, esi
	mov	BYTE PTR 26[rcx], 1
	shr	eax, 24
	mov	BYTE PTR 27[rcx], 0
	mov	BYTE PTR 29[rcx], 0
	mov	BYTE PTR 25[rcx], al
	mov	al, sil
	mov	BYTE PTR 22[rcx], sil
	imul	eax, edi
	imul	edi, esi
	imul	eax, r8d
	movzx	r8d, r8b
	imul	edi, r8d
	mov	BYTE PTR 34[rcx], al
	add	eax, 64
	mov	edx, edi
	mov	BYTE PTR 2[rcx], al
	shr	edx, 8
	mov	BYTE PTR 35[rcx], dl
	mov	edx, edi
	shr	edx, 16
	mov	BYTE PTR 36[rcx], dl
	mov	edx, edi
	add	edi, 64
	mov	eax, edi
	shr	edx, 24
	shr	eax, 8
	mov	BYTE PTR 37[rcx], dl
	mov	BYTE PTR 3[rcx], al
	mov	eax, edi
	shr	edi, 24
	shr	eax, 16
	mov	BYTE PTR 5[rcx], dil
	mov	BYTE PTR 4[rcx], al
	ret
	.cfi_endproc
.LFE5:
	.size	set_bitmap_header, .-set_bitmap_header
	.globl	capture_FB_to_file_16b
	.type	capture_FB_to_file_16b, @function
capture_FB_to_file_16b:
.LFB8:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	esi, 1024
	xor	r9d, r9d
	xor	r10d, r10d
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12, rdi
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	push	rdx
	.cfi_def_cfa_offset 64
	mov	rcx, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	r13, QWORD PTR file_data@GOTPCREL[rip]
	mov	rax, QWORD PTR 136[rcx]
	mov	r14, QWORD PTR 32[rcx]
	mov	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR 200[rcx]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rcx]
	and	edi, 16777215
	mov	r8d, DWORD PTR [rax]
	mov	rax, QWORD PTR 224[rcx]
	mov	ebx, DWORD PTR [rax]
	mov	eax, edx
	shr	edx, 16
	and	edx, 1023
	and	eax, 1023
	sub	eax, edx
	and	ebx, 4095
	imul	ebx, eax
	mov	eax, ebx
	cdq
	idiv	esi
	mov	edx, r8d
	shr	r8d, 16
	and	edx, 1023
	and	r8d, 1023
	sub	edx, r8d
	mov	ebx, eax
	mov	rax, QWORD PTR 232[rcx]
	and	ebx, -2
	lea	r11d, [rbx+rbx]
	mov	eax, DWORD PTR [rax]
	and	eax, 4095
	imul	eax, edx
	cdq
	idiv	esi
	mov	ebp, eax
	mov	rax, QWORD PTR 144[rcx]
	sar	ebp
	lea	edx, -1[rbp]
	mov	eax, DWORD PTR [rax]
	mov	r15d, edx
	imul	r15d, r11d
	and	eax, 4095
	sub	eax, ebx
.L3:
	test	edx, edx
	js	.L9
	lea	ecx, [r9+r15]
	lea	rsi, 64[rcx+r13]
	xor	ecx, ecx
.L4:
	cmp	ecx, ebx
	jge	.L10
	lea	r8d, [rcx+r10]
	add	rsi, 2
	inc	ecx
	lea	r8d, [rdi+r8*2]
	xor	r8d, 2
	movsx	r8, r8d
	mov	r8w, WORD PTR [r14+r8]
	rol	r8w, 15
	mov	BYTE PTR -2[rsi], r8b
	shr	r8w, 8
	mov	BYTE PTR -1[rsi], r8b
	jmp	.L4
.L10:
	xor	ecx, ecx
	test	ebx, ebx
	cmovns	ecx, ebx
	dec	edx
	sub	r9d, r11d
	add	r10d, ecx
	add	r10d, eax
	jmp	.L3
.L9:
	mov	edi, ebx
	mov	esi, ebp
	mov	edx, 16
	imul	ebx, ebp
	call	set_bitmap_header@PLT
	pop	rax
	.cfi_def_cfa_offset 56
	lea	edx, 64[rbx+rbx]
	mov	rdi, r12
	mov	rsi, r13
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	jmp	file_out@PLT
	.cfi_endproc
.LFE8:
	.size	capture_FB_to_file_16b, .-capture_FB_to_file_16b
	.globl	capture_FB_to_file_32b
	.type	capture_FB_to_file_32b, @function
capture_FB_to_file_32b:
.LFB9:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	xor	r8d, r8d
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12, rdi
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	mov	rcx, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rax, QWORD PTR 136[rcx]
	mov	r14d, DWORD PTR [rax]
	mov	rax, QWORD PTR 200[rcx]
	mov	esi, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rcx]
	and	r14d, 16777215
	mov	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR 224[rcx]
	mov	ebx, DWORD PTR [rax]
	mov	eax, esi
	shr	esi, 16
	and	esi, 1023
	and	eax, 1023
	sub	eax, esi
	mov	esi, 1024
	and	ebx, 4095
	imul	ebx, eax
	mov	eax, ebx
	cdq
	idiv	esi
	mov	ebx, eax
	mov	rax, QWORD PTR 232[rcx]
	lea	r11d, 0[0+rbx*4]
	mov	ebp, DWORD PTR [rax]
	mov	eax, edi
	shr	edi, 16
	mov	edx, edi
	and	eax, 1023
	xor	edi, edi
	and	edx, 1023
	sub	eax, edx
	and	ebp, 4095
	imul	ebp, eax
	mov	eax, ebp
	cdq
	idiv	esi
	mov	ebp, eax
	mov	rax, QWORD PTR 144[rcx]
	sar	ebp
	lea	edx, -1[rbp]
	mov	eax, DWORD PTR [rax]
	mov	r13d, edx
	imul	r13d, r11d
	mov	DWORD PTR 12[rsp], eax
	and	DWORD PTR 12[rsp], 4095
	sub	DWORD PTR 12[rsp], ebx
.L12:
	test	edx, edx
	js	.L17
	mov	rax, QWORD PTR file_data@GOTPCREL[rip]
	lea	ecx, [rdi+r13]
	lea	r10d, 0[0+r8*4]
	xor	r9d, r9d
	movsx	r10, r10d
	lea	rcx, 64[rcx+rax]
	add	r10, r14
	sub	r10, rcx
.L13:
	cmp	r9d, ebx
	jge	.L18
	mov	rsi, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rax, r10
	add	rcx, 4
	inc	r9d
	add	rax, QWORD PTR 32[rsi]
	mov	esi, DWORD PTR -4[rcx+rax]
	mov	r15d, esi
	mov	eax, esi
	shr	r15d, 16
	movzx	eax, ah
	mov	BYTE PTR -3[rcx], r15b
	mov	r15d, esi
	mov	BYTE PTR -4[rcx], al
	shr	r15d, 24
	mov	BYTE PTR -2[rcx], r15b
	mov	BYTE PTR -1[rcx], sil
	jmp	.L13
.L18:
	xor	ecx, ecx
	test	ebx, ebx
	cmovns	ecx, ebx
	dec	edx
	sub	edi, r11d
	add	r8d, ecx
	add	r8d, DWORD PTR 12[rsp]
	jmp	.L12
.L17:
	mov	edi, ebx
	mov	esi, ebp
	mov	edx, 32
	imul	ebx, ebp
	call	set_bitmap_header@PLT
	mov	rsi, QWORD PTR file_data@GOTPCREL[rip]
	add	rsp, 24
	.cfi_def_cfa_offset 56
	mov	rdi, r12
	lea	edx, 64[0+rbx*4]
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	jmp	file_out@PLT
	.cfi_endproc
.LFE9:
	.size	capture_FB_to_file_32b, .-capture_FB_to_file_32b
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Failed to read DAC."
	.text
	.globl	capture_screen_to_file
	.type	capture_screen_to_file, @function
capture_screen_to_file:
.LFB6:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	mov	rbx, QWORD PTR thread_stage@GOTPCREL[rip]
	cmp	DWORD PTR [rbx], 0
	jns	.L20
	mov	DWORD PTR [rbx], 0
	jmp	.L19
.L20:
	mov	rax, QWORD PTR viewport@GOTPCREL[rip]
	mov	esi, 1
	mov	r14, rdi
	mov	edi, 3333
	mov	DWORD PTR [rbx], 1
	mov	ebp, DWORD PTR 8[rax]
	mov	r12d, DWORD PTR 12[rax]
	call	glPixelStorei@PLT
	mov	r13, QWORD PTR file_data@GOTPCREL[rip]
	xor	esi, esi
	xor	edi, edi
	mov	r9d, 5121
	mov	r8d, 32992
	mov	ecx, r12d
	mov	edx, ebp
	lea	rax, 64[r13]
	mov	QWORD PTR [rsp], rax
	call	glReadPixels@PLT
	call	glGetError@PLT
	test	eax, eax
	je	.L22
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	lea	rdi, .LC0[rip]
	mov	esi, eax
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	jmp	DisplayGLError@PLT
.L22:
	.cfi_restore_state
	mov	eax, ebp
	mov	edx, 1048576
	mov	esi, r12d
	imul	eax, r12d
	mov	edi, ebp
	cmp	eax, 1048576
	cmovg	eax, edx
	mov	edx, 24
	cdqe
	lea	r15, [rax+rax*2]
	call	set_bitmap_header@PLT
	lea	rdx, 64[r15]
	mov	rsi, r13
	mov	rdi, r14
	call	file_out@PLT
	mov	DWORD PTR [rbx], -1
.L19:
	add	rsp, 24
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6:
	.size	capture_screen_to_file, .-capture_screen_to_file
	.globl	safe_name
	.type	safe_name, @function
safe_name:
.LFB7:
	.cfi_startproc
	mov	dl, 45
	test	dil, dil
	mov	al, dl
	cmovns	eax, edi
	sub	edi, 32
	cmp	dil, 95
	cmovae	eax, edx
	ret
	.cfi_endproc
.LFE7:
	.size	safe_name, .-safe_name
	.globl	capture_FB_to_file
	.section	.data.rel,"aw",@progbits
	.align 16
	.type	capture_FB_to_file, @object
	.size	capture_FB_to_file, 16
capture_FB_to_file:
	.quad	capture_FB_to_file_16b
	.quad	capture_FB_to_file_32b
	.globl	thread_stage
	.data
	.align 4
	.type	thread_stage, @object
	.size	thread_stage, 4
thread_stage:
	.long	-1
	.comm	file_data,3145792,16
	.ident	"GCC: (GNU) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
