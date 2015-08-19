	.file	"vi.c"
	.intel_syntax noprefix
	.text
	.p2align 4,,15
	.type	do_frame_buffer_raw, @function
do_frame_buffer_raw:
.LFB553:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	rax, QWORD PTR RCP_info_VI@GOTPCREL[rip]
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
	mov	r9, QWORD PTR 232[rax]
	mov	DWORD PTR -52[rsp], r8d
	mov	r8, QWORD PTR 136[rax]
	mov	r10d, DWORD PTR [r9]
	mov	ebp, DWORD PTR [r8]
	mov	r8, QWORD PTR 144[rax]
	mov	r11d, DWORD PTR [r8]
	mov	r8, QWORD PTR 224[rax]
	and	ebp, 16777215
	mov	r8d, DWORD PTR [r8]
	je	.L1
	mov	ebx, r10d
	shr	r10d, 16
	and	r11d, 4095
	and	ebx, 4095
	and	r8d, 4095
	and	r10d, 4095
	and	ecx, 1
	mov	DWORD PTR -44[rsp], ebx
	mov	DWORD PTR -48[rsp], r11d
	mov	ebx, -16777216
	je	.L26
	sub	edx, 1
	mov	r15d, edx
	js	.L1
	mov	ecx, DWORD PTR x_start_init[rip]
	mov	rdx, QWORD PTR PreScale@GOTPCREL[rip]
	mov	rax, QWORD PTR 32[rax]
	mov	r9d, DWORD PTR hpass_minmax[rip]
	mov	r12d, DWORD PTR hpass_minmax[rip+4]
	mov	DWORD PTR -32[rsp], ecx
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR -40[rsp], rax
	mov	QWORD PTR -24[rsp], rcx
	.p2align 4,,10
	.p2align 3
.L11:
	mov	rcx, QWORD PTR -24[rsp]
	mov	eax, edi
	mov	r14d, r10d
	sar	r14d, 10
	add	edi, DWORD PTR -52[rsp]
	mov	r11d, DWORD PTR -32[rsp]
	imul	r14d, DWORD PTR -48[rsp]
	lea	rcx, [rcx+rax*4]
	xor	eax, eax
	test	esi, esi
	jle	.L9
	mov	QWORD PTR -64[rsp], rcx
	jmp	.L18
	.p2align 4,,10
	.p2align 3
.L27:
	mov	rcx, QWORD PTR -64[rsp]
	mov	r11d, edx
.L18:
	cmp	eax, r9d
	lea	edx, [r11+r8]
	mov	DWORD PTR [rcx+rax*4], 0
	jl	.L8
	cmp	r12d, eax
	jle	.L8
	mov	r13, QWORD PTR plim@GOTPCREL[rip]
	sar	r11d, 10
	add	r11d, r14d
	lea	r11d, 0[rbp+r11*4]
	mov	r13d, DWORD PTR 0[r13]
	movsx	r11, r11d
	cmp	r11, r13
	ja	.L8
	mov	rcx, QWORD PTR -40[rsp]
	and	ebx, -16711681
	mov	r11d, DWORD PTR [rcx+r11]
	mov	r13d, r11d
	shr	r13d, 24
	sal	r13d, 16
	or	ebx, r13d
	mov	r13d, r11d
	shr	r11d, 8
	shr	r13d, 16
	mov	rcx, r13
	mov	bh, cl
	mov	rcx, QWORD PTR -64[rsp]
	mov	bl, r11b
	mov	DWORD PTR [rcx+rax*4], ebx
	.p2align 4,,10
	.p2align 3
.L8:
	add	rax, 1
	cmp	esi, eax
	jg	.L27
.L9:
	sub	r15d, 1
	add	r10d, DWORD PTR -44[rsp]
	cmp	r15d, -1
	jne	.L11
.L1:
	pop	rbx
	.cfi_remember_state
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
.L26:
	.cfi_restore_state
	sub	edx, 1
	mov	DWORD PTR -40[rsp], edx
	js	.L1
	mov	ecx, DWORD PTR x_start_init[rip]
	mov	rdx, QWORD PTR PreScale@GOTPCREL[rip]
	mov	rax, QWORD PTR 32[rax]
	mov	r9d, DWORD PTR hpass_minmax[rip]
	mov	r12d, DWORD PTR hpass_minmax[rip+4]
	mov	DWORD PTR -24[rsp], ecx
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR -32[rsp], rax
	mov	QWORD PTR -16[rsp], rcx
	.p2align 4,,10
	.p2align 3
.L17:
	mov	rcx, QWORD PTR -16[rsp]
	mov	eax, edi
	mov	r15d, r10d
	sar	r15d, 10
	add	edi, DWORD PTR -52[rsp]
	mov	r11d, DWORD PTR -24[rsp]
	imul	r15d, DWORD PTR -48[rsp]
	lea	rcx, [rcx+rax*4]
	xor	eax, eax
	test	esi, esi
	jle	.L15
	mov	QWORD PTR -64[rsp], rcx
	jmp	.L19
	.p2align 4,,10
	.p2align 3
.L28:
	mov	rcx, QWORD PTR -64[rsp]
	mov	r11d, edx
.L19:
	cmp	eax, r9d
	lea	edx, [r11+r8]
	mov	DWORD PTR [rcx+rax*4], 0
	jl	.L14
	cmp	eax, r12d
	jge	.L14
	mov	r13, QWORD PTR plim@GOTPCREL[rip]
	sar	r11d, 10
	add	r11d, r15d
	lea	r11d, 0[rbp+r11*2]
	mov	r13d, DWORD PTR 0[r13]
	movsx	r14, r11d
	cmp	r14, r13
	ja	.L14
	mov	rcx, QWORD PTR -32[rsp]
	xor	r11d, 2
	and	ebx, -16711681
	movsx	r11, r11d
	movzx	r11d, WORD PTR [rcx+r11]
	mov	r13d, r11d
	and	r13d, 63488
	sal	r13d, 8
	or	ebx, r13d
	mov	r13d, r11d
	and	r11d, 62
	and	r13d, 1984
	sal	r11d, 2
	shr	r13d, 3
	mov	rcx, r13
	mov	bh, cl
	mov	rcx, QWORD PTR -64[rsp]
	mov	bl, r11b
	mov	DWORD PTR [rcx+rax*4], ebx
	.p2align 4,,10
	.p2align 3
.L14:
	add	rax, 1
	cmp	esi, eax
	jg	.L28
.L15:
	sub	DWORD PTR -40[rsp], 1
	add	r10d, DWORD PTR -44[rsp]
	cmp	DWORD PTR -40[rsp], -1
	jne	.L17
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
.LFE553:
	.size	do_frame_buffer_raw, .-do_frame_buffer_raw
	.p2align 4,,15
	.type	divot_filter, @function
divot_filter:
.LFB558:
	.cfi_startproc
	sub	rsp, 16
	.cfi_def_cfa_offset 24
	mov	eax, edx
	mov	DWORD PTR [rdi], esi
	and	eax, esi
	mov	DWORD PTR -88[rsp], edx
	mov	edx, ecx
	and	eax, edx
	mov	DWORD PTR -104[rsp], ecx
	cmp	al, 7
	je	.L29
	lea	rax, -88[rsp]
	mov	QWORD PTR -16[rsp], rdi
	mov	QWORD PTR -24[rsp], rax
	lea	rax, -104[rsp]
	mov	QWORD PTR -8[rsp], rax
	movzx	eax, BYTE PTR -85[rsp]
	mov	DWORD PTR -72[rsp], eax
	movzx	eax, BYTE PTR -86[rsp]
	mov	DWORD PTR -68[rsp], eax
	movzx	eax, BYTE PTR -87[rsp]
	mov	DWORD PTR -64[rsp], eax
	movzx	eax, BYTE PTR -101[rsp]
	movdqa	xmm2, XMMWORD PTR -72[rsp]
	mov	DWORD PTR -40[rsp], eax
	movzx	eax, BYTE PTR -102[rsp]
	mov	DWORD PTR -36[rsp], eax
	movzx	eax, BYTE PTR -103[rsp]
	mov	DWORD PTR -32[rsp], eax
	mov	eax, esi
	shr	eax, 24
	movdqa	xmm0, XMMWORD PTR -40[rsp]
	mov	DWORD PTR -56[rsp], eax
	mov	eax, esi
	shr	eax, 16
	psubd	xmm2, xmm0
	movdqa	xmm4, XMMWORD PTR -40[rsp]
	movzx	eax, al
	mov	DWORD PTR -52[rsp], eax
	mov	rax, rsi
	movzx	esi, ah
	mov	DWORD PTR -48[rsp], esi
	movdqa	xmm1, XMMWORD PTR -56[rsp]
	psubd	xmm1, xmm0
	pxor	xmm0, xmm0
	movdqa	xmm3, xmm1
	movdqa	xmm5, xmm0
	pand	xmm3, xmm2
	movdqa	xmm6, xmm0
	psubd	xmm5, xmm2
	movdqa	xmm2, xmm5
	psubd	xmm6, xmm1
	movdqa	xmm7, xmm0
	movdqa	xmm1, xmm4
	pand	xmm2, xmm6
	por	xmm3, xmm2
	movdqa	XMMWORD PTR -120[rsp], xmm3
	mov	eax, DWORD PTR -120[rsp]
	movdqa	XMMWORD PTR -40[rsp], xmm3
	sar	eax, 31
	add	eax, 2
	cdqe
	mov	rax, QWORD PTR -24[rsp+rax*8]
	movzx	eax, BYTE PTR 3[rax]
	mov	BYTE PTR 3[rdi], al
	mov	eax, DWORD PTR -36[rsp]
	sar	eax, 31
	add	eax, 2
	cdqe
	mov	rax, QWORD PTR -24[rsp+rax*8]
	movzx	eax, BYTE PTR 2[rax]
	mov	BYTE PTR 2[rdi], al
	mov	eax, DWORD PTR -32[rsp]
	sar	eax, 31
	add	eax, 2
	cdqe
	mov	rax, QWORD PTR -24[rsp+rax*8]
	movzx	eax, BYTE PTR 1[rax]
	mov	BYTE PTR 1[rdi], al
	movdqa	xmm3, XMMWORD PTR -72[rsp]
	movdqa	xmm2, XMMWORD PTR -56[rsp]
	psubd	xmm1, xmm3
	psubd	xmm0, xmm1
	psubd	xmm2, xmm3
	movdqa	xmm3, xmm2
	psubd	xmm7, xmm2
	movdqa	xmm2, xmm7
	pand	xmm3, xmm1
	pand	xmm2, xmm0
	movdqa	XMMWORD PTR -40[rsp], xmm1
	por	xmm3, xmm2
	movdqa	XMMWORD PTR -56[rsp], xmm7
	movdqa	XMMWORD PTR -120[rsp], xmm3
	movdqa	XMMWORD PTR -72[rsp], xmm3
	mov	eax, DWORD PTR -120[rsp]
	shr	eax, 31
	mov	rax, QWORD PTR -24[rsp+rax*8]
	movzx	eax, BYTE PTR 3[rax]
	mov	BYTE PTR 3[rdi], al
	mov	eax, DWORD PTR -68[rsp]
	shr	eax, 31
	mov	rax, QWORD PTR -24[rsp+rax*8]
	movzx	eax, BYTE PTR 2[rax]
	mov	BYTE PTR 2[rdi], al
	mov	eax, DWORD PTR -64[rsp]
	shr	eax, 31
	mov	rax, QWORD PTR -24[rsp+rax*8]
	movzx	eax, BYTE PTR 1[rax]
	mov	BYTE PTR 1[rdi], al
.L29:
	add	rsp, 16
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE558:
	.size	divot_filter, .-divot_filter
	.p2align 4,,15
	.type	video_max_optimized, @function
video_max_optimized:
.LFB564:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	cmp	ecx, 1
	mov	r11d, DWORD PTR [rdi]
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
	jle	.L63
	lea	r9, 4[rdi]
	mov	ebx, r11d
	mov	r10d, r11d
	mov	ebp, r11d
	mov	eax, 1
	xor	r14d, r14d
	xor	r13d, r13d
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L85:
	cmp	r8d, ebx
	jae	.L65
	mov	r12d, r8d
	mov	r14d, eax
	mov	r8d, r10d
	mov	ebp, ebx
.L37:
	add	eax, 1
	add	r9, 4
	cmp	eax, ecx
	je	.L38
.L86:
	mov	r10d, r8d
	mov	ebx, r12d
.L39:
	mov	r8d, DWORD PTR [r9]
	cmp	r8d, r10d
	jbe	.L85
	mov	r13d, eax
	add	eax, 1
	add	r9, 4
	cmp	eax, ecx
	mov	r12d, ebx
	mov	r11d, r10d
	jne	.L86
.L38:
	cmp	r8d, r11d
	je	.L40
	lea	eax, 1[r13]
	cmp	ecx, eax
	jle	.L40
	movsx	r8, r13d
	lea	r9d, -1[rcx]
	mov	r10d, ecx
	lea	rbx, [rdi+r8*4]
	sub	r9d, r13d
	lea	r8, 4[rbx]
	and	r8d, 15
	shr	r8, 2
	neg	r8
	and	r8d, 3
	cmp	r8d, r9d
	cmova	r8d, r9d
	sub	r10d, r13d
	sub	r10d, 1
	cmp	r10d, 8
	cmovbe	r8d, r10d
	test	r8d, r8d
	je	.L42
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	r11d, eax
	cmovb	r11d, eax
	cmp	r8d, 1
	lea	eax, 2[r13]
	jbe	.L43
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	r11d, eax
	cmovb	r11d, eax
	cmp	r8d, 2
	lea	eax, 3[r13]
	jbe	.L43
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	r11d, eax
	cmovb	r11d, eax
	cmp	r8d, 3
	lea	eax, 4[r13]
	jbe	.L43
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	r11d, eax
	cmovb	r11d, eax
	cmp	r8d, 4
	lea	eax, 5[r13]
	jbe	.L43
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	r11d, eax
	cmovb	r11d, eax
	cmp	r8d, 5
	lea	eax, 6[r13]
	jbe	.L43
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	r11d, eax
	cmovb	r11d, eax
	cmp	r8d, 6
	lea	eax, 7[r13]
	jbe	.L43
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	r11d, eax
	cmovb	r11d, eax
	cmp	r8d, 7
	lea	eax, 8[r13]
	jbe	.L43
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	r11d, eax
	cmovb	r11d, eax
	lea	eax, 9[r13]
.L43:
	cmp	r9d, r8d
	je	.L40
.L42:
	sub	r10d, r8d
	mov	r15d, r8d
	mov	r9d, r10d
	shr	r9d, 2
	lea	r13d, 0[0+r9*4]
	test	r13d, r13d
	je	.L45
	mov	DWORD PTR -12[rsp], r11d
	lea	rbx, 4[rbx+r15*4]
	xor	r8d, r8d
	movd	xmm7, DWORD PTR -12[rsp]
	movdqa	xmm0, XMMWORD PTR .LC0[rip]
	pshufd	xmm1, xmm7, 0
.L51:
	movdqa	xmm3, XMMWORD PTR [rbx]
	add	r8d, 1
	movdqa	xmm2, xmm1
	add	rbx, 16
	movdqa	xmm4, xmm3
	cmp	r8d, r9d
	psubd	xmm2, xmm0
	psubd	xmm4, xmm0
	pcmpgtd	xmm2, xmm4
	movdqa	xmm4, xmm1
	movdqa	xmm1, xmm2
	pand	xmm4, xmm2
	pandn	xmm1, xmm3
	por	xmm1, xmm4
	jb	.L51
	movdqa	xmm5, xmm1
	add	eax, r13d
	movdqa	xmm4, xmm1
	cmp	r10d, r13d
	psrldq	xmm5, 8
	movdqa	xmm2, xmm5
	movdqa	xmm3, xmm5
	psubd	xmm4, xmm0
	psubd	xmm2, xmm0
	pcmpgtd	xmm2, xmm4
	pand	xmm3, xmm2
	pandn	xmm2, xmm1
	movdqa	xmm1, xmm2
	por	xmm1, xmm3
	movdqa	xmm6, xmm1
	movdqa	xmm7, xmm1
	psrldq	xmm6, 4
	movdqa	xmm2, xmm6
	movdqa	xmm3, xmm6
	psubd	xmm7, xmm0
	psubd	xmm2, xmm0
	pcmpgtd	xmm2, xmm7
	pand	xmm3, xmm2
	pandn	xmm2, xmm1
	por	xmm2, xmm3
	movdqa	xmm7, xmm2
	movd	DWORD PTR -12[rsp], xmm7
	mov	r11d, DWORD PTR -12[rsp]
	je	.L40
.L45:
	movsx	r8, eax
	mov	r8d, DWORD PTR [rdi+r8*4]
	cmp	r11d, r8d
	cmovb	r11d, r8d
	lea	r8d, 1[rax]
	cmp	ecx, r8d
	jle	.L40
	movsx	r8, r8d
	mov	r8d, DWORD PTR [rdi+r8*4]
	cmp	r11d, r8d
	cmovb	r11d, r8d
	add	eax, 2
	cmp	ecx, eax
	jle	.L40
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	r11d, eax
	cmovb	r11d, eax
.L40:
	cmp	ebp, r12d
	je	.L36
	lea	eax, 1[r14]
	cmp	ecx, eax
	jle	.L36
	movsx	r8, r14d
	lea	r9d, -1[rcx]
	mov	r10d, ecx
	lea	r12, [rdi+r8*4]
	sub	r9d, r14d
	lea	r8, 4[r12]
	and	r8d, 15
	shr	r8, 2
	neg	r8
	and	r8d, 3
	cmp	r8d, r9d
	cmova	r8d, r9d
	sub	r10d, r14d
	sub	r10d, 1
	cmp	r10d, 8
	cmovbe	r8d, r10d
	test	r8d, r8d
	je	.L53
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	ebp, eax
	cmova	ebp, eax
	cmp	r8d, 1
	lea	eax, 2[r14]
	jbe	.L54
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	ebp, eax
	cmova	ebp, eax
	cmp	r8d, 2
	lea	eax, 3[r14]
	jbe	.L54
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	ebp, eax
	cmova	ebp, eax
	cmp	r8d, 3
	lea	eax, 4[r14]
	jbe	.L54
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	ebp, eax
	cmova	ebp, eax
	cmp	r8d, 4
	lea	eax, 5[r14]
	jbe	.L54
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	ebp, eax
	cmova	ebp, eax
	cmp	r8d, 5
	lea	eax, 6[r14]
	jbe	.L54
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	ebp, eax
	cmova	ebp, eax
	cmp	r8d, 6
	lea	eax, 7[r14]
	jbe	.L54
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	ebp, eax
	cmova	ebp, eax
	cmp	r8d, 7
	lea	eax, 8[r14]
	jbe	.L54
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	ebp, eax
	cmova	ebp, eax
	lea	eax, 9[r14]
.L54:
	cmp	r8d, r9d
	je	.L36
.L53:
	sub	r10d, r8d
	mov	r9d, r8d
	mov	r13d, r10d
	shr	r13d, 2
	lea	ebx, 0[0+r13*4]
	test	ebx, ebx
	je	.L56
	mov	DWORD PTR -12[rsp], ebp
	lea	r9, 4[r12+r9*4]
	xor	r8d, r8d
	movd	xmm5, DWORD PTR -12[rsp]
	movdqa	xmm0, XMMWORD PTR .LC0[rip]
	pshufd	xmm1, xmm5, 0
.L62:
	movdqa	xmm3, XMMWORD PTR [r9]
	add	r8d, 1
	movdqa	xmm2, xmm1
	add	r9, 16
	movdqa	xmm4, xmm3
	cmp	r8d, r13d
	psubd	xmm2, xmm0
	psubd	xmm4, xmm0
	pcmpgtd	xmm2, xmm4
	pand	xmm3, xmm2
	pandn	xmm2, xmm1
	movdqa	xmm1, xmm2
	por	xmm1, xmm3
	jb	.L62
	movdqa	xmm5, xmm1
	add	eax, ebx
	movdqa	xmm4, xmm1
	cmp	ebx, r10d
	psrldq	xmm5, 8
	movdqa	xmm2, xmm5
	psubd	xmm4, xmm0
	psubd	xmm2, xmm0
	pcmpgtd	xmm2, xmm4
	pand	xmm1, xmm2
	pandn	xmm2, xmm5
	por	xmm2, xmm1
	movdqa	xmm6, xmm2
	movdqa	xmm7, xmm2
	psrldq	xmm6, 4
	movdqa	xmm1, xmm6
	psubd	xmm7, xmm0
	psubd	xmm1, xmm0
	pcmpgtd	xmm1, xmm7
	pand	xmm2, xmm1
	pandn	xmm1, xmm6
	por	xmm1, xmm2
	movdqa	xmm6, xmm1
	movd	DWORD PTR -12[rsp], xmm6
	mov	ebp, DWORD PTR -12[rsp]
	je	.L36
.L56:
	movsx	r8, eax
	mov	r8d, DWORD PTR [rdi+r8*4]
	cmp	ebp, r8d
	cmova	ebp, r8d
	lea	r8d, 1[rax]
	cmp	ecx, r8d
	jle	.L36
	movsx	r8, r8d
	mov	r8d, DWORD PTR [rdi+r8*4]
	cmp	ebp, r8d
	cmova	ebp, r8d
	add	eax, 2
	cmp	ecx, eax
	jle	.L36
	cdqe
	mov	eax, DWORD PTR [rdi+rax*4]
	cmp	ebp, eax
	cmova	ebp, eax
.L36:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	mov	DWORD PTR [rdx], r11d
	mov	DWORD PTR [rsi], ebp
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
	.p2align 4,,10
	.p2align 3
.L65:
	.cfi_restore_state
	mov	r12d, ebx
	mov	r8d, r10d
	jmp	.L37
.L63:
	mov	ebp, r11d
	jmp	.L36
	.cfi_endproc
.LFE564:
	.size	video_max_optimized, .-video_max_optimized
	.p2align 4,,15
	.type	vi_fetch_filter32, @function
vi_fetch_filter32:
.LFB555:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	shr	esi, 2
	add	edx, esi
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
	mov	rbx, rdi
	sub	rsp, 152
	.cfi_def_cfa_offset 208
	mov	rax, QWORD PTR idxlim32@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	ja	.L107
	mov	rsi, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	r9d, edx
	mov	rdi, QWORD PTR 32[rsi]
	mov	edi, DWORD PTR [rdi+r9*4]
	mov	r11d, edi
	mov	r12d, edi
	mov	r9d, edi
	shr	r11d, 5
	shr	r12d, 24
	shr	r9d, 16
	shr	edi, 8
	mov	r14d, r11d
	mov	r13d, r12d
	mov	ebp, r9d
	mov	r11d, edi
.L88:
	mov	r10, QWORD PTR 144[rsi]
	and	ecx, 1
	mov	r15d, ecx
	xor	r15d, 1
	mov	r10d, DWORD PTR [r10]
	neg	r15d
	mov	BYTE PTR 3[rbx], r13b
	or	r15d, r14d
	mov	BYTE PTR 2[rbx], bpl
	mov	BYTE PTR 1[rbx], r11b
	and	r15d, 7
	and	r10d, 4095
	cmp	r15b, 7
	mov	BYTE PTR [rbx], r15b
	je	.L123
	mov	r14d, edx
	lea	r13d, -2[rdx]
	lea	r11d, 2[rdx]
	sub	r14d, r10d
	add	edx, r10d
	xor	r15d, 7
	lea	ebp, -1[r14]
	lea	r10d, -1[rdx]
	add	r14d, 1
	add	edx, 1
	movzx	r9d, r9b
	movzx	r8d, dil
	cmp	eax, ebp
	movzx	r15d, r15b
	mov	DWORD PTR 48[rsp], r12d
	mov	DWORD PTR 80[rsp], r9d
	mov	DWORD PTR 112[rsp], r8d
	jae	.L124
.L118:
	mov	edi, 2
	mov	ebp, 1
.L101:
	cmp	eax, r14d
	jb	.L102
	mov	rcx, QWORD PTR 32[rsi]
	mov	r14d, DWORD PTR [rcx+r14*4]
	mov	ecx, r14d
	shr	ecx, 5
	and	ecx, 7
	cmp	ecx, 7
	jne	.L102
	mov	ecx, r14d
	shr	ecx, 24
	mov	DWORD PTR 48[rsp+rbp*4], ecx
	mov	ecx, r14d
	shr	ecx, 16
	and	ecx, 255
	mov	DWORD PTR 80[rsp+rbp*4], ecx
	mov	rcx, r14
	movzx	ecx, ch
	mov	DWORD PTR 112[rsp+rbp*4], ecx
	mov	ebp, edi
.L102:
	cmp	eax, r13d
	jb	.L103
	mov	rcx, QWORD PTR 32[rsi]
	mov	edi, DWORD PTR [rcx+r13*4]
	mov	ecx, edi
	shr	ecx, 5
	and	ecx, 7
	cmp	ecx, 7
	jne	.L103
	mov	r13d, edi
	mov	r14d, ebp
	mov	rcx, rdi
	shr	r13d, 24
	add	ebp, 1
	mov	DWORD PTR 48[rsp+r14*4], r13d
	mov	r13d, edi
	movzx	edi, ch
	shr	r13d, 16
	mov	DWORD PTR 112[rsp+r14*4], edi
	and	r13d, 255
	mov	DWORD PTR 80[rsp+r14*4], r13d
.L103:
	cmp	eax, r11d
	jb	.L104
	mov	rcx, QWORD PTR 32[rsi]
	mov	edi, DWORD PTR [rcx+r11*4]
	mov	ecx, edi
	shr	ecx, 5
	and	ecx, 7
	cmp	ecx, 7
	jne	.L104
	mov	r11d, edi
	mov	r14d, ebp
	mov	rcx, rdi
	shr	r11d, 24
	add	ebp, 1
	mov	DWORD PTR 48[rsp+r14*4], r11d
	mov	r11d, edi
	movzx	edi, ch
	shr	r11d, 16
	mov	DWORD PTR 112[rsp+r14*4], edi
	and	r11d, 255
	mov	DWORD PTR 80[rsp+r14*4], r11d
.L104:
	cmp	eax, r10d
	jb	.L105
	mov	rcx, QWORD PTR 32[rsi]
	mov	edi, DWORD PTR [rcx+r10*4]
	mov	ecx, edi
	shr	ecx, 5
	and	ecx, 7
	cmp	ecx, 7
	jne	.L105
	mov	r10d, edi
	mov	r11d, ebp
	mov	rcx, rdi
	shr	r10d, 24
	add	ebp, 1
	mov	DWORD PTR 48[rsp+r11*4], r10d
	mov	r10d, edi
	movzx	edi, ch
	shr	r10d, 16
	mov	DWORD PTR 112[rsp+r11*4], edi
	and	r10d, 255
	mov	DWORD PTR 80[rsp+r11*4], r10d
.L105:
	cmp	eax, edx
	jb	.L106
	mov	rax, QWORD PTR 32[rsi]
	mov	eax, DWORD PTR [rax+rdx*4]
	mov	edx, eax
	shr	edx, 5
	and	edx, 7
	cmp	edx, 7
	jne	.L106
	mov	ecx, eax
	mov	edx, ebp
	add	ebp, 1
	shr	ecx, 24
	mov	DWORD PTR 48[rsp+rdx*4], ecx
	mov	ecx, eax
	movzx	eax, ah
	shr	ecx, 16
	mov	DWORD PTR 112[rsp+rdx*4], eax
	and	ecx, 255
	mov	DWORD PTR 80[rsp+rdx*4], ecx
.L106:
	lea	r14, 16[rsp]
	lea	r13, 32[rsp]
	lea	rdi, 48[rsp]
	mov	ecx, ebp
	mov	DWORD PTR 8[rsp], r8d
	mov	DWORD PTR 4[rsp], r9d
	mov	rdx, r14
	mov	rsi, r13
	call	video_max_optimized
	lea	rdx, 4[r14]
	lea	rsi, 4[r13]
	lea	rdi, 80[rsp]
	mov	ecx, ebp
	call	video_max_optimized
	lea	rdx, 8[r14]
	lea	rsi, 8[r13]
	lea	rdi, 112[rsp]
	mov	ecx, ebp
	call	video_max_optimized
	mov	r9d, DWORD PTR 4[rsp]
	mov	eax, DWORD PTR 20[rsp]
	add	eax, DWORD PTR 36[rsp]
	mov	r8d, DWORD PTR 8[rsp]
	lea	edx, [r9+r9]
	sub	eax, edx
	lea	edx, [r8+r8]
	imul	eax, r15d
	add	eax, 4
	shr	eax, 3
	add	r9d, eax
	mov	eax, DWORD PTR 24[rsp]
	add	eax, DWORD PTR 40[rsp]
	mov	BYTE PTR 2[rbx], r9b
	sub	eax, edx
	lea	edx, [r12+r12]
	imul	eax, r15d
	add	eax, 4
	shr	eax, 3
	add	r8d, eax
	mov	eax, DWORD PTR 16[rsp]
	add	eax, DWORD PTR 32[rsp]
	mov	BYTE PTR 1[rbx], r8b
	sub	eax, edx
	imul	r15d, eax
	add	r15d, 4
	shr	r15d, 3
	add	r12d, r15d
	mov	BYTE PTR 3[rbx], r12b
.L87:
	add	rsp, 152
	.cfi_remember_state
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
	.p2align 4,,10
	.p2align 3
.L107:
	.cfi_restore_state
	xor	r11d, r11d
	xor	edi, edi
	xor	ebp, ebp
	xor	r9d, r9d
	xor	r13d, r13d
	xor	r12d, r12d
	xor	r14d, r14d
	mov	rsi, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	jmp	.L88
	.p2align 4,,10
	.p2align 3
.L124:
	mov	rcx, QWORD PTR 32[rsi]
	mov	edi, DWORD PTR [rcx+rbp*4]
	mov	ecx, edi
	shr	ecx, 5
	and	ecx, 7
	cmp	ecx, 7
	jne	.L118
	mov	ecx, edi
	mov	ebp, 2
	shr	ecx, 24
	mov	DWORD PTR 52[rsp], ecx
	mov	ecx, edi
	shr	ecx, 16
	and	ecx, 255
	mov	DWORD PTR 84[rsp], ecx
	mov	rcx, rdi
	movzx	edi, ch
	mov	DWORD PTR 116[rsp], edi
	mov	edi, 3
	jmp	.L101
	.p2align 4,,10
	.p2align 3
.L123:
	test	r8d, r8d
	je	.L87
	lea	r11d, [rdx+r10]
	lea	r8d, 0[0+r12*4]
	mov	ebp, edx
	movzx	r9d, r9b
	movzx	edi, dil
	sub	ebp, r10d
	lea	ecx, -1[r11]
	and	r8d, 992
	lea	r14d, 0[0+rdi*4]
	lea	r13d, -1[rbp]
	mov	DWORD PTR 4[rsp], ecx
	lea	ecx, -1[rdx]
	and	r14d, 992
	mov	DWORD PTR 8[rsp], ecx
	lea	ecx, 1[r11]
	mov	r15d, ecx
	mov	DWORD PTR 12[rsp], ecx
	mov	rcx, QWORD PTR vi_restore_table@GOTPCREL[rip]
	lea	r10, [rcx+r8*4]
	lea	r8d, 0[0+r9*4]
	and	r8d, 992
	cmp	eax, r15d
	lea	r8, [rcx+r8*4]
	lea	rcx, [rcx+r14*4]
	jb	.L91
	cmp	eax, r13d
	jae	.L125
.L109:
	xor	r13d, r13d
	xor	r14d, r14d
	xor	r15d, r15d
.L92:
	add	r12d, DWORD PTR [r10+r15]
	add	r9d, DWORD PTR [r8+r14]
	add	edi, DWORD PTR [rcx+r13]
	cmp	eax, ebp
	jb	.L110
	mov	r14, QWORD PTR 32[rsi]
	mov	r13d, ebp
	mov	r13d, DWORD PTR [r14+r13*4]
	mov	r14d, r13d
	mov	r15d, r13d
	shr	r13d, 11
	shr	r14d, 19
	shr	r15d, 27
	and	r13d, 31
	and	r14d, 31
	sal	r15, 2
	sal	r13, 2
	sal	r14, 2
.L94:
	add	ebp, 1
	add	r12d, DWORD PTR [r10+r15]
	add	r9d, DWORD PTR [r8+r14]
	add	edi, DWORD PTR [rcx+r13]
	cmp	eax, ebp
	jb	.L111
	mov	r13, QWORD PTR 32[rsi]
	mov	ebp, DWORD PTR 0[r13+rbp*4]
	mov	r13d, ebp
	mov	r14d, ebp
	shr	ebp, 11
	shr	r13d, 19
	shr	r14d, 27
	and	ebp, 31
	and	r13d, 31
	sal	r14, 2
	sal	rbp, 2
	sal	r13, 2
.L95:
	add	r12d, DWORD PTR [r10+r14]
	add	r9d, DWORD PTR [r8+r13]
	add	edi, DWORD PTR [rcx+rbp]
	cmp	eax, DWORD PTR 4[rsp]
	jb	.L112
	mov	r13d, DWORD PTR 4[rsp]
	mov	rbp, QWORD PTR 32[rsi]
	mov	ebp, DWORD PTR 0[rbp+r13*4]
	mov	r13d, ebp
	mov	r14d, ebp
	shr	ebp, 11
	shr	r13d, 19
	shr	r14d, 27
	and	ebp, 31
	and	r13d, 31
	sal	r14, 2
	sal	rbp, 2
	sal	r13, 2
.L96:
	add	r12d, DWORD PTR [r10+r14]
	add	r9d, DWORD PTR [r8+r13]
	add	edi, DWORD PTR [rcx+rbp]
	cmp	eax, r11d
	jb	.L113
	mov	rbp, QWORD PTR 32[rsi]
	mov	r11d, DWORD PTR 0[rbp+r11*4]
	mov	ebp, r11d
	mov	r13d, r11d
	shr	r11d, 11
	shr	ebp, 19
	shr	r13d, 27
	and	r11d, 31
	and	ebp, 31
	sal	r13, 2
	sal	r11, 2
	sal	rbp, 2
.L97:
	add	r12d, DWORD PTR [r10+r13]
	add	r9d, DWORD PTR [r8+rbp]
	add	edi, DWORD PTR [rcx+r11]
	cmp	eax, DWORD PTR 12[rsp]
	jb	.L114
	mov	ebp, DWORD PTR 12[rsp]
	mov	r11, QWORD PTR 32[rsi]
	mov	r11d, DWORD PTR [r11+rbp*4]
	mov	ebp, r11d
	mov	r13d, r11d
	shr	r11d, 11
	shr	ebp, 19
	shr	r13d, 27
	and	r11d, 31
	and	ebp, 31
	sal	r13, 2
	sal	r11, 2
	sal	rbp, 2
.L98:
	add	r12d, DWORD PTR [r10+r13]
	add	r9d, DWORD PTR [r8+rbp]
	add	edi, DWORD PTR [rcx+r11]
	cmp	eax, DWORD PTR 8[rsp]
	jb	.L115
	mov	ebp, DWORD PTR 8[rsp]
	mov	r11, QWORD PTR 32[rsi]
	mov	r11d, DWORD PTR [r11+rbp*4]
	mov	ebp, r11d
	mov	r13d, r11d
	shr	r11d, 11
	shr	ebp, 19
	shr	r13d, 27
	and	r11d, 31
	and	ebp, 31
	sal	r13, 2
	sal	r11, 2
	sal	rbp, 2
.L99:
	add	edx, 1
	add	r12d, DWORD PTR [r10+r13]
	add	r9d, DWORD PTR [r8+rbp]
	add	edi, DWORD PTR [rcx+r11]
	cmp	eax, edx
	jb	.L116
	mov	rax, QWORD PTR 32[rsi]
	mov	eax, DWORD PTR [rax+rdx*4]
	mov	edx, eax
	mov	esi, eax
	shr	eax, 11
	shr	edx, 19
	shr	esi, 27
	and	eax, 31
	and	edx, 31
	sal	rsi, 2
	sal	rax, 2
	sal	rdx, 2
.L100:
	add	r12d, DWORD PTR [r10+rsi]
	add	r9d, DWORD PTR [r8+rdx]
	add	edi, DWORD PTR [rcx+rax]
.L93:
	mov	BYTE PTR 3[rbx], r12b
	mov	BYTE PTR 2[rbx], r9b
	mov	BYTE PTR 1[rbx], dil
	jmp	.L87
	.p2align 4,,10
	.p2align 3
.L91:
	cmp	eax, r13d
	jb	.L109
	mov	r14, QWORD PTR 32[rsi]
	mov	r13d, DWORD PTR [r14+r13*4]
	mov	r14d, r13d
	mov	r15d, r13d
	shr	r13d, 11
	shr	r14d, 19
	shr	r15d, 27
	and	r13d, 31
	and	r14d, 31
	sal	r15, 2
	sal	r13, 2
	sal	r14, 2
	jmp	.L92
	.p2align 4,,10
	.p2align 3
.L116:
	xor	eax, eax
	xor	edx, edx
	xor	esi, esi
	jmp	.L100
	.p2align 4,,10
	.p2align 3
.L115:
	xor	r11d, r11d
	xor	ebp, ebp
	xor	r13d, r13d
	jmp	.L99
	.p2align 4,,10
	.p2align 3
.L114:
	xor	r11d, r11d
	xor	ebp, ebp
	xor	r13d, r13d
	jmp	.L98
	.p2align 4,,10
	.p2align 3
.L113:
	xor	r11d, r11d
	xor	ebp, ebp
	xor	r13d, r13d
	jmp	.L97
	.p2align 4,,10
	.p2align 3
.L112:
	xor	ebp, ebp
	xor	r13d, r13d
	xor	r14d, r14d
	jmp	.L96
	.p2align 4,,10
	.p2align 3
.L111:
	xor	ebp, ebp
	xor	r13d, r13d
	xor	r14d, r14d
	jmp	.L95
	.p2align 4,,10
	.p2align 3
.L110:
	xor	r13d, r13d
	xor	r14d, r14d
	xor	r15d, r15d
	jmp	.L94
	.p2align 4,,10
	.p2align 3
.L125:
	mov	rax, QWORD PTR 32[rsi]
	mov	esi, DWORD PTR [rax+r13*4]
	mov	r13d, esi
	shr	r13d, 27
	add	r12d, DWORD PTR [r10+r13*4]
	mov	r13d, esi
	shr	esi, 11
	and	esi, 31
	shr	r13d, 19
	add	edi, DWORD PTR [rcx+rsi*4]
	mov	esi, ebp
	and	r13d, 31
	mov	esi, DWORD PTR [rax+rsi*4]
	add	r9d, DWORD PTR [r8+r13*4]
	add	ebp, 1
	mov	r13d, esi
	shr	r13d, 27
	add	r12d, DWORD PTR [r10+r13*4]
	mov	r13d, esi
	shr	esi, 11
	and	esi, 31
	shr	r13d, 19
	add	edi, DWORD PTR [rcx+rsi*4]
	mov	esi, DWORD PTR [rax+rbp*4]
	and	r13d, 31
	add	r9d, DWORD PTR [r8+r13*4]
	mov	ebp, esi
	shr	ebp, 27
	add	r12d, DWORD PTR [r10+rbp*4]
	mov	ebp, esi
	shr	esi, 11
	and	esi, 31
	shr	ebp, 19
	add	edi, DWORD PTR [rcx+rsi*4]
	mov	esi, DWORD PTR 4[rsp]
	and	ebp, 31
	add	r9d, DWORD PTR [r8+rbp*4]
	mov	esi, DWORD PTR [rax+rsi*4]
	mov	ebp, esi
	shr	ebp, 27
	add	r12d, DWORD PTR [r10+rbp*4]
	mov	ebp, esi
	shr	esi, 11
	and	esi, 31
	shr	ebp, 19
	add	edi, DWORD PTR [rcx+rsi*4]
	mov	esi, DWORD PTR [rax+r11*4]
	and	ebp, 31
	add	r9d, DWORD PTR [r8+rbp*4]
	mov	r11d, esi
	shr	r11d, 27
	add	edx, 1
	add	r12d, DWORD PTR [r10+r11*4]
	mov	r11d, esi
	shr	esi, 11
	and	esi, 31
	shr	r11d, 19
	add	edi, DWORD PTR [rcx+rsi*4]
	mov	esi, r15d
	and	r11d, 31
	mov	esi, DWORD PTR [rax+rsi*4]
	add	r9d, DWORD PTR [r8+r11*4]
	mov	r11d, esi
	shr	r11d, 27
	add	r12d, DWORD PTR [r10+r11*4]
	mov	r11d, esi
	shr	esi, 11
	and	esi, 31
	shr	r11d, 19
	add	edi, DWORD PTR [rcx+rsi*4]
	mov	esi, DWORD PTR 8[rsp]
	and	r11d, 31
	add	r9d, DWORD PTR [r8+r11*4]
	mov	esi, DWORD PTR [rax+rsi*4]
	mov	eax, DWORD PTR [rax+rdx*4]
	mov	r11d, esi
	mov	edx, eax
	shr	r11d, 27
	shr	edx, 27
	add	r12d, DWORD PTR [r10+r11*4]
	mov	r11d, esi
	shr	esi, 11
	shr	r11d, 19
	add	r12d, DWORD PTR [r10+rdx*4]
	mov	edx, eax
	and	r11d, 31
	and	esi, 31
	shr	edx, 19
	shr	eax, 11
	add	r9d, DWORD PTR [r8+r11*4]
	add	edi, DWORD PTR [rcx+rsi*4]
	and	edx, 31
	and	eax, 31
	add	r9d, DWORD PTR [r8+rdx*4]
	add	edi, DWORD PTR [rcx+rax*4]
	jmp	.L93
	.cfi_endproc
.LFE555:
	.size	vi_fetch_filter32, .-vi_fetch_filter32
	.p2align 4,,15
	.type	vi_fetch_filter16, @function
vi_fetch_filter16:
.LFB554:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	lea	r10d, [rsi+rdx*2]
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	shr	r10d
	and	r10d, 8388607
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
	mov	rbx, rdi
	sub	rsp, 152
	.cfi_def_cfa_offset 208
	mov	rdi, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rax, QWORD PTR 144[rdi]
	mov	r11d, DWORD PTR [rax]
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	and	r11w, 4095
	test	ecx, ecx
	mov	eax, DWORD PTR [rax]
	je	.L127
	cmp	r10d, eax
	jbe	.L168
	xor	r15d, r15d
	xor	r9d, r9d
	xor	r10d, r10d
	xor	r13d, r13d
	xor	r14d, r14d
	xor	ecx, ecx
.L128:
	cmp	ecx, 7
	mov	BYTE PTR 3[rbx], r14b
	mov	BYTE PTR 2[rbx], r10b
	mov	BYTE PTR 1[rbx], r9b
	mov	BYTE PTR [rbx], r15b
	je	.L129
	shr	esi
	movzx	r11d, r11w
	xor	r15d, 7
	add	edx, esi
	movzx	r15d, r15b
	movzx	r14d, r14b
	mov	r12d, edx
	lea	esi, [rdx+r11]
	lea	edi, -2[rdx]
	sub	r12d, r11d
	lea	ecx, 2[rdx]
	movzx	r8d, r9b
	lea	r10d, -1[r12]
	lea	edx, -1[rsi]
	add	r12d, 1
	add	esi, 1
	mov	DWORD PTR 8[rsp], r15d
	mov	DWORD PTR 48[rsp], r14d
	cmp	eax, r10d
	mov	DWORD PTR 80[rsp], r13d
	mov	DWORD PTR 112[rsp], r8d
	jb	.L162
	mov	r9, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r11d, r10d
	mov	rbp, QWORD PTR hidden_bits@GOTPCREL[rip]
	xor	r11d, 1
	mov	r9, QWORD PTR [r9]
	movzx	r10d, BYTE PTR 0[rbp+r10]
	movzx	r9d, WORD PTR [r9+r11*2]
	mov	r11d, r9d
	and	r11d, 1
	add	r10d, r11d
	cmp	r10d, 4
	jne	.L162
	mov	r10d, r9d
	mov	ebp, 2
	shr	r10w, 8
	and	r10d, 248
	mov	DWORD PTR 52[rsp], r10d
	mov	r10d, r9d
	and	r9d, 62
	and	r10d, 1984
	sal	r9d, 2
	sar	r10d, 3
	cmp	eax, r12d
	mov	DWORD PTR 116[rsp], r9d
	mov	DWORD PTR 84[rsp], r10d
	mov	r10d, 3
	jae	.L169
	.p2align 4,,10
	.p2align 3
.L144:
	cmp	eax, edi
	jb	.L145
	mov	r9, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r10d, edi
	mov	r11, QWORD PTR hidden_bits@GOTPCREL[rip]
	xor	r10d, 1
	mov	r9, QWORD PTR [r9]
	movzx	edi, BYTE PTR [r11+rdi]
	movzx	r9d, WORD PTR [r9+r10*2]
	mov	r10d, r9d
	and	r10d, 1
	add	edi, r10d
	cmp	edi, 4
	jne	.L145
	mov	r10d, r9d
	mov	edi, ebp
	add	ebp, 1
	shr	r10w, 8
	and	r10d, 248
	mov	DWORD PTR 48[rsp+rdi*4], r10d
	mov	r10d, r9d
	and	r9d, 62
	and	r10d, 1984
	sal	r9d, 2
	sar	r10d, 3
	mov	DWORD PTR 112[rsp+rdi*4], r9d
	mov	DWORD PTR 80[rsp+rdi*4], r10d
.L145:
	cmp	eax, ecx
	jb	.L146
	mov	rdi, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r9d, ecx
	mov	r10, QWORD PTR hidden_bits@GOTPCREL[rip]
	xor	r9d, 1
	mov	rdi, QWORD PTR [rdi]
	movzx	ecx, BYTE PTR [r10+rcx]
	movzx	edi, WORD PTR [rdi+r9*2]
	mov	r9d, edi
	and	r9d, 1
	add	ecx, r9d
	cmp	ecx, 4
	jne	.L146
	mov	r9d, edi
	mov	ecx, ebp
	add	ebp, 1
	shr	r9w, 8
	and	r9d, 248
	mov	DWORD PTR 48[rsp+rcx*4], r9d
	mov	r9d, edi
	and	edi, 62
	and	r9d, 1984
	sal	edi, 2
	sar	r9d, 3
	mov	DWORD PTR 112[rsp+rcx*4], edi
	mov	DWORD PTR 80[rsp+rcx*4], r9d
.L146:
	cmp	eax, edx
	jb	.L147
	mov	rcx, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	edi, edx
	mov	r9, QWORD PTR hidden_bits@GOTPCREL[rip]
	xor	edi, 1
	mov	rcx, QWORD PTR [rcx]
	movzx	edx, BYTE PTR [r9+rdx]
	movzx	ecx, WORD PTR [rcx+rdi*2]
	mov	edi, ecx
	and	edi, 1
	add	edx, edi
	cmp	edx, 4
	jne	.L147
	mov	edi, ecx
	mov	edx, ebp
	add	ebp, 1
	shr	di, 8
	and	edi, 248
	mov	DWORD PTR 48[rsp+rdx*4], edi
	mov	edi, ecx
	and	ecx, 62
	and	edi, 1984
	sal	ecx, 2
	sar	edi, 3
	mov	DWORD PTR 112[rsp+rdx*4], ecx
	mov	DWORD PTR 80[rsp+rdx*4], edi
.L147:
	cmp	eax, esi
	jb	.L148
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	edx, esi
	xor	edx, 1
	mov	rax, QWORD PTR [rax]
	movzx	eax, WORD PTR [rax+rdx*2]
	mov	rdx, QWORD PTR hidden_bits@GOTPCREL[rip]
	movzx	edx, BYTE PTR [rdx+rsi]
	mov	ecx, eax
	and	ecx, 1
	add	edx, ecx
	cmp	edx, 4
	jne	.L148
	mov	ecx, eax
	mov	edx, ebp
	add	ebp, 1
	shr	cx, 8
	and	ecx, 248
	mov	DWORD PTR 48[rsp+rdx*4], ecx
	mov	ecx, eax
	and	eax, 62
	and	ecx, 1984
	sal	eax, 2
	sar	ecx, 3
	mov	DWORD PTR 112[rsp+rdx*4], eax
	mov	DWORD PTR 80[rsp+rdx*4], ecx
.L148:
	lea	r15, 16[rsp]
	lea	r12, 32[rsp]
	lea	rdi, 48[rsp]
	mov	ecx, ebp
	mov	DWORD PTR 12[rsp], r8d
	mov	rdx, r15
	mov	rsi, r12
	call	video_max_optimized
	lea	rdx, 4[r15]
	lea	rsi, 4[r12]
	lea	rdi, 80[rsp]
	mov	ecx, ebp
	call	video_max_optimized
	lea	rdx, 8[r15]
	lea	rsi, 8[r12]
	lea	rdi, 112[rsp]
	mov	ecx, ebp
	call	video_max_optimized
	mov	eax, DWORD PTR 20[rsp]
	add	eax, DWORD PTR 36[rsp]
	lea	edx, [r13+r13]
	mov	esi, DWORD PTR 8[rsp]
	mov	r8d, DWORD PTR 12[rsp]
	sub	eax, edx
	lea	ecx, [r8+r8]
	imul	eax, esi
	add	eax, 4
	shr	eax, 3
	lea	edx, [rax+r13]
	mov	eax, DWORD PTR 24[rsp]
	add	eax, DWORD PTR 40[rsp]
	mov	BYTE PTR 2[rbx], dl
	sub	eax, ecx
	lea	ecx, [r14+r14]
	imul	eax, esi
	add	eax, 4
	shr	eax, 3
	add	r8d, eax
	mov	eax, DWORD PTR 16[rsp]
	add	eax, DWORD PTR 32[rsp]
	mov	BYTE PTR 1[rbx], r8b
	sub	eax, ecx
	imul	eax, esi
	add	eax, 4
	shr	eax, 3
	add	eax, r14d
	mov	BYTE PTR 3[rbx], al
	jmp	.L126
	.p2align 4,,10
	.p2align 3
.L127:
	cmp	r10d, eax
	jbe	.L170
	xor	r9d, r9d
	xor	ecx, ecx
	xor	r13d, r13d
	xor	r14d, r14d
.L131:
	mov	BYTE PTR 3[rbx], r14b
	mov	BYTE PTR 2[rbx], cl
	mov	BYTE PTR 1[rbx], r9b
	mov	BYTE PTR [rbx], 7
.L129:
	test	r8d, r8d
	jne	.L171
.L126:
	add	rsp, 152
	.cfi_remember_state
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
	.p2align 4,,10
	.p2align 3
.L170:
	.cfi_restore_state
	mov	rcx, QWORD PTR rdram_16@GOTPCREL[rip]
	xor	r10d, 1
	mov	rcx, QWORD PTR [rcx]
	movzx	r9d, WORD PTR [rcx+r10*2]
	mov	rcx, r9
	mov	r13d, r9d
	and	r9d, 62
	movzx	ecx, ch
	and	r13d, 1984
	sal	r9d, 2
	mov	r14d, ecx
	shr	r13d, 3
	and	r14d, -8
	mov	ecx, r13d
	jmp	.L131
	.p2align 4,,10
	.p2align 3
.L168:
	mov	rcx, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r9d, r10d
	xor	r9d, 1
	mov	rcx, QWORD PTR [rcx]
	movzx	r9d, WORD PTR [rcx+r9*2]
	mov	rcx, QWORD PTR hidden_bits@GOTPCREL[rip]
	movzx	ecx, BYTE PTR [rcx+r10]
	movzx	r14d, r9w
	mov	r13d, r9d
	and	r9d, 62
	and	r13d, 1984
	sal	r9d, 2
	shr	r13d, 3
	lea	ecx, [rcx+r14*4]
	shr	r14d, 8
	mov	r10d, r13d
	and	r14d, -8
	and	ecx, 7
	mov	r15d, ecx
	jmp	.L128
	.p2align 4,,10
	.p2align 3
.L162:
	cmp	eax, r12d
	mov	r10d, 2
	mov	ebp, 1
	jb	.L144
.L169:
	mov	r9, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r11d, r12d
	mov	r15, QWORD PTR hidden_bits@GOTPCREL[rip]
	xor	r11d, 1
	mov	r9, QWORD PTR [r9]
	movzx	r12d, BYTE PTR [r15+r12]
	movzx	r9d, WORD PTR [r9+r11*2]
	mov	r11d, r9d
	and	r11d, 1
	add	r11d, r12d
	cmp	r11d, 4
	jne	.L144
	mov	r11d, r9d
	shr	r11w, 8
	and	r11d, 248
	mov	DWORD PTR 48[rsp+rbp*4], r11d
	mov	r11d, r9d
	and	r9d, 62
	and	r11d, 1984
	sal	r9d, 2
	sar	r11d, 3
	mov	DWORD PTR 112[rsp+rbp*4], r9d
	mov	DWORD PTR 80[rsp+rbp*4], r11d
	mov	ebp, r10d
	jmp	.L144
	.p2align 4,,10
	.p2align 3
.L171:
	shr	esi
	movzx	r11d, r11w
	movzx	r14d, r14b
	add	edx, esi
	mov	rcx, QWORD PTR vi_restore_table@GOTPCREL[rip]
	movzx	r9d, r9b
	mov	ebp, edx
	lea	r8d, 0[0+r9*4]
	sub	ebp, r11d
	add	r11d, edx
	lea	esi, -1[r11]
	lea	r12d, 1[r11]
	movsx	r8, r8d
	lea	r15d, -1[rbp]
	mov	DWORD PTR 8[rsp], esi
	lea	esi, -1[rdx]
	cmp	r12d, eax
	mov	DWORD PTR 12[rsp], esi
	lea	esi, 0[0+r14*4]
	movsx	rsi, esi
	lea	r10, [rcx+rsi*4]
	lea	esi, 0[0+r13*4]
	movsx	rsi, esi
	lea	rsi, [rcx+rsi*4]
	lea	rcx, [rcx+r8*4]
	ja	.L133
	cmp	r15d, eax
	jbe	.L172
.L153:
	xor	edi, edi
	xor	r8d, r8d
	xor	r15d, r15d
.L134:
	add	r14d, DWORD PTR [r10+r15]
	add	r13d, DWORD PTR [rsi+r8]
	add	r9d, DWORD PTR [rcx+rdi]
	cmp	ebp, eax
	ja	.L154
	mov	rdi, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r8d, ebp
	xor	r8d, 1
	mov	rdi, QWORD PTR [rdi]
	movzx	edi, WORD PTR [rdi+r8*2]
	mov	r15d, edi
	mov	r8d, edi
	shr	di
	shr	r15w, 11
	shr	r8w, 6
	and	edi, 31
	movzx	r15d, r15w
	and	r8d, 31
	sal	rdi, 2
	sal	r15, 2
	sal	r8, 2
.L136:
	add	ebp, 1
	add	r14d, DWORD PTR [r10+r15]
	add	r13d, DWORD PTR [rsi+r8]
	add	r9d, DWORD PTR [rcx+rdi]
	cmp	ebp, eax
	ja	.L155
	mov	rdi, QWORD PTR rdram_16@GOTPCREL[rip]
	xor	ebp, 1
	mov	rdi, QWORD PTR [rdi]
	movzx	edi, WORD PTR [rdi+rbp*2]
	mov	ebp, edi
	mov	r8d, edi
	shr	di
	shr	bp, 11
	shr	r8w, 6
	and	edi, 31
	movzx	ebp, bp
	and	r8d, 31
	sal	rdi, 2
	sal	rbp, 2
	sal	r8, 2
.L137:
	add	r13d, DWORD PTR [rsi+r8]
	add	r14d, DWORD PTR [r10+rbp]
	add	r9d, DWORD PTR [rcx+rdi]
	cmp	DWORD PTR 8[rsp], eax
	mov	r8d, r13d
	ja	.L156
	mov	rdi, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	ebp, DWORD PTR 8[rsp]
	mov	rdi, QWORD PTR [rdi]
	xor	ebp, 1
	movzx	edi, WORD PTR [rdi+rbp*2]
	mov	r13d, edi
	mov	ebp, edi
	shr	di
	shr	r13w, 11
	shr	bp, 6
	and	edi, 31
	movzx	r13d, r13w
	and	ebp, 31
	sal	rdi, 2
	sal	r13, 2
	sal	rbp, 2
.L138:
	add	r14d, DWORD PTR [r10+r13]
	add	r8d, DWORD PTR [rsi+rbp]
	add	r9d, DWORD PTR [rcx+rdi]
	cmp	r11d, eax
	ja	.L157
	mov	rdi, QWORD PTR rdram_16@GOTPCREL[rip]
	xor	r11d, 1
	mov	rdi, QWORD PTR [rdi]
	movzx	edi, WORD PTR [rdi+r11*2]
	mov	ebp, edi
	mov	r11d, edi
	shr	di
	shr	bp, 11
	shr	r11w, 6
	and	edi, 31
	movzx	ebp, bp
	and	r11d, 31
	sal	rdi, 2
	sal	rbp, 2
	sal	r11, 2
.L139:
	add	r14d, DWORD PTR [r10+rbp]
	add	r8d, DWORD PTR [rsi+r11]
	add	r9d, DWORD PTR [rcx+rdi]
	cmp	r12d, eax
	ja	.L158
	mov	rdi, QWORD PTR rdram_16@GOTPCREL[rip]
	xor	r12d, 1
	mov	rdi, QWORD PTR [rdi]
	movzx	edi, WORD PTR [rdi+r12*2]
	mov	ebp, edi
	mov	r11d, edi
	shr	di
	shr	bp, 11
	shr	r11w, 6
	and	edi, 31
	movzx	ebp, bp
	and	r11d, 31
	sal	rdi, 2
	sal	rbp, 2
	sal	r11, 2
.L140:
	add	r14d, DWORD PTR [r10+rbp]
	add	r8d, DWORD PTR [rsi+r11]
	add	r9d, DWORD PTR [rcx+rdi]
	cmp	DWORD PTR 12[rsp], eax
	ja	.L159
	mov	rdi, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r11d, DWORD PTR 12[rsp]
	mov	rdi, QWORD PTR [rdi]
	xor	r11d, 1
	movzx	edi, WORD PTR [rdi+r11*2]
	mov	ebp, edi
	mov	r11d, edi
	shr	di
	shr	bp, 11
	shr	r11w, 6
	and	edi, 31
	movzx	ebp, bp
	and	r11d, 31
	sal	rdi, 2
	sal	rbp, 2
	sal	r11, 2
.L141:
	add	edx, 1
	add	r14d, DWORD PTR [r10+rbp]
	add	r8d, DWORD PTR [rsi+r11]
	add	r9d, DWORD PTR [rcx+rdi]
	cmp	eax, edx
	jb	.L160
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	xor	edx, 1
	mov	rax, QWORD PTR [rax]
	movzx	eax, WORD PTR [rax+rdx*2]
	mov	edi, eax
	mov	edx, eax
	shr	ax
	shr	di, 11
	shr	dx, 6
	and	eax, 31
	movzx	edi, di
	and	edx, 31
	sal	rax, 2
	sal	rdi, 2
	sal	rdx, 2
.L142:
	add	r14d, DWORD PTR [r10+rdi]
	add	r8d, DWORD PTR [rsi+rdx]
	add	r9d, DWORD PTR [rcx+rax]
.L135:
	mov	BYTE PTR 3[rbx], r14b
	mov	BYTE PTR 2[rbx], r8b
	mov	BYTE PTR 1[rbx], r9b
	jmp	.L126
	.p2align 4,,10
	.p2align 3
.L133:
	cmp	r15d, eax
	ja	.L153
	mov	rdi, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r8d, r15d
	xor	r8d, 1
	mov	rdi, QWORD PTR [rdi]
	movzx	edi, WORD PTR [rdi+r8*2]
	mov	r8d, edi
	shr	r8w, 11
	movzx	r8d, r8w
	lea	r15, 0[0+r8*4]
	mov	r8d, edi
	shr	di
	shr	r8w, 6
	and	edi, 31
	and	r8d, 31
	sal	rdi, 2
	sal	r8, 2
	jmp	.L134
	.p2align 4,,10
	.p2align 3
.L160:
	xor	eax, eax
	xor	edx, edx
	xor	edi, edi
	jmp	.L142
	.p2align 4,,10
	.p2align 3
.L159:
	xor	edi, edi
	xor	r11d, r11d
	xor	ebp, ebp
	jmp	.L141
	.p2align 4,,10
	.p2align 3
.L158:
	xor	edi, edi
	xor	r11d, r11d
	xor	ebp, ebp
	jmp	.L140
	.p2align 4,,10
	.p2align 3
.L157:
	xor	edi, edi
	xor	r11d, r11d
	xor	ebp, ebp
	jmp	.L139
	.p2align 4,,10
	.p2align 3
.L156:
	xor	edi, edi
	xor	ebp, ebp
	xor	r13d, r13d
	jmp	.L138
	.p2align 4,,10
	.p2align 3
.L155:
	xor	edi, edi
	xor	r8d, r8d
	xor	ebp, ebp
	jmp	.L137
	.p2align 4,,10
	.p2align 3
.L154:
	xor	edi, edi
	xor	r8d, r8d
	xor	r15d, r15d
	jmp	.L136
	.p2align 4,,10
	.p2align 3
.L172:
	mov	rax, QWORD PTR 32[rdi]
	mov	edi, r15d
	xor	edi, 1
	movzx	edi, WORD PTR [rax+rdi*2]
	mov	r8d, edi
	shr	r8w, 11
	movzx	r8d, r8w
	add	r14d, DWORD PTR [r10+r8*4]
	mov	r8d, edi
	shr	di
	and	edi, 31
	shr	r8w, 6
	add	r9d, DWORD PTR [rcx+rdi*4]
	mov	edi, ebp
	and	r8d, 31
	xor	edi, 1
	add	r13d, DWORD PTR [rsi+r8*4]
	add	ebp, 1
	movzx	edi, WORD PTR [rax+rdi*2]
	xor	ebp, 1
	mov	r8d, r13d
	mov	r13d, edi
	shr	r13w, 11
	movzx	r13d, r13w
	add	r14d, DWORD PTR [r10+r13*4]
	mov	r13d, edi
	shr	di
	and	edi, 31
	shr	r13w, 6
	add	r9d, DWORD PTR [rcx+rdi*4]
	movzx	edi, WORD PTR [rax+rbp*2]
	and	r13d, 31
	add	r8d, DWORD PTR [rsi+r13*4]
	mov	ebp, edi
	shr	bp, 11
	movzx	ebp, bp
	add	r14d, DWORD PTR [r10+rbp*4]
	mov	ebp, edi
	shr	di
	and	edi, 31
	shr	bp, 6
	add	r9d, DWORD PTR [rcx+rdi*4]
	mov	edi, DWORD PTR 8[rsp]
	and	ebp, 31
	add	r8d, DWORD PTR [rsi+rbp*4]
	xor	edi, 1
	movzx	edi, WORD PTR [rax+rdi*2]
	mov	ebp, edi
	shr	bp, 11
	movzx	ebp, bp
	add	r14d, DWORD PTR [r10+rbp*4]
	mov	ebp, edi
	shr	bp, 6
	and	ebp, 31
	add	r8d, DWORD PTR [rsi+rbp*4]
	shr	di
	xor	r11d, 1
	and	edi, 31
	xor	r12d, 1
	add	edx, 1
	add	r9d, DWORD PTR [rcx+rdi*4]
	movzx	edi, WORD PTR [rax+r11*2]
	xor	edx, 1
	mov	r11d, edi
	shr	r11w, 11
	movzx	r11d, r11w
	add	r14d, DWORD PTR [r10+r11*4]
	mov	r11d, edi
	shr	di
	and	edi, 31
	shr	r11w, 6
	add	r9d, DWORD PTR [rcx+rdi*4]
	movzx	edi, WORD PTR [rax+r12*2]
	and	r11d, 31
	add	r8d, DWORD PTR [rsi+r11*4]
	mov	r11d, edi
	shr	r11w, 11
	movzx	r11d, r11w
	add	r14d, DWORD PTR [r10+r11*4]
	mov	r11d, edi
	shr	di
	and	edi, 31
	shr	r11w, 6
	add	r9d, DWORD PTR [rcx+rdi*4]
	mov	edi, DWORD PTR 12[rsp]
	and	r11d, 31
	add	r8d, DWORD PTR [rsi+r11*4]
	xor	edi, 1
	movzx	edi, WORD PTR [rax+rdi*2]
	movzx	eax, WORD PTR [rax+rdx*2]
	mov	r11d, edi
	mov	edx, eax
	shr	r11w, 11
	movzx	r11d, r11w
	add	r14d, DWORD PTR [r10+r11*4]
	mov	r11d, edi
	shr	di
	shr	r11w, 6
	and	edi, 31
	and	r11d, 31
	add	r9d, DWORD PTR [rcx+rdi*4]
	add	r8d, DWORD PTR [rsi+r11*4]
	shr	dx, 11
	movzx	edx, dx
	add	r14d, DWORD PTR [r10+rdx*4]
	mov	edx, eax
	shr	ax
	shr	dx, 6
	and	eax, 31
	and	edx, 31
	add	r9d, DWORD PTR [rcx+rax*4]
	add	r8d, DWORD PTR [rsi+rdx*4]
	jmp	.L135
	.cfi_endproc
.LFE554:
	.size	vi_fetch_filter16, .-vi_fetch_filter16
	.p2align 4,,15
	.globl	DisplayError
	.type	DisplayError, @function
DisplayError:
.LFB565:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, QWORD PTR stderr@GOTPCREL[rip]
	mov	rsi, QWORD PTR [rbx]
	call	fputs@PLT
	mov	rsi, QWORD PTR [rbx]
	mov	edi, 10
	pop	rbx
	.cfi_def_cfa_offset 8
	jmp	fputc@PLT
	.cfi_endproc
.LFE565:
	.size	DisplayError, .-DisplayError
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"rdp_update: vbus_clock_enable bit set in VI_CONTROL_REG register. Never run this code on your N64! It's rumored that turning this bit on will result in permanent damage to the hardware! Emulation will now continue."
	.text
	.p2align 4,,15
	.type	do_frame_buffer_proper, @function
do_frame_buffer_proper:
.LFB552:
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
	sub	rsp, 216
	.cfi_def_cfa_offset 272
	mov	rax, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	DWORD PTR 20[rsp], edx
	mov	DWORD PTR 196[rsp], ecx
	mov	DWORD PTR 180[rsp], edi
	mov	DWORD PTR 116[rsp], esi
	mov	rdx, QWORD PTR 232[rax]
	mov	rcx, QWORD PTR 144[rax]
	mov	DWORD PTR 184[rsp], r8d
	mov	ebp, DWORD PTR [rdx]
	mov	rdx, QWORD PTR 136[rax]
	mov	r12d, DWORD PTR [rcx]
	mov	rcx, QWORD PTR 224[rax]
	mov	rax, QWORD PTR 128[rax]
	mov	edx, DWORD PTR [rdx]
	mov	ecx, DWORD PTR [rcx]
	mov	ebx, DWORD PTR [rax]
	and	edx, 16777215
	mov	DWORD PTR 132[rsp], ecx
	mov	DWORD PTR 28[rsp], edx
	je	.L175
	test	bl, 32
	jne	.L232
.L177:
	mov	edx, DWORD PTR x_start_init[rip]
	mov	eax, edx
	sar	eax, 10
	sub	eax, 1
	mov	DWORD PTR 204[rsp], eax
	mov	eax, DWORD PTR 20[rsp]
	test	eax, eax
	jle	.L175
	mov	eax, ebp
	mov	DWORD PTR 60[rsp], edx
	lea	rdx, divot_array.21973[rip+10304]
	shr	eax, 16
	and	r12d, 4095
	and	ebp, 4095
	mov	DWORD PTR 172[rsp], eax
	mov	eax, ebx
	mov	QWORD PTR 144[rsp], rdx
	shr	eax, 4
	lea	rdx, divot_array.21973[rip]
	and	DWORD PTR 172[rsp], 4095
	mov	DWORD PTR 124[rsp], eax
	mov	eax, ebx
	and	DWORD PTR 124[rsp], 1
	shr	eax, 9
	mov	QWORD PTR 136[rsp], rdx
	lea	rdx, viaa_array.21972[rip+10304]
	xor	eax, 1
	mov	DWORD PTR 188[rsp], r12d
	and	eax, 1
	mov	ecx, eax
	mov	BYTE PTR 201[rsp], al
	mov	eax, ebx
	shr	eax, 16
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, viaa_array.21972[rip]
	and	eax, 1
	mov	DWORD PTR 192[rsp], ebp
	mov	DWORD PTR 108[rsp], 0
	mov	BYTE PTR 203[rsp], al
	mov	eax, ebx
	mov	QWORD PTR 32[rsp], rdx
	shr	eax, 2
	mov	DWORD PTR 112[rsp], 0
	mov	DWORD PTR [rsp], 0
	mov	DWORD PTR 128[rsp], eax
	mov	eax, ebx
	shr	ebx, 8
	xor	ebx, 1
	and	DWORD PTR 128[rsp], 2
	shr	eax, 2
	mov	edx, ebx
	and	eax, 1
	mov	DWORD PTR 8[rsp], 0
	and	edx, 1
	or	DWORD PTR 128[rsp], eax
	mov	DWORD PTR 176[rsp], 0
	mov	BYTE PTR 202[rsp], dl
	xor	eax, eax
	or	BYTE PTR 202[rsp], cl
	.p2align 4,,10
	.p2align 3
.L212:
	mov	ecx, DWORD PTR 172[rsp]
	lea	edx, 1[rax]
	shr	ecx, 10
	cmp	ecx, edx
	mov	DWORD PTR 168[rsp], ecx
	je	.L233
	cmp	eax, DWORD PTR 168[rsp]
	je	.L234
.L181:
	mov	edx, DWORD PTR 124[rsp]
	mov	eax, DWORD PTR 204[rsp]
	mov	ecx, DWORD PTR 108[rsp]
	test	edx, edx
	mov	DWORD PTR [rsp], eax
	mov	DWORD PTR 8[rsp], eax
	cmovne	ecx, eax
	mov	DWORD PTR 108[rsp], ecx
	mov	ecx, DWORD PTR 112[rsp]
	cmovne	ecx, eax
	mov	DWORD PTR 112[rsp], ecx
.L182:
	mov	rax, QWORD PTR PreScale@GOTPCREL[rip]
	mov	edx, DWORD PTR 180[rsp]
	mov	edi, DWORD PTR 168[rsp]
	mov	ecx, DWORD PTR 184[rsp]
	add	DWORD PTR 180[rsp], ecx
	mov	ecx, DWORD PTR 172[rsp]
	mov	rax, QWORD PTR [rax]
	mov	r15d, DWORD PTR 116[rsp]
	shr	ecx, 5
	lea	rax, [rax+rdx*4]
	mov	edx, DWORD PTR 188[rsp]
	mov	DWORD PTR 120[rsp], ecx
	and	ecx, 31
	mov	DWORD PTR 152[rsp], ecx
	imul	edi, edx
	mov	DWORD PTR 88[rsp], edi
	add	edi, edx
	test	r15d, r15d
	mov	DWORD PTR 92[rsp], edi
	jle	.L183
	mov	QWORD PTR 48[rsp], rax
	mov	eax, DWORD PTR 196[rsp]
	mov	DWORD PTR 16[rsp], 0
	and	eax, 1
	mov	QWORD PTR 64[rsp], rax
	movzx	eax, BYTE PTR 203[rsp]
	mov	DWORD PTR 24[rsp], eax
	jmp	.L210
	.p2align 4,,10
	.p2align 3
.L241:
	mov	rax, QWORD PTR 32[rsp]
	cmp	BYTE PTR 59[rsp], 0
	lea	rcx, [rax+r12]
	movzx	eax, BYTE PTR 1[rcx]
	movzx	edx, BYTE PTR 2[rcx]
	movzx	ecx, BYTE PTR 3[rcx]
	je	.L193
	mov	rdi, QWORD PTR 32[rsp]
	movsx	rbx, r11d
	mov	r10, QWORD PTR 40[rsp]
	sal	rbx, 2
	lea	r8, [rdi+rbx]
	movzx	esi, BYTE PTR 1[r8]
	movzx	edi, BYTE PTR 2[r8]
	movzx	r8d, BYTE PTR 3[r8]
.L231:
	add	r12, r10
	add	rbx, r10
	movzx	ebp, BYTE PTR 1[r12]
	movzx	r13d, BYTE PTR 2[r12]
	movzx	r9d, BYTE PTR 3[r12]
	mov	r12d, DWORD PTR 152[rsp]
	movzx	r10d, BYTE PTR 1[rbx]
	movzx	r11d, BYTE PTR 2[rbx]
	movzx	ebx, BYTE PTR 3[rbx]
	test	r12d, r12d
	je	.L203
	mov	r15d, DWORD PTR 152[rsp]
	movzx	r12d, cl
	sub	r9d, r12d
	imul	r9d, r15d
	add	r9d, 16
	shr	r9d, 5
	add	ecx, r9d
	movzx	r9d, dl
	sub	r13d, r9d
	movzx	r9d, al
	sub	ebp, r9d
	movzx	r9d, r8b
	sub	ebx, r9d
	movzx	r9d, dil
	sub	r11d, r9d
	movzx	r9d, sil
	sub	r10d, r9d
	imul	r13d, r15d
	imul	ebp, r15d
	add	r13d, 16
	imul	ebx, r15d
	add	ebp, 16
	shr	r13d, 5
	imul	r11d, r15d
	shr	ebp, 5
	add	edx, r13d
	add	eax, ebp
	add	ebx, 16
	imul	r10d, r15d
	add	r11d, 16
	shr	ebx, 5
	shr	r11d, 5
	add	r8d, ebx
	add	edi, r11d
	add	r10d, 16
	shr	r10d, 5
	add	esi, r10d
.L203:
	mov	r9d, DWORD PTR 104[rsp]
	and	r9d, 31
	je	.L193
	movzx	r10d, cl
	movzx	r8d, r8b
	movzx	edi, dil
	sub	r8d, r10d
	movzx	esi, sil
	imul	r8d, r9d
	add	r8d, 16
	shr	r8d, 5
	add	ecx, r8d
	movzx	r8d, dl
	sub	edi, r8d
	imul	edi, r9d
	add	edi, 16
	shr	edi, 5
	add	edx, edi
	movzx	edi, al
	sub	esi, edi
	imul	esi, r9d
	add	esi, 16
	shr	esi, 5
	add	eax, esi
.L193:
	mov	r14b, al
	movzx	ebp, cl
	movzx	r12d, al
	mov	rbx, r14
	mov	eax, DWORD PTR 128[rsp]
	mov	ecx, ebp
	mov	bh, dl
	sal	ecx, 16
	movzx	r13d, dl
	and	ebx, -16711681
	or	ebx, ecx
	cmp	eax, 2
	mov	r14d, ebx
	je	.L205
	cmp	eax, 3
	je	.L206
	cmp	eax, 1
	je	.L235
.L204:
	mov	eax, DWORD PTR 132[rsp]
	and	eax, 4095
	add	DWORD PTR 60[rsp], eax
	mov	rax, QWORD PTR 48[rsp]
	mov	DWORD PTR [rax], 0
	mov	eax, DWORD PTR 16[rsp]
	cmp	DWORD PTR hpass_minmax[rip], eax
	jg	.L209
	cmp	DWORD PTR hpass_minmax[rip+4], eax
	jle	.L209
	mov	rax, QWORD PTR 48[rsp]
	mov	DWORD PTR [rax], r14d
.L209:
	add	DWORD PTR 16[rsp], 1
	add	QWORD PTR 48[rsp], 4
	mov	eax, DWORD PTR 116[rsp]
	cmp	DWORD PTR 16[rsp], eax
	je	.L183
.L210:
	mov	esi, DWORD PTR 60[rsp]
	mov	edi, DWORD PTR 92[rsp]
	mov	eax, DWORD PTR 88[rsp]
	mov	ebx, esi
	sar	esi, 5
	sar	ebx, 10
	mov	DWORD PTR 104[rsp], esi
	lea	ebp, 1[rbx]
	lea	edx, -1[rbx]
	lea	r10d, [rbx+rax]
	lea	ecx, [rbx+rdi]
	lea	r11d, 2[rbx]
	mov	DWORD PTR 80[rsp], edx
	lea	edx, 0[rbp+rdi]
	add	eax, ebp
	mov	DWORD PTR 96[rsp], ecx
	mov	DWORD PTR 72[rsp], edx
	mov	edx, DWORD PTR 120[rsp]
	or	edx, esi
	movzx	esi, BYTE PTR 202[rsp]
	and	edx, 31
	setne	BYTE PTR 59[rsp]
	and	BYTE PTR 59[rsp], sil
	cmp	ebx, DWORD PTR 8[rsp]
	jg	.L236
	cmp	ebp, DWORD PTR 8[rsp]
	jg	.L237
	cmp	r11d, DWORD PTR 8[rsp]
	jg	.L187
	movsx	r12, ebp
	sal	r12, 2
.L185:
	cmp	ebx, DWORD PTR [rsp]
	jg	.L238
	cmp	ebp, DWORD PTR [rsp]
	jg	.L239
	cmp	r11d, DWORD PTR [rsp]
	jg	.L240
.L189:
	mov	r13d, DWORD PTR 124[rsp]
	test	r13d, r13d
	je	.L241
	add	ebx, 3
	cmp	DWORD PTR 8[rsp], ebx
	jl	.L242
.L194:
	cmp	DWORD PTR [rsp], ebx
	jl	.L243
.L195:
	cmp	ebp, DWORD PTR 112[rsp]
	jg	.L244
	cmp	r11d, DWORD PTR 112[rsp]
	jg	.L198
	mov	rax, QWORD PTR 136[rsp]
	lea	r13, [rax+r12]
.L197:
	cmp	ebp, DWORD PTR 108[rsp]
	jg	.L245
	cmp	r11d, DWORD PTR 108[rsp]
	jg	.L246
.L200:
	cmp	BYTE PTR 59[rsp], 0
	movzx	eax, BYTE PTR 1[r13]
	movzx	edx, BYTE PTR 2[r13]
	movzx	ecx, BYTE PTR 3[r13]
	je	.L193
	mov	rdi, QWORD PTR 136[rsp]
	movsx	rbx, r11d
	mov	r10, QWORD PTR 144[rsp]
	sal	rbx, 2
	lea	r8, [rdi+rbx]
	movzx	esi, BYTE PTR 1[r8]
	movzx	edi, BYTE PTR 2[r8]
	movzx	r8d, BYTE PTR 3[r8]
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L175:
	add	rsp, 216
	.cfi_remember_state
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
	.p2align 4,,10
	.p2align 3
.L238:
	.cfi_restore_state
	mov	rcx, QWORD PTR 64[rsp]
	movzx	r13d, BYTE PTR 201[rsp]
	lea	rax, vi_fetch_filter_func[rip]
	mov	rdi, QWORD PTR 40[rsp]
	mov	edx, DWORD PTR 80[rsp]
	add	edx, DWORD PTR 92[rsp]
	mov	DWORD PTR 156[rsp], r11d
	mov	r15, QWORD PTR [rax+rcx*8]
	movsx	rax, ebx
	mov	r9d, DWORD PTR 20[rsp]
	sal	rax, 2
	mov	r8d, DWORD PTR 24[rsp]
	mov	ecx, r13d
	add	rdi, rax
	mov	QWORD PTR [rsp], rax
	mov	esi, DWORD PTR 28[rsp]
	call	r15
	mov	rdi, QWORD PTR 40[rsp]
	mov	r9d, DWORD PTR 20[rsp]
	mov	ecx, r13d
	mov	r8d, DWORD PTR 24[rsp]
	mov	edx, DWORD PTR 96[rsp]
	mov	esi, DWORD PTR 28[rsp]
	add	rdi, r12
	call	r15
	mov	rdi, QWORD PTR 40[rsp]
	mov	rax, QWORD PTR [rsp]
	mov	ecx, r13d
	mov	r9d, DWORD PTR 20[rsp]
	mov	r8d, DWORD PTR 24[rsp]
	mov	edx, DWORD PTR 72[rsp]
	mov	esi, DWORD PTR 28[rsp]
	lea	rdi, 8[rdi+rax]
	call	r15
	mov	r11d, DWORD PTR 156[rsp]
	mov	DWORD PTR [rsp], r11d
	jmp	.L189
	.p2align 4,,10
	.p2align 3
.L236:
	mov	DWORD PTR 164[rsp], eax
	mov	rax, QWORD PTR 64[rsp]
	lea	rdx, vi_fetch_filter_func[rip]
	movzx	r13d, BYTE PTR 201[rsp]
	mov	rsi, QWORD PTR 32[rsp]
	movsx	r15, ebx
	sal	r15, 2
	mov	DWORD PTR 156[rsp], r11d
	mov	DWORD PTR 160[rsp], r10d
	mov	rax, QWORD PTR [rdx+rax*8]
	mov	edx, DWORD PTR 80[rsp]
	lea	r12, 4[r15]
	add	edx, DWORD PTR 88[rsp]
	lea	rdi, [rsi+r15]
	mov	r9d, DWORD PTR 20[rsp]
	mov	r8d, DWORD PTR 24[rsp]
	mov	ecx, r13d
	mov	esi, DWORD PTR 28[rsp]
	mov	QWORD PTR 8[rsp], rax
	call	rax
	mov	rsi, QWORD PTR 32[rsp]
	mov	r10d, DWORD PTR 160[rsp]
	mov	ecx, r13d
	mov	r9d, DWORD PTR 20[rsp]
	mov	r8d, DWORD PTR 24[rsp]
	mov	rax, QWORD PTR 8[rsp]
	lea	rdi, [rsi+r12]
	mov	edx, r10d
	mov	esi, DWORD PTR 28[rsp]
	call	rax
	mov	eax, DWORD PTR 164[rsp]
	mov	rdi, QWORD PTR 32[rsp]
	mov	ecx, r13d
	mov	r9d, DWORD PTR 20[rsp]
	mov	r8d, DWORD PTR 24[rsp]
	mov	esi, DWORD PTR 28[rsp]
	mov	edx, eax
	lea	rdi, 8[rdi+r15]
	mov	rax, QWORD PTR 8[rsp]
	call	rax
	mov	r11d, DWORD PTR 156[rsp]
	mov	DWORD PTR 8[rsp], r11d
	jmp	.L185
	.p2align 4,,10
	.p2align 3
.L237:
	mov	DWORD PTR 156[rsp], eax
	mov	rax, QWORD PTR 64[rsp]
	lea	rdx, vi_fetch_filter_func[rip]
	movzx	r15d, BYTE PTR 201[rsp]
	movsx	r12, ebp
	mov	DWORD PTR 8[rsp], r11d
	sal	r12, 2
	mov	r9d, DWORD PTR 20[rsp]
	mov	r8d, DWORD PTR 24[rsp]
	mov	r13, QWORD PTR [rdx+rax*8]
	mov	rax, QWORD PTR 32[rsp]
	mov	edx, r10d
	mov	esi, DWORD PTR 28[rsp]
	mov	ecx, r15d
	lea	rdi, [rax+r12]
	call	r13
	mov	rax, QWORD PTR 32[rsp]
	mov	r9d, DWORD PTR 20[rsp]
	mov	ecx, r15d
	mov	r8d, DWORD PTR 24[rsp]
	mov	esi, DWORD PTR 28[rsp]
	lea	rdi, 4[rax+r12]
	mov	eax, DWORD PTR 156[rsp]
	mov	edx, eax
	call	r13
	mov	r11d, DWORD PTR 8[rsp]
	jmp	.L185
	.p2align 4,,10
	.p2align 3
.L239:
	mov	rcx, QWORD PTR 64[rsp]
	lea	rax, vi_fetch_filter_func[rip]
	movzx	r15d, BYTE PTR 201[rsp]
	mov	DWORD PTR [rsp], r11d
	mov	r9d, DWORD PTR 20[rsp]
	mov	r8d, DWORD PTR 24[rsp]
	mov	edx, DWORD PTR 96[rsp]
	mov	r13, QWORD PTR [rax+rcx*8]
	mov	rax, QWORD PTR 40[rsp]
	mov	ecx, r15d
	mov	esi, DWORD PTR 28[rsp]
	lea	rdi, [rax+r12]
	call	r13
	mov	r11d, DWORD PTR [rsp]
	mov	rcx, QWORD PTR 40[rsp]
	mov	r9d, DWORD PTR 20[rsp]
	mov	r8d, DWORD PTR 24[rsp]
	mov	edx, DWORD PTR 72[rsp]
	mov	esi, DWORD PTR 28[rsp]
	movsx	rax, r11d
	lea	rdi, [rcx+rax*4]
	mov	ecx, r15d
	call	r13
	mov	r11d, DWORD PTR [rsp]
	jmp	.L189
	.p2align 4,,10
	.p2align 3
.L205:
	mov	rsi, QWORD PTR gamma_table@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rsi+rbp*4]
	mov	edx, DWORD PTR [rsi+r13*4]
	mov	r12d, DWORD PTR [rsi+r12*4]
.L208:
	movzx	ecx, cl
	and	ebx, -16711681
	sal	ecx, 16
	mov	r14d, ebx
	or	r14d, ecx
	mov	rax, r14
	mov	ah, dl
	mov	r14, rax
	mov	r14b, r12b
	jmp	.L204
	.p2align 4,,10
	.p2align 3
.L235:
	call	irand@PLT
	xor	ecx, ecx
	cmp	ebp, 254
	mov	edx, eax
	setle	cl
	sar	edx
	xor	esi, esi
	and	ecx, eax
	add	ecx, ebp
	cmp	r13d, 254
	setle	sil
	sar	eax, 3
	and	edx, esi
	xor	esi, esi
	add	edx, r13d
	cmp	r12d, 254
	setle	sil
	and	eax, esi
	add	r12d, eax
	jmp	.L208
	.p2align 4,,10
	.p2align 3
.L206:
	call	irand@PLT
	mov	esi, eax
	mov	edx, eax
	mov	rdi, QWORD PTR gamma_dither_table@GOTPCREL[rip]
	sar	esi, 6
	and	edx, 63
	sal	ebp, 6
	and	esi, 63
	sal	r13d, 6
	or	edx, ebp
	or	esi, r13d
	movsx	rdx, edx
	sal	r12d, 6
	movsx	rsi, esi
	mov	ecx, DWORD PTR [rdi+rdx*4]
	mov	edx, DWORD PTR [rdi+rsi*4]
	mov	esi, eax
	sar	eax, 9
	and	esi, 7
	and	eax, 56
	or	esi, r12d
	or	esi, eax
	movsx	rsi, esi
	mov	r12d, DWORD PTR [rdi+rsi*4]
	jmp	.L208
	.p2align 4,,10
	.p2align 3
.L187:
	mov	rdx, QWORD PTR 32[rsp]
	movsx	r12, r11d
	mov	r10, QWORD PTR 64[rsp]
	sal	r12, 2
	movzx	ecx, BYTE PTR 201[rsp]
	mov	DWORD PTR 8[rsp], r11d
	mov	r9d, DWORD PTR 20[rsp]
	mov	r8d, DWORD PTR 24[rsp]
	lea	rdi, [rdx+r12]
	mov	edx, eax
	lea	rax, vi_fetch_filter_func[rip]
	mov	esi, DWORD PTR 28[rsp]
	sub	r12, 4
	call	[QWORD PTR [rax+r10*8]]
	mov	r11d, DWORD PTR 8[rsp]
	jmp	.L185
	.p2align 4,,10
	.p2align 3
.L240:
	mov	rdx, QWORD PTR 40[rsp]
	movsx	rax, r11d
	mov	r10, QWORD PTR 64[rsp]
	movzx	ecx, BYTE PTR 201[rsp]
	mov	DWORD PTR [rsp], r11d
	mov	r9d, DWORD PTR 20[rsp]
	mov	r8d, DWORD PTR 24[rsp]
	lea	rdi, [rdx+rax*4]
	lea	rax, vi_fetch_filter_func[rip]
	mov	edx, DWORD PTR 72[rsp]
	mov	esi, DWORD PTR 28[rsp]
	call	[QWORD PTR [rax+r10*8]]
	mov	r11d, DWORD PTR [rsp]
	jmp	.L189
	.p2align 4,,10
	.p2align 3
.L245:
	mov	rcx, QWORD PTR 40[rsp]
	movsx	rbx, r11d
	mov	rsi, QWORD PTR 144[rsp]
	sal	rbx, 2
	mov	DWORD PTR 80[rsp], r11d
	lea	rax, -8[rbx]
	lea	r15, [rcx+r12]
	lea	rbp, [rcx+rbx]
	mov	edx, DWORD PTR -8[rcx+rbx]
	lea	rdi, [rsi+r12]
	mov	QWORD PTR 72[rsp], rax
	mov	ecx, DWORD PTR 0[rbp]
	mov	esi, DWORD PTR [r15]
	call	divot_filter
	mov	rsi, QWORD PTR 144[rsp]
	mov	rcx, QWORD PTR 40[rsp]
	mov	rax, QWORD PTR 72[rsp]
	mov	edx, DWORD PTR [r15]
	lea	rdi, [rsi+rbx]
	mov	esi, DWORD PTR 0[rbp]
	mov	ecx, DWORD PTR 12[rcx+rax]
	call	divot_filter
	mov	r11d, DWORD PTR 80[rsp]
	mov	DWORD PTR 108[rsp], r11d
	jmp	.L200
	.p2align 4,,10
	.p2align 3
.L244:
	mov	rsi, QWORD PTR 32[rsp]
	movsx	r15, r11d
	mov	rcx, QWORD PTR 136[rsp]
	sal	r15, 2
	mov	DWORD PTR 112[rsp], r11d
	lea	r9, -8[r15]
	lea	r8, [rsi+r12]
	mov	rax, rsi
	mov	edx, DWORD PTR -8[rsi+r15]
	add	rax, r15
	lea	r13, [rcx+r12]
	mov	QWORD PTR 96[rsp], r9
	mov	ecx, DWORD PTR [rax]
	mov	esi, DWORD PTR [r8]
	mov	rdi, r13
	mov	QWORD PTR 80[rsp], rax
	mov	QWORD PTR 72[rsp], r8
	call	divot_filter
	mov	rax, QWORD PTR 136[rsp]
	mov	rsi, QWORD PTR 32[rsp]
	mov	r9, QWORD PTR 96[rsp]
	mov	r8, QWORD PTR 72[rsp]
	lea	rdi, [rax+r15]
	mov	rax, QWORD PTR 80[rsp]
	mov	ecx, DWORD PTR 12[rsi+r9]
	mov	edx, DWORD PTR [r8]
	mov	esi, DWORD PTR [rax]
	call	divot_filter
	mov	r11d, DWORD PTR 112[rsp]
	jmp	.L197
	.p2align 4,,10
	.p2align 3
.L243:
	mov	eax, DWORD PTR 92[rsp]
	mov	rsi, QWORD PTR 40[rsp]
	mov	r10, QWORD PTR 64[rsp]
	movzx	ecx, BYTE PTR 201[rsp]
	mov	DWORD PTR 72[rsp], r11d
	mov	r9d, DWORD PTR 20[rsp]
	lea	edx, [r11+rax]
	movsx	rax, ebx
	mov	r8d, DWORD PTR 24[rsp]
	lea	rdi, [rsi+rax*4]
	lea	rax, vi_fetch_filter_func[rip]
	mov	esi, DWORD PTR 28[rsp]
	call	[QWORD PTR [rax+r10*8]]
	mov	DWORD PTR [rsp], ebx
	mov	r11d, DWORD PTR 72[rsp]
	jmp	.L195
	.p2align 4,,10
	.p2align 3
.L242:
	mov	eax, DWORD PTR 88[rsp]
	mov	rsi, QWORD PTR 32[rsp]
	mov	r10, QWORD PTR 64[rsp]
	movzx	ecx, BYTE PTR 201[rsp]
	mov	DWORD PTR 72[rsp], r11d
	mov	r9d, DWORD PTR 20[rsp]
	lea	edx, [r11+rax]
	movsx	rax, ebx
	mov	r8d, DWORD PTR 24[rsp]
	lea	rdi, [rsi+rax*4]
	lea	rax, vi_fetch_filter_func[rip]
	mov	esi, DWORD PTR 28[rsp]
	call	[QWORD PTR [rax+r10*8]]
	mov	DWORD PTR 8[rsp], ebx
	mov	r11d, DWORD PTR 72[rsp]
	jmp	.L194
	.p2align 4,,10
	.p2align 3
.L198:
	mov	rdi, QWORD PTR 32[rsp]
	movsx	rdx, ebx
	mov	r15, QWORD PTR 136[rsp]
	lea	rax, 0[0+rdx*4]
	mov	DWORD PTR 72[rsp], r11d
	mov	ecx, DWORD PTR [rdi+rdx*4]
	mov	esi, DWORD PTR -4[rdi+rax]
	lea	r13, [r15+r12]
	mov	edx, DWORD PTR [rdi+r12]
	lea	rdi, -4[r15+rax]
	call	divot_filter
	mov	r11d, DWORD PTR 72[rsp]
	mov	DWORD PTR 112[rsp], r11d
	jmp	.L197
	.p2align 4,,10
	.p2align 3
.L246:
	mov	rsi, QWORD PTR 40[rsp]
	movsx	rbx, ebx
	mov	rdi, QWORD PTR 144[rsp]
	lea	rax, 0[0+rbx*4]
	mov	DWORD PTR 72[rsp], r11d
	mov	ecx, DWORD PTR [rsi+rbx*4]
	mov	edx, DWORD PTR [rsi+r12]
	lea	rdi, -4[rdi+rax]
	mov	esi, DWORD PTR -4[rsi+rax]
	call	divot_filter
	mov	r11d, DWORD PTR 72[rsp]
	mov	DWORD PTR 108[rsp], r11d
	jmp	.L200
	.p2align 4,,10
	.p2align 3
.L183:
	add	DWORD PTR 176[rsp], 1
	mov	eax, DWORD PTR 192[rsp]
	add	DWORD PTR 172[rsp], eax
	mov	eax, DWORD PTR 20[rsp]
	cmp	DWORD PTR 176[rsp], eax
	je	.L175
	mov	eax, DWORD PTR x_start_init[rip]
	mov	DWORD PTR 60[rsp], eax
	mov	eax, DWORD PTR 168[rsp]
	jmp	.L212
	.p2align 4,,10
	.p2align 3
.L233:
	mov	eax, DWORD PTR 176[rsp]
	test	eax, eax
	je	.L181
	mov	eax, DWORD PTR 124[rsp]
	test	eax, eax
	jne	.L213
	mov	eax, DWORD PTR [rsp]
	mov	rcx, QWORD PTR 40[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	eax, DWORD PTR 204[rsp]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR 32[rsp]
	mov	QWORD PTR 32[rsp], rcx
	mov	QWORD PTR 40[rsp], rax
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L234:
	mov	eax, DWORD PTR 176[rsp]
	test	eax, eax
	jne	.L182
	jmp	.L181
	.p2align 4,,10
	.p2align 3
.L213:
	mov	eax, DWORD PTR 108[rsp]
	mov	ecx, DWORD PTR [rsp]
	mov	DWORD PTR 112[rsp], eax
	mov	eax, DWORD PTR 204[rsp]
	mov	DWORD PTR 8[rsp], ecx
	mov	rcx, QWORD PTR 144[rsp]
	mov	DWORD PTR 108[rsp], eax
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR 136[rsp]
	mov	QWORD PTR 136[rsp], rcx
	mov	rcx, QWORD PTR 40[rsp]
	mov	QWORD PTR 144[rsp], rax
	mov	rax, QWORD PTR 32[rsp]
	mov	QWORD PTR 32[rsp], rcx
	mov	QWORD PTR 40[rsp], rax
	jmp	.L182
.L232:
	lea	rdi, .LC1[rip]
	call	DisplayError@PLT
	jmp	.L177
	.cfi_endproc
.LFE552:
	.size	do_frame_buffer_proper, .-do_frame_buffer_proper
	.p2align 4,,15
	.globl	DisplayWarning
	.type	DisplayWarning, @function
DisplayWarning:
.LFB566:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, QWORD PTR stdout@GOTPCREL[rip]
	mov	rsi, QWORD PTR [rbx]
	call	fputs@PLT
	mov	rsi, QWORD PTR [rbx]
	mov	edi, 10
	pop	rbx
	.cfi_def_cfa_offset 8
	jmp	fputc@PLT
	.cfi_endproc
.LFE566:
	.size	DisplayWarning, .-DisplayWarning
	.p2align 4,,15
	.globl	DisplayInStatusPanel
	.type	DisplayInStatusPanel, @function
DisplayInStatusPanel:
.LFB567:
	.cfi_startproc
	jmp	puts@PLT
	.cfi_endproc
.LFE567:
	.size	DisplayInStatusPanel, .-DisplayInStatusPanel
	.p2align 4,,15
	.globl	memfill
	.type	memfill, @function
memfill:
.LFB568:
	.cfi_startproc
	movd	xmm0, esi
	cmp	rdx, 63
	punpcklbw	xmm0, xmm0
	punpcklwd	xmm0, xmm0
	pshufd	xmm0, xmm0, 0
	jbe	.L251
	mov	r8d, 16
	lea	rax, -16[rdi+rdx]
	sub	r8, rdi
	.p2align 4,,10
	.p2align 3
.L253:
	movdqu	XMMWORD PTR [rax], xmm0
	sub	rax, 64
	movdqu	XMMWORD PTR 48[rax], xmm0
	movdqu	XMMWORD PTR 32[rax], xmm0
	movdqu	XMMWORD PTR 16[rax], xmm0
	lea	rcx, [r8+rax]
	cmp	rcx, 63
	ja	.L253
	and	edx, 63
.L251:
	cmp	rdx, 31
	jbe	.L254
	movdqu	XMMWORD PTR -16[rdi+rdx], xmm0
	movdqu	XMMWORD PTR -32[rdi+rdx], xmm0
	and	edx, 31
.L254:
	cmp	rdx, 15
	jbe	.L273
	movdqu	XMMWORD PTR -16[rdi+rdx], xmm0
	and	edx, 15
.L273:
	lea	rax, .L258[rip]
	movsx	rdx, DWORD PTR [rax+rdx*4]
	add	rax, rdx
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L258:
	.long	.L250-.L258
	.long	.L257-.L258
	.long	.L259-.L258
	.long	.L260-.L258
	.long	.L261-.L258
	.long	.L262-.L258
	.long	.L263-.L258
	.long	.L264-.L258
	.long	.L265-.L258
	.long	.L266-.L258
	.long	.L267-.L258
	.long	.L268-.L258
	.long	.L269-.L258
	.long	.L270-.L258
	.long	.L271-.L258
	.long	.L272-.L258
	.text
.L272:
	mov	BYTE PTR 14[rdi], sil
.L271:
	mov	BYTE PTR 13[rdi], sil
.L270:
	mov	BYTE PTR 12[rdi], sil
.L269:
	mov	BYTE PTR 11[rdi], sil
.L268:
	mov	BYTE PTR 10[rdi], sil
.L267:
	mov	BYTE PTR 9[rdi], sil
.L266:
	mov	BYTE PTR 8[rdi], sil
.L265:
	mov	BYTE PTR 7[rdi], sil
.L264:
	mov	BYTE PTR 6[rdi], sil
.L263:
	mov	BYTE PTR 5[rdi], sil
.L262:
	mov	BYTE PTR 4[rdi], sil
.L261:
	mov	BYTE PTR 3[rdi], sil
.L260:
	mov	BYTE PTR 2[rdi], sil
.L259:
	mov	BYTE PTR 1[rdi], sil
.L257:
	mov	BYTE PTR [rdi], sil
.L250:
	rep ret
	.cfi_endproc
.LFE568:
	.size	memfill, .-memfill
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"rb"
	.text
	.p2align 4,,15
	.globl	file_exists
	.type	file_exists, @function
file_exists:
.LFB569:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	lea	rsi, .LC2[rip]
	call	fopen@PLT
	test	rax, rax
	mov	rbx, rax
	je	.L277
	.p2align 4,,10
	.p2align 3
.L276:
	mov	rdi, rbx
	call	fclose@PLT
	test	eax, eax
	jne	.L276
	mov	eax, 1
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L277:
	.cfi_restore_state
	xor	eax, eax
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE569:
	.size	file_exists, .-file_exists
	.p2align 4,,15
	.globl	file_in
	.type	file_in, @function
file_in:
.LFB570:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	mov	r12, rdx
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	mov	rbp, rsi
	lea	rsi, .LC2[rip]
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	call	fopen@PLT
	mov	rbx, rax
	xor	eax, eax
	test	rbx, rbx
	je	.L281
	mov	rdi, rbp
	mov	rcx, rbx
	mov	edx, 1
	mov	rsi, r12
	call	fread@PLT
	mov	rbp, rax
	.p2align 4,,10
	.p2align 3
.L283:
	mov	rdi, rbx
	call	fclose@PLT
	test	eax, eax
	jne	.L283
	xor	eax, eax
	test	rbp, rbp
	setne	al
.L281:
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE570:
	.size	file_in, .-file_in
	.section	.rodata.str1.1
.LC3:
	.string	"wb"
.LC4:
	.string	"Failed to write file.\n"
	.text
	.p2align 4,,15
	.globl	file_out
	.type	file_out, @function
file_out:
.LFB571:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	mov	r12, rdx
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	mov	rbp, rsi
	lea	rsi, .LC3[rip]
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	call	fopen@PLT
	mov	rdi, rbp
	mov	rcx, rax
	mov	edx, 1
	mov	rsi, r12
	mov	rbx, rax
	call	fwrite@PLT
	mov	rbp, rax
	.p2align 4,,10
	.p2align 3
.L289:
	mov	rdi, rbx
	call	fclose@PLT
	test	eax, eax
	jne	.L289
	test	ebp, ebp
	je	.L292
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	.p2align 4,,3
	ret
	.p2align 4,,10
	.p2align 3
.L292:
	.cfi_restore_state
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	lea	rdi, .LC4[rip]
	jmp	DisplayError@PLT
	.cfi_endproc
.LFE571:
	.size	file_out, .-file_out
	.p2align 4,,15
	.globl	screen_resize
	.type	screen_resize, @function
screen_resize:
.LFB572:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, QWORD PTR video_surface@GOTPCREL[rip]
	mov	rax, QWORD PTR [rbx]
	mov	rdx, QWORD PTR 8[rax]
	mov	ecx, DWORD PTR [rax]
	movzx	edx, BYTE PTR 8[rdx]
	call	SDL_SetVideoMode@PLT
	mov	QWORD PTR [rbx], rax
	mov	rax, QWORD PTR video_sync@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE572:
	.size	screen_resize, .-screen_resize
	.p2align 4,,15
	.globl	get_screen_size
	.type	get_screen_size, @function
get_screen_size:
.LFB573:
	.cfi_startproc
	mov	rax, QWORD PTR SDL_desktop@GOTPCREL[rip]
	mov	edx, DWORD PTR [rax]
	mov	DWORD PTR [rdi], edx
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR 4[rdi], eax
	ret
	.cfi_endproc
.LFE573:
	.size	get_screen_size, .-get_screen_size
	.p2align 4,,15
	.globl	reform_image_canvas
	.type	reform_image_canvas, @function
reform_image_canvas:
.LFB574:
	.cfi_startproc
	cmp	edi, 1
	mov	ecx, esi
	lea	rdi, quad[rip]
	sbb	eax, eax
	mov	DWORD PTR quad[rip+16], 0x3f200000
	mov	DWORD PTR quad[rip+48], 0x3f200000
	and	eax, -96
	add	eax, 576
	sar	eax, cl
	cvtsi2ss	xmm0, rax
	mov	rax, QWORD PTR cfg@GOTPCREL[rip]
	movzx	esi, BYTE PTR 23[rax]
	not	esi
	and	esi, 2
	mulss	xmm0, DWORD PTR .LC6[rip]
	movss	DWORD PTR quad[rip+4], xmm0
	movss	DWORD PTR quad[rip+20], xmm0
	jmp	rebound_screen_texture@PLT
	.cfi_endproc
.LFE574:
	.size	reform_image_canvas, .-reform_image_canvas
	.section	.rodata.str1.1
.LC9:
	.string	"VI_V_SYNC_REG too big"
	.section	.rodata.str1.8
	.align 8
.LC13:
	.string	"Invalid resolution control setting."
	.align 8
.LC14:
	.string	"Problem scaling the frame drawing."
	.text
	.p2align 4,,15
	.globl	rdp_update
	.type	rdp_update, @function
rdp_update:
.LFB551:
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
	sub	rsp, 120
	.cfi_def_cfa_offset 176
	mov	rsi, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	r11, QWORD PTR oldvstart@GOTPCREL[rip]
	mov	rax, QWORD PTR 176[rsi]
	mov	rdx, QWORD PTR 208[rsi]
	mov	rcx, QWORD PTR 128[rsi]
	mov	r8, QWORD PTR 224[rsi]
	mov	r10d, DWORD PTR [r11]
	mov	r13d, DWORD PTR [rax]
	xor	eax, eax
	mov	edi, DWORD PTR [rdx]
	mov	r12d, DWORD PTR [rcx]
	mov	r9d, DWORD PTR [r8]
	and	r13d, 1023
	mov	edx, edi
	cmp	r13d, 550
	mov	ecx, r12d
	setg	al
	shr	edx, 16
	shr	ecx, 6
	mov	ebx, eax
	mov	rax, QWORD PTR 200[rsi]
	and	edx, 1023
	mov	DWORD PTR 48[rsp], ebx
	mov	eax, DWORD PTR [rax]
	mov	ebp, eax
	and	eax, 1023
	shr	ebp, 16
	and	ebp, 1023
	sub	eax, ebp
	test	ebx, ebx
	je	.L302
	xor	ebx, ebx
	cmp	edx, r10d
	setl	bl
	mov	DWORD PTR 64[rsp], ebx
	xor	ebx, ebx
	and	DWORD PTR 64[rsp], ecx
	cmp	edx, r10d
	setne	bl
	mov	DWORD PTR 40[rsp], ebx
	and	DWORD PTR 40[rsp], ecx
	mov	ecx, DWORD PTR 40[rsp]
	mov	ebx, ecx
	xor	ebx, 1
	mov	DWORD PTR 68[rsp], ebx
	mov	rbx, QWORD PTR pitchindwords@GOTPCREL[rip]
	mov	r10d, DWORD PTR [rbx]
	mov	DWORD PTR 52[rsp], r10d
	sal	DWORD PTR 52[rsp], cl
	lea	ecx, -128[rbp]
	mov	r10d, 47
	mov	DWORD PTR 32[rsp], ecx
	mov	r14d, ecx
.L303:
	mov	ecx, r9d
	shr	ecx, 16
	and	ecx, 4095
	test	r14d, r14d
	js	.L304
	mov	DWORD PTR 36[rsp], 640
	sub	DWORD PTR 36[rsp], r14d
	xor	r9d, r9d
	mov	DWORD PTR x_start_init[rip], ecx
.L305:
	cmp	eax, DWORD PTR 36[rsp]
	mov	ecx, 1
	mov	DWORD PTR [r11], edx
	jg	.L306
	mov	DWORD PTR 36[rsp], eax
	xor	cl, cl
.L306:
	cmp	DWORD PTR 48[rsp], 1
	sbb	eax, eax
	and	eax, -10
	add	eax, 47
	sub	r13d, eax
	cmp	r13d, 625
	jg	.L392
	test	r13d, r13d
	mov	eax, 2
	js	.L379
	cmp	r9d, 1
	mov	r11d, DWORD PTR 36[rsp]
	sbb	eax, eax
	and	eax, 8
	mov	DWORD PTR hpass_minmax[rip], eax
	mov	eax, r11d
	sub	eax, 7
	test	ecx, ecx
	mov	ecx, edx
	cmovne	eax, r11d
	sub	ecx, r10d
	xor	r9d, r9d
	sar	ecx
	mov	DWORD PTR hpass_minmax[rip+4], eax
	cmovs	ecx, r9d
	and	edi, 1023
	mov	r10d, ecx
	sub	edi, edx
	mov	DWORD PTR 76[rsp], ecx
	mov	ecx, 625
	sar	edi
	sub	ecx, r10d
	cmp	ecx, edi
	cmovle	edi, ecx
	test	r11d, r11d
	mov	DWORD PTR 72[rsp], edi
	jg	.L393
.L360:
	mov	eax, 3
.L379:
	add	rsp, 120
	.cfi_remember_state
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
	.p2align 4,,10
	.p2align 3
.L302:
	.cfi_restore_state
	xor	ebx, ebx
	cmp	edx, r10d
	setg	bl
	mov	DWORD PTR 64[rsp], ebx
	xor	ebx, ebx
	and	DWORD PTR 64[rsp], ecx
	cmp	edx, r10d
	setne	bl
	mov	DWORD PTR 40[rsp], ebx
	and	DWORD PTR 40[rsp], ecx
	mov	ecx, DWORD PTR 40[rsp]
	mov	ebx, ecx
	xor	ebx, 1
	mov	DWORD PTR 68[rsp], ebx
	mov	rbx, QWORD PTR pitchindwords@GOTPCREL[rip]
	mov	r10d, DWORD PTR [rbx]
	mov	DWORD PTR 52[rsp], r10d
	sal	DWORD PTR 52[rsp], cl
	lea	ecx, -108[rbp]
	mov	r10d, 37
	mov	DWORD PTR 32[rsp], ecx
	mov	r14d, ecx
	jmp	.L303
	.p2align 4,,10
	.p2align 3
.L304:
	and	r9d, 4095
	add	eax, r14d
	mov	DWORD PTR 36[rsp], 640
	imul	r9d, r14d
	mov	DWORD PTR 32[rsp], 0
	sub	ecx, r9d
	mov	r9d, 1
	mov	DWORD PTR x_start_init[rip], ecx
	jmp	.L305
	.p2align 4,,10
	.p2align 3
.L392:
	lea	rdi, .LC9[rip]
	call	DisplayError@PLT
	add	rsp, 120
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	mov	eax, 1
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
	.p2align 4,,10
	.p2align 3
.L393:
	.cfi_restore_state
	test	edi, edi
	jle	.L360
	test	r12b, 2
	jne	.L312
	mov	r10d, DWORD PTR prevwasblank[rip]
	mov	eax, 3
	test	r10d, r10d
	jne	.L379
.L312:
	mov	rax, QWORD PTR shift_old@GOTPCREL[rip]
	mov	edi, DWORD PTR 68[rsp]
	mov	r14, QWORD PTR video_sync@GOTPCREL[rip]
	mov	ecx, DWORD PTR 36[rsp]
	mov	r15, QWORD PTR vres_old@GOTPCREL[rip]
	cmp	edi, DWORD PTR [rax]
	mov	rdi, QWORD PTR hres_old@GOTPCREL[rip]
	setne	al
	movzx	eax, al
	or	eax, DWORD PTR [r14]
	cmp	ecx, DWORD PTR [rdi]
	mov	edi, DWORD PTR 72[rsp]
	setne	dl
	cmp	DWORD PTR [r15], edi
	setne	cl
	or	edx, ecx
	movzx	edx, dl
	or	eax, edx
	test	eax, eax
	mov	DWORD PTR [r14], eax
	je	.L313
	mov	rax, QWORD PTR video_surface@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR is_full_screen@GOTPCREL[rip]
	mov	r9d, DWORD PTR [rax]
	test	r9d, r9d
	jne	.L394
	mov	rax, QWORD PTR 232[rsi]
	mov	rbp, QWORD PTR viewport@GOTPCREL[rip]
	mov	edi, DWORD PTR [r8]
	mov	esi, DWORD PTR [rax]
	mov	rax, QWORD PTR cfg@GOTPCREL[rip]
	mov	DWORD PTR 0[rbp], 0
	mov	DWORD PTR 4[rbp], 0
	movzx	edx, BYTE PTR 4[rax]
	cmp	dl, 1
	je	.L321
	jb	.L322
	cmp	dl, 2
	jne	.L395
	movzx	edx, BYTE PTR 2[rax]
	movzx	esi, BYTE PTR 3[rax]
	sal	edx, 8
	or	edx, esi
	movzx	esi, BYTE PTR [rax]
	movzx	eax, BYTE PTR 1[rax]
	add	edx, 1
	mov	DWORD PTR 12[rbp], edx
	sal	esi, 8
	or	esi, eax
	add	esi, 1
	mov	DWORD PTR 8[rbp], esi
	mov	edi, esi
	mov	esi, edx
.L324:
	mov	DWORD PTR 56[rsp], ecx
	call	screen_resize@PLT
	mov	esi, DWORD PTR 12[rbp]
	mov	edi, DWORD PTR 8[rbp]
	xor	edx, edx
	mov	ecx, DWORD PTR 56[rsp]
	call	SDL_SetVideoMode@PLT
	mov	rsi, QWORD PTR video_surface@GOTPCREL[rip]
	mov	QWORD PTR [rsi], rax
.L319:
	mov	esi, DWORD PTR 4[rbp]
	mov	edi, DWORD PTR 0[rbp]
	mov	ecx, DWORD PTR 12[rbp]
	mov	edx, DWORD PTR 8[rbp]
	mov	DWORD PTR [r14], 0
	call	glViewport@PLT
	mov	esi, DWORD PTR 68[rsp]
	mov	edi, DWORD PTR 48[rsp]
	call	reform_image_canvas@PLT
.L313:
	mov	rax, QWORD PTR hres_old@GOTPCREL[rip]
	mov	esi, DWORD PTR 36[rsp]
	mov	DWORD PTR [rax], esi
	mov	eax, DWORD PTR 72[rsp]
	mov	esi, DWORD PTR 68[rsp]
	mov	DWORD PTR [r15], eax
	mov	rax, QWORD PTR shift_old@GOTPCREL[rip]
	mov	DWORD PTR [rax], esi
	mov	rax, QWORD PTR support_pixel_DMAs@GOTPCREL[rip]
	cmp	BYTE PTR [rax], 0
	jne	.L396
	mov	rax, QWORD PTR screen@GOTPCREL[rip]
.L325:
	and	r12d, 3
	mov	edi, r12d
	mov	DWORD PTR 92[rsp], r12d
	mov	r12, QWORD PTR PreScale@GOTPCREL[rip]
	shr	edi
	mov	QWORD PTR [r12], rax
	je	.L397
	mov	esi, DWORD PTR 32[rsp]
	movzx	ecx, BYTE PTR 68[rsp]
	mov	DWORD PTR prevwasblank[rip], 0
	lea	edx, -1[rsi]
	sar	r13d, cl
	cmp	edx, 638
	mov	DWORD PTR 80[rsp], r13d
	ja	.L398
	test	r13d, r13d
	je	.L332
	mov	esi, DWORD PTR 32[rsp]
	xor	ebp, ebp
	lea	r14d, 0[0+rsi*4]
	movsx	r14, r14d
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L399:
	mov	rax, QWORD PTR [r12]
.L334:
	mov	edx, DWORD PTR [rbx]
	xor	esi, esi
	imul	edx, ebp
	add	ebp, 1
	movsx	rdx, edx
	lea	rdi, [rax+rdx*4]
	mov	rdx, r14
	call	memfill@PLT
	cmp	ebp, r13d
	jne	.L399
	mov	r14d, DWORD PTR 36[rsp]
	add	r14d, DWORD PTR 32[rsp]
	cmp	r14d, 639
	jbe	.L354
	.p2align 4,,10
	.p2align 3
.L332:
	cmp	DWORD PTR 32[rsp], 639
	movzx	ecx, BYTE PTR 40[rsp]
	mov	r14d, DWORD PTR 76[rsp]
	setle	BYTE PTR 87[rsp]
	sal	r14d, cl
	add	r14d, DWORD PTR 64[rsp]
	mov	DWORD PTR 88[rsp], r14d
	je	.L400
	mov	eax, DWORD PTR 36[rsp]
	movzx	r15d, BYTE PTR 87[rsp]
	xor	r13d, r13d
	mov	rbp, QWORD PTR tvfadeoutstate@GOTPCREL[rip]
	sal	eax, 2
	cdqe
	mov	QWORD PTR 56[rsp], rax
	mov	eax, DWORD PTR 88[rsp]
	lea	r8d, -1[rax]
	lea	r14, 1[r8]
	jmp	.L339
	.p2align 4,,10
	.p2align 3
.L338:
	add	r13, 1
	cmp	r13, r14
	je	.L336
.L339:
	mov	eax, DWORD PTR 0[rbp+r13*4]
	shr	eax
	mov	DWORD PTR 0[rbp+r13*4], eax
	not	eax
	test	eax, r15d
	je	.L338
	mov	edx, DWORD PTR [rbx]
	mov	rax, QWORD PTR [r12]
	xor	esi, esi
	imul	edx, r13d
	add	edx, DWORD PTR 32[rsp]
	movsx	rdx, edx
	lea	rdi, [rax+rdx*4]
	mov	rdx, QWORD PTR 56[rsp]
	call	memfill@PLT
	jmp	.L338
.L398:
	mov	r14d, DWORD PTR 36[rsp]
	add	r14d, esi
	cmp	r14d, 639
	ja	.L332
	mov	esi, DWORD PTR 80[rsp]
	test	esi, esi
	je	.L332
.L354:
	mov	eax, 640
	mov	r15d, DWORD PTR 80[rsp]
	xor	ebp, ebp
	sub	eax, r14d
	sal	eax, 2
	movsx	r13, eax
	.p2align 4,,10
	.p2align 3
.L337:
	mov	edx, DWORD PTR [rbx]
	mov	rax, QWORD PTR [r12]
	xor	esi, esi
	imul	edx, ebp
	add	ebp, 1
	add	edx, r14d
	movsx	rdx, edx
	lea	rdi, [rax+rdx*4]
	mov	rdx, r13
	call	memfill@PLT
	cmp	ebp, r15d
	jne	.L337
	jmp	.L332
.L400:
	mov	rbp, QWORD PTR tvfadeoutstate@GOTPCREL[rip]
	.p2align 4,,10
	.p2align 3
.L336:
	mov	ecx, DWORD PTR 40[rsp]
	test	ecx, ecx
	jne	.L340
	mov	ecx, DWORD PTR 88[rsp]
	mov	esi, DWORD PTR 72[rsp]
	movsx	rdx, ecx
	jmp	.L342
	.p2align 4,,10
	.p2align 3
.L401:
	movsx	rdx, r13d
.L342:
	lea	r13d, 1[rdx]
	mov	DWORD PTR 0[rbp+rdx*4], 2
	mov	eax, r13d
	sub	eax, ecx
	cmp	eax, esi
	jl	.L401
.L341:
	cmp	DWORD PTR 80[rsp], r13d
	jle	.L349
	mov	eax, DWORD PTR 36[rsp]
	movzx	r15d, BYTE PTR 87[rsp]
	lea	r14d, 0[0+rax*4]
	movsx	r14, r14d
	mov	QWORD PTR 40[rsp], r14
	mov	r14d, r15d
	mov	r15, rbp
	mov	ebp, DWORD PTR 80[rsp]
	jmp	.L350
	.p2align 4,,10
	.p2align 3
.L348:
	add	r13d, 1
	cmp	r13d, ebp
	je	.L349
.L350:
	movsx	rdx, r13d
	mov	eax, DWORD PTR [r15+rdx*4]
	shr	eax
	mov	DWORD PTR [r15+rdx*4], eax
	not	eax
	test	eax, r14d
	je	.L348
	mov	edx, DWORD PTR [rbx]
	mov	rax, QWORD PTR [r12]
	xor	esi, esi
	imul	edx, r13d
	add	edx, DWORD PTR 32[rsp]
	movsx	rdx, edx
	lea	rdi, [rax+rdx*4]
	mov	rdx, QWORD PTR 40[rsp]
	call	memfill@PLT
	jmp	.L348
.L340:
	mov	eax, DWORD PTR 36[rsp]
	xor	r14d, r14d
	mov	QWORD PTR 40[rsp], rbx
	movzx	r15d, BYTE PTR 87[rsp]
	mov	rbx, rbp
	mov	r13d, DWORD PTR 88[rsp]
	mov	ebp, r14d
	mov	r14d, DWORD PTR 72[rsp]
	sal	eax, 2
	cdqe
	mov	QWORD PTR 56[rsp], rax
	jmp	.L347
	.p2align 4,,10
	.p2align 3
.L346:
	add	ebp, 1
	add	r13d, 2
	cmp	ebp, r14d
	jge	.L402
.L347:
	lea	esi, 1[r13]
	movsx	rax, r13d
	mov	DWORD PTR [rbx+rax*4], 2
	movsx	rdx, esi
	mov	eax, DWORD PTR [rbx+rdx*4]
	shr	eax
	mov	DWORD PTR [rbx+rdx*4], eax
	not	eax
	test	eax, r15d
	je	.L346
	mov	rax, QWORD PTR 40[rsp]
	mov	rdx, QWORD PTR 56[rsp]
	imul	esi, DWORD PTR [rax]
	mov	rax, QWORD PTR [r12]
	add	esi, DWORD PTR 32[rsp]
	movsx	rsi, esi
	lea	rdi, [rax+rsi*4]
	xor	esi, esi
	call	memfill@PLT
	jmp	.L346
.L394:
	lea	rdi, 96[rsp]
	mov	DWORD PTR 56[rsp], ecx
	call	get_screen_size@PLT
	mov	edi, DWORD PTR 48[rsp]
	movss	xmm1, DWORD PTR .LC8[rip]
	mov	ecx, DWORD PTR 56[rsp]
	test	edi, edi
	je	.L315
	movss	xmm1, DWORD PTR .LC7[rip]
.L315:
	mov	eax, DWORD PTR 96[rsp]
	mov	edx, DWORD PTR 100[rsp]
	movss	xmm4, DWORD PTR .LC10[rip]
	mov	rbp, QWORD PTR viewport@GOTPCREL[rip]
	cvtsi2ss	xmm2, eax
	cvtsi2ss	xmm0, edx
	movaps	xmm3, xmm2
	divss	xmm3, xmm0
	ucomiss	xmm4, xmm3
	ja	.L403
	mulss	xmm0, xmm1
	mov	DWORD PTR 12[rbp], edx
	mov	DWORD PTR 4[rbp], 0
	cvttss2si	edx, xmm0
	sub	eax, edx
	mov	DWORD PTR 8[rbp], edx
	mov	edx, eax
	shr	edx, 31
	add	eax, edx
	sar	eax
	mov	DWORD PTR 0[rbp], eax
.L318:
	mov	rax, QWORD PTR SDL_desktop@GOTPCREL[rip]
	xor	edx, edx
	mov	esi, DWORD PTR 4[rax]
	mov	edi, DWORD PTR [rax]
	call	SDL_SetVideoMode@PLT
	mov	rsi, QWORD PTR video_surface@GOTPCREL[rip]
	mov	QWORD PTR [rsi], rax
	jmp	.L319
	.p2align 4,,10
	.p2align 3
.L349:
	mov	eax, DWORD PTR 76[rsp]
	mov	edx, DWORD PTR 64[rsp]
	imul	eax, DWORD PTR 52[rsp]
	add	eax, DWORD PTR 32[rsp]
	test	edx, edx
	jne	.L344
	xor	edx, edx
.L345:
	mov	rcx, QWORD PTR cfg@GOTPCREL[rip]
	lea	edi, [rax+rdx]
	lea	rax, do_frame_buffer[rip]
	mov	r8d, DWORD PTR 52[rsp]
	mov	edx, DWORD PTR 72[rsp]
	mov	esi, DWORD PTR 36[rsp]
	movzx	r9d, BYTE PTR 23[rcx]
	mov	ecx, DWORD PTR 92[rsp]
	and	r9d, 1
	call	[QWORD PTR [rax+r9*8]]
.L329:
	cmp	DWORD PTR 48[rsp], 1
	movzx	ecx, BYTE PTR 68[rsp]
	mov	rax, QWORD PTR support_pixel_DMAs@GOTPCREL[rip]
	sbb	r9d, r9d
	and	r9d, -96
	add	r9d, 576
	shr	r9d, cl
	cmp	BYTE PTR [rax], 0
	jne	.L352
	mov	rax, QWORD PTR [r12]
.L353:
	xor	ecx, ecx
	mov	QWORD PTR 16[rsp], rax
	mov	r8d, 640
	xor	edx, edx
	xor	esi, esi
	mov	edi, 3553
	mov	DWORD PTR 8[rsp], 5121
	mov	DWORD PTR [rsp], 32993
	call	glTexSubImage2D@PLT
	xor	esi, esi
	mov	edx, 4
	mov	edi, 5
	call	glDrawArrays@PLT
	call	glGetError@PLT
	mov	esi, eax
	xor	eax, eax
	test	esi, esi
	je	.L379
	lea	rdi, .LC14[rip]
	mov	DWORD PTR 32[rsp], eax
	call	DisplayGLError@PLT
	mov	eax, DWORD PTR 32[rsp]
	jmp	.L379
.L402:
	mov	rbp, rbx
	mov	rbx, QWORD PTR 40[rsp]
	jmp	.L341
.L344:
	mov	edx, DWORD PTR [rbx]
	jmp	.L345
.L397:
	mov	rdi, QWORD PTR tvfadeoutstate@GOTPCREL[rip]
	mov	edx, 2500
	xor	esi, esi
	xor	ebp, ebp
	call	memfill@PLT
	.p2align 4,,10
	.p2align 3
.L328:
	mov	edx, DWORD PTR [rbx]
	mov	rax, QWORD PTR [r12]
	xor	esi, esi
	imul	edx, ebp
	add	ebp, 1
	movsx	rdx, edx
	lea	rdi, [rax+rdx*4]
	mov	edx, 2560
	call	memfill@PLT
	cmp	ebp, 625
	jne	.L328
	mov	DWORD PTR prevwasblank[rip], 1
	jmp	.L329
.L352:
	mov	rax, QWORD PTR xglUnmapBuffer@GOTPCREL[rip]
	mov	DWORD PTR 32[rsp], r9d
	mov	edi, 35052
	call	[QWORD PTR [rax]]
	mov	QWORD PTR [r12], 0
	xor	eax, eax
	mov	r9d, DWORD PTR 32[rsp]
	jmp	.L353
.L396:
	mov	rax, QWORD PTR xglMapBuffer@GOTPCREL[rip]
	mov	esi, 35001
	mov	edi, 35052
	call	[QWORD PTR [rax]]
	jmp	.L325
.L395:
	lea	rdi, .LC13[rip]
	mov	DWORD PTR 56[rsp], ecx
	call	DisplayError@PLT
	mov	esi, DWORD PTR 12[rbp]
	mov	edi, DWORD PTR 8[rbp]
	mov	ecx, DWORD PTR 56[rsp]
	jmp	.L324
.L322:
	mov	DWORD PTR 8[rbp], 640
	mov	DWORD PTR 12[rbp], 480
	mov	edi, 640
	mov	esi, 480
	jmp	.L324
.L321:
	and	esi, 4095
	mov	eax, DWORD PTR 36[rsp]
	and	edi, 4095
	imul	esi, DWORD PTR 72[rsp]
	imul	edi, eax
	and	eax, 1
	sar	edi, 10
	sar	esi, 10
	sub	edi, eax
	cvtsi2sd	xmm0, esi
	mov	DWORD PTR 8[rbp], edi
	mulsd	xmm0, QWORD PTR .LC11[rip]
	divsd	xmm0, QWORD PTR .LC12[rip]
	cvttsd2si	esi, xmm0
	mov	DWORD PTR 12[rbp], esi
	jmp	.L324
.L403:
	divss	xmm2, xmm1
	mov	DWORD PTR 8[rbp], eax
	mov	DWORD PTR 0[rbp], 0
	cvttss2si	eax, xmm2
	sub	edx, eax
	mov	DWORD PTR 12[rbp], eax
	mov	eax, edx
	shr	eax, 31
	add	eax, edx
	sar	eax
	mov	DWORD PTR 4[rbp], eax
	jmp	.L318
	.cfi_endproc
.LFE551:
	.size	rdp_update, .-rdp_update
	.local	divot_array.21973
	.comm	divot_array.21973,20608,32
	.local	viaa_array.21972
	.comm	viaa_array.21972,20608,32
	.comm	shift_old,4,4
	.comm	vres_old,4,4
	.comm	hres_old,4,4
	.local	x_start_init
	.comm	x_start_init,4,16
	.local	hpass_minmax
	.comm	hpass_minmax,8,16
	.data
	.align 32
	.type	quad, @object
	.size	quad, 64
quad:
	.long	0
	.long	1065353216
	.long	3212836864
	.long	3212836864
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	3212836864
	.long	0
	.long	0
	.long	3212836864
	.long	1065353216
	.long	1065353216
	.long	0
	.long	1065353216
	.long	1065353216
	.section	.data.rel.ro.local,"aw",@progbits
	.align 16
	.type	vi_fetch_filter_func, @object
	.size	vi_fetch_filter_func, 16
vi_fetch_filter_func:
	.quad	vi_fetch_filter16
	.quad	vi_fetch_filter32
	.align 16
	.type	do_frame_buffer, @object
	.size	do_frame_buffer, 16
do_frame_buffer:
	.quad	do_frame_buffer_proper
	.quad	do_frame_buffer_raw
	.local	prevwasblank
	.comm	prevwasblank,4,16
	.comm	tvfadeoutstate,2500,32
	.globl	video_sync
	.data
	.align 16
	.type	video_sync, @object
	.size	video_sync, 4
video_sync:
	.long	1
	.comm	viewport,16,16
	.comm	PreScale,8,8
	.comm	screen,4194304,32
	.globl	oldvstart
	.align 16
	.type	oldvstart, @object
	.size	oldvstart, 4
oldvstart:
	.long	1337
	.comm	vi_restore_table,4096,32
	.comm	gamma_dither_table,65536,32
	.comm	gamma_table,1024,32
	.comm	hidden_bits,4194304,32
	.comm	idxlim32,4,4
	.comm	idxlim16,4,4
	.comm	plim,4,4
	.comm	rdram_16,8,8
	.comm	rdram_8,8,8
	.comm	onetimewarnings,20,16
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.long	-2147483648
	.long	-2147483648
	.long	-2147483648
	.long	-2147483648
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC6:
	.long	981467136
	.align 4
.LC7:
	.long	1066285284
	.align 4
.LC8:
	.long	1068149419
	.align 4
.LC10:
	.long	1065353216
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC11:
	.long	0
	.long	1081892864
	.align 8
.LC12:
	.long	0
	.long	1081868288
	.ident	"GCC: (GNU) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
