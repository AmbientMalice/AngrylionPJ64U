	.file	"n64video.c"
	.intel_syntax noprefix
	.text
	.p2align 4,,15
	.globl	fbwrite_4
	.type	fbwrite_4, @function
fbwrite_4:
.LFB609:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	add	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR plim@GOTPCREL[rip]
	and	edi, 16777215
	cmp	DWORD PTR [rax], edi
	jb	.L1
	mov	rax, QWORD PTR rdram_8@GOTPCREL[rip]
	xor	edi, 3
	mov	rax, QWORD PTR [rax]
	mov	BYTE PTR [rax+rdi], 0
.L1:
	rep ret
	.cfi_endproc
.LFE609:
	.size	fbwrite_4, .-fbwrite_4
	.p2align 4,,15
	.globl	fbwrite_8
	.type	fbwrite_8, @function
fbwrite_8:
.LFB610:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	rdx, QWORD PTR plim@GOTPCREL[rip]
	add	edi, DWORD PTR [rax]
	mov	eax, edi
	and	eax, 16777215
	cmp	DWORD PTR [rdx], eax
	mov	ecx, eax
	jb	.L4
	mov	rdx, QWORD PTR rdram_8@GOTPCREL[rip]
	xor	eax, 3
	and	edi, 1
	mov	rdx, QWORD PTR [rdx]
	mov	BYTE PTR [rdx+rax], sil
	je	.L4
	and	esi, 1
	mov	rax, QWORD PTR hidden_bits@GOTPCREL[rip]
	shr	rcx
	neg	esi
	and	esi, 3
	mov	BYTE PTR [rax+rcx], sil
.L4:
	rep ret
	.cfi_endproc
.LFE610:
	.size	fbwrite_8, .-fbwrite_8
	.p2align 4,,15
	.globl	fbfill_4
	.type	fbfill_4, @function
fbfill_4:
.LFB613:
	.cfi_startproc
	mov	rax, QWORD PTR rdp_pipeline_crashed@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
	ret
	.cfi_endproc
.LFE613:
	.size	fbfill_4, .-fbfill_4
	.p2align 4,,15
	.globl	fbfill_8
	.type	fbfill_8, @function
fbfill_8:
.LFB614:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	rdx, QWORD PTR fill_color@GOTPCREL[rip]
	add	edi, DWORD PTR [rax]
	mov	r8d, DWORD PTR [rdx]
	mov	rdx, QWORD PTR plim@GOTPCREL[rip]
	mov	eax, edi
	and	eax, 16777215
	cmp	DWORD PTR [rdx], eax
	mov	esi, eax
	jb	.L14
	mov	rdx, QWORD PTR rdram_8@GOTPCREL[rip]
	mov	rcx, rsi
	xor	eax, 3
	not	rcx
	and	ecx, 3
	mov	rdx, QWORD PTR [rdx]
	sal	ecx, 3
	shr	r8d, cl
	and	edi, 1
	mov	BYTE PTR [rdx+rax], r8b
	je	.L14
	mov	eax, r8d
	mov	rdx, QWORD PTR hidden_bits@GOTPCREL[rip]
	shr	rsi
	and	eax, 1
	neg	eax
	and	eax, 3
	mov	BYTE PTR [rdx+rsi], al
.L14:
	rep ret
	.cfi_endproc
.LFE614:
	.size	fbfill_8, .-fbfill_8
	.p2align 4,,15
	.globl	fbfill_16
	.type	fbfill_16, @function
fbfill_16:
.LFB615:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	rcx, QWORD PTR idxlim16@GOTPCREL[rip]
	mov	rdx, QWORD PTR fill_color@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	ecx, DWORD PTR [rcx]
	mov	edx, DWORD PTR [rdx]
	lea	eax, [rax+rdi*2]
	and	eax, 16777215
	shr	rax
	cmp	rax, rcx
	ja	.L21
	mov	rcx, rax
	mov	rsi, rax
	not	rcx
	xor	rsi, 1
	and	ecx, 1
	sal	ecx, 4
	shr	edx, cl
	mov	rcx, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rcx]
	mov	WORD PTR [rcx+rsi*2], dx
	and	edx, 1
	mov	rcx, QWORD PTR hidden_bits@GOTPCREL[rip]
	neg	edx
	and	edx, 3
	mov	BYTE PTR [rcx+rax], dl
.L21:
	rep ret
	.cfi_endproc
.LFE615:
	.size	fbfill_16, .-fbfill_16
	.p2align 4,,15
	.globl	fbfill_32
	.type	fbfill_32, @function
fbfill_32:
.LFB616:
	.cfi_startproc
	mov	rax, QWORD PTR fill_color@GOTPCREL[rip]
	mov	rcx, QWORD PTR idxlim32@GOTPCREL[rip]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	mov	eax, DWORD PTR [rax]
	lea	eax, [rax+rdi*4]
	and	eax, 16777215
	shr	rax, 2
	cmp	rax, rcx
	ja	.L23
	mov	rcx, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	esi, edx
	sal	esi, 15
	sar	esi, 31
	mov	rcx, QWORD PTR 32[rcx]
	and	esi, 3
	mov	DWORD PTR [rcx+rax*4], edx
	mov	rcx, QWORD PTR hidden_bits@GOTPCREL[rip]
	and	edx, 1
	neg	edx
	and	edx, 3
	mov	BYTE PTR [rcx+rax*2], sil
	mov	BYTE PTR 1[rcx+rax*2], dl
.L23:
	rep ret
	.cfi_endproc
.LFE616:
	.size	fbfill_32, .-fbfill_32
	.p2align 4,,15
	.globl	fbread_4
	.type	fbread_4, @function
fbread_4:
.LFB617:
	.cfi_startproc
	mov	rax, QWORD PTR memory_color@GOTPCREL[rip]
	mov	DWORD PTR 8[rax], 0
	mov	DWORD PTR 4[rax], 0
	mov	DWORD PTR [rax], 0
	mov	DWORD PTR 12[rax], 224
	mov	DWORD PTR [rsi], 7
	ret
	.cfi_endproc
.LFE617:
	.size	fbread_4, .-fbread_4
	.p2align 4,,15
	.globl	fbread2_4
	.type	fbread2_4, @function
fbread2_4:
.LFB618:
	.cfi_startproc
	mov	rax, QWORD PTR pre_memory_color@GOTPCREL[rip]
	mov	DWORD PTR 8[rax], 0
	mov	DWORD PTR 4[rax], 0
	mov	DWORD PTR [rax], 0
	mov	DWORD PTR 12[rax], 224
	mov	DWORD PTR [rsi], 7
	ret
	.cfi_endproc
.LFE618:
	.size	fbread2_4, .-fbread2_4
	.p2align 4,,15
	.globl	fbread_8
	.type	fbread_8, @function
fbread_8:
.LFB619:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	xor	edx, edx
	add	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR plim@GOTPCREL[rip]
	and	edi, 16777215
	cmp	DWORD PTR [rax], edi
	jb	.L28
	mov	rax, QWORD PTR rdram_8@GOTPCREL[rip]
	xor	edi, 3
	mov	rax, QWORD PTR [rax]
	movzx	edx, BYTE PTR [rax+rdi]
.L28:
	mov	rax, QWORD PTR memory_color@GOTPCREL[rip]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR 4[rax], edx
	mov	DWORD PTR 8[rax], edx
	mov	DWORD PTR 12[rax], 224
	mov	DWORD PTR [rsi], 7
	ret
	.cfi_endproc
.LFE619:
	.size	fbread_8, .-fbread_8
	.p2align 4,,15
	.globl	fbread2_8
	.type	fbread2_8, @function
fbread2_8:
.LFB620:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	xor	edx, edx
	add	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR plim@GOTPCREL[rip]
	and	edi, 16777215
	cmp	DWORD PTR [rax], edi
	jb	.L31
	mov	rax, QWORD PTR rdram_8@GOTPCREL[rip]
	xor	edi, 3
	mov	rax, QWORD PTR [rax]
	movzx	edx, BYTE PTR [rax+rdi]
.L31:
	mov	rax, QWORD PTR pre_memory_color@GOTPCREL[rip]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR 4[rax], edx
	mov	DWORD PTR 8[rax], edx
	mov	DWORD PTR 12[rax], 224
	mov	DWORD PTR [rsi], 7
	ret
	.cfi_endproc
.LFE620:
	.size	fbread2_8, .-fbread2_8
	.p2align 4,,15
	.globl	fbread_16
	.type	fbread_16, @function
fbread_16:
.LFB621:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	lea	eax, [rax+rdi*2]
	mov	edi, DWORD PTR 116[rdx]
	mov	rdx, QWORD PTR idxlim16@GOTPCREL[rip]
	shr	eax
	and	eax, 8388607
	test	edi, edi
	mov	edx, DWORD PTR [rdx]
	mov	ecx, eax
	jne	.L34
	cmp	rcx, rdx
	jbe	.L42
	xor	ecx, ecx
	xor	edx, edx
.L35:
	mov	edi, 224
	mov	eax, 7
	jmp	.L36
	.p2align 4,,10
	.p2align 3
.L34:
	cmp	rcx, rdx
	jbe	.L43
	xor	ecx, ecx
	xor	edi, edi
	xor	eax, eax
	xor	edx, edx
.L36:
	mov	DWORD PTR [rsi], eax
	mov	rsi, QWORD PTR fb_format@GOTPCREL[rip]
	mov	rax, QWORD PTR memory_color@GOTPCREL[rip]
	mov	esi, DWORD PTR [rsi]
	mov	DWORD PTR 12[rax], edi
	test	esi, esi
	jne	.L44
	and	ecx, 248
	mov	DWORD PTR [rax], ecx
	mov	ecx, edx
	and	edx, 62
	and	ecx, 1984
	sal	edx, 2
	sar	ecx, 3
	mov	DWORD PTR 8[rax], edx
	mov	DWORD PTR 4[rax], ecx
	ret
	.p2align 4,,10
	.p2align 3
.L43:
	mov	rdx, QWORD PTR rdram_16@GOTPCREL[rip]
	xor	eax, 1
	mov	rdx, QWORD PTR [rdx]
	movzx	edx, WORD PTR [rdx+rax*2]
	mov	rax, QWORD PTR hidden_bits@GOTPCREL[rip]
	movzx	eax, BYTE PTR [rax+rcx]
	mov	ecx, edx
	shr	cx, 8
	lea	eax, [rax+rdx*4]
	and	eax, 7
	mov	edi, eax
	sal	edi, 5
	jmp	.L36
	.p2align 4,,10
	.p2align 3
.L42:
	mov	rdx, QWORD PTR rdram_16@GOTPCREL[rip]
	xor	eax, 1
	mov	rdx, QWORD PTR [rdx]
	movzx	edx, WORD PTR [rdx+rax*2]
	mov	ecx, edx
	shr	cx, 8
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L44:
	movzx	ecx, cx
	mov	DWORD PTR [rax], ecx
	mov	DWORD PTR 4[rax], ecx
	mov	DWORD PTR 8[rax], ecx
	ret
	.cfi_endproc
.LFE621:
	.size	fbread_16, .-fbread_16
	.p2align 4,,15
	.globl	fbread2_16
	.type	fbread2_16, @function
fbread2_16:
.LFB622:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	r9d, DWORD PTR 116[rdx]
	mov	rdx, QWORD PTR idxlim16@GOTPCREL[rip]
	lea	eax, [rax+rdi*2]
	mov	edx, DWORD PTR [rdx]
	shr	eax
	and	eax, 8388607
	test	r9d, r9d
	mov	ecx, eax
	jne	.L46
	cmp	rcx, rdx
	jbe	.L54
	xor	ecx, ecx
	xor	edx, edx
.L47:
	mov	edi, 224
	mov	eax, 7
	jmp	.L48
	.p2align 4,,10
	.p2align 3
.L46:
	cmp	rcx, rdx
	jbe	.L55
	xor	ecx, ecx
	xor	edi, edi
	xor	eax, eax
	xor	edx, edx
.L48:
	mov	DWORD PTR [rsi], eax
	mov	rsi, QWORD PTR fb_format@GOTPCREL[rip]
	mov	rax, QWORD PTR pre_memory_color@GOTPCREL[rip]
	mov	r8d, DWORD PTR [rsi]
	mov	DWORD PTR 12[rax], edi
	test	r8d, r8d
	jne	.L56
	and	ecx, 248
	mov	DWORD PTR [rax], ecx
	mov	ecx, edx
	and	edx, 62
	and	ecx, 1984
	sal	edx, 2
	sar	ecx, 3
	mov	DWORD PTR 8[rax], edx
	mov	DWORD PTR 4[rax], ecx
	ret
	.p2align 4,,10
	.p2align 3
.L55:
	mov	rdx, QWORD PTR rdram_16@GOTPCREL[rip]
	xor	eax, 1
	mov	rdx, QWORD PTR [rdx]
	movzx	edx, WORD PTR [rdx+rax*2]
	mov	rax, QWORD PTR hidden_bits@GOTPCREL[rip]
	movzx	eax, BYTE PTR [rax+rcx]
	mov	ecx, edx
	shr	cx, 8
	lea	eax, [rax+rdx*4]
	and	eax, 7
	mov	edi, eax
	sal	edi, 5
	jmp	.L48
	.p2align 4,,10
	.p2align 3
.L54:
	mov	rdx, QWORD PTR rdram_16@GOTPCREL[rip]
	xor	eax, 1
	mov	rdx, QWORD PTR [rdx]
	movzx	edx, WORD PTR [rdx+rax*2]
	mov	ecx, edx
	shr	cx, 8
	jmp	.L47
	.p2align 4,,10
	.p2align 3
.L56:
	movzx	ecx, cx
	mov	DWORD PTR [rax], ecx
	mov	DWORD PTR 4[rax], ecx
	mov	DWORD PTR 8[rax], ecx
	ret
	.cfi_endproc
.LFE622:
	.size	fbread2_16, .-fbread2_16
	.p2align 4,,15
	.globl	fbread_32
	.type	fbread_32, @function
fbread_32:
.LFB623:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	rdx, QWORD PTR idxlim32@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR [rdx]
	lea	eax, [rax+rdi*4]
	and	eax, 16777215
	shr	rax, 2
	cmp	rax, rdx
	ja	.L59
	mov	rdx, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rdx, QWORD PTR 32[rdx]
	mov	eax, DWORD PTR [rdx+rax*4]
	mov	r8d, eax
	mov	r9d, eax
	movzx	edi, ah
	shr	r8d, 16
	shr	r9d, 24
	movzx	ecx, al
	movzx	r8d, r8b
.L58:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rdx, QWORD PTR memory_color@GOTPCREL[rip]
	mov	eax, DWORD PTR 116[rax]
	mov	DWORD PTR [rdx], r9d
	mov	DWORD PTR 4[rdx], r8d
	mov	DWORD PTR 8[rdx], edi
	sub	eax, 1
	or	eax, ecx
	and	eax, 224
	mov	DWORD PTR 12[rdx], eax
	shr	eax, 5
	mov	DWORD PTR [rsi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L59:
	xor	ecx, ecx
	xor	edi, edi
	xor	r8d, r8d
	xor	r9d, r9d
	jmp	.L58
	.cfi_endproc
.LFE623:
	.size	fbread_32, .-fbread_32
	.p2align 4,,15
	.globl	fbread2_32
	.type	fbread2_32, @function
fbread2_32:
.LFB624:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	rdx, QWORD PTR idxlim32@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR [rdx]
	lea	eax, [rax+rdi*4]
	and	eax, 16777215
	shr	rax, 2
	cmp	rax, rdx
	ja	.L62
	mov	rdx, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rdx, QWORD PTR 32[rdx]
	mov	eax, DWORD PTR [rdx+rax*4]
	mov	r8d, eax
	mov	r9d, eax
	movzx	edi, ah
	shr	r8d, 16
	shr	r9d, 24
	movzx	ecx, al
	movzx	r8d, r8b
.L61:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rdx, QWORD PTR pre_memory_color@GOTPCREL[rip]
	mov	eax, DWORD PTR 116[rax]
	mov	DWORD PTR [rdx], r9d
	mov	DWORD PTR 4[rdx], r8d
	mov	DWORD PTR 8[rdx], edi
	sub	eax, 1
	or	eax, ecx
	and	eax, 224
	mov	DWORD PTR 12[rdx], eax
	shr	eax, 5
	mov	DWORD PTR [rsi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L62:
	xor	ecx, ecx
	xor	edi, edi
	xor	r8d, r8d
	xor	r9d, r9d
	jmp	.L61
	.cfi_endproc
.LFE624:
	.size	fbread2_32, .-fbread2_32
	.p2align 4,,15
	.globl	rgb_dither_complete
	.type	rgb_dither_complete, @function
rgb_dither_complete:
.LFB638:
	.cfi_startproc
	mov	r9d, ecx
	mov	ecx, DWORD PTR [rsi]
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	r10d, DWORD PTR [rdi]
	movabs	r8, -4294967296
	mov	r11d, DWORD PTR [rdx]
	sal	rcx, 32
	mov	eax, r10d
	or	rax, rcx
	mov	ecx, 255
	mov	ebx, eax
	and	ebx, 248
	add	ebx, 8
	cmp	eax, 247
	cmovg	rbx, rcx
	and	rax, r8
	or	rax, rbx
	mov	r8, rax
	sar	r8, 32
	mov	ebx, r8d
	and	ebx, 248
	add	ebx, 8
	cmp	r8d, 247
	mov	r8d, eax
	cmovg	ebx, ecx
	mov	eax, r11d
	sal	rbx, 32
	and	eax, 248
	add	eax, 8
	or	r8, rbx
	cmp	r11d, 247
	cmovle	ecx, eax
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	ebx, r9d
	mov	r11d, ecx
	and	r11d, 511
	cmp	DWORD PTR 52[rax], 2
	mov	eax, r9d
	je	.L64
	xor	ecx, ecx
.L68:
	sal	rax, 32
	sar	r9d, cl
	movabs	rcx, 30064771079
	or	rax, rbx
	and	r9d, 7
	and	rax, rcx
	mov	ecx, r10d
	and	ecx, 7
	cmp	ecx, eax
	cmovg	r10d, r8d
	sar	rax, 32
	shr	r8, 32
	mov	DWORD PTR [rdi], r10d
	mov	ecx, DWORD PTR [rsi]
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	mov	edi, ecx
	and	edi, 7
	cmp	edi, eax
	cmovg	rcx, r8
	mov	DWORD PTR [rsi], ecx
	mov	eax, DWORD PTR [rdx]
	mov	ecx, eax
	and	ecx, 7
	cmp	ecx, r9d
	cmovg	eax, r11d
	mov	DWORD PTR [rdx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L64:
	.cfi_restore_state
	sar	eax, 3
	mov	ecx, 6
	jmp	.L68
	.cfi_endproc
.LFE638:
	.size	rgb_dither_complete, .-rgb_dither_complete
	.p2align 4,,15
	.globl	rgb_dither_nothing
	.type	rgb_dither_nothing, @function
rgb_dither_nothing:
.LFB639:
	.cfi_startproc
	rep ret
	.cfi_endproc
.LFE639:
	.size	rgb_dither_nothing, .-rgb_dither_nothing
	.p2align 4,,15
	.globl	get_dither_nothing
	.type	get_dither_nothing, @function
get_dither_nothing:
.LFB642:
	.cfi_startproc
	rep ret
	.cfi_endproc
.LFE642:
	.size	get_dither_nothing, .-get_dither_nothing
	.p2align 4,,15
	.globl	tcdiv_nopersp
	.type	tcdiv_nopersp, @function
tcdiv_nopersp:
.LFB646:
	.cfi_startproc
	movsx	edi, di
	movsx	esi, si
	and	edi, 131071
	and	esi, 131071
	mov	DWORD PTR [rcx], edi
	mov	DWORD PTR [r8], esi
	ret
	.cfi_endproc
.LFE646:
	.size	tcdiv_nopersp, .-tcdiv_nopersp
	.p2align 4,,15
	.globl	tcdiv_persp
	.type	tcdiv_persp, @function
tcdiv_persp:
.LFB647:
	.cfi_startproc
	mov	rax, QWORD PTR tcdiv_table@GOTPCREL[rip]
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	r11, rcx
	mov	ecx, edx
	movsx	edi, di
	movsx	esi, si
	and	ecx, 32767
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	mov	r9d, DWORD PTR [rax+rcx*4]
	mov	eax, r9d
	and	r9d, 15
	sar	eax, 4
	mov	ecx, r9d
	imul	edi, eax
	imul	esi, eax
	mov	eax, 536870912
	sar	eax, cl
	neg	eax
	and	eax, 1073741823
	mov	ebp, eax
	mov	ebx, eax
	and	ebp, edi
	and	ebx, esi
	cmp	r9d, 14
	je	.L78
	mov	ecx, 13
	sub	ecx, r9d
	sar	edi, cl
	sar	esi, cl
	mov	ecx, esi
	mov	r10d, edi
.L79:
	test	ebp, ebp
	je	.L83
	cmp	ebp, eax
	jne	.L100
.L83:
	xor	edi, edi
.L80:
	test	ebx, ebx
	je	.L85
	cmp	ebx, eax
	.p2align 4,,3
	jne	.L101
.L85:
	mov	r9d, 262144
	xor	eax, eax
.L81:
	test	dx, dx
	jg	.L82
	or	edi, 262144
	mov	eax, r9d
.L82:
	mov	esi, r10d
	mov	edx, ecx
	and	esi, 131071
	and	edx, 131071
	or	esi, edi
	or	edx, eax
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	mov	DWORD PTR [r11], esi
	mov	DWORD PTR [r8], edx
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L100:
	.cfi_restore_state
	and	edi, 536870912
	cmp	edi, 1
	sbb	edi, edi
	and	edi, 131072
	add	edi, 131072
	jmp	.L80
	.p2align 4,,10
	.p2align 3
.L101:
	and	esi, 536870912
	cmp	esi, 1
	sbb	r9d, r9d
	and	r9d, -131072
	add	r9d, 393216
	cmp	esi, 1
	sbb	eax, eax
	and	eax, 131072
	add	eax, 131072
	jmp	.L81
	.p2align 4,,10
	.p2align 3
.L78:
	lea	r10d, [rdi+rdi]
	lea	ecx, [rsi+rsi]
	jmp	.L79
	.cfi_endproc
.LFE647:
	.size	tcdiv_persp, .-tcdiv_persp
	.p2align 4,,15
	.globl	get_dither_noise_complete
	.type	get_dither_noise_complete, @function
get_dither_noise_complete:
.LFB640:
	.cfi_startproc
	mov	r8, QWORD PTR iseed@GOTPCREL[rip]
	mov	r10d, DWORD PTR [r8]
	imul	r9d, r10d, 214013
	add	r9d, 2531011
	mov	eax, r9d
	mov	DWORD PTR [r8], r9d
	shr	eax, 10
	and	eax, 448
	or	eax, 32
	mov	DWORD PTR noise[rip], eax
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	cmp	DWORD PTR 168[rax], 15
	ja	.L102
	mov	r10d, DWORD PTR 168[rax]
	lea	rax, .L105[rip]
	movsx	r10, DWORD PTR [rax+r10*4]
	add	rax, r10
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L105:
	.long	.L104-.L105
	.long	.L106-.L105
	.long	.L107-.L105
	.long	.L108-.L105
	.long	.L109-.L105
	.long	.L110-.L105
	.long	.L111-.L105
	.long	.L112-.L105
	.long	.L113-.L105
	.long	.L114-.L105
	.long	.L115-.L105
	.long	.L116-.L105
	.long	.L117-.L105
	.long	.L118-.L105
	.long	.L119-.L105
	.long	.L120-.L105
	.text
	.p2align 4,,10
	.p2align 3
.L120:
	mov	DWORD PTR [rdx], 7
	mov	DWORD PTR [rcx], 0
.L102:
	rep ret
	.p2align 4,,10
	.p2align 3
.L119:
	mov	DWORD PTR [rdx], 7
	mov	eax, DWORD PTR noise[rip]
	sar	eax, 6
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L104:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L106:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
.L121:
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	not	eax
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L107:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
.L122:
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	mov	eax, DWORD PTR noise[rip]
	sar	eax, 6
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L108:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR [rcx], 0
	ret
	.p2align 4,,10
	.p2align 3
.L109:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L110:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	jmp	.L121
	.p2align 4,,10
	.p2align 3
.L111:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	jmp	.L122
	.p2align 4,,10
	.p2align 3
.L112:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR [rcx], 0
	ret
	.p2align 4,,10
	.p2align 3
.L113:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	imul	r9d, r9d, 214013
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	add	r9d, 2531011
	mov	DWORD PTR [r8], r9d
	sar	r9d, 16
	and	r9d, 32767
	mov	DWORD PTR [rdx], r9d
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L114:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	imul	r9d, r9d, 214013
	movzx	eax, BYTE PTR [rax+rsi]
	add	r9d, 2531011
	mov	DWORD PTR [r8], r9d
	not	eax
	sar	r9d, 16
	and	r9d, 32767
	and	eax, 7
	mov	DWORD PTR [rdx], r9d
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L115:
	imul	r9d, r9d, 214013
	add	r9d, 2531011
	mov	DWORD PTR [r8], r9d
	sar	r9d, 16
	and	r9d, 32767
	mov	DWORD PTR [rdx], r9d
	mov	eax, DWORD PTR noise[rip]
	sar	eax, 6
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L116:
	imul	r9d, r9d, 214013
	add	r9d, 2531011
	mov	DWORD PTR [r8], r9d
	sar	r9d, 16
	and	r9d, 32767
	mov	DWORD PTR [rdx], r9d
	mov	DWORD PTR [rcx], 0
	ret
	.p2align 4,,10
	.p2align 3
.L117:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	mov	DWORD PTR [rdx], 7
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L118:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	mov	DWORD PTR [rdx], 7
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	not	eax
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.cfi_endproc
.LFE640:
	.size	get_dither_noise_complete, .-get_dither_noise_complete
	.p2align 4,,15
	.globl	get_dither_only
	.type	get_dither_only, @function
get_dither_only:
.LFB641:
	.cfi_startproc
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	cmp	DWORD PTR 168[rax], 15
	ja	.L123
	mov	r8d, DWORD PTR 168[rax]
	lea	rax, .L126[rip]
	movsx	r8, DWORD PTR [rax+r8*4]
	add	rax, r8
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L126:
	.long	.L125-.L126
	.long	.L127-.L126
	.long	.L128-.L126
	.long	.L129-.L126
	.long	.L130-.L126
	.long	.L131-.L126
	.long	.L132-.L126
	.long	.L133-.L126
	.long	.L134-.L126
	.long	.L135-.L126
	.long	.L136-.L126
	.long	.L137-.L126
	.long	.L138-.L126
	.long	.L139-.L126
	.long	.L140-.L126
	.long	.L141-.L126
	.text
	.p2align 4,,10
	.p2align 3
.L141:
	mov	DWORD PTR [rdx], 7
	mov	DWORD PTR [rcx], 0
.L123:
	rep ret
	.p2align 4,,10
	.p2align 3
.L140:
	mov	DWORD PTR [rdx], 7
	mov	eax, DWORD PTR noise[rip]
	sar	eax, 6
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L125:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L127:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
.L142:
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	not	eax
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L128:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
.L143:
	movzx	eax, BYTE PTR [rax+rsi]
.L144:
	mov	DWORD PTR [rdx], eax
	mov	eax, DWORD PTR noise[rip]
	sar	eax, 6
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L129:
	and	esi, 3
	and	edi, 3
	lea	rax, magic_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR [rcx], 0
	ret
	.p2align 4,,10
	.p2align 3
.L130:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L131:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	jmp	.L142
	.p2align 4,,10
	.p2align 3
.L132:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	jmp	.L143
	.p2align 4,,10
	.p2align 3
.L133:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR [rcx], 0
	ret
	.p2align 4,,10
	.p2align 3
.L134:
	mov	r8, QWORD PTR iseed@GOTPCREL[rip]
	and	esi, 3
	and	edi, 3
	sal	esi, 2
	or	esi, edi
	mov	eax, DWORD PTR [r8]
	movsx	rsi, esi
	imul	eax, eax, 214013
	add	eax, 2531011
	mov	DWORD PTR [r8], eax
	sar	eax, 16
	and	eax, 32767
	mov	DWORD PTR [rdx], eax
	lea	rax, magic_matrix[rip]
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L135:
	mov	r8, QWORD PTR iseed@GOTPCREL[rip]
	and	esi, 3
	and	edi, 3
	sal	esi, 2
	or	esi, edi
	mov	eax, DWORD PTR [r8]
	movsx	rsi, esi
	imul	eax, eax, 214013
	add	eax, 2531011
	mov	DWORD PTR [r8], eax
	sar	eax, 16
	and	eax, 32767
	mov	DWORD PTR [rdx], eax
	lea	rax, magic_matrix[rip]
	movzx	eax, BYTE PTR [rax+rsi]
	not	eax
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L136:
	mov	rsi, QWORD PTR iseed@GOTPCREL[rip]
	mov	eax, DWORD PTR [rsi]
	imul	eax, eax, 214013
	add	eax, 2531011
	mov	DWORD PTR [rsi], eax
	sar	eax, 16
	and	eax, 32767
	jmp	.L144
	.p2align 4,,10
	.p2align 3
.L137:
	mov	rsi, QWORD PTR iseed@GOTPCREL[rip]
	mov	r11d, DWORD PTR [rsi]
	imul	eax, r11d, 214013
	add	eax, 2531011
	mov	DWORD PTR [rsi], eax
	sar	eax, 16
	and	eax, 32767
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR [rcx], 0
	ret
	.p2align 4,,10
	.p2align 3
.L138:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	mov	DWORD PTR [rdx], 7
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rcx], eax
	ret
	.p2align 4,,10
	.p2align 3
.L139:
	and	esi, 3
	and	edi, 3
	lea	rax, bayer_matrix[rip]
	sal	esi, 2
	mov	DWORD PTR [rdx], 7
	or	esi, edi
	movsx	rsi, esi
	movzx	eax, BYTE PTR [rax+rsi]
	not	eax
	and	eax, 7
	mov	DWORD PTR [rcx], eax
	ret
	.cfi_endproc
.LFE641:
	.size	get_dither_only, .-get_dither_only
	.p2align 4,,15
	.globl	fbwrite_16
	.type	fbwrite_16, @function
fbwrite_16:
.LFB611:
	.cfi_startproc
	mov	eax, DWORD PTR 8[rsp]
	sub	r8d, 1
	mov	DWORD PTR -16[rsp], 7
	or	r8d, eax
	mov	DWORD PTR -12[rsp], eax
	add	eax, r9d
	add	r8d, r9d
	mov	DWORD PTR -20[rsp], eax
	mov	eax, r8d
	sal	eax, 28
	sar	eax, 31
	or	eax, r8d
	mov	DWORD PTR -24[rsp], eax
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	movsx	rax, DWORD PTR 108[rax]
	mov	r8d, DWORD PTR -24[rsp+rax*4]
	mov	rax, QWORD PTR fb_format@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	and	r8d, 7
	test	eax, eax
	je	.L146
	mov	ecx, esi
	sal	r8d, 5
	sal	ecx, 8
	or	ecx, r8d
	xor	r8d, r8d
.L147:
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	rdx, QWORD PTR idxlim16@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR [rdx]
	lea	eax, [rax+rdi*2]
	and	eax, 16777215
	shr	rax
	cmp	rax, rdx
	ja	.L145
	mov	rdx, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	rsi, rax
	and	r8d, 3
	xor	rsi, 1
	mov	rdx, QWORD PTR [rdx]
	mov	WORD PTR [rdx+rsi*2], cx
	mov	rdx, QWORD PTR hidden_bits@GOTPCREL[rip]
	mov	BYTE PTR [rdx+rax], r8b
.L145:
	rep ret
	.p2align 4,,10
	.p2align 3
.L146:
	and	ecx, 248
	mov	eax, r8d
	and	edx, 248
	shr	ecx, 2
	sar	eax, 2
	sal	edx, 3
	or	ecx, eax
	and	esi, 248
	or	ecx, edx
	sal	esi, 8
	or	ecx, esi
	jmp	.L147
	.cfi_endproc
.LFE611:
	.size	fbwrite_16, .-fbwrite_16
	.p2align 4,,15
	.globl	fbwrite_32
	.type	fbwrite_32, @function
fbwrite_32:
.LFB612:
	.cfi_startproc
	mov	rax, QWORD PTR fb_address@GOTPCREL[rip]
	mov	r10d, DWORD PTR 8[rsp]
	sub	r8d, 1
	mov	DWORD PTR -16[rsp], 7
	mov	eax, DWORD PTR [rax]
	or	r8d, r10d
	mov	DWORD PTR -12[rsp], r10d
	add	r8d, r9d
	add	r10d, r9d
	mov	DWORD PTR -20[rsp], r10d
	lea	eax, [rax+rdi*4]
	mov	edi, r8d
	sal	edi, 28
	sar	edi, 31
	and	eax, 16777215
	or	edi, r8d
	shr	rax, 2
	mov	DWORD PTR -24[rsp], edi
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	movsx	rdi, DWORD PTR 108[rdi]
	mov	r8d, DWORD PTR -24[rsp+rdi*4]
	mov	rdi, QWORD PTR idxlim32@GOTPCREL[rip]
	mov	edi, DWORD PTR [rdi]
	cmp	rax, rdi
	ja	.L149
	mov	edi, edx
	and	r8d, 7
	sal	ecx, 8
	sal	edi, 16
	sal	r8d, 5
	sal	esi, 24
	or	edi, r8d
	and	edx, 1
	or	edi, ecx
	mov	rcx, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	neg	edx
	or	edi, esi
	and	edx, 3
	mov	rcx, QWORD PTR 32[rcx]
	mov	DWORD PTR [rcx+rax*4], edi
	mov	rcx, QWORD PTR hidden_bits@GOTPCREL[rip]
	mov	BYTE PTR [rcx+rax*2], dl
	mov	BYTE PTR 1[rcx+rax*2], 0
.L149:
	rep ret
	.cfi_endproc
.LFE612:
	.size	fbwrite_32, .-fbwrite_32
	.p2align 4,,15
	.globl	tcmask
	.type	tcmask, @function
tcmask:
.LFB551:
	.cfi_startproc
	movsx	rdx, edx
	mov	rax, QWORD PTR tile@GOTPCREL[rip]
	lea	rcx, [rdx+rdx*4]
	lea	rcx, [rcx+rcx*4]
	lea	r8, [rax+rcx*4]
	lea	r9, 32[r8]
	movsx	rcx, DWORD PTR 12[r9]
	test	ecx, ecx
	je	.L152
	mov	r10d, DWORD PTR 32[r8]
	test	r10d, r10d
	jne	.L153
	mov	r8d, DWORD PTR [rdi]
.L154:
	mov	r9, QWORD PTR maskbits_table@GOTPCREL[rip]
	and	r8d, DWORD PTR [r9+rcx*4]
	mov	DWORD PTR [rdi], r8d
.L152:
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [rax+rdx*4]
	lea	rdi, 32[rdx]
	movsx	rax, DWORD PTR 4[rdi]
	test	eax, eax
	je	.L151
	mov	ecx, DWORD PTR 24[rdx]
	test	ecx, ecx
	jne	.L156
	mov	edx, DWORD PTR [rsi]
.L157:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	and	edx, DWORD PTR [rcx+rax*4]
	mov	DWORD PTR [rsi], edx
.L151:
	rep ret
	.p2align 4,,10
	.p2align 3
.L156:
	mov	eax, DWORD PTR [rsi]
	mov	ecx, DWORD PTR 88[rdx]
	mov	edx, eax
	sar	edx, cl
	and	edx, 1
	neg	edx
	xor	edx, eax
	mov	DWORD PTR [rsi], edx
	movsx	rax, DWORD PTR 4[rdi]
	jmp	.L157
	.p2align 4,,10
	.p2align 3
.L153:
	mov	r10d, DWORD PTR [rdi]
	mov	ecx, DWORD PTR 84[r8]
	mov	r8d, r10d
	sar	r8d, cl
	and	r8d, 1
	neg	r8d
	xor	r8d, r10d
	mov	DWORD PTR [rdi], r8d
	movsx	rcx, DWORD PTR 12[r9]
	jmp	.L154
	.cfi_endproc
.LFE551:
	.size	tcmask, .-tcmask
	.p2align 4,,15
	.globl	tcmask_coupled
	.type	tcmask_coupled, @function
tcmask_coupled:
.LFB552:
	.cfi_startproc
	movsx	r8, r8d
	mov	rax, QWORD PTR tile@GOTPCREL[rip]
	mov	r10, rcx
	lea	r9, [r8+r8*4]
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	lea	rcx, [r9+r9*4]
	lea	r9, [rax+rcx*4]
	movsx	rcx, DWORD PTR 44[r9]
	lea	r11, 32[r9]
	test	ecx, ecx
	je	.L165
	mov	ebx, DWORD PTR 32[r9]
	test	ebx, ebx
	jne	.L176
.L166:
	mov	r9, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	ecx, DWORD PTR [r9+rcx*4]
	and	DWORD PTR [rdi], ecx
	and	DWORD PTR [rsi], ecx
.L165:
	lea	rsi, [r8+r8*4]
	lea	rcx, [rsi+rsi*4]
	lea	rsi, [rax+rcx*4]
	movsx	rax, DWORD PTR 36[rsi]
	lea	rdi, 32[rsi]
	test	eax, eax
	je	.L164
	mov	r11d, DWORD PTR 24[rsi]
	test	r11d, r11d
	je	.L168
	mov	ecx, DWORD PTR 88[rsi]
	mov	esi, DWORD PTR [rdx]
	mov	eax, esi
	sar	eax, cl
	and	eax, 1
	neg	eax
	xor	eax, esi
	mov	DWORD PTR [rdx], eax
	mov	esi, DWORD PTR [r10]
	mov	eax, esi
	sar	eax, cl
	and	eax, 1
	neg	eax
	xor	eax, esi
	mov	DWORD PTR [r10], eax
	movsx	rax, DWORD PTR 4[rdi]
.L168:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	eax, DWORD PTR [rcx+rax*4]
	and	DWORD PTR [rdx], eax
	and	DWORD PTR [r10], eax
.L164:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L176:
	.cfi_restore_state
	mov	ebx, DWORD PTR [rdi]
	mov	ecx, DWORD PTR 84[r9]
	mov	r9d, ebx
	sar	r9d, cl
	and	r9d, 1
	neg	r9d
	xor	r9d, ebx
	mov	DWORD PTR [rdi], r9d
	mov	r9d, DWORD PTR [rsi]
	mov	ebx, r9d
	sar	ebx, cl
	mov	ecx, ebx
	and	ecx, 1
	neg	ecx
	xor	ecx, r9d
	mov	DWORD PTR [rsi], ecx
	movsx	rcx, DWORD PTR 12[r11]
	jmp	.L166
	.cfi_endproc
.LFE552:
	.size	tcmask_coupled, .-tcmask_coupled
	.p2align 4,,15
	.globl	tcmask_copy
	.type	tcmask_copy, @function
tcmask_copy:
.LFB553:
	.cfi_startproc
	movsx	r9, r9d
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rax, QWORD PTR tile@GOTPCREL[rip]
	lea	r10, [r9+r9*4]
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	mov	rbx, rcx
	lea	rcx, [r10+r10*4]
	lea	r11, [rax+rcx*4]
	movsx	r10, DWORD PTR 44[r11]
	lea	rbp, 32[r11]
	test	r10d, r10d
	je	.L178
	mov	ecx, DWORD PTR 32[r11]
	test	ecx, ecx
	jne	.L190
.L179:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx+r10*4]
	and	DWORD PTR [rdi], ecx
	and	DWORD PTR [rsi], ecx
	and	DWORD PTR [rdx], ecx
	and	DWORD PTR [rbx], ecx
.L178:
	lea	rdx, [r9+r9*4]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [rax+rdx*4]
	lea	rsi, 32[rdx]
	movsx	rax, DWORD PTR 4[rsi]
	test	eax, eax
	je	.L177
	mov	ebp, DWORD PTR 24[rdx]
	test	ebp, ebp
	jne	.L181
	mov	edx, DWORD PTR [r8]
.L182:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	and	edx, DWORD PTR [rcx+rax*4]
	mov	DWORD PTR [r8], edx
.L177:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L181:
	.cfi_restore_state
	mov	eax, DWORD PTR [r8]
	mov	ecx, DWORD PTR 88[rdx]
	mov	edx, eax
	sar	edx, cl
	and	edx, 1
	neg	edx
	xor	edx, eax
	mov	DWORD PTR [r8], edx
	movsx	rax, DWORD PTR 4[rsi]
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L190:
	mov	ecx, DWORD PTR 84[r11]
	mov	r11d, DWORD PTR [rdi]
	mov	r10d, r11d
	sar	r10d, cl
	and	r10d, 1
	neg	r10d
	xor	r10d, r11d
	mov	DWORD PTR [rdi], r10d
	mov	r11d, DWORD PTR [rsi]
	mov	r10d, r11d
	sar	r10d, cl
	and	r10d, 1
	neg	r10d
	xor	r10d, r11d
	mov	DWORD PTR [rsi], r10d
	mov	r11d, DWORD PTR [rdx]
	mov	r10d, r11d
	sar	r10d, cl
	and	r10d, 1
	neg	r10d
	xor	r10d, r11d
	mov	DWORD PTR [rdx], r10d
	mov	r10d, DWORD PTR [rbx]
	mov	r11d, r10d
	sar	r11d, cl
	mov	ecx, r11d
	and	ecx, 1
	neg	ecx
	xor	ecx, r10d
	mov	DWORD PTR [rbx], ecx
	movsx	r10, DWORD PTR 12[rbp]
	jmp	.L179
	.cfi_endproc
.LFE553:
	.size	tcmask_copy, .-tcmask_copy
	.p2align 4,,15
	.globl	tcshift_cycle
	.type	tcshift_cycle, @function
tcshift_cycle:
.LFB554:
	.cfi_startproc
	mov	r8d, r8d
	mov	rax, QWORD PTR tile@GOTPCREL[rip]
	mov	r11, rcx
	lea	r10, [r8+r8*4]
	mov	r9d, DWORD PTR [rdi]
	lea	rcx, [r10+r10*4]
	mov	r10d, DWORD PTR 48[rax+rcx*4]
	cmp	r10d, 10
	jg	.L192
	movsx	r9d, r9w
	mov	ecx, r10d
	sar	r9d, cl
.L193:
	mov	DWORD PTR [rdi], r9d
	lea	rdi, [r8+r8*4]
	sar	r9d, 3
	lea	rcx, [rdi+rdi*4]
	lea	rdi, [rax+rcx*4]
	xor	ecx, ecx
	cmp	r9d, DWORD PTR 60[rdi]
	setge	cl
	mov	DWORD PTR [rdx], ecx
	mov	edi, DWORD PTR 40[rdi]
	mov	edx, DWORD PTR [rsi]
	cmp	edi, 10
	jle	.L196
	mov	ecx, 16
	sub	ecx, edi
	sal	edx, cl
	movsx	edx, dx
.L195:
	mov	DWORD PTR [rsi], edx
	lea	rsi, [r8+r8*4]
	sar	edx, 3
	lea	rcx, [rsi+rsi*4]
	cmp	edx, DWORD PTR 64[rax+rcx*4]
	setge	al
	movzx	eax, al
	mov	DWORD PTR [r11], eax
	ret
	.p2align 4,,10
	.p2align 3
.L192:
	mov	ecx, 16
	sub	ecx, r10d
	sal	r9d, cl
	movsx	r9d, r9w
	jmp	.L193
	.p2align 4,,10
	.p2align 3
.L196:
	movsx	edx, dx
	mov	ecx, edi
	sar	edx, cl
	jmp	.L195
	.cfi_endproc
.LFE554:
	.size	tcshift_cycle, .-tcshift_cycle
	.p2align 4,,15
	.globl	tcshift_copy
	.type	tcshift_copy, @function
tcshift_copy:
.LFB555:
	.cfi_startproc
	mov	edx, edx
	mov	rax, QWORD PTR tile@GOTPCREL[rip]
	mov	r8d, DWORD PTR [rdi]
	lea	r9, [rdx+rdx*4]
	lea	rcx, [r9+r9*4]
	mov	r9d, DWORD PTR 48[rax+rcx*4]
	cmp	r9d, 10
	jg	.L198
	movsx	r8d, r8w
	mov	ecx, r9d
	sar	r8d, cl
.L199:
	lea	rdx, [rdx+rdx*4]
	mov	DWORD PTR [rdi], r8d
	mov	edi, DWORD PTR [rsi]
	lea	rdx, [rdx+rdx*4]
	mov	eax, DWORD PTR 40[rax+rdx*4]
	cmp	eax, 10
	jle	.L202
	mov	ecx, 16
	sub	ecx, eax
	sal	edi, cl
	movsx	edx, di
	mov	DWORD PTR [rsi], edx
	ret
	.p2align 4,,10
	.p2align 3
.L198:
	mov	ecx, 16
	sub	ecx, r9d
	sal	r8d, cl
	movsx	r8d, r8w
	jmp	.L199
	.p2align 4,,10
	.p2align 3
.L202:
	movsx	edx, di
	mov	ecx, eax
	sar	edx, cl
	mov	DWORD PTR [rsi], edx
	ret
	.cfi_endproc
.LFE555:
	.size	tcshift_copy, .-tcshift_copy
	.p2align 4,,15
	.globl	tcclamp_cycle
	.type	tcclamp_cycle, @function
tcclamp_cycle:
.LFB556:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	r10, QWORD PTR tile@GOTPCREL[rip]
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movsx	rax, DWORD PTR 24[rsp]
	mov	ebp, DWORD PTR [rdi]
	mov	ebx, DWORD PTR [rsi]
	lea	r11, [rax+rax*4]
	lea	r11, [r11+r11*4]
	lea	r11, 64[r10+r11*4]
	cmp	DWORD PTR 12[r11], 0
	je	.L204
	test	ebp, 65536
	jne	.L205
	test	r8d, r8d
	jne	.L206
.L204:
	sar	ebp, 5
	mov	DWORD PTR [rdi], ebp
.L207:
	lea	rax, [rax+rax*4]
	lea	rax, [rax+rax*4]
	lea	rax, 64[r10+rax*4]
	mov	edi, DWORD PTR 16[rax]
	test	edi, edi
	je	.L208
	test	ebx, 65536
	jne	.L209
	test	r9d, r9d
	jne	.L210
.L208:
	sar	ebx, 5
	mov	DWORD PTR [rsi], ebx
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L205:
	.cfi_restore_state
	mov	DWORD PTR [rdi], 0
	mov	DWORD PTR [rdx], 0
	jmp	.L207
	.p2align 4,,10
	.p2align 3
.L209:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	mov	DWORD PTR [rsi], 0
	mov	DWORD PTR [rcx], 0
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L210:
	.cfi_restore_state
	mov	eax, DWORD PTR 8[rax]
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	mov	DWORD PTR [rsi], eax
	mov	DWORD PTR [rcx], 0
	ret
	.p2align 4,,10
	.p2align 3
.L206:
	.cfi_restore_state
	mov	r8d, DWORD PTR 4[r11]
	mov	DWORD PTR [rdi], r8d
	mov	DWORD PTR [rdx], 0
	jmp	.L207
	.cfi_endproc
.LFE556:
	.size	tcclamp_cycle, .-tcclamp_cycle
	.p2align 4,,15
	.globl	tcclamp_cycle_light
	.type	tcclamp_cycle_light, @function
tcclamp_cycle_light:
.LFB557:
	.cfi_startproc
	movsx	r8, r8d
	mov	rax, QWORD PTR tile@GOTPCREL[rip]
	mov	r11d, DWORD PTR [rdi]
	lea	r9, [r8+r8*4]
	mov	r10d, DWORD PTR [rsi]
	lea	r9, [r9+r9*4]
	lea	r9, 64[rax+r9*4]
	cmp	DWORD PTR 12[r9], 0
	je	.L214
	test	r11d, 65536
	jne	.L215
	test	edx, edx
	jne	.L216
.L214:
	sar	r11d, 5
	mov	DWORD PTR [rdi], r11d
.L217:
	lea	rdx, [r8+r8*4]
	lea	rdx, [rdx+rdx*4]
	lea	rax, 64[rax+rdx*4]
	mov	edx, DWORD PTR 16[rax]
	test	edx, edx
	je	.L218
	test	r10d, 65536
	jne	.L219
	test	ecx, ecx
	jne	.L220
.L218:
	sar	r10d, 5
	mov	DWORD PTR [rsi], r10d
	ret
	.p2align 4,,10
	.p2align 3
.L215:
	mov	DWORD PTR [rdi], 0
	jmp	.L217
	.p2align 4,,10
	.p2align 3
.L219:
	mov	DWORD PTR [rsi], 0
	ret
	.p2align 4,,10
	.p2align 3
.L220:
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR [rsi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L216:
	mov	edx, DWORD PTR 4[r9]
	mov	DWORD PTR [rdi], edx
	jmp	.L217
	.cfi_endproc
.LFE557:
	.size	tcclamp_cycle_light, .-tcclamp_cycle_light
	.p2align 4,,15
	.globl	SET_SUBA_RGB_INPUT
	.type	SET_SUBA_RGB_INPUT, @function
SET_SUBA_RGB_INPUT:
.LFB559:
	.cfi_startproc
	lea	rax, .L225[rip]
	and	ecx, 15
	movsx	rcx, DWORD PTR [rax+rcx*4]
	add	rax, rcx
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L225:
	.long	.L223-.L225
	.long	.L224-.L225
	.long	.L226-.L225
	.long	.L227-.L225
	.long	.L228-.L225
	.long	.L229-.L225
	.long	.L230-.L225
	.long	.L231-.L225
	.long	.L232-.L225
	.long	.L232-.L225
	.long	.L232-.L225
	.long	.L232-.L225
	.long	.L232-.L225
	.long	.L232-.L225
	.long	.L232-.L225
	.long	.L232-.L225
	.text
	.p2align 4,,10
	.p2align 3
.L231:
	lea	rax, noise[rip]
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L223:
	mov	rax, QWORD PTR combined_color@GOTPCREL[rip]
	.p2align 4,,10
	.p2align 3
.L234:
	lea	rcx, 4[rax]
	mov	QWORD PTR [rdi], rax
	add	rax, 8
	mov	QWORD PTR [rsi], rcx
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L224:
	mov	rax, QWORD PTR texel0_color@GOTPCREL[rip]
	jmp	.L234
	.p2align 4,,10
	.p2align 3
.L226:
	mov	rax, QWORD PTR texel1_color@GOTPCREL[rip]
	jmp	.L234
	.p2align 4,,10
	.p2align 3
.L227:
	mov	rax, QWORD PTR prim_color@GOTPCREL[rip]
	jmp	.L234
	.p2align 4,,10
	.p2align 3
.L228:
	mov	rax, QWORD PTR shade_color@GOTPCREL[rip]
	jmp	.L234
	.p2align 4,,10
	.p2align 3
.L229:
	mov	rax, QWORD PTR env_color@GOTPCREL[rip]
	jmp	.L234
	.p2align 4,,10
	.p2align 3
.L230:
	lea	rax, one_color[rip]
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L232:
	lea	rax, zero_color[rip]
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.cfi_endproc
.LFE559:
	.size	SET_SUBA_RGB_INPUT, .-SET_SUBA_RGB_INPUT
	.p2align 4,,15
	.globl	SET_SUBB_RGB_INPUT
	.type	SET_SUBB_RGB_INPUT, @function
SET_SUBB_RGB_INPUT:
.LFB560:
	.cfi_startproc
	lea	rax, .L238[rip]
	and	ecx, 15
	movsx	rcx, DWORD PTR [rax+rcx*4]
	add	rax, rcx
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L238:
	.long	.L236-.L238
	.long	.L237-.L238
	.long	.L239-.L238
	.long	.L240-.L238
	.long	.L241-.L238
	.long	.L242-.L238
	.long	.L243-.L238
	.long	.L244-.L238
	.long	.L245-.L238
	.long	.L245-.L238
	.long	.L245-.L238
	.long	.L245-.L238
	.long	.L245-.L238
	.long	.L245-.L238
	.long	.L245-.L238
	.long	.L245-.L238
	.text
	.p2align 4,,10
	.p2align 3
.L244:
	mov	rax, QWORD PTR k_YUV_RGB@GOTPCREL[rip]
	add	rax, 16
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L236:
	mov	rax, QWORD PTR combined_color@GOTPCREL[rip]
	.p2align 4,,10
	.p2align 3
.L247:
	lea	rcx, 4[rax]
	mov	QWORD PTR [rdi], rax
	add	rax, 8
	mov	QWORD PTR [rsi], rcx
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L237:
	mov	rax, QWORD PTR texel0_color@GOTPCREL[rip]
	jmp	.L247
	.p2align 4,,10
	.p2align 3
.L239:
	mov	rax, QWORD PTR texel1_color@GOTPCREL[rip]
	jmp	.L247
	.p2align 4,,10
	.p2align 3
.L240:
	mov	rax, QWORD PTR prim_color@GOTPCREL[rip]
	jmp	.L247
	.p2align 4,,10
	.p2align 3
.L241:
	mov	rax, QWORD PTR shade_color@GOTPCREL[rip]
	jmp	.L247
	.p2align 4,,10
	.p2align 3
.L242:
	mov	rax, QWORD PTR env_color@GOTPCREL[rip]
	jmp	.L247
	.p2align 4,,10
	.p2align 3
.L243:
	mov	rax, QWORD PTR key_center@GOTPCREL[rip]
	jmp	.L247
	.p2align 4,,10
	.p2align 3
.L245:
	lea	rax, zero_color[rip]
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.cfi_endproc
.LFE560:
	.size	SET_SUBB_RGB_INPUT, .-SET_SUBB_RGB_INPUT
	.p2align 4,,15
	.globl	SET_MUL_RGB_INPUT
	.type	SET_MUL_RGB_INPUT, @function
SET_MUL_RGB_INPUT:
.LFB561:
	.cfi_startproc
	lea	rax, .L251[rip]
	and	ecx, 31
	movsx	rcx, DWORD PTR [rax+rcx*4]
	add	rax, rcx
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L251:
	.long	.L249-.L251
	.long	.L250-.L251
	.long	.L252-.L251
	.long	.L253-.L251
	.long	.L254-.L251
	.long	.L255-.L251
	.long	.L256-.L251
	.long	.L257-.L251
	.long	.L258-.L251
	.long	.L259-.L251
	.long	.L260-.L251
	.long	.L261-.L251
	.long	.L262-.L251
	.long	.L263-.L251
	.long	.L264-.L251
	.long	.L265-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.long	.L266-.L251
	.text
	.p2align 4,,10
	.p2align 3
.L265:
	mov	rax, QWORD PTR k_YUV_RGB@GOTPCREL[rip]
	add	rax, 20
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L249:
	mov	rax, QWORD PTR combined_color@GOTPCREL[rip]
	.p2align 4,,10
	.p2align 3
.L268:
	lea	rcx, 4[rax]
	mov	QWORD PTR [rdi], rax
	add	rax, 8
	mov	QWORD PTR [rsi], rcx
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L250:
	mov	rax, QWORD PTR texel0_color@GOTPCREL[rip]
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L252:
	mov	rax, QWORD PTR texel1_color@GOTPCREL[rip]
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L253:
	mov	rax, QWORD PTR prim_color@GOTPCREL[rip]
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L254:
	mov	rax, QWORD PTR shade_color@GOTPCREL[rip]
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L255:
	mov	rax, QWORD PTR env_color@GOTPCREL[rip]
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L256:
	mov	rax, QWORD PTR key_scale@GOTPCREL[rip]
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L257:
	mov	rax, QWORD PTR combined_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L258:
	mov	rax, QWORD PTR texel0_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L259:
	mov	rax, QWORD PTR texel1_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L260:
	mov	rax, QWORD PTR prim_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L261:
	mov	rax, QWORD PTR shade_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L262:
	mov	rax, QWORD PTR env_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L263:
	lea	rax, lod_frac[rip]
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L264:
	mov	rax, QWORD PTR primitive_lod_frac@GOTPCREL[rip]
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L266:
	lea	rax, zero_color[rip]
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.cfi_endproc
.LFE561:
	.size	SET_MUL_RGB_INPUT, .-SET_MUL_RGB_INPUT
	.p2align 4,,15
	.globl	SET_ADD_RGB_INPUT
	.type	SET_ADD_RGB_INPUT, @function
SET_ADD_RGB_INPUT:
.LFB562:
	.cfi_startproc
	lea	rax, .L272[rip]
	and	ecx, 7
	movsx	rcx, DWORD PTR [rax+rcx*4]
	add	rax, rcx
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L272:
	.long	.L270-.L272
	.long	.L271-.L272
	.long	.L273-.L272
	.long	.L274-.L272
	.long	.L275-.L272
	.long	.L276-.L272
	.long	.L277-.L272
	.long	.L278-.L272
	.text
	.p2align 4,,10
	.p2align 3
.L277:
	lea	rax, one_color[rip]
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L270:
	mov	rax, QWORD PTR combined_color@GOTPCREL[rip]
	.p2align 4,,10
	.p2align 3
.L280:
	lea	rcx, 4[rax]
	mov	QWORD PTR [rdi], rax
	add	rax, 8
	mov	QWORD PTR [rsi], rcx
	mov	QWORD PTR [rdx], rax
	ret
	.p2align 4,,10
	.p2align 3
.L271:
	mov	rax, QWORD PTR texel0_color@GOTPCREL[rip]
	jmp	.L280
	.p2align 4,,10
	.p2align 3
.L273:
	mov	rax, QWORD PTR texel1_color@GOTPCREL[rip]
	jmp	.L280
	.p2align 4,,10
	.p2align 3
.L274:
	mov	rax, QWORD PTR prim_color@GOTPCREL[rip]
	jmp	.L280
	.p2align 4,,10
	.p2align 3
.L275:
	mov	rax, QWORD PTR shade_color@GOTPCREL[rip]
	jmp	.L280
	.p2align 4,,10
	.p2align 3
.L276:
	mov	rax, QWORD PTR env_color@GOTPCREL[rip]
	jmp	.L280
	.p2align 4,,10
	.p2align 3
.L278:
	lea	rax, zero_color[rip]
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rdx], rax
	ret
	.cfi_endproc
.LFE562:
	.size	SET_ADD_RGB_INPUT, .-SET_ADD_RGB_INPUT
	.p2align 4,,15
	.globl	SET_SUB_ALPHA_INPUT
	.type	SET_SUB_ALPHA_INPUT, @function
SET_SUB_ALPHA_INPUT:
.LFB563:
	.cfi_startproc
	lea	rax, .L284[rip]
	and	esi, 7
	movsx	rdx, DWORD PTR [rax+rsi*4]
	add	rax, rdx
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L284:
	.long	.L282-.L284
	.long	.L283-.L284
	.long	.L285-.L284
	.long	.L286-.L284
	.long	.L287-.L284
	.long	.L288-.L284
	.long	.L289-.L284
	.long	.L290-.L284
	.text
	.p2align 4,,10
	.p2align 3
.L289:
	lea	rax, one_color[rip]
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L282:
	mov	rax, QWORD PTR combined_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L283:
	mov	rax, QWORD PTR texel0_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L285:
	mov	rax, QWORD PTR texel1_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L286:
	mov	rax, QWORD PTR prim_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L287:
	mov	rax, QWORD PTR shade_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L288:
	mov	rax, QWORD PTR env_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L290:
	lea	rax, zero_color[rip]
	mov	QWORD PTR [rdi], rax
	ret
	.cfi_endproc
.LFE563:
	.size	SET_SUB_ALPHA_INPUT, .-SET_SUB_ALPHA_INPUT
	.p2align 4,,15
	.globl	SET_MUL_ALPHA_INPUT
	.type	SET_MUL_ALPHA_INPUT, @function
SET_MUL_ALPHA_INPUT:
.LFB564:
	.cfi_startproc
	lea	rax, .L295[rip]
	and	esi, 7
	movsx	rdx, DWORD PTR [rax+rsi*4]
	add	rax, rdx
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L295:
	.long	.L293-.L295
	.long	.L294-.L295
	.long	.L296-.L295
	.long	.L297-.L295
	.long	.L298-.L295
	.long	.L299-.L295
	.long	.L300-.L295
	.long	.L301-.L295
	.text
	.p2align 4,,10
	.p2align 3
.L300:
	mov	rax, QWORD PTR primitive_lod_frac@GOTPCREL[rip]
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L293:
	lea	rax, lod_frac[rip]
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L294:
	mov	rax, QWORD PTR texel0_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L296:
	mov	rax, QWORD PTR texel1_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L297:
	mov	rax, QWORD PTR prim_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L298:
	mov	rax, QWORD PTR shade_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L299:
	mov	rax, QWORD PTR env_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [rdi], rax
	ret
	.p2align 4,,10
	.p2align 3
.L301:
	lea	rax, zero_color[rip]
	mov	QWORD PTR [rdi], rax
	ret
	.cfi_endproc
.LFE564:
	.size	SET_MUL_ALPHA_INPUT, .-SET_MUL_ALPHA_INPUT
	.p2align 4,,15
	.globl	combiner_1cycle
	.type	combiner_1cycle, @function
combiner_1cycle:
.LFB565:
	.cfi_startproc
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	mov	rax, QWORD PTR combiner_rgbmul_r@GOTPCREL[rip]
	lea	r11, zero_color[rip]
	push	r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	push	r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	push	rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	push	rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	mov	rax, QWORD PTR 8[rax]
	cmp	rax, r11
	je	.L327
	mov	rcx, QWORD PTR combiner_rgbsub_a_r@GOTPCREL[rip]
	mov	r8, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	r10, QWORD PTR combiner_rgbsub_b_g@GOTPCREL[rip]
	mov	rbx, QWORD PTR combiner_rgbsub_b_b@GOTPCREL[rip]
	mov	rcx, QWORD PTR 8[rcx]
	mov	r8, QWORD PTR 8[r8]
	mov	edx, eax
	mov	r10, QWORD PTR 8[r10]
	and	edx, 256
	mov	rbx, QWORD PTR 8[rbx]
	movsx	r8, DWORD PTR [r8]
	movsx	rcx, DWORD PTR [rcx]
	neg	edx
	or	edx, eax
	mov	rax, QWORD PTR special_9bit_exttable@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rax+rcx*4]
	sub	ecx, DWORD PTR [rax+r8*4]
	imul	edx, ecx
	mov	rcx, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	mov	rcx, QWORD PTR 8[rcx]
	movsx	rcx, DWORD PTR [rcx]
	mov	ecx, DWORD PTR [rax+rcx*4]
	sal	ecx, 8
	lea	r8d, 128[rdx+rcx]
	mov	rcx, QWORD PTR combiner_rgbmul_g@GOTPCREL[rip]
	mov	rdx, QWORD PTR combined_color@GOTPCREL[rip]
	and	r8d, 131071
	mov	rcx, QWORD PTR 8[rcx]
	mov	DWORD PTR [rdx], r8d
	movsx	r10, DWORD PTR [r10]
	mov	r9d, DWORD PTR [rcx]
	mov	ecx, r9d
	and	ecx, 256
	neg	ecx
	or	ecx, r9d
	mov	r9, QWORD PTR combiner_rgbsub_a_g@GOTPCREL[rip]
	mov	r9, QWORD PTR 8[r9]
	movsx	r9, DWORD PTR [r9]
	mov	r9d, DWORD PTR [rax+r9*4]
	sub	r9d, DWORD PTR [rax+r10*4]
	imul	ecx, r9d
	mov	r9, QWORD PTR combiner_rgbadd_g@GOTPCREL[rip]
	mov	r9, QWORD PTR 8[r9]
	movsx	r9, DWORD PTR [r9]
	mov	r9d, DWORD PTR [rax+r9*4]
	sal	r9d, 8
	lea	r9d, 128[rcx+r9]
	mov	rcx, QWORD PTR combiner_rgbmul_b@GOTPCREL[rip]
	and	r9d, 131071
	mov	rcx, QWORD PTR 8[rcx]
	mov	DWORD PTR 4[rdx], r9d
	movsx	rbx, DWORD PTR [rbx]
	mov	r10d, DWORD PTR [rcx]
	mov	ecx, r10d
	and	ecx, 256
	neg	ecx
	or	ecx, r10d
	mov	r10, QWORD PTR combiner_rgbsub_a_b@GOTPCREL[rip]
	mov	r10, QWORD PTR 8[r10]
	movsx	r10, DWORD PTR [r10]
	mov	r10d, DWORD PTR [rax+r10*4]
	sub	r10d, DWORD PTR [rax+rbx*4]
	imul	ecx, r10d
	mov	r10, QWORD PTR combiner_rgbadd_b@GOTPCREL[rip]
	mov	r10, QWORD PTR 8[r10]
	movsx	r10, DWORD PTR [r10]
	mov	r10d, DWORD PTR [rax+r10*4]
	sal	r10d, 8
	lea	r10d, 128[rcx+r10]
	and	r10d, 131071
	mov	DWORD PTR 8[rdx], r10d
	mov	rcx, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	mov	rcx, QWORD PTR 8[rcx]
	cmp	rcx, r11
	je	.L328
.L306:
	mov	r11d, DWORD PTR [rcx]
	mov	rbx, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	mov	ecx, r11d
	mov	rbx, QWORD PTR 8[rbx]
	and	ecx, 256
	neg	ecx
	or	ecx, r11d
	mov	r11, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	movsx	rbx, DWORD PTR [rbx]
	mov	r11, QWORD PTR 8[r11]
	movsx	r11, DWORD PTR [r11]
	mov	r11d, DWORD PTR [rax+r11*4]
	sub	r11d, DWORD PTR [rax+rbx*4]
	imul	ecx, r11d
	mov	r11, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	mov	r11, QWORD PTR 8[r11]
	movsx	r11, DWORD PTR [r11]
	mov	eax, DWORD PTR [rax+r11*4]
	sal	eax, 8
	lea	eax, 128[rcx+rax]
	sar	eax, 8
	and	eax, 511
.L307:
	mov	rcx, QWORD PTR special_9bit_clamptable@GOTPCREL[rip]
	mov	DWORD PTR 12[rdx], eax
	cdqe
	mov	r11d, DWORD PTR [rcx+rax*4]
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	cmp	r11d, 255
	je	.L308
	mov	DWORD PTR 12[rax], r11d
	mov	r13d, r11d
.L309:
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	cmp	DWORD PTR 48[rbx], 0
	jne	.L329
	sar	r8d, 8
	sar	r9d, 8
	sar	r10d, 8
	mov	DWORD PTR [rdx], r8d
	movsx	r8, r8d
	mov	DWORD PTR 4[rdx], r9d
	mov	DWORD PTR 8[rdx], r10d
	mov	edx, DWORD PTR [rcx+r8*4]
	movsx	r9, r9d
	movsx	r10, r10d
	mov	DWORD PTR [rax], edx
	mov	edx, DWORD PTR [rcx+r9*4]
	mov	DWORD PTR 4[rax], edx
	mov	edx, DWORD PTR [rcx+r10*4]
	mov	DWORD PTR 8[rax], edx
.L310:
	mov	r9d, DWORD PTR 100[rbx]
	xor	edx, edx
	test	r9d, r9d
	je	.L311
	mov	edx, DWORD PTR [rsi]
	imul	edx, r13d
	add	edx, 4
	shr	edx, 3
	mov	ecx, edx
	sar	ecx, 5
	and	ecx, 15
	mov	DWORD PTR [rsi], ecx
.L311:
	mov	r8d, DWORD PTR 96[rbx]
	test	r8d, r8d
	jne	.L312
	mov	esi, DWORD PTR 48[rbx]
	test	esi, esi
	jne	.L313
	mov	edx, DWORD PTR 12[rax]
	add	edx, edi
	mov	DWORD PTR 12[rax], edx
	and	dh, 1
	je	.L315
	mov	DWORD PTR 12[rax], 255
	jmp	.L315
	.p2align 4,,10
	.p2align 3
.L312:
	mov	ecx, DWORD PTR 100[rbx]
	test	ecx, ecx
	je	.L330
.L316:
	mov	ecx, 255
	cmp	edx, 256
	cmovl	ecx, edx
	mov	DWORD PTR 12[rax], ecx
.L315:
	mov	rdx, QWORD PTR shade_color@GOTPCREL[rip]
	mov	eax, 255
	add	edi, DWORD PTR 12[rdx]
	test	edi, 256
	cmove	eax, edi
	mov	DWORD PTR 12[rdx], eax
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
	ret
	.p2align 4,,10
	.p2align 3
.L330:
	.cfi_restore_state
	mov	edx, DWORD PTR [rsi]
	sal	edx, 5
	jmp	.L316
	.p2align 4,,10
	.p2align 3
.L313:
	mov	rdx, QWORD PTR keyalpha@GOTPCREL[rip]
	mov	edx, DWORD PTR [rdx]
	mov	DWORD PTR 12[rax], edx
	jmp	.L315
.L329:
	mov	r11, QWORD PTR key_width@GOTPCREL[rip]
	mov	r14d, 255
	mov	ebp, DWORD PTR 8[r11]
	mov	r12d, DWORD PTR 4[r11]
	mov	r11d, DWORD PTR [r11]
	sal	ebp, 4
	sal	r12d, 4
	sal	r11d, 4
	sub	ebp, r10d
	sub	r12d, r9d
	sub	r11d, r8d
	cmp	r11d, 255
	cmovg	r11d, r14d
	cmp	r12d, r11d
	cmovle	r11d, r12d
	cmp	ebp, r11d
	cmovg	ebp, r11d
	mov	r11, QWORD PTR keyalpha@GOTPCREL[rip]
	xor	r14b, r14b
	test	ebp, ebp
	cmovns	r14d, ebp
	sar	r8d, 8
	sar	r9d, 8
	mov	DWORD PTR [r11], r14d
	mov	r11, QWORD PTR combiner_rgbsub_a_r@GOTPCREL[rip]
	sar	r10d, 8
	mov	r11, QWORD PTR 8[r11]
	movsx	r11, DWORD PTR [r11]
	mov	r11d, DWORD PTR [rcx+r11*4]
	mov	DWORD PTR [rax], r11d
	mov	r11, QWORD PTR combiner_rgbsub_a_g@GOTPCREL[rip]
	mov	r11, QWORD PTR 8[r11]
	movsx	r11, DWORD PTR [r11]
	mov	r11d, DWORD PTR [rcx+r11*4]
	mov	DWORD PTR 4[rax], r11d
	mov	r11, QWORD PTR combiner_rgbsub_a_b@GOTPCREL[rip]
	mov	r11, QWORD PTR 8[r11]
	movsx	r11, DWORD PTR [r11]
	mov	DWORD PTR [rdx], r8d
	mov	DWORD PTR 4[rdx], r9d
	mov	DWORD PTR 8[rdx], r10d
	mov	ecx, DWORD PTR [rcx+r11*4]
	mov	DWORD PTR 8[rax], ecx
	jmp	.L310
	.p2align 4,,10
	.p2align 3
.L308:
	mov	DWORD PTR 12[rax], 256
	mov	r13d, 256
	jmp	.L309
	.p2align 4,,10
	.p2align 3
.L327:
	mov	rdx, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	mov	rax, QWORD PTR special_9bit_exttable@GOTPCREL[rip]
	mov	rcx, QWORD PTR combiner_rgbadd_g@GOTPCREL[rip]
	mov	rdx, QWORD PTR 8[rdx]
	mov	rcx, QWORD PTR 8[rcx]
	movsx	rdx, DWORD PTR [rdx]
	mov	r8d, DWORD PTR [rax+rdx*4]
	mov	rdx, QWORD PTR combined_color@GOTPCREL[rip]
	sal	r8d, 8
	sub	r8d, -128
	and	r8d, 131071
	mov	DWORD PTR [rdx], r8d
	movsx	rcx, DWORD PTR [rcx]
	mov	r9d, DWORD PTR [rax+rcx*4]
	mov	rcx, QWORD PTR combiner_rgbadd_b@GOTPCREL[rip]
	sal	r9d, 8
	mov	rcx, QWORD PTR 8[rcx]
	sub	r9d, -128
	and	r9d, 131071
	mov	DWORD PTR 4[rdx], r9d
	movsx	rcx, DWORD PTR [rcx]
	mov	r10d, DWORD PTR [rax+rcx*4]
	mov	rcx, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	mov	rcx, QWORD PTR 8[rcx]
	sal	r10d, 8
	sub	r10d, -128
	and	r10d, 131071
	cmp	rcx, r11
	mov	DWORD PTR 8[rdx], r10d
	jne	.L306
	.p2align 4,,10
	.p2align 3
.L328:
	mov	rcx, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	mov	rcx, QWORD PTR 8[rcx]
	movsx	rcx, DWORD PTR [rcx]
	mov	eax, DWORD PTR [rax+rcx*4]
	and	eax, 511
	jmp	.L307
	.cfi_endproc
.LFE565:
	.size	combiner_1cycle, .-combiner_1cycle
	.p2align 4,,15
	.globl	combiner_2cycle
	.type	combiner_2cycle, @function
combiner_2cycle:
.LFB566:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	lea	r8, zero_color[rip]
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, QWORD PTR combiner_rgbmul_r@GOTPCREL[rip]
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
	mov	rax, QWORD PTR [r14]
	cmp	rax, r8
	je	.L359
	mov	rcx, QWORD PTR combiner_rgbsub_a_r@GOTPCREL[rip]
	mov	r9, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	r13, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	mov	r10, QWORD PTR combiner_rgbsub_b_g@GOTPCREL[rip]
	mov	r12, QWORD PTR combiner_rgbadd_g@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rcx]
	mov	r9, QWORD PTR [r9]
	mov	edx, eax
	mov	rbx, QWORD PTR combiner_rgbsub_b_b@GOTPCREL[rip]
	mov	rbp, QWORD PTR combiner_rgbadd_b@GOTPCREL[rip]
	and	edx, 256
	mov	r10, QWORD PTR [r10]
	movsx	r9, DWORD PTR [r9]
	movsx	rcx, DWORD PTR [rcx]
	neg	edx
	or	edx, eax
	mov	rax, QWORD PTR special_9bit_exttable@GOTPCREL[rip]
	mov	rbx, QWORD PTR [rbx]
	mov	ecx, DWORD PTR [rax+rcx*4]
	sub	ecx, DWORD PTR [rax+r9*4]
	imul	edx, ecx
	mov	rcx, QWORD PTR 0[r13]
	movsx	rcx, DWORD PTR [rcx]
	mov	ecx, DWORD PTR [rax+rcx*4]
	sal	ecx, 8
	lea	r11d, 128[rdx+rcx]
	mov	rcx, QWORD PTR combiner_rgbmul_g@GOTPCREL[rip]
	mov	rdx, QWORD PTR combined_color@GOTPCREL[rip]
	and	r11d, 131071
	mov	rcx, QWORD PTR [rcx]
	mov	DWORD PTR [rdx], r11d
	movsx	r10, DWORD PTR [r10]
	mov	r9d, DWORD PTR [rcx]
	mov	ecx, r9d
	and	ecx, 256
	neg	ecx
	or	ecx, r9d
	mov	r9, QWORD PTR combiner_rgbsub_a_g@GOTPCREL[rip]
	mov	r9, QWORD PTR [r9]
	movsx	r9, DWORD PTR [r9]
	mov	r9d, DWORD PTR [rax+r9*4]
	sub	r9d, DWORD PTR [rax+r10*4]
	imul	ecx, r9d
	mov	r9, QWORD PTR [r12]
	movsx	r9, DWORD PTR [r9]
	mov	r9d, DWORD PTR [rax+r9*4]
	sal	r9d, 8
	lea	r10d, 128[rcx+r9]
	mov	rcx, QWORD PTR combiner_rgbmul_b@GOTPCREL[rip]
	and	r10d, 131071
	mov	rcx, QWORD PTR [rcx]
	mov	DWORD PTR 4[rdx], r10d
	movsx	rbx, DWORD PTR [rbx]
	mov	r9d, DWORD PTR [rcx]
	mov	ecx, r9d
	and	ecx, 256
	neg	ecx
	or	ecx, r9d
	mov	r9, QWORD PTR combiner_rgbsub_a_b@GOTPCREL[rip]
	mov	r9, QWORD PTR [r9]
	movsx	r9, DWORD PTR [r9]
	mov	r9d, DWORD PTR [rax+r9*4]
	sub	r9d, DWORD PTR [rax+rbx*4]
	imul	ecx, r9d
	mov	r9, QWORD PTR 0[rbp]
	movsx	r9, DWORD PTR [r9]
	mov	r9d, DWORD PTR [rax+r9*4]
	sal	r9d, 8
	lea	r9d, 128[rcx+r9]
	and	r9d, 131071
	mov	DWORD PTR 8[rdx], r9d
	mov	rbx, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rbx]
	cmp	rcx, r8
	je	.L360
.L334:
	mov	ebx, DWORD PTR [rcx]
	mov	r15, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	mov	ecx, ebx
	mov	r15, QWORD PTR [r15]
	and	ecx, 256
	neg	ecx
	or	ecx, ebx
	mov	rbx, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	movsx	r15, DWORD PTR [r15]
	mov	rbx, QWORD PTR [rbx]
	movsx	rbx, DWORD PTR [rbx]
	mov	ebx, DWORD PTR [rax+rbx*4]
	sub	ebx, DWORD PTR [rax+r15*4]
	mov	r15, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	imul	ecx, ebx
	mov	rbx, QWORD PTR [r15]
	movsx	rbx, DWORD PTR [rbx]
	mov	ebx, DWORD PTR [rax+rbx*4]
	sal	ebx, 8
	lea	ecx, 128[rcx+rbx]
	sar	ecx, 8
	and	ecx, 511
.L335:
	sar	r9d, 8
	sar	r10d, 8
	mov	DWORD PTR 12[rdx], ecx
	mov	DWORD PTR 8[rdx], r9d
	mov	r9, QWORD PTR texel1_color@GOTPCREL[rip]
	sar	r11d, 8
	mov	DWORD PTR 4[rdx], r10d
	mov	r10, QWORD PTR texel0_color@GOTPCREL[rip]
	mov	DWORD PTR [rdx], r11d
	mov	rcx, QWORD PTR [r9]
	mov	rbx, QWORD PTR 8[r9]
	mov	QWORD PTR [r10], rcx
	mov	rcx, QWORD PTR nexttexel_color@GOTPCREL[rip]
	mov	QWORD PTR 8[r10], rbx
	mov	rbx, QWORD PTR 8[rcx]
	mov	rcx, QWORD PTR [rcx]
	mov	QWORD PTR [r9], rcx
	mov	rcx, QWORD PTR 8[r14]
	mov	QWORD PTR 8[r9], rbx
	cmp	rcx, r8
	je	.L361
	mov	r9d, DWORD PTR [rcx]
	mov	r10, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	mov	r11, QWORD PTR combiner_rgbsub_b_g@GOTPCREL[rip]
	mov	rbx, QWORD PTR combiner_rgbsub_b_b@GOTPCREL[rip]
	mov	ecx, r9d
	mov	r10, QWORD PTR 8[r10]
	and	ecx, 256
	mov	r11, QWORD PTR 8[r11]
	mov	rbx, QWORD PTR 8[rbx]
	neg	ecx
	or	ecx, r9d
	mov	r9, QWORD PTR combiner_rgbsub_a_r@GOTPCREL[rip]
	movsx	r10, DWORD PTR [r10]
	mov	r9, QWORD PTR 8[r9]
	movsx	r9, DWORD PTR [r9]
	mov	r9d, DWORD PTR [rax+r9*4]
	sub	r9d, DWORD PTR [rax+r10*4]
	imul	ecx, r9d
	mov	r9, QWORD PTR 8[r13]
	movsx	r9, DWORD PTR [r9]
	mov	r9d, DWORD PTR [rax+r9*4]
	sal	r9d, 8
	lea	r9d, 128[rcx+r9]
	mov	rcx, QWORD PTR combiner_rgbmul_g@GOTPCREL[rip]
	and	r9d, 131071
	mov	rcx, QWORD PTR 8[rcx]
	mov	DWORD PTR [rdx], r9d
	movsx	r11, DWORD PTR [r11]
	mov	r10d, DWORD PTR [rcx]
	mov	ecx, r10d
	and	ecx, 256
	neg	ecx
	or	ecx, r10d
	mov	r10, QWORD PTR combiner_rgbsub_a_g@GOTPCREL[rip]
	mov	r10, QWORD PTR 8[r10]
	movsx	r10, DWORD PTR [r10]
	mov	r10d, DWORD PTR [rax+r10*4]
	sub	r10d, DWORD PTR [rax+r11*4]
	imul	ecx, r10d
	mov	r10, QWORD PTR 8[r12]
	movsx	r10, DWORD PTR [r10]
	mov	r10d, DWORD PTR [rax+r10*4]
	sal	r10d, 8
	lea	r10d, 128[rcx+r10]
	mov	rcx, QWORD PTR combiner_rgbmul_b@GOTPCREL[rip]
	and	r10d, 131071
	mov	rcx, QWORD PTR 8[rcx]
	mov	DWORD PTR 4[rdx], r10d
	movsx	rbx, DWORD PTR [rbx]
	mov	r11d, DWORD PTR [rcx]
	mov	ecx, r11d
	and	ecx, 256
	neg	ecx
	or	ecx, r11d
	mov	r11, QWORD PTR combiner_rgbsub_a_b@GOTPCREL[rip]
	mov	r11, QWORD PTR 8[r11]
	movsx	r11, DWORD PTR [r11]
	mov	r11d, DWORD PTR [rax+r11*4]
	sub	r11d, DWORD PTR [rax+rbx*4]
	imul	ecx, r11d
	mov	r11, QWORD PTR 8[rbp]
	movsx	r11, DWORD PTR [r11]
	mov	r11d, DWORD PTR [rax+r11*4]
	sal	r11d, 8
	lea	r11d, 128[rcx+r11]
	and	r11d, 131071
	mov	DWORD PTR 8[rdx], r11d
	mov	rbx, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	mov	rcx, QWORD PTR 8[rbx]
	cmp	rcx, r8
	je	.L362
.L338:
	mov	r8d, DWORD PTR [rcx]
	mov	rbx, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	mov	ecx, r8d
	mov	rbx, QWORD PTR 8[rbx]
	and	ecx, 256
	neg	ecx
	or	ecx, r8d
	mov	r8, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	movsx	rbx, DWORD PTR [rbx]
	mov	r8, QWORD PTR 8[r8]
	movsx	r8, DWORD PTR [r8]
	mov	r8d, DWORD PTR [rax+r8*4]
	sub	r8d, DWORD PTR [rax+rbx*4]
	imul	ecx, r8d
	mov	r8, QWORD PTR 8[r15]
	movsx	r8, DWORD PTR [r8]
	mov	eax, DWORD PTR [rax+r8*4]
	sal	eax, 8
	lea	ecx, 128[rcx+rax]
	sar	ecx, 8
	and	ecx, 511
.L339:
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	DWORD PTR 12[rdx], ecx
	cmp	DWORD PTR 48[rbx], 0
	jne	.L363
	mov	r8, QWORD PTR special_9bit_clamptable@GOTPCREL[rip]
	sar	r9d, 8
	sar	r10d, 8
	sar	r11d, 8
	mov	DWORD PTR [rdx], r9d
	movsx	r9, r9d
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	DWORD PTR 4[rdx], r10d
	movsx	r10, r10d
	mov	DWORD PTR 8[rdx], r11d
	mov	edx, DWORD PTR [r8+r9*4]
	movsx	r11, r11d
	movsx	rcx, ecx
	mov	DWORD PTR [rax], edx
	mov	edx, DWORD PTR [r8+r10*4]
	mov	DWORD PTR 4[rax], edx
	mov	edx, DWORD PTR [r8+r11*4]
	mov	DWORD PTR 8[rax], edx
	mov	edx, DWORD PTR [r8+rcx*4]
	cmp	edx, 255
	je	.L341
.L365:
	mov	DWORD PTR 12[rax], edx
	mov	ecx, edx
.L342:
	mov	r12d, DWORD PTR 100[rbx]
	xor	edx, edx
	test	r12d, r12d
	je	.L343
	mov	edx, DWORD PTR [rsi]
	imul	edx, ecx
	add	edx, 4
	shr	edx, 3
	mov	ecx, edx
	sar	ecx, 5
	and	ecx, 15
	mov	DWORD PTR [rsi], ecx
.L343:
	mov	ebp, DWORD PTR 96[rbx]
	test	ebp, ebp
	jne	.L344
	mov	r11d, DWORD PTR 48[rbx]
	test	r11d, r11d
	jne	.L345
	mov	edx, DWORD PTR 12[rax]
	add	edx, edi
	mov	DWORD PTR 12[rax], edx
	and	dh, 1
	je	.L347
	mov	DWORD PTR 12[rax], 255
	jmp	.L347
	.p2align 4,,10
	.p2align 3
.L344:
	mov	r10d, DWORD PTR 100[rbx]
	test	r10d, r10d
	je	.L364
.L348:
	mov	ecx, 255
	cmp	edx, 256
	cmovl	ecx, edx
	mov	DWORD PTR 12[rax], ecx
.L347:
	mov	rdx, QWORD PTR shade_color@GOTPCREL[rip]
	mov	eax, 255
	add	edi, DWORD PTR 12[rdx]
	test	edi, 256
	cmove	eax, edi
	mov	DWORD PTR 12[rdx], eax
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
	.p2align 4,,10
	.p2align 3
.L364:
	.cfi_restore_state
	mov	edx, DWORD PTR [rsi]
	sal	edx, 5
	jmp	.L348
	.p2align 4,,10
	.p2align 3
.L345:
	mov	rdx, QWORD PTR keyalpha@GOTPCREL[rip]
	mov	edx, DWORD PTR [rdx]
	mov	DWORD PTR 12[rax], edx
	jmp	.L347
.L363:
	mov	rax, QWORD PTR key_width@GOTPCREL[rip]
	mov	r12d, 255
	movsx	rcx, ecx
	mov	r8d, DWORD PTR 8[rax]
	mov	ebp, DWORD PTR 4[rax]
	mov	eax, DWORD PTR [rax]
	sal	r8d, 4
	sal	ebp, 4
	sal	eax, 4
	sub	ebp, r10d
	sub	r8d, r11d
	sub	eax, r9d
	cmp	eax, 255
	cmovg	eax, r12d
	cmp	ebp, eax
	cmovle	eax, ebp
	mov	rbp, QWORD PTR combiner_rgbsub_a_r@GOTPCREL[rip]
	cmp	r8d, eax
	cmovg	r8d, eax
	mov	rax, QWORD PTR keyalpha@GOTPCREL[rip]
	xor	r12b, r12b
	mov	rbp, QWORD PTR 8[rbp]
	test	r8d, r8d
	cmovns	r12d, r8d
	mov	r8, QWORD PTR special_9bit_clamptable@GOTPCREL[rip]
	sar	r9d, 8
	mov	DWORD PTR [rax], r12d
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	sar	r10d, 8
	movsx	rbp, DWORD PTR 0[rbp]
	sar	r11d, 8
	mov	ebp, DWORD PTR [r8+rbp*4]
	mov	DWORD PTR [rax], ebp
	mov	rbp, QWORD PTR combiner_rgbsub_a_g@GOTPCREL[rip]
	mov	rbp, QWORD PTR 8[rbp]
	movsx	rbp, DWORD PTR 0[rbp]
	mov	ebp, DWORD PTR [r8+rbp*4]
	mov	DWORD PTR 4[rax], ebp
	mov	rbp, QWORD PTR combiner_rgbsub_a_b@GOTPCREL[rip]
	mov	rbp, QWORD PTR 8[rbp]
	movsx	rbp, DWORD PTR 0[rbp]
	mov	DWORD PTR [rdx], r9d
	mov	DWORD PTR 4[rdx], r10d
	mov	DWORD PTR 8[rdx], r11d
	mov	edx, DWORD PTR [r8+rcx*4]
	mov	ebp, DWORD PTR [r8+rbp*4]
	cmp	edx, 255
	mov	DWORD PTR 8[rax], ebp
	jne	.L365
.L341:
	mov	DWORD PTR 12[rax], 256
	mov	ecx, 256
	jmp	.L342
	.p2align 4,,10
	.p2align 3
.L359:
	mov	r13, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	mov	rax, QWORD PTR special_9bit_exttable@GOTPCREL[rip]
	mov	r12, QWORD PTR combiner_rgbadd_g@GOTPCREL[rip]
	mov	rbp, QWORD PTR combiner_rgbadd_b@GOTPCREL[rip]
	mov	rbx, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	mov	rdx, QWORD PTR 0[r13]
	mov	rcx, QWORD PTR [r12]
	movsx	rdx, DWORD PTR [rdx]
	mov	r11d, DWORD PTR [rax+rdx*4]
	mov	rdx, QWORD PTR combined_color@GOTPCREL[rip]
	sal	r11d, 8
	sub	r11d, -128
	and	r11d, 131071
	mov	DWORD PTR [rdx], r11d
	movsx	rcx, DWORD PTR [rcx]
	mov	r10d, DWORD PTR [rax+rcx*4]
	mov	rcx, QWORD PTR 0[rbp]
	sal	r10d, 8
	sub	r10d, -128
	and	r10d, 131071
	mov	DWORD PTR 4[rdx], r10d
	movsx	rcx, DWORD PTR [rcx]
	mov	r9d, DWORD PTR [rax+rcx*4]
	mov	rcx, QWORD PTR [rbx]
	sal	r9d, 8
	sub	r9d, -128
	and	r9d, 131071
	cmp	rcx, r8
	mov	DWORD PTR 8[rdx], r9d
	jne	.L334
	.p2align 4,,10
	.p2align 3
.L360:
	mov	r15, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	mov	rcx, QWORD PTR [r15]
	movsx	rcx, DWORD PTR [rcx]
	mov	ecx, DWORD PTR [rax+rcx*4]
	and	ecx, 511
	jmp	.L335
	.p2align 4,,10
	.p2align 3
.L361:
	mov	rcx, QWORD PTR 8[r13]
	mov	rbx, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	movsx	rcx, DWORD PTR [rcx]
	mov	r9d, DWORD PTR [rax+rcx*4]
	mov	rcx, QWORD PTR 8[r12]
	sal	r9d, 8
	sub	r9d, -128
	and	r9d, 131071
	mov	DWORD PTR [rdx], r9d
	movsx	rcx, DWORD PTR [rcx]
	mov	r10d, DWORD PTR [rax+rcx*4]
	mov	rcx, QWORD PTR 8[rbp]
	sal	r10d, 8
	sub	r10d, -128
	and	r10d, 131071
	mov	DWORD PTR 4[rdx], r10d
	movsx	rcx, DWORD PTR [rcx]
	mov	r11d, DWORD PTR [rax+rcx*4]
	mov	rcx, QWORD PTR 8[rbx]
	sal	r11d, 8
	sub	r11d, -128
	and	r11d, 131071
	cmp	rcx, r8
	mov	DWORD PTR 8[rdx], r11d
	jne	.L338
	.p2align 4,,10
	.p2align 3
.L362:
	mov	rcx, QWORD PTR 8[r15]
	movsx	rcx, DWORD PTR [rcx]
	mov	ecx, DWORD PTR [rax+rcx*4]
	and	ecx, 511
	jmp	.L339
	.cfi_endproc
.LFE566:
	.size	combiner_2cycle, .-combiner_2cycle
	.p2align 4,,15
	.globl	SET_BLENDER_INPUT
	.type	SET_BLENDER_INPUT, @function
SET_BLENDER_INPUT:
.LFB568:
	.cfi_startproc
	mov	eax, DWORD PTR 8[rsp]
	and	eax, 3
	cmp	eax, 2
	je	.L368
	cmp	eax, 3
	je	.L369
	cmp	eax, 1
	je	.L370
	test	edi, edi
	.p2align 4,,3
	jne	.L371
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	jmp	.L383
	.p2align 4,,10
	.p2align 3
.L370:
	mov	rax, QWORD PTR memory_color@GOTPCREL[rip]
.L383:
	mov	QWORD PTR [rdx], rax
	lea	rdx, 4[rax]
	add	rax, 8
	mov	QWORD PTR [rcx], rdx
	mov	QWORD PTR [r8], rax
	mov	eax, DWORD PTR 16[rsp]
	and	eax, 3
	test	esi, esi
	jne	.L373
	cmp	eax, 2
	je	.L375
	cmp	eax, 3
	je	.L381
	cmp	eax, 1
	.p2align 4,,2
	je	.L377
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [r9], rax
	ret
	.p2align 4,,10
	.p2align 3
.L373:
	cmp	eax, 2
	je	.L380
	cmp	eax, 3
	je	.L381
	cmp	eax, 1
	.p2align 4,,2
	je	.L382
	mov	rax, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [r9], rax
	ret
	.p2align 4,,10
	.p2align 3
.L381:
	lea	rax, zero_color[rip]
	mov	QWORD PTR [r9], rax
	ret
	.p2align 4,,10
	.p2align 3
.L369:
	mov	rax, QWORD PTR fog_color@GOTPCREL[rip]
	jmp	.L383
	.p2align 4,,10
	.p2align 3
.L368:
	mov	rax, QWORD PTR blend_color@GOTPCREL[rip]
	jmp	.L383
	.p2align 4,,10
	.p2align 3
.L371:
	mov	rax, QWORD PTR blended_pixel_color@GOTPCREL[rip]
	jmp	.L383
	.p2align 4,,10
	.p2align 3
.L382:
	mov	rax, QWORD PTR memory_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [r9], rax
	ret
	.p2align 4,,10
	.p2align 3
.L377:
	mov	rax, QWORD PTR fog_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [r9], rax
	ret
	.p2align 4,,10
	.p2align 3
.L380:
	lea	rax, blenderone[rip]
	mov	QWORD PTR [r9], rax
	ret
	.p2align 4,,10
	.p2align 3
.L375:
	mov	rax, QWORD PTR shade_color@GOTPCREL[rip]
	add	rax, 12
	mov	QWORD PTR [r9], rax
	ret
	.cfi_endproc
.LFE568:
	.size	SET_BLENDER_INPUT, .-SET_BLENDER_INPUT
	.p2align 4,,15
	.globl	blender_1cycle
	.type	blender_1cycle, @function
blender_1cycle:
.LFB569:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	mov	r11d, ecx
	mov	r12, rdi
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	mov	rbp, rsi
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	mov	rbx, rdx
	sub	rsp, 48
	.cfi_def_cfa_offset 80
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	r10d, DWORD PTR 12[rax]
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	ecx, DWORD PTR 140[rax]
	test	ecx, ecx
	jne	.L385
.L390:
	mov	edx, DWORD PTR 128[rax]
	test	edx, edx
	jne	.L386
	mov	edx, DWORD PTR 88[rsp]
	test	edx, edx
	setne	dl
	test	dl, dl
	je	.L393
.L407:
	mov	edi, DWORD PTR 112[rax]
	test	edi, edi
	je	.L394
	test	r9d, r9d
	jne	.L394
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 16[rsp], eax
	mov	rax, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 32[rsp], eax
.L399:
	lea	rdx, 32[rsp]
	lea	rsi, 16[rsp]
	mov	rdi, rsp
	mov	ecx, r11d
	call	[QWORD PTR rgb_dither_ptr[rip]]
	mov	eax, DWORD PTR [rsp]
	mov	DWORD PTR [r12], eax
	mov	eax, DWORD PTR 16[rsp]
	mov	DWORD PTR 0[rbp], eax
	mov	eax, DWORD PTR 32[rsp]
	mov	DWORD PTR [rbx], eax
	add	rsp, 48
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	mov	eax, 1
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L386:
	.cfi_restore_state
	mov	ecx, DWORD PTR 80[rsp]
	test	ecx, ecx
	setne	dl
	test	dl, dl
	jne	.L407
.L393:
	add	rsp, 48
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	xor	eax, eax
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L394:
	.cfi_restore_state
	mov	esi, DWORD PTR 152[rax]
	test	esi, esi
	je	.L396
	cmp	r10d, 254
	jle	.L396
.L397:
	mov	rax, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 16[rsp], eax
	mov	rax, QWORD PTR blender1a_b@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 32[rsp], eax
	jmp	.L399
	.p2align 4,,10
	.p2align 3
.L396:
	test	r8d, r8d
	je	.L397
	mov	rdx, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rsi, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rdx]
	mov	edx, DWORD PTR [rcx]
	not	edx
	and	edx, 255
	mov	DWORD PTR 12[rsi], edx
	mov	edx, DWORD PTR [rcx]
	mov	rcx, QWORD PTR blender2b_a@GOTPCREL[rip]
	sar	edx, 3
	mov	rcx, QWORD PTR [rcx]
	mov	esi, DWORD PTR [rcx]
	mov	ecx, DWORD PTR 160[rax]
	sar	esi, 3
	test	ecx, ecx
	je	.L400
	mov	rcx, QWORD PTR blshifta@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	sar	edx, cl
	mov	rcx, QWORD PTR blshiftb@GOTPCREL[rip]
	and	edx, 60
	mov	ecx, DWORD PTR [rcx]
	sar	esi, cl
	or	esi, 3
.L400:
	mov	rdi, QWORD PTR blender1a_r@GOTPCREL[rip]
	lea	ecx, 1[rsi]
	mov	eax, DWORD PTR 92[rax]
	mov	rdi, QWORD PTR [rdi]
	mov	r8d, DWORD PTR [rdi]
	mov	rdi, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rdi, QWORD PTR [rdi]
	imul	r8d, edx
	mov	r10d, DWORD PTR [rdi]
	mov	rdi, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rdi, QWORD PTR [rdi]
	imul	r10d, ecx
	mov	r9d, DWORD PTR [rdi]
	mov	rdi, QWORD PTR blender2a_g@GOTPCREL[rip]
	add	r8d, r10d
	mov	rdi, QWORD PTR [rdi]
	imul	r9d, edx
	mov	r10d, DWORD PTR [rdi]
	imul	r10d, ecx
	mov	edi, r10d
	add	edi, r9d
	mov	r9, QWORD PTR blender1a_b@GOTPCREL[rip]
	mov	r9, QWORD PTR [r9]
	mov	r10d, DWORD PTR [r9]
	imul	r10d, edx
	mov	r9d, r10d
	mov	r10, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	r10, QWORD PTR [r10]
	imul	ecx, DWORD PTR [r10]
	add	ecx, r9d
	test	eax, eax
	je	.L408
	sar	r8d, 5
	sar	edi, 5
	sar	ecx, 5
	and	r8d, 255
	and	edi, 255
	and	ecx, 255
	mov	DWORD PTR [rsp], r8d
	mov	DWORD PTR 16[rsp], edi
	mov	DWORD PTR 32[rsp], ecx
	jmp	.L399
	.p2align 4,,10
	.p2align 3
.L385:
	mov	edi, DWORD PTR 136[rax]
	test	edi, edi
	je	.L409
	mov	rcx, QWORD PTR iseed@GOTPCREL[rip]
	mov	esi, DWORD PTR [rcx]
	imul	edx, esi, 214013
	add	edx, 2531011
	mov	DWORD PTR [rcx], edx
	sar	edx, 16
	movzx	edx, dl
.L389:
	cmp	r10d, edx
	jl	.L393
	jmp	.L390
	.p2align 4,,10
	.p2align 3
.L409:
	mov	rdx, QWORD PTR blend_color@GOTPCREL[rip]
	mov	edx, DWORD PTR 12[rdx]
	jmp	.L389
	.p2align 4,,10
	.p2align 3
.L408:
	and	edx, -4
	and	esi, -4
	mov	r9, QWORD PTR bldiv_hwaccurate_table@GOTPCREL[rip]
	lea	eax, 4[rdx+rsi]
	mov	esi, r8d
	sar	edi, 2
	sar	esi, 2
	sar	ecx, 2
	sal	eax, 9
	and	esi, 2047
	and	ecx, 2047
	or	esi, eax
	or	ecx, eax
	movsx	rsi, esi
	movsx	rcx, ecx
	movzx	edx, BYTE PTR [r9+rsi]
	mov	DWORD PTR [rsp], edx
	mov	edx, edi
	and	edx, 2047
	or	edx, eax
	movzx	eax, BYTE PTR [r9+rcx]
	movsx	rdx, edx
	movzx	edx, BYTE PTR [r9+rdx]
	mov	DWORD PTR 32[rsp], eax
	mov	DWORD PTR 16[rsp], edx
	jmp	.L399
	.cfi_endproc
.LFE569:
	.size	blender_1cycle, .-blender_1cycle
	.p2align 4,,15
	.globl	blender_2cycle
	.type	blender_2cycle, @function
blender_2cycle:
.LFB570:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r11d, ecx
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
	mov	rbp, rsi
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	mov	rbx, rdx
	sub	rsp, 56
	.cfi_def_cfa_offset 112
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	r10d, DWORD PTR 12[rax]
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r14d, DWORD PTR 140[rax]
	test	r14d, r14d
	jne	.L411
.L416:
	mov	r13d, DWORD PTR 128[rax]
	test	r13d, r13d
	jne	.L412
	mov	edx, DWORD PTR 120[rsp]
	test	edx, edx
	setne	dl
	test	dl, dl
	jne	.L434
.L419:
	add	rsp, 56
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xor	eax, eax
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
.L412:
	.cfi_restore_state
	mov	ecx, DWORD PTR 112[rsp]
	test	ecx, ecx
	setne	dl
	test	dl, dl
	je	.L419
.L434:
	mov	rdi, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rsi, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	r15d, DWORD PTR 160[rax]
	mov	rcx, QWORD PTR [rdi]
	mov	rdi, QWORD PTR blender2b_a@GOTPCREL[rip]
	mov	edx, DWORD PTR [rcx]
	not	edx
	and	edx, 255
	mov	DWORD PTR 12[rsi], edx
	mov	rdx, QWORD PTR [rdi]
	mov	r14d, DWORD PTR [rcx]
	mov	edx, DWORD PTR [rdx]
	sar	r14d, 3
	sar	edx, 3
	test	r15d, r15d
	je	.L420
	mov	rcx, QWORD PTR pastblshifta@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	sar	r14d, cl
	mov	rcx, QWORD PTR pastblshiftb@GOTPCREL[rip]
	and	r14d, 60
	mov	ecx, DWORD PTR [rcx]
	sar	edx, cl
	or	edx, 3
.L420:
	mov	rsi, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rdi, QWORD PTR blender2a_r@GOTPCREL[rip]
	add	edx, 1
	mov	r15, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rsi]
	mov	esi, DWORD PTR [rcx]
	mov	rcx, QWORD PTR [rdi]
	mov	edi, DWORD PTR [rcx]
	mov	rcx, QWORD PTR [r15]
	imul	esi, r14d
	imul	edi, edx
	add	esi, edi
	sar	esi, 5
	movzx	esi, sil
	mov	DWORD PTR [rsp], esi
	mov	edi, DWORD PTR [rcx]
	mov	rcx, QWORD PTR blender2a_g@GOTPCREL[rip]
	imul	edi, r14d
	mov	rcx, QWORD PTR [rcx]
	mov	r13d, DWORD PTR [rcx]
	imul	r13d, edx
	mov	ecx, r13d
	add	ecx, edi
	mov	rdi, QWORD PTR blender1a_b@GOTPCREL[rip]
	sar	ecx, 5
	movzx	ecx, cl
	mov	r13, QWORD PTR [rdi]
	mov	DWORD PTR 16[rsp], ecx
	imul	r14d, DWORD PTR 0[r13]
	mov	r13, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	r13, QWORD PTR 0[r13]
	imul	edx, DWORD PTR 0[r13]
	mov	r13d, DWORD PTR 112[rax]
	add	r14d, edx
	mov	rdx, QWORD PTR pre_memory_color@GOTPCREL[rip]
	sar	r14d, 5
	test	r13d, r13d
	movzx	r14d, r14b
	movdqa	xmm1, XMMWORD PTR [rdx]
	mov	rdx, QWORD PTR memory_color@GOTPCREL[rip]
	mov	DWORD PTR 32[rsp], r14d
	movdqa	XMMWORD PTR [rdx], xmm1
	mov	rdx, QWORD PTR blended_pixel_color@GOTPCREL[rip]
	mov	DWORD PTR [rdx], esi
	mov	DWORD PTR 4[rdx], ecx
	mov	DWORD PTR 8[rdx], r14d
	mov	DWORD PTR 12[rdx], r10d
	je	.L421
	test	r9d, r9d
	jne	.L421
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 16[rsp], eax
	mov	rax, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 32[rsp], eax
.L426:
	lea	rdx, 32[rsp]
	lea	rsi, 16[rsp]
	mov	rdi, rsp
	mov	ecx, r11d
	call	[QWORD PTR rgb_dither_ptr[rip]]
	mov	eax, DWORD PTR [rsp]
	mov	DWORD PTR [r12], eax
	mov	eax, DWORD PTR 16[rsp]
	mov	DWORD PTR 0[rbp], eax
	mov	eax, DWORD PTR 32[rsp]
	mov	DWORD PTR [rbx], eax
	add	rsp, 56
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
.L411:
	.cfi_restore_state
	mov	edi, DWORD PTR 136[rax]
	test	edi, edi
	je	.L435
	mov	rcx, QWORD PTR iseed@GOTPCREL[rip]
	mov	esi, DWORD PTR [rcx]
	imul	edx, esi, 214013
	add	edx, 2531011
	mov	DWORD PTR [rcx], edx
	sar	edx, 16
	movzx	edx, dl
.L415:
	cmp	r10d, edx
	jl	.L419
	jmp	.L416
	.p2align 4,,10
	.p2align 3
.L435:
	mov	rdx, QWORD PTR blend_color@GOTPCREL[rip]
	mov	edx, DWORD PTR 12[rdx]
	jmp	.L415
	.p2align 4,,10
	.p2align 3
.L421:
	mov	r9d, DWORD PTR 156[rax]
	test	r9d, r9d
	je	.L423
	cmp	r10d, 254
	jg	.L424
.L423:
	test	r8d, r8d
	jne	.L425
.L424:
	mov	rax, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR 8[r15]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 16[rsp], eax
	mov	rax, QWORD PTR 8[rdi]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 32[rsp], eax
	jmp	.L426
	.p2align 4,,10
	.p2align 3
.L425:
	mov	rsi, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	r8d, DWORD PTR 164[rax]
	mov	rcx, QWORD PTR 8[rsi]
	mov	rsi, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	edx, DWORD PTR [rcx]
	not	edx
	and	edx, 255
	mov	DWORD PTR 12[rsi], edx
	mov	rsi, QWORD PTR blender2b_a@GOTPCREL[rip]
	mov	edx, DWORD PTR [rcx]
	mov	rcx, QWORD PTR 8[rsi]
	sar	edx, 3
	mov	esi, DWORD PTR [rcx]
	sar	esi, 3
	test	r8d, r8d
	je	.L427
	mov	rcx, QWORD PTR blshifta@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	sar	edx, cl
	mov	rcx, QWORD PTR blshiftb@GOTPCREL[rip]
	and	edx, 60
	mov	ecx, DWORD PTR [rcx]
	sar	esi, cl
	or	esi, 3
.L427:
	mov	r10, QWORD PTR blender1a_r@GOTPCREL[rip]
	lea	ecx, 1[rsi]
	mov	rdi, QWORD PTR 8[rdi]
	mov	r8, QWORD PTR 8[r10]
	mov	r10, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	r9d, DWORD PTR [r8]
	mov	r8, QWORD PTR 8[r10]
	mov	r10d, DWORD PTR [r8]
	imul	r9d, edx
	imul	r10d, ecx
	mov	r8d, r10d
	add	r8d, r9d
	mov	r9, QWORD PTR 8[r15]
	mov	r15, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	r10d, DWORD PTR [r9]
	mov	r9, QWORD PTR 8[r15]
	mov	r15d, DWORD PTR [r9]
	imul	r10d, edx
	imul	r15d, ecx
	mov	r9d, r15d
	mov	r15d, DWORD PTR [rdi]
	add	r9d, r10d
	imul	r15d, edx
	mov	edi, r15d
	mov	r15, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	r10, QWORD PTR 8[r15]
	imul	ecx, DWORD PTR [r10]
	add	ecx, edi
	mov	edi, DWORD PTR 92[rax]
	test	edi, edi
	je	.L436
	sar	r8d, 5
	sar	r9d, 5
	sar	ecx, 5
	and	r8d, 255
	and	r9d, 255
	and	ecx, 255
	mov	DWORD PTR [rsp], r8d
	mov	DWORD PTR 16[rsp], r9d
	mov	DWORD PTR 32[rsp], ecx
	jmp	.L426
	.p2align 4,,10
	.p2align 3
.L436:
	and	edx, -4
	and	esi, -4
	mov	rdi, QWORD PTR bldiv_hwaccurate_table@GOTPCREL[rip]
	lea	eax, 4[rdx+rsi]
	mov	esi, r8d
	sar	ecx, 2
	sar	esi, 2
	and	ecx, 2047
	sal	eax, 9
	and	esi, 2047
	or	esi, eax
	or	ecx, eax
	movsx	rsi, esi
	movsx	rcx, ecx
	movzx	edx, BYTE PTR [rdi+rsi]
	mov	DWORD PTR [rsp], edx
	mov	edx, r9d
	sar	edx, 2
	and	edx, 2047
	or	edx, eax
	movzx	eax, BYTE PTR [rdi+rcx]
	movsx	rdx, edx
	movzx	edx, BYTE PTR [rdi+rdx]
	mov	DWORD PTR 32[rsp], eax
	mov	DWORD PTR 16[rsp], edx
	jmp	.L426
	.cfi_endproc
.LFE570:
	.size	blender_2cycle, .-blender_2cycle
	.p2align 4,,15
	.globl	fetch_texel
	.type	fetch_texel, @function
fetch_texel:
.LFB571:
	.cfi_startproc
	mov	ecx, ecx
	lea	rax, [rcx+rcx*4]
	mov	rcx, QWORD PTR tile@GOTPCREL[rip]
	lea	rax, [rax+rax*4]
	lea	rax, [rcx+rax*4]
	mov	ecx, DWORD PTR 8[rax]
	mov	r9d, DWORD PTR 16[rax]
	add	rax, 80
	imul	ecx, edx
	add	ecx, DWORD PTR -68[rax]
	cmp	DWORD PTR 12[rax], 19
	ja	.L520
	mov	r8d, DWORD PTR 12[rax]
	lea	rax, .L440[rip]
	movsx	r8, DWORD PTR [rax+r8*4]
	add	rax, r8
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L440:
	.long	.L454-.L440
	.long	.L455-.L440
	.long	.L442-.L440
	.long	.L443-.L440
	.long	.L444-.L440
	.long	.L444-.L440
	.long	.L445-.L440
	.long	.L445-.L440
	.long	.L446-.L440
	.long	.L455-.L440
	.long	.L457-.L440
	.long	.L457-.L440
	.long	.L450-.L440
	.long	.L451-.L440
	.long	.L452-.L440
	.long	.L457-.L440
	.long	.L454-.L440
	.long	.L455-.L440
	.long	.L457-.L440
	.long	.L457-.L440
	.text
	.p2align 4,,10
	.p2align 3
.L457:
	and	edx, 1
	lea	ecx, [rsi+rcx*4]
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -2
	add	eax, 3
	xor	eax, ecx
	and	eax, 2047
	movzx	eax, WORD PTR [rdx+rax*2]
	movzx	edx, ah
	movzx	ecx, al
	mov	DWORD PTR [rdi], edx
	mov	DWORD PTR 4[rdi], ecx
.L521:
	sal	eax, 31
	mov	DWORD PTR 8[rdi], edx
	sar	eax, 31
	movzx	eax, al
	mov	DWORD PTR 12[rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L455:
	and	edx, 1
	lea	ecx, [rsi+rcx*8]
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	eax, ecx
	and	eax, 4095
	movzx	eax, BYTE PTR [rdx+rax]
	mov	DWORD PTR [rdi], eax
	mov	DWORD PTR 4[rdi], eax
	mov	DWORD PTR 8[rdi], eax
	mov	DWORD PTR 12[rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L454:
	sal	ecx, 4
	and	edx, 1
	add	ecx, esi
	shr	ecx
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	eax, ecx
	and	eax, 4095
	movzx	eax, BYTE PTR [rdx+rax]
	mov	edx, eax
	shr	al, 4
	and	edx, 15
	and	esi, 1
	cmove	edx, eax
	mov	eax, edx
	sal	eax, 4
	or	eax, edx
	movzx	eax, al
	mov	DWORD PTR [rdi], eax
	mov	DWORD PTR 4[rdi], eax
	mov	DWORD PTR 8[rdi], eax
	mov	DWORD PTR 12[rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L450:
	sal	ecx, 4
	and	edx, 1
	add	ecx, esi
	shr	ecx
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	eax, ecx
	and	eax, 4095
	movzx	edx, BYTE PTR [rdx+rax]
	mov	eax, edx
	shr	dl, 4
	and	eax, 15
	and	esi, 1
	cmove	eax, edx
	mov	ecx, eax
	and	ecx, 14
	movzx	esi, cl
	shr	cl, 2
	mov	edx, esi
	add	esi, esi
	sal	edx, 4
	or	edx, esi
	or	edx, ecx
	movzx	edx, dl
	mov	DWORD PTR [rdi], edx
	mov	DWORD PTR 4[rdi], edx
	jmp	.L521
	.p2align 4,,10
	.p2align 3
.L444:
	and	edx, 1
	lea	ecx, [rsi+rcx*8]
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	eax, ecx
	and	eax, 2047
	movzx	edx, BYTE PTR [rdx+rax]
	lea	eax, -128[rdx]
	mov	DWORD PTR 8[rdi], edx
	mov	DWORD PTR 12[rdi], edx
	and	eax, 511
	mov	DWORD PTR [rdi], eax
	mov	DWORD PTR 4[rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L443:
	and	edx, 1
	lea	ecx, [rsi+rcx*4]
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -2
	add	eax, 3
	xor	eax, ecx
	and	eax, 1023
	mov	ecx, eax
	or	ah, 4
	mov	eax, eax
	movzx	ecx, WORD PTR [rdx+rcx*2]
	movzx	eax, WORD PTR [rdx+rax*2]
	movzx	esi, ch
	movzx	ecx, cl
	movzx	edx, ah
	movzx	eax, al
	mov	DWORD PTR [rdi], esi
	mov	DWORD PTR 4[rdi], ecx
	mov	DWORD PTR 8[rdi], edx
	mov	DWORD PTR 12[rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L451:
	and	edx, 1
	lea	ecx, [rsi+rcx*8]
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	eax, ecx
	and	eax, 4095
	movzx	edx, BYTE PTR [rdx+rax]
	mov	ecx, edx
	and	ecx, -16
	mov	eax, ecx
	shr	al, 4
	or	eax, ecx
	movzx	eax, al
	mov	DWORD PTR [rdi], eax
	mov	DWORD PTR 4[rdi], eax
	mov	DWORD PTR 8[rdi], eax
	mov	eax, edx
	and	edx, 15
	sal	eax, 4
	and	eax, 240
	or	eax, edx
	mov	DWORD PTR 12[rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L445:
	lea	eax, [rsi+rcx*8]
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	esi, eax
	shr	esi
	and	edx, 1
	jne	.L466
	xor	eax, 3
	mov	ecx, 1
	mov	edx, eax
.L492:
	xor	esi, ecx
	mov	rcx, QWORD PTR TMEM@GOTPCREL[rip]
	and	edx, 2047
	and	esi, 1023
	or	dh, 8
	movzx	ebx, WORD PTR [rcx+rsi*2]
	movzx	ecx, BYTE PTR [rcx+rdx]
	movzx	eax, bl
	movzx	edx, bh
	mov	DWORD PTR 8[rdi], ecx
	pop	rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	add	edx, -128
	add	eax, -128
	mov	DWORD PTR 12[rdi], ecx
	and	edx, 511
	and	eax, 511
	mov	DWORD PTR [rdi], edx
	mov	DWORD PTR 4[rdi], eax
.L520:
	rep ret
	.p2align 4,,10
	.p2align 3
.L446:
	sal	ecx, 4
	and	edx, 1
	add	ecx, esi
	shr	ecx
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	eax, ecx
	and	eax, 4095
	movzx	edx, BYTE PTR [rdx+rax]
	mov	eax, edx
	shr	dl, 4
	and	eax, 15
	and	esi, 1
	cmove	eax, edx
	sal	r9d, 4
	or	eax, r9d
	movzx	eax, al
	mov	DWORD PTR 12[rdi], eax
	mov	DWORD PTR 8[rdi], eax
	mov	DWORD PTR 4[rdi], eax
	mov	DWORD PTR [rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L452:
	and	edx, 1
	lea	ecx, [rsi+rcx*4]
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -2
	add	eax, 3
	xor	eax, ecx
	and	eax, 2047
	movzx	edx, WORD PTR [rdx+rax*2]
	movzx	eax, dh
	movzx	edx, dl
	mov	DWORD PTR 8[rdi], eax
	mov	DWORD PTR 4[rdi], eax
	mov	DWORD PTR [rdi], eax
	mov	DWORD PTR 12[rdi], edx
	ret
	.p2align 4,,10
	.p2align 3
.L442:
	and	edx, 1
	lea	ecx, [rsi+rcx*4]
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -2
	add	eax, 3
	xor	eax, ecx
	mov	rcx, QWORD PTR replicated_rgba@GOTPCREL[rip]
	and	eax, 2047
	movzx	eax, WORD PTR [rdx+rax*2]
	mov	edx, eax
	shr	dx, 11
	and	edx, 31
	movzx	edx, BYTE PTR [rcx+rdx]
	mov	DWORD PTR [rdi], edx
	mov	rdx, rax
	shr	rdx, 6
	and	edx, 31
	movzx	edx, BYTE PTR [rcx+rdx]
	mov	DWORD PTR 4[rdi], edx
	mov	rdx, rax
	shr	rdx
	and	edx, 31
	movzx	edx, BYTE PTR [rcx+rdx]
	jmp	.L521
	.p2align 4,,10
	.p2align 3
.L466:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	xor	eax, 7
	mov	ecx, 3
	mov	edx, eax
	jmp	.L492
	.cfi_endproc
.LFE571:
	.size	fetch_texel, .-fetch_texel
	.p2align 4,,15
	.globl	fetch_texel_entlut
	.type	fetch_texel_entlut, @function
fetch_texel_entlut:
.LFB572:
	.cfi_startproc
	mov	ecx, ecx
	mov	r8, QWORD PTR tile@GOTPCREL[rip]
	lea	rax, [rcx+rcx*4]
	lea	rax, [rax+rax*4]
	lea	rax, [r8+rax*4]
	mov	ecx, DWORD PTR 8[rax]
	mov	r8d, DWORD PTR 16[rax]
	imul	ecx, edx
	add	ecx, DWORD PTR 12[rax]
	mov	eax, DWORD PTR 96[rax]
	sal	r8d, 4
	and	eax, 15
	sub	eax, 3
	cmp	eax, 12
	ja	.L523
	lea	r9, .L525[rip]
	movsx	rax, DWORD PTR [r9+rax*4]
	add	r9, rax
	jmp	r9
	.section	.rodata
	.align 4
	.align 4
.L525:
	.long	.L524-.L525
	.long	.L530-.L525
	.long	.L530-.L525
	.long	.L530-.L525
	.long	.L530-.L525
	.long	.L529-.L525
	.long	.L529-.L525
	.long	.L529-.L525
	.long	.L530-.L525
	.long	.L529-.L525
	.long	.L529-.L525
	.long	.L529-.L525
	.long	.L530-.L525
	.text
	.p2align 4,,10
	.p2align 3
.L530:
	and	edx, 1
	lea	ecx, [rsi+rcx*8]
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	eax, ecx
	and	eax, 2047
	movzx	eax, BYTE PTR [rdx+rax]
	lea	eax, 1[0+rax*4]
	movzx	eax, WORD PTR 2048[rdx+rax*2]
.L534:
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	esi, DWORD PTR 24[rdx]
	test	esi, esi
	jne	.L543
.L557:
	mov	rcx, QWORD PTR replicated_rgba@GOTPCREL[rip]
	mov	edx, eax
	shr	edx, 11
	movsx	rdx, edx
	movzx	edx, BYTE PTR [rcx+rdx]
	mov	DWORD PTR [rdi], edx
	mov	rdx, rax
	shr	rdx, 6
	and	edx, 31
	movzx	edx, BYTE PTR [rcx+rdx]
	mov	DWORD PTR 4[rdi], edx
	mov	rdx, rax
	and	eax, 1
	shr	rdx
	neg	eax
	and	edx, 31
	movzx	eax, al
	movzx	edx, BYTE PTR [rcx+rdx]
	mov	DWORD PTR 12[rdi], eax
	mov	DWORD PTR 8[rdi], edx
	ret
	.p2align 4,,10
	.p2align 3
.L529:
	and	edx, 1
	lea	ecx, [rsi+rcx*4]
	cmp	edx, 1
	mov	rdx, QWORD PTR TMEM@GOTPCREL[rip]
	sbb	eax, eax
	and	eax, -2
	add	eax, 3
	xor	eax, ecx
	and	eax, 1023
	movzx	eax, WORD PTR [rdx+rax*2]
	shr	eax, 6
	and	eax, 1020
	or	rax, 1
	movzx	eax, WORD PTR 2048[rdx+rax*2]
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	esi, DWORD PTR 24[rdx]
	test	esi, esi
	je	.L557
.L543:
	mov	edx, eax
	and	eax, 255
	shr	edx, 8
	mov	DWORD PTR 12[rdi], eax
	mov	DWORD PTR 8[rdi], edx
	mov	DWORD PTR 4[rdi], edx
	mov	DWORD PTR [rdi], edx
	ret
	.p2align 4,,10
	.p2align 3
.L524:
	lea	ecx, [rsi+rcx*8]
.L556:
	and	edx, 1
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	cmp	edx, 1
	sbb	edx, edx
	and	edx, -4
	add	edx, 7
	xor	edx, ecx
	and	edx, 2047
	and	esi, 1
	movzx	edx, BYTE PTR [rax+rdx]
	je	.L536
	and	edx, 15
.L537:
	or	edx, r8d
	lea	edx, 1[0+rdx*4]
	movzx	eax, WORD PTR 2048[rax+rdx*2]
	jmp	.L534
	.p2align 4,,10
	.p2align 3
.L523:
	sal	ecx, 4
	add	ecx, esi
	shr	ecx
	jmp	.L556
	.p2align 4,,10
	.p2align 3
.L536:
	shr	edx, 4
	jmp	.L537
	.cfi_endproc
.LFE572:
	.size	fetch_texel_entlut, .-fetch_texel_entlut
	.p2align 4,,15
	.globl	fetch_texel_quadro
	.type	fetch_texel_quadro, @function
fetch_texel_quadro:
.LFB573:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r10, QWORD PTR tile@GOTPCREL[rip]
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
	mov	eax, DWORD PTR 72[rsp]
	mov	r14d, DWORD PTR 56[rsp]
	mov	r15d, DWORD PTR 64[rsp]
	lea	rax, [rax+rax*4]
	lea	rax, [rax+rax*4]
	lea	rax, [r10+rax*4]
	mov	r11d, DWORD PTR 8[rax]
	mov	r10d, DWORD PTR 12[rax]
	add	rax, 80
	mov	ebx, DWORD PTR -64[rax]
	mov	r13d, r11d
	imul	r13d, r14d
	imul	r11d, r15d
	add	r13d, r10d
	add	r11d, r10d
	cmp	DWORD PTR 12[rax], 19
	ja	.L558
	mov	r10d, DWORD PTR 12[rax]
	lea	rax, .L561[rip]
	movsx	r10, DWORD PTR [rax+r10*4]
	add	rax, r10
	jmp	rax
	.section	.rodata
	.align 4
	.align 4
.L561:
	.long	.L560-.L561
	.long	.L568-.L561
	.long	.L563-.L561
	.long	.L564-.L561
	.long	.L565-.L561
	.long	.L565-.L561
	.long	.L566-.L561
	.long	.L566-.L561
	.long	.L567-.L561
	.long	.L568-.L561
	.long	.L578-.L561
	.long	.L578-.L561
	.long	.L571-.L561
	.long	.L572-.L561
	.long	.L573-.L561
	.long	.L578-.L561
	.long	.L575-.L561
	.long	.L576-.L561
	.long	.L578-.L561
	.long	.L578-.L561
	.text
	.p2align 4,,10
	.p2align 3
.L571:
	sal	r13d, 4
	sal	r11d, 4
	mov	eax, r14d
	lea	ebp, 0[r13+r8]
	lea	ebx, [r11+r8]
	mov	r10d, r11d
	add	r13d, r9d
	add	r10d, r9d
	and	eax, 1
	shr	ebp
	shr	r13d
	shr	ebx
	shr	r10d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	ebp, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebp, 4095
	and	r13d, 4095
	and	eax, -4
	add	eax, 7
	xor	ebx, eax
	xor	r10d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	ebx, 4095
	and	r10d, 4095
	and	r8d, 1
	movzx	r12d, BYTE PTR [rax+rbp]
	jne	.L733
	shr	r12d, 4
.L624:
	mov	r14d, r12d
	and	r14d, 14
	lea	r11d, [r14+r14]
	mov	ebp, r14d
	shr	r14d, 2
	sal	ebp, 4
	or	r11d, ebp
	or	r11d, r14d
	mov	DWORD PTR [rdi], r11d
	mov	DWORD PTR 4[rdi], r11d
	mov	DWORD PTR 8[rdi], r11d
	mov	r11d, r12d
	and	r11d, 1
	neg	r11d
	test	r8d, r8d
	movzx	r11d, r11b
	mov	DWORD PTR 12[rdi], r11d
	movzx	edi, BYTE PTR [rax+rbx]
	je	.L626
	mov	r8d, edi
	and	r8d, 15
.L627:
	mov	r11d, r8d
	and	r11d, 14
	lea	edi, [r11+r11]
	mov	ebx, r11d
	shr	r11d, 2
	sal	ebx, 4
	or	edi, ebx
	or	edi, r11d
	mov	DWORD PTR [rdx], edi
	mov	DWORD PTR 4[rdx], edi
	mov	DWORD PTR 8[rdx], edi
	mov	edi, r8d
	and	edi, 1
	neg	edi
	and	r9d, 1
	movzx	edi, dil
	mov	DWORD PTR 12[rdx], edi
	movzx	edi, BYTE PTR [rax+r13]
	je	.L629
	and	edi, 15
.L630:
	mov	r8d, edi
	and	r8d, 14
	lea	edx, [r8+r8]
	mov	r11d, r8d
	shr	r8d, 2
	sal	r11d, 4
	or	edx, r11d
	or	edx, r8d
	mov	DWORD PTR [rsi], edx
	mov	DWORD PTR 4[rsi], edx
	mov	DWORD PTR 8[rsi], edx
	mov	edx, edi
	and	edx, 1
	neg	edx
	test	r9d, r9d
	movzx	edx, dl
	mov	DWORD PTR 12[rsi], edx
	movzx	edx, BYTE PTR [rax+r10]
	je	.L632
	and	edx, 15
.L633:
	mov	esi, edx
	and	esi, 14
	lea	eax, [rsi+rsi]
	mov	edi, esi
	shr	esi, 2
	sal	edi, 4
	or	eax, edi
	or	eax, esi
	mov	DWORD PTR [rcx], eax
	mov	DWORD PTR 4[rcx], eax
	mov	DWORD PTR 8[rcx], eax
	mov	eax, edx
	and	eax, 1
	neg	eax
	movzx	eax, al
	mov	DWORD PTR 12[rcx], eax
	.p2align 4,,10
	.p2align 3
.L558:
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
	.p2align 4,,10
	.p2align 3
.L578:
	.cfi_restore_state
	mov	eax, r14d
	sal	r13d, 2
	sal	r11d, 2
	and	eax, 1
	lea	ebx, 0[r13+r8]
	add	r13d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -2
	add	eax, 3
	xor	ebx, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebx, 2047
	and	r13d, 2047
	and	eax, -2
	add	eax, 3
	xor	r8d, eax
	xor	r9d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	r8d, 2047
	and	r9d, 2047
	movzx	ebx, WORD PTR [rax+rbx*2]
	movzx	r10d, bl
	movzx	ebp, bh
	mov	DWORD PTR 4[rdi], r10d
	mov	r10d, ebx
	movzx	ebx, WORD PTR [rax+r13*2]
	sal	r10d, 31
	mov	DWORD PTR [rdi], ebp
	mov	DWORD PTR 8[rdi], ebp
	sar	r10d, 31
	movzx	r10d, r10b
	mov	DWORD PTR 12[rdi], r10d
	movzx	edi, bh
	movzx	r10d, bl
	mov	DWORD PTR [rsi], edi
	mov	DWORD PTR 8[rsi], edi
	mov	edi, ebx
	movzx	ebx, WORD PTR [rax+r8*2]
	sal	edi, 31
	mov	DWORD PTR 4[rsi], r10d
	sar	edi, 31
	movzx	eax, WORD PTR [rax+r9*2]
	movzx	edi, dil
	mov	DWORD PTR 12[rsi], edi
	movzx	esi, bh
	movzx	edi, bl
	mov	DWORD PTR [rdx], esi
	mov	DWORD PTR 8[rdx], esi
	mov	esi, ebx
	sal	esi, 31
	mov	DWORD PTR 4[rdx], edi
	sar	esi, 31
	movzx	esi, sil
	mov	DWORD PTR 12[rdx], esi
	movzx	edx, ah
	movzx	esi, al
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	sal	eax, 31
	mov	DWORD PTR [rcx], edx
	mov	DWORD PTR 4[rcx], esi
	pop	r13
	.cfi_def_cfa_offset 24
	sar	eax, 31
	mov	DWORD PTR 8[rcx], edx
	movzx	eax, al
	pop	r14
	.cfi_def_cfa_offset 16
	mov	DWORD PTR 12[rcx], eax
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L568:
	.cfi_restore_state
	mov	eax, r14d
	sal	r13d, 3
	sal	r11d, 3
	and	eax, 1
	lea	ebx, 0[r13+r8]
	add	r13d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	ebx, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebx, 4095
	and	r13d, 4095
	and	eax, -4
	add	eax, 7
	xor	r8d, eax
	xor	r9d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	r8d, 4095
	movzx	r10d, BYTE PTR [rax+rbx]
	mov	DWORD PTR [rdi], r10d
	mov	DWORD PTR 4[rdi], r10d
	mov	DWORD PTR 8[rdi], r10d
	mov	DWORD PTR 12[rdi], r10d
	movzx	edi, BYTE PTR [rax+r8]
	mov	DWORD PTR [rdx], edi
	mov	DWORD PTR 4[rdx], edi
	mov	DWORD PTR 8[rdx], edi
	mov	DWORD PTR 12[rdx], edi
	movzx	edx, BYTE PTR [rax+r13]
	mov	DWORD PTR [rsi], edx
	mov	DWORD PTR 4[rsi], edx
	mov	DWORD PTR 8[rsi], edx
	mov	DWORD PTR 12[rsi], edx
.L732:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	and	r9d, 4095
	movzx	eax, BYTE PTR [rax+r9]
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	mov	DWORD PTR [rcx], eax
	mov	DWORD PTR 4[rcx], eax
	mov	DWORD PTR 8[rcx], eax
	mov	DWORD PTR 12[rcx], eax
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L560:
	.cfi_restore_state
	sal	r13d, 4
	sal	r11d, 4
	mov	eax, r14d
	lea	ebp, 0[r13+r8]
	lea	ebx, [r11+r8]
	add	r13d, r9d
	add	r11d, r9d
	and	eax, 1
	shr	r13d
	shr	ebp
	shr	ebx
	shr	r11d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	ebp, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebp, 4095
	and	r13d, 4095
	and	eax, -4
	add	eax, 7
	xor	ebx, eax
	xor	r11d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	ebx, 4095
	and	r11d, 4095
	and	r8d, 1
	movzx	r10d, BYTE PTR [rax+rbp]
	jne	.L734
	shr	r10d, 4
	mov	r8d, r10d
	sal	r8d, 4
	or	r8d, r10d
	mov	DWORD PTR [rdi], r8d
	mov	DWORD PTR 4[rdi], r8d
	mov	DWORD PTR 8[rdi], r8d
	mov	DWORD PTR 12[rdi], r8d
	movzx	r8d, BYTE PTR [rax+rbx]
	shr	r8d, 4
.L582:
	mov	edi, r8d
	sal	edi, 4
	or	edi, r8d
	and	r9d, 1
	mov	DWORD PTR [rdx], edi
	mov	DWORD PTR 4[rdx], edi
	mov	DWORD PTR 8[rdx], edi
	mov	DWORD PTR 12[rdx], edi
	movzx	edi, BYTE PTR [rax+r13]
	je	.L583
	and	edi, 15
	mov	edx, edi
	sal	edx, 4
	or	edx, edi
	mov	DWORD PTR [rsi], edx
	mov	DWORD PTR 4[rsi], edx
	mov	DWORD PTR 8[rsi], edx
	mov	DWORD PTR 12[rsi], edx
	movzx	eax, BYTE PTR [rax+r11]
	and	eax, 15
.L584:
	mov	DWORD PTR -16[rsp], eax
	movd	xmm2, DWORD PTR -16[rsp]
	pshufd	xmm1, xmm2, 0
	movdqa	xmm0, xmm1
	pslld	xmm0, 4
	por	xmm0, xmm1
	movdqu	XMMWORD PTR [rcx], xmm0
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L573:
	mov	eax, r14d
	sal	r13d, 2
	sal	r11d, 2
	and	eax, 1
	lea	ebx, 0[r13+r8]
	add	r13d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -2
	add	eax, 3
	xor	ebx, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebx, 2047
	and	r13d, 2047
	and	eax, -2
	add	eax, 3
	xor	r8d, eax
	xor	r9d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	r8d, 2047
	and	r9d, 2047
	movzx	r10d, WORD PTR [rax+rbx*2]
	mov	rbx, r10
	movzx	r10d, r10b
	movzx	ebx, bh
	mov	DWORD PTR 12[rdi], r10d
	mov	DWORD PTR 8[rdi], ebx
	mov	DWORD PTR 4[rdi], ebx
	mov	DWORD PTR [rdi], ebx
	movzx	ebx, WORD PTR [rax+r13*2]
	movzx	edi, bh
	movzx	ebx, bl
	mov	DWORD PTR 12[rsi], ebx
	movzx	ebx, WORD PTR [rax+r8*2]
	mov	DWORD PTR 8[rsi], edi
	mov	DWORD PTR 4[rsi], edi
	mov	DWORD PTR [rsi], edi
	movzx	esi, bh
	movzx	ebx, bl
	mov	DWORD PTR 8[rdx], esi
	mov	DWORD PTR 4[rdx], esi
	mov	DWORD PTR [rdx], esi
	mov	DWORD PTR 12[rdx], ebx
	movzx	edx, WORD PTR [rax+r9*2]
	movzx	eax, dh
	movzx	edx, dl
	mov	DWORD PTR 8[rcx], eax
	mov	DWORD PTR 4[rcx], eax
	mov	DWORD PTR [rcx], eax
	mov	DWORD PTR 12[rcx], edx
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L563:
	mov	eax, r14d
	sal	r13d, 2
	sal	r11d, 2
	and	eax, 1
	lea	ebx, 0[r13+r8]
	add	r13d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -2
	add	eax, 3
	xor	ebx, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebx, 2047
	and	r13d, 2047
	and	eax, -2
	add	eax, 3
	xor	r8d, eax
	xor	r9d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	r8d, 2047
	and	r9d, 2047
	movzx	r12d, WORD PTR [rax+rbx*2]
	movzx	r10d, WORD PTR [rax+r8*2]
	movzx	ebx, WORD PTR [rax+r13*2]
	movzx	r9d, WORD PTR [rax+r9*2]
	mov	rax, QWORD PTR replicated_rgba@GOTPCREL[rip]
	mov	r8d, r12d
	shr	r8w, 11
	and	r8d, 31
	movzx	r8d, BYTE PTR [rax+r8]
	mov	DWORD PTR [rdi], r8d
	mov	r8, r12
	shr	r8, 6
	and	r8d, 31
	movzx	r8d, BYTE PTR [rax+r8]
	mov	DWORD PTR 4[rdi], r8d
	mov	r8, r12
	shr	r8
	and	r8d, 31
	movzx	r8d, BYTE PTR [rax+r8]
	mov	DWORD PTR 8[rdi], r8d
	mov	r8d, r12d
	sal	r8d, 31
	sar	r8d, 31
	movzx	r8d, r8b
	mov	DWORD PTR 12[rdi], r8d
	mov	edi, ebx
	shr	di, 11
	and	edi, 31
	movzx	edi, BYTE PTR [rax+rdi]
	mov	DWORD PTR [rsi], edi
	mov	rdi, rbx
	shr	rdi, 6
	and	edi, 31
	movzx	edi, BYTE PTR [rax+rdi]
	mov	DWORD PTR 4[rsi], edi
	mov	rdi, rbx
	shr	rdi
	and	edi, 31
	movzx	edi, BYTE PTR [rax+rdi]
	mov	DWORD PTR 8[rsi], edi
	mov	edi, ebx
	sal	edi, 31
	sar	edi, 31
	movzx	edi, dil
	mov	DWORD PTR 12[rsi], edi
	mov	esi, r10d
	shr	si, 11
	and	esi, 31
	movzx	esi, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], esi
	mov	rsi, r10
	shr	rsi, 6
	and	esi, 31
	movzx	esi, BYTE PTR [rax+rsi]
	mov	DWORD PTR 4[rdx], esi
	mov	rsi, r10
	shr	rsi
	and	esi, 31
	movzx	esi, BYTE PTR [rax+rsi]
	mov	DWORD PTR 8[rdx], esi
	mov	esi, r10d
	sal	esi, 31
	sar	esi, 31
	movzx	esi, sil
	mov	DWORD PTR 12[rdx], esi
	mov	edx, r9d
	shr	dx, 11
	and	edx, 31
	movzx	edx, BYTE PTR [rax+rdx]
	mov	DWORD PTR [rcx], edx
	mov	rdx, r9
	shr	rdx, 6
	and	edx, 31
	movzx	edx, BYTE PTR [rax+rdx]
	mov	DWORD PTR 4[rcx], edx
	mov	rdx, r9
	shr	rdx
	and	edx, 31
	movzx	eax, BYTE PTR [rax+rdx]
	mov	DWORD PTR 8[rcx], eax
	mov	eax, r9d
	sal	eax, 31
	sar	eax, 31
	movzx	eax, al
	mov	DWORD PTR 12[rcx], eax
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L564:
	mov	eax, r14d
	sal	r13d, 2
	sal	r11d, 2
	and	eax, 1
	lea	r12d, 0[r13+r8]
	add	r13d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -2
	add	eax, 3
	xor	r12d, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	r12d, 1023
	and	r13d, 1023
	and	eax, -2
	mov	r10d, r12d
	add	eax, 3
	xor	r8d, eax
	xor	r9d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	r8d, 1023
	and	r9d, 1023
	movzx	r10d, WORD PTR [rax+r10*2]
	mov	rbx, r10
	movzx	r10d, r10b
	movzx	ebp, bh
	mov	ebx, r12d
	mov	DWORD PTR 4[rdi], r10d
	or	bh, 4
	mov	DWORD PTR [rdi], ebp
	mov	ebx, ebx
	movzx	ebx, WORD PTR [rax+rbx*2]
	movzx	ebp, bh
	movzx	ebx, bl
	mov	DWORD PTR 12[rdi], ebx
	mov	DWORD PTR 8[rdi], ebp
	mov	edi, r13d
	movzx	ebx, WORD PTR [rax+rdi*2]
	or	r13d, 1024
	movzx	edi, bh
	movzx	ebx, bl
	mov	DWORD PTR 4[rsi], ebx
	movzx	ebx, WORD PTR [rax+r13*2]
	mov	DWORD PTR [rsi], edi
	movzx	edi, bh
	movzx	ebx, bl
	mov	DWORD PTR 12[rsi], ebx
	mov	DWORD PTR 8[rsi], edi
	mov	esi, r8d
	movzx	ebx, WORD PTR [rax+rsi*2]
	or	r8d, 1024
	movzx	esi, bh
	movzx	ebx, bl
	mov	DWORD PTR 4[rdx], ebx
	movzx	ebx, WORD PTR [rax+r8*2]
	mov	DWORD PTR [rdx], esi
	movzx	esi, bh
	movzx	ebx, bl
	mov	DWORD PTR 8[rdx], esi
	mov	DWORD PTR 12[rdx], ebx
	mov	edx, r9d
	movzx	edx, WORD PTR [rax+rdx*2]
	or	r9d, 1024
	movzx	eax, WORD PTR [rax+r9*2]
	movzx	esi, dh
	movzx	edx, dl
	mov	DWORD PTR 4[rcx], edx
	movzx	edx, ah
	movzx	eax, al
	mov	DWORD PTR [rcx], esi
	mov	DWORD PTR 8[rcx], edx
	mov	DWORD PTR 12[rcx], eax
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L576:
	mov	eax, r14d
	sal	r13d, 3
	sal	r11d, 3
	and	eax, 1
	lea	ebx, 0[r13+r8]
	add	r13d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	ebx, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebx, 4095
	and	r13d, 4095
	and	eax, -4
	add	eax, 7
	xor	r8d, eax
	xor	r9d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	r8d, 4095
	movzx	r10d, BYTE PTR [rax+rbx]
	mov	DWORD PTR [rdi], r10d
	mov	DWORD PTR 4[rdi], r10d
	mov	DWORD PTR 8[rdi], r10d
	mov	DWORD PTR 12[rdi], r10d
	movzx	edi, BYTE PTR [rax+r13]
	mov	DWORD PTR [rsi], edi
	mov	DWORD PTR 4[rsi], edi
	mov	DWORD PTR 8[rsi], edi
	mov	DWORD PTR 12[rsi], edi
	movzx	esi, BYTE PTR [rax+r8]
	mov	DWORD PTR [rdx], esi
	mov	DWORD PTR 4[rdx], esi
	mov	DWORD PTR 8[rdx], esi
	mov	DWORD PTR 12[rdx], esi
	jmp	.L732
	.p2align 4,,10
	.p2align 3
.L575:
	sal	r13d, 4
	sal	r11d, 4
	mov	eax, r14d
	lea	ebp, 0[r13+r8]
	lea	ebx, [r11+r8]
	add	r13d, r9d
	add	r11d, r9d
	and	eax, 1
	shr	r13d
	shr	ebp
	shr	ebx
	shr	r11d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	ebp, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebp, 4095
	and	r13d, 4095
	and	eax, -4
	add	eax, 7
	xor	ebx, eax
	xor	r11d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	ebx, 4095
	and	r11d, 4095
	and	r8d, 1
	movzx	r10d, BYTE PTR [rax+rbp]
	jne	.L735
	shr	r10d, 4
	mov	r8d, r10d
	sal	r8d, 4
	or	r8d, r10d
	mov	DWORD PTR 12[rdi], r8d
	mov	DWORD PTR 8[rdi], r8d
	mov	DWORD PTR 4[rdi], r8d
	mov	DWORD PTR [rdi], r8d
	movzx	r8d, BYTE PTR [rax+rbx]
	shr	r8d, 4
.L648:
	mov	edi, r8d
	sal	edi, 4
	or	edi, r8d
	and	r9d, 1
	mov	DWORD PTR 12[rdx], edi
	mov	DWORD PTR 8[rdx], edi
	mov	DWORD PTR 4[rdx], edi
	mov	DWORD PTR [rdx], edi
	movzx	edi, BYTE PTR [rax+r13]
	je	.L649
	and	edi, 15
	mov	edx, edi
	sal	edx, 4
	or	edx, edi
	mov	DWORD PTR 12[rsi], edx
	mov	DWORD PTR 8[rsi], edx
	mov	DWORD PTR 4[rsi], edx
	mov	DWORD PTR [rsi], edx
	movzx	eax, BYTE PTR [rax+r11]
	and	eax, 15
.L650:
	mov	DWORD PTR -16[rsp], eax
	movd	xmm5, DWORD PTR -16[rsp]
	pshufd	xmm1, xmm5, 0
	movdqa	xmm0, xmm1
	pslld	xmm0, 4
	por	xmm0, xmm1
	movdqu	XMMWORD PTR [rcx], xmm0
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L572:
	mov	eax, r14d
	sal	r11d, 3
	sal	r13d, 3
	and	eax, 1
	lea	ebx, 0[r13+r8]
	add	r13d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	eax, 1
	sbb	eax, eax
	mov	r10, QWORD PTR TMEM@GOTPCREL[rip]
	and	eax, -4
	add	eax, 7
	xor	ebx, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebx, 4095
	and	r13d, 4095
	movzx	r11d, BYTE PTR [r10+rbx]
	and	eax, -4
	add	eax, 7
	xor	r8d, eax
	xor	r9d, eax
	and	r8d, 4095
	and	r9d, 4095
	mov	ebx, r11d
	and	ebx, 240
	mov	eax, ebx
	shr	eax, 4
	or	eax, ebx
	mov	DWORD PTR [rdi], eax
	mov	DWORD PTR 4[rdi], eax
	mov	DWORD PTR 8[rdi], eax
	mov	eax, r11d
	and	r11d, 15
	sal	eax, 4
	and	eax, 240
	or	eax, r11d
	mov	DWORD PTR 12[rdi], eax
	movzx	edi, BYTE PTR [r10+r13]
	mov	r11d, edi
	and	r11d, 240
	mov	eax, r11d
	shr	eax, 4
	or	eax, r11d
	mov	DWORD PTR [rsi], eax
	mov	DWORD PTR 4[rsi], eax
	mov	DWORD PTR 8[rsi], eax
	mov	eax, edi
	and	edi, 15
	sal	eax, 4
	and	eax, 240
	or	eax, edi
	mov	DWORD PTR 12[rsi], eax
	movzx	esi, BYTE PTR [r10+r8]
	mov	edi, esi
	and	edi, 240
	mov	eax, edi
	shr	eax, 4
	or	eax, edi
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR 4[rdx], eax
	mov	DWORD PTR 8[rdx], eax
	mov	eax, esi
	and	esi, 15
	sal	eax, 4
	and	eax, 240
	or	eax, esi
	mov	DWORD PTR 12[rdx], eax
	movzx	edx, BYTE PTR [r10+r9]
	mov	esi, edx
	and	esi, 240
	mov	eax, esi
	shr	eax, 4
	or	eax, esi
	mov	DWORD PTR [rcx], eax
	mov	DWORD PTR 4[rcx], eax
	mov	DWORD PTR 8[rcx], eax
	mov	eax, edx
	sal	eax, 4
	and	edx, 15
	and	eax, 240
	or	eax, edx
	mov	DWORD PTR 12[rcx], eax
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L565:
	mov	eax, r14d
	sal	r13d, 3
	sal	r11d, 3
	and	eax, 1
	lea	ebx, 0[r13+r8]
	add	r13d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	eax, 1
	sbb	eax, eax
	mov	r12, QWORD PTR TMEM@GOTPCREL[rip]
	and	eax, -4
	add	eax, 7
	xor	ebx, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	ebx, 2047
	and	r13d, 2047
	and	eax, -4
	movzx	r14d, BYTE PTR [r12+rbx]
	movzx	r13d, BYTE PTR [r12+r13]
	add	eax, 7
	xor	r8d, eax
	xor	r9d, eax
	and	r8d, 2047
	and	r9d, 2047
	movzx	ebp, BYTE PTR [r12+r8]
	movzx	r9d, BYTE PTR [r12+r9]
	lea	ebx, -128[r14]
	lea	r10d, -128[r13]
	mov	DWORD PTR 8[rdi], r14d
	mov	DWORD PTR 12[rdi], r14d
	and	ebx, 511
	and	r10d, 511
	mov	DWORD PTR [rdi], ebx
	mov	DWORD PTR 4[rdi], ebx
	lea	r8d, -128[rbp]
	lea	eax, -128[r9]
	mov	DWORD PTR [rsi], r10d
	mov	DWORD PTR 4[rsi], r10d
	mov	DWORD PTR 8[rsi], r13d
	and	r8d, 511
	and	eax, 511
	mov	DWORD PTR 12[rsi], r13d
	mov	DWORD PTR [rdx], r8d
	mov	DWORD PTR 4[rdx], r8d
	mov	DWORD PTR 8[rdx], ebp
	mov	DWORD PTR 12[rdx], ebp
	mov	DWORD PTR [rcx], eax
	mov	DWORD PTR 4[rcx], eax
	mov	DWORD PTR 8[rcx], r9d
	mov	DWORD PTR 12[rcx], r9d
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L566:
	sal	r13d, 3
	sal	r11d, 3
	and	r14d, 1
	lea	ebp, 0[r13+r8]
	lea	eax, [r11+r8]
	add	r13d, r9d
	add	r11d, r9d
	mov	ebx, r13d
	mov	r9d, r14d
	mov	r12d, ebp
	mov	r8d, eax
	mov	r10d, r11d
	shr	r12d
	shr	ebx
	shr	r8d
	shr	r10d
	cmp	r14d, 1
	mov	DWORD PTR -16[rsp], eax
	sbb	eax, eax
	mov	r14d, ebp
	and	r15d, 1
	and	eax, -4
	mov	ebp, DWORD PTR -16[rsp]
	add	eax, 7
	xor	r14d, eax
	xor	r13d, eax
	cmp	r15d, 1
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	ebp, eax
	xor	r11d, eax
	cmp	r9d, 1
	sbb	eax, eax
	mov	r9, QWORD PTR TMEM@GOTPCREL[rip]
	and	eax, -2
	add	eax, 3
	xor	r12d, eax
	xor	ebx, eax
	cmp	r15d, 1
	sbb	eax, eax
	and	r11d, 2047
	and	r12d, 1023
	and	eax, -2
	or	r11, 2048
	movzx	r12d, WORD PTR [r9+r12*2]
	add	eax, 3
	and	r14d, 2047
	and	r13d, 2047
	xor	r8d, eax
	xor	r10d, eax
	and	ebp, 2047
	mov	r15d, r8d
	or	r14, 2048
	or	r13, 2048
	and	r15d, 1023
	or	rbp, 2048
	and	r10d, 1023
	movzx	eax, WORD PTR [r9+r15*2]
	movzx	r15d, BYTE PTR [r9+r14]
	and	ebx, 1023
	movzx	r14d, BYTE PTR [r9+r13]
	movzx	r13d, BYTE PTR [r9+rbp]
	movzx	ebp, r12b
	movzx	r8d, WORD PTR [r9+r10*2]
	movzx	ebx, WORD PTR [r9+rbx*2]
	add	ebp, -128
	and	ebp, 511
	mov	WORD PTR -16[rsp], ax
	movzx	eax, BYTE PTR [r9+r11]
	mov	DWORD PTR 4[rdi], ebp
	mov	DWORD PTR 8[rdi], r15d
	movzx	r11d, bl
	movzx	ebx, bh
	mov	DWORD PTR 12[rdi], r15d
	add	r11d, -128
	add	ebx, -128
	mov	DWORD PTR -12[rsp], eax
	mov	rax, r12
	and	ebx, 511
	movzx	eax, ah
	and	r11d, 511
	mov	r12d, eax
	movzx	eax, WORD PTR -16[rsp]
	add	r12d, -128
	and	r12d, 511
	mov	DWORD PTR [rdi], r12d
	mov	DWORD PTR [rsi], ebx
	movzx	r9d, al
	movzx	eax, ah
	mov	DWORD PTR 4[rsi], r11d
	lea	r10d, -128[rax]
	movzx	eax, r8b
	add	r9d, -128
	add	eax, -128
	and	r9d, 511
	mov	DWORD PTR 8[rsi], r14d
	mov	DWORD PTR -16[rsp], eax
	mov	rax, r8
	and	DWORD PTR -16[rsp], 511
	movzx	eax, ah
	and	r10d, 511
	mov	DWORD PTR 12[rsi], r14d
	mov	r8d, eax
	mov	eax, DWORD PTR -16[rsp]
	mov	DWORD PTR [rdx], r10d
	mov	DWORD PTR 4[rdx], r9d
	add	r8d, -128
	mov	DWORD PTR 8[rdx], r13d
	and	r8d, 511
	mov	DWORD PTR 12[rdx], r13d
	mov	DWORD PTR 4[rcx], eax
	mov	eax, DWORD PTR -12[rsp]
	mov	DWORD PTR [rcx], r8d
	mov	DWORD PTR 8[rcx], eax
	mov	DWORD PTR 12[rcx], eax
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L567:
	sal	r13d, 4
	sal	r11d, 4
	mov	eax, r14d
	lea	r12d, 0[r13+r8]
	lea	ebp, [r11+r8]
	add	r13d, r9d
	add	r11d, r9d
	and	eax, 1
	shr	r13d
	shr	r12d
	shr	ebp
	shr	r11d
	cmp	eax, 1
	sbb	eax, eax
	and	eax, -4
	add	eax, 7
	xor	r12d, eax
	xor	r13d, eax
	mov	eax, r15d
	and	eax, 1
	cmp	eax, 1
	sbb	eax, eax
	and	r12d, 4095
	and	r13d, 4095
	and	eax, -4
	add	eax, 7
	xor	ebp, eax
	xor	r11d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	ebp, 4095
	and	r11d, 4095
	and	r8d, 1
	movzx	r10d, BYTE PTR [rax+r12]
	jne	.L736
	movzx	r8d, r10b
	sal	ebx, 4
	shr	r8d, 4
	or	r8d, ebx
	mov	DWORD PTR 12[rdi], r8d
	mov	DWORD PTR 8[rdi], r8d
	mov	DWORD PTR 4[rdi], r8d
	mov	DWORD PTR [rdi], r8d
	movzx	edi, BYTE PTR [rax+rbp]
	shr	edi, 4
.L604:
	or	edi, ebx
	and	r9d, 1
	mov	DWORD PTR 12[rdx], edi
	mov	DWORD PTR 8[rdx], edi
	mov	DWORD PTR 4[rdx], edi
	mov	DWORD PTR [rdx], edi
	movzx	edx, BYTE PTR [rax+r13]
	je	.L605
	and	edx, 15
	or	edx, ebx
	mov	DWORD PTR 12[rsi], edx
	mov	DWORD PTR 8[rsi], edx
	mov	DWORD PTR 4[rsi], edx
	mov	DWORD PTR [rsi], edx
	movzx	eax, BYTE PTR [rax+r11]
	and	eax, 15
.L606:
	mov	DWORD PTR -16[rsp], eax
	movd	xmm3, DWORD PTR -16[rsp]
	mov	DWORD PTR -16[rsp], ebx
	movd	xmm4, DWORD PTR -16[rsp]
	pshufd	xmm0, xmm3, 0
	pshufd	xmm1, xmm4, 0
	por	xmm0, xmm1
	movdqu	XMMWORD PTR [rcx], xmm0
	jmp	.L558
	.p2align 4,,10
	.p2align 3
.L736:
	mov	r8d, r10d
	sal	ebx, 4
	and	r8d, 15
	or	r8d, ebx
	mov	DWORD PTR 12[rdi], r8d
	mov	DWORD PTR 8[rdi], r8d
	mov	DWORD PTR 4[rdi], r8d
	mov	DWORD PTR [rdi], r8d
	movzx	edi, BYTE PTR [rax+rbp]
	and	edi, 15
	jmp	.L604
	.p2align 4,,10
	.p2align 3
.L733:
	and	r12d, 15
	jmp	.L624
	.p2align 4,,10
	.p2align 3
.L735:
	and	r10d, 15
	mov	r8d, r10d
	sal	r8d, 4
	or	r8d, r10d
	mov	DWORD PTR 12[rdi], r8d
	mov	DWORD PTR 8[rdi], r8d
	mov	DWORD PTR 4[rdi], r8d
	mov	DWORD PTR [rdi], r8d
	movzx	r8d, BYTE PTR [rax+rbx]
	and	r8d, 15
	jmp	.L648
	.p2align 4,,10
	.p2align 3
.L734:
	and	r10d, 15
	mov	r8d, r10d
	sal	r8d, 4
	or	r8d, r10d
	mov	DWORD PTR [rdi], r8d
	mov	DWORD PTR 4[rdi], r8d
	mov	DWORD PTR 8[rdi], r8d
	mov	DWORD PTR 12[rdi], r8d
	movzx	r8d, BYTE PTR [rax+rbx]
	and	r8d, 15
	jmp	.L582
	.p2align 4,,10
	.p2align 3
.L649:
	shr	edi, 4
	mov	edx, edi
	sal	edx, 4
	or	edx, edi
	mov	DWORD PTR 12[rsi], edx
	mov	DWORD PTR 8[rsi], edx
	mov	DWORD PTR 4[rsi], edx
	mov	DWORD PTR [rsi], edx
	movzx	eax, BYTE PTR [rax+r11]
	shr	eax, 4
	jmp	.L650
	.p2align 4,,10
	.p2align 3
.L583:
	shr	edi, 4
	mov	edx, edi
	sal	edx, 4
	or	edx, edi
	mov	DWORD PTR [rsi], edx
	mov	DWORD PTR 4[rsi], edx
	mov	DWORD PTR 8[rsi], edx
	mov	DWORD PTR 12[rsi], edx
	movzx	eax, BYTE PTR [rax+r11]
	shr	eax, 4
	jmp	.L584
	.p2align 4,,10
	.p2align 3
.L605:
	shr	edx, 4
	or	edx, ebx
	mov	DWORD PTR 12[rsi], edx
	mov	DWORD PTR 8[rsi], edx
	mov	DWORD PTR 4[rsi], edx
	mov	DWORD PTR [rsi], edx
	movzx	eax, BYTE PTR [rax+r11]
	shr	eax, 4
	jmp	.L606
	.p2align 4,,10
	.p2align 3
.L632:
	shr	edx, 4
	jmp	.L633
	.p2align 4,,10
	.p2align 3
.L629:
	shr	edi, 4
	jmp	.L630
	.p2align 4,,10
	.p2align 3
.L626:
	movzx	r8d, dil
	shr	r8d, 4
	jmp	.L627
	.cfi_endproc
.LFE573:
	.size	fetch_texel_quadro, .-fetch_texel_quadro
	.p2align 4,,15
	.globl	fetch_texel_entlut_quadro
	.type	fetch_texel_entlut_quadro, @function
fetch_texel_entlut_quadro:
.LFB574:
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
	mov	r13, QWORD PTR tile@GOTPCREL[rip]
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	mov	eax, DWORD PTR 72[rsp]
	mov	ebp, DWORD PTR 56[rsp]
	mov	ebx, DWORD PTR 64[rsp]
	lea	rax, [rax+rax*4]
	lea	rax, [rax+rax*4]
	lea	rax, 0[r13+rax*4]
	mov	r11d, DWORD PTR 8[rax]
	mov	r10d, DWORD PTR 12[rax]
	mov	r12d, r11d
	imul	r12d, ebp
	imul	r11d, ebx
	add	r12d, r10d
	add	r11d, r10d
	mov	r10d, DWORD PTR 16[rax]
	mov	eax, DWORD PTR 96[rax]
	and	eax, 15
	sal	r10d, 4
	sub	eax, 3
	cmp	eax, 12
	ja	.L738
	lea	r13, .L740[rip]
	movsx	rax, DWORD PTR 0[r13+rax*4]
	add	r13, rax
	jmp	r13
	.section	.rodata
	.align 4
	.align 4
.L740:
	.long	.L739-.L740
	.long	.L745-.L740
	.long	.L745-.L740
	.long	.L745-.L740
	.long	.L745-.L740
	.long	.L744-.L740
	.long	.L744-.L740
	.long	.L744-.L740
	.long	.L745-.L740
	.long	.L744-.L740
	.long	.L744-.L740
	.long	.L744-.L740
	.long	.L745-.L740
	.text
	.p2align 4,,10
	.p2align 3
.L745:
	sal	r11d, 3
	sal	r12d, 3
	and	ebp, 1
	lea	r13d, [r12+r8]
	add	r12d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	ebp, 1
	sbb	eax, eax
	and	ebx, 1
	and	eax, -4
	add	eax, 7
	xor	r13d, eax
	xor	r12d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	cmp	ebx, 1
	sbb	ebx, ebx
	and	r13d, 2047
	and	r12d, 2047
	movzx	r10d, BYTE PTR [rax+r13]
	and	ebx, -4
	add	ebx, 7
	xor	r8d, ebx
	xor	r9d, ebx
	and	r8d, 2047
	and	r9d, 2047
	lea	r10d, 1[0+r10*4]
	movzx	r8d, BYTE PTR [rax+r8]
	movzx	r9d, BYTE PTR [rax+r9]
	movsx	r10, r10d
	movzx	ebp, WORD PTR 2048[rax+r10*2]
	movzx	r10d, BYTE PTR [rax+r12]
	lea	r8d, 1[0+r8*4]
	lea	r9d, 1[0+r9*4]
	movsx	r8, r8d
	movsx	r9, r9d
	lea	r10d, 1[0+r10*4]
	movzx	r8d, WORD PTR 2048[rax+r8*2]
	movzx	ebx, WORD PTR 2048[rax+r9*2]
	movsx	r10, r10d
	movzx	r11d, WORD PTR 2048[rax+r10*2]
.L752:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r12d, DWORD PTR 24[rax]
	test	r12d, r12d
	jne	.L769
.L799:
	mov	rax, QWORD PTR replicated_rgba@GOTPCREL[rip]
	mov	r9d, ebp
	shr	r9w, 11
	and	r9d, 31
	movzx	r9d, BYTE PTR [rax+r9]
	mov	DWORD PTR [rdi], r9d
	mov	r9, rbp
	shr	r9, 6
	and	r9d, 31
	movzx	r9d, BYTE PTR [rax+r9]
	mov	DWORD PTR 4[rdi], r9d
	mov	r9, rbp
	sal	ebp, 31
	shr	r9
	sar	ebp, 31
	and	r9d, 31
	movzx	ebp, bpl
	movzx	r9d, BYTE PTR [rax+r9]
	mov	DWORD PTR 12[rdi], ebp
	mov	DWORD PTR 8[rdi], r9d
	mov	edi, r11d
	shr	di, 11
	and	edi, 31
	movzx	edi, BYTE PTR [rax+rdi]
	mov	DWORD PTR [rsi], edi
	mov	rdi, r11
	shr	rdi, 6
	and	edi, 31
	movzx	edi, BYTE PTR [rax+rdi]
	mov	DWORD PTR 4[rsi], edi
	mov	rdi, r11
	sal	r11d, 31
	shr	rdi
	sar	r11d, 31
	and	edi, 31
	movzx	r11d, r11b
	movzx	edi, BYTE PTR [rax+rdi]
	mov	DWORD PTR 12[rsi], r11d
	mov	DWORD PTR 8[rsi], edi
	mov	esi, r8d
	shr	si, 11
	and	esi, 31
	movzx	esi, BYTE PTR [rax+rsi]
	mov	DWORD PTR [rdx], esi
	mov	rsi, r8
	shr	rsi, 6
	and	esi, 31
	movzx	esi, BYTE PTR [rax+rsi]
	mov	DWORD PTR 4[rdx], esi
	mov	rsi, r8
	sal	r8d, 31
	shr	rsi
	sar	r8d, 31
	and	esi, 31
	movzx	r8d, r8b
	movzx	esi, BYTE PTR [rax+rsi]
	mov	DWORD PTR 12[rdx], r8d
	mov	DWORD PTR 8[rdx], esi
	mov	edx, ebx
	shr	dx, 11
	and	edx, 31
	movzx	edx, BYTE PTR [rax+rdx]
	mov	DWORD PTR [rcx], edx
	mov	rdx, rbx
	shr	rdx, 6
	and	edx, 31
	movzx	edx, BYTE PTR [rax+rdx]
	mov	DWORD PTR 4[rcx], edx
	mov	rdx, rbx
	sal	ebx, 31
	shr	rdx
	sar	ebx, 31
	movzx	ebx, bl
	and	edx, 31
	movzx	eax, BYTE PTR [rax+rdx]
	mov	DWORD PTR 12[rcx], ebx
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
	mov	DWORD PTR 8[rcx], eax
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L744:
	.cfi_restore_state
	sal	r11d, 2
	sal	r12d, 2
	and	ebp, 1
	lea	r13d, [r12+r8]
	add	r12d, r9d
	add	r8d, r11d
	add	r9d, r11d
	cmp	ebp, 1
	sbb	eax, eax
	and	ebx, 1
	and	eax, -2
	add	eax, 3
	xor	r13d, eax
	xor	r12d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	cmp	ebx, 1
	sbb	ebx, ebx
	and	r13d, 1023
	and	r12d, 1023
	movzx	r10d, WORD PTR [rax+r13*2]
	and	ebx, -2
	add	ebx, 3
	xor	r8d, ebx
	xor	r9d, ebx
	and	r8d, 1023
	and	r9d, 1023
	shr	r10w, 6
	movzx	r8d, WORD PTR [rax+r8*2]
	movzx	r9d, WORD PTR [rax+r9*2]
	and	r10d, 1020
	or	r10, 1
	movzx	ebp, WORD PTR 2048[rax+r10*2]
	movzx	r10d, WORD PTR [rax+r12*2]
	shr	r8w, 6
	shr	r9w, 6
	and	r8d, 1020
	and	r9d, 1020
	or	r8, 1
	or	r9, 1
	shr	r10w, 6
	movzx	r8d, WORD PTR 2048[rax+r8*2]
	movzx	ebx, WORD PTR 2048[rax+r9*2]
	and	r10d, 1020
	or	r10, 1
	movzx	r11d, WORD PTR 2048[rax+r10*2]
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r12d, DWORD PTR 24[rax]
	test	r12d, r12d
	je	.L799
.L769:
	mov	rax, rbp
	movzx	ebp, bpl
	movzx	eax, ah
	mov	DWORD PTR 12[rdi], ebp
	mov	DWORD PTR 8[rdi], eax
	mov	DWORD PTR 4[rdi], eax
	mov	DWORD PTR [rdi], eax
	mov	rax, r11
	movzx	r11d, r11b
	movzx	eax, ah
	mov	DWORD PTR 12[rsi], r11d
	mov	DWORD PTR 8[rsi], eax
	mov	DWORD PTR 4[rsi], eax
	mov	DWORD PTR [rsi], eax
	mov	rax, r8
	movzx	r8d, r8b
	movzx	eax, ah
	mov	DWORD PTR 12[rdx], r8d
	mov	DWORD PTR 8[rdx], eax
	mov	DWORD PTR 4[rdx], eax
	mov	DWORD PTR [rdx], eax
	movzx	eax, bh
	movzx	ebx, bl
	mov	DWORD PTR 12[rcx], ebx
	mov	DWORD PTR 8[rcx], eax
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
	mov	DWORD PTR 4[rcx], eax
	mov	DWORD PTR [rcx], eax
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L739:
	.cfi_restore_state
	sal	r11d, 3
	sal	r12d, 3
	lea	r15d, [r11+r8]
	lea	r13d, [r11+r9]
	lea	r14d, [r12+r8]
	add	r12d, r9d
.L798:
	and	ebp, 1
	cmp	ebp, 1
	sbb	eax, eax
	and	ebx, 1
	and	eax, -4
	add	eax, 7
	xor	r14d, eax
	xor	r12d, eax
	cmp	ebx, 1
	sbb	eax, eax
	and	r14d, 2047
	and	eax, -4
	add	eax, 7
	xor	r15d, eax
	xor	r13d, eax
	mov	rax, QWORD PTR TMEM@GOTPCREL[rip]
	and	r8d, 1
	movzx	r11d, BYTE PTR [rax+r14]
	je	.L755
	and	r11d, 15
	and	r15d, 2047
	or	r11d, r10d
	movzx	r8d, BYTE PTR [rax+r15]
	lea	r11d, 1[0+r11*4]
	movzx	ebp, WORD PTR 2048[rax+r11*2]
	and	r8d, 15
.L756:
	movzx	r8d, r8w
	and	r12d, 2047
	or	r8d, r10d
	and	r9d, 1
	movzx	r11d, BYTE PTR [rax+r12]
	lea	r8d, 1[0+r8*4]
	movzx	r8d, WORD PTR 2048[rax+r8*2]
	je	.L757
	and	r11d, 15
	and	r13d, 2047
	or	r11d, r10d
	movzx	r9d, BYTE PTR [rax+r13]
	lea	r11d, 1[0+r11*4]
	movzx	r11d, WORD PTR 2048[rax+r11*2]
	and	r9d, 15
.L758:
	movzx	r9d, r9w
	or	r9d, r10d
	lea	r9d, 1[0+r9*4]
	movzx	ebx, WORD PTR 2048[rax+r9*2]
	jmp	.L752
	.p2align 4,,10
	.p2align 3
.L738:
	sal	r12d, 4
	sal	r11d, 4
	lea	r14d, [r12+r8]
	lea	r15d, [r11+r8]
	lea	r13d, [r11+r9]
	add	r12d, r9d
	shr	r14d
	shr	r12d
	shr	r15d
	shr	r13d
	jmp	.L798
	.p2align 4,,10
	.p2align 3
.L757:
	mov	r9d, r11d
	and	r13d, 2047
	shr	r9d, 4
	and	r9d, 15
	or	r9d, r10d
	lea	r9d, 1[0+r9*4]
	movzx	r11d, WORD PTR 2048[rax+r9*2]
	movzx	r9d, BYTE PTR [rax+r13]
	shr	r9w, 4
	jmp	.L758
	.p2align 4,,10
	.p2align 3
.L755:
	mov	r8d, r11d
	and	r15d, 2047
	shr	r8d, 4
	and	r8d, 15
	or	r8d, r10d
	lea	r8d, 1[0+r8*4]
	movzx	ebp, WORD PTR 2048[rax+r8*2]
	movzx	r8d, BYTE PTR [rax+r15]
	shr	r8w, 4
	jmp	.L756
	.cfi_endproc
.LFE574:
	.size	fetch_texel_entlut_quadro, .-fetch_texel_entlut_quadro
	.p2align 4,,15
	.type	texture_pipeline_cycle.constprop.9, @function
texture_pipeline_cycle.constprop.9:
.LFB671:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	eax, edx
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
	mov	ebp, edx
	lea	rdx, 0[rbp+rbp*4]
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	lea	rdx, [rdx+rdx*4]
	sub	rsp, 120
	.cfi_def_cfa_offset 176
	mov	rbx, QWORD PTR tile@GOTPCREL[rip]
	mov	r12, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edx, DWORD PTR 48[rbx+rdx*4]
	mov	r15d, DWORD PTR 36[r12]
	cmp	edx, 10
	jg	.L801
	movsx	edi, di
	mov	ecx, edx
	sar	edi, cl
.L802:
	lea	rdx, 0[rbp+rbp*4]
	mov	ecx, edi
	xor	r9d, r9d
	sar	ecx, 3
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [rbx+rdx*4]
	cmp	ecx, DWORD PTR 60[rdx]
	mov	edx, DWORD PTR 40[rdx]
	setge	r9b
	cmp	edx, 10
	jle	.L863
	mov	ecx, 16
	sub	ecx, edx
	sal	esi, cl
	movsx	r10d, si
.L804:
	lea	rdx, 0[rbp+rbp*4]
	mov	esi, r10d
	xor	r11d, r11d
	sar	esi, 3
	lea	rdx, [rdx+rdx*4]
	lea	rcx, [rbx+rdx*4]
	cmp	esi, DWORD PTR 64[rcx]
	mov	esi, DWORD PTR 52[rcx]
	lea	edx, 0[0+rsi*8]
	setge	r11b
	add	rcx, 48
	sub	edi, edx
	mov	ecx, DWORD PTR 8[rcx]
	mov	edx, edi
	mov	edi, DWORD PTR 28[r12]
	sal	ecx, 3
	sub	r10d, ecx
	test	edi, edi
	je	.L805
	movsx	rdi, eax
	mov	r13d, edx
	mov	r14d, r10d
	lea	rcx, [rdi+rdi*4]
	mov	r8d, edx
	and	r13d, 31
	and	r14d, 31
	sar	r8d, 5
	lea	rcx, [rcx+rcx*4]
	lea	rcx, 64[rbx+rcx*4]
	mov	esi, DWORD PTR 12[rcx]
	test	esi, esi
	je	.L807
	and	edx, 65536
	jne	.L845
	test	r9d, r9d
	je	.L807
	mov	r8d, DWORD PTR 4[rcx]
	xor	r13d, r13d
	.p2align 4,,10
	.p2align 3
.L807:
	lea	rdx, [rdi+rdi*4]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, 64[rbx+rdx*4]
	mov	esi, DWORD PTR 16[rdx]
	test	esi, esi
	jne	.L864
.L809:
	sar	r10d, 5
	lea	r11d, 1[r10]
.L810:
	lea	rdx, 0[rbp+rbp*4]
	lea	r9d, 2[r8]
	lea	rcx, [rdx+rdx*4]
	lea	edx, 1[r8]
	cmp	DWORD PTR [rbx+rcx*4], 1
	cmovne	r9d, edx
	lea	rdx, [rdi+rdi*4]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [rbx+rdx*4]
	movsx	rsi, DWORD PTR 44[rdx]
	test	esi, esi
	je	.L814
	mov	ecx, DWORD PTR 32[rdx]
	test	ecx, ecx
	jne	.L865
.L815:
	mov	rdx, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	edx, DWORD PTR [rdx+rsi*4]
	and	r8d, edx
	and	r9d, edx
.L814:
	lea	rdx, [rdi+rdi*4]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [rbx+rdx*4]
	movsx	rsi, DWORD PTR 36[rdx]
	test	esi, esi
	je	.L816
	mov	ecx, DWORD PTR 24[rdx]
	test	ecx, ecx
	jne	.L866
.L817:
	mov	rdx, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	edx, DWORD PTR [rdx+rsi*4]
	and	r10d, edx
	and	r11d, edx
.L816:
	test	r15d, r15d
	je	.L818
	mov	r15d, DWORD PTR 20[r12]
	lea	rcx, 96[rsp]
	lea	rdx, 80[rsp]
	lea	rsi, 64[rsp]
	lea	rdi, 48[rsp]
	mov	DWORD PTR 16[rsp], eax
	mov	DWORD PTR 8[rsp], r11d
	mov	DWORD PTR [rsp], r10d
	test	r15d, r15d
	je	.L867
	call	fetch_texel_entlut_quadro@PLT
.L820:
	lea	rax, 0[rbp+rbp*4]
	lea	rax, [rax+rax*4]
	cmp	DWORD PTR [rbx+rax*4], 1
	je	.L821
	mov	r8d, DWORD PTR 80[rsp]
	mov	r9d, DWORD PTR 64[rsp]
	mov	esi, DWORD PTR 84[rsp]
	mov	edi, DWORD PTR 68[rsp]
.L822:
	mov	r15d, DWORD PTR 32[r12]
	test	r15d, r15d
	je	.L823
	cmp	r13d, 16
	je	.L868
.L823:
	lea	eax, [r14+r13]
	test	al, 32
	je	.L825
	mov	r10d, DWORD PTR 96[rsp]
	mov	edx, 32
	mov	r11d, DWORD PTR 104[rsp]
	mov	ecx, edx
	sub	edx, r14d
	mov	eax, DWORD PTR 88[rsp]
	sub	ecx, r13d
	mov	ebx, DWORD PTR 108[rsp]
	sub	r8d, r10d
	sub	r9d, r10d
	imul	r9d, edx
	sub	eax, r11d
	imul	r8d, ecx
	lea	r8d, 16[r8+r9]
	mov	r9d, DWORD PTR 100[rsp]
	imul	eax, ecx
	sar	r8d, 5
	sub	esi, r9d
	sub	edi, r9d
	imul	edi, edx
	imul	esi, ecx
	lea	esi, 16[rsi+rdi]
	mov	edi, eax
	mov	eax, DWORD PTR 72[rsp]
	sar	esi, 5
	sub	eax, r11d
	imul	eax, edx
	lea	edi, 16[rdi+rax]
	mov	eax, DWORD PTR 92[rsp]
	sar	edi, 5
	sub	eax, ebx
	imul	ecx, eax
	mov	eax, DWORD PTR 76[rsp]
	sub	eax, ebx
	imul	edx, eax
.L862:
	lea	eax, 16[rcx+rdx]
	sar	eax, 5
	add	eax, ebx
	lea	ebx, [r11+rdi]
	mov	DWORD PTR 36[rsp], ebx
	lea	ebx, [r9+rsi]
	mov	DWORD PTR 40[rsp], ebx
	lea	ebx, [r10+r8]
	mov	DWORD PTR 44[rsp], ebx
	jmp	.L826
	.p2align 4,,10
	.p2align 3
.L805:
	movsx	rdi, eax
	mov	esi, edx
	lea	rcx, [rdi+rdi*4]
	sar	esi, 5
	lea	rcx, [rcx+rcx*4]
	lea	rcx, 64[rbx+rcx*4]
	mov	r13d, DWORD PTR 12[rcx]
	test	r13d, r13d
	je	.L833
	xor	esi, esi
	test	edx, 65536
	jne	.L833
	test	r9d, r9d
	jne	.L834
	mov	esi, edx
	sar	esi, 5
	.p2align 4,,10
	.p2align 3
.L833:
	lea	rdx, [rdi+rdi*4]
	lea	rdx, [rdx+rdx*4]
	lea	rcx, 64[rbx+rdx*4]
	mov	edx, r10d
	sar	edx, 5
	mov	ebp, DWORD PTR 16[rcx]
	test	ebp, ebp
	je	.L836
	xor	edx, edx
	test	r10d, 65536
	jne	.L836
	test	r11d, r11d
	jne	.L837
	mov	edx, r10d
	sar	edx, 5
	.p2align 4,,10
	.p2align 3
.L836:
	lea	rcx, [rdi+rdi*4]
	lea	rcx, [rcx+rcx*4]
	lea	rcx, [rbx+rcx*4]
	movsx	r8, DWORD PTR 44[rcx]
	test	r8d, r8d
	je	.L838
	mov	r9d, DWORD PTR 32[rcx]
	test	r9d, r9d
	je	.L839
	mov	ecx, DWORD PTR 84[rcx]
	mov	r14d, esi
	sar	r14d, cl
	mov	ecx, r14d
	and	ecx, 1
	neg	ecx
	xor	esi, ecx
.L839:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	and	esi, DWORD PTR [rcx+r8*4]
.L838:
	lea	rcx, [rdi+rdi*4]
	lea	rcx, [rcx+rcx*4]
	lea	rcx, [rbx+rcx*4]
	movsx	rdi, DWORD PTR 36[rcx]
	test	edi, edi
	je	.L840
	mov	r8d, DWORD PTR 24[rcx]
	test	r8d, r8d
	je	.L841
	mov	ecx, DWORD PTR 88[rcx]
	mov	ebx, edx
	sar	ebx, cl
	mov	ecx, ebx
	and	ecx, 1
	neg	ecx
	xor	edx, ecx
.L841:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	and	edx, DWORD PTR [rcx+rdi*4]
.L840:
	mov	r14d, DWORD PTR 20[r12]
	lea	rdi, 48[rsp]
	mov	ecx, eax
	test	r14d, r14d
	je	.L869
	call	fetch_texel_entlut@PLT
	test	r15d, r15d
	je	.L844
.L870:
	mov	rcx, QWORD PTR texel0_color@GOTPCREL[rip]
	mov	rax, QWORD PTR 48[rsp]
	mov	rdx, QWORD PTR 56[rsp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
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
.L801:
	.cfi_restore_state
	mov	ecx, 16
	sub	ecx, edx
	sal	edi, cl
	movsx	edi, di
	jmp	.L802
	.p2align 4,,10
	.p2align 3
.L864:
	test	r10d, 65536
	jne	.L846
	test	r11d, r11d
	je	.L809
	mov	r10d, DWORD PTR 8[rdx]
	xor	r14d, r14d
	lea	r11d, 1[r10]
	jmp	.L810
	.p2align 4,,10
	.p2align 3
.L869:
	call	fetch_texel@PLT
	test	r15d, r15d
	jne	.L870
.L844:
	mov	rdi, QWORD PTR k_YUV_RGB@GOTPCREL[rip]
	mov	ecx, DWORD PTR 48[rsp]
	mov	edx, DWORD PTR 52[rsp]
	mov	eax, DWORD PTR 56[rsp]
	mov	r8d, DWORD PTR 4[rdi]
	mov	esi, DWORD PTR 8[rdi]
	sal	ecx, 23
	sal	edx, 23
	sar	ecx, 23
	sal	eax, 23
	sar	edx, 23
	sar	eax, 23
	imul	esi, edx
	imul	r8d, ecx
	imul	edx, DWORD PTR [rdi]
	imul	ecx, DWORD PTR 12[rdi]
	lea	r8d, 128[r8+rsi]
	mov	rsi, QWORD PTR texel0_color@GOTPCREL[rip]
	sar	r8d, 8
	add	r8d, eax
	sub	edx, -128
	and	r8d, 511
	sub	ecx, -128
	sar	edx, 8
	mov	DWORD PTR 4[rsi], r8d
	sar	ecx, 8
	add	edx, eax
	add	ecx, eax
	and	edx, 511
	and	eax, 511
	and	ecx, 511
	mov	DWORD PTR [rsi], edx
	mov	DWORD PTR 12[rsi], eax
	mov	DWORD PTR 8[rsi], ecx
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
.L863:
	.cfi_restore_state
	movsx	r10d, si
	mov	ecx, edx
	sar	r10d, cl
	jmp	.L804
	.p2align 4,,10
	.p2align 3
.L818:
	mov	r14d, DWORD PTR 20[r12]
	lea	rdi, 48[rsp]
	mov	ecx, eax
	mov	edx, r10d
	mov	esi, r8d
	test	r14d, r14d
	je	.L871
	call	fetch_texel_entlut@PLT
.L828:
	lea	rax, 0[rbp+rbp*4]
	lea	rax, [rax+rax*4]
	cmp	DWORD PTR [rbx+rax*4], 1
	je	.L829
	mov	edx, DWORD PTR 52[rsp]
	mov	eax, DWORD PTR 48[rsp]
.L830:
	mov	rdi, QWORD PTR k_YUV_RGB@GOTPCREL[rip]
	mov	esi, DWORD PTR 8[rdi]
	mov	ecx, DWORD PTR [rdi]
	mov	ebx, DWORD PTR 4[rdi]
	imul	ecx, edx
	imul	edx, esi
	sub	ecx, -128
	imul	esi, eax
	sar	ecx, 8
	imul	ebx, eax
	mov	eax, DWORD PTR 56[rsp]
	sub	esi, -128
	lea	edx, 128[rbx+rdx]
	sar	esi, 8
	lea	ebx, [rax+rsi]
	sar	edx, 8
	mov	DWORD PTR 36[rsp], ebx
	lea	ebx, [rax+rdx]
	mov	DWORD PTR 40[rsp], ebx
	lea	ebx, [rax+rcx]
	mov	DWORD PTR 44[rsp], ebx
.L826:
	movd	xmm1, DWORD PTR 36[rsp]
	mov	DWORD PTR 36[rsp], eax
	movd	xmm2, DWORD PTR 36[rsp]
	mov	rax, QWORD PTR texel0_color@GOTPCREL[rip]
	movd	xmm0, DWORD PTR 44[rsp]
	movd	xmm3, DWORD PTR 40[rsp]
	punpckldq	xmm1, xmm2
	punpckldq	xmm0, xmm3
	punpcklqdq	xmm0, xmm1
	pand	xmm0, XMMWORD PTR .LC0[rip]
	movdqa	XMMWORD PTR [rax], xmm0
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
.L866:
	.cfi_restore_state
	mov	ecx, DWORD PTR 88[rdx]
	mov	edx, r10d
	sar	edx, cl
	and	edx, 1
	neg	edx
	xor	r10d, edx
	mov	edx, r11d
	sar	edx, cl
	and	edx, 1
	neg	edx
	xor	r11d, edx
	jmp	.L817
	.p2align 4,,10
	.p2align 3
.L845:
	xor	r8d, r8d
	xor	r13d, r13d
	jmp	.L807
	.p2align 4,,10
	.p2align 3
.L867:
	call	fetch_texel_quadro@PLT
	jmp	.L820
	.p2align 4,,10
	.p2align 3
.L865:
	mov	ecx, DWORD PTR 84[rdx]
	mov	edx, r8d
	sar	edx, cl
	and	edx, 1
	neg	edx
	xor	r8d, edx
	mov	edx, r9d
	sar	edx, cl
	and	edx, 1
	neg	edx
	xor	r9d, edx
	jmp	.L815
	.p2align 4,,10
	.p2align 3
.L871:
	call	fetch_texel@PLT
	jmp	.L828
	.p2align 4,,10
	.p2align 3
.L846:
	mov	r11d, 1
	xor	r10d, r10d
	xor	r14d, r14d
	jmp	.L810
	.p2align 4,,10
	.p2align 3
.L825:
	mov	r10d, DWORD PTR 48[rsp]
	mov	r11d, DWORD PTR 56[rsp]
	mov	edx, DWORD PTR 72[rsp]
	mov	eax, DWORD PTR 88[rsp]
	mov	ebx, DWORD PTR 60[rsp]
	mov	ecx, DWORD PTR 76[rsp]
	sub	r9d, r10d
	sub	r8d, r10d
	imul	r9d, r13d
	sub	edx, r11d
	sub	eax, r11d
	imul	r8d, r14d
	sub	ecx, ebx
	lea	r8d, 16[r9+r8]
	mov	r9d, DWORD PTR 52[rsp]
	imul	edx, r13d
	imul	eax, r14d
	sar	r8d, 5
	sub	edi, r9d
	sub	esi, r9d
	imul	edi, r13d
	imul	esi, r14d
	lea	esi, 16[rdi+rsi]
	lea	edi, 16[rdx+rax]
	mov	edx, DWORD PTR 92[rsp]
	imul	ecx, r13d
	sar	esi, 5
	sar	edi, 5
	sub	edx, ebx
	imul	edx, r14d
	jmp	.L862
	.p2align 4,,10
	.p2align 3
.L837:
	mov	edx, DWORD PTR 8[rcx]
	jmp	.L836
	.p2align 4,,10
	.p2align 3
.L821:
	mov	eax, DWORD PTR 48[rsp]
	mov	r9d, DWORD PTR 64[rsp]
	mov	edi, DWORD PTR 68[rsp]
	mov	r8d, DWORD PTR 80[rsp]
	mov	esi, DWORD PTR 84[rsp]
	sal	eax, 23
	sal	r9d, 23
	sar	eax, 23
	sal	edi, 23
	sal	r8d, 23
	mov	DWORD PTR 48[rsp], eax
	mov	eax, DWORD PTR 52[rsp]
	sal	esi, 23
	sar	r9d, 23
	sar	edi, 23
	sar	r8d, 23
	sar	esi, 23
	mov	DWORD PTR 64[rsp], r9d
	mov	DWORD PTR 68[rsp], edi
	sal	eax, 23
	mov	DWORD PTR 80[rsp], r8d
	mov	DWORD PTR 84[rsp], esi
	sar	eax, 23
	mov	DWORD PTR 52[rsp], eax
	mov	eax, DWORD PTR 96[rsp]
	sal	eax, 23
	sar	eax, 23
	mov	DWORD PTR 96[rsp], eax
	mov	eax, DWORD PTR 100[rsp]
	sal	eax, 23
	sar	eax, 23
	mov	DWORD PTR 100[rsp], eax
	jmp	.L822
	.p2align 4,,10
	.p2align 3
.L829:
	mov	eax, DWORD PTR 48[rsp]
	mov	edx, DWORD PTR 52[rsp]
	sal	eax, 23
	sal	edx, 23
	sar	eax, 23
	sar	edx, 23
	jmp	.L830
	.p2align 4,,10
	.p2align 3
.L834:
	mov	esi, DWORD PTR 4[rcx]
	jmp	.L833
	.p2align 4,,10
	.p2align 3
.L868:
	cmp	r14d, 16
	jne	.L823
	mov	ecx, DWORD PTR 48[rsp]
	mov	r10d, DWORD PTR 52[rsp]
	mov	r11d, DWORD PTR 56[rsp]
	mov	eax, DWORD PTR 60[rsp]
	mov	edx, ecx
	sub	r9d, ecx
	sub	r8d, ecx
	not	edx
	add	edx, DWORD PTR 96[rsp]
	add	r8d, r9d
	sub	edi, r10d
	sub	esi, r10d
	mov	r9d, eax
	add	esi, edi
	mov	edi, r11d
	not	r9d
	not	edi
	add	edi, DWORD PTR 104[rsp]
	add	r9d, DWORD PTR 108[rsp]
	add	r8d, edx
	mov	edx, r10d
	not	edx
	add	edx, DWORD PTR 100[rsp]
	sal	r8d, 6
	add	r8d, 192
	sar	r8d, 8
	add	esi, edx
	mov	edx, DWORD PTR 72[rsp]
	sal	esi, 6
	add	esi, 192
	sub	edx, r11d
	sar	esi, 8
	sub	edx, r11d
	add	edx, DWORD PTR 88[rsp]
	add	edi, edx
	mov	edx, DWORD PTR 76[rsp]
	sal	edi, 6
	add	edi, 192
	sub	edx, eax
	sar	edi, 8
	sub	edx, eax
	add	edx, DWORD PTR 92[rsp]
	lea	ebx, [r11+rdi]
	mov	DWORD PTR 36[rsp], ebx
	lea	ebx, [r10+rsi]
	add	edx, r9d
	mov	DWORD PTR 40[rsp], ebx
	lea	ebx, [rcx+r8]
	sal	edx, 6
	add	edx, 192
	mov	DWORD PTR 44[rsp], ebx
	sar	edx, 8
	add	eax, edx
	jmp	.L826
	.cfi_endproc
.LFE671:
	.size	texture_pipeline_cycle.constprop.9, .-texture_pipeline_cycle.constprop.9
	.p2align 4,,15
	.globl	sort_tmem_idx
	.type	sort_tmem_idx, @function
sort_tmem_idx:
.LFB577:
	.cfi_startproc
	mov	eax, esi
	and	eax, 3
	cmp	eax, r9d
	je	.L878
	mov	eax, edx
	and	eax, 3
	cmp	eax, r9d
	je	.L879
	mov	eax, ecx
	and	eax, 3
	cmp	eax, r9d
	je	.L880
	mov	eax, r8d
	and	eax, 3
	cmp	r9d, eax
	je	.L881
	mov	DWORD PTR [rdi], 0
	ret
	.p2align 4,,10
	.p2align 3
.L881:
	and	r8d, 1023
	mov	DWORD PTR [rdi], r8d
	ret
	.p2align 4,,10
	.p2align 3
.L878:
	and	esi, 1023
	mov	DWORD PTR [rdi], esi
	ret
	.p2align 4,,10
	.p2align 3
.L879:
	and	edx, 1023
	mov	DWORD PTR [rdi], edx
	ret
	.p2align 4,,10
	.p2align 3
.L880:
	and	ecx, 1023
	mov	DWORD PTR [rdi], ecx
	ret
	.cfi_endproc
.LFE577:
	.size	sort_tmem_idx, .-sort_tmem_idx
	.p2align 4,,15
	.globl	get_tmem_idx
	.type	get_tmem_idx, @function
get_tmem_idx:
.LFB575:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	edx, edx
	mov	r10, rcx
	mov	r15, r8
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, r9
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
	mov	r9, QWORD PTR tile@GOTPCREL[rip]
	mov	rax, QWORD PTR 80[rsp]
	mov	r8, QWORD PTR 88[rsp]
	mov	rcx, QWORD PTR 96[rsp]
	mov	QWORD PTR 8[rsp], rax
	lea	rax, [rdx+rdx*4]
	lea	rax, [rax+rax*4]
	lea	rax, [r9+rax*4]
	mov	edx, DWORD PTR 8[rax]
	mov	r9d, DWORD PTR 4[rax]
	imul	edx, esi
	and	edx, 511
	add	edx, DWORD PTR 12[rax]
	cmp	r9d, 1
	je	.L888
	cmp	DWORD PTR [rax], 1
	jne	.L883
.L888:
	sar	edi
.L885:
	mov	eax, edi
	and	edi, 2047
	and	esi, 1
	lea	edx, [rdi+rdx*4]
	shr	eax
	and	eax, 1
	mov	ebx, edx
	shr	edx, 10
	xor	eax, esi
	and	ebx, 2045
	and	edx, 1
	mov	DWORD PTR [r8], eax
	lea	r13d, 3[rbx]
	lea	ebp, 1[rbx]
	lea	r12d, 2[rbx]
	mov	DWORD PTR [rcx], edx
	and	r13d, 2047
	test	esi, esi
	je	.L887
	xor	ebx, 2
	xor	ebp, 2
	xor	r12d, 2
	xor	r13d, 2
.L887:
	mov	rdi, r10
	mov	r8d, r13d
	mov	ecx, r12d
	mov	edx, ebp
	mov	esi, ebx
	xor	r9d, r9d
	call	sort_tmem_idx@PLT
	mov	r8d, r13d
	mov	ecx, r12d
	mov	edx, ebp
	mov	esi, ebx
	mov	rdi, r15
	mov	r9d, 1
	call	sort_tmem_idx@PLT
	mov	r8d, r13d
	mov	ecx, r12d
	mov	edx, ebp
	mov	esi, ebx
	mov	rdi, r14
	mov	r9d, 2
	call	sort_tmem_idx@PLT
	mov	rdi, QWORD PTR 8[rsp]
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	mov	esi, ebx
	pop	rbx
	.cfi_def_cfa_offset 48
	mov	edx, ebp
	mov	ecx, r12d
	mov	r8d, r13d
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
	mov	r9d, 3
	jmp	sort_tmem_idx@PLT
	.p2align 4,,10
	.p2align 3
.L883:
	.cfi_restore_state
	mov	eax, edi
	sar	eax, 2
	cmp	r9d, 2
	cmovb	edi, eax
	jmp	.L885
	.cfi_endproc
.LFE575:
	.size	get_tmem_idx, .-get_tmem_idx
	.p2align 4,,15
	.globl	sort_tmem_shorts_lowhalf
	.type	sort_tmem_shorts_lowhalf, @function
sort_tmem_shorts_lowhalf:
.LFB578:
	.cfi_startproc
	cmp	r9d, 1
	je	.L895
	jb	.L896
	cmp	r9d, 2
	je	.L897
	cmp	r9d, 3
	.p2align 4,,3
	je	.L898
	.p2align 4,,3
	rep ret
	.p2align 4,,10
	.p2align 3
.L897:
	mov	DWORD PTR [rdi], ecx
	ret
	.p2align 4,,10
	.p2align 3
.L898:
	mov	DWORD PTR [rdi], r8d
	.p2align 4,,7
	ret
	.p2align 4,,10
	.p2align 3
.L896:
	mov	DWORD PTR [rdi], esi
	ret
	.p2align 4,,10
	.p2align 3
.L895:
	mov	DWORD PTR [rdi], edx
	ret
	.cfi_endproc
.LFE578:
	.size	sort_tmem_shorts_lowhalf, .-sort_tmem_shorts_lowhalf
	.p2align 4,,15
	.globl	compute_color_index
	.type	compute_color_index, @function
compute_color_index:
.LFB579:
	.cfi_startproc
	mov	ecx, ecx
	mov	r10, QWORD PTR tile@GOTPCREL[rip]
	lea	rax, [rcx+rcx*4]
	lea	rax, [rax+rax*4]
	lea	rax, [r10+rax*4]
	mov	r11d, DWORD PTR 4[rax]
	test	r11d, r11d
	je	.L903
	not	edx
	mov	eax, esi
	and	edx, 2
	lea	ecx, 0[0+rdx*4]
	test	ecx, ecx
	jne	.L904
	shr	eax, 4
	xor	ecx, ecx
	and	eax, 15
	shr	esi, cl
	and	esi, 15
	sal	eax, 4
	or	esi, eax
	mov	DWORD PTR [rdi], esi
	ret
	.p2align 4,,10
	.p2align 3
.L904:
	shr	eax, 12
	shr	esi, cl
	and	eax, 15
	and	esi, 15
	sal	eax, 4
	or	esi, eax
	mov	DWORD PTR [rdi], esi
	ret
	.p2align 4,,10
	.p2align 3
.L903:
	xor	edx, 3
	mov	eax, DWORD PTR 16[rax]
	lea	ecx, 0[0+rdx*4]
	shr	esi, cl
	sal	eax, 4
	and	esi, 15
	or	esi, eax
	mov	DWORD PTR [rdi], esi
	ret
	.cfi_endproc
.LFE579:
	.size	compute_color_index, .-compute_color_index
	.p2align 4,,15
	.globl	read_tmem_copy
	.type	read_tmem_copy, @function
read_tmem_copy:
.LFB576:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	eax, r9d
	mov	r10d, eax
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	lea	r10, [r10+r10*4]
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	lea	r10, [r10+r10*4]
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
	mov	rax, QWORD PTR tile@GOTPCREL[rip]
	mov	DWORD PTR 12[rsp], r9d
	mov	rbx, QWORD PTR 176[rsp]
	mov	r9, QWORD PTR 184[rsp]
	mov	r12, QWORD PTR 192[rsp]
	lea	r10, [rax+r10*4]
	mov	r15d, DWORD PTR 8[r10]
	mov	r11d, DWORD PTR 4[r10]
	imul	r15d, r8d
	and	r15d, 511
	add	r15d, DWORD PTR 12[r10]
	cmp	DWORD PTR [r10], 1
	sete	r10b
	cmp	r11d, 1
	je	.L917
	test	r10b, r10b
	je	.L906
.L917:
	add	edi, edi
	add	esi, esi
	add	edx, edx
	add	ecx, ecx
.L908:
	sal	r15d, 4
	and	ecx, 8191
	and	edi, 8191
	and	esi, 8191
	lea	ebp, [rdx+r15]
	mov	r11d, ecx
	lea	r14d, [rsi+r15]
	lea	ecx, [rdi+r15]
	add	r15d, r11d
	and	r15d, 8191
	and	ebp, 8191
	and	r14d, 8191
	and	ecx, 8191
	test	r10b, r10b
	mov	r13d, r15d
	mov	edx, r14d
	jne	.L924
.L910:
	and	r8d, 1
	je	.L911
	xor	ecx, 8
	xor	edx, 8
	xor	r14d, 8
	xor	ebp, 8
	xor	r13d, 8
	xor	r15d, 8
.L911:
	mov	esi, ecx
	shr	esi, 12
	and	esi, 1
	mov	DWORD PTR [r9], esi
	mov	esi, edx
	shr	esi, 12
	and	esi, 1
	mov	DWORD PTR 4[r9], esi
	mov	esi, r14d
	shr	esi, 12
	and	esi, 1
	mov	DWORD PTR 8[r9], esi
	mov	esi, ebp
	shr	esi, 12
	and	esi, 1
	mov	DWORD PTR 12[r9], esi
	mov	esi, r13d
	shr	esi, 12
	and	esi, 1
	mov	DWORD PTR 16[r9], esi
	mov	esi, r15d
	shr	esi, 12
	and	esi, 1
	mov	DWORD PTR 20[r9], esi
	mov	esi, ecx
	sar	ecx, 2
	and	esi, 15
	mov	edi, ecx
	xor	r9d, r9d
	mov	DWORD PTR [r12], esi
	mov	esi, edx
	mov	DWORD PTR 4[rsp], ecx
	and	esi, 15
	sar	edx, 2
	mov	DWORD PTR 4[r12], esi
	mov	esi, r14d
	mov	DWORD PTR 8[rsp], edx
	and	esi, 15
	mov	DWORD PTR 8[r12], esi
	mov	esi, ebp
	sar	ebp, 2
	and	esi, 15
	mov	eax, ebp
	mov	DWORD PTR [rsp], ebp
	mov	DWORD PTR 12[r12], esi
	mov	esi, r13d
	lea	rbp, 80[rsp]
	and	esi, 15
	sar	r13d, 2
	mov	ecx, eax
	mov	DWORD PTR 16[r12], esi
	mov	esi, r15d
	mov	r8d, r13d
	and	esi, 15
	mov	DWORD PTR 20[r12], esi
	mov	esi, edi
	mov	rdi, rbp
	call	sort_tmem_idx@PLT
	mov	ecx, DWORD PTR [rsp]
	mov	edx, DWORD PTR 8[rsp]
	lea	rdi, 4[rbp]
	mov	esi, DWORD PTR 4[rsp]
	mov	r8d, r13d
	mov	r9d, 1
	call	sort_tmem_idx@PLT
	mov	ecx, DWORD PTR [rsp]
	mov	edx, DWORD PTR 8[rsp]
	lea	rdi, 8[rbp]
	mov	esi, DWORD PTR 4[rsp]
	mov	r8d, r13d
	mov	r9d, 2
	call	sort_tmem_idx@PLT
	mov	ecx, DWORD PTR [rsp]
	mov	edx, DWORD PTR 8[rsp]
	lea	rdi, 12[rbp]
	mov	esi, DWORD PTR 4[rsp]
	mov	r8d, r13d
	mov	r9d, 3
	call	sort_tmem_idx@PLT
	mov	edx, DWORD PTR 80[rsp]
	mov	r13, QWORD PTR TMEM@GOTPCREL[rip]
	mov	ecx, DWORD PTR 88[rsp]
	mov	edi, DWORD PTR 92[rsp]
	mov	r9d, DWORD PTR [r12]
	xor	edx, 1
	movzx	esi, WORD PTR 0[r13+rdx*2]
	mov	edx, DWORD PTR 84[rsp]
	xor	edi, 1
	xor	ecx, 1
	movzx	r8d, WORD PTR 0[r13+rdi*2]
	sar	r9d, 2
	movzx	ecx, WORD PTR 0[r13+rcx*2]
	mov	rdi, rbx
	xor	edx, 1
	movzx	edx, WORD PTR 0[r13+rdx*2]
	mov	DWORD PTR 16[rsp], esi
	mov	DWORD PTR 64[rsp], r8d
	mov	DWORD PTR 48[rsp], ecx
	mov	DWORD PTR 32[rsp], edx
	call	sort_tmem_shorts_lowhalf@PLT
	mov	r9d, DWORD PTR 4[r12]
	mov	r8d, DWORD PTR 64[rsp]
	lea	rdi, 4[rbx]
	mov	ecx, DWORD PTR 48[rsp]
	mov	edx, DWORD PTR 32[rsp]
	mov	esi, DWORD PTR 16[rsp]
	sar	r9d, 2
	call	sort_tmem_shorts_lowhalf@PLT
	mov	r9d, DWORD PTR 12[r12]
	mov	r8d, DWORD PTR 64[rsp]
	lea	rdi, 8[rbx]
	mov	ecx, DWORD PTR 48[rsp]
	mov	edx, DWORD PTR 32[rsp]
	mov	esi, DWORD PTR 16[rsp]
	sar	r9d, 2
	call	sort_tmem_shorts_lowhalf@PLT
	mov	r9d, DWORD PTR 16[r12]
	mov	r8d, DWORD PTR 64[rsp]
	lea	rdi, 12[rbx]
	mov	ecx, DWORD PTR 48[rsp]
	mov	edx, DWORD PTR 32[rsp]
	mov	esi, DWORD PTR 16[rsp]
	sar	r9d, 2
	call	sort_tmem_shorts_lowhalf@PLT
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 20[rax]
	test	eax, eax
	je	.L912
	mov	r14d, DWORD PTR 12[rsp]
	mov	edx, DWORD PTR [r12]
	lea	rdi, 16[rsp]
	mov	esi, DWORD PTR [rbx]
	and	edx, 3
	mov	ecx, r14d
	call	compute_color_index@PLT
	mov	edx, DWORD PTR 4[r12]
	mov	esi, DWORD PTR 4[rbx]
	lea	rdi, 32[rsp]
	mov	ecx, r14d
	and	edx, 3
	call	compute_color_index@PLT
	mov	edx, DWORD PTR 12[r12]
	mov	esi, DWORD PTR 8[rbx]
	lea	rdi, 48[rsp]
	mov	ecx, r14d
	and	edx, 3
	call	compute_color_index@PLT
	mov	edx, DWORD PTR 16[r12]
	mov	esi, DWORD PTR 12[rbx]
	lea	rdi, 64[rsp]
	mov	ecx, r14d
	and	edx, 3
	call	compute_color_index@PLT
	mov	eax, DWORD PTR 16[rsp]
	mov	edx, DWORD PTR 32[rsp]
	mov	ecx, DWORD PTR 48[rsp]
	mov	edi, DWORD PTR 64[rsp]
	lea	esi, 0[0+rax*4]
	lea	edx, 1[0+rdx*4]
	lea	ecx, 2[0+rcx*4]
	lea	edi, 3[0+rdi*4]
	mov	DWORD PTR 96[rsp], esi
	mov	DWORD PTR 100[rsp], edx
	mov	DWORD PTR 104[rsp], ecx
	mov	DWORD PTR 108[rsp], edi
.L913:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	or	esi, 1024
	or	dh, 4
	or	ch, 4
	or	edi, 1024
	xor	esi, 1
	xor	edi, 1
	xor	edx, 1
	xor	ecx, 1
	movzx	r8d, WORD PTR 0[r13+rdi*2]
	movzx	esi, WORD PTR 0[r13+rsi*2]
	lea	rdi, 16[rbx]
	movzx	edx, WORD PTR 0[r13+rdx*2]
	movzx	ecx, WORD PTR 0[r13+rcx*2]
	mov	ebp, DWORD PTR 20[rax]
	mov	DWORD PTR 16[rsp], esi
	mov	DWORD PTR 64[rsp], r8d
	test	ebp, ebp
	mov	DWORD PTR 32[rsp], edx
	mov	DWORD PTR 48[rsp], ecx
	jne	.L925
	mov	r9d, DWORD PTR [r12]
	sar	r9d, 2
	call	sort_tmem_shorts_lowhalf@PLT
	mov	r9d, DWORD PTR 8[r12]
	mov	r8d, DWORD PTR 64[rsp]
	lea	rdi, 20[rbx]
	mov	ecx, DWORD PTR 48[rsp]
	mov	edx, DWORD PTR 32[rsp]
	mov	esi, DWORD PTR 16[rsp]
	sar	r9d, 2
	call	sort_tmem_shorts_lowhalf@PLT
	mov	r9d, DWORD PTR 12[r12]
	mov	r8d, DWORD PTR 64[rsp]
	lea	rdi, 24[rbx]
	mov	ecx, DWORD PTR 48[rsp]
	mov	edx, DWORD PTR 32[rsp]
	mov	esi, DWORD PTR 16[rsp]
	sar	r9d, 2
	call	sort_tmem_shorts_lowhalf@PLT
	mov	r9d, DWORD PTR 20[r12]
	lea	rdi, 28[rbx]
	sar	r9d, 2
.L923:
	mov	r8d, DWORD PTR 64[rsp]
	mov	ecx, DWORD PTR 48[rsp]
	mov	edx, DWORD PTR 32[rsp]
	mov	esi, DWORD PTR 16[rsp]
	call	sort_tmem_shorts_lowhalf@PLT
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
.L906:
	.cfi_restore_state
	cmp	r11d, 1
	jbe	.L908
	sal	edi, 2
	sal	esi, 2
	sal	edx, 2
	sal	ecx, 2
	jmp	.L908
	.p2align 4,,10
	.p2align 3
.L912:
	mov	ecx, DWORD PTR [rsp]
	mov	esi, DWORD PTR 4[rsp]
	sar	r15d, 2
	sar	r14d, 2
	lea	rdi, 16[rbp]
	xor	r9d, r9d
	mov	r8d, r15d
	mov	edx, r14d
	call	sort_tmem_idx@PLT
	mov	ecx, DWORD PTR [rsp]
	mov	esi, DWORD PTR 4[rsp]
	lea	rdi, 20[rbp]
	mov	r9d, 1
	mov	r8d, r15d
	mov	edx, r14d
	call	sort_tmem_idx@PLT
	mov	ecx, DWORD PTR [rsp]
	mov	esi, DWORD PTR 4[rsp]
	lea	rdi, 24[rbp]
	mov	r9d, 2
	mov	r8d, r15d
	mov	edx, r14d
	call	sort_tmem_idx@PLT
	mov	ecx, DWORD PTR [rsp]
	mov	esi, DWORD PTR 4[rsp]
	lea	rdi, 28[rbp]
	mov	edx, r14d
	mov	r9d, 3
	mov	r8d, r15d
	call	sort_tmem_idx@PLT
	mov	esi, DWORD PTR 96[rsp]
	mov	edx, DWORD PTR 100[rsp]
	mov	ecx, DWORD PTR 104[rsp]
	mov	edi, DWORD PTR 108[rsp]
	jmp	.L913
	.p2align 4,,10
	.p2align 3
.L925:
	xor	r9d, r9d
	call	sort_tmem_shorts_lowhalf@PLT
	mov	r8d, DWORD PTR 64[rsp]
	mov	ecx, DWORD PTR 48[rsp]
	lea	rdi, 20[rbx]
	mov	edx, DWORD PTR 32[rsp]
	mov	esi, DWORD PTR 16[rsp]
	mov	r9d, 1
	call	sort_tmem_shorts_lowhalf@PLT
	mov	r8d, DWORD PTR 64[rsp]
	mov	ecx, DWORD PTR 48[rsp]
	lea	rdi, 24[rbx]
	mov	edx, DWORD PTR 32[rsp]
	mov	esi, DWORD PTR 16[rsp]
	mov	r9d, 2
	call	sort_tmem_shorts_lowhalf@PLT
	lea	rdi, 28[rbx]
	mov	r9d, 3
	jmp	.L923
	.p2align 4,,10
	.p2align 3
.L924:
	sub	esi, edi
	sub	r11d, edi
	lea	edx, [rcx+rsi*2]
	and	edx, 8191
	lea	r13d, [r11+rdx]
	and	r13d, 8191
	jmp	.L910
	.cfi_endproc
.LFE576:
	.size	read_tmem_copy, .-read_tmem_copy
	.p2align 4,,15
	.globl	replicate_for_copy
	.type	replicate_for_copy, @function
replicate_for_copy:
.LFB580:
	.cfi_startproc
	test	r9d, r9d
	mov	eax, ecx
	je	.L928
	cmp	r9d, 1
	jne	.L936
	xor	edx, 3
	or	edx, 1
	cmp	r8d, 3
	lea	ecx, 0[0+rdx*4]
	je	.L937
	mov	eax, esi
	shr	eax, cl
	and	ecx, -5
	and	eax, 15
	shr	esi, cl
	sal	eax, 4
	and	esi, 15
	or	eax, esi
	mov	DWORD PTR [rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L936:
	mov	rax, rsi
	movzx	esi, ah
	mov	DWORD PTR [rdi], esi
	ret
	.p2align 4,,10
	.p2align 3
.L928:
	xor	edx, 3
	lea	ecx, 0[0+rdx*4]
	shr	esi, cl
	and	esi, 15
	cmp	r8d, 2
	je	.L938
	cmp	r8d, 3
	je	.L939
.L935:
	mov	eax, esi
	sal	eax, 4
	or	eax, esi
	mov	DWORD PTR [rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L939:
	mov	edx, esi
	sal	edx, 4
	or	edx, esi
	mov	ecx, edx
	shr	edx, 6
	and	ecx, 224
	mov	eax, ecx
	shr	eax, 3
	or	eax, edx
	or	eax, ecx
	mov	DWORD PTR [rdi], eax
	ret
	.p2align 4,,10
	.p2align 3
.L937:
	shr	esi, cl
	and	esi, 15
	jmp	.L935
	.p2align 4,,10
	.p2align 3
.L938:
	lea	rax, [rax+rax*4]
	mov	rdx, QWORD PTR tile@GOTPCREL[rip]
	lea	rax, [rax+rax*4]
	lea	rax, [rdx+rax*4]
	mov	eax, DWORD PTR 16[rax]
	sal	eax, 4
	or	eax, esi
	mov	DWORD PTR [rdi], eax
	ret
	.cfi_endproc
.LFE580:
	.size	replicate_for_copy, .-replicate_for_copy
	.p2align 4,,15
	.globl	fetch_qword_copy
	.type	fetch_qword_copy, @function
fetch_qword_copy:
.LFB581:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r10d, ecx
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, rsi
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	mov	r13, rdi
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	mov	ebx, r8d
	sub	rsp, 200
	.cfi_def_cfa_offset 256
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edi, DWORD PTR 20[rax]
	test	edi, edi
	je	.L941
	mov	esi, DWORD PTR 24[rax]
	mov	ebp, 2
	test	esi, esi
	je	.L968
	mov	r12d, 3
	mov	rdi, QWORD PTR tile@GOTPCREL[rip]
	mov	esi, r8d
	jmp	.L942
	.p2align 4,,10
	.p2align 3
.L941:
	mov	esi, r8d
	mov	rdi, QWORD PTR tile@GOTPCREL[rip]
	lea	rax, [rsi+rsi*4]
	lea	rax, [rax+rax*4]
	lea	rax, [rdi+rax*4]
	mov	ebp, DWORD PTR 4[rax]
	mov	r12d, DWORD PTR [rax]
.L942:
	lea	r8, [rsi+rsi*4]
	lea	rax, [r8+r8*4]
	mov	r8d, DWORD PTR 48[rdi+rax*4]
	cmp	r8d, 10
	jg	.L943
	movsx	eax, dx
	mov	ecx, r8d
	sar	eax, cl
.L944:
	lea	rdx, [rsi+rsi*4]
	lea	rdx, [rdx+rdx*4]
	mov	edx, DWORD PTR 40[rdi+rdx*4]
	cmp	edx, 10
	jle	.L984
	mov	ecx, 16
	sub	ecx, edx
	sal	r10d, cl
	movsx	r10d, r10w
.L946:
	movsx	r8, ebx
	lea	rdx, [r8+r8*4]
	lea	rdx, [rdx+rdx*4]
	lea	r15, [rdi+rdx*4]
	mov	esi, DWORD PTR 52[r15]
	mov	edx, DWORD PTR 56[r15]
	movsx	r9, DWORD PTR 44[r15]
	lea	ecx, 0[0+rsi*8]
	sal	edx, 3
	sub	r10d, edx
	sub	eax, ecx
	sar	r10d, 5
	sar	eax, 5
	test	r9d, r9d
	lea	esi, 1[rax]
	lea	edx, 2[rax]
	lea	r11d, 3[rax]
	je	.L947
	mov	ecx, DWORD PTR 32[r15]
	test	ecx, ecx
	jne	.L985
.L948:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx+r9*4]
	and	eax, ecx
	and	esi, ecx
	and	edx, ecx
	and	r11d, ecx
.L947:
	lea	rcx, [r8+r8*4]
	lea	rcx, [rcx+rcx*4]
	lea	rcx, [rdi+rcx*4]
	movsx	rdi, DWORD PTR 36[rcx]
	test	edi, edi
	je	.L949
	mov	r15d, DWORD PTR 24[rcx]
	test	r15d, r15d
	jne	.L986
.L950:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	and	r10d, DWORD PTR [rcx+rdi*4]
.L949:
	lea	rcx, 128[rsp]
	mov	r9d, ebx
	mov	r8d, r10d
	mov	edi, eax
	mov	QWORD PTR 16[rsp], rcx
	lea	rcx, 96[rsp]
	mov	QWORD PTR 8[rsp], rcx
	lea	rcx, 160[rsp]
	mov	QWORD PTR [rsp], rcx
	mov	ecx, r11d
	call	read_tmem_copy@PLT
	cmp	r12d, 1
	je	.L951
	cmp	ebp, 3
	je	.L987
.L953:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	cmp	DWORD PTR 20[rax], 0
	jne	.L965
	mov	r10d, DWORD PTR 96[rsp]
	test	r10d, r10d
	je	.L955
	mov	r9d, DWORD PTR 100[rsp]
	mov	esi, DWORD PTR 176[rsp]
	test	r9d, r9d
	mov	DWORD PTR 32[rsp], esi
	je	.L957
.L989:
	mov	r8d, DWORD PTR 108[rsp]
	mov	ecx, DWORD PTR 180[rsp]
	test	r8d, r8d
	mov	DWORD PTR 48[rsp], ecx
	je	.L959
.L990:
	mov	edi, DWORD PTR 112[rsp]
	mov	eax, DWORD PTR 184[rsp]
	test	edi, edi
	mov	DWORD PTR 64[rsp], eax
	je	.L961
.L991:
	mov	edx, DWORD PTR 188[rsp]
.L962:
	mov	DWORD PTR 80[rsp], edx
.L954:
	sal	eax, 16
	or	eax, edx
	cmp	ebp, 2
	mov	DWORD PTR [r14], eax
	je	.L988
.L963:
	mov	edx, DWORD PTR 128[rsp]
	lea	rdi, 32[rsp]
	mov	r9d, ebp
	mov	r8d, r12d
	mov	ecx, ebx
	and	edx, 3
	call	replicate_for_copy@PLT
	mov	edx, DWORD PTR 132[rsp]
	mov	esi, DWORD PTR 48[rsp]
	lea	rdi, 48[rsp]
	mov	r9d, ebp
	mov	r8d, r12d
	mov	ecx, ebx
	and	edx, 3
	call	replicate_for_copy@PLT
	mov	edx, DWORD PTR 140[rsp]
	mov	esi, DWORD PTR 64[rsp]
	lea	rdi, 64[rsp]
	mov	r9d, ebp
	mov	r8d, r12d
	mov	ecx, ebx
	and	edx, 3
	call	replicate_for_copy@PLT
	mov	edx, DWORD PTR 144[rsp]
	mov	esi, DWORD PTR 80[rsp]
	lea	rdi, 80[rsp]
	mov	r9d, ebp
	mov	r8d, r12d
	mov	ecx, ebx
	and	edx, 3
	call	replicate_for_copy@PLT
	mov	eax, DWORD PTR 32[rsp]
	mov	edx, DWORD PTR 48[rsp]
	sal	eax, 24
	sal	edx, 16
	or	eax, edx
	mov	edx, DWORD PTR 64[rsp]
	or	eax, DWORD PTR 80[rsp]
	sal	edx, 8
	or	eax, edx
	mov	DWORD PTR 0[r13], eax
.L940:
	add	rsp, 200
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
.L943:
	.cfi_restore_state
	mov	ecx, 16
	mov	eax, edx
	sub	ecx, r8d
	sal	eax, cl
	cwde
	jmp	.L944
	.p2align 4,,10
	.p2align 3
.L987:
	test	r12d, r12d
	jne	.L953
.L951:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	cmp	DWORD PTR 20[rax], 0
	jne	.L965
	mov	eax, DWORD PTR 168[rsp]
	mov	edx, DWORD PTR 172[rsp]
	mov	esi, DWORD PTR 160[rsp]
	mov	ecx, DWORD PTR 164[rsp]
	mov	DWORD PTR 64[rsp], eax
	sal	eax, 16
	mov	DWORD PTR 80[rsp], edx
	or	eax, edx
	cmp	ebp, 2
	mov	DWORD PTR 32[rsp], esi
	mov	DWORD PTR 48[rsp], ecx
	mov	DWORD PTR [r14], eax
	jne	.L963
.L988:
	sal	esi, 16
	or	esi, ecx
	mov	DWORD PTR 0[r13], esi
	jmp	.L940
	.p2align 4,,10
	.p2align 3
.L986:
	mov	ecx, DWORD PTR 88[rcx]
	mov	r15d, r10d
	sar	r15d, cl
	mov	ecx, r15d
	and	ecx, 1
	neg	ecx
	xor	r10d, ecx
	jmp	.L950
	.p2align 4,,10
	.p2align 3
.L985:
	mov	ecx, DWORD PTR 84[r15]
	mov	r15d, eax
	sar	r15d, cl
	and	r15d, 1
	neg	r15d
	xor	eax, r15d
	mov	r15d, esi
	sar	r15d, cl
	and	r15d, 1
	neg	r15d
	xor	esi, r15d
	mov	r15d, edx
	sar	r15d, cl
	and	r15d, 1
	neg	r15d
	xor	edx, r15d
	mov	r15d, r11d
	sar	r15d, cl
	mov	ecx, r15d
	and	ecx, 1
	neg	ecx
	xor	r11d, ecx
	jmp	.L948
	.p2align 4,,10
	.p2align 3
.L968:
	xor	r12d, r12d
	mov	rdi, QWORD PTR tile@GOTPCREL[rip]
	mov	esi, r8d
	jmp	.L942
	.p2align 4,,10
	.p2align 3
.L984:
	movsx	r10d, r10w
	mov	ecx, edx
	sar	r10d, cl
	jmp	.L946
.L965:
	mov	esi, DWORD PTR 176[rsp]
	mov	ecx, DWORD PTR 180[rsp]
	mov	eax, DWORD PTR 184[rsp]
	mov	edx, DWORD PTR 188[rsp]
	mov	DWORD PTR 32[rsp], esi
	mov	DWORD PTR 48[rsp], ecx
	mov	DWORD PTR 64[rsp], eax
	mov	DWORD PTR 80[rsp], edx
	jmp	.L954
	.p2align 4,,10
	.p2align 3
.L955:
	mov	r9d, DWORD PTR 100[rsp]
	mov	esi, DWORD PTR 160[rsp]
	test	r9d, r9d
	mov	DWORD PTR 32[rsp], esi
	jne	.L989
.L957:
	mov	r8d, DWORD PTR 108[rsp]
	mov	ecx, DWORD PTR 164[rsp]
	test	r8d, r8d
	mov	DWORD PTR 48[rsp], ecx
	jne	.L990
.L959:
	mov	edi, DWORD PTR 112[rsp]
	mov	eax, DWORD PTR 168[rsp]
	test	edi, edi
	mov	DWORD PTR 64[rsp], eax
	jne	.L991
.L961:
	mov	edx, DWORD PTR 172[rsp]
	jmp	.L962
	.cfi_endproc
.LFE581:
	.size	fetch_qword_copy, .-fetch_qword_copy
	.p2align 4,,15
	.globl	texture_pipeline_cycle
	.type	texture_pipeline_cycle, @function
texture_pipeline_cycle:
.LFB582:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r10d, ecx
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, rsi
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
	sub	rsp, 120
	.cfi_def_cfa_offset 176
	mov	r13, QWORD PTR other_modes@GOTPCREL[rip]
	test	r9d, r9d
	mov	r15d, DWORD PTR 36[r13]
	mov	eax, DWORD PTR 40[r13]
	je	.L1045
	cmp	DWORD PTR 44[r13], 0
	mov	r15d, eax
	jne	.L1050
	.p2align 4,,10
	.p2align 3
.L1045:
	mov	DWORD PTR 32[rsp], 0
.L1044:
	mov	ebp, r8d
	mov	rbx, QWORD PTR tile@GOTPCREL[rip]
	lea	rax, 0[rbp+rbp*4]
	lea	rax, [rax+rax*4]
	mov	eax, DWORD PTR 48[rbx+rax*4]
	cmp	eax, 10
	jg	.L994
	movsx	edx, dx
	mov	ecx, eax
	sar	edx, cl
.L995:
	lea	rax, 0[rbp+rbp*4]
	mov	ecx, edx
	xor	r11d, r11d
	sar	ecx, 3
	lea	rax, [rax+rax*4]
	lea	rax, [rbx+rax*4]
	cmp	ecx, DWORD PTR 60[rax]
	mov	eax, DWORD PTR 40[rax]
	setge	r11b
	cmp	eax, 10
	jle	.L1071
	mov	ecx, 16
	sub	ecx, eax
	sal	r10d, cl
	movsx	r10d, r10w
.L997:
	lea	rax, 0[rbp+rbp*4]
	mov	ecx, r10d
	xor	r9d, r9d
	sar	ecx, 3
	mov	edi, DWORD PTR 28[r13]
	lea	rax, [rax+rax*4]
	lea	rax, [rbx+rax*4]
	cmp	ecx, DWORD PTR 64[rax]
	mov	esi, DWORD PTR 52[rax]
	lea	ecx, 0[0+rsi*8]
	setge	r9b
	add	rax, 48
	mov	eax, DWORD PTR 8[rax]
	sub	edx, ecx
	sal	eax, 3
	sub	r10d, eax
	test	edi, edi
	je	.L998
	mov	eax, edx
	movsx	rdi, r8d
	and	eax, 31
	mov	DWORD PTR 36[rsp], eax
	mov	eax, r10d
	and	eax, 31
	mov	DWORD PTR 40[rsp], eax
	lea	rax, [rdi+rdi*4]
	lea	rax, [rax+rax*4]
	lea	rcx, 64[rbx+rax*4]
	mov	eax, edx
	sar	eax, 5
	mov	esi, DWORD PTR 12[rcx]
	test	esi, esi
	je	.L1000
	and	edx, 65536
	jne	.L1046
	test	r11d, r11d
	je	.L1000
	mov	eax, DWORD PTR 4[rcx]
	mov	DWORD PTR 36[rsp], 0
	.p2align 4,,10
	.p2align 3
.L1000:
	lea	rdx, [rdi+rdi*4]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, 64[rbx+rdx*4]
	mov	r11d, DWORD PTR 16[rdx]
	test	r11d, r11d
	jne	.L1072
.L1002:
	sar	r10d, 5
	lea	r11d, 1[r10]
.L1003:
	lea	rdx, 0[rbp+rbp*4]
	lea	r9d, 2[rax]
	lea	rcx, [rdx+rdx*4]
	lea	edx, 1[rax]
	cmp	DWORD PTR [rbx+rcx*4], 1
	cmovne	r9d, edx
	lea	rdx, [rdi+rdi*4]
	lea	rdx, [rdx+rdx*4]
	lea	rcx, [rbx+rdx*4]
	movsx	rdx, DWORD PTR 44[rcx]
	test	edx, edx
	je	.L1007
	mov	esi, DWORD PTR 32[rcx]
	test	esi, esi
	jne	.L1073
.L1008:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	edx, DWORD PTR [rcx+rdx*4]
	and	eax, edx
	and	r9d, edx
.L1007:
	lea	rdx, [rdi+rdi*4]
	lea	rdx, [rdx+rdx*4]
	lea	rcx, [rbx+rdx*4]
	movsx	rdx, DWORD PTR 36[rcx]
	test	edx, edx
	je	.L1009
	mov	esi, DWORD PTR 24[rcx]
	test	esi, esi
	jne	.L1074
.L1010:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	edx, DWORD PTR [rcx+rdx*4]
	and	r10d, edx
	and	r11d, edx
.L1009:
	test	r15d, r15d
	je	.L1011
	mov	r15d, DWORD PTR 20[r13]
	lea	rcx, 96[rsp]
	mov	DWORD PTR 16[rsp], r8d
	lea	rdx, 80[rsp]
	lea	rsi, 64[rsp]
	lea	rdi, 48[rsp]
	mov	DWORD PTR 8[rsp], r11d
	mov	DWORD PTR [rsp], r10d
	mov	r8d, eax
	test	r15d, r15d
	je	.L1075
	call	fetch_texel_entlut_quadro@PLT
.L1013:
	lea	rax, 0[rbp+rbp*4]
	lea	rax, [rax+rax*4]
	cmp	DWORD PTR [rbx+rax*4], 1
	je	.L1014
	mov	esi, DWORD PTR 64[rsp]
	mov	ecx, DWORD PTR 80[rsp]
	mov	edx, DWORD PTR 68[rsp]
	mov	eax, DWORD PTR 84[rsp]
.L1015:
	mov	r9d, DWORD PTR 32[r13]
	test	r9d, r9d
	je	.L1016
	cmp	DWORD PTR 36[rsp], 16
	je	.L1076
.L1016:
	mov	r8d, DWORD PTR 32[rsp]
	mov	edi, DWORD PTR 40[rsp]
	add	edi, DWORD PTR 36[rsp]
	test	r8d, r8d
	jne	.L1018
	and	edi, 32
	je	.L1019
	mov	edi, 32
	mov	r9d, DWORD PTR 96[rsp]
	mov	r8d, edi
	sub	edi, DWORD PTR 40[rsp]
	sub	r8d, DWORD PTR 36[rsp]
	sub	ecx, r9d
	sub	esi, r9d
	imul	esi, edi
	imul	ecx, r8d
	lea	ecx, 16[rcx+rsi]
	sar	ecx, 5
	lea	esi, [r9+rcx]
	mov	ecx, DWORD PTR 100[rsp]
	mov	DWORD PTR [r12], esi
	mov	DWORD PTR 32[rsp], esi
	sub	eax, ecx
	sub	edx, ecx
	imul	edx, edi
	imul	eax, r8d
	lea	eax, 16[rax+rdx]
	mov	edx, DWORD PTR 88[rsp]
	sar	eax, 5
	lea	r9d, [rcx+rax]
	mov	ecx, DWORD PTR 104[rsp]
	mov	eax, DWORD PTR 72[rsp]
	mov	DWORD PTR 4[r12], r9d
	mov	DWORD PTR 36[rsp], r9d
	sub	edx, ecx
	sub	eax, ecx
	imul	edx, r8d
	imul	eax, edi
	lea	eax, 16[rdx+rax]
	mov	edx, DWORD PTR 92[rsp]
	sar	eax, 5
	lea	r10d, [rcx+rax]
	mov	ecx, DWORD PTR 108[rsp]
	mov	eax, DWORD PTR 76[rsp]
	mov	DWORD PTR 8[r12], r10d
	mov	DWORD PTR 40[rsp], r10d
	sub	edx, ecx
	sub	eax, ecx
	imul	edx, r8d
	imul	eax, edi
	lea	eax, 16[rdx+rax]
	sar	eax, 5
	add	eax, ecx
	mov	DWORD PTR 12[r12], eax
	mov	DWORD PTR 44[rsp], eax
	jmp	.L1020
	.p2align 4,,10
	.p2align 3
.L998:
	movsx	rdi, r8d
	mov	esi, edx
	lea	rax, [rdi+rdi*4]
	sar	esi, 5
	lea	rax, [rax+rax*4]
	lea	rax, 64[rbx+rax*4]
	mov	ebp, DWORD PTR 12[rax]
	test	ebp, ebp
	je	.L1030
	xor	esi, esi
	test	edx, 65536
	jne	.L1030
	test	r11d, r11d
	jne	.L1031
	mov	esi, edx
	sar	esi, 5
	.p2align 4,,10
	.p2align 3
.L1030:
	lea	rax, [rdi+rdi*4]
	mov	edx, r10d
	sar	edx, 5
	lea	rax, [rax+rax*4]
	lea	rax, 64[rbx+rax*4]
	mov	ecx, DWORD PTR 16[rax]
	test	ecx, ecx
	je	.L1033
	xor	edx, edx
	test	r10d, 65536
	jne	.L1033
	test	r9d, r9d
	jne	.L1034
	mov	edx, r10d
	sar	edx, 5
	.p2align 4,,10
	.p2align 3
.L1033:
	lea	rax, [rdi+rdi*4]
	lea	rax, [rax+rax*4]
	lea	rax, [rbx+rax*4]
	movsx	r9, DWORD PTR 44[rax]
	test	r9d, r9d
	je	.L1035
	mov	ebp, DWORD PTR 32[rax]
	test	ebp, ebp
	je	.L1036
	mov	ecx, DWORD PTR 84[rax]
	mov	eax, esi
	sar	eax, cl
	and	eax, 1
	neg	eax
	xor	esi, eax
.L1036:
	mov	rax, QWORD PTR maskbits_table@GOTPCREL[rip]
	and	esi, DWORD PTR [rax+r9*4]
.L1035:
	lea	rax, [rdi+rdi*4]
	lea	rax, [rax+rax*4]
	lea	rax, [rbx+rax*4]
	movsx	rdi, DWORD PTR 36[rax]
	test	edi, edi
	je	.L1037
	mov	r11d, DWORD PTR 24[rax]
	test	r11d, r11d
	je	.L1038
	mov	ecx, DWORD PTR 88[rax]
	mov	eax, edx
	sar	eax, cl
	and	eax, 1
	neg	eax
	xor	edx, eax
.L1038:
	mov	rax, QWORD PTR maskbits_table@GOTPCREL[rip]
	and	edx, DWORD PTR [rax+rdi*4]
.L1037:
	mov	r10d, DWORD PTR 20[r13]
	lea	rdi, 48[rsp]
	mov	ecx, r8d
	test	r10d, r10d
	je	.L1077
	call	fetch_texel_entlut@PLT
	test	r15d, r15d
	je	.L1041
.L1078:
	mov	r9d, DWORD PTR 32[rsp]
	test	r9d, r9d
	jne	.L1042
	mov	rax, QWORD PTR 48[rsp]
	mov	rdx, QWORD PTR 56[rsp]
	mov	QWORD PTR [r12], rax
	mov	QWORD PTR 8[r12], rdx
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
.L994:
	.cfi_restore_state
	mov	ecx, 16
	sub	ecx, eax
	sal	edx, cl
	movsx	edx, dx
	jmp	.L995
	.p2align 4,,10
	.p2align 3
.L1077:
	call	fetch_texel@PLT
	test	r15d, r15d
	jne	.L1078
.L1041:
	mov	r8d, DWORD PTR 32[rsp]
	test	r8d, r8d
	jne	.L1079
.L1043:
	mov	rsi, QWORD PTR k_YUV_RGB@GOTPCREL[rip]
	mov	ecx, DWORD PTR 52[rsp]
	mov	eax, DWORD PTR 56[rsp]
	mov	edx, DWORD PTR 48[rsp]
	mov	edi, DWORD PTR [rsi]
	sal	ecx, 23
	sar	ecx, 23
	sal	eax, 23
	sal	edx, 23
	sar	eax, 23
	sar	edx, 23
	imul	edi, ecx
	sub	edi, -128
	sar	edi, 8
	add	edi, eax
	mov	DWORD PTR [r12], edi
	mov	r8d, DWORD PTR 4[rsi]
	and	edi, 511
	imul	ecx, DWORD PTR 8[rsi]
	imul	r8d, edx
	lea	ecx, 128[r8+rcx]
	sar	ecx, 8
	add	ecx, eax
	mov	DWORD PTR 4[r12], ecx
	and	ecx, 511
	imul	edx, DWORD PTR 12[rsi]
	mov	DWORD PTR [r12], edi
	mov	DWORD PTR 4[r12], ecx
	sub	edx, -128
	sar	edx, 8
	add	edx, eax
	and	eax, 511
	and	edx, 511
	mov	DWORD PTR 12[r12], eax
	mov	DWORD PTR 8[r12], edx
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
.L1072:
	.cfi_restore_state
	test	r10d, 65536
	jne	.L1047
	test	r9d, r9d
	je	.L1002
	mov	r10d, DWORD PTR 8[rdx]
	mov	DWORD PTR 40[rsp], 0
	lea	r11d, 1[r10]
	jmp	.L1003
	.p2align 4,,10
	.p2align 3
.L1071:
	movsx	r10d, r10w
	mov	ecx, eax
	sar	r10d, cl
	jmp	.L997
	.p2align 4,,10
	.p2align 3
.L1011:
	mov	r15d, DWORD PTR 20[r13]
	lea	rdi, 48[rsp]
	mov	ecx, r8d
	mov	edx, r10d
	mov	esi, eax
	test	r15d, r15d
	jne	.L1023
	call	fetch_texel@PLT
.L1024:
	mov	r13d, DWORD PTR 32[rsp]
	test	r13d, r13d
	je	.L1025
	mov	rax, QWORD PTR [r14]
	mov	rdx, QWORD PTR 8[r14]
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 56[rsp], rdx
.L1025:
	lea	rax, 0[rbp+rbp*4]
	lea	rax, [rax+rax*4]
	cmp	DWORD PTR [rbx+rax*4], 1
	je	.L1026
	mov	esi, DWORD PTR 52[rsp]
	mov	ecx, DWORD PTR 48[rsp]
.L1027:
	mov	rdx, QWORD PTR k_YUV_RGB@GOTPCREL[rip]
	mov	eax, DWORD PTR 56[rsp]
	mov	edi, DWORD PTR [rdx]
	mov	DWORD PTR 44[rsp], eax
	imul	edi, esi
	sub	edi, -128
	sar	edi, 8
	add	edi, eax
	mov	DWORD PTR [r12], edi
	mov	r8d, DWORD PTR 4[rdx]
	imul	esi, DWORD PTR 8[rdx]
	mov	DWORD PTR 32[rsp], edi
	imul	r8d, ecx
	lea	esi, 128[r8+rsi]
	sar	esi, 8
	add	esi, eax
	mov	DWORD PTR 4[r12], esi
	mov	DWORD PTR 36[rsp], esi
	imul	ecx, DWORD PTR 8[rdx]
	mov	DWORD PTR 12[r12], eax
	sub	ecx, -128
	sar	ecx, 8
	add	ecx, eax
	mov	DWORD PTR 8[r12], ecx
	mov	DWORD PTR 40[rsp], ecx
.L1020:
	movd	xmm1, DWORD PTR 40[rsp]
	movd	xmm2, DWORD PTR 44[rsp]
	movd	xmm0, DWORD PTR 32[rsp]
	movd	xmm3, DWORD PTR 36[rsp]
	punpckldq	xmm1, xmm2
	punpckldq	xmm0, xmm3
	punpcklqdq	xmm0, xmm1
	pand	xmm0, XMMWORD PTR .LC0[rip]
	movdqu	XMMWORD PTR [r12], xmm0
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
.L1074:
	.cfi_restore_state
	mov	ecx, DWORD PTR 88[rcx]
	mov	esi, r10d
	sar	esi, cl
	and	esi, 1
	neg	esi
	xor	r10d, esi
	mov	esi, r11d
	sar	esi, cl
	mov	ecx, esi
	and	ecx, 1
	neg	ecx
	xor	r11d, ecx
	jmp	.L1010
	.p2align 4,,10
	.p2align 3
.L1042:
	mov	eax, DWORD PTR 8[r14]
	mov	DWORD PTR 12[r12], eax
	mov	DWORD PTR 8[r12], eax
	mov	DWORD PTR 4[r12], eax
	mov	DWORD PTR [r12], eax
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
.L1046:
	.cfi_restore_state
	xor	eax, eax
	mov	DWORD PTR 36[rsp], 0
	jmp	.L1000
	.p2align 4,,10
	.p2align 3
.L1079:
	mov	rax, QWORD PTR [r14]
	mov	rdx, QWORD PTR 8[r14]
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 56[rsp], rdx
	jmp	.L1043
	.p2align 4,,10
	.p2align 3
.L1075:
	call	fetch_texel_quadro@PLT
	jmp	.L1013
	.p2align 4,,10
	.p2align 3
.L1023:
	call	fetch_texel_entlut@PLT
	.p2align 4,,8
	jmp	.L1024
	.p2align 4,,10
	.p2align 3
.L1073:
	mov	ecx, DWORD PTR 84[rcx]
	mov	esi, eax
	sar	esi, cl
	and	esi, 1
	neg	esi
	xor	eax, esi
	mov	esi, r9d
	sar	esi, cl
	mov	ecx, esi
	and	ecx, 1
	neg	ecx
	xor	r9d, ecx
	jmp	.L1008
	.p2align 4,,10
	.p2align 3
.L1047:
	mov	r11d, 1
	xor	r10d, r10d
	mov	DWORD PTR 40[rsp], 0
	jmp	.L1003
	.p2align 4,,10
	.p2align 3
.L1018:
	and	edi, 32
	mov	edi, DWORD PTR 8[r14]
	je	.L1021
	mov	r9d, DWORD PTR 96[rsp]
	mov	r8d, DWORD PTR 4[r14]
	sub	ecx, r9d
	sub	esi, r9d
	mov	r9d, DWORD PTR 100[rsp]
	imul	ecx, DWORD PTR [r14]
	imul	esi, r8d
	sub	edx, r9d
	sub	eax, r9d
	imul	r8d, edx
	mov	edx, DWORD PTR 88[rsp]
	lea	ecx, 128[rcx+rsi]
	sar	ecx, 8
	lea	esi, [rdi+rcx]
	mov	DWORD PTR [r12], esi
	mov	ecx, DWORD PTR [r14]
	imul	eax, ecx
	lea	eax, 128[rax+r8]
	sar	eax, 8
	lea	r8d, [rdi+rax]
	mov	eax, DWORD PTR 104[rsp]
	mov	DWORD PTR 4[r12], r8d
	mov	r9d, DWORD PTR 4[r14]
	sub	edx, eax
	imul	edx, ecx
	mov	r10d, edx
	mov	edx, DWORD PTR 72[rsp]
	sub	edx, eax
	mov	eax, edx
	imul	eax, r9d
	lea	edx, 128[r10+rax]
	mov	r10d, DWORD PTR 108[rsp]
	mov	eax, DWORD PTR 76[rsp]
	sar	edx, 8
	add	edi, edx
	mov	edx, DWORD PTR 92[rsp]
	mov	DWORD PTR 8[r12], edi
	sub	edx, r10d
	imul	edx, ecx
.L1070:
	sub	eax, r10d
	mov	DWORD PTR 40[rsp], edi
	mov	DWORD PTR 36[rsp], r8d
	imul	eax, r9d
	mov	DWORD PTR 32[rsp], esi
	lea	eax, 128[rdx+rax]
	sar	eax, 8
	add	eax, DWORD PTR 8[r14]
	mov	DWORD PTR 12[r12], eax
	mov	DWORD PTR 44[rsp], eax
	jmp	.L1020
	.p2align 4,,10
	.p2align 3
.L1034:
	mov	edx, DWORD PTR 8[rax]
	jmp	.L1033
	.p2align 4,,10
	.p2align 3
.L1014:
	mov	eax, DWORD PTR 48[rsp]
	mov	edi, DWORD PTR 96[rsp]
	mov	esi, DWORD PTR 64[rsp]
	mov	edx, DWORD PTR 68[rsp]
	mov	ecx, DWORD PTR 80[rsp]
	sal	eax, 23
	sal	edi, 23
	sar	eax, 23
	sar	edi, 23
	sal	esi, 23
	mov	DWORD PTR 48[rsp], eax
	mov	eax, DWORD PTR 52[rsp]
	sal	edx, 23
	mov	DWORD PTR 96[rsp], edi
	mov	edi, DWORD PTR 100[rsp]
	sal	ecx, 23
	sar	esi, 23
	sar	edx, 23
	sar	ecx, 23
	sal	eax, 23
	mov	DWORD PTR 64[rsp], esi
	mov	DWORD PTR 68[rsp], edx
	sar	eax, 23
	sal	edi, 23
	mov	DWORD PTR 80[rsp], ecx
	mov	DWORD PTR 52[rsp], eax
	mov	eax, DWORD PTR 84[rsp]
	sar	edi, 23
	mov	DWORD PTR 100[rsp], edi
	sal	eax, 23
	sar	eax, 23
	mov	DWORD PTR 84[rsp], eax
	jmp	.L1015
	.p2align 4,,10
	.p2align 3
.L1026:
	mov	ecx, DWORD PTR 48[rsp]
	mov	esi, DWORD PTR 52[rsp]
	sal	ecx, 23
	sal	esi, 23
	sar	ecx, 23
	sar	esi, 23
	jmp	.L1027
	.p2align 4,,10
	.p2align 3
.L1031:
	mov	esi, DWORD PTR 4[rax]
	jmp	.L1030
	.p2align 4,,10
	.p2align 3
.L1019:
	mov	edi, DWORD PTR 48[rsp]
	mov	r15d, DWORD PTR 36[rsp]
	mov	ebx, DWORD PTR 40[rsp]
	sub	esi, edi
	sub	ecx, edi
	imul	esi, r15d
	imul	ecx, ebx
	lea	ecx, 16[rsi+rcx]
	sar	ecx, 5
	lea	esi, [rdi+rcx]
	mov	ecx, DWORD PTR 52[rsp]
	mov	DWORD PTR [r12], esi
	mov	DWORD PTR 32[rsp], esi
	sub	edx, ecx
	sub	eax, ecx
	imul	edx, r15d
	imul	eax, ebx
	lea	eax, 16[rdx+rax]
	mov	edx, DWORD PTR 72[rsp]
	sar	eax, 5
	lea	edi, [rcx+rax]
	mov	ecx, DWORD PTR 56[rsp]
	mov	eax, DWORD PTR 88[rsp]
	mov	DWORD PTR 4[r12], edi
	mov	DWORD PTR 36[rsp], edi
	sub	edx, ecx
	sub	eax, ecx
	imul	edx, r15d
	imul	eax, ebx
	lea	eax, 16[rdx+rax]
	mov	edx, DWORD PTR 76[rsp]
	sar	eax, 5
	lea	r8d, [rcx+rax]
	mov	ecx, DWORD PTR 60[rsp]
	mov	eax, DWORD PTR 92[rsp]
	mov	DWORD PTR 8[r12], r8d
	mov	DWORD PTR 40[rsp], r8d
	sub	edx, ecx
	sub	eax, ecx
	imul	edx, r15d
	imul	eax, ebx
	lea	eax, 16[rdx+rax]
	sar	eax, 5
	add	eax, ecx
	mov	DWORD PTR 12[r12], eax
	mov	DWORD PTR 44[rsp], eax
	jmp	.L1020
	.p2align 4,,10
	.p2align 3
.L1021:
	mov	r9d, DWORD PTR 48[rsp]
	mov	r8d, DWORD PTR 4[r14]
	sub	esi, r9d
	sub	ecx, r9d
	mov	r9d, DWORD PTR 52[rsp]
	imul	esi, DWORD PTR [r14]
	imul	ecx, r8d
	sub	eax, r9d
	sub	edx, r9d
	imul	r8d, eax
	lea	ecx, 128[rsi+rcx]
	sar	ecx, 8
	lea	esi, [rdi+rcx]
	mov	DWORD PTR [r12], esi
	mov	ecx, DWORD PTR [r14]
	imul	edx, ecx
	lea	eax, 128[rdx+r8]
	mov	edx, DWORD PTR 72[rsp]
	sar	eax, 8
	lea	r8d, [rdi+rax]
	mov	eax, DWORD PTR 56[rsp]
	mov	DWORD PTR 4[r12], r8d
	mov	r9d, DWORD PTR 4[r14]
	sub	edx, eax
	imul	edx, ecx
	mov	r10d, edx
	mov	edx, DWORD PTR 88[rsp]
	sub	edx, eax
	mov	eax, edx
	imul	eax, r9d
	lea	edx, 128[r10+rax]
	mov	r10d, DWORD PTR 60[rsp]
	mov	eax, DWORD PTR 92[rsp]
	sar	edx, 8
	add	edi, edx
	mov	edx, DWORD PTR 76[rsp]
	mov	DWORD PTR 8[r12], edi
	sub	edx, r10d
	imul	edx, ecx
	jmp	.L1070
	.p2align 4,,10
	.p2align 3
.L1076:
	cmp	DWORD PTR 40[rsp], 16
	jne	.L1016
	mov	r10d, DWORD PTR 48[rsp]
	mov	r9d, DWORD PTR 52[rsp]
	mov	r8d, DWORD PTR 56[rsp]
	mov	edi, DWORD PTR 60[rsp]
	mov	r15d, DWORD PTR 32[rsp]
	mov	r13d, r10d
	mov	ebp, r9d
	mov	ebx, r8d
	mov	r11d, edi
	not	r13d
	test	r15d, r15d
	not	ebp
	not	ebx
	not	r11d
	jne	.L1022
	add	ebp, DWORD PTR 100[rsp]
	sub	edx, r9d
	sub	eax, r9d
	add	eax, edx
	add	ebx, DWORD PTR 104[rsp]
	add	r13d, DWORD PTR 96[rsp]
	sub	esi, r10d
	sub	ecx, r10d
	add	r11d, DWORD PTR 108[rsp]
	add	ecx, esi
	add	eax, ebp
	sal	eax, 6
	add	ecx, r13d
	add	eax, 192
	sal	ecx, 6
	sar	eax, 8
	add	ecx, 192
	add	r9d, eax
	mov	eax, DWORD PTR 72[rsp]
	sar	ecx, 8
	add	r10d, ecx
	mov	DWORD PTR 4[r12], r9d
	mov	DWORD PTR 36[rsp], r9d
	mov	DWORD PTR [r12], r10d
	mov	DWORD PTR 32[rsp], r10d
	sub	eax, r8d
	sub	eax, r8d
	add	eax, DWORD PTR 88[rsp]
	add	eax, ebx
	sal	eax, 6
	add	eax, 192
	sar	eax, 8
	add	r8d, eax
	mov	eax, DWORD PTR 76[rsp]
	mov	DWORD PTR 8[r12], r8d
	mov	DWORD PTR 40[rsp], r8d
	sub	eax, edi
	sub	eax, edi
	add	eax, DWORD PTR 92[rsp]
	add	eax, r11d
	sal	eax, 6
	add	eax, 192
	sar	eax, 8
	add	eax, edi
	mov	DWORD PTR 12[r12], eax
	mov	DWORD PTR 44[rsp], eax
	jmp	.L1020
.L1022:
	mov	r15d, DWORD PTR 8[r14]
	sub	esi, r10d
	sub	ecx, r10d
	imul	esi, DWORD PTR [r14]
	add	r13d, DWORD PTR 96[rsp]
	sub	edx, r9d
	sub	eax, r9d
	mov	DWORD PTR 32[rsp], r15d
	mov	r15d, DWORD PTR 4[r14]
	mov	r10d, DWORD PTR 32[rsp]
	add	ebp, DWORD PTR 100[rsp]
	add	ebx, DWORD PTR 104[rsp]
	add	r11d, DWORD PTR 108[rsp]
	imul	ecx, r15d
	sal	r13d, 6
	imul	eax, r15d
	mov	r15d, r10d
	sal	ebp, 6
	add	esi, ecx
	sal	ebx, 6
	sal	r11d, 6
	lea	ecx, 192[rsi+r13]
	sar	ecx, 8
	add	ecx, r10d
	mov	DWORD PTR [r12], ecx
	mov	esi, DWORD PTR [r14]
	mov	DWORD PTR 32[rsp], ecx
	imul	edx, esi
	add	eax, edx
	lea	edx, 192[rax+rbp]
	mov	eax, DWORD PTR 72[rsp]
	sar	edx, 8
	sub	eax, r8d
	add	edx, r10d
	imul	eax, esi
	mov	DWORD PTR 4[r12], edx
	mov	r9d, DWORD PTR 4[r14]
	mov	DWORD PTR 36[rsp], edx
	mov	r10d, eax
	mov	eax, DWORD PTR 88[rsp]
	sub	eax, r8d
	imul	eax, r9d
	add	eax, r10d
	lea	eax, 192[rax+rbx]
	sar	eax, 8
	add	r15d, eax
	mov	eax, DWORD PTR 76[rsp]
	mov	DWORD PTR 8[r12], r15d
	mov	DWORD PTR 40[rsp], r15d
	sub	eax, edi
	imul	esi, eax
	mov	eax, DWORD PTR 92[rsp]
	sub	eax, edi
	imul	r9d, eax
	lea	eax, [rsi+r9]
	lea	eax, 192[rax+r11]
	sar	eax, 8
	add	eax, DWORD PTR 8[r14]
	mov	DWORD PTR 12[r12], eax
	mov	DWORD PTR 44[rsp], eax
	jmp	.L1020
.L1050:
	mov	DWORD PTR 32[rsp], 1
	jmp	.L1044
	.cfi_endproc
.LFE582:
	.size	texture_pipeline_cycle, .-texture_pipeline_cycle
	.p2align 4,,15
	.globl	tc_pipeline_copy
	.type	tc_pipeline_copy, @function
tc_pipeline_copy:
.LFB583:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r11, QWORD PTR tile@GOTPCREL[rip]
	mov	eax, DWORD PTR [rdi]
	mov	r10d, DWORD PTR [r8]
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	mov	r13, rcx
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	mov	ebx, r9d
	lea	rbp, [rbx+rbx*4]
	lea	rcx, 0[rbp+rbp*4]
	mov	ebp, DWORD PTR 48[r11+rcx*4]
	cmp	ebp, 10
	jg	.L1081
	cwde
	mov	ecx, ebp
	sar	eax, cl
.L1082:
	lea	rbx, [rbx+rbx*4]
	lea	rcx, [rbx+rbx*4]
	mov	ebx, DWORD PTR 40[r11+rcx*4]
	cmp	ebx, 10
	jle	.L1096
	mov	ecx, 16
	sub	ecx, ebx
	sal	r10d, cl
	movsx	r10d, r10w
.L1084:
	movsx	r9, r9d
	lea	rcx, [r9+r9*4]
	lea	rcx, [rcx+rcx*4]
	lea	rcx, [r11+rcx*4]
	mov	r15d, DWORD PTR 52[rcx]
	mov	ebx, DWORD PTR 56[rcx]
	movsx	r14, DWORD PTR 44[rcx]
	lea	ebp, 0[0+r15*8]
	sal	ebx, 3
	sub	r10d, ebx
	sub	eax, ebp
	sar	r10d, 5
	sar	eax, 5
	test	r14d, r14d
	lea	r12d, 1[rax]
	lea	ebp, 2[rax]
	lea	ebx, 3[rax]
	je	.L1085
	mov	r15d, DWORD PTR 32[rcx]
	test	r15d, r15d
	jne	.L1097
.L1086:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx+r14*4]
	and	eax, ecx
	and	r12d, ecx
	and	ebp, ecx
	and	ebx, ecx
.L1085:
	lea	rcx, [r9+r9*4]
	lea	rcx, [rcx+rcx*4]
	lea	rcx, [r11+rcx*4]
	movsx	r9, DWORD PTR 36[rcx]
	test	r9d, r9d
	je	.L1087
	mov	r11d, DWORD PTR 24[rcx]
	test	r11d, r11d
	jne	.L1098
.L1088:
	mov	rcx, QWORD PTR maskbits_table@GOTPCREL[rip]
	and	r10d, DWORD PTR [rcx+r9*4]
.L1087:
	mov	DWORD PTR [rdi], eax
	mov	DWORD PTR [rsi], r12d
	mov	DWORD PTR [rdx], ebp
	mov	DWORD PTR 0[r13], ebx
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
	mov	DWORD PTR [r8], r10d
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1081:
	.cfi_restore_state
	mov	ecx, 16
	sub	ecx, ebp
	sal	eax, cl
	cwde
	jmp	.L1082
	.p2align 4,,10
	.p2align 3
.L1098:
	mov	ecx, DWORD PTR 88[rcx]
	mov	r14d, r10d
	sar	r14d, cl
	mov	ecx, r14d
	and	ecx, 1
	neg	ecx
	xor	r10d, ecx
	jmp	.L1088
	.p2align 4,,10
	.p2align 3
.L1097:
	mov	ecx, DWORD PTR 84[rcx]
	mov	r15d, eax
	sar	r15d, cl
	and	r15d, 1
	neg	r15d
	xor	eax, r15d
	mov	r15d, r12d
	sar	r15d, cl
	and	r15d, 1
	neg	r15d
	xor	r12d, r15d
	mov	r15d, ebp
	sar	r15d, cl
	and	r15d, 1
	neg	r15d
	xor	ebp, r15d
	mov	r15d, ebx
	sar	r15d, cl
	mov	ecx, r15d
	and	ecx, 1
	neg	ecx
	xor	ebx, ecx
	jmp	.L1086
	.p2align 4,,10
	.p2align 3
.L1096:
	movsx	r10d, r10w
	mov	ecx, ebx
	sar	r10d, cl
	jmp	.L1084
	.cfi_endproc
.LFE583:
	.size	tc_pipeline_copy, .-tc_pipeline_copy
	.p2align 4,,15
	.globl	tc_pipeline_load
	.type	tc_pipeline_load, @function
tc_pipeline_load:
.LFB584:
	.cfi_startproc
	movsx	rdx, edx
	mov	r9, QWORD PTR tile@GOTPCREL[rip]
	movsx	r8d, WORD PTR [rdi]
	lea	rdx, [rdx+rdx*4]
	movsx	eax, WORD PTR [rsi]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [r9+rdx*4]
	mov	r10d, DWORD PTR 52[rdx]
	add	rdx, 48
	mov	edx, DWORD PTR 8[rdx]
	lea	r9d, 0[0+r10*8]
	sal	edx, 3
	sub	r8d, r9d
	sub	eax, edx
	mov	r9d, r8d
	mov	edx, eax
	sar	r9d, 3
	sar	edx, 3
	test	ecx, ecx
	jne	.L1101
	sar	r8d, 5
	sar	eax, 5
	mov	r9d, r8d
	mov	edx, eax
.L1101:
	mov	DWORD PTR [rdi], r9d
	mov	DWORD PTR [rsi], edx
	ret
	.cfi_endproc
.LFE584:
	.size	tc_pipeline_load, .-tc_pipeline_load
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"render_spans_fill:  RDP crashed"
	.align 8
.LC2:
	.string	"Exact fill abort timing not implemented."
	.text
	.p2align 4,,15
	.globl	render_spans_fill
	.type	render_spans_fill, @function
render_spans_fill:
.LFB592:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14d, esi
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	mov	ebp, edi
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rcx, QWORD PTR fb_size@GOTPCREL[rip]
	mov	rbx, QWORD PTR fbfill_ptr@GOTPCREL[rip]
	mov	r9d, DWORD PTR 116[rax]
	mov	r10d, DWORD PTR 124[rax]
	mov	edi, DWORD PTR 120[rax]
	mov	r8d, DWORD PTR 132[rax]
	mov	eax, DWORD PTR [rcx]
	mov	rcx, QWORD PTR fbfill_func@GOTPCREL[rip]
	movsx	rsi, eax
	test	eax, eax
	mov	rcx, QWORD PTR [rcx+rsi*8]
	mov	QWORD PTR [rbx], rcx
	je	.L1141
	mov	eax, r8d
	and	edx, 1
	or	r10d, r9d
	not	eax
	mov	r12d, edx
	mov	r13d, r10d
	and	eax, edi
	neg	r12d
	or	eax, r10d
	je	.L1105
	cmp	r14d, ebp
	jl	.L1102
	mov	rax, QWORD PTR span@GOTPCREL[rip]
	mov	rsi, rax
	mov	QWORD PTR 8[rsp], rax
	movsx	rax, ebp
	lea	rcx, [rax+rax*2]
	sal	rcx, 5
	add	rsi, rcx
	mov	ecx, DWORD PTR 4[rsi]
	sub	ecx, DWORD PTR [rsi]
	xor	ecx, r12d
	add	ecx, edx
	js	.L1142
	mov	r14d, ebp
.L1108:
	mov	r15, QWORD PTR onetimewarnings@GOTPCREL[rip]
	mov	eax, DWORD PTR 12[r15]
	test	eax, eax
	je	.L1143
.L1111:
	mov	rax, QWORD PTR rdp_pipeline_crashed@GOTPCREL[rip]
	test	r13d, r13d
	mov	DWORD PTR 12[r15], 1
	mov	DWORD PTR [rax], 1
	jne	.L1144
.L1105:
	test	r12d, r12d
	jne	.L1145
	cmp	r14d, ebp
	jl	.L1102
	mov	rax, QWORD PTR span@GOTPCREL[rip]
	mov	QWORD PTR 8[rsp], rax
	.p2align 4,,10
	.p2align 3
.L1140:
	movsx	rax, ebp
.L1119:
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR 8[rsp]
	mov	r11d, DWORD PTR 12[rax]
	mov	edx, DWORD PTR [rax]
	mov	r13d, DWORD PTR 4[rax]
	test	r11d, r11d
	je	.L1117
	mov	rax, QWORD PTR fb_width@GOTPCREL[rip]
	mov	r12d, DWORD PTR [rax]
	imul	r12d, ebp
	add	r12d, r13d
	sub	r13d, edx
	js	.L1117
	xor	r15d, r15d
	.p2align 4,,10
	.p2align 3
.L1118:
	mov	edi, r12d
	sub	edi, r15d
	add	r15d, 1
	call	[QWORD PTR [rbx]]
	cmp	r13d, r15d
	jge	.L1118
.L1117:
	add	ebp, 1
	cmp	r14d, ebp
	jge	.L1140
.L1102:
	add	rsp, 24
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
.L1145:
	.cfi_restore_state
	cmp	r14d, ebp
	jl	.L1102
	mov	rax, QWORD PTR span@GOTPCREL[rip]
	mov	QWORD PTR 8[rsp], rax
	movsx	rax, ebp
	.p2align 4,,10
	.p2align 3
.L1124:
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR 8[rsp]
	mov	r10d, DWORD PTR 12[rax]
	mov	r13d, DWORD PTR [rax]
	mov	edx, DWORD PTR 4[rax]
	test	r10d, r10d
	je	.L1122
	mov	rax, QWORD PTR fb_width@GOTPCREL[rip]
	mov	r12d, DWORD PTR [rax]
	imul	r12d, ebp
	add	r12d, edx
	sub	r13d, edx
	js	.L1122
	mov	r15d, r12d
	.p2align 4,,10
	.p2align 3
.L1123:
	mov	edi, r15d
	add	r15d, 1
	call	[QWORD PTR [rbx]]
	mov	edx, r15d
	sub	edx, r12d
	cmp	r13d, edx
	jge	.L1123
.L1122:
	add	ebp, 1
	cmp	ebp, r14d
	jg	.L1102
	movsx	rax, ebp
	jmp	.L1124
.L1141:
	mov	rax, QWORD PTR rdp_pipeline_crashed@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
	add	rsp, 24
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
.L1144:
	.cfi_restore_state
	lea	rdi, .LC2[rip]
	call	DisplayError@PLT
	jmp	.L1105
.L1143:
	lea	rdi, .LC1[rip]
	call	DisplayError@PLT
	jmp	.L1111
.L1142:
	mov	ecx, ebp
.L1112:
	add	ecx, 1
	cmp	r14d, ecx
	jl	.L1146
	movsx	rsi, ecx
	mov	rdi, QWORD PTR 8[rsp]
	lea	rsi, [rsi+rsi*2]
	sal	rsi, 5
	add	rdi, rsi
	mov	esi, DWORD PTR 4[rdi]
	sub	esi, DWORD PTR [rdi]
	xor	esi, r12d
	add	esi, edx
	js	.L1112
	mov	r14d, ecx
	jmp	.L1108
.L1146:
	test	r12d, r12d
	je	.L1119
	.p2align 4,,5
	jmp	.L1124
	.cfi_endproc
.LFE592:
	.size	render_spans_fill, .-render_spans_fill
	.p2align 4,,15
	.globl	render_spans_copy
	.type	render_spans_copy, @function
render_spans_copy:
.LFB593:
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
	sub	rsp, 280
	.cfi_def_cfa_offset 336
	mov	rax, QWORD PTR fb_size@GOTPCREL[rip]
	mov	DWORD PTR 120[rsp], edi
	mov	DWORD PTR 140[rsp], esi
	mov	DWORD PTR 124[rsp], edx
	mov	DWORD PTR 36[rsp], ecx
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 144[rsp], 0
	mov	DWORD PTR 160[rsp], 0
	mov	DWORD PTR 176[rsp], 0
	mov	DWORD PTR 192[rsp], 0
	mov	DWORD PTR 32[rsp], 8
	test	eax, eax
	je	.L1148
	mov	DWORD PTR 32[rsp], 16
	mov	ecx, eax
	sar	DWORD PTR 32[rsp], cl
.L1148:
	cmp	DWORD PTR 36[rsp], 1
	sbb	ebx, ebx
	mov	DWORD PTR 52[rsp], ebx
	and	DWORD PTR 52[rsp], -16
	add	DWORD PTR 52[rsp], 8
	test	eax, eax
	je	.L1206
	lea	ecx, -1[rax]
	mov	DWORD PTR 48[rsp], 1
	sal	DWORD PTR 48[rsp], cl
	cmp	eax, 3
	je	.L1246
.L1150:
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	mov	edi, DWORD PTR 36[rsp]
	mov	ebx, DWORD PTR [rax]
	test	edi, edi
	mov	DWORD PTR 12[rsp], ebx
	je	.L1152
	mov	ebx, DWORD PTR 4[rax]
	mov	eax, DWORD PTR 8[rax]
	mov	r15d, 1
	mov	DWORD PTR 16[rsp], ebx
	mov	DWORD PTR 20[rsp], eax
.L1153:
	mov	eax, DWORD PTR 140[rsp]
	cmp	DWORD PTR 120[rsp], eax
	jg	.L1147
	mov	eax, DWORD PTR 20[rsp]
	add	eax, eax
	mov	DWORD PTR 128[rsp], eax
	mov	eax, DWORD PTR 12[rsp]
	add	eax, eax
	mov	DWORD PTR 132[rsp], eax
	mov	eax, DWORD PTR 16[rsp]
	add	eax, eax
	mov	DWORD PTR 136[rsp], eax
	mov	eax, DWORD PTR 124[rsp]
	mov	DWORD PTR 24[rsp], eax
	lea	rax, 160[rsp]
	mov	QWORD PTR 56[rsp], rax
	lea	rax, 144[rsp]
	mov	QWORD PTR 64[rsp], rax
	lea	rax, 192[rsp]
	mov	QWORD PTR 72[rsp], rax
	lea	rax, 176[rsp]
	mov	QWORD PTR 80[rsp], rax
	.p2align 4,,10
	.p2align 3
.L1202:
	movsx	rdx, DWORD PTR 120[rsp]
	lea	rcx, [rdx+rdx*2]
	sal	rcx, 5
	add	rcx, QWORD PTR span@GOTPCREL[rip]
	mov	esi, DWORD PTR 12[rcx]
	test	esi, esi
	je	.L1155
	mov	esi, DWORD PTR 4[rcx]
	mov	r12d, DWORD PTR 32[rcx]
	mov	ebp, DWORD PTR 36[rcx]
	mov	r13d, DWORD PTR 40[rcx]
	mov	edx, DWORD PTR [rcx]
	mov	rcx, QWORD PTR fb_width@GOTPCREL[rip]
	mov	rax, QWORD PTR fb_size@GOTPCREL[rip]
	mov	edi, DWORD PTR 120[rsp]
	imul	edi, DWORD PTR [rcx]
	mov	ecx, DWORD PTR [rax]
	test	ecx, ecx
	lea	ebx, [rdi+rsi]
	je	.L1156
	mov	r8, QWORD PTR fb_address@GOTPCREL[rip]
	sal	ebx, cl
	add	edi, edx
	sar	ebx
	sal	edi, cl
	sar	edi
	mov	r8d, DWORD PTR [r8]
	add	ebx, r8d
.L1157:
	lea	eax, [r8+rdi]
	and	ebx, 16777215
	mov	DWORD PTR 28[rsp], eax
	mov	eax, edx
	and	DWORD PTR 28[rsp], 16777215
	sub	eax, esi
	sub	esi, edx
	mov	edi, eax
	mov	eax, DWORD PTR 36[rsp]
	test	eax, eax
	cmovne	esi, edi
	test	esi, esi
	mov	DWORD PTR 40[rsp], esi
	js	.L1155
	neg	eax
	add	r13d, DWORD PTR 20[rsp]
	add	r12d, DWORD PTR 12[rsp]
	mov	DWORD PTR 44[rsp], eax
	lea	rax, 224[rsp]
	add	ebp, DWORD PTR 16[rsp]
	mov	r14d, DWORD PTR 32[rsp]
	mov	QWORD PTR 88[rsp], rax
	lea	rax, 208[rsp]
	mov	QWORD PTR 96[rsp], rax
	lea	rax, 256[rsp]
	mov	QWORD PTR 104[rsp], rax
	lea	rax, 240[rsp]
	mov	QWORD PTR 112[rsp], rax
	.p2align 4,,10
	.p2align 3
.L1200:
	mov	edx, r13d
	mov	esi, ebp
	sub	edx, DWORD PTR 20[rsp]
	sub	esi, DWORD PTR 16[rsp]
	mov	edi, r12d
	sub	edi, DWORD PTR 12[rsp]
	mov	r8, QWORD PTR 56[rsp]
	mov	rcx, QWORD PTR 64[rsp]
	sar	edx, 16
	sar	esi, 16
	sar	edi, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	edx, DWORD PTR 144[rsp]
	mov	eax, DWORD PTR 160[rsp]
	test	edx, 262144
	jne	.L1160
	test	edx, 131072
	jne	.L1161
	mov	ecx, edx
	and	ecx, 98304
	cmp	ecx, 32768
	je	.L1160
	cmp	ecx, 65536
	je	.L1161
	and	edx, 65535
	mov	DWORD PTR 144[rsp], edx
.L1162:
	test	eax, 262144
	jne	.L1163
.L1251:
	test	eax, 131072
	jne	.L1164
	mov	edx, eax
	and	edx, 98304
	cmp	edx, 32768
	je	.L1163
	cmp	edx, 65536
	je	.L1164
	and	eax, 65535
	mov	DWORD PTR 160[rsp], eax
.L1165:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	ecx, DWORD PTR 16[rax]
	test	ecx, ecx
	jne	.L1247
.L1174:
	mov	r8d, DWORD PTR 24[rsp]
	mov	edx, DWORD PTR 144[rsp]
	mov	ecx, DWORD PTR 160[rsp]
	mov	rsi, QWORD PTR 72[rsp]
	mov	rdi, QWORD PTR 80[rsp]
	call	fetch_qword_copy@PLT
	mov	rax, QWORD PTR fb_size@GOTPCREL[rip]
	xor	r8d, r8d
	mov	eax, DWORD PTR [rax]
	lea	edx, -1[rax]
	cmp	edx, 1
	jbe	.L1248
.L1175:
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	esi, 255
	mov	edx, DWORD PTR 140[rdi]
	test	edx, edx
	je	.L1176
	cmp	eax, 2
	je	.L1249
	xor	esi, esi
	cmp	eax, 1
	je	.L1250
.L1176:
	mov	eax, ebx
	sub	eax, DWORD PTR 28[rsp]
	mov	edi, DWORD PTR 48[rsp]
	xor	eax, DWORD PTR 44[rsp]
	add	eax, DWORD PTR 36[rsp]
	lea	edx, [rdi+rax]
	mov	eax, 8
	cmp	edx, 8
	cmovle	eax, edx
	test	eax, eax
	jle	.L1198
	mov	edi, 7
	mov	edx, ebx
	sub	edi, eax
	mov	eax, 7
	.p2align 4,,10
	.p2align 3
.L1199:
	bt	esi, eax
	jnc	.L1195
	mov	rcx, QWORD PTR plim@GOTPCREL[rip]
	cmp	DWORD PTR [rcx], edx
	jb	.L1195
	mov	r10, QWORD PTR rdram_8@GOTPCREL[rip]
	lea	ecx, 0[0+rax*8]
	mov	r11, r8
	mov	r9d, edx
	shr	r11, cl
	xor	r9d, 3
	test	dl, 1
	mov	r10, QWORD PTR [r10]
	mov	rcx, r11
	mov	BYTE PTR [r10+r9], r11b
	je	.L1195
	and	ecx, 1
	mov	r10, QWORD PTR hidden_bits@GOTPCREL[rip]
	mov	r9d, edx
	neg	ecx
	shr	r9d
	and	ecx, 3
	mov	BYTE PTR [r10+r9], cl
	.p2align 4,,10
	.p2align 3
.L1195:
	sub	eax, 1
	add	edx, r15d
	cmp	eax, edi
	jne	.L1199
.L1198:
	add	ebx, DWORD PTR 52[rsp]
	mov	eax, DWORD PTR 32[rsp]
	add	r13d, DWORD PTR 20[rsp]
	add	r12d, DWORD PTR 12[rsp]
	add	ebp, DWORD PTR 16[rsp]
	add	eax, r14d
	and	ebx, 16777215
	cmp	DWORD PTR 40[rsp], r14d
	jl	.L1155
	mov	r14d, eax
	jmp	.L1200
	.p2align 4,,10
	.p2align 3
.L1160:
	test	eax, 262144
	mov	DWORD PTR 144[rsp], 32767
	je	.L1251
.L1163:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	DWORD PTR 160[rsp], 32767
	mov	ecx, DWORD PTR 16[rax]
	test	ecx, ecx
	je	.L1174
.L1247:
	mov	eax, DWORD PTR 132[rsp]
	sub	eax, DWORD PTR 12[rsp]
	mov	edi, r12d
	mov	esi, ebp
	sar	edi, 16
	mov	edx, r13d
	sar	esi, 16
	sar	edx, 16
	mov	DWORD PTR 208[rsp], edi
	mov	DWORD PTR 224[rsp], esi
	mov	r8, QWORD PTR 88[rsp]
	add	eax, r12d
	mov	rcx, QWORD PTR 96[rsp]
	sar	eax, 16
	mov	DWORD PTR 240[rsp], eax
	mov	eax, DWORD PTR 136[rsp]
	sub	eax, DWORD PTR 16[rsp]
	add	eax, ebp
	sar	eax, 16
	mov	DWORD PTR 256[rsp], eax
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	edx, DWORD PTR 128[rsp]
	sub	edx, DWORD PTR 20[rsp]
	mov	r8, QWORD PTR 104[rsp]
	mov	rcx, QWORD PTR 112[rsp]
	mov	esi, DWORD PTR 256[rsp]
	mov	edi, DWORD PTR 240[rsp]
	add	edx, r13d
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r8d, DWORD PTR 256[rsp]
	mov	r10d, DWORD PTR 224[rsp]
	mov	edi, DWORD PTR 240[rsp]
	mov	esi, DWORD PTR 208[rsp]
	mov	eax, r8d
	mov	r11d, r10d
	mov	ecx, edi
	mov	edx, esi
	sal	eax, 15
	sal	ecx, 15
	sal	edx, 15
	sal	r11d, 15
	sar	eax, 15
	sar	r11d, 15
	sar	ecx, 15
	sar	edx, 15
	sub	eax, r11d
	sub	ecx, edx
	jns	.L1167
	not	ecx
	and	ecx, 131071
.L1167:
	test	eax, 131072
	je	.L1168
	not	eax
	and	eax, 131071
.L1168:
	xor	edx, edx
	test	ecx, ecx
	cmovns	edx, ecx
	cmp	edx, eax
	cmovge	eax, edx
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L1170
	or	r8d, r10d
	or	r8d, edi
	or	r8d, esi
	sar	r8d, 17
	mov	eax, r8d
	shr	eax
	or	eax, r8d
	test	al, 1
	jne	.L1170
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, ecx
	cmovge	ecx, edx
	lea	edx, -32[rcx]
	mov	esi, ecx
	sar	esi, 5
	shr	edx, 31
	movzx	esi, sil
	and	ch, 96
	mov	eax, DWORD PTR [rax+rsi*4]
	jne	.L1252
	mov	rcx, QWORD PTR max_level@GOTPCREL[rip]
	not	edx
	mov	ecx, DWORD PTR [rcx]
	cmp	eax, ecx
	cmovae	eax, ecx
.L1203:
	mov	rsi, QWORD PTR other_modes@GOTPCREL[rip]
	add	eax, DWORD PTR 124[rsp]
	and	edx, DWORD PTR 8[rsi]
	add	eax, edx
	mov	DWORD PTR 24[rsp], eax
	and	DWORD PTR 24[rsp], 7
	jmp	.L1174
	.p2align 4,,10
	.p2align 3
.L1161:
	mov	DWORD PTR 144[rsp], 32768
	jmp	.L1162
	.p2align 4,,10
	.p2align 3
.L1248:
	mov	r8d, DWORD PTR 176[rsp]
	mov	edx, DWORD PTR 192[rsp]
	sal	r8, 32
	or	r8, rdx
	jmp	.L1175
	.p2align 4,,10
	.p2align 3
.L1164:
	mov	DWORD PTR 160[rsp], 32768
	jmp	.L1165
	.p2align 4,,10
	.p2align 3
.L1170:
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	edx, -1
	mov	eax, DWORD PTR [rax]
	jmp	.L1203
	.p2align 4,,10
	.p2align 3
.L1155:
	add	DWORD PTR 120[rsp], 1
	mov	eax, DWORD PTR 120[rsp]
	cmp	DWORD PTR 140[rsp], eax
	jge	.L1202
.L1147:
	add	rsp, 280
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
.L1249:
	.cfi_restore_state
	movabs	rax, 281474976710656
	movabs	rcx, 4294967296
	and	rax, r8
	cmp	rax, 1
	sbb	edx, edx
	and	dl, 64
	add	edx, 240
	cmp	rax, 1
	sbb	eax, eax
	not	eax
	and	eax, 192
	test	r8, rcx
	cmovne	eax, edx
	mov	rdx, r8
	and	edx, 65536
	cmp	rdx, 1
	sbb	esi, esi
	not	esi
	and	esi, 12
	or	esi, eax
	mov	rax, r8
	and	eax, 1
	neg	eax
	and	eax, 3
	or	esi, eax
	jmp	.L1176
.L1250:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 136[rax]
	test	eax, eax
	je	.L1182
	mov	rdx, QWORD PTR iseed@GOTPCREL[rip]
	mov	rsi, r8
	mov	rdi, r8
	shr	rsi, 24
	movzx	esi, sil
	mov	eax, DWORD PTR [rdx]
	imul	eax, eax, 214013
	add	eax, 2531011
	mov	DWORD PTR [rdx], eax
	sar	eax, 16
	movzx	eax, al
	movsx	rdx, eax
	mov	r10d, eax
	cmp	rsi, rdx
	sbb	ecx, ecx
	and	cl, 64
	add	ecx, 240
	cmp	rsi, rdx
	mov	esi, eax
	sbb	edx, edx
	sal	esi, 6
	sar	r10d, 2
	movzx	esi, sil
	not	edx
	shr	rdi, 16
	or	esi, r10d
	and	edx, 192
	cmp	sil, dil
	mov	esi, eax
	cmovbe	edx, ecx
	mov	ecx, eax
	sar	esi, 4
	sal	ecx, 4
	movzx	ecx, cl
	or	ecx, esi
	mov	rsi, r8
	shr	rsi, 8
	cmp	sil, cl
	sbb	esi, esi
	not	esi
	and	esi, 12
	or	esi, edx
	lea	edx, 0[0+rax*4]
	sar	eax, 6
	mov	ecx, eax
	movzx	eax, r8b
	movzx	edx, dl
	or	edx, ecx
	movsx	rdx, edx
	cmp	rax, rdx
	sbb	eax, eax
	not	eax
	and	eax, 3
	or	esi, eax
	jmp	.L1176
.L1156:
	mov	rcx, QWORD PTR fb_address@GOTPCREL[rip]
	add	edi, edx
	mov	r8d, DWORD PTR [rcx]
	add	ebx, r8d
	jmp	.L1157
.L1182:
	mov	rax, QWORD PTR blend_color@GOTPCREL[rip]
	mov	rdi, r8
	mov	edx, 192
	shr	rdi, 24
	movzx	edi, dil
	movsx	rax, DWORD PTR 12[rax]
	cmp	rdi, rax
	sbb	ecx, ecx
	and	cl, 64
	add	ecx, 240
	cmp	rdi, rax
	cmovb	edx, esi
	mov	rsi, r8
	shr	rsi, 16
	movzx	esi, sil
	cmp	rax, rsi
	cmovbe	edx, ecx
	mov	rcx, r8
	movzx	ecx, ch
	cmp	rcx, rax
	sbb	esi, esi
	not	esi
	and	esi, 12
	or	esi, edx
	movzx	edx, r8b
	cmp	rdx, rax
	sbb	eax, eax
	not	eax
	and	eax, 3
	or	esi, eax
	jmp	.L1176
.L1152:
	mov	ebx, DWORD PTR 4[rax]
	mov	eax, DWORD PTR 8[rax]
	mov	r15d, -1
	neg	DWORD PTR 12[rsp]
	mov	DWORD PTR 16[rsp], ebx
	mov	DWORD PTR 20[rsp], eax
	neg	DWORD PTR 16[rsp]
	neg	DWORD PTR 20[rsp]
	jmp	.L1153
.L1206:
	mov	DWORD PTR 48[rsp], 1
	jmp	.L1150
.L1246:
	mov	rax, QWORD PTR rdp_pipeline_crashed@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
	jmp	.L1147
.L1252:
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	not	edx
	mov	eax, DWORD PTR [rax]
	jmp	.L1203
	.cfi_endproc
.LFE593:
	.size	render_spans_copy, .-render_spans_copy
	.p2align 4,,15
	.globl	loading_pipeline
	.type	loading_pipeline, @function
loading_pipeline:
.LFB594:
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
	sub	rsp, 248
	.cfi_def_cfa_offset 304
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	cmp	esi, edi
	mov	DWORD PTR 128[rsp], edi
	mov	DWORD PTR 132[rsp], esi
	mov	DWORD PTR 108[rsp], edx
	mov	DWORD PTR 112[rsp], ecx
	mov	ebx, DWORD PTR [rax]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR 124[rsp], r8d
	mov	DWORD PTR 144[rsp], 0
	mov	DWORD PTR 160[rsp], 0
	mov	DWORD PTR 176[rsp], 0
	mov	DWORD PTR 192[rsp], 0
	mov	DWORD PTR 208[rsp], 0
	mov	DWORD PTR 224[rsp], 0
	mov	DWORD PTR 116[rsp], ebx
	mov	DWORD PTR 120[rsp], eax
	jle	.L1254
	test	r8d, r8d
	je	.L1254
.L1260:
	mov	rax, QWORD PTR rdp_pipeline_crashed@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
.L1253:
	add	rsp, 248
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
.L1254:
	.cfi_restore_state
	movsx	rax, DWORD PTR 108[rsp]
	mov	rbx, QWORD PTR tile@GOTPCREL[rip]
	mov	DWORD PTR 104[rsp], 0
	lea	rdx, [rax+rax*4]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [rbx+rdx*4]
	mov	ecx, DWORD PTR [rdx]
	cmp	ecx, 1
	je	.L1256
	test	ecx, ecx
	mov	DWORD PTR 104[rsp], 2
	jne	.L1256
	xor	ebx, ebx
	cmp	DWORD PTR 4[rdx], 3
	setne	bl
	mov	DWORD PTR 104[rsp], ebx
	add	DWORD PTR 104[rsp], 1
.L1256:
	mov	rbx, QWORD PTR ti_size@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rbx]
	cmp	ecx, 1
	je	.L1258
	jle	.L1320
	cmp	ecx, 2
	je	.L1261
	cmp	ecx, 3
	mov	QWORD PTR 96[rsp], 8
	mov	DWORD PTR 36[rsp], 2
	jne	.L1303
.L1257:
	mov	ebx, DWORD PTR 128[rsp]
	cmp	DWORD PTR 132[rsp], ebx
	jl	.L1253
	lea	rax, [rax+rax*4]
	lea	rax, [rax+rax*4]
	mov	QWORD PTR 136[rsp], rax
	.p2align 4,,10
	.p2align 3
.L1299:
	mov	ebx, DWORD PTR 128[rsp]
	movsx	rax, ebx
	lea	rdx, [rax+rax*2]
	mov	rax, QWORD PTR ti_width@GOTPCREL[rip]
	sal	rdx, 5
	add	rdx, QWORD PTR span@GOTPCREL[rip]
	imul	ebx, DWORD PTR [rax]
	mov	rax, QWORD PTR ti_address@GOTPCREL[rip]
	mov	esi, DWORD PTR 8[rdx]
	mov	ebp, DWORD PTR 32[rdx]
	mov	r13d, DWORD PTR 36[rdx]
	mov	edx, DWORD PTR [rdx]
	add	ebx, esi
	sal	ebx, cl
	sub	edx, esi
	sar	ebx
	add	ebx, DWORD PTR [rax]
	add	edx, 1
	and	ebx, 16777215
	and	edx, 4095
	mov	DWORD PTR 32[rsp], edx
	je	.L1297
	lea	rax, 176[rsp]
	mov	rsi, QWORD PTR 136[rsp]
	mov	r14d, DWORD PTR 36[rsp]
	mov	r15, QWORD PTR TMEM@GOTPCREL[rip]
	mov	QWORD PTR 56[rsp], rax
	lea	rax, 160[rsp]
	mov	QWORD PTR 48[rsp], rax
	lea	rax, 144[rsp]
	mov	QWORD PTR 40[rsp], rax
	lea	rax, 224[rsp]
	mov	QWORD PTR 80[rsp], rax
	lea	rax, 208[rsp]
	mov	QWORD PTR 72[rsp], rax
	lea	rax, 192[rsp]
	mov	QWORD PTR 64[rsp], rax
	mov	rax, QWORD PTR tile@GOTPCREL[rip]
	lea	rax, [rax+rsi*4]
	mov	QWORD PTR 88[rsp], rax
	mov	eax, r14d
	mov	r14d, r13d
	mov	r13d, ebp
	mov	ebp, eax
	.p2align 4,,10
	.p2align 3
.L1298:
	mov	rax, QWORD PTR 88[rsp]
	mov	edi, r13d
	mov	r12d, r14d
	sar	edi, 16
	sar	r12d, 16
	lea	rdx, 48[rax]
	mov	eax, DWORD PTR 52[rax]
	mov	edx, DWORD PTR 8[rdx]
	lea	ecx, 0[0+rax*8]
	mov	eax, DWORD PTR 112[rsp]
	sal	edx, 3
	sub	edi, ecx
	sub	r12d, edx
	test	eax, eax
	jne	.L1268
	sar	edi, 5
	sar	r12d, 5
.L1269:
	mov	rax, QWORD PTR 80[rsp]
	mov	r8, QWORD PTR 48[rsp]
	mov	esi, r12d
	mov	rcx, QWORD PTR 40[rsp]
	mov	edx, DWORD PTR 108[rsp]
	mov	r9, QWORD PTR 56[rsp]
	mov	QWORD PTR 16[rsp], rax
	mov	rax, QWORD PTR 72[rsp]
	mov	QWORD PTR 8[rsp], rax
	mov	rax, QWORD PTR 64[rsp]
	mov	QWORD PTR [rsp], rax
	call	get_tmem_idx@PLT
	mov	rax, QWORD PTR idxlim32@GOTPCREL[rip]
	mov	rdx, rbx
	xor	r8d, r8d
	shr	rdx, 2
	and	edx, -2
	mov	ecx, DWORD PTR [rax]
	cmp	edx, ecx
	ja	.L1270
	mov	rsi, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	edi, edx
	mov	rsi, QWORD PTR 32[rsi]
	mov	r8d, DWORD PTR [rsi+rdi*4]
.L1270:
	lea	edi, 1[rdx]
	xor	esi, esi
	cmp	ecx, edi
	jb	.L1271
	mov	rsi, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rsi, QWORD PTR 32[rsi]
	mov	esi, DWORD PTR [rsi+rdi*4]
.L1271:
	lea	r9d, 2[rdx]
	xor	edi, edi
	cmp	ecx, r9d
	jb	.L1272
	mov	rdi, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rdi, QWORD PTR 32[rdi]
	mov	edi, DWORD PTR [rdi+r9*4]
.L1272:
	add	edx, 3
	xor	r9d, r9d
	cmp	ecx, edx
	jb	.L1273
	mov	rcx, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rcx, QWORD PTR 32[rcx]
	mov	r9d, DWORD PTR [rcx+rdx*4]
.L1273:
	lea	rax, .L1276[rip]
	mov	rdx, rbx
	and	edx, 7
	movsx	rdx, DWORD PTR [rax+rdx*4]
	add	rdx, rax
	jmp	rdx
	.section	.rodata
	.align 4
	.align 4
.L1276:
	.long	.L1274-.L1276
	.long	.L1275-.L1276
	.long	.L1277-.L1276
	.long	.L1278-.L1276
	.long	.L1279-.L1276
	.long	.L1280-.L1276
	.long	.L1281-.L1276
	.long	.L1282-.L1276
	.text
	.p2align 4,,10
	.p2align 3
.L1281:
	mov	eax, DWORD PTR 124[rsp]
	test	eax, eax
	jne	.L1287
	mov	edx, edi
	sal	rsi, 48
	shr	r9d, 16
	sal	rdx, 16
	or	rdx, rsi
	or	rdx, r9
	.p2align 4,,10
	.p2align 3
.L1284:
	mov	eax, DWORD PTR 104[rsp]
	cmp	eax, 1
	je	.L1289
.L1322:
	cmp	eax, 2
	jne	.L1321
	and	r12d, 1
	mov	ecx, DWORD PTR 144[rsp]
	jne	.L1294
	mov	r9d, DWORD PTR 224[rsp]
	test	r9d, r9d
	jne	.L1295
	mov	rsi, rdx
	xor	ecx, 1
	shr	rsi, 48
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 160[rsp]
	mov	rsi, rdx
	shr	rsi, 32
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 176[rsp]
	mov	rsi, rdx
	shr	rsi, 16
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 192[rsp]
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], dx
	.p2align 4,,10
	.p2align 3
.L1292:
	add	r13d, DWORD PTR 116[rsp]
	add	r14d, DWORD PTR 120[rsp]
	add	rbx, QWORD PTR 96[rsp]
	mov	eax, DWORD PTR 36[rsp]
	and	r13d, -32
	and	r14d, -32
	lea	edx, 0[rbp+rax]
	and	ebx, 16777215
	cmp	DWORD PTR 32[rsp], ebp
	jle	.L1297
	mov	ebp, edx
	jmp	.L1298
	.p2align 4,,10
	.p2align 3
.L1280:
	mov	edx, edi
	mov	eax, DWORD PTR 104[rsp]
	sal	rsi, 40
	sal	rdx, 8
	shr	r9d, 24
	or	rdx, rsi
	or	rdx, r9
	cmp	eax, 1
	jne	.L1322
	.p2align 4,,10
	.p2align 3
.L1289:
	mov	rsi, rdx
	mov	rcx, rdx
	mov	r10d, DWORD PTR 208[rsp]
	shr	rsi, 16
	shr	rcx, 48
	sal	ecx, 16
	movzx	esi, si
	or	esi, ecx
	mov	rcx, rdx
	movzx	edx, dx
	shr	rcx, 32
	sal	ecx, 16
	or	ecx, edx
	test	r10d, r10d
	jne	.L1318
.L1293:
	mov	edi, DWORD PTR 144[rsp]
	mov	r8d, esi
	shr	r8d, 16
	mov	edx, edi
	xor	edx, 1
	mov	WORD PTR [r15+rdx*2], r8w
	mov	edx, DWORD PTR 160[rsp]
	jmp	.L1319
	.p2align 4,,10
	.p2align 3
.L1279:
	mov	eax, DWORD PTR 124[rsp]
	test	eax, eax
	jne	.L1286
	mov	edx, edi
	sal	rsi, 32
	or	rdx, rsi
	jmp	.L1284
	.p2align 4,,10
	.p2align 3
.L1278:
	mov	edx, esi
	sal	r8, 56
	shr	edi, 8
	sal	rdx, 24
	or	rdx, r8
	or	rdx, rdi
	jmp	.L1284
	.p2align 4,,10
	.p2align 3
.L1274:
	mov	eax, DWORD PTR 124[rsp]
	test	eax, eax
	jne	.L1283
	mov	edx, esi
	sal	r8, 32
	or	rdx, r8
	jmp	.L1284
	.p2align 4,,10
	.p2align 3
.L1277:
	mov	eax, DWORD PTR 124[rsp]
	test	eax, eax
	jne	.L1285
	mov	edx, esi
	sal	r8, 48
	shr	edi, 16
	sal	rdx, 16
	or	rdx, r8
	or	rdx, rdi
	jmp	.L1284
	.p2align 4,,10
	.p2align 3
.L1275:
	mov	edx, esi
	sal	r8, 40
	shr	edi, 24
	sal	rdx, 8
	or	rdx, r8
	or	rdx, rdi
	jmp	.L1284
	.p2align 4,,10
	.p2align 3
.L1282:
	mov	edx, edi
	sal	rsi, 56
	shr	r9d, 8
	sal	rdx, 24
	or	rdx, rsi
	or	rdx, r9
	jmp	.L1284
.L1258:
	mov	QWORD PTR 96[rsp], 8
	mov	DWORD PTR 36[rsp], 8
	jmp	.L1257
.L1261:
	mov	ebx, DWORD PTR 124[rsp]
	cmp	ebx, 1
	sbb	rsi, rsi
	mov	QWORD PTR 96[rsp], rsi
	and	QWORD PTR 96[rsp], 6
	add	QWORD PTR 96[rsp], 2
	cmp	ebx, 1
	sbb	ebx, ebx
	mov	DWORD PTR 36[rsp], ebx
	and	DWORD PTR 36[rsp], 3
	add	DWORD PTR 36[rsp], 1
	jmp	.L1257
	.p2align 4,,10
	.p2align 3
.L1268:
	sar	edi, 3
	sar	r12d, 3
	jmp	.L1269
	.p2align 4,,10
	.p2align 3
.L1321:
	mov	rsi, rdx
	movzx	ecx, dh
	movzx	edi, dl
	shr	rsi, 56
	mov	r11d, DWORD PTR 208[rsp]
	sal	esi, 24
	or	esi, ecx
	mov	rcx, rdx
	shr	rcx, 40
	movzx	ecx, cl
	sal	ecx, 16
	or	esi, ecx
	mov	rcx, rdx
	shr	rcx, 24
	sal	ecx, 8
	movzx	ecx, cx
	or	esi, ecx
	mov	rcx, rdx
	shr	rcx, 48
	sal	ecx, 24
	or	ecx, edi
	mov	rdi, rdx
	shr	rdx, 16
	shr	rdi, 32
	sal	edx, 8
	movzx	edi, dil
	movzx	edx, dx
	sal	edi, 16
	or	ecx, edi
	or	ecx, edx
	test	r11d, r11d
	je	.L1293
.L1318:
	mov	edi, DWORD PTR 176[rsp]
	mov	r8d, esi
	shr	r8d, 16
	mov	edx, edi
	xor	edx, 1
	mov	WORD PTR [r15+rdx*2], r8w
	mov	edx, DWORD PTR 192[rsp]
.L1319:
	mov	r8d, edx
	or	edi, 1024
	or	dh, 4
	xor	r8d, 1
	xor	edi, 1
	xor	edx, 1
	mov	WORD PTR [r15+r8*2], si
	mov	esi, ecx
	shr	esi, 16
	mov	WORD PTR [r15+rdi*2], si
	mov	WORD PTR [r15+rdx*2], cx
	jmp	.L1292
	.p2align 4,,10
	.p2align 3
.L1294:
	mov	r8d, DWORD PTR 224[rsp]
	test	r8d, r8d
	jne	.L1296
	mov	rsi, rdx
	xor	ecx, 1
	shr	rsi, 16
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 160[rsp]
	mov	rsi, rdx
	shr	rsi, 48
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], dx
	mov	ecx, DWORD PTR 176[rsp]
	shr	rdx, 32
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 192[rsp]
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], dx
	jmp	.L1292
	.p2align 4,,10
	.p2align 3
.L1286:
	shr	esi, 16
.L1287:
	movzx	esi, si
	mov	rdx, rsi
	mov	rcx, rsi
	sal	rdx, 48
	sal	rcx, 32
	or	rdx, rcx
	or	rdx, rsi
	sal	rsi, 16
	or	rdx, rsi
	jmp	.L1284
	.p2align 4,,10
	.p2align 3
.L1283:
	shr	r8d, 16
.L1285:
	movzx	r8d, r8w
	mov	rdx, r8
	mov	rcx, r8
	sal	rdx, 48
	sal	rcx, 32
	or	rdx, rcx
	or	rdx, r8
	sal	r8, 16
	or	rdx, r8
	jmp	.L1284
	.p2align 4,,10
	.p2align 3
.L1297:
	add	DWORD PTR 128[rsp], 1
	mov	eax, DWORD PTR 128[rsp]
	cmp	DWORD PTR 132[rsp], eax
	jl	.L1253
	mov	rax, QWORD PTR ti_size@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rax]
	jmp	.L1299
	.p2align 4,,10
	.p2align 3
.L1295:
	or	ch, 4
	mov	rsi, rdx
	xor	ecx, 1
	shr	rsi, 48
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 160[rsp]
	mov	rsi, rdx
	shr	rsi, 32
	or	ch, 4
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 176[rsp]
	mov	rsi, rdx
	shr	rsi, 16
	or	ch, 4
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 192[rsp]
	or	ch, 4
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], dx
	jmp	.L1292
	.p2align 4,,10
	.p2align 3
.L1296:
	mov	rsi, rdx
	or	ch, 4
	xor	ecx, 1
	shr	rsi, 16
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 160[rsp]
	mov	rsi, rdx
	shr	rsi, 48
	or	ch, 4
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], dx
	mov	ecx, DWORD PTR 176[rsp]
	shr	rdx, 32
	or	ch, 4
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], si
	mov	ecx, DWORD PTR 192[rsp]
	or	ch, 4
	xor	ecx, 1
	mov	WORD PTR [r15+rcx*2], dx
	jmp	.L1292
.L1320:
	test	ecx, ecx
	je	.L1260
.L1303:
	mov	QWORD PTR 96[rsp], 0
	mov	DWORD PTR 36[rsp], 0
	jmp	.L1257
	.cfi_endproc
.LFE594:
	.size	loading_pipeline, .-loading_pipeline
	.p2align 4,,15
	.globl	edgewalker_for_loads
	.type	edgewalker_for_loads, @function
edgewalker_for_loads:
.LFB595:
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
	mov	eax, DWORD PTR [rdi]
	mov	r10d, DWORD PTR 28[rdi]
	mov	r9d, DWORD PTR 24[rdi]
	mov	r13d, DWORD PTR 4[rdi]
	mov	r15d, DWORD PTR 12[rdi]
	sar	eax, 24
	mov	r11d, DWORD PTR 8[rdi]
	mov	ecx, DWORD PTR 16[rdi]
	and	eax, 63
	mov	ebx, r10d
	cmp	eax, 48
	lea	r8d, 0[0+r13*4]
	sete	dl
	cmp	eax, 51
	sete	al
	movzx	esi, dl
	xor	bx, bx
	or	eax, edx
	mov	DWORD PTR -16[rsp], esi
	mov	edx, DWORD PTR 20[rdi]
	movzx	eax, al
	sal	r13d, 18
	sal	r15d, 4
	mov	DWORD PTR -12[rsp], eax
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	sar	r13d, 18
	sar	r15d, 4
	sal	r10d, 16
	sal	ecx, 4
	and	r15d, -2
	sal	r11d, 4
	sar	ecx, 4
	mov	DWORD PTR [rax], 0
	mov	esi, DWORD PTR [rdi]
	mov	r14d, edx
	sar	r8d, 18
	sar	r11d, 4
	sal	r14d, 16
	and	ecx, -2
	mov	eax, esi
	sal	esi, 18
	sar	eax, 16
	sar	esi, 18
	mov	DWORD PTR -20[rsp], eax
	mov	eax, DWORD PTR 36[rdi]
	mov	rdi, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	and	DWORD PTR -20[rsp], 7
	mov	DWORD PTR -32[rsp], eax
	mov	eax, r9d
	and	r9d, 65504
	shr	eax, 16
	or	r9d, r10d
	mov	DWORD PTR 8[rdi], 0
	or	eax, ebx
	mov	ebx, esi
	mov	DWORD PTR 4[rdi], r9d
	and	eax, -32
	or	ebx, 3
	sal	DWORD PTR -32[rsp], 16
	mov	DWORD PTR [rdi], eax
	mov	eax, r13d
	mov	edi, r15d
	and	eax, -4
	sar	edi, 16
	cmp	eax, ebx
	mov	DWORD PTR -28[rsp], edi
	jg	.L1333
	sal	r15d, 4
	xor	dx, dx
	add	ebx, 1
	shr	r15d, 20
	xor	r10d, r10d
	xor	r9d, r9d
	and	r11d, -2
	mov	DWORD PTR -24[rsp], edx
	mov	DWORD PTR -36[rsp], r15d
	jmp	.L1334
	.p2align 4,,10
	.p2align 3
.L1340:
	mov	r12d, eax
	mov	r15d, 4095
	sar	r12d, 2
	cmp	eax, esi
	setl	bpl
	cmp	eax, r13d
	setge	dil
	test	edx, edx
	cmove	r10d, r15d
	mov	r15w, 0
	cmove	r9d, r15d
	test	bpl, dil
	je	.L1328
	mov	edi, ecx
	sal	edi, 4
	shr	edi, 20
	cmp	r9d, edi
	cmovl	r9d, edi
	cmp	r10d, DWORD PTR -36[rsp]
	cmovg	r10d, DWORD PTR -36[rsp]
.L1328:
	test	edx, edx
	jne	.L1329
	movsx	r12, r12d
	mov	edi, DWORD PTR -28[rsp]
	lea	rdx, [r12+r12*2]
	sal	rdx, 5
	add	rdx, QWORD PTR span@GOTPCREL[rip]
	mov	DWORD PTR 8[rdx], edi
	mov	edi, DWORD PTR -24[rsp]
	mov	DWORD PTR 32[rdx], edi
	mov	edi, r14d
	and	edi, -1024
	mov	DWORD PTR 36[rdx], edi
.L1332:
	add	eax, 1
	cmp	eax, ebx
	je	.L1333
.L1334:
	cmp	eax, r8d
	mov	edx, eax
	cmove	ecx, r11d
	and	edx, 3
	test	eax, -4096
	je	.L1340
	cmp	edx, 3
	jne	.L1332
	add	r14d, DWORD PTR -32[rsp]
.L1341:
	add	eax, 1
	cmp	eax, ebx
	jne	.L1334
.L1333:
	mov	r8d, DWORD PTR -16[rsp]
	mov	ecx, DWORD PTR -12[rsp]
	mov	edi, r13d
	mov	edx, DWORD PTR -20[rsp]
	sar	esi, 2
	sar	edi, 2
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
	jmp	loading_pipeline@PLT
	.p2align 4,,10
	.p2align 3
.L1329:
	.cfi_restore_state
	cmp	edx, 3
	jne	.L1332
	movsx	r12, r12d
	add	r14d, DWORD PTR -32[rsp]
	lea	rdx, [r12+r12*2]
	sal	rdx, 5
	add	rdx, QWORD PTR span@GOTPCREL[rip]
	mov	DWORD PTR [rdx], r9d
	mov	DWORD PTR 4[rdx], r10d
	jmp	.L1341
	.cfi_endproc
.LFE595:
	.size	edgewalker_for_loads, .-edgewalker_for_loads
	.p2align 4,,15
	.globl	deduce_derivatives
	.type	deduce_derivatives, @function
deduce_derivatives:
.LFB596:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	rcx, QWORD PTR blender2b_a@GOTPCREL[rip]
	xor	edi, edi
	mov	rdx, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	lea	rax, 12[rdx]
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	mov	rsi, QWORD PTR [rcx]
	cmp	rsi, rax
	je	.L1402
.L1343:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rcx, QWORD PTR 8[rcx]
	mov	DWORD PTR 152[rax], edi
	lea	rdi, 12[rdx]
	xor	edx, edx
	cmp	rcx, rdi
	je	.L1403
.L1344:
	mov	DWORD PTR 156[rax], edx
	mov	rdx, QWORD PTR memory_color@GOTPCREL[rip]
	mov	ebp, DWORD PTR 56[rax]
	add	rdx, 12
	cmp	rsi, rdx
	sete	sil
	cmp	rcx, rdx
	sete	dl
	movzx	esi, sil
	movzx	edx, dl
	mov	DWORD PTR 160[rax], esi
	mov	DWORD PTR 164[rax], edx
	mov	edx, DWORD PTR 52[rax]
	lea	esi, 0[0+rdx*4]
	or	esi, ebp
	cmp	edx, 3
	mov	DWORD PTR 168[rax], esi
	je	.L1404
	mov	rdx, QWORD PTR rgb_dither_complete@GOTPCREL[rip]
.L1345:
	movsx	rcx, DWORD PTR 4[rax]
	mov	QWORD PTR rgb_dither_ptr[rip], rdx
	lea	rdx, tcdiv_func[rip]
	mov	rdx, QWORD PTR [rdx+rcx*8]
	mov	rcx, QWORD PTR combiner_rgbmul_r@GOTPCREL[rip]
	mov	r8, QWORD PTR 8[rcx]
	mov	QWORD PTR tcdiv_ptr[rip], rdx
	lea	rdx, lod_frac[rip]
	cmp	r8, rdx
	je	.L1375
	mov	rdi, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	xor	r9d, r9d
	cmp	QWORD PTR 8[rdi], rdx
	sete	r9b
.L1346:
	mov	rdi, QWORD PTR [rcx]
	mov	r11d, 1
	cmp	rdi, rdx
	je	.L1347
	mov	rcx, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	lea	rdx, lod_frac[rip]
	cmp	QWORD PTR [rcx], rdx
	cmovne	r11d, r9d
.L1347:
	mov	rdx, QWORD PTR texel1_color@GOTPCREL[rip]
	mov	rbx, QWORD PTR combiner_rgbsub_a_r@GOTPCREL[rip]
	cmp	r8, rdx
	mov	r10, QWORD PTR 8[rbx]
	je	.L1405
	cmp	r10, rdx
	je	.L1384
	mov	rcx, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	cmp	QWORD PTR 8[rcx], rdx
	je	.L1384
	mov	rcx, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	cmp	QWORD PTR 8[rcx], rdx
	je	.L1384
	mov	r12, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	lea	rcx, 12[rdx]
	cmp	QWORD PTR 8[r12], rcx
	je	.L1384
	mov	r12, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	cmp	QWORD PTR 8[r12], rcx
	je	.L1384
	mov	r12, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	cmp	QWORD PTR 8[r12], rcx
	je	.L1384
	mov	r12, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	cmp	QWORD PTR 8[r12], rcx
	je	.L1384
	xor	r12d, r12d
	cmp	r8, rcx
	mov	rcx, QWORD PTR texel0_color@GOTPCREL[rip]
	sete	r12b
	cmp	r8, rcx
	jne	.L1349
	.p2align 4,,10
	.p2align 3
.L1351:
	mov	r14d, 1
	mov	r13d, 1
.L1352:
	cmp	rdi, rdx
	mov	r8, QWORD PTR [rbx]
	mov	ebx, 1
	je	.L1354
	cmp	r8, rdx
	je	.L1392
	mov	rbx, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	cmp	QWORD PTR [rbx], rdx
	je	.L1392
	mov	rbx, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	cmp	QWORD PTR [rbx], rdx
	je	.L1392
	mov	rbx, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	add	rdx, 12
	cmp	QWORD PTR [rbx], rdx
	je	.L1392
	mov	rbx, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	cmp	QWORD PTR [rbx], rdx
	je	.L1392
	mov	rbx, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	cmp	QWORD PTR [rbx], rdx
	je	.L1392
	mov	rbx, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	cmp	QWORD PTR [rbx], rdx
	je	.L1392
	xor	ebx, ebx
	cmp	rdi, rdx
	sete	bl
	cmp	rdi, rcx
	jne	.L1354
	.p2align 4,,10
	.p2align 3
.L1356:
	test	r12d, r12d
	mov	ecx, 1
	je	.L1358
.L1406:
	mov	rcx, QWORD PTR render_spans_1cycle_complete@GOTPCREL[rip]
	mov	rdx, QWORD PTR render_spans_1cycle_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rdx], rcx
	mov	rcx, QWORD PTR render_spans_2cycle_complete@GOTPCREL[rip]
	mov	rdx, QWORD PTR render_spans_2cycle_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rdx], rcx
.L1359:
	mov	edx, DWORD PTR [rax]
	cmp	edx, 1
	je	.L1363
.L1409:
	test	edx, edx
	jne	.L1394
	lea	rdx, noise[rip]
	cmp	r10, rdx
	je	.L1365
.L1364:
	cmp	ebp, 2
	je	.L1365
	cmp	esi, 15
	je	.L1368
	mov	rdx, QWORD PTR get_dither_only@GOTPCREL[rip]
	mov	QWORD PTR get_dither_noise_ptr[rip], rdx
.L1367:
	xor	edx, edx
	or	r9d, DWORD PTR 16[rax]
	setne	dl
	mov	DWORD PTR 148[rax], edx
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
	.p2align 4,,10
	.p2align 3
.L1384:
	.cfi_restore_state
	mov	rcx, QWORD PTR texel0_color@GOTPCREL[rip]
	mov	r12d, 1
	cmp	r8, rcx
	je	.L1351
.L1349:
	cmp	r10, rcx
	je	.L1351
	mov	r13, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	cmp	QWORD PTR 8[r13], rcx
	je	.L1351
	mov	r13, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	cmp	QWORD PTR 8[r13], rcx
	je	.L1351
	mov	r13, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	lea	r15, 12[rcx]
	cmp	QWORD PTR 8[r13], r15
	je	.L1351
	mov	r13, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	cmp	QWORD PTR 8[r13], r15
	je	.L1351
	mov	r13, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	cmp	QWORD PTR 8[r13], r15
	je	.L1351
	mov	r13, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	cmp	QWORD PTR 8[r13], r15
	je	.L1351
	xor	r13d, r13d
	cmp	r8, r15
	mov	r14d, r9d
	jne	.L1352
	jmp	.L1351
	.p2align 4,,10
	.p2align 3
.L1392:
	cmp	rdi, rcx
	mov	ebx, 1
	je	.L1356
.L1354:
	cmp	r8, rcx
	je	.L1356
	mov	rdx, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	cmp	QWORD PTR [rdx], rcx
	je	.L1356
	mov	rdx, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	cmp	QWORD PTR [rdx], rcx
	je	.L1356
	lea	rdx, 12[rcx]
	mov	rcx, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	cmp	QWORD PTR [rcx], rdx
	je	.L1356
	mov	rcx, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	cmp	QWORD PTR [rcx], rdx
	je	.L1356
	mov	rcx, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	cmp	QWORD PTR [rcx], rdx
	je	.L1356
	mov	rcx, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	cmp	QWORD PTR [rcx], rdx
	je	.L1356
	cmp	rdi, rdx
	mov	ecx, r11d
	je	.L1356
	test	r12d, r12d
	jne	.L1406
.L1358:
	test	r14d, r14d
	je	.L1407
	mov	rdi, QWORD PTR render_spans_1cycle_notexel1@GOTPCREL[rip]
	mov	rdx, QWORD PTR render_spans_1cycle_ptr@GOTPCREL[rip]
	or	ebx, r13d
	mov	QWORD PTR [rdx], rdi
	je	.L1408
.L1369:
	mov	rdx, QWORD PTR render_spans_2cycle_ptr@GOTPCREL[rip]
	mov	rcx, QWORD PTR render_spans_2cycle_notexelnext@GOTPCREL[rip]
	mov	QWORD PTR [rdx], rcx
	mov	edx, DWORD PTR [rax]
	cmp	edx, 1
	jne	.L1409
.L1363:
	lea	rdx, noise[rip]
	cmp	r8, rdx
	je	.L1410
	cmp	r10, rdx
	mov	r9d, r11d
	jne	.L1364
	.p2align 4,,10
	.p2align 3
.L1365:
	mov	rdx, QWORD PTR get_dither_noise_complete@GOTPCREL[rip]
	mov	QWORD PTR get_dither_noise_ptr[rip], rdx
	jmp	.L1367
	.p2align 4,,10
	.p2align 3
.L1394:
	xor	r9d, r9d
	jmp	.L1364
	.p2align 4,,10
	.p2align 3
.L1407:
	mov	rdi, QWORD PTR render_spans_1cycle_notex@GOTPCREL[rip]
	mov	rdx, QWORD PTR render_spans_1cycle_ptr@GOTPCREL[rip]
	or	ebx, r13d
	mov	QWORD PTR [rdx], rdi
	jne	.L1369
.L1408:
	test	ecx, ecx
	je	.L1362
	mov	rcx, QWORD PTR render_spans_2cycle_notexel1@GOTPCREL[rip]
	mov	rdx, QWORD PTR render_spans_2cycle_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rdx], rcx
	jmp	.L1359
	.p2align 4,,10
	.p2align 3
.L1404:
	mov	rdx, QWORD PTR rgb_dither_nothing@GOTPCREL[rip]
	jmp	.L1345
	.p2align 4,,10
	.p2align 3
.L1368:
	mov	rdx, QWORD PTR get_dither_nothing@GOTPCREL[rip]
	mov	QWORD PTR get_dither_noise_ptr[rip], rdx
	jmp	.L1367
	.p2align 4,,10
	.p2align 3
.L1362:
	mov	rcx, QWORD PTR render_spans_2cycle_notex@GOTPCREL[rip]
	mov	rdx, QWORD PTR render_spans_2cycle_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rdx], rcx
	jmp	.L1359
	.p2align 4,,10
	.p2align 3
.L1375:
	mov	r9d, 1
	jmp	.L1346
	.p2align 4,,10
	.p2align 3
.L1405:
	mov	r12d, 1
	mov	rcx, QWORD PTR texel0_color@GOTPCREL[rip]
	jmp	.L1349
	.p2align 4,,10
	.p2align 3
.L1402:
	mov	rdi, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	add	rax, 12
	cmp	QWORD PTR [rdi], rax
	sete	dil
	movzx	edi, dil
	jmp	.L1343
	.p2align 4,,10
	.p2align 3
.L1403:
	mov	rdx, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	rdi, QWORD PTR blender1b_a@GOTPCREL[rip]
	add	rdx, 12
	cmp	QWORD PTR 8[rdi], rdx
	sete	dl
	movzx	edx, dl
	jmp	.L1344
	.p2align 4,,10
	.p2align 3
.L1410:
	mov	r9d, r11d
	jmp	.L1365
	.cfi_endproc
.LFE596:
	.size	deduce_derivatives, .-deduce_derivatives
	.p2align 4,,15
	.globl	tile_tlut_common_cs_decoder
	.type	tile_tlut_common_cs_decoder, @function
tile_tlut_common_cs_decoder:
.LFB597:
	.cfi_startproc
	mov	r8d, esi
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	edx, edi
	shr	r8d, 24
	mov	ecx, esi
	shr	edx, 12
	and	r8d, 7
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	mov	r9d, edi
	movsx	rax, r8d
	shr	ecx, 12
	and	edx, 4095
	lea	rax, [rax+rax*4]
	sub	rsp, 56
	.cfi_def_cfa_offset 80
	mov	r10, QWORD PTR tile@GOTPCREL[rip]
	and	r9d, 4095
	and	ecx, 4095
	and	esi, 4095
	lea	rax, [rax+rax*4]
	and	edi, -16777216
	mov	DWORD PTR 24[rsp], 0
	or	edi, 8388611
	mov	DWORD PTR 32[rsp], 32
	mov	DWORD PTR 36[rsp], 32
	lea	r11, [r10+rax*4]
	mov	eax, r8d
	or	edi, esi
	lea	rax, [rax+rax*4]
	sal	r8d, 16
	mov	DWORD PTR 52[r11], edx
	mov	DWORD PTR 56[r11], r9d
	or	edi, r8d
	lea	rax, [rax+rax*4]
	mov	DWORD PTR 60[r11], ecx
	mov	DWORD PTR 64[r11], esi
	or	esi, 3
	mov	DWORD PTR [rsp], edi
	mov	rdi, rsp
	lea	r11, [r10+rax*4]
	sal	esi, 16
	or	esi, r9d
	mov	eax, DWORD PTR 60[r11]
	mov	ebx, DWORD PTR 52[r11]
	mov	r10d, DWORD PTR 56[r11]
	mov	DWORD PTR 4[rsp], esi
	mov	esi, edx
	sar	esi, 2
	sar	ebx, 2
	sar	eax, 2
	sal	esi, 16
	sub	eax, ebx
	sar	r10d, 2
	and	eax, 1023
	mov	DWORD PTR 68[r11], eax
	mov	eax, DWORD PTR 64[r11]
	sar	eax, 2
	sub	eax, r10d
	and	eax, 1023
	mov	DWORD PTR 72[r11], eax
	mov	eax, ecx
	sar	ecx, 2
	sal	eax, 14
	sal	ecx, 16
	movzx	eax, ax
	or	eax, ecx
	mov	ecx, edx
	mov	DWORD PTR 8[rsp], eax
	mov	DWORD PTR 16[rsp], eax
	sal	ecx, 14
	mov	rax, QWORD PTR ti_size@GOTPCREL[rip]
	movzx	ecx, cx
	or	ecx, esi
	sal	edx, 19
	sal	r9d, 3
	mov	DWORD PTR 12[rsp], ecx
	or	edx, r9d
	mov	ecx, DWORD PTR [rax]
	mov	eax, 512
	mov	DWORD PTR 20[rsp], edx
	sar	eax, cl
	sal	eax, 16
	mov	DWORD PTR 28[rsp], eax
	call	edgewalker_for_loads@PLT
	add	rsp, 56
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE597:
	.size	tile_tlut_common_cs_decoder, .-tile_tlut_common_cs_decoder
	.p2align 4,,15
	.globl	irand
	.type	irand, @function
irand:
.LFB598:
	.cfi_startproc
	mov	rdx, QWORD PTR iseed@GOTPCREL[rip]
	mov	eax, DWORD PTR [rdx]
	imul	eax, eax, 214013
	add	eax, 2531011
	mov	DWORD PTR [rdx], eax
	sar	eax, 16
	and	eax, 32767
	ret
	.cfi_endproc
.LFE598:
	.size	irand, .-irand
	.p2align 4,,15
	.globl	alpha_compare
	.type	alpha_compare, @function
alpha_compare:
.LFB599:
	.cfi_startproc
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, 1
	mov	r8d, DWORD PTR 140[rdx]
	test	r8d, r8d
	je	.L1415
	mov	esi, DWORD PTR 136[rdx]
	test	esi, esi
	je	.L1419
	mov	rdx, QWORD PTR iseed@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rdx]
	imul	eax, ecx, 214013
	add	eax, 2531011
	mov	DWORD PTR [rdx], eax
	sar	eax, 16
	movzx	eax, al
.L1417:
	cmp	edi, eax
	setge	al
	movzx	eax, al
.L1415:
	rep ret
	.p2align 4,,10
	.p2align 3
.L1419:
	mov	rax, QWORD PTR blend_color@GOTPCREL[rip]
	mov	eax, DWORD PTR 12[rax]
	jmp	.L1417
	.cfi_endproc
.LFE599:
	.size	alpha_compare, .-alpha_compare
	.p2align 4,,15
	.globl	color_combiner_equation
	.type	color_combiner_equation, @function
color_combiner_equation:
.LFB600:
	.cfi_startproc
	mov	r9, QWORD PTR special_9bit_exttable@GOTPCREL[rip]
	movsx	rdi, edi
	movsx	rsi, esi
	mov	r8d, edx
	movsx	rcx, ecx
	and	r8d, 256
	mov	eax, DWORD PTR [r9+rdi*4]
	sub	eax, DWORD PTR [r9+rsi*4]
	neg	r8d
	or	r8d, edx
	mov	edx, DWORD PTR [r9+rcx*4]
	imul	eax, r8d
	sal	edx, 8
	lea	eax, 128[rax+rdx]
	and	eax, 131071
	ret
	.cfi_endproc
.LFE600:
	.size	color_combiner_equation, .-color_combiner_equation
	.p2align 4,,15
	.globl	alpha_combiner_equation
	.type	alpha_combiner_equation, @function
alpha_combiner_equation:
.LFB601:
	.cfi_startproc
	mov	r9, QWORD PTR special_9bit_exttable@GOTPCREL[rip]
	movsx	rdi, edi
	movsx	rsi, esi
	mov	r8d, edx
	movsx	rcx, ecx
	and	r8d, 256
	mov	eax, DWORD PTR [r9+rdi*4]
	sub	eax, DWORD PTR [r9+rsi*4]
	neg	r8d
	or	r8d, edx
	mov	edx, DWORD PTR [r9+rcx*4]
	imul	eax, r8d
	sal	edx, 8
	lea	eax, 128[rax+rdx]
	sar	eax, 8
	and	eax, 511
	ret
	.cfi_endproc
.LFE601:
	.size	alpha_combiner_equation, .-alpha_combiner_equation
	.p2align 4,,15
	.globl	blender_equation_cycle0
	.type	blender_equation_cycle0, @function
blender_equation_cycle0:
.LFB602:
	.cfi_startproc
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rcx, QWORD PTR blender2b_a@GOTPCREL[rip]
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	r9, QWORD PTR other_modes@GOTPCREL[rip]
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	mov	rax, QWORD PTR [rax]
	mov	rcx, QWORD PTR [rcx]
	mov	r10d, DWORD PTR 160[r9]
	mov	eax, DWORD PTR [rax]
	mov	r8d, DWORD PTR [rcx]
	sar	eax, 3
	sar	r8d, 3
	test	r10d, r10d
	je	.L1423
	mov	rcx, QWORD PTR blshifta@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	sar	eax, cl
	mov	rcx, QWORD PTR blshiftb@GOTPCREL[rip]
	and	eax, 60
	mov	ecx, DWORD PTR [rcx]
	sar	r8d, cl
	or	r8d, 3
.L1423:
	mov	r10, QWORD PTR blender1a_r@GOTPCREL[rip]
	lea	ecx, 1[r8]
	mov	r9d, DWORD PTR 92[r9]
	mov	r10, QWORD PTR [r10]
	mov	r11d, DWORD PTR [r10]
	mov	r10, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	r10, QWORD PTR [r10]
	imul	r11d, eax
	mov	ebx, DWORD PTR [r10]
	mov	r10, QWORD PTR blender1a_g@GOTPCREL[rip]
	imul	ebx, ecx
	mov	r10, QWORD PTR [r10]
	add	r11d, ebx
	mov	ebx, DWORD PTR [r10]
	mov	r10, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	r10, QWORD PTR [r10]
	imul	ebx, eax
	mov	ebp, DWORD PTR [r10]
	imul	ebp, ecx
	mov	r10d, ebp
	add	r10d, ebx
	mov	rbx, QWORD PTR blender1a_b@GOTPCREL[rip]
	mov	rbx, QWORD PTR [rbx]
	mov	ebp, DWORD PTR [rbx]
	imul	ebp, eax
	mov	ebx, ebp
	mov	rbp, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	rbp, QWORD PTR 0[rbp]
	imul	ecx, DWORD PTR 0[rbp]
	add	ecx, ebx
	test	r9d, r9d
	je	.L1427
	sar	r11d, 5
	sar	r10d, 5
	sar	ecx, 5
	and	r11d, 255
	and	r10d, 255
	and	ecx, 255
	mov	DWORD PTR [rdi], r11d
	mov	DWORD PTR [rsi], r10d
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	mov	DWORD PTR [rdx], ecx
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1427:
	.cfi_restore_state
	and	r8d, -4
	and	eax, -4
	mov	r9, QWORD PTR bldiv_hwaccurate_table@GOTPCREL[rip]
	lea	eax, 4[rax+r8]
	mov	r8d, r11d
	sar	ecx, 2
	sar	r8d, 2
	and	ecx, 2047
	sal	eax, 9
	and	r8d, 2047
	or	r8d, eax
	or	ecx, eax
	movsx	r8, r8d
	movsx	rcx, ecx
	movzx	r8d, BYTE PTR [r9+r8]
	mov	DWORD PTR [rdi], r8d
	mov	edi, r10d
	sar	edi, 2
	and	edi, 2047
	or	edi, eax
	movsx	rdi, edi
	movzx	edi, BYTE PTR [r9+rdi]
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	mov	DWORD PTR [rsi], edi
	movzx	eax, BYTE PTR [r9+rcx]
	mov	DWORD PTR [rdx], eax
	ret
	.cfi_endproc
.LFE602:
	.size	blender_equation_cycle0, .-blender_equation_cycle0
	.p2align 4,,15
	.globl	blender_equation_cycle0_2
	.type	blender_equation_cycle0_2, @function
blender_equation_cycle0_2:
.LFB603:
	.cfi_startproc
	mov	rcx, QWORD PTR blender2b_a@GOTPCREL[rip]
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rcx]
	mov	rax, QWORD PTR [rax]
	mov	r8d, DWORD PTR [rcx]
	mov	rcx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	r11d, DWORD PTR 160[rcx]
	sar	r8d, 3
	sar	eax, 3
	test	r11d, r11d
	je	.L1429
	mov	rcx, QWORD PTR pastblshifta@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	sar	eax, cl
	mov	rcx, QWORD PTR pastblshiftb@GOTPCREL[rip]
	and	eax, 60
	mov	ecx, DWORD PTR [rcx]
	sar	r8d, cl
	or	r8d, 3
.L1429:
	mov	rcx, QWORD PTR blender1a_r@GOTPCREL[rip]
	add	r8d, 1
	mov	rcx, QWORD PTR [rcx]
	mov	r9d, DWORD PTR [rcx]
	mov	rcx, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rcx]
	imul	r9d, eax
	mov	r10d, DWORD PTR [rcx]
	imul	r10d, r8d
	mov	ecx, r10d
	add	ecx, r9d
	sar	ecx, 5
	and	ecx, 255
	mov	DWORD PTR [rdi], ecx
	mov	rcx, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rcx]
	mov	edi, DWORD PTR [rcx]
	mov	rcx, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rcx]
	imul	edi, eax
	mov	r11d, DWORD PTR [rcx]
	imul	r11d, r8d
	mov	ecx, r11d
	add	ecx, edi
	sar	ecx, 5
	and	ecx, 255
	mov	DWORD PTR [rsi], ecx
	mov	rcx, QWORD PTR blender1a_b@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rcx]
	imul	eax, DWORD PTR [rcx]
	mov	rcx, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rcx]
	imul	r8d, DWORD PTR [rcx]
	add	eax, r8d
	sar	eax, 5
	and	eax, 255
	mov	DWORD PTR [rdx], eax
	ret
	.cfi_endproc
.LFE603:
	.size	blender_equation_cycle0_2, .-blender_equation_cycle0_2
	.p2align 4,,15
	.globl	blender_equation_cycle1
	.type	blender_equation_cycle1, @function
blender_equation_cycle1:
.LFB604:
	.cfi_startproc
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rcx, QWORD PTR blender2b_a@GOTPCREL[rip]
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	r9, QWORD PTR other_modes@GOTPCREL[rip]
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	mov	rax, QWORD PTR 8[rax]
	mov	rcx, QWORD PTR 8[rcx]
	mov	ebp, DWORD PTR 164[r9]
	mov	eax, DWORD PTR [rax]
	mov	r8d, DWORD PTR [rcx]
	sar	eax, 3
	sar	r8d, 3
	test	ebp, ebp
	je	.L1431
	mov	rcx, QWORD PTR blshifta@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	sar	eax, cl
	mov	rcx, QWORD PTR blshiftb@GOTPCREL[rip]
	and	eax, 60
	mov	ecx, DWORD PTR [rcx]
	sar	r8d, cl
	or	r8d, 3
.L1431:
	mov	r10, QWORD PTR blender1a_r@GOTPCREL[rip]
	lea	ecx, 1[r8]
	mov	r10, QWORD PTR 8[r10]
	mov	r11d, DWORD PTR [r10]
	mov	r10, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	r10, QWORD PTR 8[r10]
	imul	r11d, eax
	mov	ebx, DWORD PTR [r10]
	mov	r10, QWORD PTR blender1a_g@GOTPCREL[rip]
	imul	ebx, ecx
	mov	r10, QWORD PTR 8[r10]
	add	r11d, ebx
	mov	ebx, DWORD PTR [r10]
	mov	r10, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	r10, QWORD PTR 8[r10]
	imul	ebx, eax
	mov	ebp, DWORD PTR [r10]
	imul	ebp, ecx
	mov	r10d, ebp
	add	r10d, ebx
	mov	rbx, QWORD PTR blender1a_b@GOTPCREL[rip]
	mov	rbx, QWORD PTR 8[rbx]
	mov	ebp, DWORD PTR [rbx]
	imul	ebp, eax
	mov	ebx, ebp
	mov	rbp, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	rbp, QWORD PTR 8[rbp]
	imul	ecx, DWORD PTR 0[rbp]
	add	ecx, ebx
	mov	ebx, DWORD PTR 92[r9]
	test	ebx, ebx
	je	.L1435
	sar	r11d, 5
	sar	r10d, 5
	sar	ecx, 5
	and	r11d, 255
	and	r10d, 255
	and	ecx, 255
	mov	DWORD PTR [rdi], r11d
	mov	DWORD PTR [rsi], r10d
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	mov	DWORD PTR [rdx], ecx
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1435:
	.cfi_restore_state
	and	r8d, -4
	and	eax, -4
	mov	r9, QWORD PTR bldiv_hwaccurate_table@GOTPCREL[rip]
	lea	eax, 4[rax+r8]
	mov	r8d, r11d
	sar	ecx, 2
	sar	r8d, 2
	and	ecx, 2047
	sal	eax, 9
	and	r8d, 2047
	or	r8d, eax
	or	ecx, eax
	movsx	r8, r8d
	movsx	rcx, ecx
	movzx	r8d, BYTE PTR [r9+r8]
	mov	DWORD PTR [rdi], r8d
	mov	edi, r10d
	sar	edi, 2
	and	edi, 2047
	or	edi, eax
	movsx	rdi, edi
	movzx	edi, BYTE PTR [r9+rdi]
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	mov	DWORD PTR [rsi], edi
	movzx	eax, BYTE PTR [r9+rcx]
	mov	DWORD PTR [rdx], eax
	ret
	.cfi_endproc
.LFE604:
	.size	blender_equation_cycle1, .-blender_equation_cycle1
	.p2align 4,,15
	.globl	rightcvghex
	.type	rightcvghex, @function
rightcvghex:
.LFB605:
	.cfi_startproc
	and	edi, 7
	mov	eax, 240
	lea	ecx, 1[rdi]
	shr	ecx
	sar	eax, cl
	and	eax, esi
	ret
	.cfi_endproc
.LFE605:
	.size	rightcvghex, .-rightcvghex
	.p2align 4,,15
	.globl	leftcvghex
	.type	leftcvghex, @function
leftcvghex:
.LFB606:
	.cfi_startproc
	and	edi, 7
	mov	eax, 15
	lea	ecx, 1[rdi]
	shr	ecx
	sar	eax, cl
	and	eax, esi
	ret
	.cfi_endproc
.LFE606:
	.size	leftcvghex, .-leftcvghex
	.p2align 4,,15
	.globl	compute_cvg_flip
	.type	compute_cvg_flip, @function
compute_cvg_flip:
.LFB607:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movsx	rax, edi
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
	lea	rbx, [rax+rax*2]
	sub	rsp, 152
	.cfi_def_cfa_offset 208
	mov	r15, QWORD PTR span@GOTPCREL[rip]
	sal	rbx, 5
	lea	rax, [r15+rbx]
	mov	r13d, DWORD PTR [rax]
	mov	ebp, DWORD PTR 4[rax]
	mov	r12d, r13d
	sub	r12d, ebp
	js	.L1438
	mov	r14, QWORD PTR cvgbuf@GOTPCREL[rip]
	movsx	rax, ebp
	add	r12d, 1
	mov	QWORD PTR 24[rsp], rax
	movsx	rdx, r12d
	mov	esi, 255
	lea	rbx, 80[r15+rbx]
	add	rax, r14
	mov	rdi, rax
	mov	QWORD PTR 8[rsp], rax
	call	memfill@PLT
	lea	eax, 1[r13]
	mov	QWORD PTR 16[rsp], rbx
	mov	DWORD PTR 108[rsp], eax
	sub	eax, ebp
	mov	ebx, eax
	mov	DWORD PTR 124[rsp], eax
	mov	rax, QWORD PTR 8[rsp]
	neg	rax
	and	eax, 15
	cmp	eax, ebx
	mov	esi, eax
	mov	DWORD PTR 112[rsp], eax
	mov	eax, ebx
	cmovbe	eax, esi
	cmp	r12d, 16
	mov	r11d, eax
	cmovbe	r11d, r12d
	mov	eax, r11d
	add	rax, QWORD PTR 24[rsp]
	sub	r12d, r11d
	mov	DWORD PTR 128[rsp], r12d
	shr	r12d, 4
	mov	DWORD PTR 132[rsp], r12d
	sal	r12d, 4
	mov	DWORD PTR 44[rsp], r12d
	xor	r12d, r12d
	add	rax, r14
	mov	QWORD PTR 136[rsp], rax
	lea	eax, 1[rbp]
	mov	DWORD PTR 56[rsp], eax
	cdqe
	mov	QWORD PTR 48[rsp], rax
	lea	eax, 2[rbp]
	mov	DWORD PTR 60[rsp], eax
	cdqe
	mov	QWORD PTR 64[rsp], rax
	lea	eax, 3[rbp]
	mov	DWORD PTR 80[rsp], eax
	cdqe
	mov	QWORD PTR 72[rsp], rax
	lea	eax, 4[rbp]
	mov	DWORD PTR 84[rsp], eax
	cdqe
	mov	QWORD PTR 88[rsp], rax
	lea	eax, 5[rbp]
	mov	DWORD PTR 104[rsp], eax
	cdqe
	mov	QWORD PTR 96[rsp], rax
.L1480:
	lea	eax, -2[r12]
	mov	ecx, r12d
	mov	ebx, 10
	and	ecx, 1
	mov	DWORD PTR 8[rsp], eax
	mov	rax, QWORD PTR 16[rsp]
	sar	ebx, cl
	and	DWORD PTR 8[rsp], 4
	mov	r10d, ebx
	movzx	ecx, BYTE PTR 8[rsp]
	mov	edx, DWORD PTR [rax]
	sal	r10d, cl
	test	edx, edx
	je	.L1440
	cmp	ebp, r13d
	jg	.L1442
	mov	edx, r10d
	test	r11d, r11d
	not	edx
	je	.L1485
	mov	rax, QWORD PTR 24[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 1
	mov	eax, DWORD PTR 56[rsp]
	je	.L1470
	mov	rax, QWORD PTR 48[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 2
	mov	eax, DWORD PTR 60[rsp]
	je	.L1470
	mov	rax, QWORD PTR 64[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 3
	mov	eax, DWORD PTR 80[rsp]
	je	.L1470
	mov	rax, QWORD PTR 72[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 4
	mov	eax, DWORD PTR 84[rsp]
	je	.L1470
	mov	rax, QWORD PTR 88[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 5
	mov	eax, DWORD PTR 104[rsp]
	je	.L1470
	mov	rax, QWORD PTR 96[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 6
	lea	eax, 6[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 7
	lea	eax, 7[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 8
	lea	eax, 8[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 9
	lea	eax, 9[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 10
	lea	eax, 10[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 11
	lea	eax, 11[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 12
	lea	eax, 12[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 13
	lea	eax, 13[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 14
	lea	eax, 14[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r11d, 15
	lea	eax, 15[rbp]
	je	.L1470
	cdqe
	and	BYTE PTR [r14+rax], dl
	lea	eax, 16[rbp]
.L1470:
	cmp	DWORD PTR 124[rsp], r11d
	je	.L1442
.L1469:
	mov	r15d, DWORD PTR 44[rsp]
	test	r15d, r15d
	je	.L1472
	movd	xmm1, edx
	mov	r8d, DWORD PTR 132[rsp]
	mov	rdi, QWORD PTR 136[rsp]
	xor	ecx, ecx
	xor	esi, esi
	punpcklbw	xmm1, xmm1
	punpcklwd	xmm1, xmm1
	pshufd	xmm1, xmm1, 0
	.p2align 4,,10
	.p2align 3
.L1478:
	movdqa	xmm0, XMMWORD PTR [rdi+rcx]
	add	esi, 1
	pand	xmm0, xmm1
	movdqa	XMMWORD PTR [rdi+rcx], xmm0
	add	rcx, 16
	cmp	esi, r8d
	jb	.L1478
	mov	ebx, DWORD PTR 44[rsp]
	add	eax, ebx
	cmp	DWORD PTR 128[rsp], ebx
	je	.L1442
	.p2align 4,,10
	.p2align 3
.L1472:
	movsx	rcx, eax
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 1[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 2[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 3[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 4[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 5[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 6[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 7[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 8[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 9[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 10[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 11[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 12[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	and	BYTE PTR [r14+rcx], dl
	lea	ecx, 13[rax]
	cmp	r13d, ecx
	jl	.L1442
	movsx	rcx, ecx
	add	eax, 14
	and	BYTE PTR [r14+rcx], dl
	cmp	r13d, eax
	jl	.L1442
	cdqe
	and	BYTE PTR [r14+rax], dl
.L1442:
	add	r12d, 1
	add	QWORD PTR 16[rsp], 4
	cmp	r12d, 4
	jne	.L1480
.L1438:
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
.L1440:
	.cfi_restore_state
	mov	rsi, rax
	mov	eax, DWORD PTR -16[rax]
	mov	esi, DWORD PTR -32[rsi]
	mov	ecx, eax
	mov	DWORD PTR 36[rsp], eax
	mov	DWORD PTR 40[rsp], esi
	sar	esi, 3
	sar	ecx, 3
	cmp	ebp, esi
	jg	.L1455
	mov	eax, esi
	mov	r8d, DWORD PTR 112[rsp]
	mov	edx, r10d
	sub	eax, ebp
	not	edx
	lea	edi, 1[rax]
	cmp	edi, r8d
	mov	r15d, edi
	cmovbe	r8d, edi
	cmp	edi, 16
	cmovbe	r8d, edi
	test	r8d, r8d
	je	.L1482
	mov	rax, QWORD PTR 24[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 1
	mov	eax, DWORD PTR 56[rsp]
	je	.L1448
	mov	rax, QWORD PTR 48[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 2
	mov	eax, DWORD PTR 60[rsp]
	je	.L1448
	mov	rax, QWORD PTR 64[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 3
	mov	eax, DWORD PTR 80[rsp]
	je	.L1448
	mov	rax, QWORD PTR 72[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 4
	mov	eax, DWORD PTR 84[rsp]
	je	.L1448
	mov	rax, QWORD PTR 88[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 5
	mov	eax, DWORD PTR 104[rsp]
	je	.L1448
	mov	rax, QWORD PTR 96[rsp]
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 6
	lea	eax, 6[rbp]
	je	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 7
	lea	eax, 7[rbp]
	je	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 8
	lea	eax, 8[rbp]
	je	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 9
	lea	eax, 9[rbp]
	je	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 10
	lea	eax, 10[rbp]
	je	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 11
	lea	eax, 11[rbp]
	je	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 12
	lea	eax, 12[rbp]
	je	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 13
	lea	eax, 13[rbp]
	je	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 14
	lea	eax, 14[rbp]
	je	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 16
	lea	eax, 15[rbp]
	jne	.L1448
	cdqe
	and	BYTE PTR [r14+rax], dl
	lea	eax, 16[rbp]
.L1448:
	cmp	edi, r8d
	je	.L1455
.L1447:
	sub	r15d, r8d
	mov	edi, r8d
	mov	DWORD PTR 116[rsp], r15d
	shr	r15d, 4
	mov	r9d, r15d
	sal	r9d, 4
	test	r9d, r9d
	mov	DWORD PTR 120[rsp], r9d
	je	.L1450
	movd	xmm1, edx
	add	rdi, QWORD PTR 24[rsp]
	xor	r8d, r8d
	punpcklbw	xmm1, xmm1
	lea	r9, [r14+rdi]
	xor	edi, edi
	punpcklwd	xmm1, xmm1
	pshufd	xmm1, xmm1, 0
	.p2align 4,,10
	.p2align 3
.L1456:
	movdqa	xmm0, XMMWORD PTR [r9+rdi]
	add	r8d, 1
	pand	xmm0, xmm1
	movdqa	XMMWORD PTR [r9+rdi], xmm0
	add	rdi, 16
	cmp	r8d, r15d
	jb	.L1456
	mov	edi, DWORD PTR 120[rsp]
	add	eax, edi
	cmp	DWORD PTR 116[rsp], edi
	je	.L1455
	.p2align 4,,10
	.p2align 3
.L1450:
	movsx	rdi, eax
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 1[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 2[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 3[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 4[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 5[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 6[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 7[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 8[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 9[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 10[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 11[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 12[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 13[rax]
	cmp	esi, edi
	jl	.L1455
	movsx	rdi, edi
	add	eax, 14
	and	BYTE PTR [r14+rdi], dl
	cmp	esi, eax
	jl	.L1455
	cdqe
	and	BYTE PTR [r14+rax], dl
.L1455:
	cmp	r13d, ecx
	jl	.L1635
	mov	edx, r10d
	movsx	r10, ecx
	mov	edi, DWORD PTR 108[rsp]
	lea	rax, [r14+r10]
	mov	r15d, r13d
	not	edx
	neg	rax
	sub	edi, ecx
	and	eax, 15
	cmp	eax, edi
	cmova	eax, edi
	sub	r15d, ecx
	add	r15d, 1
	mov	r8d, eax
	cmp	r15d, 16
	cmovbe	r8d, r15d
	test	r8d, r8d
	je	.L1484
	and	BYTE PTR [r14+r10], dl
	cmp	r8d, 1
	lea	eax, 1[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 2
	lea	eax, 2[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 3
	lea	eax, 3[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 4
	lea	eax, 4[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 5
	lea	eax, 5[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 6
	lea	eax, 6[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 7
	lea	eax, 7[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 8
	lea	eax, 8[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 9
	lea	eax, 9[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 10
	lea	eax, 10[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 11
	lea	eax, 11[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 12
	lea	eax, 12[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 13
	lea	eax, 13[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 14
	lea	eax, 14[rcx]
	je	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	cmp	r8d, 16
	lea	eax, 15[rcx]
	jne	.L1461
	cdqe
	and	BYTE PTR [r14+rax], dl
	lea	eax, 16[rcx]
.L1461:
	cmp	edi, r8d
	je	.L1445
.L1460:
	sub	r15d, r8d
	mov	edi, r8d
	mov	DWORD PTR 120[rsp], r15d
	shr	r15d, 4
	mov	r9d, r15d
	sal	r9d, 4
	test	r9d, r9d
	mov	DWORD PTR 116[rsp], r9d
	je	.L1463
	movd	xmm1, edx
	add	rdi, r10
	xor	r8d, r8d
	lea	r9, [r14+rdi]
	xor	edi, edi
	punpcklbw	xmm1, xmm1
	punpcklwd	xmm1, xmm1
	pshufd	xmm1, xmm1, 0
	.p2align 4,,10
	.p2align 3
.L1468:
	movdqa	xmm0, XMMWORD PTR [r9+rdi]
	add	r8d, 1
	pand	xmm0, xmm1
	movdqa	XMMWORD PTR [r9+rdi], xmm0
	add	rdi, 16
	cmp	r15d, r8d
	ja	.L1468
	mov	edi, DWORD PTR 116[rsp]
	mov	r9d, DWORD PTR 120[rsp]
	add	eax, edi
	cmp	edi, r9d
	je	.L1445
	.p2align 4,,10
	.p2align 3
.L1463:
	movsx	rdi, eax
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 1[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 2[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 3[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 4[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 5[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 6[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 7[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 8[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 9[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 10[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 11[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 12[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	and	BYTE PTR [r14+rdi], dl
	lea	edi, 13[rax]
	cmp	r13d, edi
	jl	.L1445
	movsx	rdi, edi
	add	eax, 14
	and	BYTE PTR [r14+rdi], dl
	cmp	r13d, eax
	jl	.L1445
	cdqe
	and	BYTE PTR [r14+rax], dl
.L1445:
	cmp	ecx, esi
	je	.L1636
	mov	ecx, DWORD PTR 36[rsp]
	mov	edx, DWORD PTR 8[rsp]
	mov	eax, 240
	movsx	rsi, esi
	add	r12d, 1
	add	QWORD PTR 16[rsp], 4
	and	ecx, 7
	add	ecx, 1
	shr	ecx
	sar	eax, cl
	mov	ecx, edx
	and	eax, ebx
	sal	eax, cl
	mov	ecx, DWORD PTR 40[rsp]
	or	BYTE PTR [r14+r10], al
	mov	eax, 15
	and	ecx, 7
	add	ecx, 1
	shr	ecx
	sar	eax, cl
	mov	ecx, edx
	and	eax, ebx
	sal	eax, cl
	or	BYTE PTR [r14+rsi], al
	cmp	r12d, 4
	jne	.L1480
	jmp	.L1438
	.p2align 4,,10
	.p2align 3
.L1482:
	mov	eax, ebp
	jmp	.L1447
	.p2align 4,,10
	.p2align 3
.L1484:
	mov	eax, ecx
	jmp	.L1460
	.p2align 4,,10
	.p2align 3
.L1485:
	mov	eax, ebp
	jmp	.L1469
	.p2align 4,,10
	.p2align 3
.L1636:
	mov	ecx, DWORD PTR 36[rsp]
	mov	eax, 240
	mov	edx, 15
	add	r12d, 1
	add	QWORD PTR 16[rsp], 4
	and	ecx, 7
	add	ecx, 1
	shr	ecx
	sar	eax, cl
	mov	ecx, DWORD PTR 40[rsp]
	and	ecx, 7
	add	ecx, 1
	shr	ecx
	sar	edx, cl
	movzx	ecx, BYTE PTR 8[rsp]
	and	eax, edx
	and	eax, ebx
	sal	eax, cl
	or	BYTE PTR [r14+r10], al
	cmp	r12d, 4
	jne	.L1480
	jmp	.L1438
.L1635:
	movsx	r10, ecx
	jmp	.L1445
	.cfi_endproc
.LFE607:
	.size	compute_cvg_flip, .-compute_cvg_flip
	.p2align 4,,15
	.globl	compute_cvg_noflip
	.type	compute_cvg_noflip, @function
compute_cvg_noflip:
.LFB608:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movsx	rax, edi
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
	lea	rbx, [rax+rax*2]
	sub	rsp, 136
	.cfi_def_cfa_offset 192
	mov	r15, QWORD PTR span@GOTPCREL[rip]
	sal	rbx, 5
	lea	rax, [r15+rbx]
	mov	r10d, DWORD PTR 4[rax]
	mov	r13d, DWORD PTR [rax]
	mov	r12d, r10d
	mov	DWORD PTR 16[rsp], r10d
	sub	r12d, r13d
	js	.L1637
	mov	rbp, QWORD PTR cvgbuf@GOTPCREL[rip]
	movsx	rax, r13d
	add	r12d, 1
	movsx	rdx, r12d
	mov	esi, 255
	mov	QWORD PTR 8[rsp], rax
	lea	rbx, 80[r15+rbx]
	lea	r14, 0[rbp+rax]
	mov	rdi, r14
	neg	r14
	call	memfill@PLT
	mov	r10d, DWORD PTR 16[rsp]
	mov	QWORD PTR [rsp], rbx
	lea	eax, 1[r10]
	mov	DWORD PTR 92[rsp], eax
	sub	eax, r13d
	mov	ebx, eax
	mov	DWORD PTR 108[rsp], eax
	mov	rax, r14
	and	eax, 15
	cmp	eax, ebx
	mov	edi, eax
	mov	DWORD PTR 96[rsp], eax
	mov	eax, ebx
	cmovbe	eax, edi
	cmp	r12d, 16
	mov	r15d, eax
	cmovbe	r15d, r12d
	mov	eax, r15d
	add	rax, QWORD PTR 8[rsp]
	sub	r12d, r15d
	mov	DWORD PTR 112[rsp], r12d
	shr	r12d, 4
	mov	DWORD PTR 116[rsp], r12d
	sal	r12d, 4
	mov	DWORD PTR 28[rsp], r12d
	xor	r12d, r12d
	add	rax, rbp
	mov	QWORD PTR 120[rsp], rax
	lea	eax, 1[r13]
	mov	DWORD PTR 40[rsp], eax
	cdqe
	mov	QWORD PTR 32[rsp], rax
	lea	eax, 2[r13]
	mov	DWORD PTR 44[rsp], eax
	cdqe
	mov	QWORD PTR 48[rsp], rax
	lea	eax, 3[r13]
	mov	DWORD PTR 64[rsp], eax
	cdqe
	mov	QWORD PTR 56[rsp], rax
	lea	eax, 4[r13]
	mov	DWORD PTR 68[rsp], eax
	cdqe
	mov	QWORD PTR 72[rsp], rax
	lea	eax, 5[r13]
	mov	DWORD PTR 88[rsp], eax
	cdqe
	mov	QWORD PTR 80[rsp], rax
.L1679:
	lea	eax, -2[r12]
	mov	ecx, r12d
	mov	ebx, 10
	and	ecx, 1
	mov	DWORD PTR 16[rsp], eax
	mov	rax, QWORD PTR [rsp]
	sar	ebx, cl
	and	DWORD PTR 16[rsp], 4
	mov	r11d, ebx
	movzx	ecx, BYTE PTR 16[rsp]
	mov	esi, DWORD PTR [rax]
	sal	r11d, cl
	test	esi, esi
	je	.L1639
	cmp	r13d, r10d
	jg	.L1641
	mov	edx, r11d
	test	r15d, r15d
	not	edx
	je	.L1684
	mov	rax, QWORD PTR 8[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 1
	mov	eax, DWORD PTR 40[rsp]
	je	.L1669
	mov	rax, QWORD PTR 32[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 2
	mov	eax, DWORD PTR 44[rsp]
	je	.L1669
	mov	rax, QWORD PTR 48[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 3
	mov	eax, DWORD PTR 64[rsp]
	je	.L1669
	mov	rax, QWORD PTR 56[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 4
	mov	eax, DWORD PTR 68[rsp]
	je	.L1669
	mov	rax, QWORD PTR 72[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 5
	mov	eax, DWORD PTR 88[rsp]
	je	.L1669
	mov	rax, QWORD PTR 80[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 6
	lea	eax, 6[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 7
	lea	eax, 7[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 8
	lea	eax, 8[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 9
	lea	eax, 9[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 10
	lea	eax, 10[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 11
	lea	eax, 11[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 12
	lea	eax, 12[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 13
	lea	eax, 13[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 14
	lea	eax, 14[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r15d, 15
	lea	eax, 15[r13]
	je	.L1669
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	lea	eax, 16[r13]
.L1669:
	cmp	DWORD PTR 108[rsp], r15d
	je	.L1641
.L1668:
	mov	ecx, DWORD PTR 28[rsp]
	test	ecx, ecx
	je	.L1671
	movd	xmm1, edx
	mov	r8d, DWORD PTR 116[rsp]
	mov	rdi, QWORD PTR 120[rsp]
	xor	ecx, ecx
	xor	esi, esi
	punpcklbw	xmm1, xmm1
	punpcklwd	xmm1, xmm1
	pshufd	xmm1, xmm1, 0
	.p2align 4,,10
	.p2align 3
.L1677:
	movdqa	xmm0, XMMWORD PTR [rdi+rcx]
	add	esi, 1
	pand	xmm0, xmm1
	movdqa	XMMWORD PTR [rdi+rcx], xmm0
	add	rcx, 16
	cmp	esi, r8d
	jb	.L1677
	mov	ebx, DWORD PTR 28[rsp]
	add	eax, ebx
	cmp	DWORD PTR 112[rsp], ebx
	je	.L1641
	.p2align 4,,10
	.p2align 3
.L1671:
	movsx	rcx, eax
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 1[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 2[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 3[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 4[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 5[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 6[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 7[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 8[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 9[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 10[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 11[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 12[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 13[rax]
	cmp	r10d, ecx
	jl	.L1641
	movsx	rcx, ecx
	add	eax, 14
	and	BYTE PTR 0[rbp+rcx], dl
	cmp	r10d, eax
	jl	.L1641
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
.L1641:
	add	r12d, 1
	add	QWORD PTR [rsp], 4
	cmp	r12d, 4
	jne	.L1679
.L1637:
	add	rsp, 136
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
.L1639:
	.cfi_restore_state
	mov	rdi, rax
	mov	eax, DWORD PTR -16[rax]
	mov	esi, DWORD PTR -32[rdi]
	mov	edi, eax
	mov	DWORD PTR 20[rsp], eax
	sar	edi, 3
	mov	DWORD PTR 24[rsp], esi
	sar	esi, 3
	cmp	r13d, edi
	jg	.L1654
	mov	eax, edi
	mov	r8d, DWORD PTR 96[rsp]
	mov	edx, r11d
	sub	eax, r13d
	not	edx
	lea	ecx, 1[rax]
	cmp	ecx, r8d
	mov	r14d, ecx
	cmovbe	r8d, ecx
	cmp	ecx, 16
	cmovbe	r8d, ecx
	test	r8d, r8d
	je	.L1681
	mov	rax, QWORD PTR 8[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 1
	mov	eax, DWORD PTR 40[rsp]
	je	.L1647
	mov	rax, QWORD PTR 32[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 2
	mov	eax, DWORD PTR 44[rsp]
	je	.L1647
	mov	rax, QWORD PTR 48[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 3
	mov	eax, DWORD PTR 64[rsp]
	je	.L1647
	mov	rax, QWORD PTR 56[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 4
	mov	eax, DWORD PTR 68[rsp]
	je	.L1647
	mov	rax, QWORD PTR 72[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 5
	mov	eax, DWORD PTR 88[rsp]
	je	.L1647
	mov	rax, QWORD PTR 80[rsp]
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 6
	lea	eax, 6[r13]
	je	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 7
	lea	eax, 7[r13]
	je	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 8
	lea	eax, 8[r13]
	je	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 9
	lea	eax, 9[r13]
	je	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 10
	lea	eax, 10[r13]
	je	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 11
	lea	eax, 11[r13]
	je	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 12
	lea	eax, 12[r13]
	je	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 13
	lea	eax, 13[r13]
	je	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 14
	lea	eax, 14[r13]
	je	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 16
	lea	eax, 15[r13]
	jne	.L1647
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	lea	eax, 16[r13]
.L1647:
	cmp	ecx, r8d
	je	.L1654
.L1646:
	sub	r14d, r8d
	mov	ecx, r8d
	mov	DWORD PTR 100[rsp], r14d
	shr	r14d, 4
	mov	r9d, r14d
	sal	r9d, 4
	test	r9d, r9d
	mov	DWORD PTR 104[rsp], r9d
	je	.L1649
	movd	xmm1, edx
	add	rcx, QWORD PTR 8[rsp]
	xor	r8d, r8d
	punpcklbw	xmm1, xmm1
	lea	r9, 0[rbp+rcx]
	xor	ecx, ecx
	punpcklwd	xmm1, xmm1
	pshufd	xmm1, xmm1, 0
	.p2align 4,,10
	.p2align 3
.L1655:
	movdqa	xmm0, XMMWORD PTR [r9+rcx]
	add	r8d, 1
	pand	xmm0, xmm1
	movdqa	XMMWORD PTR [r9+rcx], xmm0
	add	rcx, 16
	cmp	r8d, r14d
	jb	.L1655
	mov	ecx, DWORD PTR 104[rsp]
	add	eax, ecx
	cmp	DWORD PTR 100[rsp], ecx
	je	.L1654
	.p2align 4,,10
	.p2align 3
.L1649:
	movsx	rcx, eax
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 1[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 2[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 3[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 4[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 5[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 6[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 7[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 8[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 9[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 10[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 11[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 12[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 13[rax]
	cmp	edi, ecx
	jl	.L1654
	movsx	rcx, ecx
	add	eax, 14
	and	BYTE PTR 0[rbp+rcx], dl
	cmp	edi, eax
	jl	.L1654
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
.L1654:
	cmp	r10d, esi
	jl	.L1644
	movsx	r9, esi
	mov	ecx, DWORD PTR 92[rsp]
	mov	r14d, r10d
	lea	rax, 0[rbp+r9]
	mov	edx, r11d
	not	edx
	neg	rax
	sub	ecx, esi
	and	eax, 15
	cmp	eax, ecx
	cmova	eax, ecx
	sub	r14d, esi
	add	r14d, 1
	mov	r8d, eax
	cmp	r14d, 16
	cmovbe	r8d, r14d
	test	r8d, r8d
	je	.L1683
	and	BYTE PTR 0[rbp+r9], dl
	cmp	r8d, 1
	lea	eax, 1[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 2
	lea	eax, 2[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 3
	lea	eax, 3[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 4
	lea	eax, 4[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 5
	lea	eax, 5[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 6
	lea	eax, 6[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 7
	lea	eax, 7[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 8
	lea	eax, 8[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 9
	lea	eax, 9[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 10
	lea	eax, 10[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 11
	lea	eax, 11[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 12
	lea	eax, 12[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 13
	lea	eax, 13[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 14
	lea	eax, 14[rsi]
	je	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	cmp	r8d, 16
	lea	eax, 15[rsi]
	jne	.L1660
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
	lea	eax, 16[rsi]
.L1660:
	cmp	ecx, r8d
	je	.L1644
.L1659:
	sub	r14d, r8d
	mov	ecx, r8d
	mov	r11d, r14d
	mov	DWORD PTR 100[rsp], r14d
	shr	r11d, 4
	mov	r14d, r11d
	sal	r14d, 4
	test	r14d, r14d
	je	.L1662
	movd	xmm1, edx
	add	rcx, r9
	xor	r8d, r8d
	lea	r9, 0[rbp+rcx]
	xor	ecx, ecx
	punpcklbw	xmm1, xmm1
	punpcklwd	xmm1, xmm1
	pshufd	xmm1, xmm1, 0
	.p2align 4,,10
	.p2align 3
.L1667:
	movdqa	xmm0, XMMWORD PTR [r9+rcx]
	add	r8d, 1
	pand	xmm0, xmm1
	movdqa	XMMWORD PTR [r9+rcx], xmm0
	add	rcx, 16
	cmp	r11d, r8d
	ja	.L1667
	add	eax, r14d
	cmp	r14d, DWORD PTR 100[rsp]
	je	.L1644
	.p2align 4,,10
	.p2align 3
.L1662:
	movsx	rcx, eax
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 1[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 2[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 3[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 4[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 5[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 6[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 7[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 8[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 9[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 10[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 11[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 12[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	and	BYTE PTR 0[rbp+rcx], dl
	lea	ecx, 13[rax]
	cmp	r10d, ecx
	jl	.L1644
	movsx	rcx, ecx
	add	eax, 14
	and	BYTE PTR 0[rbp+rcx], dl
	cmp	r10d, eax
	jl	.L1644
	cdqe
	and	BYTE PTR 0[rbp+rax], dl
.L1644:
	cmp	edi, esi
	je	.L1834
	mov	ecx, DWORD PTR 20[rsp]
	mov	edx, DWORD PTR 16[rsp]
	mov	eax, 15
	movsx	rdi, edi
	movsx	rsi, esi
	add	r12d, 1
	add	QWORD PTR [rsp], 4
	and	ecx, 7
	add	ecx, 1
	shr	ecx
	sar	eax, cl
	mov	ecx, edx
	and	eax, ebx
	sal	eax, cl
	mov	ecx, DWORD PTR 24[rsp]
	or	BYTE PTR 0[rbp+rdi], al
	mov	eax, 240
	and	ecx, 7
	add	ecx, 1
	shr	ecx
	sar	eax, cl
	mov	ecx, edx
	and	eax, ebx
	sal	eax, cl
	or	BYTE PTR 0[rbp+rsi], al
	cmp	r12d, 4
	jne	.L1679
	jmp	.L1637
	.p2align 4,,10
	.p2align 3
.L1683:
	mov	eax, esi
	jmp	.L1659
	.p2align 4,,10
	.p2align 3
.L1681:
	mov	eax, r13d
	jmp	.L1646
	.p2align 4,,10
	.p2align 3
.L1684:
	mov	eax, r13d
	jmp	.L1668
	.p2align 4,,10
	.p2align 3
.L1834:
	mov	ecx, DWORD PTR 20[rsp]
	mov	eax, 15
	mov	edx, 240
	movsx	rdi, edi
	add	r12d, 1
	add	QWORD PTR [rsp], 4
	and	ecx, 7
	add	ecx, 1
	shr	ecx
	sar	eax, cl
	mov	ecx, DWORD PTR 24[rsp]
	and	ecx, 7
	add	ecx, 1
	shr	ecx
	sar	edx, cl
	movzx	ecx, BYTE PTR 16[rsp]
	and	eax, edx
	and	eax, ebx
	sal	eax, cl
	or	BYTE PTR 0[rbp+rdi], al
	cmp	r12d, 4
	jne	.L1679
	jmp	.L1637
	.cfi_endproc
.LFE608:
	.size	compute_cvg_noflip, .-compute_cvg_noflip
	.p2align 4,,15
	.globl	z_decompress
	.type	z_decompress, @function
z_decompress:
.LFB625:
	.cfi_startproc
	mov	rax, QWORD PTR z_complete_dec_table@GOTPCREL[rip]
	and	edi, 65532
	mov	eax, DWORD PTR [rdi+rax]
	ret
	.cfi_endproc
.LFE625:
	.size	z_decompress, .-z_decompress
	.p2align 4,,15
	.globl	z_build_com_table
	.type	z_build_com_table, @function
z_build_com_table:
.LFB626:
	.cfi_startproc
	mov	rdi, QWORD PTR z_com_table@GOTPCREL[rip]
	lea	rsi, .L1839[rip]
	xor	eax, eax
	.p2align 4,,10
	.p2align 3
.L1848:
	mov	ecx, eax
	mov	edx, eax
	sar	ecx, 11
	sub	ecx, 64
	cmp	ecx, 63
	ja	.L1837
	movsx	rcx, DWORD PTR [rsi+rcx*4]
	add	rcx, rsi
	jmp	rcx
	.section	.rodata
	.align 4
	.align 4
.L1839:
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1838-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1840-.L1839
	.long	.L1841-.L1839
	.long	.L1841-.L1839
	.long	.L1841-.L1839
	.long	.L1841-.L1839
	.long	.L1841-.L1839
	.long	.L1841-.L1839
	.long	.L1841-.L1839
	.long	.L1841-.L1839
	.long	.L1842-.L1839
	.long	.L1842-.L1839
	.long	.L1842-.L1839
	.long	.L1842-.L1839
	.long	.L1843-.L1839
	.long	.L1843-.L1839
	.long	.L1844-.L1839
	.long	.L1845-.L1839
	.text
	.p2align 4,,10
	.p2align 3
.L1843:
	add	edx, edx
	and	dx, 8188
	or	dx, -24576
	.p2align 4,,10
	.p2align 3
.L1846:
	mov	WORD PTR [rdi+rax*2], dx
	add	rax, 1
	cmp	rax, 262144
	jne	.L1848
	rep ret
	.p2align 4,,10
	.p2align 3
.L1842:
	mov	edx, eax
	and	dx, 8188
	or	dx, -32768
	jmp	.L1846
	.p2align 4,,10
	.p2align 3
.L1841:
	sar	edx
	and	dx, 8188
	or	dh, 96
	jmp	.L1846
	.p2align 4,,10
	.p2align 3
.L1840:
	sar	edx, 2
	and	dx, 8188
	or	dh, 64
	jmp	.L1846
	.p2align 4,,10
	.p2align 3
.L1838:
	sar	edx, 3
	and	dx, 8188
	or	dh, 32
	jmp	.L1846
	.p2align 4,,10
	.p2align 3
.L1844:
	sal	edx, 2
	and	dx, 8188
	or	dx, -16384
	jmp	.L1846
.L1845:
	sal	edx, 2
	and	dx, 8188
	or	dx, -8192
	jmp	.L1846
	.p2align 4,,10
	.p2align 3
.L1837:
	mov	edx, eax
	sar	edx, 4
	and	dx, 8188
	jmp	.L1846
	.cfi_endproc
.LFE626:
	.size	z_build_com_table, .-z_build_com_table
	.p2align 4,,15
	.globl	precalc_cvmask_derivatives
	.type	precalc_cvmask_derivatives, @function
precalc_cvmask_derivatives:
.LFB627:
	.cfi_startproc
	movdqa	xmm0, XMMWORD PTR .LC3[rip]
	xor	ecx, ecx
	mov	rax, QWORD PTR cvarray@GOTPCREL[rip]
	xor	r8d, r8d
	mov	r9d, 61440
	movdqa	XMMWORD PTR -40[rsp], xmm0
	lea	rsi, 1[rax]
	xor	eax, eax
	movdqa	xmm0, XMMWORD PTR .LC4[rip]
	movdqa	XMMWORD PTR -24[rsp], xmm0
	jmp	.L1851
	.p2align 4,,10
	.p2align 3
.L1852:
	mov	ecx, eax
	mov	edx, eax
	xor	edi, edi
	and	ecx, 2
	and	edx, 8
	movzx	ecx, cl
	movzx	edx, dl
	sal	ecx, 4
	sal	edx, 4
	or	edx, ecx
	mov	ecx, eax
	and	ecx, 5
	or	edx, ecx
	mov	ecx, eax
	and	ecx, 16
	movzx	ecx, cl
	sal	ecx, 4
	or	edx, ecx
	mov	ecx, eax
	and	ecx, 64
	movzx	ecx, cl
	sal	ecx, 4
	or	edx, ecx
	mov	ecx, eax
	and	ecx, 32
	movzx	ecx, cl
	sal	ecx, 8
	or	edx, ecx
	mov	ecx, eax
	and	ecx, -128
	movzx	ecx, cl
	sal	ecx, 8
	or	edx, ecx
	test	dl, 5
	setne	dil
	xor	ecx, ecx
	sal	edi, 3
	test	dl, -96
	setne	cl
	sal	ecx, 2
	or	ecx, edi
	xor	edi, edi
	test	dh, 160
	setne	dil
	or	ecx, edi
	xor	edi, edi
	test	dh, 5
	setne	dil
	movzx	edx, dx
	add	edi, edi
	or	ecx, edi
	mov	edi, r9d
	movsx	rcx, cx
	movzx	r8d, BYTE PTR -40[rsp+rcx]
	movzx	ecx, r8b
	sal	ecx, 2
	sar	edi, cl
	mov	ecx, r8d
	xor	ecx, 3
	and	edi, edx
	movzx	ecx, cl
	sal	ecx, 2
	sar	edi, cl
	movzx	edi, di
	movzx	ecx, BYTE PTR -24[rsp+rdi]
.L1851:
	mov	edx, eax
	mov	edi, eax
	mov	r11d, eax
	sar	edx, 7
	and	edi, 1
	sar	r11d, 3
	mov	BYTE PTR [rsi], dl
	add	edx, edi
	mov	edi, eax
	sar	edi
	mov	r10d, eax
	and	r11d, 1
	and	edi, 1
	sar	r10d, 4
	mov	BYTE PTR 1[rsi], cl
	add	edi, edx
	mov	edx, eax
	and	r10d, 1
	sar	edx, 2
	mov	BYTE PTR 2[rsi], r8b
	add	rsi, 4
	and	edx, 1
	add	edx, edi
	mov	edi, eax
	add	r11d, edx
	sar	edi, 5
	mov	edx, eax
	add	r10d, r11d
	and	edi, 1
	sar	edx, 6
	add	edi, r10d
	and	edx, 1
	add	eax, 1
	add	edx, edi
	mov	BYTE PTR -5[rsi], dl
	cmp	eax, 256
	jne	.L1852
	rep ret
	.cfi_endproc
.LFE627:
	.size	precalc_cvmask_derivatives, .-precalc_cvmask_derivatives
	.p2align 4,,15
	.globl	decompress_cvmask_frombyte
	.type	decompress_cvmask_frombyte, @function
decompress_cvmask_frombyte:
.LFB628:
	.cfi_startproc
	mov	edx, edi
	mov	eax, edi
	and	edx, 2
	and	eax, 8
	movzx	edx, dl
	movzx	eax, al
	sal	edx, 4
	sal	eax, 4
	or	eax, edx
	mov	edx, edi
	and	edx, 5
	or	eax, edx
	mov	edx, edi
	and	edx, 16
	movzx	edx, dl
	sal	edx, 4
	or	eax, edx
	mov	edx, edi
	and	edx, 32
	movzx	edx, dl
	sal	edx, 8
	or	eax, edx
	mov	edx, edi
	and	edi, -128
	and	edx, 64
	movzx	edi, dil
	movzx	edx, dl
	sal	edi, 8
	sal	edx, 4
	or	eax, edx
	or	eax, edi
	ret
	.cfi_endproc
.LFE628:
	.size	decompress_cvmask_frombyte, .-decompress_cvmask_frombyte
	.p2align 4,,15
	.globl	lookup_cvmask_derivatives
	.type	lookup_cvmask_derivatives, @function
lookup_cvmask_derivatives:
.LFB629:
	.cfi_startproc
	mov	rax, QWORD PTR cvarray@GOTPCREL[rip]
	mov	edi, edi
	lea	rax, [rax+rdi*4]
	movzx	r10d, BYTE PTR 1[rax]
	movzx	r9d, BYTE PTR 2[rax]
	movzx	edi, BYTE PTR 3[rax]
	movzx	eax, BYTE PTR [rax]
	mov	DWORD PTR [rcx], eax
	mov	DWORD PTR [r8], r10d
	mov	BYTE PTR [rsi], r9b
	mov	BYTE PTR [rdx], dil
	ret
	.cfi_endproc
.LFE629:
	.size	lookup_cvmask_derivatives, .-lookup_cvmask_derivatives
	.p2align 4,,15
	.globl	z_store
	.type	z_store, @function
z_store:
.LFB630:
	.cfi_startproc
	mov	rax, QWORD PTR z_com_table@GOTPCREL[rip]
	and	esi, 262143
	movzx	ecx, WORD PTR [rax+rsi*2]
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	cmp	DWORD PTR [rax], edi
	jb	.L1855
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r8d, edx
	mov	esi, edi
	sar	r8d, 2
	xor	esi, 1
	mov	edi, edi
	or	ecx, r8d
	and	edx, 3
	mov	rax, QWORD PTR [rax]
	mov	WORD PTR [rax+rsi*2], cx
	mov	rax, QWORD PTR hidden_bits@GOTPCREL[rip]
	mov	BYTE PTR [rax+rdi], dl
.L1855:
	rep ret
	.cfi_endproc
.LFE630:
	.size	z_store, .-z_store
	.p2align 4,,15
	.globl	dz_decompress
	.type	dz_decompress, @function
dz_decompress:
.LFB631:
	.cfi_startproc
	mov	ecx, edi
	mov	eax, 1
	sal	eax, cl
	ret
	.cfi_endproc
.LFE631:
	.size	dz_decompress, .-dz_decompress
	.p2align 4,,15
	.globl	dz_compress
	.type	dz_compress, @function
dz_compress:
.LFB632:
	.cfi_startproc
	mov	edx, edi
	and	edx, 65280
	cmp	edx, 1
	sbb	eax, eax
	and	eax, -8
	add	eax, 12
	cmp	edx, 1
	sbb	edx, edx
	not	edx
	and	edx, 8
	test	edi, 61680
	cmove	eax, edx
	mov	edx, eax
	or	edx, 2
	test	edi, 52428
	cmovne	eax, edx
	mov	edx, eax
	or	edx, 1
	and	edi, 43690
	cmovne	eax, edx
	ret
	.cfi_endproc
.LFE632:
	.size	dz_compress, .-dz_compress
	.p2align 4,,15
	.globl	z_compare
	.type	z_compare, @function
z_compare:
.LFB633:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r10d, ecx
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
	sub	rsp, 8
	.cfi_def_cfa_offset 64
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rbx, QWORD PTR 64[rsp]
	mov	ecx, DWORD PTR 124[rax]
	test	ecx, ecx
	je	.L1869
	mov	rcx, QWORD PTR idxlim16@GOTPCREL[rip]
	cmp	DWORD PTR [rcx], edi
	jb	.L1870
	mov	rcx, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	r11d, edi
	mov	edi, edi
	xor	r11d, 1
	mov	r14d, 4
	and	esi, 262143
	mov	r15d, r14d
	mov	r12d, esi
	mov	rsi, QWORD PTR blshifta@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rcx]
	movzx	r11d, WORD PTR [rcx+r11*2]
	mov	rcx, QWORD PTR hidden_bits@GOTPCREL[rip]
	movzx	ecx, BYTE PTR [rcx+rdi]
	mov	edi, 1
	movzx	ebp, r11w
	and	r11d, 3
	sal	r11d, 2
	mov	r13d, ebp
	shr	ebp, 2
	shr	r13d, 13
	or	r11d, ecx
	mov	ecx, r11d
	sal	edi, cl
	mov	rcx, QWORD PTR z_complete_dec_table@GOTPCREL[rip]
	mov	ebp, DWORD PTR [rcx+rbp*4]
	mov	ecx, r10d
	sub	ecx, r11d
	cmp	ecx, 4
	cmovle	r15d, ecx
	xor	ecx, ecx
	test	r15d, r15d
	cmovs	r15d, ecx
	sub	r11d, r10d
	cmp	r11d, 4
	mov	DWORD PTR [rsi], r15d
	mov	rsi, QWORD PTR blshiftb@GOTPCREL[rip]
	cmovle	r14d, r11d
	test	r14d, r14d
	cmovs	r14d, ecx
	cmp	r13d, 2
	mov	DWORD PTR [rsi], r14d
	jle	.L1930
.L1871:
	cmp	edi, 32769
	mov	ecx, 65535
	cmovae	edi, ecx
.L1874:
	movzx	edx, dx
	cmp	edi, edx
	cmovb	edi, edx
	xor	r10d, r10d
	lea	r11d, 0[0+rdi*8]
	lea	edx, [r11+r12]
	cmp	edx, ebp
	setae	r10b
	xor	edx, edx
	mov	r13d, r10d
.L1872:
	mov	ecx, DWORD PTR 72[rsp]
	add	ecx, DWORD PTR [rbx]
	mov	esi, 1
	mov	r15d, DWORD PTR 92[rax]
	and	ecx, 8
	test	r15d, r15d
	jne	.L1875
	xor	sil, sil
	test	ecx, ecx
	je	.L1931
.L1875:
	mov	DWORD PTR [r8], esi
	mov	DWORD PTR [r9], ecx
	mov	eax, DWORD PTR 104[rax]
	cmp	eax, 1
	je	.L1877
.L1934:
	jle	.L1932
	cmp	eax, 2
	je	.L1880
	cmp	eax, 3
	.p2align 4,,5
	jne	.L1904
	sub	r12d, r11d
	cmp	ebp, r12d
	setge	al
	or	al, dl
	je	.L1904
	test	r13d, r13d
	je	.L1904
	xor	eax, eax
	cmp	ebp, 262143
	setne	al
	jmp	.L1921
	.p2align 4,,10
	.p2align 3
.L1869:
	mov	ecx, DWORD PTR 72[rsp]
	add	ecx, DWORD PTR [rbx]
	lea	esi, -15[r10]
	mov	rdx, QWORD PTR blshifta@GOTPCREL[rip]
	mov	r11d, 4
	mov	DWORD PTR [rdx], esi
	and	ecx, 8
	cmp	esi, 4
	mov	esi, r11d
	cmovle	esi, DWORD PTR [rdx]
	xor	edi, edi
	test	esi, esi
	cmovs	esi, edi
	mov	DWORD PTR [rdx], esi
	mov	rdx, QWORD PTR blshiftb@GOTPCREL[rip]
	mov	esi, 15
	sub	esi, r10d
	mov	r10d, DWORD PTR 92[rax]
	cmp	esi, 4
	mov	DWORD PTR [rdx], esi
	mov	esi, r11d
	cmovle	esi, DWORD PTR [rdx]
	test	esi, esi
	cmovns	edi, esi
	test	r10d, r10d
	mov	DWORD PTR [rdx], edi
	mov	edx, 1
	je	.L1933
.L1893:
	mov	DWORD PTR [r8], edx
	mov	DWORD PTR [r9], ecx
.L1928:
	mov	eax, 1
.L1921:
	add	rsp, 8
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
.L1933:
	.cfi_restore_state
	test	ecx, ecx
	jne	.L1895
	mov	edi, DWORD PTR 128[rax]
	test	edi, edi
	jne	.L1893
.L1895:
	xor	edx, edx
	jmp	.L1893
	.p2align 4,,10
	.p2align 3
.L1870:
	mov	rcx, QWORD PTR z_complete_dec_table@GOTPCREL[rip]
	mov	edi, 4
	and	esi, 262143
	cmp	r10d, 4
	mov	r12d, esi
	mov	r11, QWORD PTR blshifta@GOTPCREL[rip]
	mov	ebp, DWORD PTR [rcx]
	mov	ecx, edi
	cmovle	ecx, r10d
	xor	esi, esi
	test	ecx, ecx
	cmovs	ecx, esi
	neg	r10d
	cmp	r10d, 4
	mov	DWORD PTR [r11], ecx
	mov	rcx, QWORD PTR blshiftb@GOTPCREL[rip]
	cmovle	edi, r10d
	test	edi, edi
	cmovns	esi, edi
	mov	edi, 1
	xor	r13d, r13d
	mov	DWORD PTR [rcx], esi
.L1897:
	mov	esi, 16
	mov	ecx, r13d
	add	edi, edi
	sar	esi, cl
	cmp	esi, edi
	jb	.L1871
	mov	edi, esi
	jmp	.L1874
	.p2align 4,,10
	.p2align 3
.L1931:
	mov	r14d, DWORD PTR 128[rax]
	mov	esi, ecx
	test	r14d, r14d
	cmovne	esi, r10d
	mov	DWORD PTR [r8], esi
	mov	DWORD PTR [r9], ecx
	mov	eax, DWORD PTR 104[rax]
	cmp	eax, 1
	jne	.L1934
.L1877:
	cmp	r12d, ebp
	setb	sil
	test	r10d, r10d
	je	.L1886
	test	sil, sil
	jne	.L1935
.L1886:
	cmp	ebp, 262143
	je	.L1928
	test	ecx, ecx
	jne	.L1936
	sub	r12d, r11d
	cmp	ebp, r12d
	setge	al
	or	eax, edx
.L1896:
	test	al, al
	jne	.L1928
	.p2align 4,,10
	.p2align 3
.L1904:
	xor	eax, eax
.L1938:
	add	rsp, 8
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
.L1880:
	.cfi_restore_state
	cmp	ebp, 262143
	sete	al
	cmp	r12d, ebp
	setb	dl
	add	rsp, 8
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
	or	eax, edx
	pop	r14
	.cfi_def_cfa_offset 16
	movzx	eax, al
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1932:
	.cfi_restore_state
	test	eax, eax
	jne	.L1904
	cmp	ebp, 262143
	je	.L1928
	test	ecx, ecx
	jne	.L1937
	sub	r12d, r11d
	cmp	ebp, r12d
	jge	.L1928
	test	dl, dl
	jne	.L1928
	xor	eax, eax
	jmp	.L1938
	.p2align 4,,10
	.p2align 3
.L1935:
	test	ecx, ecx
	jne	.L1939
	sub	r12d, r11d
	cmp	ebp, r12d
	setge	al
	or	eax, edx
	cmp	ebp, 262143
	jne	.L1896
	jmp	.L1928
	.p2align 4,,10
	.p2align 3
.L1937:
	cmp	r12d, ebp
	mov	eax, 1
	jb	.L1921
	xor	eax, eax
	jmp	.L1938
	.p2align 4,,10
	.p2align 3
.L1936:
	test	sil, sil
	mov	eax, 1
	jne	.L1921
	xor	eax, eax
	jmp	.L1938
	.p2align 4,,10
	.p2align 3
.L1939:
	call	dz_compress@PLT
	mov	ecx, eax
	mov	eax, 1
	shr	ebp, cl
	shr	r12d, cl
	sub	ebp, r12d
	and	ebp, 15
	imul	ebp, DWORD PTR [rbx]
	shr	ebp, 3
	and	ebp, 15
	mov	DWORD PTR [rbx], ebp
	jmp	.L1921
.L1930:
	cmp	edi, 32768
	jne	.L1897
	mov	edx, 1
	mov	r10d, 1
	mov	r11d, 524280
	mov	edi, 65535
	mov	r13d, 1
	jmp	.L1872
	.cfi_endproc
.LFE633:
	.size	z_compare, .-z_compare
	.p2align 4,,15
	.globl	render_spans_1cycle_notex
	.type	render_spans_1cycle_notex, @function
render_spans_1cycle_notex:
.LFB587:
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
	sub	rsp, 296
	.cfi_def_cfa_offset 352
	mov	rax, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	test	ecx, ecx
	mov	DWORD PTR 52[rsp], edi
	mov	DWORD PTR 144[rsp], esi
	mov	DWORD PTR 148[rsp], ecx
	mov	DWORD PTR 256[rsp], 7
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 272[rsp], 0
	mov	DWORD PTR 92[rsp], ebx
	je	.L1941
	mov	ebx, DWORD PTR 4[rax]
	mov	DWORD PTR 116[rsp], 1
	mov	DWORD PTR 96[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 100[rsp], ebx
	mov	DWORD PTR 104[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 88[rsp], eax
.L1942:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r14d, DWORD PTR 132[rax]
	test	r14d, r14d
	jne	.L1943
	mov	rax, QWORD PTR spans_dzpix@GOTPCREL[rip]
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 108[rsp], eax
	mov	ebx, eax
.L1944:
	mov	eax, ebx
	and	eax, 65280
	cmp	eax, 1
	sbb	r10d, r10d
	and	r10d, -8
	add	r10d, 9
	cmp	eax, 1
	sbb	r9d, r9d
	not	r9d
	and	r9d, 2
	cmp	eax, 1
	sbb	r8d, r8d
	and	r8d, -8
	add	r8d, 11
	cmp	eax, 1
	sbb	edi, edi
	and	edi, -8
	add	edi, 10
	cmp	eax, 1
	sbb	esi, esi
	and	esi, -8
	add	esi, 13
	cmp	eax, 1
	sbb	edx, edx
	mov	DWORD PTR 160[rsp], edx
	and	edx, -8
	and	WORD PTR 160[rsp], -2
	add	WORD PTR 160[rsp], 3
	add	edx, 15
	cmp	eax, 1
	sbb	r11d, r11d
	and	r11d, -8
	mov	ecx, r11d
	add	ecx, 12
	cmp	eax, 1
	sbb	eax, eax
	add	r11d, 14
	not	eax
	and	eax, 8
	and	ebx, 61680
	jne	.L1946
	mov	esi, r10d
	mov	WORD PTR 160[rsp], r9w
	mov	edx, r8d
	mov	r11d, edi
	mov	ecx, eax
.L1946:
	test	DWORD PTR 108[rsp], 52428
	jne	.L1986
	mov	DWORD PTR 112[rsp], esi
	mov	r11d, ecx
	xor	eax, eax
	mov	BYTE PTR 191[rsp], 1
.L1947:
	movzx	ebx, BYTE PTR 191[rsp]
	mov	edx, DWORD PTR 108[rsp]
	and	edx, 43690
	cmovne	r11d, DWORD PTR 112[rsp]
	cmove	ebx, eax
	mov	eax, DWORD PTR 144[rsp]
	cmp	DWORD PTR 52[rsp], eax
	mov	BYTE PTR 191[rsp], bl
	mov	DWORD PTR 112[rsp], r11d
	jg	.L1940
	lea	rax, 272[rsp]
	mov	QWORD PTR 120[rsp], rax
	lea	rax, 256[rsp]
	mov	QWORD PTR 128[rsp], rax
	lea	rax, 224[rsp]
	mov	QWORD PTR 40[rsp], rax
	lea	rax, 240[rsp]
	mov	QWORD PTR 136[rsp], rax
	.p2align 4,,10
	.p2align 3
.L1983:
	movsx	rax, DWORD PTR 52[rsp]
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	r13d, DWORD PTR 12[rax]
	test	r13d, r13d
	je	.L1958
	mov	esi, DWORD PTR 16[rax]
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edx, DWORD PTR [rax]
	mov	ebp, DWORD PTR 8[rax]
	mov	ebx, DWORD PTR 4[rax]
	mov	DWORD PTR 20[rsp], esi
	mov	esi, DWORD PTR 20[rax]
	mov	r12d, DWORD PTR 132[rdi]
	mov	DWORD PTR 24[rsp], esi
	mov	esi, DWORD PTR 24[rax]
	test	r12d, r12d
	mov	DWORD PTR 28[rsp], esi
	mov	esi, DWORD PTR 28[rax]
	mov	DWORD PTR 32[rsp], esi
	jne	.L1953
	mov	eax, DWORD PTR 44[rax]
	mov	DWORD PTR 36[rsp], eax
.L1954:
	mov	rax, QWORD PTR fb_width@GOTPCREL[rip]
	mov	esi, DWORD PTR 52[rsp]
	mov	r11d, DWORD PTR 148[rsp]
	imul	esi, DWORD PTR [rax]
	mov	rax, QWORD PTR zb_address@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	lea	r14d, [rbx+rsi]
	lea	r13d, [rax+r14*2]
	and	r13d, 16777215
	sar	r13d
	test	r11d, r11d
	jne	.L1955
	mov	edi, DWORD PTR 52[rsp]
	mov	eax, ebx
	sub	ebp, ebx
	sub	eax, edx
	mov	DWORD PTR 72[rsp], eax
	call	compute_cvg_noflip@PLT
.L1956:
	test	ebp, ebp
	je	.L1957
	mov	eax, DWORD PTR 92[rsp]
	imul	eax, ebp
	add	DWORD PTR 20[rsp], eax
	mov	eax, DWORD PTR 96[rsp]
	imul	eax, ebp
	add	DWORD PTR 24[rsp], eax
	mov	eax, DWORD PTR 100[rsp]
	imul	eax, ebp
	add	DWORD PTR 28[rsp], eax
	mov	eax, DWORD PTR 104[rsp]
	imul	eax, ebp
	add	DWORD PTR 32[rsp], eax
	imul	ebp, DWORD PTR 88[rsp]
	add	DWORD PTR 36[rsp], ebp
.L1957:
	mov	r10d, DWORD PTR 72[rsp]
	test	r10d, r10d
	js	.L1958
	lea	rax, 208[rsp]
	sub	r14d, ebx
	mov	DWORD PTR 48[rsp], 0
	mov	r12, QWORD PTR shade_color@GOTPCREL[rip]
	mov	rbp, QWORD PTR special_9bit_clamptable@GOTPCREL[rip]
	mov	QWORD PTR 64[rsp], rax
	lea	rax, 192[rsp]
	mov	DWORD PTR 76[rsp], r14d
	mov	QWORD PTR 56[rsp], rax
	jmp	.L1982
	.p2align 4,,10
	.p2align 3
.L1966:
	mov	eax, DWORD PTR 92[rsp]
	add	DWORD PTR 20[rsp], eax
	mov	eax, DWORD PTR 96[rsp]
	add	DWORD PTR 24[rsp], eax
	mov	eax, DWORD PTR 100[rsp]
	add	DWORD PTR 28[rsp], eax
	mov	eax, DWORD PTR 104[rsp]
	add	DWORD PTR 32[rsp], eax
	mov	eax, DWORD PTR 88[rsp]
	add	DWORD PTR 36[rsp], eax
	mov	eax, DWORD PTR 116[rsp]
	add	DWORD PTR 48[rsp], 1
	add	r13d, eax
	add	ebx, eax
	and	r13d, 8388607
	mov	eax, DWORD PTR 48[rsp]
	cmp	DWORD PTR 72[rsp], eax
	jl	.L1958
.L1982:
	mov	rdx, QWORD PTR cvgbuf@GOTPCREL[rip]
	movsx	rax, ebx
	mov	rsi, QWORD PTR cvarray@GOTPCREL[rip]
	mov	r8d, DWORD PTR 20[rsp]
	mov	edi, DWORD PTR 24[rsp]
	mov	r11d, DWORD PTR 28[rsp]
	mov	r10d, DWORD PTR 32[rsp]
	movzx	eax, BYTE PTR [rdx+rax]
	mov	r9d, DWORD PTR 36[rsp]
	sar	r8d, 14
	sar	edi, 14
	sar	r11d, 14
	sar	r10d, 14
	shr	r9d, 10
	lea	rcx, [rsi+rax*4]
	movzx	eax, BYTE PTR 1[rcx]
	movzx	edx, BYTE PTR 2[rcx]
	mov	BYTE PTR 80[rsp], al
	movzx	eax, BYTE PTR 3[rcx]
	movzx	ecx, BYTE PTR [rcx]
	cmp	ecx, 8
	mov	DWORD PTR 224[rsp], ecx
	je	.L1999
	mov	rsi, QWORD PTR spans_cd_rgba@GOTPCREL[rip]
	mov	rcx, QWORD PTR spans_d_rgba_dy@GOTPCREL[rip]
	mov	r15d, DWORD PTR [rsi]
	mov	r14d, DWORD PTR [rcx]
	imul	r15d, edx
	imul	r14d, eax
	add	r14d, r15d
	mov	r15d, DWORD PTR 4[rsi]
	lea	r8d, [r14+r8*4]
	mov	r14d, DWORD PTR 4[rcx]
	imul	r15d, edx
	sar	r8d, 4
	imul	r14d, eax
	add	r14d, r15d
	mov	r15d, DWORD PTR 8[rsi]
	lea	edi, [r14+rdi*4]
	mov	r14d, DWORD PTR 8[rcx]
	imul	r15d, edx
	sar	edi, 4
	imul	r14d, eax
	add	r14d, r15d
	mov	r15d, DWORD PTR 12[rsi]
	lea	r11d, [r14+r11*4]
	imul	r15d, edx
	sar	r11d, 4
	mov	esi, r15d
	mov	r15d, DWORD PTR 12[rcx]
	imul	r15d, eax
	add	esi, r15d
	lea	ecx, [rsi+r10*4]
	mov	rsi, QWORD PTR spans_cdz@GOTPCREL[rip]
	sar	ecx, 4
	imul	edx, DWORD PTR [rsi]
	mov	rsi, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	imul	eax, DWORD PTR 12[rsi]
	add	edx, eax
	lea	r9d, [rdx+r9*4]
	sar	r9d, 5
.L1960:
	and	r8d, 511
	and	edi, 511
	and	r11d, 511
	mov	eax, DWORD PTR 0[rbp+r8*4]
	and	ecx, 511
	mov	r15d, 262143
	mov	DWORD PTR [r12], eax
	mov	eax, DWORD PTR 0[rbp+rdi*4]
	mov	DWORD PTR 4[r12], eax
	mov	eax, DWORD PTR 0[rbp+r11*4]
	mov	DWORD PTR 8[r12], eax
	mov	eax, DWORD PTR 0[rbp+rcx*4]
	mov	DWORD PTR 12[r12], eax
	mov	eax, r9d
	and	eax, 393216
	sar	eax, 17
	cmp	eax, 2
	je	.L1963
	xor	r15d, r15d
	and	r9d, 262143
	cmp	eax, 3
	cmovne	r15, r9
.L1963:
	mov	rcx, QWORD PTR 120[rsp]
	mov	rdx, QWORD PTR 128[rsp]
	mov	edi, ebx
	mov	esi, DWORD PTR 52[rsp]
	call	[QWORD PTR get_dither_noise_ptr[rip]]
	mov	rsi, QWORD PTR 40[rsp]
	mov	edi, DWORD PTR 272[rsp]
	call	combiner_1cycle@PLT
	mov	edi, DWORD PTR 76[rsp]
	mov	rdx, QWORD PTR fbread1_ptr@GOTPCREL[rip]
	mov	rsi, QWORD PTR 136[rsp]
	lea	r14d, [rdi+rbx]
	mov	edi, r14d
	call	[QWORD PTR [rdx]]
	mov	eax, DWORD PTR 240[rsp]
	mov	r9, QWORD PTR 64[rsp]
	mov	esi, r15d
	mov	r8, QWORD PTR 56[rsp]
	mov	ecx, DWORD PTR 112[rsp]
	mov	edi, r13d
	mov	edx, DWORD PTR 108[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	rax, QWORD PTR 40[rsp]
	mov	QWORD PTR [rsp], rax
	call	z_compare@PLT
	test	eax, eax
	je	.L1966
	mov	r10, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	edx, DWORD PTR 224[rsp]
	mov	edi, DWORD PTR 208[rsp]
	mov	esi, DWORD PTR 192[rsp]
	mov	ecx, DWORD PTR 256[rsp]
	mov	r9d, DWORD PTR 140[r10]
	mov	eax, DWORD PTR 12[rax]
	test	r9d, r9d
	jne	.L1967
.L1972:
	mov	r8d, DWORD PTR 128[r10]
	test	r8d, r8d
	je	.L2000
	test	edx, edx
	setne	dl
.L1974:
	test	dl, dl
	je	.L1966
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r8d, DWORD PTR 112[rdx]
	test	r8d, r8d
	je	.L1975
	test	edi, edi
	jne	.L1975
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 276[rsp], eax
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 280[rsp], eax
	mov	rax, QWORD PTR blender2a_b@GOTPCREL[rip]
.L1998:
	mov	rax, QWORD PTR [rax]
	lea	r9, 284[rsp]
	lea	r8, 280[rsp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 284[rsp], eax
	lea	rax, 276[rsp]
.L1980:
	mov	rdx, r9
	mov	rsi, r8
	mov	rdi, rax
	call	[QWORD PTR rgb_dither_ptr[rip]]
	mov	eax, DWORD PTR 240[rsp]
	mov	esi, DWORD PTR 276[rsp]
	mov	edi, r14d
	mov	r9d, DWORD PTR 224[rsp]
	mov	r8d, DWORD PTR 192[rsp]
	mov	ecx, DWORD PTR 284[rsp]
	mov	edx, DWORD PTR 280[rsp]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR fbwrite_ptr@GOTPCREL[rip]
	call	[QWORD PTR [rax]]
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	esi, DWORD PTR 120[rax]
	test	esi, esi
	je	.L1966
	mov	rax, QWORD PTR z_com_table@GOTPCREL[rip]
	movzx	edx, WORD PTR [rax+r15*2]
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	cmp	r13d, DWORD PTR [rax]
	ja	.L1966
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	or	dx, WORD PTR 160[rsp]
	mov	ecx, r13d
	xor	ecx, 1
	movzx	esi, BYTE PTR 191[rsp]
	mov	rax, QWORD PTR [rax]
	mov	WORD PTR [rax+rcx*2], dx
	mov	rdx, QWORD PTR hidden_bits@GOTPCREL[rip]
	mov	eax, r13d
	mov	BYTE PTR [rdx+rax], sil
	jmp	.L1966
	.p2align 4,,10
	.p2align 3
.L1999:
	mov	r8d, DWORD PTR 20[rsp]
	mov	edi, DWORD PTR 24[rsp]
	sar	r9d, 3
	mov	r11d, DWORD PTR 28[rsp]
	mov	ecx, DWORD PTR 32[rsp]
	sar	r8d, 16
	sar	edi, 16
	sar	r11d, 16
	sar	ecx, 16
	jmp	.L1960
	.p2align 4,,10
	.p2align 3
.L1958:
	add	DWORD PTR 52[rsp], 1
	mov	eax, DWORD PTR 52[rsp]
	cmp	DWORD PTR 144[rsp], eax
	jge	.L1983
.L1940:
	add	rsp, 296
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
.L2000:
	.cfi_restore_state
	cmp	BYTE PTR 80[rsp], 0
	setne	dl
	jmp	.L1974
	.p2align 4,,10
	.p2align 3
.L1967:
	mov	r11d, DWORD PTR 136[r10]
	test	r11d, r11d
	jne	.L1970
	mov	r8, QWORD PTR blend_color@GOTPCREL[rip]
	mov	r8d, DWORD PTR 12[r8]
.L1971:
	cmp	eax, r8d
	jl	.L1966
	mov	r10, QWORD PTR other_modes@GOTPCREL[rip]
	jmp	.L1972
	.p2align 4,,10
	.p2align 3
.L1975:
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edi, DWORD PTR 152[rdx]
	test	edi, edi
	je	.L1977
	cmp	eax, 254
	jg	.L1978
.L1977:
	test	esi, esi
	jne	.L1979
.L1978:
	mov	rax, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 276[rsp], eax
	mov	rax, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 280[rsp], eax
	mov	rax, QWORD PTR blender1a_b@GOTPCREL[rip]
	jmp	.L1998
	.p2align 4,,10
	.p2align 3
.L1955:
	mov	edi, DWORD PTR 52[rsp]
	mov	eax, ebx
	sub	edx, ebx
	sub	eax, ebp
	mov	DWORD PTR 72[rsp], edx
	mov	ebp, eax
	call	compute_cvg_flip@PLT
	jmp	.L1956
	.p2align 4,,10
	.p2align 3
.L1953:
	mov	rax, QWORD PTR primitive_z@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 36[rsp], eax
	jmp	.L1954
	.p2align 4,,10
	.p2align 3
.L1970:
	mov	r9, QWORD PTR iseed@GOTPCREL[rip]
	mov	r10d, DWORD PTR [r9]
	imul	r8d, r10d, 214013
	add	r8d, 2531011
	mov	DWORD PTR [r9], r8d
	sar	r8d, 16
	movzx	r8d, r8b
	jmp	.L1971
	.p2align 4,,10
	.p2align 3
.L1979:
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rdx, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	lea	r9, 284[rsp]
	lea	r8, 280[rsp]
	mov	DWORD PTR 184[rsp], ecx
	mov	QWORD PTR 176[rsp], r9
	mov	rax, QWORD PTR [rax]
	mov	rsi, r8
	mov	QWORD PTR 152[rsp], r8
	mov	eax, DWORD PTR [rax]
	not	eax
	and	eax, 255
	mov	DWORD PTR 12[rdx], eax
	lea	rax, 276[rsp]
	mov	rdx, r9
	mov	rdi, rax
	mov	QWORD PTR 80[rsp], rax
	call	blender_equation_cycle0@PLT
	mov	rax, QWORD PTR 80[rsp]
	mov	r8, QWORD PTR 152[rsp]
	mov	r9, QWORD PTR 176[rsp]
	mov	ecx, DWORD PTR 184[rsp]
	jmp	.L1980
.L1986:
	mov	DWORD PTR 112[rsp], edx
	mov	eax, 2
	mov	BYTE PTR 191[rsp], 3
	jmp	.L1947
.L1943:
	mov	rax, QWORD PTR primitive_delta_z@GOTPCREL[rip]
	mov	DWORD PTR 88[rsp], 0
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 108[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	ebx, DWORD PTR 108[rsp]
	mov	DWORD PTR 12[rax], 0
	mov	rax, QWORD PTR spans_cdz@GOTPCREL[rip]
	mov	DWORD PTR [rax], 0
	jmp	.L1944
.L1941:
	mov	ebx, DWORD PTR 4[rax]
	neg	DWORD PTR 92[rsp]
	mov	DWORD PTR 116[rsp], -1
	mov	DWORD PTR 96[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 96[rsp]
	mov	DWORD PTR 100[rsp], ebx
	neg	DWORD PTR 100[rsp]
	mov	DWORD PTR 104[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	neg	DWORD PTR 104[rsp]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 88[rsp], eax
	neg	DWORD PTR 88[rsp]
	jmp	.L1942
	.cfi_endproc
.LFE587:
	.size	render_spans_1cycle_notex, .-render_spans_1cycle_notex
	.p2align 4,,15
	.globl	render_spans_2cycle_notex
	.type	render_spans_2cycle_notex, @function
render_spans_2cycle_notex:
.LFB591:
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
	sub	rsp, 296
	.cfi_def_cfa_offset 352
	mov	rax, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	test	ecx, ecx
	mov	DWORD PTR 40[rsp], edi
	mov	DWORD PTR 144[rsp], esi
	mov	DWORD PTR 148[rsp], ecx
	mov	DWORD PTR 256[rsp], 7
	mov	edx, DWORD PTR [rax]
	mov	DWORD PTR 272[rsp], 0
	mov	DWORD PTR 84[rsp], edx
	je	.L2002
	mov	edx, DWORD PTR 4[rax]
	mov	DWORD PTR 108[rsp], 1
	mov	DWORD PTR 88[rsp], edx
	mov	edx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 92[rsp], edx
	mov	DWORD PTR 96[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 80[rsp], eax
.L2003:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r10d, DWORD PTR 132[rax]
	test	r10d, r10d
	jne	.L2004
	mov	rax, QWORD PTR spans_dzpix@GOTPCREL[rip]
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 100[rsp], eax
	mov	ebx, eax
.L2005:
	mov	eax, ebx
	and	eax, 65280
	cmp	eax, 1
	sbb	r10d, r10d
	and	r10d, -8
	add	r10d, 9
	cmp	eax, 1
	sbb	r9d, r9d
	not	r9d
	and	r9d, 2
	cmp	eax, 1
	sbb	r8d, r8d
	and	r8d, -8
	add	r8d, 11
	cmp	eax, 1
	sbb	edi, edi
	and	edi, -8
	add	edi, 10
	cmp	eax, 1
	sbb	esi, esi
	and	esi, -8
	add	esi, 13
	cmp	eax, 1
	sbb	edx, edx
	mov	DWORD PTR 160[rsp], edx
	and	edx, -8
	and	WORD PTR 160[rsp], -2
	add	WORD PTR 160[rsp], 3
	add	edx, 15
	cmp	eax, 1
	sbb	r11d, r11d
	and	r11d, -8
	mov	ecx, r11d
	add	ecx, 12
	cmp	eax, 1
	sbb	eax, eax
	add	r11d, 14
	not	eax
	and	eax, 8
	and	ebx, 61680
	jne	.L2007
	mov	esi, r10d
	mov	WORD PTR 160[rsp], r9w
	mov	edx, r8d
	mov	r11d, edi
	mov	ecx, eax
.L2007:
	test	DWORD PTR 100[rsp], 52428
	jne	.L2048
	mov	DWORD PTR 104[rsp], esi
	mov	r11d, ecx
	xor	eax, eax
	mov	BYTE PTR 191[rsp], 1
.L2008:
	movzx	esi, BYTE PTR 191[rsp]
	mov	edx, DWORD PTR 100[rsp]
	and	edx, 43690
	cmovne	r11d, DWORD PTR 104[rsp]
	cmove	esi, eax
	mov	eax, DWORD PTR 144[rsp]
	cmp	DWORD PTR 40[rsp], eax
	mov	BYTE PTR 191[rsp], sil
	mov	DWORD PTR 104[rsp], r11d
	jg	.L2001
	lea	rax, 272[rsp]
	mov	QWORD PTR 112[rsp], rax
	lea	rax, 256[rsp]
	mov	QWORD PTR 120[rsp], rax
	lea	rax, 224[rsp]
	mov	QWORD PTR 128[rsp], rax
	lea	rax, 240[rsp]
	mov	QWORD PTR 136[rsp], rax
	.p2align 4,,10
	.p2align 3
.L2045:
	movsx	rax, DWORD PTR 40[rsp]
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	r9d, DWORD PTR 12[rax]
	test	r9d, r9d
	je	.L2019
	mov	edi, DWORD PTR 16[rax]
	mov	esi, DWORD PTR 20[rax]
	mov	edx, DWORD PTR [rax]
	mov	ebp, DWORD PTR 8[rax]
	mov	ebx, DWORD PTR 4[rax]
	mov	DWORD PTR 16[rsp], edi
	mov	edi, DWORD PTR 24[rax]
	mov	DWORD PTR 20[rsp], esi
	mov	esi, DWORD PTR 28[rax]
	mov	DWORD PTR 24[rsp], edi
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	DWORD PTR 28[rsp], esi
	mov	r8d, DWORD PTR 132[rdi]
	test	r8d, r8d
	jne	.L2014
	mov	eax, DWORD PTR 44[rax]
	mov	DWORD PTR 32[rsp], eax
.L2015:
	mov	rax, QWORD PTR fb_width@GOTPCREL[rip]
	mov	r12d, DWORD PTR 40[rsp]
	mov	edi, DWORD PTR 148[rsp]
	imul	r12d, DWORD PTR [rax]
	mov	rax, QWORD PTR zb_address@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	lea	ecx, [rbx+r12]
	lea	r15d, [rax+rcx*2]
	mov	DWORD PTR 36[rsp], ecx
	and	r15d, 16777215
	sar	r15d
	test	edi, edi
	jne	.L2016
	mov	edi, DWORD PTR 40[rsp]
	mov	eax, ebx
	sub	ebp, ebx
	sub	eax, edx
	mov	DWORD PTR 44[rsp], eax
	call	compute_cvg_noflip@PLT
	mov	ecx, DWORD PTR 36[rsp]
.L2017:
	test	ebp, ebp
	je	.L2018
	mov	eax, DWORD PTR 84[rsp]
	imul	eax, ebp
	add	DWORD PTR 16[rsp], eax
	mov	eax, DWORD PTR 88[rsp]
	imul	eax, ebp
	add	DWORD PTR 20[rsp], eax
	mov	eax, DWORD PTR 92[rsp]
	imul	eax, ebp
	add	DWORD PTR 24[rsp], eax
	mov	eax, DWORD PTR 96[rsp]
	imul	eax, ebp
	add	DWORD PTR 28[rsp], eax
	imul	ebp, DWORD PTR 80[rsp]
	add	DWORD PTR 32[rsp], ebp
.L2018:
	mov	esi, DWORD PTR 44[rsp]
	test	esi, esi
	js	.L2019
	lea	rax, 208[rsp]
	sub	ecx, ebx
	mov	r13d, ebx
	mov	DWORD PTR 36[rsp], 0
	mov	r14, QWORD PTR shade_color@GOTPCREL[rip]
	mov	QWORD PTR 56[rsp], rax
	lea	rax, 192[rsp]
	mov	r12, QWORD PTR special_9bit_clamptable@GOTPCREL[rip]
	mov	DWORD PTR 72[rsp], ecx
	mov	QWORD PTR 48[rsp], rax
	jmp	.L2044
	.p2align 4,,10
	.p2align 3
.L2027:
	mov	rax, QWORD PTR pre_memory_color@GOTPCREL[rip]
	mov	rdi, QWORD PTR memory_color@GOTPCREL[rip]
	mov	rsi, QWORD PTR pastblshifta@GOTPCREL[rip]
	add	DWORD PTR 36[rsp], 1
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rdi], rax
	mov	rax, QWORD PTR blshifta@GOTPCREL[rip]
	mov	QWORD PTR 8[rdi], rdx
	mov	rdx, QWORD PTR pastblshiftb@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rsi], eax
	mov	rax, QWORD PTR blshiftb@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	mov	eax, DWORD PTR 84[rsp]
	add	DWORD PTR 16[rsp], eax
	mov	eax, DWORD PTR 88[rsp]
	add	DWORD PTR 20[rsp], eax
	mov	eax, DWORD PTR 92[rsp]
	add	DWORD PTR 24[rsp], eax
	mov	eax, DWORD PTR 96[rsp]
	add	DWORD PTR 28[rsp], eax
	mov	eax, DWORD PTR 80[rsp]
	add	DWORD PTR 32[rsp], eax
	mov	eax, DWORD PTR 108[rsp]
	add	r15d, eax
	add	r13d, eax
	mov	eax, DWORD PTR 36[rsp]
	and	r15d, 8388607
	cmp	DWORD PTR 44[rsp], eax
	jl	.L2019
.L2044:
	mov	rdx, QWORD PTR cvgbuf@GOTPCREL[rip]
	movsx	rax, r13d
	mov	rsi, QWORD PTR cvarray@GOTPCREL[rip]
	mov	r8d, DWORD PTR 16[rsp]
	mov	edi, DWORD PTR 20[rsp]
	mov	r11d, DWORD PTR 24[rsp]
	mov	r10d, DWORD PTR 28[rsp]
	movzx	eax, BYTE PTR [rdx+rax]
	mov	r9d, DWORD PTR 32[rsp]
	sar	r8d, 14
	sar	edi, 14
	sar	r11d, 14
	sar	r10d, 14
	shr	r9d, 10
	lea	rcx, [rsi+rax*4]
	movzx	eax, BYTE PTR 1[rcx]
	movzx	edx, BYTE PTR 2[rcx]
	mov	BYTE PTR 64[rsp], al
	movzx	eax, BYTE PTR 3[rcx]
	movzx	ecx, BYTE PTR [rcx]
	cmp	ecx, 8
	mov	DWORD PTR 224[rsp], ecx
	je	.L2061
	mov	rsi, QWORD PTR spans_cd_rgba@GOTPCREL[rip]
	mov	rcx, QWORD PTR spans_d_rgba_dy@GOTPCREL[rip]
	mov	ebp, DWORD PTR [rsi]
	mov	ebx, DWORD PTR [rcx]
	imul	ebp, edx
	imul	ebx, eax
	add	ebx, ebp
	mov	ebp, DWORD PTR 4[rsi]
	lea	r8d, [rbx+r8*4]
	mov	ebx, DWORD PTR 4[rcx]
	imul	ebp, edx
	sar	r8d, 4
	imul	ebx, eax
	add	ebx, ebp
	mov	ebp, DWORD PTR 8[rsi]
	lea	edi, [rbx+rdi*4]
	mov	ebx, DWORD PTR 8[rcx]
	imul	ebp, edx
	sar	edi, 4
	imul	ebx, eax
	add	ebx, ebp
	lea	r11d, [rbx+r11*4]
	mov	ebx, DWORD PTR 12[rsi]
	sar	r11d, 4
	imul	ebx, edx
	mov	esi, ebx
	mov	ebx, DWORD PTR 12[rcx]
	imul	ebx, eax
	add	esi, ebx
	lea	ecx, [rsi+r10*4]
	mov	rsi, QWORD PTR spans_cdz@GOTPCREL[rip]
	sar	ecx, 4
	imul	edx, DWORD PTR [rsi]
	mov	rsi, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	imul	eax, DWORD PTR 12[rsi]
	add	edx, eax
	lea	r9d, [rdx+r9*4]
	sar	r9d, 5
.L2021:
	and	r8d, 511
	and	edi, 511
	and	r11d, 511
	mov	eax, DWORD PTR [r12+r8*4]
	and	ecx, 511
	mov	ebp, 262143
	mov	DWORD PTR [r14], eax
	mov	eax, DWORD PTR [r12+rdi*4]
	mov	DWORD PTR 4[r14], eax
	mov	eax, DWORD PTR [r12+r11*4]
	mov	DWORD PTR 8[r14], eax
	mov	eax, DWORD PTR [r12+rcx*4]
	mov	DWORD PTR 12[r14], eax
	mov	eax, r9d
	and	eax, 393216
	sar	eax, 17
	cmp	eax, 2
	je	.L2024
	xor	ebp, ebp
	and	r9d, 262143
	cmp	eax, 3
	cmovne	rbp, r9
.L2024:
	mov	rcx, QWORD PTR 112[rsp]
	mov	rdx, QWORD PTR 120[rsp]
	mov	edi, r13d
	mov	esi, DWORD PTR 40[rsp]
	call	[QWORD PTR get_dither_noise_ptr[rip]]
	mov	rbx, QWORD PTR 128[rsp]
	mov	edi, DWORD PTR 272[rsp]
	mov	rsi, rbx
	call	combiner_2cycle@PLT
	mov	edi, DWORD PTR 72[rsp]
	mov	rdx, QWORD PTR fbread2_ptr@GOTPCREL[rip]
	mov	rsi, QWORD PTR 136[rsp]
	lea	eax, [rdi+r13]
	mov	edi, eax
	mov	DWORD PTR 76[rsp], eax
	call	[QWORD PTR [rdx]]
	mov	eax, DWORD PTR 240[rsp]
	mov	r9, QWORD PTR 56[rsp]
	mov	esi, ebp
	mov	r8, QWORD PTR 48[rsp]
	mov	ecx, DWORD PTR 104[rsp]
	mov	edi, r15d
	mov	edx, DWORD PTR 100[rsp]
	mov	QWORD PTR [rsp], rbx
	mov	DWORD PTR 8[rsp], eax
	call	z_compare@PLT
	test	eax, eax
	je	.L2027
	mov	rsi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	edx, DWORD PTR 224[rsp]
	mov	r11d, DWORD PTR 208[rsp]
	mov	r10d, DWORD PTR 192[rsp]
	mov	r9d, DWORD PTR 256[rsp]
	mov	ecx, DWORD PTR 140[rsi]
	mov	eax, DWORD PTR 12[rax]
	test	ecx, ecx
	jne	.L2028
.L2033:
	mov	ebx, DWORD PTR 128[rsi]
	test	ebx, ebx
	je	.L2062
	test	edx, edx
	setne	dl
.L2035:
	test	dl, dl
	je	.L2027
	mov	rdi, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rsi, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rdi]
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edx, DWORD PTR [rcx]
	not	edx
	and	edx, 255
	mov	DWORD PTR 12[rsi], edx
	mov	rdx, QWORD PTR blender2b_a@GOTPCREL[rip]
	mov	r8d, DWORD PTR [rcx]
	mov	esi, DWORD PTR 160[rdi]
	mov	rdx, QWORD PTR [rdx]
	sar	r8d, 3
	mov	edx, DWORD PTR [rdx]
	sar	edx, 3
	test	esi, esi
	je	.L2036
	mov	rdi, QWORD PTR pastblshifta@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rdi]
	mov	rdi, QWORD PTR pastblshiftb@GOTPCREL[rip]
	sar	r8d, cl
	mov	ecx, DWORD PTR [rdi]
	and	r8d, 60
	sar	edx, cl
	or	edx, 3
.L2036:
	mov	rsi, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rdi, QWORD PTR blender2a_r@GOTPCREL[rip]
	add	edx, 1
	mov	rbx, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rcx, QWORD PTR [rsi]
	mov	esi, DWORD PTR [rcx]
	mov	rcx, QWORD PTR [rdi]
	mov	edi, DWORD PTR [rcx]
	mov	rcx, QWORD PTR [rbx]
	imul	esi, r8d
	mov	rbx, QWORD PTR blender2a_g@GOTPCREL[rip]
	imul	edi, edx
	add	esi, edi
	sar	esi, 5
	movzx	esi, sil
	mov	DWORD PTR 276[rsp], esi
	mov	edi, DWORD PTR [rcx]
	mov	rcx, QWORD PTR [rbx]
	imul	edi, r8d
	mov	ebx, DWORD PTR [rcx]
	imul	ebx, edx
	mov	ecx, ebx
	add	ecx, edi
	mov	rdi, QWORD PTR blender1a_b@GOTPCREL[rip]
	sar	ecx, 5
	movzx	ecx, cl
	mov	rbx, QWORD PTR [rdi]
	mov	DWORD PTR 280[rsp], ecx
	imul	r8d, DWORD PTR [rbx]
	mov	rbx, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	rbx, QWORD PTR [rbx]
	imul	edx, DWORD PTR [rbx]
	add	r8d, edx
	mov	rdx, QWORD PTR pre_memory_color@GOTPCREL[rip]
	sar	r8d, 5
	movzx	r8d, r8b
	movdqa	xmm1, XMMWORD PTR [rdx]
	mov	rdx, QWORD PTR memory_color@GOTPCREL[rip]
	mov	DWORD PTR 284[rsp], r8d
	movdqa	XMMWORD PTR [rdx], xmm1
	mov	rdx, QWORD PTR blended_pixel_color@GOTPCREL[rip]
	mov	DWORD PTR [rdx], esi
	mov	rsi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	DWORD PTR 4[rdx], ecx
	mov	DWORD PTR 8[rdx], r8d
	mov	DWORD PTR 12[rdx], eax
	mov	ecx, DWORD PTR 112[rsi]
	test	ecx, ecx
	je	.L2037
	test	r11d, r11d
	jne	.L2037
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 276[rsp], eax
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 280[rsp], eax
	mov	rax, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
.L2060:
	mov	eax, DWORD PTR [rax]
	lea	r10, 284[rsp]
	lea	r8, 280[rsp]
	mov	DWORD PTR 284[rsp], eax
	lea	rax, 276[rsp]
.L2042:
	mov	ecx, r9d
	mov	rdx, r10
	mov	rsi, r8
	mov	rdi, rax
	call	[QWORD PTR rgb_dither_ptr[rip]]
	mov	eax, DWORD PTR 240[rsp]
	mov	r9d, DWORD PTR 224[rsp]
	mov	r8d, DWORD PTR 192[rsp]
	mov	ecx, DWORD PTR 284[rsp]
	mov	edx, DWORD PTR 280[rsp]
	mov	esi, DWORD PTR 276[rsp]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR fbwrite_ptr@GOTPCREL[rip]
	mov	edi, DWORD PTR 76[rsp]
	call	[QWORD PTR [rax]]
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 120[rax]
	test	eax, eax
	je	.L2027
	mov	rax, QWORD PTR z_com_table@GOTPCREL[rip]
	movzx	edx, WORD PTR [rax+rbp*2]
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	cmp	r15d, DWORD PTR [rax]
	ja	.L2027
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	or	dx, WORD PTR 160[rsp]
	mov	ecx, r15d
	xor	ecx, 1
	movzx	esi, BYTE PTR 191[rsp]
	mov	rax, QWORD PTR [rax]
	mov	WORD PTR [rax+rcx*2], dx
	mov	rdx, QWORD PTR hidden_bits@GOTPCREL[rip]
	mov	eax, r15d
	mov	BYTE PTR [rdx+rax], sil
	jmp	.L2027
	.p2align 4,,10
	.p2align 3
.L2061:
	mov	r8d, DWORD PTR 16[rsp]
	mov	edi, DWORD PTR 20[rsp]
	sar	r9d, 3
	mov	r11d, DWORD PTR 24[rsp]
	mov	ecx, DWORD PTR 28[rsp]
	sar	r8d, 16
	sar	edi, 16
	sar	r11d, 16
	sar	ecx, 16
	jmp	.L2021
	.p2align 4,,10
	.p2align 3
.L2019:
	add	DWORD PTR 40[rsp], 1
	mov	eax, DWORD PTR 40[rsp]
	cmp	DWORD PTR 144[rsp], eax
	jge	.L2045
.L2001:
	add	rsp, 296
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
.L2062:
	.cfi_restore_state
	cmp	BYTE PTR 64[rsp], 0
	setne	dl
	jmp	.L2035
	.p2align 4,,10
	.p2align 3
.L2028:
	mov	r8d, DWORD PTR 136[rsi]
	test	r8d, r8d
	jne	.L2031
	mov	rcx, QWORD PTR blend_color@GOTPCREL[rip]
	mov	ecx, DWORD PTR 12[rcx]
.L2032:
	cmp	eax, ecx
	jl	.L2027
	mov	rsi, QWORD PTR other_modes@GOTPCREL[rip]
	jmp	.L2033
	.p2align 4,,10
	.p2align 3
.L2037:
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edx, DWORD PTR 156[rdx]
	test	edx, edx
	je	.L2039
	cmp	eax, 254
	jg	.L2040
.L2039:
	test	r10d, r10d
	jne	.L2041
.L2040:
	mov	rax, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 276[rsp], eax
	mov	rax, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 280[rsp], eax
	mov	rax, QWORD PTR 8[rdi]
	jmp	.L2060
	.p2align 4,,10
	.p2align 3
.L2016:
	mov	edi, DWORD PTR 40[rsp]
	mov	eax, ebx
	sub	edx, ebx
	sub	eax, ebp
	mov	DWORD PTR 44[rsp], edx
	mov	ebp, eax
	call	compute_cvg_flip@PLT
	mov	ecx, DWORD PTR 36[rsp]
	jmp	.L2017
	.p2align 4,,10
	.p2align 3
.L2014:
	mov	rax, QWORD PTR primitive_z@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 32[rsp], eax
	jmp	.L2015
	.p2align 4,,10
	.p2align 3
.L2031:
	mov	rsi, QWORD PTR iseed@GOTPCREL[rip]
	mov	edi, DWORD PTR [rsi]
	imul	ecx, edi, 214013
	add	ecx, 2531011
	mov	DWORD PTR [rsi], ecx
	sar	ecx, 16
	movzx	ecx, cl
	jmp	.L2032
	.p2align 4,,10
	.p2align 3
.L2041:
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rdx, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	lea	r10, 284[rsp]
	lea	r8, 280[rsp]
	mov	DWORD PTR 184[rsp], r9d
	mov	QWORD PTR 176[rsp], r10
	mov	rax, QWORD PTR 8[rax]
	mov	rsi, r8
	mov	QWORD PTR 152[rsp], r8
	mov	eax, DWORD PTR [rax]
	not	eax
	and	eax, 255
	mov	DWORD PTR 12[rdx], eax
	lea	rax, 276[rsp]
	mov	rdx, r10
	mov	rdi, rax
	mov	QWORD PTR 64[rsp], rax
	call	blender_equation_cycle1@PLT
	mov	rax, QWORD PTR 64[rsp]
	mov	r8, QWORD PTR 152[rsp]
	mov	r10, QWORD PTR 176[rsp]
	mov	r9d, DWORD PTR 184[rsp]
	jmp	.L2042
.L2048:
	mov	DWORD PTR 104[rsp], edx
	mov	eax, 2
	mov	BYTE PTR 191[rsp], 3
	jmp	.L2008
.L2004:
	mov	rax, QWORD PTR primitive_delta_z@GOTPCREL[rip]
	mov	DWORD PTR 80[rsp], 0
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 100[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	ebx, DWORD PTR 100[rsp]
	mov	DWORD PTR 12[rax], 0
	mov	rax, QWORD PTR spans_cdz@GOTPCREL[rip]
	mov	DWORD PTR [rax], 0
	jmp	.L2005
.L2002:
	mov	edx, DWORD PTR 4[rax]
	neg	DWORD PTR 84[rsp]
	mov	DWORD PTR 108[rsp], -1
	mov	DWORD PTR 88[rsp], edx
	mov	edx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 88[rsp]
	mov	DWORD PTR 92[rsp], edx
	neg	DWORD PTR 92[rsp]
	mov	DWORD PTR 96[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	neg	DWORD PTR 96[rsp]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 80[rsp], eax
	neg	DWORD PTR 80[rsp]
	jmp	.L2003
	.cfi_endproc
.LFE591:
	.size	render_spans_2cycle_notex, .-render_spans_2cycle_notex
	.p2align 4,,15
	.globl	render_spans_2cycle_notexel1
	.type	render_spans_2cycle_notexel1, @function
render_spans_2cycle_notexel1:
.LFB590:
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
	sub	rsp, 488
	.cfi_def_cfa_offset 544
	mov	rax, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	test	ecx, ecx
	mov	DWORD PTR 80[rsp], edi
	mov	DWORD PTR 260[rsp], esi
	mov	DWORD PTR 264[rsp], edx
	mov	DWORD PTR 268[rsp], ecx
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 352[rsp], 7
	mov	DWORD PTR 368[rsp], 0
	mov	DWORD PTR 384[rsp], 0
	mov	DWORD PTR 400[rsp], 0
	mov	DWORD PTR 164[rsp], ebx
	je	.L2064
	mov	ebx, DWORD PTR 4[rax]
	mov	DWORD PTR 188[rsp], 1
	mov	DWORD PTR 168[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 172[rsp], ebx
	mov	DWORD PTR 176[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 108[rsp], ebx
	mov	ebx, DWORD PTR 4[rax]
	mov	DWORD PTR 112[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 116[rsp], ebx
	mov	DWORD PTR 160[rsp], eax
.L2065:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	ecx, DWORD PTR 132[rax]
	test	ecx, ecx
	jne	.L2066
	mov	rax, QWORD PTR spans_dzpix@GOTPCREL[rip]
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 184[rsp], eax
	mov	edi, eax
.L2067:
	call	dz_compress@PLT
	mov	ebx, DWORD PTR 260[rsp]
	cmp	DWORD PTR 80[rsp], ebx
	mov	DWORD PTR 180[rsp], eax
	jg	.L2063
	shr	eax, 2
	mov	DWORD PTR 272[rsp], eax
	mov	eax, DWORD PTR 264[rsp]
	mov	DWORD PTR 100[rsp], eax
	lea	rax, 400[rsp]
	mov	QWORD PTR 192[rsp], rax
	lea	rax, 384[rsp]
	mov	QWORD PTR 200[rsp], rax
	lea	rax, 368[rsp]
	mov	QWORD PTR 208[rsp], rax
	lea	rax, 352[rsp]
	mov	QWORD PTR 216[rsp], rax
	.p2align 4,,10
	.p2align 3
.L2121:
	movsx	rax, DWORD PTR 80[rsp]
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	edx, DWORD PTR 12[rax]
	test	edx, edx
	je	.L2069
	mov	edi, DWORD PTR 4[rax]
	mov	edx, DWORD PTR [rax]
	mov	ebx, DWORD PTR 8[rax]
	mov	r13d, DWORD PTR 32[rax]
	mov	r12d, DWORD PTR 36[rax]
	mov	ebp, DWORD PTR 40[rax]
	mov	DWORD PTR 84[rsp], edi
	mov	edi, DWORD PTR 16[rax]
	mov	DWORD PTR 40[rsp], edi
	mov	edi, DWORD PTR 20[rax]
	mov	DWORD PTR 44[rsp], edi
	mov	edi, DWORD PTR 24[rax]
	mov	DWORD PTR 48[rsp], edi
	mov	edi, DWORD PTR 28[rax]
	mov	DWORD PTR 52[rsp], edi
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r15d, DWORD PTR 132[rdi]
	test	r15d, r15d
	jne	.L2070
	mov	eax, DWORD PTR 44[rax]
	mov	DWORD PTR 56[rsp], eax
.L2071:
	mov	rax, QWORD PTR fb_width@GOTPCREL[rip]
	mov	edi, DWORD PTR 80[rsp]
	mov	r14d, DWORD PTR 268[rsp]
	imul	edi, DWORD PTR [rax]
	mov	eax, DWORD PTR 84[rsp]
	add	eax, edi
	mov	edi, eax
	mov	DWORD PTR 152[rsp], eax
	mov	rax, QWORD PTR zb_address@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	lea	eax, [rax+rdi*2]
	mov	r15d, eax
	and	r15d, 16777215
	sar	r15d
	test	r14d, r14d
	jne	.L2072
	mov	edi, DWORD PTR 84[rsp]
	mov	eax, edi
	sub	ebx, edi
	mov	edi, DWORD PTR 80[rsp]
	sub	eax, edx
	mov	DWORD PTR 104[rsp], eax
	call	compute_cvg_noflip@PLT
.L2073:
	test	ebx, ebx
	je	.L2074
	mov	eax, DWORD PTR 164[rsp]
	imul	eax, ebx
	add	DWORD PTR 40[rsp], eax
	mov	eax, DWORD PTR 168[rsp]
	imul	eax, ebx
	add	DWORD PTR 44[rsp], eax
	mov	eax, DWORD PTR 172[rsp]
	imul	eax, ebx
	add	DWORD PTR 48[rsp], eax
	mov	eax, DWORD PTR 176[rsp]
	imul	eax, ebx
	add	DWORD PTR 52[rsp], eax
	mov	eax, DWORD PTR 160[rsp]
	imul	eax, ebx
	add	DWORD PTR 56[rsp], eax
	mov	eax, DWORD PTR 108[rsp]
	imul	eax, ebx
	add	r13d, eax
	mov	eax, DWORD PTR 112[rsp]
	imul	eax, ebx
	imul	ebx, DWORD PTR 116[rsp]
	add	r12d, eax
	add	ebp, ebx
.L2074:
	mov	ebx, DWORD PTR 104[rsp]
	test	ebx, ebx
	js	.L2069
	lea	rbx, 320[rsp]
	mov	eax, DWORD PTR 116[rsp]
	mov	DWORD PTR 36[rsp], ebp
	mov	DWORD PTR 28[rsp], r13d
	mov	DWORD PTR 32[rsp], r12d
	mov	QWORD PTR 136[rsp], rbx
	lea	rbx, 336[rsp]
	mov	DWORD PTR 60[rsp], 0
	add	eax, ebp
	mov	r14, QWORD PTR special_9bit_clamptable@GOTPCREL[rip]
	mov	QWORD PTR 144[rsp], rbx
	lea	rbx, 304[rsp]
	mov	DWORD PTR 88[rsp], eax
	mov	eax, DWORD PTR 108[rsp]
	mov	QWORD PTR 128[rsp], rbx
	lea	rbx, 288[rsp]
	add	eax, r13d
	mov	QWORD PTR 120[rsp], rbx
	lea	rbx, 464[rsp]
	mov	DWORD PTR 96[rsp], eax
	mov	eax, DWORD PTR 112[rsp]
	mov	QWORD PTR 224[rsp], rbx
	lea	rbx, 448[rsp]
	add	eax, r12d
	mov	QWORD PTR 232[rsp], rbx
	lea	rbx, 432[rsp]
	mov	DWORD PTR 92[rsp], eax
	mov	eax, DWORD PTR 84[rsp]
	mov	QWORD PTR 240[rsp], rbx
	lea	rbx, 416[rsp]
	mov	ebp, eax
	mov	QWORD PTR 248[rsp], rbx
	mov	ebx, r15d
	jmp	.L2119
	.p2align 4,,10
	.p2align 3
.L2168:
	test	r13d, 131072
	jne	.L2076
	mov	eax, r13d
	and	eax, 98304
	cmp	eax, 32768
	je	.L2075
	cmp	eax, 65536
	je	.L2076
	movzx	eax, r13w
	mov	DWORD PTR 384[rsp], eax
.L2077:
	test	r12d, 262144
	jne	.L2078
.L2169:
	test	r12d, 131072
	jne	.L2079
	mov	eax, r12d
	and	eax, 98304
	cmp	eax, 32768
	je	.L2078
	cmp	eax, 65536
	je	.L2079
	movzx	esi, r12w
	mov	DWORD PTR 400[rsp], esi
	.p2align 4,,10
	.p2align 3
.L2080:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r11d, DWORD PTR 148[rax]
	test	r11d, r11d
	jne	.L2165
.L2094:
	mov	edx, DWORD PTR 100[rsp]
	mov	edi, DWORD PTR 384[rsp]
	call	texture_pipeline_cycle.constprop.9
	cmp	DWORD PTR 320[rsp], 8
	je	.L2166
	mov	rsi, QWORD PTR spans_cd_rgba@GOTPCREL[rip]
	mov	rcx, QWORD PTR spans_d_rgba_dy@GOTPCREL[rip]
	movzx	eax, BYTE PTR 158[rsp]
	movzx	edx, BYTE PTR 157[rsp]
	mov	r10d, DWORD PTR 64[rsp]
	mov	r8d, DWORD PTR [rsi]
	mov	edi, DWORD PTR [rcx]
	mov	r9d, DWORD PTR 4[rsi]
	imul	r8d, edx
	imul	edi, eax
	add	edi, r8d
	lea	r8d, [rdi+r10*4]
	mov	edi, DWORD PTR 4[rcx]
	mov	r10d, DWORD PTR 68[rsp]
	imul	r9d, edx
	sar	r8d, 4
	imul	edi, eax
	add	edi, r9d
	mov	r9d, DWORD PTR 8[rsi]
	lea	r15d, [rdi+r15*4]
	mov	edi, DWORD PTR 8[rcx]
	imul	r9d, edx
	sar	r15d, 4
	imul	edi, eax
	add	edi, r9d
	lea	edi, [rdi+r10*4]
	mov	r10d, DWORD PTR 12[rsi]
	sar	edi, 4
	imul	r10d, edx
	mov	esi, r10d
	mov	r10d, DWORD PTR 12[rcx]
	imul	r10d, eax
	mov	ecx, r10d
	add	ecx, esi
	mov	esi, DWORD PTR 72[rsp]
	lea	ecx, [rcx+rsi*4]
	mov	rsi, QWORD PTR spans_cdz@GOTPCREL[rip]
	sar	ecx, 4
	imul	edx, DWORD PTR [rsi]
	mov	rsi, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	imul	eax, DWORD PTR 12[rsi]
	add	eax, edx
	mov	edx, DWORD PTR 76[rsp]
	lea	edx, [rax+rdx*4]
	sar	edx, 5
.L2096:
	and	r8d, 511
	mov	rsi, QWORD PTR shade_color@GOTPCREL[rip]
	and	r15d, 511
	mov	eax, DWORD PTR [r14+r8*4]
	and	edi, 511
	and	ecx, 511
	mov	r13d, 262143
	mov	DWORD PTR [rsi], eax
	mov	eax, DWORD PTR [r14+r15*4]
	mov	DWORD PTR 4[rsi], eax
	mov	eax, DWORD PTR [r14+rdi*4]
	mov	DWORD PTR 8[rsi], eax
	mov	eax, DWORD PTR [r14+rcx*4]
	mov	DWORD PTR 12[rsi], eax
	mov	eax, edx
	and	eax, 393216
	sar	eax, 17
	cmp	eax, 2
	je	.L2099
	xor	r13d, r13d
	and	edx, 262143
	cmp	eax, 3
	cmovne	r13, rdx
.L2099:
	mov	rcx, QWORD PTR 208[rsp]
	mov	rdx, QWORD PTR 216[rsp]
	mov	edi, ebp
	mov	esi, DWORD PTR 80[rsp]
	call	[QWORD PTR get_dither_noise_ptr[rip]]
	mov	r15, QWORD PTR 136[rsp]
	mov	edi, DWORD PTR 368[rsp]
	mov	rsi, r15
	call	combiner_2cycle@PLT
	mov	r12d, DWORD PTR 152[rsp]
	sub	r12d, DWORD PTR 84[rsp]
	mov	rax, QWORD PTR fbread2_ptr@GOTPCREL[rip]
	mov	rsi, QWORD PTR 144[rsp]
	add	r12d, ebp
	mov	edi, r12d
	call	[QWORD PTR [rax]]
	mov	eax, DWORD PTR 336[rsp]
	mov	r9, QWORD PTR 128[rsp]
	mov	esi, r13d
	mov	r8, QWORD PTR 120[rsp]
	mov	ecx, DWORD PTR 180[rsp]
	mov	edi, ebx
	mov	edx, DWORD PTR 184[rsp]
	mov	QWORD PTR [rsp], r15
	mov	DWORD PTR 8[rsp], eax
	call	z_compare@PLT
	test	eax, eax
	jne	.L2167
.L2102:
	mov	rax, QWORD PTR pre_memory_color@GOTPCREL[rip]
	mov	rcx, QWORD PTR memory_color@GOTPCREL[rip]
	add	DWORD PTR 60[rsp], 1
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rcx], rax
	mov	rax, QWORD PTR blshifta@GOTPCREL[rip]
	mov	QWORD PTR 8[rcx], rdx
	mov	rdx, QWORD PTR pastblshifta@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR blshiftb@GOTPCREL[rip]
	mov	rdx, QWORD PTR pastblshiftb@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	mov	eax, DWORD PTR 164[rsp]
	add	DWORD PTR 40[rsp], eax
	mov	eax, DWORD PTR 168[rsp]
	add	DWORD PTR 44[rsp], eax
	mov	eax, DWORD PTR 172[rsp]
	add	DWORD PTR 48[rsp], eax
	mov	eax, DWORD PTR 176[rsp]
	add	DWORD PTR 52[rsp], eax
	mov	eax, DWORD PTR 160[rsp]
	add	DWORD PTR 56[rsp], eax
	mov	eax, DWORD PTR 188[rsp]
	add	ebx, eax
	add	ebp, eax
	mov	eax, DWORD PTR 108[rsp]
	and	ebx, 8388607
	add	DWORD PTR 28[rsp], eax
	mov	ecx, DWORD PTR 112[rsp]
	mov	esi, DWORD PTR 116[rsp]
	add	DWORD PTR 96[rsp], eax
	add	DWORD PTR 32[rsp], ecx
	mov	eax, DWORD PTR 60[rsp]
	add	DWORD PTR 36[rsp], esi
	add	DWORD PTR 88[rsp], esi
	add	DWORD PTR 92[rsp], ecx
	cmp	DWORD PTR 104[rsp], eax
	jl	.L2069
.L2119:
	mov	eax, DWORD PTR 40[rsp]
	mov	rdx, QWORD PTR cvgbuf@GOTPCREL[rip]
	mov	rcx, QWORD PTR cvarray@GOTPCREL[rip]
	mov	esi, DWORD PTR 32[rsp]
	mov	edi, DWORD PTR 28[rsp]
	mov	r15d, DWORD PTR 44[rsp]
	sar	eax, 14
	mov	r8, QWORD PTR 192[rsp]
	mov	DWORD PTR 64[rsp], eax
	mov	eax, DWORD PTR 48[rsp]
	sar	esi, 16
	sar	edi, 16
	sar	r15d, 14
	sar	eax, 14
	mov	DWORD PTR 68[rsp], eax
	mov	eax, DWORD PTR 52[rsp]
	sar	eax, 14
	mov	DWORD PTR 72[rsp], eax
	mov	eax, DWORD PTR 56[rsp]
	shr	eax, 10
	mov	DWORD PTR 76[rsp], eax
	movsx	rax, ebp
	movzx	eax, BYTE PTR [rdx+rax]
	lea	rax, [rcx+rax*4]
	movzx	edx, BYTE PTR 1[rax]
	movzx	ecx, BYTE PTR 2[rax]
	mov	BYTE PTR 159[rsp], dl
	movzx	edx, BYTE PTR 3[rax]
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR 157[rsp], cl
	mov	rcx, QWORD PTR 200[rsp]
	mov	BYTE PTR 158[rsp], dl
	mov	edx, DWORD PTR 36[rsp]
	mov	DWORD PTR 320[rsp], eax
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r13d, DWORD PTR 384[rsp]
	mov	r12d, DWORD PTR 400[rsp]
	test	r13d, 262144
	je	.L2168
.L2075:
	test	r12d, 262144
	mov	DWORD PTR 384[rsp], 32767
	je	.L2169
.L2078:
	mov	DWORD PTR 400[rsp], 32767
	mov	esi, 32767
	jmp	.L2080
	.p2align 4,,10
	.p2align 3
.L2076:
	mov	DWORD PTR 384[rsp], 32768
	jmp	.L2077
	.p2align 4,,10
	.p2align 3
.L2165:
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	edx, DWORD PTR 28[rsp]
	mov	ecx, DWORD PTR 36[rsp]
	mov	edi, DWORD PTR 96[rsp]
	mov	esi, DWORD PTR 92[rsp]
	mov	r8, QWORD PTR 224[rsp]
	add	edx, DWORD PTR [rax]
	add	ecx, DWORD PTR 8[rax]
	sar	edi, 16
	sar	esi, 16
	mov	DWORD PTR 448[rsp], edi
	mov	DWORD PTR 464[rsp], esi
	sar	edx, 16
	mov	DWORD PTR 416[rsp], edx
	mov	edx, DWORD PTR 32[rsp]
	add	edx, DWORD PTR 4[rax]
	mov	eax, ecx
	mov	rcx, QWORD PTR 232[rsp]
	sar	eax, 16
	mov	DWORD PTR 256[rsp], eax
	sar	edx, 16
	mov	DWORD PTR 432[rsp], edx
	mov	edx, DWORD PTR 88[rsp]
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	eax, DWORD PTR 256[rsp]
	mov	r8, QWORD PTR 240[rsp]
	mov	esi, DWORD PTR 432[rsp]
	mov	edi, DWORD PTR 416[rsp]
	mov	rcx, QWORD PTR 248[rsp]
	mov	edx, eax
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r10d, DWORD PTR 464[rsp]
	mov	r9d, DWORD PTR 448[rsp]
	mov	edx, r13d
	mov	esi, r12d
	sal	edx, 15
	mov	r8d, DWORD PTR 416[rsp]
	sal	esi, 15
	sar	edx, 15
	mov	edi, DWORD PTR 432[rsp]
	mov	r11d, r9d
	mov	eax, r10d
	sar	esi, 15
	sal	r11d, 15
	sal	eax, 15
	sar	eax, 15
	sar	r11d, 15
	sub	eax, esi
	sub	r11d, edx
	jns	.L2082
	not	r11d
	and	r11d, 131071
.L2082:
	test	eax, 131072
	je	.L2083
	not	eax
	and	eax, 131071
.L2083:
	xor	ecx, ecx
	test	r11d, r11d
	cmovns	ecx, r11d
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	ecx, eax
	and	ecx, 32767
	mov	r11d, ecx
	or	r11d, 16384
	test	eax, 114688
	mov	eax, edi
	cmovne	ecx, r11d
	mov	r11d, r8d
	sal	eax, 15
	sal	r11d, 15
	sar	eax, 15
	sar	r11d, 15
	sub	eax, esi
	sub	r11d, edx
	jns	.L2085
	not	r11d
	and	r11d, 131071
.L2085:
	test	eax, 131072
	je	.L2086
	not	eax
	and	eax, 131071
.L2086:
	cmp	r11d, ecx
	cmovl	r11d, ecx
	cmp	r11d, eax
	cmovge	eax, r11d
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L2088
	or	r12d, r13d
	or	r12d, r10d
	or	r12d, r9d
	or	r12d, r8d
	or	r12d, edi
	sar	r12d, 17
	mov	eax, r12d
	shr	eax
	or	eax, r12d
	test	al, 1
	jne	.L2088
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	r11d, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, r11d
	cmovge	r11d, edx
	mov	edx, r11d
	lea	r9d, -32[r11]
	sar	edx, 5
	movzx	edx, dl
	sar	r9d, 31
	test	r11d, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	edi, ecx
	jne	.L2170
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	mov	r10d, r9d
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	r11d, 3
	and	r9d, 1
	neg	esi
	mov	r8d, esi
	and	r8d, 1
.L2090:
	sar	r11d, cl
	mov	rcx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, r11d
	mov	edx, DWORD PTR 12[rcx]
	mov	ecx, DWORD PTR 8[rcx]
	mov	r13d, ecx
	or	r13d, edx
	jne	.L2091
	mov	eax, r10d
	not	eax
	and	eax, r11d
	or	eax, esi
.L2091:
	and	edx, r10d
	movzx	eax, al
	sal	edx, 8
	or	eax, edx
	movzx	eax, ax
	mov	DWORD PTR lod_frac[rip], eax
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r10d, DWORD PTR 16[rax]
	test	r10d, r10d
	je	.L2164
	test	r8d, r8d
	je	.L2093
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
.L2093:
	not	r9d
	and	r9d, ecx
	add	r9d, DWORD PTR 264[rsp]
	lea	eax, [r9+rdi]
	mov	DWORD PTR 100[rsp], eax
	and	DWORD PTR 100[rsp], 7
.L2164:
	mov	esi, DWORD PTR 400[rsp]
	jmp	.L2094
	.p2align 4,,10
	.p2align 3
.L2167:
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	ecx, DWORD PTR 320[rsp]
	mov	r11d, DWORD PTR 304[rsp]
	mov	edx, DWORD PTR 288[rsp]
	mov	r10d, DWORD PTR 352[rsp]
	mov	esi, DWORD PTR 140[rdi]
	mov	eax, DWORD PTR 12[rax]
	test	esi, esi
	jne	.L2103
.L2108:
	mov	r15d, DWORD PTR 128[rdi]
	test	r15d, r15d
	je	.L2171
	test	ecx, ecx
	setne	cl
.L2110:
	test	cl, cl
	je	.L2102
	mov	rdi, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rsi, QWORD PTR [rdi]
	mov	rdi, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rsi]
	not	ecx
	and	ecx, 255
	mov	DWORD PTR 12[rdi], ecx
	mov	rcx, QWORD PTR blender2b_a@GOTPCREL[rip]
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r9d, DWORD PTR [rsi]
	mov	rcx, QWORD PTR [rcx]
	mov	edi, DWORD PTR 160[rdi]
	sar	r9d, 3
	mov	esi, DWORD PTR [rcx]
	sar	esi, 3
	test	edi, edi
	je	.L2111
	mov	rcx, QWORD PTR pastblshifta@GOTPCREL[rip]
	mov	rdi, QWORD PTR pastblshiftb@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	sar	r9d, cl
	mov	ecx, DWORD PTR [rdi]
	and	r9d, 60
	sar	esi, cl
	or	esi, 3
.L2111:
	lea	ecx, 1[rsi]
	mov	rsi, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rsi, QWORD PTR [rsi]
	mov	edi, DWORD PTR [rsi]
	mov	rsi, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rsi, QWORD PTR [rsi]
	imul	edi, r9d
	mov	r15d, DWORD PTR [rsi]
	mov	rsi, QWORD PTR blender1a_g@GOTPCREL[rip]
	imul	r15d, ecx
	mov	rsi, QWORD PTR [rsi]
	add	edi, r15d
	sar	edi, 5
	movzx	edi, dil
	mov	DWORD PTR 432[rsp], edi
	mov	r8d, DWORD PTR [rsi]
	mov	rsi, QWORD PTR blender2a_g@GOTPCREL[rip]
	imul	r8d, r9d
	mov	rsi, QWORD PTR [rsi]
	mov	r15d, DWORD PTR [rsi]
	imul	r15d, ecx
	mov	esi, r15d
	mov	r15, QWORD PTR blender1a_b@GOTPCREL[rip]
	add	esi, r8d
	sar	esi, 5
	mov	r8, QWORD PTR [r15]
	movzx	esi, sil
	mov	DWORD PTR 448[rsp], esi
	imul	r9d, DWORD PTR [r8]
	mov	r8, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	r15, QWORD PTR [r8]
	imul	ecx, DWORD PTR [r15]
	add	r9d, ecx
	mov	rcx, QWORD PTR pre_memory_color@GOTPCREL[rip]
	sar	r9d, 5
	movzx	r9d, r9b
	movdqa	xmm1, XMMWORD PTR [rcx]
	mov	rcx, QWORD PTR memory_color@GOTPCREL[rip]
	mov	DWORD PTR 464[rsp], r9d
	movdqa	XMMWORD PTR [rcx], xmm1
	mov	rcx, QWORD PTR blended_pixel_color@GOTPCREL[rip]
	mov	DWORD PTR [rcx], edi
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	DWORD PTR 4[rcx], esi
	mov	DWORD PTR 8[rcx], r9d
	mov	DWORD PTR 12[rcx], eax
	mov	ecx, DWORD PTR 112[rdi]
	test	ecx, ecx
	je	.L2112
	test	r11d, r11d
	jne	.L2112
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 432[rsp], eax
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 448[rsp], eax
	mov	rax, QWORD PTR 8[r8]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 464[rsp], eax
.L2117:
	mov	ecx, r10d
	mov	rdx, QWORD PTR 224[rsp]
	mov	rsi, QWORD PTR 232[rsp]
	mov	rdi, QWORD PTR 240[rsp]
	call	[QWORD PTR rgb_dither_ptr[rip]]
	mov	eax, DWORD PTR 336[rsp]
	mov	r9d, DWORD PTR 320[rsp]
	mov	edi, r12d
	mov	r8d, DWORD PTR 288[rsp]
	mov	ecx, DWORD PTR 464[rsp]
	mov	edx, DWORD PTR 448[rsp]
	mov	esi, DWORD PTR 432[rsp]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR fbwrite_ptr@GOTPCREL[rip]
	call	[QWORD PTR [rax]]
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r11d, DWORD PTR 120[rax]
	test	r11d, r11d
	je	.L2102
	mov	rax, QWORD PTR z_com_table@GOTPCREL[rip]
	movzx	edx, WORD PTR [rax+r13*2]
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	cmp	ebx, DWORD PTR [rax]
	ja	.L2102
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	or	dx, WORD PTR 272[rsp]
	mov	ecx, ebx
	xor	ecx, 1
	mov	rax, QWORD PTR [rax]
	mov	WORD PTR [rax+rcx*2], dx
	movzx	ecx, BYTE PTR 180[rsp]
	mov	eax, ebx
	mov	rdx, QWORD PTR hidden_bits@GOTPCREL[rip]
	and	ecx, 3
	mov	BYTE PTR [rdx+rax], cl
	jmp	.L2102
	.p2align 4,,10
	.p2align 3
.L2166:
	mov	r8d, DWORD PTR 64[rsp]
	mov	edi, DWORD PTR 68[rsp]
	sar	r15d, 2
	mov	ecx, DWORD PTR 72[rsp]
	mov	edx, DWORD PTR 76[rsp]
	sar	r8d, 2
	sar	edi, 2
	sar	ecx, 2
	sar	edx, 3
	jmp	.L2096
	.p2align 4,,10
	.p2align 3
.L2079:
	mov	DWORD PTR 400[rsp], 32768
	mov	esi, 32768
	jmp	.L2080
	.p2align 4,,10
	.p2align 3
.L2088:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r9d, r9d
	mov	r8d, 1
	xor	r10d, r10d
	mov	r11d, 262136
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	edi, ecx
	jmp	.L2090
	.p2align 4,,10
	.p2align 3
.L2069:
	add	DWORD PTR 80[rsp], 1
	mov	eax, DWORD PTR 80[rsp]
	cmp	DWORD PTR 260[rsp], eax
	jge	.L2121
.L2063:
	add	rsp, 488
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
.L2171:
	.cfi_restore_state
	cmp	BYTE PTR 159[rsp], 0
	setne	cl
	jmp	.L2110
	.p2align 4,,10
	.p2align 3
.L2103:
	mov	r9d, DWORD PTR 136[rdi]
	test	r9d, r9d
	jne	.L2106
	mov	rsi, QWORD PTR blend_color@GOTPCREL[rip]
	mov	esi, DWORD PTR 12[rsi]
.L2107:
	cmp	eax, esi
	jl	.L2102
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	jmp	.L2108
	.p2align 4,,10
	.p2align 3
.L2112:
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r15d, DWORD PTR 156[rdi]
	test	r15d, r15d
	je	.L2114
	cmp	eax, 254
	jg	.L2115
.L2114:
	test	edx, edx
	jne	.L2116
.L2115:
	mov	rax, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 432[rsp], eax
	mov	rax, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 448[rsp], eax
	mov	rax, QWORD PTR blender1a_b@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 464[rsp], eax
	jmp	.L2117
	.p2align 4,,10
	.p2align 3
.L2072:
	mov	eax, DWORD PTR 84[rsp]
	mov	edi, DWORD PTR 80[rsp]
	sub	edx, eax
	sub	eax, ebx
	mov	DWORD PTR 104[rsp], edx
	mov	ebx, eax
	call	compute_cvg_flip@PLT
	jmp	.L2073
	.p2align 4,,10
	.p2align 3
.L2070:
	mov	rax, QWORD PTR primitive_z@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 56[rsp], eax
	jmp	.L2071
	.p2align 4,,10
	.p2align 3
.L2106:
	mov	rdi, QWORD PTR iseed@GOTPCREL[rip]
	mov	r8d, DWORD PTR [rdi]
	imul	esi, r8d, 214013
	add	esi, 2531011
	mov	DWORD PTR [rdi], esi
	sar	esi, 16
	movzx	esi, sil
	jmp	.L2107
	.p2align 4,,10
	.p2align 3
.L2116:
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rsi, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	rdx, QWORD PTR 224[rsp]
	mov	rdi, QWORD PTR 240[rsp]
	mov	DWORD PTR 64[rsp], r10d
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	not	eax
	and	eax, 255
	mov	DWORD PTR 12[rsi], eax
	mov	rsi, QWORD PTR 232[rsp]
	call	blender_equation_cycle1@PLT
	mov	r10d, DWORD PTR 64[rsp]
	jmp	.L2117
.L2066:
	mov	rax, QWORD PTR primitive_delta_z@GOTPCREL[rip]
	mov	DWORD PTR 160[rsp], 0
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 184[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	edi, DWORD PTR 184[rsp]
	mov	DWORD PTR 12[rax], 0
	mov	rax, QWORD PTR spans_cdz@GOTPCREL[rip]
	mov	DWORD PTR [rax], 0
	jmp	.L2067
.L2064:
	mov	ebx, DWORD PTR 4[rax]
	neg	DWORD PTR 164[rsp]
	mov	DWORD PTR 188[rsp], -1
	mov	DWORD PTR 168[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 168[rsp]
	mov	DWORD PTR 172[rsp], ebx
	neg	DWORD PTR 172[rsp]
	mov	DWORD PTR 176[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	neg	DWORD PTR 176[rsp]
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 108[rsp], ebx
	mov	ebx, DWORD PTR 4[rax]
	neg	DWORD PTR 108[rsp]
	mov	DWORD PTR 112[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 112[rsp]
	mov	DWORD PTR 116[rsp], ebx
	neg	DWORD PTR 116[rsp]
	mov	DWORD PTR 160[rsp], eax
	neg	DWORD PTR 160[rsp]
	jmp	.L2065
.L2170:
	mov	r10d, r9d
	sal	r11d, 3
	and	r9d, 1
	mov	r8d, 1
	mov	esi, -1
	jmp	.L2090
	.cfi_endproc
.LFE590:
	.size	render_spans_2cycle_notexel1, .-render_spans_2cycle_notexel1
	.p2align 4,,15
	.globl	render_spans_1cycle_notexel1
	.type	render_spans_1cycle_notexel1, @function
render_spans_1cycle_notexel1:
.LFB586:
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
	mov	ebx, edi
	sub	rsp, 504
	.cfi_def_cfa_offset 560
	mov	rax, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	test	ecx, ecx
	mov	DWORD PTR 296[rsp], esi
	mov	DWORD PTR 292[rsp], edx
	mov	DWORD PTR 300[rsp], ecx
	mov	DWORD PTR 368[rsp], 7
	mov	esi, DWORD PTR [rax]
	mov	DWORD PTR 384[rsp], 0
	mov	DWORD PTR 400[rsp], 0
	mov	DWORD PTR 416[rsp], 0
	mov	DWORD PTR 192[rsp], esi
	je	.L2173
	mov	esi, DWORD PTR 4[rax]
	mov	DWORD PTR 248[rsp], 1
	mov	DWORD PTR 196[rsp], esi
	mov	esi, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 200[rsp], esi
	mov	DWORD PTR 204[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	mov	esi, DWORD PTR [rax]
	mov	DWORD PTR 136[rsp], esi
	mov	esi, DWORD PTR 4[rax]
	mov	DWORD PTR 140[rsp], esi
	mov	esi, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 144[rsp], esi
	mov	DWORD PTR 188[rsp], eax
.L2174:
	mov	r13, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r10d, DWORD PTR 132[r13]
	test	r10d, r10d
	jne	.L2175
	mov	rax, QWORD PTR spans_dzpix@GOTPCREL[rip]
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 212[rsp], eax
	mov	edi, eax
.L2176:
	call	dz_compress@PLT
	cmp	ebx, DWORD PTR 296[rsp]
	mov	DWORD PTR 208[rsp], eax
	jg	.L2172
	shr	eax, 2
	mov	edi, DWORD PTR 144[rsp]
	mov	DWORD PTR 304[rsp], eax
	lea	eax, 1[rbx]
	mov	DWORD PTR 264[rsp], eax
	mov	eax, DWORD PTR 292[rsp]
	lea	esi, [rdi+rdi]
	mov	edi, DWORD PTR 136[rsp]
	mov	DWORD PTR 272[rsp], esi
	mov	DWORD PTR 124[rsp], eax
	lea	rax, 416[rsp]
	lea	esi, [rdi+rdi]
	mov	edi, DWORD PTR 140[rsp]
	mov	QWORD PTR 216[rsp], rax
	lea	rax, 400[rsp]
	mov	DWORD PTR 276[rsp], esi
	mov	QWORD PTR 224[rsp], rax
	lea	rax, 384[rsp]
	lea	esi, [rdi+rdi]
	mov	QWORD PTR 232[rsp], rax
	lea	rax, 368[rsp]
	mov	DWORD PTR 280[rsp], esi
	mov	QWORD PTR 240[rsp], rax
	.p2align 4,,10
	.p2align 3
.L2236:
	mov	eax, DWORD PTR 264[rsp]
	sub	eax, 1
	mov	DWORD PTR 128[rsp], eax
	cdqe
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	r9d, DWORD PTR 12[rax]
	test	r9d, r9d
	je	.L2282
	mov	esi, DWORD PTR 4[rax]
	mov	r8d, DWORD PTR 132[r13]
	mov	edx, DWORD PTR [rax]
	mov	ebx, DWORD PTR 8[rax]
	mov	DWORD PTR 132[rsp], esi
	mov	esi, DWORD PTR 16[rax]
	test	r8d, r8d
	mov	DWORD PTR 48[rsp], esi
	mov	esi, DWORD PTR 20[rax]
	mov	DWORD PTR 52[rsp], esi
	mov	esi, DWORD PTR 24[rax]
	mov	DWORD PTR 56[rsp], esi
	mov	esi, DWORD PTR 28[rax]
	mov	DWORD PTR 60[rsp], esi
	mov	esi, DWORD PTR 32[rax]
	mov	DWORD PTR 96[rsp], esi
	mov	esi, DWORD PTR 36[rax]
	mov	DWORD PTR 100[rsp], esi
	mov	esi, DWORD PTR 40[rax]
	mov	DWORD PTR 104[rsp], esi
	jne	.L2180
	mov	eax, DWORD PTR 44[rax]
	mov	DWORD PTR 88[rsp], eax
.L2181:
	mov	rax, QWORD PTR fb_width@GOTPCREL[rip]
	mov	esi, DWORD PTR 128[rsp]
	mov	edi, DWORD PTR 300[rsp]
	imul	esi, DWORD PTR [rax]
	mov	eax, DWORD PTR 132[rsp]
	add	eax, esi
	mov	esi, eax
	mov	DWORD PTR 148[rsp], eax
	mov	rax, QWORD PTR zb_address@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	lea	eax, [rax+rsi*2]
	mov	r14d, eax
	and	r14d, 16777215
	sar	r14d
	test	edi, edi
	jne	.L2182
	mov	esi, DWORD PTR 132[rsp]
	mov	edi, DWORD PTR 128[rsp]
	mov	eax, esi
	sub	ebx, esi
	sub	eax, edx
	mov	DWORD PTR 108[rsp], eax
	call	compute_cvg_noflip@PLT
.L2183:
	xor	eax, eax
	cmp	DWORD PTR 108[rsp], 7
	setg	al
	test	ebx, ebx
	mov	DWORD PTR 284[rsp], eax
	je	.L2184
	mov	eax, DWORD PTR 192[rsp]
	imul	eax, ebx
	add	DWORD PTR 48[rsp], eax
	mov	eax, DWORD PTR 196[rsp]
	imul	eax, ebx
	add	DWORD PTR 52[rsp], eax
	mov	eax, DWORD PTR 200[rsp]
	imul	eax, ebx
	add	DWORD PTR 56[rsp], eax
	mov	eax, DWORD PTR 204[rsp]
	imul	eax, ebx
	add	DWORD PTR 60[rsp], eax
	mov	eax, DWORD PTR 188[rsp]
	imul	eax, ebx
	add	DWORD PTR 88[rsp], eax
	mov	eax, DWORD PTR 136[rsp]
	imul	eax, ebx
	add	DWORD PTR 96[rsp], eax
	mov	eax, DWORD PTR 140[rsp]
	imul	eax, ebx
	add	DWORD PTR 100[rsp], eax
	imul	ebx, DWORD PTR 144[rsp]
	add	DWORD PTR 104[rsp], ebx
.L2184:
	mov	esi, DWORD PTR 108[rsp]
	test	esi, esi
	js	.L2282
	mov	ebx, DWORD PTR 144[rsp]
	add	ebx, DWORD PTR 104[rsp]
	lea	rsi, 352[rsp]
	mov	eax, DWORD PTR 108[rsp]
	lea	rdi, 444[rsp]
	mov	r15, QWORD PTR special_9bit_clamptable@GOTPCREL[rip]
	mov	QWORD PTR 168[rsp], rsi
	lea	rsi, 336[rsp]
	mov	DWORD PTR 44[rsp], 0
	mov	QWORD PTR 176[rsp], rdi
	lea	rdi, 320[rsp]
	mov	DWORD PTR 32[rsp], 0
	mov	DWORD PTR 116[rsp], ebx
	mov	ebx, DWORD PTR 136[rsp]
	sub	eax, 1
	add	ebx, DWORD PTR 96[rsp]
	mov	DWORD PTR 288[rsp], eax
	movsx	rax, DWORD PTR 264[rsp]
	mov	DWORD PTR 40[rsp], 0
	mov	DWORD PTR 36[rsp], 0
	mov	QWORD PTR 160[rsp], rsi
	mov	QWORD PTR 152[rsp], rdi
	mov	DWORD PTR 28[rsp], r14d
	mov	DWORD PTR 120[rsp], ebx
	mov	ebx, DWORD PTR 140[rsp]
	add	ebx, DWORD PTR 100[rsp]
	mov	DWORD PTR 268[rsp], eax
	lea	rax, [rax+rax*2]
	mov	QWORD PTR 256[rsp], rax
	sal	QWORD PTR 256[rsp], 5
	mov	DWORD PTR 112[rsp], ebx
	mov	ebx, DWORD PTR 132[rsp]
	mov	ebp, ebx
	.p2align 4,,10
	.p2align 3
.L2234:
	mov	eax, DWORD PTR 48[rsp]
	mov	rdx, QWORD PTR cvgbuf@GOTPCREL[rip]
	mov	rcx, QWORD PTR cvarray@GOTPCREL[rip]
	mov	edi, DWORD PTR 40[rsp]
	add	edi, DWORD PTR 96[rsp]
	mov	r12d, DWORD PTR 60[rsp]
	sar	eax, 14
	mov	r14d, DWORD PTR 88[rsp]
	mov	r8, QWORD PTR 216[rsp]
	mov	DWORD PTR 64[rsp], eax
	mov	eax, DWORD PTR 52[rsp]
	sar	r12d, 14
	sar	edi, 16
	shr	r14d, 10
	sar	eax, 14
	mov	DWORD PTR 72[rsp], eax
	mov	eax, DWORD PTR 56[rsp]
	sar	eax, 14
	mov	DWORD PTR 80[rsp], eax
	movsx	rax, ebp
	movzx	eax, BYTE PTR [rdx+rax]
	lea	rax, [rcx+rax*4]
	movzx	edx, BYTE PTR 1[rax]
	movzx	esi, BYTE PTR 3[rax]
	movzx	ecx, BYTE PTR 2[rax]
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR 187[rsp], dl
	mov	BYTE PTR 186[rsp], sil
	mov	edx, DWORD PTR 44[rsp]
	mov	esi, DWORD PTR 32[rsp]
	add	edx, DWORD PTR 104[rsp]
	add	esi, DWORD PTR 100[rsp]
	mov	BYTE PTR 92[rsp], cl
	mov	DWORD PTR 352[rsp], eax
	mov	rcx, QWORD PTR 224[rsp]
	sar	esi, 16
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	eax, DWORD PTR 400[rsp]
	mov	esi, DWORD PTR 416[rsp]
	test	eax, 262144
	jne	.L2186
	test	eax, 131072
	jne	.L2187
	mov	edx, eax
	and	edx, 98304
	cmp	edx, 32768
	je	.L2186
	cmp	edx, 65536
	je	.L2187
	and	eax, 65535
	mov	DWORD PTR 400[rsp], eax
.L2188:
	test	esi, 262144
	jne	.L2189
.L2287:
	test	esi, 131072
	jne	.L2190
	mov	eax, esi
	and	eax, 98304
	cmp	eax, 32768
	je	.L2189
	cmp	eax, 65536
	je	.L2190
	movzx	esi, si
	mov	DWORD PTR 416[rsp], esi
	.p2align 4,,10
	.p2align 3
.L2191:
	mov	ecx, DWORD PTR 148[r13]
	test	ecx, ecx
	je	.L2210
	mov	rax, QWORD PTR 256[rsp]
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	edx, DWORD PTR 12[rax]
	test	edx, edx
	je	.L2193
	mov	ebx, DWORD PTR 108[rsp]
	cmp	DWORD PTR 36[rsp], ebx
	jne	.L2194
	mov	ebx, DWORD PTR 284[rsp]
	test	ebx, ebx
	jne	.L2283
	mov	edx, DWORD PTR 116[rsp]
	mov	edi, DWORD PTR 120[rsp]
	mov	esi, DWORD PTR 112[rsp]
	sar	edi, 16
	sar	edx, 16
	sar	esi, 16
	cmp	DWORD PTR 108[rsp], 7
	mov	DWORD PTR 464[rsp], edi
	mov	DWORD PTR 480[rsp], esi
	je	.L2198
	.p2align 4,,10
	.p2align 3
.L2279:
	mov	ecx, DWORD PTR 276[rsp]
	add	ecx, DWORD PTR 96[rsp]
	add	ecx, DWORD PTR 40[rsp]
	mov	eax, DWORD PTR 272[rsp]
	add	eax, DWORD PTR 104[rsp]
	add	eax, DWORD PTR 44[rsp]
	sar	ecx, 16
	mov	DWORD PTR 432[rsp], ecx
	mov	ecx, DWORD PTR 280[rsp]
	add	ecx, DWORD PTR 100[rsp]
	sar	eax, 16
	add	ecx, DWORD PTR 32[rsp]
	sar	ecx, 16
	mov	DWORD PTR 448[rsp], ecx
.L2200:
	lea	r9, 464[rsp]
	mov	DWORD PTR 252[rsp], eax
	lea	r8, 480[rsp]
	mov	rcx, r9
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	eax, DWORD PTR 252[rsp]
	lea	rcx, 432[rsp]
	lea	r8, 448[rsp]
	mov	esi, DWORD PTR 448[rsp]
	mov	edi, DWORD PTR 432[rsp]
	mov	edx, eax
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r8d, DWORD PTR 448[rsp]
	mov	r9d, DWORD PTR 480[rsp]
	mov	edi, DWORD PTR 432[rsp]
	mov	esi, DWORD PTR 464[rsp]
	mov	eax, r8d
	mov	r10d, r9d
	mov	ecx, edi
	mov	edx, esi
	sal	eax, 15
	sal	ecx, 15
	sal	edx, 15
	sal	r10d, 15
	sar	eax, 15
	sar	r10d, 15
	sar	ecx, 15
	sar	edx, 15
	sub	eax, r10d
	sub	ecx, edx
	jns	.L2201
	not	ecx
	and	ecx, 131071
.L2201:
	test	eax, 131072
	je	.L2202
	not	eax
	and	eax, 131071
.L2202:
	xor	edx, edx
	test	ecx, ecx
	cmovns	edx, ecx
	cmp	edx, eax
	cmovge	eax, edx
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L2204
	or	r8d, r9d
	or	r8d, edi
	or	r8d, esi
	sar	r8d, 17
	mov	eax, r8d
	shr	eax
	or	eax, r8d
	test	al, 1
	jne	.L2204
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	r11d, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, r11d
	cmovge	r11d, edx
	mov	edx, r11d
	lea	r9d, -32[r11]
	sar	edx, 5
	movzx	edx, dl
	sar	r9d, 31
	test	r11d, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	edi, ecx
	jne	.L2284
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	mov	r10d, r9d
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	r11d, 3
	and	r9d, 1
	neg	esi
	mov	r8d, esi
	and	r8d, 1
.L2206:
	sar	r11d, cl
	mov	ecx, DWORD PTR 8[r13]
	mov	edx, DWORD PTR 12[r13]
	mov	eax, r11d
	mov	ebx, ecx
	or	ebx, edx
	jne	.L2207
	mov	eax, r10d
	not	eax
	and	eax, r11d
	or	eax, esi
.L2207:
	and	edx, r10d
	mov	r10d, DWORD PTR 16[r13]
	movzx	eax, al
	sal	edx, 8
	or	eax, edx
	movzx	eax, ax
	test	r10d, r10d
	mov	DWORD PTR lod_frac[rip], eax
	je	.L2280
	test	r8d, r8d
	je	.L2209
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
.L2209:
	not	r9d
	and	r9d, ecx
	add	r9d, DWORD PTR 292[rsp]
	lea	eax, [r9+rdi]
	mov	DWORD PTR 124[rsp], eax
	and	DWORD PTR 124[rsp], 7
.L2280:
	mov	esi, DWORD PTR 416[rsp]
.L2210:
	mov	edx, DWORD PTR 124[rsp]
	mov	edi, DWORD PTR 400[rsp]
	call	texture_pipeline_cycle.constprop.9
	cmp	DWORD PTR 352[rsp], 8
	je	.L2285
	mov	rsi, QWORD PTR spans_cd_rgba@GOTPCREL[rip]
	mov	rcx, QWORD PTR spans_d_rgba_dy@GOTPCREL[rip]
	movzx	eax, BYTE PTR 186[rsp]
	movzx	edx, BYTE PTR 92[rsp]
	mov	r11d, DWORD PTR 64[rsp]
	mov	r10d, DWORD PTR 72[rsp]
	mov	r8d, DWORD PTR [rsi]
	mov	edi, DWORD PTR [rcx]
	imul	r8d, edx
	imul	edi, eax
	add	edi, r8d
	mov	r8d, DWORD PTR 4[rsi]
	lea	r9d, [rdi+r11*4]
	mov	edi, DWORD PTR 4[rcx]
	mov	r11d, DWORD PTR 80[rsp]
	imul	r8d, edx
	sar	r9d, 4
	imul	edi, eax
	add	edi, r8d
	lea	r8d, [rdi+r10*4]
	mov	r10d, DWORD PTR 8[rsi]
	mov	edi, DWORD PTR 8[rcx]
	sar	r8d, 4
	imul	r10d, edx
	imul	edi, eax
	add	edi, r10d
	lea	edi, [rdi+r11*4]
	mov	r11d, DWORD PTR 12[rsi]
	sar	edi, 4
	imul	r11d, edx
	mov	esi, r11d
	mov	r11d, DWORD PTR 12[rcx]
	imul	r11d, eax
	mov	ecx, r11d
	add	ecx, esi
	lea	r12d, [rcx+r12*4]
	mov	rcx, QWORD PTR spans_cdz@GOTPCREL[rip]
	sar	r12d, 4
	imul	edx, DWORD PTR [rcx]
	mov	rcx, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	imul	eax, DWORD PTR 12[rcx]
	add	eax, edx
	lea	edx, [rax+r14*4]
	sar	edx, 5
.L2212:
	and	r9d, 511
	mov	rcx, QWORD PTR shade_color@GOTPCREL[rip]
	and	r8d, 511
	mov	eax, DWORD PTR [r15+r9*4]
	and	edi, 511
	and	r12d, 511
	mov	r14d, 262143
	mov	DWORD PTR [rcx], eax
	mov	eax, DWORD PTR [r15+r8*4]
	mov	DWORD PTR 4[rcx], eax
	mov	eax, DWORD PTR [r15+rdi*4]
	mov	DWORD PTR 8[rcx], eax
	mov	eax, DWORD PTR [r15+r12*4]
	mov	DWORD PTR 12[rcx], eax
	mov	eax, edx
	and	eax, 393216
	sar	eax, 17
	cmp	eax, 2
	je	.L2215
	xor	r14d, r14d
	and	edx, 262143
	cmp	eax, 3
	cmovne	r14, rdx
.L2215:
	mov	rcx, QWORD PTR 232[rsp]
	mov	rdx, QWORD PTR 240[rsp]
	mov	edi, ebp
	mov	esi, DWORD PTR 128[rsp]
	call	[QWORD PTR get_dither_noise_ptr[rip]]
	mov	rbx, QWORD PTR 168[rsp]
	mov	edi, DWORD PTR 384[rsp]
	mov	rsi, rbx
	call	combiner_1cycle@PLT
	mov	r12d, DWORD PTR 148[rsp]
	sub	r12d, DWORD PTR 132[rsp]
	mov	rdx, QWORD PTR fbread1_ptr@GOTPCREL[rip]
	mov	rsi, QWORD PTR 176[rsp]
	add	r12d, ebp
	mov	edi, r12d
	call	[QWORD PTR [rdx]]
	mov	eax, DWORD PTR 444[rsp]
	mov	r9, QWORD PTR 160[rsp]
	mov	esi, r14d
	mov	r8, QWORD PTR 152[rsp]
	mov	ecx, DWORD PTR 208[rsp]
	mov	edx, DWORD PTR 212[rsp]
	mov	edi, DWORD PTR 28[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	QWORD PTR [rsp], rbx
	call	z_compare@PLT
	test	eax, eax
	jne	.L2286
.L2218:
	mov	eax, DWORD PTR 192[rsp]
	add	DWORD PTR 48[rsp], eax
	mov	eax, DWORD PTR 196[rsp]
	add	DWORD PTR 52[rsp], eax
	mov	eax, DWORD PTR 200[rsp]
	add	DWORD PTR 56[rsp], eax
	mov	eax, DWORD PTR 204[rsp]
	add	DWORD PTR 60[rsp], eax
	mov	eax, DWORD PTR 188[rsp]
	add	DWORD PTR 88[rsp], eax
	mov	eax, DWORD PTR 248[rsp]
	add	DWORD PTR 28[rsp], eax
	mov	ecx, DWORD PTR 140[rsp]
	add	ebp, eax
	mov	esi, DWORD PTR 144[rsp]
	mov	eax, DWORD PTR 136[rsp]
	and	DWORD PTR 28[rsp], 8388607
	add	DWORD PTR 40[rsp], eax
	add	DWORD PTR 36[rsp], 1
	add	DWORD PTR 32[rsp], ecx
	add	DWORD PTR 44[rsp], esi
	add	DWORD PTR 116[rsp], esi
	add	DWORD PTR 120[rsp], eax
	mov	eax, DWORD PTR 36[rsp]
	add	DWORD PTR 112[rsp], ecx
	cmp	DWORD PTR 108[rsp], eax
	jge	.L2234
.L2179:
	add	DWORD PTR 264[rsp], 1
	mov	eax, DWORD PTR 268[rsp]
	cmp	DWORD PTR 296[rsp], eax
	jge	.L2236
.L2172:
	add	rsp, 504
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
.L2186:
	.cfi_restore_state
	test	esi, 262144
	mov	DWORD PTR 400[rsp], 32767
	je	.L2287
.L2189:
	mov	DWORD PTR 416[rsp], 32767
	mov	esi, 32767
	jmp	.L2191
	.p2align 4,,10
	.p2align 3
.L2204:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r9d, r9d
	mov	r8d, 1
	xor	r10d, r10d
	mov	r11d, 262136
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	edi, ecx
	jmp	.L2206
	.p2align 4,,10
	.p2align 3
.L2187:
	mov	DWORD PTR 400[rsp], 32768
	jmp	.L2188
	.p2align 4,,10
	.p2align 3
.L2286:
	mov	r8d, DWORD PTR 140[r13]
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	edx, DWORD PTR 352[rsp]
	mov	edi, DWORD PTR 336[rsp]
	mov	esi, DWORD PTR 320[rsp]
	mov	ecx, DWORD PTR 368[rsp]
	test	r8d, r8d
	mov	eax, DWORD PTR 12[rax]
	jne	.L2219
.L2224:
	mov	ebx, DWORD PTR 128[r13]
	test	ebx, ebx
	je	.L2288
	test	edx, edx
	setne	dl
.L2226:
	test	dl, dl
	je	.L2218
	mov	r8d, DWORD PTR 112[r13]
	test	r8d, r8d
	je	.L2227
	test	edi, edi
	jne	.L2227
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 448[rsp], eax
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 464[rsp], eax
	mov	rax, QWORD PTR blender2a_b@GOTPCREL[rip]
.L2281:
	mov	rax, QWORD PTR [rax]
	lea	r8, 480[rsp]
	lea	r9, 464[rsp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 480[rsp], eax
	lea	rax, 448[rsp]
.L2232:
	mov	rdx, r8
	mov	rsi, r9
	mov	rdi, rax
	call	[QWORD PTR rgb_dither_ptr[rip]]
	mov	eax, DWORD PTR 444[rsp]
	mov	esi, DWORD PTR 448[rsp]
	mov	edi, r12d
	mov	r9d, DWORD PTR 352[rsp]
	mov	r8d, DWORD PTR 320[rsp]
	mov	ecx, DWORD PTR 480[rsp]
	mov	edx, DWORD PTR 464[rsp]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR fbwrite_ptr@GOTPCREL[rip]
	call	[QWORD PTR [rax]]
	mov	esi, DWORD PTR 120[r13]
	test	esi, esi
	je	.L2218
	mov	rax, QWORD PTR z_com_table@GOTPCREL[rip]
	mov	ebx, DWORD PTR 28[rsp]
	movzx	edx, WORD PTR [rax+r14*2]
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	cmp	ebx, DWORD PTR [rax]
	ja	.L2218
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	or	dx, WORD PTR 304[rsp]
	mov	ecx, ebx
	xor	ecx, 1
	mov	rax, QWORD PTR [rax]
	mov	WORD PTR [rax+rcx*2], dx
	movzx	ecx, BYTE PTR 208[rsp]
	mov	eax, ebx
	mov	rdx, QWORD PTR hidden_bits@GOTPCREL[rip]
	and	ecx, 3
	mov	BYTE PTR [rdx+rax], cl
	jmp	.L2218
	.p2align 4,,10
	.p2align 3
.L2285:
	mov	r9d, DWORD PTR 64[rsp]
	mov	r8d, DWORD PTR 72[rsp]
	mov	edx, r14d
	mov	edi, DWORD PTR 80[rsp]
	sar	r12d, 2
	sar	edx, 3
	sar	r9d, 2
	sar	r8d, 2
	sar	edi, 2
	jmp	.L2212
	.p2align 4,,10
	.p2align 3
.L2190:
	mov	DWORD PTR 416[rsp], 32768
	mov	esi, 32768
	jmp	.L2191
	.p2align 4,,10
	.p2align 3
.L2193:
	mov	edi, DWORD PTR 120[rsp]
	mov	esi, DWORD PTR 112[rsp]
	mov	edx, DWORD PTR 116[rsp]
	sar	edi, 16
	sar	esi, 16
	sar	edx, 16
	mov	DWORD PTR 464[rsp], edi
	mov	DWORD PTR 480[rsp], esi
	jmp	.L2279
	.p2align 4,,10
	.p2align 3
.L2194:
	mov	edx, DWORD PTR 116[rsp]
	mov	edi, DWORD PTR 120[rsp]
	mov	esi, DWORD PTR 112[rsp]
	mov	eax, DWORD PTR 288[rsp]
	sar	edi, 16
	sar	edx, 16
	sar	esi, 16
	cmp	DWORD PTR 36[rsp], eax
	mov	DWORD PTR 464[rsp], edi
	mov	DWORD PTR 480[rsp], esi
	jne	.L2279
	mov	r11d, DWORD PTR 284[rsp]
	test	r11d, r11d
	je	.L2279
.L2198:
	mov	ecx, DWORD PTR 96[rsp]
	sub	ecx, DWORD PTR 136[rsp]
	add	ecx, DWORD PTR 40[rsp]
	mov	eax, DWORD PTR 104[rsp]
	sub	eax, DWORD PTR 144[rsp]
	add	eax, DWORD PTR 44[rsp]
	sar	ecx, 16
	mov	DWORD PTR 432[rsp], ecx
	mov	ecx, DWORD PTR 100[rsp]
	sub	ecx, DWORD PTR 140[rsp]
	sar	eax, 16
	add	ecx, DWORD PTR 32[rsp]
	sar	ecx, 16
	mov	DWORD PTR 448[rsp], ecx
	jmp	.L2200
	.p2align 4,,10
	.p2align 3
.L2282:
	mov	eax, DWORD PTR 264[rsp]
	mov	DWORD PTR 268[rsp], eax
	jmp	.L2179
	.p2align 4,,10
	.p2align 3
.L2288:
	cmp	BYTE PTR 187[rsp], 0
	setne	dl
	jmp	.L2226
	.p2align 4,,10
	.p2align 3
.L2219:
	mov	r11d, DWORD PTR 136[r13]
	test	r11d, r11d
	jne	.L2222
	mov	r8, QWORD PTR blend_color@GOTPCREL[rip]
	mov	r8d, DWORD PTR 12[r8]
.L2223:
	cmp	eax, r8d
	jl	.L2218
	jmp	.L2224
	.p2align 4,,10
	.p2align 3
.L2227:
	mov	edi, DWORD PTR 152[r13]
	test	edi, edi
	je	.L2229
	cmp	eax, 254
	jg	.L2230
.L2229:
	test	esi, esi
	jne	.L2231
.L2230:
	mov	rax, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 448[rsp], eax
	mov	rax, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 464[rsp], eax
	mov	rax, QWORD PTR blender1a_b@GOTPCREL[rip]
	jmp	.L2281
	.p2align 4,,10
	.p2align 3
.L2283:
	mov	r8d, DWORD PTR 32[rax]
	mov	ecx, DWORD PTR 36[rax]
	mov	eax, DWORD PTR 40[rax]
	mov	edi, r8d
	mov	esi, ecx
	add	r8d, DWORD PTR 136[rsp]
	add	ecx, DWORD PTR 140[rsp]
	mov	edx, eax
	add	eax, DWORD PTR 144[rsp]
	sar	edi, 16
	sar	esi, 16
	sar	edx, 16
	mov	DWORD PTR 464[rsp], edi
	mov	DWORD PTR 480[rsp], esi
	sar	r8d, 16
	sar	ecx, 16
	mov	DWORD PTR 432[rsp], r8d
	sar	eax, 16
	mov	DWORD PTR 448[rsp], ecx
	jmp	.L2200
	.p2align 4,,10
	.p2align 3
.L2182:
	mov	eax, DWORD PTR 132[rsp]
	mov	edi, DWORD PTR 128[rsp]
	sub	edx, eax
	sub	eax, ebx
	mov	DWORD PTR 108[rsp], edx
	mov	ebx, eax
	call	compute_cvg_flip@PLT
	jmp	.L2183
	.p2align 4,,10
	.p2align 3
.L2180:
	mov	rax, QWORD PTR primitive_z@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 88[rsp], eax
	jmp	.L2181
	.p2align 4,,10
	.p2align 3
.L2222:
	mov	r9, QWORD PTR iseed@GOTPCREL[rip]
	mov	r10d, DWORD PTR [r9]
	imul	r8d, r10d, 214013
	add	r8d, 2531011
	mov	DWORD PTR [r9], r8d
	sar	r8d, 16
	movzx	r8d, r8b
	jmp	.L2223
	.p2align 4,,10
	.p2align 3
.L2231:
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rdx, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	lea	r8, 480[rsp]
	lea	r9, 464[rsp]
	mov	DWORD PTR 92[rsp], ecx
	mov	QWORD PTR 80[rsp], r8
	mov	rax, QWORD PTR [rax]
	mov	rsi, r9
	mov	QWORD PTR 72[rsp], r9
	mov	eax, DWORD PTR [rax]
	not	eax
	and	eax, 255
	mov	DWORD PTR 12[rdx], eax
	lea	rax, 448[rsp]
	mov	rdx, r8
	mov	rdi, rax
	mov	QWORD PTR 64[rsp], rax
	call	blender_equation_cycle0@PLT
	mov	rax, QWORD PTR 64[rsp]
	mov	r9, QWORD PTR 72[rsp]
	mov	r8, QWORD PTR 80[rsp]
	mov	ecx, DWORD PTR 92[rsp]
	jmp	.L2232
.L2175:
	mov	rax, QWORD PTR primitive_delta_z@GOTPCREL[rip]
	mov	DWORD PTR 188[rsp], 0
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 212[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	edi, DWORD PTR 212[rsp]
	mov	DWORD PTR 12[rax], 0
	mov	rax, QWORD PTR spans_cdz@GOTPCREL[rip]
	mov	DWORD PTR [rax], 0
	jmp	.L2176
.L2173:
	mov	esi, DWORD PTR 4[rax]
	neg	DWORD PTR 192[rsp]
	mov	DWORD PTR 248[rsp], -1
	mov	DWORD PTR 196[rsp], esi
	mov	esi, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 196[rsp]
	mov	DWORD PTR 200[rsp], esi
	neg	DWORD PTR 200[rsp]
	mov	DWORD PTR 204[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	neg	DWORD PTR 204[rsp]
	mov	esi, DWORD PTR [rax]
	mov	edi, DWORD PTR 8[rax]
	mov	DWORD PTR 136[rsp], esi
	mov	esi, DWORD PTR 4[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 144[rsp], edi
	neg	DWORD PTR 136[rsp]
	neg	DWORD PTR 144[rsp]
	mov	DWORD PTR 140[rsp], esi
	mov	DWORD PTR 188[rsp], eax
	neg	DWORD PTR 140[rsp]
	neg	DWORD PTR 188[rsp]
	jmp	.L2174
.L2284:
	mov	r10d, r9d
	sal	r11d, 3
	and	r9d, 1
	mov	r8d, 1
	mov	esi, -1
	jmp	.L2206
	.cfi_endproc
.LFE586:
	.size	render_spans_1cycle_notexel1, .-render_spans_1cycle_notexel1
	.p2align 4,,15
	.globl	finalize_spanalpha
	.type	finalize_spanalpha, @function
finalize_spanalpha:
.LFB634:
	.cfi_startproc
	sub	edi, 1
	mov	DWORD PTR -12[rsp], edx
	mov	DWORD PTR -16[rsp], 7
	or	edi, edx
	add	edx, esi
	add	edi, esi
	mov	DWORD PTR -20[rsp], edx
	mov	eax, edi
	sal	eax, 28
	sar	eax, 31
	or	eax, edi
	mov	DWORD PTR -24[rsp], eax
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	movsx	rax, DWORD PTR 108[rax]
	mov	eax, DWORD PTR -24[rsp+rax*4]
	and	eax, 7
	ret
	.cfi_endproc
.LFE634:
	.size	finalize_spanalpha, .-finalize_spanalpha
	.p2align 4,,15
	.globl	CLIP
	.type	CLIP, @function
CLIP:
.LFB635:
	.cfi_startproc
	cmp	edi, esi
	mov	eax, esi
	jl	.L2291
	cmp	edi, edx
	mov	eax, edx
	cmovle	eax, edi
.L2291:
	rep ret
	.cfi_endproc
.LFE635:
	.size	CLIP, .-CLIP
	.p2align 4,,15
	.globl	calculate_clamp_diffs
	.type	calculate_clamp_diffs, @function
calculate_clamp_diffs:
.LFB636:
	.cfi_startproc
	mov	edi, edi
	mov	r11, QWORD PTR tile@GOTPCREL[rip]
	lea	rax, [rdi+rdi*4]
	lea	rdx, [rax+rax*4]
	lea	rdx, [r11+rdx*4]
	mov	eax, DWORD PTR 60[rdx]
	mov	esi, DWORD PTR 52[rdx]
	lea	rdi, 64[rdx]
	sar	eax, 2
	sar	esi, 2
	sub	eax, esi
	and	eax, 1023
	mov	DWORD PTR 68[rdx], eax
	mov	eax, DWORD PTR 64[rdx]
	mov	edx, DWORD PTR 56[rdx]
	sar	eax, 2
	sar	edx, 2
	sub	eax, edx
	and	eax, 1023
	mov	DWORD PTR 8[rdi], eax
	ret
	.cfi_endproc
.LFE636:
	.size	calculate_clamp_diffs, .-calculate_clamp_diffs
	.p2align 4,,15
	.globl	calculate_tile_derivs
	.type	calculate_tile_derivs, @function
calculate_tile_derivs:
.LFB637:
	.cfi_startproc
	mov	edi, edi
	mov	rax, QWORD PTR tile@GOTPCREL[rip]
	mov	ecx, 1
	lea	rdx, [rdi+rdi*4]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [rax+rdx*4]
	mov	r9d, DWORD PTR 28[rdx]
	test	r9d, r9d
	jne	.L2295
	mov	r8d, DWORD PTR 44[rdx]
	xor	ecx, ecx
	test	r8d, r8d
	sete	cl
.L2295:
	lea	rdx, [rdi+rdi*4]
	lea	rdx, [rdx+rdx*4]
	lea	rdx, [rax+rdx*4]
	mov	esi, DWORD PTR 20[rdx]
	mov	DWORD PTR 76[rdx], ecx
	mov	ecx, 1
	test	esi, esi
	jne	.L2296
	mov	edx, DWORD PTR 36[rdx]
	xor	ecx, ecx
	test	edx, edx
	sete	cl
.L2296:
	lea	rdx, [rdi+rdi*4]
	mov	esi, 10
	mov	edi, esi
	lea	rdx, [rdx+rdx*4]
	lea	rax, [rax+rdx*4]
	cmp	DWORD PTR 44[rax], 10
	mov	edx, DWORD PTR [rax]
	cmovle	edi, DWORD PTR 44[rax]
	cmp	DWORD PTR 36[rax], 10
	cmovle	esi, DWORD PTR 36[rax]
	mov	DWORD PTR 80[rax], ecx
	lea	rcx, 80[rax]
	mov	DWORD PTR 84[rax], edi
	mov	DWORD PTR 88[rax], esi
	lea	esi, 0[0+rdx*4]
	or	esi, DWORD PTR 4[rax]
	add	edx, 2
	and	edx, 3
	mov	DWORD PTR 92[rax], esi
	mov	eax, DWORD PTR 4[rax]
	sal	eax, 2
	or	edx, eax
	mov	DWORD PTR 16[rcx], edx
	ret
	.cfi_endproc
.LFE637:
	.size	calculate_tile_derivs, .-calculate_tile_derivs
	.p2align 4,,15
	.globl	rgbaz_correct_clip
	.type	rgbaz_correct_clip, @function
rgbaz_correct_clip:
.LFB643:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	cmp	DWORD PTR 40[rsp], 8
	mov	r11, QWORD PTR 32[rsp]
	mov	ebx, DWORD PTR [r11]
	je	.L2308
	mov	r10, QWORD PTR spans_cd_rgba@GOTPCREL[rip]
	mov	rax, QWORD PTR spans_d_rgba_dy@GOTPCREL[rip]
	mov	r12d, DWORD PTR [r10]
	mov	ebp, DWORD PTR [rax]
	imul	r12d, edi
	imul	ebp, esi
	add	ebp, r12d
	mov	r12d, DWORD PTR 4[r10]
	lea	edx, 0[rbp+rdx*4]
	mov	ebp, DWORD PTR 4[rax]
	imul	r12d, edi
	sar	edx, 4
	imul	ebp, esi
	add	ebp, r12d
	mov	r12d, DWORD PTR 8[r10]
	lea	ecx, 0[rbp+rcx*4]
	mov	ebp, DWORD PTR 8[rax]
	imul	r12d, edi
	sar	ecx, 4
	imul	ebp, esi
	add	ebp, r12d
	lea	r8d, 0[rbp+r8*4]
	mov	ebp, DWORD PTR 12[r10]
	sar	r8d, 4
	imul	ebp, edi
	mov	r10d, ebp
	mov	ebp, DWORD PTR 12[rax]
	imul	ebp, esi
	mov	eax, ebp
	add	eax, r10d
	lea	r9d, [rax+r9*4]
	mov	rax, QWORD PTR spans_cdz@GOTPCREL[rip]
	sar	r9d, 4
	imul	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	imul	esi, DWORD PTR 12[rax]
	add	esi, edi
	lea	edi, [rsi+rbx*4]
	sar	edi, 5
.L2301:
	mov	rsi, QWORD PTR special_9bit_clamptable@GOTPCREL[rip]
	and	edx, 511
	mov	rax, QWORD PTR shade_color@GOTPCREL[rip]
	and	ecx, 511
	and	r8d, 511
	and	r9d, 511
	mov	edx, DWORD PTR [rsi+rdx*4]
	mov	DWORD PTR [rax], edx
	mov	edx, DWORD PTR [rsi+rcx*4]
	mov	DWORD PTR 4[rax], edx
	mov	edx, DWORD PTR [rsi+r8*4]
	mov	DWORD PTR 8[rax], edx
	mov	edx, DWORD PTR [rsi+r9*4]
	mov	DWORD PTR 12[rax], edx
	mov	eax, edi
	and	eax, 393216
	sar	eax, 17
	cmp	eax, 2
	je	.L2303
	cmp	eax, 3
	je	.L2304
	and	edi, 262143
	mov	DWORD PTR [r11], edi
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2308:
	.cfi_restore_state
	sar	ebx, 3
	sar	edx, 2
	sar	ecx, 2
	sar	r8d, 2
	sar	r9d, 2
	mov	edi, ebx
	jmp	.L2301
	.p2align 4,,10
	.p2align 3
.L2304:
	mov	DWORD PTR [r11], 0
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2303:
	.cfi_restore_state
	mov	DWORD PTR [r11], 262143
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE643:
	.size	rgbaz_correct_clip, .-rgbaz_correct_clip
	.p2align 4,,15
	.globl	render_spans_2cycle_complete
	.type	render_spans_2cycle_complete, @function
render_spans_2cycle_complete:
.LFB588:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	eax, edx
	add	eax, 1
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
	sub	rsp, 568
	.cfi_def_cfa_offset 624
	mov	DWORD PTR 112[rsp], eax
	mov	rax, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	and	DWORD PTR 112[rsp], 7
	test	ecx, ecx
	mov	DWORD PTR 84[rsp], edi
	mov	DWORD PTR 280[rsp], esi
	mov	DWORD PTR 284[rsp], edx
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 300[rsp], ecx
	mov	DWORD PTR 400[rsp], 7
	mov	DWORD PTR 416[rsp], 0
	mov	DWORD PTR 448[rsp], 0
	mov	DWORD PTR 464[rsp], 0
	mov	DWORD PTR 180[rsp], ebx
	je	.L2310
	mov	ebx, DWORD PTR 4[rax]
	mov	DWORD PTR 204[rsp], 1
	mov	DWORD PTR 184[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 188[rsp], ebx
	mov	DWORD PTR 192[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 92[rsp], ebx
	mov	ebx, DWORD PTR 4[rax]
	mov	DWORD PTR 96[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 100[rsp], ebx
	mov	DWORD PTR 176[rsp], eax
.L2311:
	mov	r13, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r9d, DWORD PTR 132[r13]
	test	r9d, r9d
	jne	.L2312
	mov	rax, QWORD PTR spans_dzpix@GOTPCREL[rip]
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 200[rsp], eax
	mov	edi, eax
.L2313:
	call	dz_compress@PLT
	mov	ebx, DWORD PTR 280[rsp]
	cmp	DWORD PTR 84[rsp], ebx
	mov	DWORD PTR 196[rsp], eax
	jg	.L2309
	shr	eax, 2
	mov	DWORD PTR 304[rsp], eax
	mov	eax, DWORD PTR 112[rsp]
	mov	DWORD PTR 276[rsp], eax
	mov	eax, DWORD PTR 284[rsp]
	mov	DWORD PTR 272[rsp], eax
	mov	DWORD PTR 116[rsp], eax
	lea	rax, 384[rsp]
	mov	QWORD PTR 208[rsp], rax
	lea	rax, 368[rsp]
	mov	QWORD PTR 216[rsp], rax
	lea	rax, 544[rsp]
	mov	QWORD PTR 224[rsp], rax
	lea	rax, 432[rsp]
	mov	QWORD PTR 232[rsp], rax
	.p2align 4,,10
	.p2align 3
.L2387:
	movsx	rax, DWORD PTR 84[rsp]
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	r8d, DWORD PTR 12[rax]
	test	r8d, r8d
	je	.L2315
	mov	edi, DWORD PTR 4[rax]
	mov	esi, DWORD PTR 20[rax]
	mov	edx, DWORD PTR [rax]
	mov	ebx, DWORD PTR 8[rax]
	mov	r14d, DWORD PTR 32[rax]
	mov	DWORD PTR 88[rsp], edi
	mov	edi, DWORD PTR 16[rax]
	mov	DWORD PTR 56[rsp], esi
	mov	esi, DWORD PTR 28[rax]
	mov	DWORD PTR 60[rsp], edi
	mov	edi, DWORD PTR 24[rax]
	mov	DWORD PTR 48[rsp], esi
	mov	esi, DWORD PTR 40[rax]
	mov	DWORD PTR 52[rsp], edi
	mov	edi, DWORD PTR 36[rax]
	mov	DWORD PTR 36[rsp], esi
	mov	DWORD PTR 32[rsp], edi
	mov	edi, DWORD PTR 132[r13]
	test	edi, edi
	jne	.L2316
	mov	eax, DWORD PTR 44[rax]
	mov	DWORD PTR 44[rsp], eax
.L2317:
	mov	rax, QWORD PTR fb_width@GOTPCREL[rip]
	mov	esi, DWORD PTR 84[rsp]
	imul	esi, DWORD PTR [rax]
	mov	eax, DWORD PTR 88[rsp]
	add	eax, esi
	mov	esi, DWORD PTR 300[rsp]
	mov	edi, eax
	mov	DWORD PTR 168[rsp], eax
	mov	rax, QWORD PTR zb_address@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	lea	ebp, [rax+rdi*2]
	and	ebp, 16777215
	sar	ebp
	test	esi, esi
	jne	.L2318
	mov	edi, DWORD PTR 88[rsp]
	mov	eax, edi
	sub	ebx, edi
	mov	edi, DWORD PTR 84[rsp]
	sub	eax, edx
	mov	DWORD PTR 108[rsp], eax
	call	compute_cvg_noflip@PLT
.L2319:
	test	ebx, ebx
	je	.L2320
	mov	eax, DWORD PTR 180[rsp]
	imul	eax, ebx
	add	DWORD PTR 60[rsp], eax
	mov	eax, DWORD PTR 184[rsp]
	imul	eax, ebx
	add	DWORD PTR 56[rsp], eax
	mov	eax, DWORD PTR 188[rsp]
	imul	eax, ebx
	add	DWORD PTR 52[rsp], eax
	mov	eax, DWORD PTR 192[rsp]
	imul	eax, ebx
	add	DWORD PTR 48[rsp], eax
	mov	eax, DWORD PTR 176[rsp]
	imul	eax, ebx
	add	DWORD PTR 44[rsp], eax
	mov	eax, DWORD PTR 92[rsp]
	imul	eax, ebx
	add	r14d, eax
	mov	eax, DWORD PTR 96[rsp]
	imul	eax, ebx
	add	DWORD PTR 32[rsp], eax
	imul	ebx, DWORD PTR 100[rsp]
	add	DWORD PTR 36[rsp], ebx
.L2320:
	mov	ecx, DWORD PTR 108[rsp]
	test	ecx, ecx
	js	.L2315
	lea	rax, 416[rsp]
	mov	ebx, DWORD PTR 88[rsp]
	mov	DWORD PTR 28[rsp], r14d
	mov	r12d, 1
	mov	r14d, ebp
	mov	DWORD PTR 64[rsp], 0
	mov	QWORD PTR 120[rsp], rax
	lea	rax, 400[rsp]
	mov	r15, QWORD PTR nexttexel_color@GOTPCREL[rip]
	mov	DWORD PTR 24[rsp], ebx
	mov	ebp, DWORD PTR 36[rsp]
	mov	QWORD PTR 160[rsp], rax
	lea	rax, 352[rsp]
	mov	ebx, DWORD PTR 32[rsp]
	mov	QWORD PTR 152[rsp], rax
	lea	rax, 492[rsp]
	mov	QWORD PTR 128[rsp], rax
	lea	rax, 336[rsp]
	mov	QWORD PTR 144[rsp], rax
	lea	rax, 320[rsp]
	mov	QWORD PTR 136[rsp], rax
	lea	rax, 464[rsp]
	mov	QWORD PTR 256[rsp], rax
	lea	rax, 448[rsp]
	mov	QWORD PTR 264[rsp], rax
	lea	rax, 528[rsp]
	mov	QWORD PTR 240[rsp], rax
	lea	rax, 512[rsp]
	mov	QWORD PTR 248[rsp], rax
	jmp	.L2385
	.p2align 4,,10
	.p2align 3
.L2462:
	test	ebp, 131072
	jne	.L2346
	mov	eax, ebp
	and	eax, 98304
	cmp	eax, 32768
	je	.L2345
	cmp	eax, 65536
	je	.L2346
	movzx	eax, bp
	mov	DWORD PTR 368[rsp], eax
.L2347:
	test	ebx, 262144
	jne	.L2348
.L2463:
	test	ebx, 131072
	jne	.L2349
	mov	eax, ebx
	and	eax, 98304
	cmp	eax, 32768
	je	.L2348
	cmp	eax, 65536
	je	.L2349
	movzx	ecx, bx
	mov	DWORD PTR 384[rsp], ecx
.L2350:
	mov	eax, DWORD PTR 148[r13]
	test	eax, eax
	jne	.L2460
.L2366:
	mov	r8d, DWORD PTR 116[rsp]
	mov	edx, DWORD PTR 368[rsp]
	xor	r9d, r9d
	mov	rsi, r15
	mov	rdi, r15
	call	texture_pipeline_cycle@PLT
	mov	r8d, DWORD PTR 112[rsp]
	mov	ecx, DWORD PTR 384[rsp]
	mov	r9d, 1
	mov	edx, DWORD PTR 368[rsp]
	mov	rdi, QWORD PTR 224[rsp]
	mov	rsi, r15
	call	texture_pipeline_cycle@PLT
	mov	eax, DWORD PTR 352[rsp]
	movzx	esi, BYTE PTR 174[rsp]
	movzx	edi, BYTE PTR 173[rsp]
	mov	r9d, DWORD PTR 80[rsp]
	mov	r8d, DWORD PTR 76[rsp]
	mov	ecx, DWORD PTR 72[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	rax, QWORD PTR 232[rsp]
	mov	edx, DWORD PTR 68[rsp]
	mov	QWORD PTR [rsp], rax
	call	rgbaz_correct_clip@PLT
	mov	r12d, DWORD PTR 24[rsp]
	mov	rcx, QWORD PTR 120[rsp]
	mov	rdx, QWORD PTR 160[rsp]
	mov	esi, DWORD PTR 84[rsp]
	mov	edi, r12d
	call	[QWORD PTR get_dither_noise_ptr[rip]]
	mov	rbp, QWORD PTR 152[rsp]
	mov	edi, DWORD PTR 416[rsp]
	mov	rsi, rbp
	call	combiner_2cycle@PLT
	mov	ebx, DWORD PTR 168[rsp]
	sub	ebx, DWORD PTR 88[rsp]
	mov	rax, QWORD PTR fbread2_ptr@GOTPCREL[rip]
	mov	rsi, QWORD PTR 128[rsp]
	add	ebx, r12d
	mov	edi, ebx
	call	[QWORD PTR [rax]]
	mov	eax, DWORD PTR 492[rsp]
	mov	r9, QWORD PTR 144[rsp]
	mov	edi, r14d
	mov	r8, QWORD PTR 136[rsp]
	mov	ecx, DWORD PTR 196[rsp]
	mov	edx, DWORD PTR 200[rsp]
	mov	esi, DWORD PTR 432[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	QWORD PTR [rsp], rbp
	call	z_compare@PLT
	test	eax, eax
	jne	.L2461
.L2368:
	mov	rax, QWORD PTR pre_memory_color@GOTPCREL[rip]
	mov	rbx, QWORD PTR memory_color@GOTPCREL[rip]
	add	DWORD PTR 64[rsp], 1
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rbx], rax
	mov	rax, QWORD PTR blshifta@GOTPCREL[rip]
	mov	QWORD PTR 8[rbx], rdx
	mov	rbx, QWORD PTR pastblshifta@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rbx], eax
	mov	rax, QWORD PTR blshiftb@GOTPCREL[rip]
	mov	rbx, QWORD PTR pastblshiftb@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rbx], eax
	mov	eax, DWORD PTR 180[rsp]
	add	DWORD PTR 60[rsp], eax
	mov	eax, DWORD PTR 184[rsp]
	add	DWORD PTR 56[rsp], eax
	mov	eax, DWORD PTR 188[rsp]
	add	DWORD PTR 52[rsp], eax
	mov	eax, DWORD PTR 192[rsp]
	add	DWORD PTR 48[rsp], eax
	mov	eax, DWORD PTR 176[rsp]
	add	DWORD PTR 44[rsp], eax
	mov	eax, DWORD PTR 204[rsp]
	add	DWORD PTR 24[rsp], eax
	add	r14d, eax
	mov	eax, DWORD PTR 64[rsp]
	and	r14d, 8388607
	cmp	DWORD PTR 108[rsp], eax
	jl	.L2315
	mov	eax, DWORD PTR 40[rsp]
	mov	ebp, DWORD PTR 36[rsp]
	xor	r12d, r12d
	mov	ebx, DWORD PTR 32[rsp]
	mov	DWORD PTR 28[rsp], eax
.L2385:
	mov	eax, DWORD PTR 60[rsp]
	mov	rsi, QWORD PTR cvgbuf@GOTPCREL[rip]
	mov	rdi, QWORD PTR cvarray@GOTPCREL[rip]
	mov	r8, QWORD PTR 208[rsp]
	sar	eax, 14
	mov	DWORD PTR 68[rsp], eax
	mov	eax, DWORD PTR 56[rsp]
	sar	eax, 14
	mov	DWORD PTR 72[rsp], eax
	mov	eax, DWORD PTR 52[rsp]
	sar	eax, 14
	mov	DWORD PTR 76[rsp], eax
	mov	eax, DWORD PTR 48[rsp]
	sar	eax, 14
	mov	DWORD PTR 80[rsp], eax
	mov	eax, DWORD PTR 44[rsp]
	shr	eax, 10
	mov	DWORD PTR 432[rsp], eax
	movsx	rax, DWORD PTR 24[rsp]
	movzx	eax, BYTE PTR [rsi+rax]
	lea	rax, [rdi+rax*4]
	movzx	ecx, BYTE PTR 1[rax]
	movzx	esi, BYTE PTR 2[rax]
	movzx	edi, BYTE PTR 3[rax]
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR 175[rsp], cl
	mov	ecx, DWORD PTR 96[rsp]
	mov	DWORD PTR 352[rsp], eax
	mov	eax, DWORD PTR 100[rsp]
	mov	BYTE PTR 173[rsp], sil
	mov	BYTE PTR 174[rsp], dil
	add	ecx, ebx
	add	eax, ebp
	mov	esi, ecx
	mov	DWORD PTR 32[rsp], ecx
	mov	edx, eax
	mov	DWORD PTR 36[rsp], eax
	mov	eax, DWORD PTR 92[rsp]
	add	eax, DWORD PTR 28[rsp]
	sar	edx, 16
	sar	esi, 16
	mov	rcx, QWORD PTR 216[rsp]
	mov	edi, eax
	mov	DWORD PTR 40[rsp], eax
	sar	edi, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	test	r12d, r12d
	jne	.L2321
	mov	eax, DWORD PTR 104[rsp]
	mov	rbx, QWORD PTR texel0_color@GOTPCREL[rip]
	mov	rdx, QWORD PTR 8[r15]
	mov	DWORD PTR lod_frac[rip], eax
	mov	rax, QWORD PTR [r15]
	mov	QWORD PTR 8[rbx], rdx
	mov	rdx, QWORD PTR 552[rsp]
	mov	QWORD PTR [rbx], rax
	mov	rbx, QWORD PTR texel1_color@GOTPCREL[rip]
	mov	rax, QWORD PTR 544[rsp]
	mov	QWORD PTR 8[rbx], rdx
	mov	QWORD PTR [rbx], rax
.L2322:
	mov	ebp, DWORD PTR 368[rsp]
	mov	ebx, DWORD PTR 384[rsp]
	test	ebp, 262144
	je	.L2462
.L2345:
	test	ebx, 262144
	mov	DWORD PTR 368[rsp], 32767
	je	.L2463
.L2348:
	mov	eax, DWORD PTR 148[r13]
	mov	DWORD PTR 384[rsp], 32767
	mov	ecx, 32767
	test	eax, eax
	je	.L2366
.L2460:
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	edx, DWORD PTR 40[rsp]
	lea	r8, 496[rsp]
	mov	edi, DWORD PTR 92[rsp]
	mov	ecx, DWORD PTR 32[rsp]
	mov	esi, DWORD PTR 96[rsp]
	mov	r12d, DWORD PTR 8[rax]
	add	edi, edx
	add	edx, DWORD PTR [rax]
	add	esi, ecx
	sar	edi, 16
	sar	esi, 16
	mov	DWORD PTR 480[rsp], edi
	mov	DWORD PTR 496[rsp], esi
	sar	edx, 16
	mov	DWORD PTR 512[rsp], edx
	mov	edx, DWORD PTR 4[rax]
	add	edx, ecx
	lea	rcx, 480[rsp]
	sar	edx, 16
	mov	DWORD PTR 528[rsp], edx
	mov	edx, DWORD PTR 36[rsp]
	add	r12d, edx
	add	edx, DWORD PTR 100[rsp]
	sar	r12d, 16
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r8, QWORD PTR 240[rsp]
	mov	edx, r12d
	mov	esi, DWORD PTR 528[rsp]
	mov	edi, DWORD PTR 512[rsp]
	mov	rcx, QWORD PTR 248[rsp]
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r10d, DWORD PTR 496[rsp]
	mov	r9d, DWORD PTR 480[rsp]
	mov	edx, ebp
	mov	esi, ebx
	sal	edx, 15
	mov	r8d, DWORD PTR 512[rsp]
	sal	esi, 15
	sar	edx, 15
	mov	edi, DWORD PTR 528[rsp]
	mov	r11d, r9d
	mov	eax, r10d
	sar	esi, 15
	sal	r11d, 15
	sal	eax, 15
	sar	eax, 15
	sar	r11d, 15
	sub	eax, esi
	sub	r11d, edx
	jns	.L2352
	not	r11d
	and	r11d, 131071
.L2352:
	test	eax, 131072
	je	.L2353
	not	eax
	and	eax, 131071
.L2353:
	xor	ecx, ecx
	test	r11d, r11d
	cmovns	ecx, r11d
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	ecx, eax
	and	ecx, 32767
	mov	r11d, ecx
	or	r11d, 16384
	test	eax, 114688
	mov	eax, edi
	cmovne	ecx, r11d
	mov	r11d, r8d
	sal	eax, 15
	sal	r11d, 15
	sar	eax, 15
	sar	r11d, 15
	sub	eax, esi
	sub	r11d, edx
	jns	.L2355
	not	r11d
	and	r11d, 131071
.L2355:
	test	eax, 131072
	je	.L2356
	not	eax
	and	eax, 131071
.L2356:
	cmp	r11d, ecx
	cmovl	r11d, ecx
	cmp	r11d, eax
	cmovge	eax, r11d
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L2358
	or	ebx, ebp
	or	ebx, r10d
	or	ebx, r9d
	or	ebx, r8d
	or	ebx, edi
	sar	ebx, 17
	mov	eax, ebx
	shr	eax
	or	eax, ebx
	test	al, 1
	jne	.L2358
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	cmovl	edx, eax
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	mov	ecx, edx
	lea	edi, -32[rdx]
	sar	ecx, 5
	movzx	ecx, cl
	sar	edi, 31
	test	dh, 96
	mov	ecx, DWORD PTR [rax+rcx*4]
	mov	r9d, ecx
	jne	.L2464
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	edx, 3
	neg	esi
.L2360:
	mov	r8d, DWORD PTR 8[r13]
	sar	edx, cl
	mov	ecx, DWORD PTR 12[r13]
	mov	eax, r8d
	or	eax, ecx
	jne	.L2361
	mov	eax, edi
	not	eax
	and	edx, eax
	or	edx, esi
.L2361:
	movzx	eax, dl
	mov	r12d, DWORD PTR 16[r13]
	mov	DWORD PTR 104[rsp], eax
	mov	eax, edi
	and	eax, ecx
	sal	eax, 8
	or	DWORD PTR 104[rsp], eax
	test	r12d, r12d
	je	.L2459
	test	esi, esi
	je	.L2363
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	r9d, DWORD PTR [rax]
.L2363:
	test	r8d, r8d
	jne	.L2364
	mov	eax, DWORD PTR 284[rsp]
	not	ecx
	and	ecx, edi
	or	ecx, esi
	add	eax, r9d
	mov	edx, eax
	sub	edx, ecx
	add	edx, 1
.L2365:
	and	eax, 7
	and	edx, 7
	mov	DWORD PTR 116[rsp], eax
	mov	DWORD PTR 112[rsp], edx
.L2459:
	mov	ecx, DWORD PTR 384[rsp]
	jmp	.L2366
	.p2align 4,,10
	.p2align 3
.L2346:
	mov	DWORD PTR 368[rsp], 32768
	jmp	.L2347
	.p2align 4,,10
	.p2align 3
.L2321:
	mov	edi, DWORD PTR 28[rsp]
	mov	edx, ebp
	mov	esi, ebx
	sar	edx, 16
	sar	esi, 16
	mov	r8, QWORD PTR 256[rsp]
	mov	rcx, QWORD PTR 264[rsp]
	sar	edi, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	eax, DWORD PTR 448[rsp]
	mov	r9d, DWORD PTR 384[rsp]
	mov	r10d, DWORD PTR 368[rsp]
	mov	r12d, DWORD PTR 464[rsp]
	test	eax, 262144
	jne	.L2323
	test	eax, 131072
	jne	.L2324
	mov	edx, eax
	and	edx, 98304
	cmp	edx, 32768
	je	.L2323
	cmp	edx, 65536
	je	.L2324
	movzx	edx, ax
	mov	DWORD PTR 448[rsp], edx
.L2325:
	test	r12d, 262144
	jne	.L2326
.L2467:
	test	r12d, 131072
	jne	.L2327
	mov	edx, r12d
	and	edx, 98304
	cmp	edx, 32768
	je	.L2326
	cmp	edx, 65536
	je	.L2327
	movzx	esi, r12w
	mov	DWORD PTR 464[rsp], esi
.L2328:
	mov	edx, DWORD PTR 148[r13]
	test	edx, edx
	jne	.L2465
.L2344:
	mov	edx, DWORD PTR 272[rsp]
	mov	edi, DWORD PTR 448[rsp]
	call	texture_pipeline_cycle.constprop.9
	mov	r8d, DWORD PTR 276[rsp]
	mov	ecx, DWORD PTR 464[rsp]
	mov	r9d, 1
	mov	edx, DWORD PTR 448[rsp]
	mov	rsi, QWORD PTR texel0_color@GOTPCREL[rip]
	mov	rdi, QWORD PTR texel1_color@GOTPCREL[rip]
	call	texture_pipeline_cycle@PLT
	jmp	.L2322
	.p2align 4,,10
	.p2align 3
.L2461:
	mov	ebp, DWORD PTR 140[r13]
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	ecx, DWORD PTR 352[rsp]
	mov	esi, DWORD PTR 336[rsp]
	mov	edx, DWORD PTR 320[rsp]
	mov	r12d, DWORD PTR 400[rsp]
	test	ebp, ebp
	mov	eax, DWORD PTR 12[rax]
	jne	.L2369
.L2374:
	mov	r11d, DWORD PTR 128[r13]
	test	r11d, r11d
	je	.L2466
	test	ecx, ecx
	setne	cl
.L2376:
	test	cl, cl
	je	.L2368
	mov	rdi, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	r10, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	r8d, DWORD PTR 160[r13]
	mov	rdi, QWORD PTR [rdi]
	mov	ecx, DWORD PTR [rdi]
	not	ecx
	and	ecx, 255
	mov	DWORD PTR 12[r10], ecx
	mov	rcx, QWORD PTR blender2b_a@GOTPCREL[rip]
	mov	r10d, DWORD PTR [rdi]
	mov	rcx, QWORD PTR [rcx]
	sar	r10d, 3
	mov	edi, DWORD PTR [rcx]
	sar	edi, 3
	test	r8d, r8d
	je	.L2377
	mov	rcx, QWORD PTR pastblshifta@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	sar	r10d, cl
	mov	rcx, QWORD PTR pastblshiftb@GOTPCREL[rip]
	and	r10d, 60
	mov	ecx, DWORD PTR [rcx]
	sar	edi, cl
	or	edi, 3
.L2377:
	lea	ecx, 1[rdi]
	mov	rdi, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rdi, QWORD PTR [rdi]
	mov	r8d, DWORD PTR [rdi]
	mov	rdi, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rdi, QWORD PTR [rdi]
	imul	r8d, r10d
	mov	r9d, DWORD PTR [rdi]
	mov	rdi, QWORD PTR blender1a_g@GOTPCREL[rip]
	imul	r9d, ecx
	mov	rdi, QWORD PTR [rdi]
	add	r8d, r9d
	sar	r8d, 5
	movzx	r8d, r8b
	mov	DWORD PTR 496[rsp], r8d
	mov	r9d, DWORD PTR [rdi]
	mov	rdi, QWORD PTR blender2a_g@GOTPCREL[rip]
	imul	r9d, r10d
	mov	rdi, QWORD PTR [rdi]
	mov	ebp, DWORD PTR [rdi]
	imul	ebp, ecx
	mov	edi, ebp
	mov	rbp, QWORD PTR blender1a_b@GOTPCREL[rip]
	add	edi, r9d
	sar	edi, 5
	mov	r9, QWORD PTR 0[rbp]
	movzx	edi, dil
	mov	DWORD PTR 512[rsp], edi
	imul	r10d, DWORD PTR [r9]
	mov	r9, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	r11, QWORD PTR [r9]
	imul	ecx, DWORD PTR [r11]
	add	r10d, ecx
	mov	rcx, QWORD PTR pre_memory_color@GOTPCREL[rip]
	sar	r10d, 5
	movzx	r10d, r10b
	movdqa	xmm1, XMMWORD PTR [rcx]
	mov	rcx, QWORD PTR memory_color@GOTPCREL[rip]
	mov	DWORD PTR 528[rsp], r10d
	movdqa	XMMWORD PTR [rcx], xmm1
	mov	rcx, QWORD PTR blended_pixel_color@GOTPCREL[rip]
	mov	DWORD PTR [rcx], r8d
	mov	DWORD PTR 4[rcx], edi
	mov	DWORD PTR 8[rcx], r10d
	mov	DWORD PTR 12[rcx], eax
	mov	ecx, DWORD PTR 112[r13]
	test	ecx, ecx
	je	.L2378
	test	esi, esi
	jne	.L2378
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	lea	rbp, 496[rsp]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 496[rsp], eax
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 512[rsp], eax
	mov	rax, QWORD PTR 8[r9]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 528[rsp], eax
.L2383:
	mov	ecx, r12d
	mov	rdx, QWORD PTR 240[rsp]
	mov	rsi, QWORD PTR 248[rsp]
	mov	rdi, rbp
	call	[QWORD PTR rgb_dither_ptr[rip]]
	mov	eax, DWORD PTR 492[rsp]
	mov	r9d, DWORD PTR 352[rsp]
	mov	edi, ebx
	mov	r8d, DWORD PTR 320[rsp]
	mov	ecx, DWORD PTR 528[rsp]
	mov	edx, DWORD PTR 512[rsp]
	mov	esi, DWORD PTR 496[rsp]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR fbwrite_ptr@GOTPCREL[rip]
	call	[QWORD PTR [rax]]
	mov	r10d, DWORD PTR 120[r13]
	test	r10d, r10d
	je	.L2368
	mov	edx, DWORD PTR 432[rsp]
	mov	rax, QWORD PTR z_com_table@GOTPCREL[rip]
	and	edx, 262143
	movzx	edx, WORD PTR [rax+rdx*2]
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	cmp	r14d, DWORD PTR [rax]
	ja	.L2368
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	or	dx, WORD PTR 304[rsp]
	mov	ecx, r14d
	xor	ecx, 1
	mov	rax, QWORD PTR [rax]
	mov	WORD PTR [rax+rcx*2], dx
	movzx	ecx, BYTE PTR 196[rsp]
	mov	eax, r14d
	mov	rdx, QWORD PTR hidden_bits@GOTPCREL[rip]
	and	ecx, 3
	mov	BYTE PTR [rdx+rax], cl
	jmp	.L2368
	.p2align 4,,10
	.p2align 3
.L2349:
	mov	DWORD PTR 384[rsp], 32768
	mov	ecx, 32768
	jmp	.L2350
	.p2align 4,,10
	.p2align 3
.L2358:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	mov	edx, 262136
	xor	edi, edi
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	r9d, ecx
	jmp	.L2360
	.p2align 4,,10
	.p2align 3
.L2315:
	add	DWORD PTR 84[rsp], 1
	mov	eax, DWORD PTR 84[rsp]
	cmp	DWORD PTR 280[rsp], eax
	jge	.L2387
.L2309:
	add	rsp, 568
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
.L2323:
	.cfi_restore_state
	test	r12d, 262144
	mov	DWORD PTR 448[rsp], 32767
	je	.L2467
.L2326:
	mov	edx, DWORD PTR 148[r13]
	mov	DWORD PTR 464[rsp], 32767
	mov	esi, 32767
	test	edx, edx
	je	.L2344
.L2465:
	mov	rdx, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	edi, DWORD PTR 28[rsp]
	mov	DWORD PTR 296[rsp], eax
	mov	DWORD PTR 292[rsp], r10d
	mov	DWORD PTR 288[rsp], r9d
	mov	r8, QWORD PTR 240[rsp]
	add	ebx, DWORD PTR 4[rdx]
	add	edi, DWORD PTR [rdx]
	add	ebp, DWORD PTR 8[rdx]
	mov	rcx, QWORD PTR 248[rsp]
	mov	esi, ebx
	sar	edi, 16
	sar	esi, 16
	mov	edx, ebp
	mov	DWORD PTR 512[rsp], edi
	sar	edx, 16
	mov	DWORD PTR 528[rsp], esi
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	eax, DWORD PTR 296[rsp]
	mov	r10d, DWORD PTR 292[rsp]
	mov	edi, r12d
	mov	r9d, DWORD PTR 288[rsp]
	sal	edi, 15
	mov	r11d, DWORD PTR 512[rsp]
	sar	edi, 15
	mov	ebx, DWORD PTR 528[rsp]
	mov	ecx, eax
	mov	r8d, r10d
	mov	edx, r9d
	sal	ecx, 15
	sal	r8d, 15
	sal	edx, 15
	sar	ecx, 15
	sar	r8d, 15
	sar	edx, 15
	sub	edx, edi
	sub	r8d, ecx
	jns	.L2330
	not	r8d
	and	r8d, 131071
.L2330:
	test	edx, 131072
	je	.L2331
	not	edx
	and	edx, 131071
.L2331:
	xor	esi, esi
	test	r8d, r8d
	cmovns	esi, r8d
	cmp	esi, edx
	cmovge	edx, esi
	mov	esi, edx
	and	esi, 32767
	mov	r8d, esi
	or	r8d, 16384
	and	edx, 114688
	mov	edx, ebx
	cmovne	esi, r8d
	mov	r8d, r11d
	sal	edx, 15
	sal	r8d, 15
	sar	edx, 15
	sar	r8d, 15
	sub	edx, edi
	sub	r8d, ecx
	jns	.L2333
	not	r8d
	and	r8d, 131071
.L2333:
	test	edx, 131072
	je	.L2334
	not	edx
	and	edx, 131071
.L2334:
	cmp	r8d, esi
	cmovl	r8d, esi
	cmp	r8d, edx
	cmovge	edx, r8d
	mov	ecx, edx
	and	ecx, 32767
	mov	esi, ecx
	or	esi, 16384
	and	edx, 114688
	cmovne	ecx, esi
	test	ch, 64
	jne	.L2336
	or	r9d, r10d
	or	r9d, eax
	or	r9d, r12d
	or	r9d, r11d
	or	r9d, ebx
	sar	r9d, 17
	mov	eax, r9d
	shr	eax
	or	eax, r9d
	test	al, 1
	jne	.L2336
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	ecx, edi
	cmovge	edi, ecx
	mov	edx, edi
	lea	r8d, -32[rdi]
	sar	edx, 5
	movzx	edx, dl
	sar	r8d, 31
	test	edi, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	ebx, ecx
	jne	.L2468
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	edx, edx
	mov	r10d, r8d
	mov	esi, r8d
	cmp	ecx, DWORD PTR [rax]
	setae	dl
	sal	edi, 3
	and	r10d, 1
	neg	edx
	mov	r9d, edx
	and	r9d, 1
.L2338:
	mov	r11d, DWORD PTR 8[r13]
	sar	edi, cl
	mov	ecx, DWORD PTR 12[r13]
	mov	eax, edi
	mov	ebp, r11d
	or	ebp, ecx
	jne	.L2339
	mov	eax, esi
	not	eax
	and	eax, edi
	or	eax, edx
.L2339:
	and	esi, ecx
	movzx	eax, al
	sal	esi, 8
	or	eax, esi
	movzx	eax, ax
	mov	DWORD PTR lod_frac[rip], eax
	mov	eax, DWORD PTR 16[r13]
	test	eax, eax
	je	.L2458
	test	r9d, r9d
	je	.L2341
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	ebx, DWORD PTR [rax]
.L2341:
	test	r11d, r11d
	jne	.L2342
	mov	eax, DWORD PTR 284[rsp]
	not	ecx
	and	ecx, r10d
	or	ecx, r9d
	add	eax, ebx
	mov	edx, eax
	sub	edx, ecx
	add	edx, 1
.L2343:
	and	eax, 7
	and	edx, 7
	mov	DWORD PTR 272[rsp], eax
	mov	DWORD PTR 276[rsp], edx
.L2458:
	mov	esi, DWORD PTR 464[rsp]
	jmp	.L2344
	.p2align 4,,10
	.p2align 3
.L2466:
	cmp	BYTE PTR 175[rsp], 0
	setne	cl
	jmp	.L2376
	.p2align 4,,10
	.p2align 3
.L2324:
	mov	DWORD PTR 448[rsp], 32768
	jmp	.L2325
	.p2align 4,,10
	.p2align 3
.L2369:
	mov	r10d, DWORD PTR 136[r13]
	test	r10d, r10d
	jne	.L2372
	mov	rdi, QWORD PTR blend_color@GOTPCREL[rip]
	mov	edi, DWORD PTR 12[rdi]
.L2373:
	cmp	eax, edi
	jl	.L2368
	jmp	.L2374
	.p2align 4,,10
	.p2align 3
.L2327:
	mov	DWORD PTR 464[rsp], 32768
	mov	esi, 32768
	jmp	.L2328
	.p2align 4,,10
	.p2align 3
.L2364:
	add	r9d, DWORD PTR 284[rsp]
	or	esi, edi
	mov	eax, r9d
	sub	r9d, esi
	sub	eax, edi
	lea	edx, 2[r9]
	add	eax, 1
	jmp	.L2365
	.p2align 4,,10
	.p2align 3
.L2336:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r10d, r10d
	mov	r9d, 1
	xor	esi, esi
	mov	edi, 262136
	xor	r8d, r8d
	mov	edx, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	ebx, ecx
	jmp	.L2338
	.p2align 4,,10
	.p2align 3
.L2378:
	mov	r11d, DWORD PTR 156[r13]
	test	r11d, r11d
	je	.L2380
	cmp	eax, 254
	jg	.L2381
.L2380:
	test	edx, edx
	jne	.L2382
.L2381:
	mov	rax, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 496[rsp], eax
	mov	rax, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 512[rsp], eax
	mov	rax, QWORD PTR 8[rbp]
	lea	rbp, 496[rsp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 528[rsp], eax
	jmp	.L2383
	.p2align 4,,10
	.p2align 3
.L2318:
	mov	eax, DWORD PTR 88[rsp]
	mov	edi, DWORD PTR 84[rsp]
	sub	edx, eax
	sub	eax, ebx
	mov	DWORD PTR 108[rsp], edx
	mov	ebx, eax
	call	compute_cvg_flip@PLT
	jmp	.L2319
	.p2align 4,,10
	.p2align 3
.L2316:
	mov	rax, QWORD PTR primitive_z@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 44[rsp], eax
	jmp	.L2317
	.p2align 4,,10
	.p2align 3
.L2372:
	mov	r8, QWORD PTR iseed@GOTPCREL[rip]
	mov	r9d, DWORD PTR [r8]
	imul	edi, r9d, 214013
	add	edi, 2531011
	mov	DWORD PTR [r8], edi
	sar	edi, 16
	movzx	edi, dil
	jmp	.L2373
	.p2align 4,,10
	.p2align 3
.L2342:
	add	ebx, DWORD PTR 284[rsp]
	or	edx, r8d
	and	edx, 1
	mov	eax, ebx
	sub	ebx, edx
	sub	eax, r10d
	lea	edx, 2[rbx]
	add	eax, 1
	jmp	.L2343
	.p2align 4,,10
	.p2align 3
.L2382:
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rsi, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	lea	rbp, 496[rsp]
	mov	rdx, QWORD PTR 240[rsp]
	mov	rdi, rbp
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	not	eax
	and	eax, 255
	mov	DWORD PTR 12[rsi], eax
	mov	rsi, QWORD PTR 248[rsp]
	call	blender_equation_cycle1@PLT
	jmp	.L2383
.L2312:
	mov	rax, QWORD PTR primitive_delta_z@GOTPCREL[rip]
	mov	DWORD PTR 176[rsp], 0
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 200[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	edi, DWORD PTR 200[rsp]
	mov	DWORD PTR 12[rax], 0
	mov	rax, QWORD PTR spans_cdz@GOTPCREL[rip]
	mov	DWORD PTR [rax], 0
	jmp	.L2313
.L2310:
	mov	ebx, DWORD PTR 4[rax]
	neg	DWORD PTR 180[rsp]
	mov	DWORD PTR 204[rsp], -1
	mov	DWORD PTR 184[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 184[rsp]
	mov	DWORD PTR 188[rsp], ebx
	neg	DWORD PTR 188[rsp]
	mov	DWORD PTR 192[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	neg	DWORD PTR 192[rsp]
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 92[rsp], ebx
	mov	ebx, DWORD PTR 4[rax]
	neg	DWORD PTR 92[rsp]
	mov	DWORD PTR 96[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 96[rsp]
	mov	DWORD PTR 100[rsp], ebx
	neg	DWORD PTR 100[rsp]
	mov	DWORD PTR 176[rsp], eax
	neg	DWORD PTR 176[rsp]
	jmp	.L2311
.L2464:
	sal	edx, 3
	mov	esi, -1
	jmp	.L2360
.L2468:
	mov	r10d, r8d
	sal	edi, 3
	mov	esi, r8d
	and	r10d, 1
	mov	r9d, 1
	mov	edx, -1
	jmp	.L2338
	.cfi_endproc
.LFE588:
	.size	render_spans_2cycle_complete, .-render_spans_2cycle_complete
	.p2align 4,,15
	.globl	render_spans_2cycle_notexelnext
	.type	render_spans_2cycle_notexelnext, @function
render_spans_2cycle_notexelnext:
.LFB589:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	eax, edx
	add	eax, 1
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
	sub	rsp, 504
	.cfi_def_cfa_offset 560
	mov	DWORD PTR 92[rsp], eax
	mov	rax, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	and	DWORD PTR 92[rsp], 7
	test	ecx, ecx
	mov	DWORD PTR 68[rsp], edi
	mov	DWORD PTR 272[rsp], esi
	mov	DWORD PTR 276[rsp], edx
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 280[rsp], ecx
	mov	DWORD PTR 352[rsp], 7
	mov	DWORD PTR 368[rsp], 0
	mov	DWORD PTR 400[rsp], 0
	mov	DWORD PTR 416[rsp], 0
	mov	DWORD PTR 160[rsp], ebx
	je	.L2470
	mov	ebx, DWORD PTR 4[rax]
	mov	DWORD PTR 216[rsp], 1
	mov	DWORD PTR 164[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 168[rsp], ebx
	mov	DWORD PTR 172[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 100[rsp], ebx
	mov	ebx, DWORD PTR 4[rax]
	mov	DWORD PTR 104[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 108[rsp], ebx
	mov	DWORD PTR 156[rsp], eax
.L2471:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edi, DWORD PTR 132[rax]
	test	edi, edi
	jne	.L2472
	mov	rax, QWORD PTR spans_dzpix@GOTPCREL[rip]
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 176[rsp], eax
	mov	ebx, eax
.L2473:
	mov	eax, ebx
	and	eax, 65280
	cmp	eax, 1
	sbb	r10d, r10d
	and	r10d, -8
	add	r10d, 9
	cmp	eax, 1
	sbb	r9d, r9d
	not	r9d
	and	r9d, 2
	cmp	eax, 1
	sbb	r8d, r8d
	and	r8d, -8
	add	r8d, 11
	cmp	eax, 1
	sbb	edi, edi
	and	edi, -8
	add	edi, 10
	cmp	eax, 1
	sbb	esi, esi
	and	esi, -8
	add	esi, 13
	cmp	eax, 1
	sbb	ecx, ecx
	mov	r11d, ecx
	mov	edx, ecx
	mov	DWORD PTR 256[rsp], ecx
	and	r11d, -8
	and	WORD PTR 256[rsp], -2
	and	edx, -8
	mov	ecx, r11d
	add	WORD PTR 256[rsp], 3
	add	edx, 15
	add	ecx, 12
	cmp	eax, 1
	sbb	eax, eax
	add	r11d, 14
	not	eax
	and	eax, 8
	and	ebx, 61680
	jne	.L2475
	mov	esi, r10d
	mov	WORD PTR 256[rsp], r9w
	mov	edx, r8d
	mov	r11d, edi
	mov	ecx, eax
.L2475:
	test	DWORD PTR 176[rsp], 52428
	jne	.L2530
	mov	DWORD PTR 180[rsp], esi
	mov	r11d, ecx
	xor	eax, eax
	mov	BYTE PTR 287[rsp], 1
.L2476:
	movzx	ebx, BYTE PTR 287[rsp]
	mov	edx, DWORD PTR 176[rsp]
	and	edx, 43690
	cmovne	r11d, DWORD PTR 180[rsp]
	cmove	ebx, eax
	mov	eax, DWORD PTR 272[rsp]
	cmp	DWORD PTR 68[rsp], eax
	mov	BYTE PTR 287[rsp], bl
	mov	DWORD PTR 180[rsp], r11d
	jg	.L2469
	mov	eax, DWORD PTR 276[rsp]
	mov	DWORD PTR 96[rsp], eax
	lea	rax, 416[rsp]
	mov	QWORD PTR 184[rsp], rax
	lea	rax, 400[rsp]
	mov	QWORD PTR 192[rsp], rax
	lea	rax, 384[rsp]
	mov	QWORD PTR 200[rsp], rax
	lea	rax, 368[rsp]
	mov	QWORD PTR 208[rsp], rax
	.p2align 4,,10
	.p2align 3
.L2527:
	movsx	rax, DWORD PTR 68[rsp]
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	esi, DWORD PTR 12[rax]
	test	esi, esi
	je	.L2479
	mov	esi, DWORD PTR 4[rax]
	mov	ecx, DWORD PTR 20[rax]
	mov	edx, DWORD PTR [rax]
	mov	ebx, DWORD PTR 8[rax]
	mov	r13d, DWORD PTR 32[rax]
	mov	r12d, DWORD PTR 36[rax]
	mov	DWORD PTR 72[rsp], esi
	mov	esi, DWORD PTR 16[rax]
	mov	DWORD PTR 32[rsp], ecx
	mov	ecx, DWORD PTR 28[rax]
	mov	ebp, DWORD PTR 40[rax]
	mov	DWORD PTR 28[rsp], esi
	mov	esi, DWORD PTR 24[rax]
	mov	DWORD PTR 40[rsp], ecx
	mov	DWORD PTR 36[rsp], esi
	mov	rsi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	ecx, DWORD PTR 132[rsi]
	test	ecx, ecx
	jne	.L2480
	mov	eax, DWORD PTR 44[rax]
	mov	DWORD PTR 44[rsp], eax
.L2481:
	mov	rax, QWORD PTR fb_width@GOTPCREL[rip]
	mov	esi, DWORD PTR 68[rsp]
	imul	esi, DWORD PTR [rax]
	mov	eax, DWORD PTR 72[rsp]
	add	eax, esi
	mov	esi, eax
	mov	DWORD PTR 152[rsp], eax
	mov	rax, QWORD PTR zb_address@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	lea	r15d, [rax+rsi*2]
	mov	eax, DWORD PTR 280[rsp]
	and	r15d, 16777215
	sar	r15d
	test	eax, eax
	jne	.L2482
	mov	ecx, DWORD PTR 72[rsp]
	mov	edi, DWORD PTR 68[rsp]
	mov	eax, ecx
	sub	ebx, ecx
	sub	eax, edx
	mov	DWORD PTR 88[rsp], eax
	call	compute_cvg_noflip@PLT
.L2483:
	test	ebx, ebx
	je	.L2484
	mov	eax, DWORD PTR 160[rsp]
	imul	eax, ebx
	add	DWORD PTR 28[rsp], eax
	mov	eax, DWORD PTR 164[rsp]
	imul	eax, ebx
	add	DWORD PTR 32[rsp], eax
	mov	eax, DWORD PTR 168[rsp]
	imul	eax, ebx
	add	DWORD PTR 36[rsp], eax
	mov	eax, DWORD PTR 172[rsp]
	imul	eax, ebx
	add	DWORD PTR 40[rsp], eax
	mov	eax, DWORD PTR 156[rsp]
	imul	eax, ebx
	add	DWORD PTR 44[rsp], eax
	mov	eax, DWORD PTR 100[rsp]
	imul	eax, ebx
	add	r13d, eax
	mov	eax, DWORD PTR 104[rsp]
	imul	eax, ebx
	imul	ebx, DWORD PTR 108[rsp]
	add	r12d, eax
	add	ebp, ebx
.L2484:
	mov	eax, DWORD PTR 88[rsp]
	test	eax, eax
	js	.L2479
	mov	eax, DWORD PTR 108[rsp]
	mov	ebx, r13d
	mov	DWORD PTR 24[rsp], r13d
	mov	r13d, r12d
	mov	DWORD PTR 48[rsp], 0
	mov	r14d, r13d
	mov	r13d, ebp
	add	eax, ebp
	mov	DWORD PTR 84[rsp], eax
	mov	eax, DWORD PTR 100[rsp]
	add	eax, ebx
	mov	DWORD PTR 80[rsp], eax
	mov	eax, DWORD PTR 104[rsp]
	add	eax, r12d
	mov	r12d, DWORD PTR 72[rsp]
	mov	DWORD PTR 76[rsp], eax
	lea	rax, 352[rsp]
	mov	QWORD PTR 144[rsp], rax
	lea	rax, 320[rsp]
	mov	QWORD PTR 128[rsp], rax
	lea	rax, 336[rsp]
	mov	QWORD PTR 136[rsp], rax
	lea	rax, 304[rsp]
	mov	QWORD PTR 120[rsp], rax
	lea	rax, 288[rsp]
	mov	QWORD PTR 112[rsp], rax
	lea	rax, 480[rsp]
	mov	QWORD PTR 224[rsp], rax
	lea	rax, 464[rsp]
	mov	QWORD PTR 232[rsp], rax
	lea	rax, 448[rsp]
	mov	QWORD PTR 240[rsp], rax
	lea	rax, 432[rsp]
	mov	QWORD PTR 248[rsp], rax
	jmp	.L2525
	.p2align 4,,10
	.p2align 3
.L2573:
	test	ebp, 131072
	jne	.L2486
	mov	eax, ebp
	and	eax, 98304
	cmp	eax, 32768
	je	.L2485
	cmp	eax, 65536
	je	.L2486
	movzx	eax, bp
	mov	DWORD PTR 400[rsp], eax
.L2487:
	test	ebx, 262144
	jne	.L2488
.L2574:
	test	ebx, 131072
	jne	.L2489
	mov	eax, ebx
	and	eax, 98304
	cmp	eax, 32768
	je	.L2488
	cmp	eax, 65536
	je	.L2489
	movzx	esi, bx
	mov	DWORD PTR 416[rsp], esi
	.p2align 4,,10
	.p2align 3
.L2490:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 148[rax]
	test	eax, eax
	jne	.L2571
.L2506:
	mov	edx, DWORD PTR 96[rsp]
	mov	edi, DWORD PTR 400[rsp]
	call	texture_pipeline_cycle.constprop.9
	mov	r8d, DWORD PTR 92[rsp]
	mov	ecx, DWORD PTR 416[rsp]
	mov	r9d, 1
	mov	edx, DWORD PTR 400[rsp]
	mov	rsi, QWORD PTR texel0_color@GOTPCREL[rip]
	mov	rdi, QWORD PTR texel1_color@GOTPCREL[rip]
	call	texture_pipeline_cycle@PLT
	mov	eax, DWORD PTR 320[rsp]
	movzx	esi, BYTE PTR 285[rsp]
	movzx	edi, BYTE PTR 284[rsp]
	mov	r9d, DWORD PTR 64[rsp]
	mov	r8d, DWORD PTR 60[rsp]
	mov	ecx, DWORD PTR 56[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	rax, QWORD PTR 200[rsp]
	mov	edx, DWORD PTR 52[rsp]
	mov	QWORD PTR [rsp], rax
	call	rgbaz_correct_clip@PLT
	mov	rcx, QWORD PTR 208[rsp]
	mov	rdx, QWORD PTR 144[rsp]
	mov	edi, r12d
	mov	esi, DWORD PTR 68[rsp]
	call	[QWORD PTR get_dither_noise_ptr[rip]]
	mov	rbp, QWORD PTR 128[rsp]
	mov	edi, DWORD PTR 368[rsp]
	mov	rsi, rbp
	call	combiner_2cycle@PLT
	mov	ebx, DWORD PTR 152[rsp]
	sub	ebx, DWORD PTR 72[rsp]
	mov	rax, QWORD PTR fbread2_ptr@GOTPCREL[rip]
	mov	rsi, QWORD PTR 136[rsp]
	add	ebx, r12d
	mov	edi, ebx
	call	[QWORD PTR [rax]]
	mov	eax, DWORD PTR 336[rsp]
	mov	r9, QWORD PTR 120[rsp]
	mov	edi, r15d
	mov	r8, QWORD PTR 112[rsp]
	mov	ecx, DWORD PTR 180[rsp]
	mov	edx, DWORD PTR 176[rsp]
	mov	esi, DWORD PTR 384[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	QWORD PTR [rsp], rbp
	call	z_compare@PLT
	test	eax, eax
	jne	.L2572
.L2508:
	mov	rax, QWORD PTR pre_memory_color@GOTPCREL[rip]
	mov	rcx, QWORD PTR memory_color@GOTPCREL[rip]
	mov	rdi, QWORD PTR pastblshiftb@GOTPCREL[rip]
	add	DWORD PTR 48[rsp], 1
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rcx], rax
	mov	rax, QWORD PTR blshifta@GOTPCREL[rip]
	mov	QWORD PTR 8[rcx], rdx
	mov	rdx, QWORD PTR pastblshifta@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR blshiftb@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdi], eax
	mov	eax, DWORD PTR 160[rsp]
	add	DWORD PTR 28[rsp], eax
	mov	eax, DWORD PTR 164[rsp]
	add	DWORD PTR 32[rsp], eax
	mov	eax, DWORD PTR 168[rsp]
	add	DWORD PTR 36[rsp], eax
	mov	eax, DWORD PTR 172[rsp]
	add	DWORD PTR 40[rsp], eax
	mov	eax, DWORD PTR 156[rsp]
	add	DWORD PTR 44[rsp], eax
	mov	eax, DWORD PTR 216[rsp]
	add	r15d, eax
	add	r12d, eax
	mov	eax, DWORD PTR 100[rsp]
	add	DWORD PTR 24[rsp], eax
	and	r15d, 8388607
	mov	ecx, DWORD PTR 104[rsp]
	mov	ebx, DWORD PTR 108[rsp]
	add	DWORD PTR 80[rsp], eax
	add	DWORD PTR 84[rsp], ebx
	mov	eax, DWORD PTR 48[rsp]
	add	r14d, ecx
	add	r13d, ebx
	add	DWORD PTR 76[rsp], ecx
	cmp	DWORD PTR 88[rsp], eax
	jl	.L2479
.L2525:
	mov	eax, DWORD PTR 28[rsp]
	mov	rcx, QWORD PTR cvgbuf@GOTPCREL[rip]
	mov	esi, r14d
	mov	rbx, QWORD PTR cvarray@GOTPCREL[rip]
	mov	edi, DWORD PTR 24[rsp]
	sar	esi, 16
	mov	r8, QWORD PTR 184[rsp]
	sar	eax, 14
	mov	DWORD PTR 52[rsp], eax
	mov	eax, DWORD PTR 32[rsp]
	sar	edi, 16
	sar	eax, 14
	mov	DWORD PTR 56[rsp], eax
	mov	eax, DWORD PTR 36[rsp]
	sar	eax, 14
	mov	DWORD PTR 60[rsp], eax
	mov	eax, DWORD PTR 40[rsp]
	sar	eax, 14
	mov	DWORD PTR 64[rsp], eax
	mov	eax, DWORD PTR 44[rsp]
	shr	eax, 10
	mov	DWORD PTR 384[rsp], eax
	movsx	rax, r12d
	movzx	eax, BYTE PTR [rcx+rax]
	lea	rax, [rbx+rax*4]
	movzx	edx, BYTE PTR 2[rax]
	movzx	ecx, BYTE PTR 1[rax]
	movzx	ebx, BYTE PTR 3[rax]
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR 284[rsp], dl
	mov	edx, r13d
	mov	BYTE PTR 286[rsp], cl
	mov	BYTE PTR 285[rsp], bl
	sar	edx, 16
	mov	DWORD PTR 320[rsp], eax
	mov	rcx, QWORD PTR 192[rsp]
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	ebp, DWORD PTR 400[rsp]
	mov	ebx, DWORD PTR 416[rsp]
	test	ebp, 262144
	je	.L2573
.L2485:
	test	ebx, 262144
	mov	DWORD PTR 400[rsp], 32767
	je	.L2574
.L2488:
	mov	DWORD PTR 416[rsp], 32767
	mov	esi, 32767
	jmp	.L2490
	.p2align 4,,10
	.p2align 3
.L2486:
	mov	DWORD PTR 400[rsp], 32768
	jmp	.L2487
	.p2align 4,,10
	.p2align 3
.L2571:
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	edx, DWORD PTR 24[rsp]
	mov	edi, DWORD PTR 80[rsp]
	mov	esi, DWORD PTR 76[rsp]
	mov	r8, QWORD PTR 224[rsp]
	add	edx, DWORD PTR [rax]
	mov	ecx, DWORD PTR 8[rax]
	sar	edi, 16
	sar	esi, 16
	mov	DWORD PTR 464[rsp], edi
	mov	DWORD PTR 480[rsp], esi
	add	ecx, r13d
	sar	edx, 16
	mov	DWORD PTR 432[rsp], edx
	mov	edx, DWORD PTR 4[rax]
	mov	eax, ecx
	sar	eax, 16
	mov	rcx, QWORD PTR 232[rsp]
	mov	DWORD PTR 220[rsp], eax
	add	edx, r14d
	sar	edx, 16
	mov	DWORD PTR 448[rsp], edx
	mov	edx, DWORD PTR 84[rsp]
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	eax, DWORD PTR 220[rsp]
	mov	r8, QWORD PTR 240[rsp]
	mov	esi, DWORD PTR 448[rsp]
	mov	edi, DWORD PTR 432[rsp]
	mov	rcx, QWORD PTR 248[rsp]
	mov	edx, eax
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r10d, DWORD PTR 480[rsp]
	mov	r9d, DWORD PTR 464[rsp]
	mov	edx, ebp
	mov	esi, ebx
	sal	edx, 15
	mov	r8d, DWORD PTR 432[rsp]
	sal	esi, 15
	sar	edx, 15
	mov	edi, DWORD PTR 448[rsp]
	mov	r11d, r9d
	mov	eax, r10d
	sar	esi, 15
	sal	r11d, 15
	sal	eax, 15
	sar	eax, 15
	sar	r11d, 15
	sub	eax, esi
	sub	r11d, edx
	jns	.L2492
	not	r11d
	and	r11d, 131071
.L2492:
	test	eax, 131072
	je	.L2493
	not	eax
	and	eax, 131071
.L2493:
	xor	ecx, ecx
	test	r11d, r11d
	cmovns	ecx, r11d
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	ecx, eax
	and	ecx, 32767
	mov	r11d, ecx
	or	r11d, 16384
	test	eax, 114688
	mov	eax, edi
	cmovne	ecx, r11d
	mov	r11d, r8d
	sal	eax, 15
	sal	r11d, 15
	sar	eax, 15
	sar	r11d, 15
	sub	eax, esi
	sub	r11d, edx
	jns	.L2495
	not	r11d
	and	r11d, 131071
.L2495:
	test	eax, 131072
	je	.L2496
	not	eax
	and	eax, 131071
.L2496:
	cmp	r11d, ecx
	cmovl	r11d, ecx
	cmp	r11d, eax
	cmovge	eax, r11d
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L2498
	or	ebx, ebp
	or	ebx, r10d
	or	ebx, r9d
	or	ebx, r8d
	or	ebx, edi
	sar	ebx, 17
	mov	eax, ebx
	shr	eax
	or	eax, ebx
	test	al, 1
	jne	.L2498
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, edi
	cmovge	edi, edx
	mov	edx, edi
	lea	r8d, -32[rdi]
	sar	edx, 5
	movzx	edx, dl
	sar	r8d, 31
	test	edi, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	r11d, ecx
	jne	.L2575
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	edx, edx
	mov	r10d, r8d
	mov	esi, r8d
	cmp	ecx, DWORD PTR [rax]
	setae	dl
	sal	edi, 3
	and	r10d, 1
	neg	edx
	mov	r9d, edx
	and	r9d, 1
.L2500:
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	sar	edi, cl
	mov	eax, edi
	mov	ecx, DWORD PTR 12[rbx]
	mov	ebx, DWORD PTR 8[rbx]
	mov	ebp, ebx
	or	ebp, ecx
	jne	.L2501
	mov	eax, esi
	not	eax
	and	eax, edi
	or	eax, edx
.L2501:
	and	esi, ecx
	movzx	eax, al
	sal	esi, 8
	or	eax, esi
	movzx	eax, ax
	mov	DWORD PTR lod_frac[rip], eax
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	ebp, DWORD PTR 16[rax]
	test	ebp, ebp
	je	.L2570
	test	r9d, r9d
	je	.L2503
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	r11d, DWORD PTR [rax]
.L2503:
	test	ebx, ebx
	jne	.L2504
	mov	eax, DWORD PTR 276[rsp]
	not	ecx
	and	ecx, r10d
	or	ecx, r9d
	add	eax, r11d
	mov	edx, eax
	sub	edx, ecx
	add	edx, 1
.L2505:
	and	eax, 7
	and	edx, 7
	mov	DWORD PTR 96[rsp], eax
	mov	DWORD PTR 92[rsp], edx
.L2570:
	mov	esi, DWORD PTR 416[rsp]
	jmp	.L2506
	.p2align 4,,10
	.p2align 3
.L2572:
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	ecx, DWORD PTR 320[rsp]
	mov	esi, DWORD PTR 304[rsp]
	mov	edx, DWORD PTR 288[rsp]
	mov	r11d, DWORD PTR 352[rsp]
	mov	r8d, DWORD PTR 140[rdi]
	mov	eax, DWORD PTR 12[rax]
	test	r8d, r8d
	jne	.L2509
.L2514:
	mov	ebp, DWORD PTR 128[rdi]
	test	ebp, ebp
	je	.L2576
	test	ecx, ecx
	setne	cl
.L2516:
	test	cl, cl
	je	.L2508
	mov	rcx, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	r10, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	rdi, QWORD PTR [rcx]
	mov	ecx, DWORD PTR [rdi]
	not	ecx
	and	ecx, 255
	mov	DWORD PTR 12[r10], ecx
	mov	rcx, QWORD PTR blender2b_a@GOTPCREL[rip]
	mov	r10d, DWORD PTR [rdi]
	mov	rcx, QWORD PTR [rcx]
	sar	r10d, 3
	mov	edi, DWORD PTR [rcx]
	mov	rcx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r8d, DWORD PTR 160[rcx]
	sar	edi, 3
	test	r8d, r8d
	je	.L2517
	mov	rcx, QWORD PTR pastblshifta@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rcx]
	sar	r10d, cl
	mov	rcx, QWORD PTR pastblshiftb@GOTPCREL[rip]
	and	r10d, 60
	mov	ecx, DWORD PTR [rcx]
	sar	edi, cl
	or	edi, 3
.L2517:
	lea	ecx, 1[rdi]
	mov	rdi, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rdi, QWORD PTR [rdi]
	mov	r8d, DWORD PTR [rdi]
	mov	rdi, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rdi, QWORD PTR [rdi]
	imul	r8d, r10d
	mov	r9d, DWORD PTR [rdi]
	mov	rdi, QWORD PTR blender1a_g@GOTPCREL[rip]
	imul	r9d, ecx
	mov	rdi, QWORD PTR [rdi]
	add	r8d, r9d
	sar	r8d, 5
	movzx	r8d, r8b
	mov	DWORD PTR 448[rsp], r8d
	mov	r9d, DWORD PTR [rdi]
	mov	rdi, QWORD PTR blender2a_g@GOTPCREL[rip]
	imul	r9d, r10d
	mov	rdi, QWORD PTR [rdi]
	mov	ebp, DWORD PTR [rdi]
	imul	ebp, ecx
	mov	edi, ebp
	add	edi, r9d
	mov	r9, QWORD PTR blender1a_b@GOTPCREL[rip]
	sar	edi, 5
	movzx	edi, dil
	mov	r9, QWORD PTR [r9]
	mov	DWORD PTR 464[rsp], edi
	imul	r10d, DWORD PTR [r9]
	mov	r9, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	rbp, QWORD PTR [r9]
	imul	ecx, DWORD PTR 0[rbp]
	add	r10d, ecx
	mov	rcx, QWORD PTR pre_memory_color@GOTPCREL[rip]
	sar	r10d, 5
	movzx	r10d, r10b
	movdqa	xmm1, XMMWORD PTR [rcx]
	mov	rcx, QWORD PTR memory_color@GOTPCREL[rip]
	mov	DWORD PTR 480[rsp], r10d
	movdqa	XMMWORD PTR [rcx], xmm1
	mov	rcx, QWORD PTR blended_pixel_color@GOTPCREL[rip]
	mov	DWORD PTR [rcx], r8d
	mov	DWORD PTR 4[rcx], edi
	mov	DWORD PTR 8[rcx], r10d
	mov	DWORD PTR 12[rcx], eax
	mov	rcx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	ecx, DWORD PTR 112[rcx]
	test	ecx, ecx
	je	.L2518
	test	esi, esi
	jne	.L2518
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 448[rsp], eax
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 464[rsp], eax
	mov	rax, QWORD PTR 8[r9]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 480[rsp], eax
.L2523:
	mov	ecx, r11d
	mov	rdx, QWORD PTR 224[rsp]
	mov	rsi, QWORD PTR 232[rsp]
	mov	rdi, QWORD PTR 240[rsp]
	call	[QWORD PTR rgb_dither_ptr[rip]]
	mov	eax, DWORD PTR 336[rsp]
	mov	r9d, DWORD PTR 320[rsp]
	mov	edi, ebx
	mov	r8d, DWORD PTR 288[rsp]
	mov	ecx, DWORD PTR 480[rsp]
	mov	edx, DWORD PTR 464[rsp]
	mov	esi, DWORD PTR 448[rsp]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR fbwrite_ptr@GOTPCREL[rip]
	call	[QWORD PTR [rax]]
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r10d, DWORD PTR 120[rax]
	test	r10d, r10d
	je	.L2508
	mov	edx, DWORD PTR 384[rsp]
	mov	rax, QWORD PTR z_com_table@GOTPCREL[rip]
	and	edx, 262143
	movzx	edx, WORD PTR [rax+rdx*2]
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	cmp	r15d, DWORD PTR [rax]
	ja	.L2508
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	or	dx, WORD PTR 256[rsp]
	mov	ecx, r15d
	xor	ecx, 1
	movzx	ebx, BYTE PTR 287[rsp]
	mov	rax, QWORD PTR [rax]
	mov	WORD PTR [rax+rcx*2], dx
	mov	rdx, QWORD PTR hidden_bits@GOTPCREL[rip]
	mov	eax, r15d
	mov	BYTE PTR [rdx+rax], bl
	jmp	.L2508
	.p2align 4,,10
	.p2align 3
.L2489:
	mov	DWORD PTR 416[rsp], 32768
	mov	esi, 32768
	jmp	.L2490
	.p2align 4,,10
	.p2align 3
.L2498:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r10d, r10d
	mov	r9d, 1
	xor	esi, esi
	mov	edi, 262136
	xor	r8d, r8d
	mov	edx, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	r11d, ecx
	jmp	.L2500
	.p2align 4,,10
	.p2align 3
.L2479:
	add	DWORD PTR 68[rsp], 1
	mov	eax, DWORD PTR 68[rsp]
	cmp	DWORD PTR 272[rsp], eax
	jge	.L2527
.L2469:
	add	rsp, 504
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
.L2576:
	.cfi_restore_state
	cmp	BYTE PTR 286[rsp], 0
	setne	cl
	jmp	.L2516
	.p2align 4,,10
	.p2align 3
.L2509:
	mov	r10d, DWORD PTR 136[rdi]
	test	r10d, r10d
	jne	.L2512
	mov	rdi, QWORD PTR blend_color@GOTPCREL[rip]
	mov	edi, DWORD PTR 12[rdi]
.L2513:
	cmp	eax, edi
	jl	.L2508
	mov	rdi, QWORD PTR other_modes@GOTPCREL[rip]
	jmp	.L2514
	.p2align 4,,10
	.p2align 3
.L2504:
	add	r11d, DWORD PTR 276[rsp]
	or	edx, r8d
	and	edx, 1
	mov	eax, r11d
	sub	r11d, edx
	sub	eax, r10d
	lea	edx, 2[r11]
	add	eax, 1
	jmp	.L2505
	.p2align 4,,10
	.p2align 3
.L2518:
	mov	rsi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	ebp, DWORD PTR 156[rsi]
	test	ebp, ebp
	je	.L2520
	cmp	eax, 254
	jg	.L2521
.L2520:
	test	edx, edx
	jne	.L2522
.L2521:
	mov	rax, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 448[rsp], eax
	mov	rax, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 464[rsp], eax
	mov	rax, QWORD PTR blender1a_b@GOTPCREL[rip]
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 480[rsp], eax
	jmp	.L2523
	.p2align 4,,10
	.p2align 3
.L2480:
	mov	rax, QWORD PTR primitive_z@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 44[rsp], eax
	jmp	.L2481
	.p2align 4,,10
	.p2align 3
.L2482:
	mov	eax, DWORD PTR 72[rsp]
	mov	edi, DWORD PTR 68[rsp]
	sub	edx, eax
	sub	eax, ebx
	mov	DWORD PTR 88[rsp], edx
	mov	ebx, eax
	call	compute_cvg_flip@PLT
	jmp	.L2483
	.p2align 4,,10
	.p2align 3
.L2512:
	mov	r8, QWORD PTR iseed@GOTPCREL[rip]
	mov	r9d, DWORD PTR [r8]
	imul	edi, r9d, 214013
	add	edi, 2531011
	mov	DWORD PTR [r8], edi
	sar	edi, 16
	movzx	edi, dil
	jmp	.L2513
	.p2align 4,,10
	.p2align 3
.L2522:
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rsi, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	rdx, QWORD PTR 224[rsp]
	mov	rdi, QWORD PTR 240[rsp]
	mov	DWORD PTR 52[rsp], r11d
	mov	rax, QWORD PTR 8[rax]
	mov	eax, DWORD PTR [rax]
	not	eax
	and	eax, 255
	mov	DWORD PTR 12[rsi], eax
	mov	rsi, QWORD PTR 232[rsp]
	call	blender_equation_cycle1@PLT
	mov	r11d, DWORD PTR 52[rsp]
	jmp	.L2523
.L2530:
	mov	DWORD PTR 180[rsp], edx
	mov	eax, 2
	mov	BYTE PTR 287[rsp], 3
	jmp	.L2476
.L2472:
	mov	rax, QWORD PTR primitive_delta_z@GOTPCREL[rip]
	mov	DWORD PTR 156[rsp], 0
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 176[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	ebx, DWORD PTR 176[rsp]
	mov	DWORD PTR 12[rax], 0
	mov	rax, QWORD PTR spans_cdz@GOTPCREL[rip]
	mov	DWORD PTR [rax], 0
	jmp	.L2473
.L2470:
	mov	ebx, DWORD PTR 4[rax]
	neg	DWORD PTR 160[rsp]
	mov	DWORD PTR 216[rsp], -1
	mov	DWORD PTR 164[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 164[rsp]
	mov	DWORD PTR 168[rsp], ebx
	neg	DWORD PTR 168[rsp]
	mov	DWORD PTR 172[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	neg	DWORD PTR 172[rsp]
	mov	ebx, DWORD PTR [rax]
	mov	DWORD PTR 100[rsp], ebx
	mov	ebx, DWORD PTR 4[rax]
	neg	DWORD PTR 100[rsp]
	mov	DWORD PTR 104[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 104[rsp]
	mov	DWORD PTR 108[rsp], ebx
	neg	DWORD PTR 108[rsp]
	mov	DWORD PTR 156[rsp], eax
	neg	DWORD PTR 156[rsp]
	jmp	.L2471
.L2575:
	mov	r10d, r8d
	sal	edi, 3
	mov	esi, r8d
	and	r10d, 1
	mov	r9d, 1
	mov	edx, -1
	jmp	.L2500
	.cfi_endproc
.LFE589:
	.size	render_spans_2cycle_notexelnext, .-render_spans_2cycle_notexelnext
	.p2align 4,,15
	.globl	IsBadPtrW32
	.type	IsBadPtrW32, @function
IsBadPtrW32:
.LFB644:
	.cfi_startproc
	xor	eax, eax
	ret
	.cfi_endproc
.LFE644:
	.size	IsBadPtrW32, .-IsBadPtrW32
	.p2align 4,,15
	.globl	vi_integer_sqrt
	.type	vi_integer_sqrt, @function
vi_integer_sqrt:
.LFB645:
	.cfi_startproc
	mov	edi, edi
	mov	edx, 1073741824
	cmp	rdi, 1073741823
	ja	.L2583
	.p2align 4,,10
	.p2align 3
.L2586:
	shr	rdx, 2
	cmp	rdi, rdx
	jb	.L2586
	test	rdx, rdx
	je	.L2587
.L2583:
	xor	eax, eax
	jmp	.L2580
	.p2align 4,,10
	.p2align 3
.L2588:
	mov	rdi, r8
.L2580:
	lea	rcx, [rax+rdx]
	lea	rsi, [rax+rdx*2]
	mov	r8, rdi
	sub	r8, rcx
	cmp	rcx, rdi
	cmova	r8, rdi
	cmovbe	rax, rsi
	shr	rdx, 2
	shr	rax
	test	rdx, rdx
	jne	.L2588
	rep ret
.L2587:
	xor	eax, eax
	ret
	.cfi_endproc
.LFE645:
	.size	vi_integer_sqrt, .-vi_integer_sqrt
	.p2align 4,,15
	.globl	precalculate_everything
	.type	precalculate_everything, @function
precalculate_everything:
.LFB567:
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
	xor	ebx, ebx
	sub	rsp, 56
	.cfi_def_cfa_offset 112
	mov	rbp, QWORD PTR gamma_table@GOTPCREL[rip]
	.p2align 4,,10
	.p2align 3
.L2591:
	mov	edi, ebx
	sal	edi, 6
	call	vi_integer_sqrt@PLT
	add	eax, eax
	mov	DWORD PTR 0[rbp+rbx*4], eax
	add	rbx, 1
	cmp	rbx, 256
	jne	.L2591
	mov	rbp, QWORD PTR gamma_dither_table@GOTPCREL[rip]
	xor	bx, bx
	.p2align 4,,10
	.p2align 3
.L2593:
	mov	edi, ebx
	call	vi_integer_sqrt@PLT
	add	eax, eax
	mov	DWORD PTR 0[rbp+rbx*4], eax
	add	rbx, 1
	cmp	rbx, 16384
	jne	.L2593
	call	z_build_com_table@PLT
	mov	r8, QWORD PTR z_complete_dec_table@GOTPCREL[rip]
	mov	rdi, QWORD PTR z_dec_table@GOTPCREL[rip]
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L2595:
	mov	esi, edx
	mov	eax, edx
	sar	esi, 11
	and	eax, 2047
	mov	ecx, DWORD PTR [rdi+rsi*8]
	sal	eax, cl
	add	eax, DWORD PTR 4[rdi+rsi*8]
	and	eax, 262143
	mov	DWORD PTR [r8+rdx*4], eax
	add	rdx, 1
	cmp	rdx, 16384
	jne	.L2595
	call	precalc_cvmask_derivatives@PLT
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	mov	DWORD PTR 4[rax], 0
	mov	DWORD PTR [rax], 0
	lea	rdx, 8[rax]
	mov	eax, 2
	jmp	.L2596
	.p2align 4,,10
	.p2align 3
.L2649:
	test	al, 64
	jne	.L2624
	test	al, 32
	jne	.L2625
	test	al, 16
	.p2align 4,,5
	jne	.L2626
	test	al, 8
	.p2align 4,,5
	jne	.L2627
	test	al, 4
	.p2align 4,,5
	jne	.L2628
	test	al, 2
	.p2align 4,,5
	jne	.L2648
	add	eax, 1
	add	rdx, 4
	cmp	eax, 256
	je	.L2597
.L2596:
	mov	ecx, eax
	sar	ecx, 7
	test	ecx, ecx
	je	.L2649
	mov	ecx, 7
	mov	DWORD PTR [rdx], ecx
	.p2align 4,,10
	.p2align 3
.L2654:
	add	eax, 1
	add	rdx, 4
	cmp	eax, 256
	jne	.L2596
.L2597:
	mov	rdx, QWORD PTR vi_restore_table@GOTPCREL[rip]
	xor	eax, eax
	jmp	.L2604
	.p2align 4,,10
	.p2align 3
.L2651:
	add	eax, 1
	mov	DWORD PTR [rdx], 1
	add	rdx, 4
	cmp	eax, 1024
	je	.L2650
.L2604:
	mov	esi, eax
	mov	ecx, eax
	sar	esi, 5
	and	ecx, 31
	cmp	esi, ecx
	jl	.L2651
	setle	cl
	add	eax, 1
	add	rdx, 4
	movzx	ecx, cl
	sub	ecx, 1
	mov	DWORD PTR -4[rdx], ecx
	cmp	eax, 1024
	jne	.L2604
.L2650:
	movdqa	xmm0, XMMWORD PTR .LC5[rip]
	mov	rax, QWORD PTR replicated_rgba@GOTPCREL[rip]
	mov	rdx, QWORD PTR special_9bit_clamptable@GOTPCREL[rip]
	movdqa	xmm6, XMMWORD PTR .LC6[rip]
	movdqa	xmm2, xmm0
	movdqa	xmm3, xmm6
	pslld	xmm2, 3
	psrad	xmm6, 2
	movdqa	xmm1, xmm2
	movdqa	xmm4, XMMWORD PTR .LC7[rip]
	pslld	xmm3, 3
	punpcklwd	xmm2, xmm3
	punpckhwd	xmm1, xmm3
	movdqa	xmm5, XMMWORD PTR .LC8[rip]
	movdqa	xmm3, xmm2
	punpcklwd	xmm2, xmm1
	movdqa	xmm7, xmm5
	psrad	xmm5, 2
	punpckhwd	xmm3, xmm1
	movdqa	xmm1, xmm4
	pslld	xmm7, 3
	psrad	xmm4, 2
	punpcklwd	xmm2, xmm3
	pslld	xmm1, 3
	movdqa	xmm3, xmm1
	punpcklwd	xmm1, xmm7
	punpckhwd	xmm3, xmm7
	movdqa	xmm7, xmm1
	punpcklwd	xmm1, xmm3
	punpckhwd	xmm7, xmm3
	movdqa	xmm3, xmm2
	punpcklwd	xmm1, xmm7
	punpckhbw	xmm3, xmm1
	punpcklbw	xmm2, xmm1
	movdqa	xmm1, xmm2
	punpcklbw	xmm2, xmm3
	punpckhbw	xmm1, xmm3
	movdqa	xmm7, xmm2
	movdqa	xmm3, xmm2
	punpckhbw	xmm7, xmm1
	punpcklbw	xmm3, xmm1
	movdqa	xmm1, xmm0
	psrad	xmm1, 2
	movdqa	xmm2, xmm1
	punpcklwd	xmm1, xmm6
	punpckhwd	xmm2, xmm6
	punpcklbw	xmm3, xmm7
	movdqa	xmm7, XMMWORD PTR .LC9[rip]
	movdqa	xmm6, xmm1
	punpcklwd	xmm1, xmm2
	punpckhwd	xmm6, xmm2
	movdqa	xmm2, xmm4
	punpckhwd	xmm4, xmm5
	punpcklwd	xmm2, xmm5
	punpcklwd	xmm1, xmm6
	movdqa	xmm6, XMMWORD PTR .LC10[rip]
	movdqa	xmm5, xmm2
	punpcklwd	xmm2, xmm4
	punpckhwd	xmm5, xmm4
	movdqa	xmm4, xmm1
	punpcklwd	xmm2, xmm5
	movdqa	xmm5, XMMWORD PTR .LC12[rip]
	punpckhbw	xmm4, xmm2
	punpcklbw	xmm1, xmm2
	movdqa	xmm8, xmm5
	psrad	xmm5, 2
	pslld	xmm8, 3
	movdqa	xmm2, xmm1
	punpcklbw	xmm1, xmm4
	punpckhbw	xmm2, xmm4
	movdqa	xmm4, xmm1
	punpcklbw	xmm1, xmm2
	punpckhbw	xmm4, xmm2
	movdqa	xmm2, xmm7
	psrad	xmm7, 2
	pslld	xmm2, 3
	punpcklbw	xmm1, xmm4
	movdqa	xmm4, XMMWORD PTR .LC11[rip]
	por	xmm3, xmm1
	movdqa	xmm1, xmm2
	movdqa	XMMWORD PTR [rax], xmm3
	movdqa	xmm3, xmm6
	psrad	xmm6, 2
	pslld	xmm3, 3
	punpcklwd	xmm2, xmm3
	punpckhwd	xmm1, xmm3
	movdqa	xmm3, xmm2
	punpcklwd	xmm2, xmm1
	punpckhwd	xmm3, xmm1
	movdqa	xmm1, xmm4
	psrad	xmm4, 2
	pslld	xmm1, 3
	punpcklwd	xmm2, xmm3
	movdqa	xmm3, xmm1
	punpcklwd	xmm1, xmm8
	punpckhwd	xmm3, xmm8
	movdqa	xmm8, xmm1
	punpcklwd	xmm1, xmm3
	punpckhwd	xmm8, xmm3
	movdqa	xmm3, xmm2
	punpcklwd	xmm1, xmm8
	punpckhbw	xmm3, xmm1
	punpcklbw	xmm2, xmm1
	movdqa	xmm1, xmm2
	punpcklbw	xmm2, xmm3
	punpckhbw	xmm1, xmm3
	movdqa	xmm8, xmm2
	movdqa	xmm3, xmm2
	movdqa	xmm2, xmm7
	punpckhbw	xmm8, xmm1
	punpcklbw	xmm3, xmm1
	movdqa	xmm1, xmm7
	punpckhwd	xmm2, xmm6
	punpcklwd	xmm1, xmm6
	punpcklbw	xmm3, xmm8
	movdqa	xmm6, xmm1
	punpcklwd	xmm1, xmm2
	punpckhwd	xmm6, xmm2
	movdqa	xmm2, xmm4
	punpckhwd	xmm4, xmm5
	punpcklwd	xmm2, xmm5
	punpcklwd	xmm1, xmm6
	movdqa	xmm5, xmm2
	punpcklwd	xmm2, xmm4
	punpckhwd	xmm5, xmm4
	movdqa	xmm4, xmm1
	punpcklwd	xmm2, xmm5
	punpckhbw	xmm4, xmm2
	punpcklbw	xmm1, xmm2
	movdqa	xmm2, xmm1
	punpcklbw	xmm1, xmm4
	punpckhbw	xmm2, xmm4
	movdqa	xmm4, xmm1
	punpcklbw	xmm1, xmm2
	punpckhbw	xmm4, xmm2
	punpcklbw	xmm1, xmm4
	por	xmm3, xmm1
	movdqa	XMMWORD PTR 16[rax], xmm3
	mov	rax, QWORD PTR maskbits_table@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1023
	mov	DWORD PTR 4[rax], 1
	mov	DWORD PTR 8[rax], 3
	mov	DWORD PTR 12[rax], 7
	mov	DWORD PTR 16[rax], 15
	mov	DWORD PTR 20[rax], 31
	mov	DWORD PTR 24[rax], 63
	mov	DWORD PTR 28[rax], 127
	mov	DWORD PTR 32[rax], 255
	mov	DWORD PTR 36[rax], 511
	mov	DWORD PTR 40[rax], 1023
	mov	DWORD PTR 44[rax], 1023
	mov	DWORD PTR 48[rax], 1023
	mov	DWORD PTR 52[rax], 1023
	mov	DWORD PTR 56[rax], 1023
	mov	DWORD PTR 60[rax], 1023
	xor	eax, eax
	jmp	.L2610
	.p2align 4,,10
	.p2align 3
.L2607:
	mov	DWORD PTR [rdx], 0
.L2608:
	add	eax, 1
	add	rdx, 4
	cmp	eax, 512
	je	.L2652
.L2610:
	mov	ecx, eax
	sar	ecx, 7
	cmp	ecx, 2
	je	.L2606
	cmp	ecx, 3
	je	.L2607
	movzx	ecx, al
	add	eax, 1
	add	rdx, 4
	mov	DWORD PTR -4[rdx], ecx
	cmp	eax, 512
	jne	.L2610
.L2652:
	mov	rax, QWORD PTR special_9bit_exttable@GOTPCREL[rip]
	movdqa	xmm6, XMMWORD PTR .LC13[rip]
	lea	rdx, 2048[rax]
	movdqa	xmm3, XMMWORD PTR .LC14[rip]
	movdqa	xmm5, XMMWORD PTR .LC15[rip]
	jmp	.L2613
	.p2align 4,,10
	.p2align 3
.L2611:
	movdqa	xmm0, xmm4
.L2613:
	movdqa	xmm1, xmm0
	add	rax, 16
	movdqa	xmm2, xmm0
	pand	xmm1, xmm3
	movdqa	xmm4, xmm0
	por	xmm2, xmm5
	paddd	xmm4, xmm6
	pcmpeqd	xmm1, xmm3
	pand	xmm2, xmm1
	pandn	xmm1, xmm0
	por	xmm1, xmm2
	movdqa	XMMWORD PTR -16[rax], xmm1
	cmp	rax, rdx
	jne	.L2611
	xor	ecx, ecx
	mov	r10, QWORD PTR norm_slope_table@GOTPCREL[rip]
	mov	r9, QWORD PTR tcdiv_table@GOTPCREL[rip]
	mov	r8, QWORD PTR norm_point_table@GOTPCREL[rip]
	jmp	.L2612
	.p2align 4,,10
	.p2align 3
.L2653:
	lea	esi, 0[0+rcx*4]
	test	esi, 32768
	jne	.L2631
	lea	eax, 0[0+rcx*8]
	test	ah, 128
	jne	.L2632
	mov	esi, ecx
	sal	esi, 4
	test	esi, 32768
	jne	.L2633
	mov	eax, ecx
	sal	eax, 5
	test	ah, 128
	jne	.L2634
	mov	esi, ecx
	sal	esi, 6
	test	esi, 32768
	jne	.L2635
	mov	eax, ecx
	sal	eax, 7
	test	ah, 128
	jne	.L2636
	mov	esi, ecx
	sal	esi, 8
	test	esi, 32768
	jne	.L2637
	mov	eax, ecx
	sal	eax, 9
	test	ah, 128
	jne	.L2638
	mov	esi, ecx
	sal	esi, 10
	test	esi, 32768
	jne	.L2639
	mov	eax, ecx
	sal	eax, 11
	test	ah, 128
	jne	.L2640
	mov	esi, ecx
	sal	esi, 12
	test	esi, 32768
	jne	.L2641
	mov	edi, ecx
	sal	edi, 13
	test	edi, 32768
	jne	.L2642
	mov	eax, ecx
	sal	eax, 14
	mov	edx, eax
	and	edx, 32768
	cmp	edx, 1
	sbb	esi, esi
	not	esi
	add	esi, 14
	test	edx, edx
	cmovne	eax, edi
.L2615:
	mov	edx, eax
	movzx	eax, al
	and	edx, 16383
	sal	eax, 2
	sar	edx, 8
	movsx	rdi, edx
	mov	edx, DWORD PTR [r10+rdi*4]
	or	edx, -1024
	add	edx, 1
	imul	edx, eax
	sar	edx, 10
	add	edx, DWORD PTR [r8+rdi*4]
	and	edx, 32767
	sal	edx, 4
	or	edx, esi
	mov	DWORD PTR [r9+rcx*4], edx
	add	rcx, 1
	cmp	rcx, 32768
	je	.L2614
.L2612:
	lea	eax, [rcx+rcx]
	test	ah, 128
	je	.L2653
	mov	eax, ecx
	xor	esi, esi
	jmp	.L2615
.L2624:
	mov	ecx, 6
	mov	DWORD PTR [rdx], ecx
	jmp	.L2654
.L2625:
	mov	ecx, 5
	mov	DWORD PTR [rdx], ecx
	jmp	.L2654
.L2626:
	mov	ecx, 4
	mov	DWORD PTR [rdx], ecx
	jmp	.L2654
.L2627:
	mov	ecx, 3
	mov	DWORD PTR [rdx], ecx
	jmp	.L2654
.L2628:
	mov	ecx, 2
	mov	DWORD PTR [rdx], ecx
	jmp	.L2654
.L2648:
	mov	ecx, 1
	mov	DWORD PTR [rdx], ecx
	jmp	.L2654
	.p2align 4,,10
	.p2align 3
.L2606:
	mov	DWORD PTR [rdx], 255
	jmp	.L2608
.L2631:
	mov	esi, 1
	jmp	.L2615
.L2632:
	mov	eax, esi
	mov	esi, 2
	jmp	.L2615
.L2633:
	mov	esi, 3
	jmp	.L2615
.L2634:
	mov	eax, esi
	mov	esi, 4
	jmp	.L2615
.L2635:
	mov	esi, 5
	jmp	.L2615
.L2636:
	mov	eax, esi
	mov	esi, 6
	jmp	.L2615
.L2637:
	mov	esi, 7
	jmp	.L2615
.L2638:
	mov	eax, esi
	mov	esi, 8
	jmp	.L2615
.L2639:
	mov	esi, 9
	jmp	.L2615
.L2640:
	mov	eax, esi
	mov	esi, 10
	jmp	.L2615
.L2641:
	mov	esi, 11
	jmp	.L2615
.L2642:
	mov	eax, esi
	mov	esi, 12
	jmp	.L2615
.L2614:
	mov	r14, QWORD PTR bldiv_hwaccurate_table@GOTPCREL[rip]
	xor	r12d, r12d
	mov	r8, rsp
	mov	r11d, 7
	mov	r10d, 256
	mov	r13d, 1
	.p2align 4,,10
	.p2align 3
.L2622:
	mov	ebp, r12d
	mov	r9d, r12d
	xor	edi, edi
	sar	ebp, 11
	and	r9d, 2047
	mov	ebx, ebp
	mov	eax, r9d
	not	ebx
	sar	eax, 8
	and	ebx, 15
	lea	eax, 1[rbx+rax]
	and	eax, 7
	mov	DWORD PTR [rsp], eax
	xor	eax, eax
	jmp	.L2620
	.p2align 4,,10
	.p2align 3
.L2656:
	lea	ecx, [rbx+rcx*2]
	lea	edx, 1[rdx+rcx]
.L2617:
	mov	ecx, edx
	and	ecx, 7
	and	edx, 16
	mov	DWORD PTR 4[r8+rax*4], ecx
	je	.L2618
	mov	edx, r13d
	mov	ecx, esi
	sal	edx, cl
	or	edi, edx
.L2618:
	add	rax, 1
	cmp	rax, 8
	je	.L2655
.L2620:
	mov	esi, r11d
	mov	edx, r9d
	mov	r15d, r10d
	sub	esi, eax
	mov	ecx, esi
	sar	edx, cl
	mov	ecx, eax
	sar	r15d, cl
	and	edx, 1
	mov	ecx, DWORD PTR [r8+rax*4]
	test	r15d, edi
	jne	.L2656
	lea	ecx, 0[rbp+rcx*2]
	add	edx, ecx
	jmp	.L2617
	.p2align 4,,10
	.p2align 3
.L2655:
	mov	BYTE PTR [r12+r14], dil
	add	r12, 1
	cmp	r12, 32768
	jne	.L2622
	add	rsp, 56
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
.LFE567:
	.size	precalculate_everything, .-precalculate_everything
	.p2align 4,,15
	.globl	rdp_init
	.type	rdp_init, @function
rdp_init:
.LFB558:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	lea	rbx, one_color[rip]
	sub	rsp, 8
	.cfi_def_cfa_offset 32
	mov	rax, QWORD PTR fbread_func@GOTPCREL[rip]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR fbread1_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR fbread2_func@GOTPCREL[rip]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR fbread2_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR fbwrite_func@GOTPCREL[rip]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR fbwrite_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR fbfill_func@GOTPCREL[rip]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR fbfill_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR get_dither_noise_complete@GOTPCREL[rip]
	mov	rdx, QWORD PTR render_spans_1cycle_complete@GOTPCREL[rip]
	mov	QWORD PTR get_dither_noise_ptr[rip], rax
	mov	rax, QWORD PTR rgb_dither_complete@GOTPCREL[rip]
	mov	QWORD PTR rgb_dither_ptr[rip], rax
	mov	rax, QWORD PTR tcdiv_nopersp@GOTPCREL[rip]
	mov	QWORD PTR tcdiv_ptr[rip], rax
	mov	rax, QWORD PTR render_spans_1cycle_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rax], rdx
	mov	rdx, QWORD PTR render_spans_2cycle_notexel1@GOTPCREL[rip]
	mov	rax, QWORD PTR render_spans_2cycle_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR combiner_rgbsub_a_r@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbsub_a_g@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbsub_a_b@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbsub_b_g@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbsub_b_b@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbmul_r@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbmul_g@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbmul_b@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbadd_g@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_rgbadd_b@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	mov	r10, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	r9, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	r8, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rdi, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rsi, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	mov	rbp, QWORD PTR blender1a_b@GOTPCREL[rip]
	mov	r11, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	mov	QWORD PTR 8[rax], rbx
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	QWORD PTR [r10], rax
	lea	rcx, 4[rax]
	lea	rdx, 8[rax]
	lea	rbx, 12[rax]
	mov	QWORD PTR [r9], rax
	mov	rax, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	mov	QWORD PTR [r8], rcx
	mov	QWORD PTR [rdi], rcx
	mov	QWORD PTR [rsi], rdx
	mov	QWORD PTR 0[rbp], rdx
	lea	rcx, 12[rax]
	mov	rax, QWORD PTR blended_pixel_color@GOTPCREL[rip]
	mov	rdx, QWORD PTR blender2b_a@GOTPCREL[rip]
	mov	QWORD PTR [r11], rbx
	mov	QWORD PTR 8[r11], rbx
	mov	QWORD PTR 8[r9], rax
	lea	r9, 4[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdi], r9
	lea	rdi, 8[rax]
	mov	QWORD PTR 8[rbp], rdi
	mov	QWORD PTR 8[r10], rax
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	QWORD PTR 8[rsi], rdi
	xor	esi, esi
	mov	rdi, QWORD PTR TMEM@GOTPCREL[rip]
	mov	QWORD PTR 8[rdx], rcx
	mov	edx, 4096
	mov	QWORD PTR 8[r8], r9
	mov	DWORD PTR 144[rax], 1
	call	memfill@PLT
	mov	rdi, QWORD PTR tvfadeoutstate@GOTPCREL[rip]
	mov	edx, 2500
	xor	esi, esi
	call	memfill@PLT
	mov	rdi, QWORD PTR hidden_bits@GOTPCREL[rip]
	mov	edx, 4194304
	mov	esi, 3
	call	memfill@PLT
	mov	rbx, QWORD PTR tile@GOTPCREL[rip]
	xor	esi, esi
	mov	edx, 800
	mov	rdi, rbx
	call	memfill@PLT
	lea	rax, 80[rbx]
	lea	rdi, 880[rbx]
	mov	esi, 10
	.p2align 4,,10
	.p2align 3
.L2661:
	mov	r11d, DWORD PTR -52[rax]
	mov	edx, 1
	test	r11d, r11d
	jne	.L2658
	mov	r10d, DWORD PTR -36[rax]
	xor	edx, edx
	test	r10d, r10d
	sete	dl
.L2658:
	mov	r9d, DWORD PTR -60[rax]
	mov	DWORD PTR -4[rax], edx
	mov	edx, 1
	test	r9d, r9d
	jne	.L2659
	mov	r8d, DWORD PTR -44[rax]
	xor	edx, edx
	test	r8d, r8d
	sete	dl
.L2659:
	cmp	DWORD PTR -36[rax], 10
	mov	DWORD PTR [rax], edx
	mov	edx, esi
	cmovle	edx, DWORD PTR -36[rax]
	cmp	DWORD PTR -44[rax], 10
	mov	ebx, DWORD PTR -76[rax]
	mov	DWORD PTR 4[rax], edx
	mov	edx, esi
	cmovle	edx, DWORD PTR -44[rax]
	add	rax, 100
	mov	DWORD PTR -92[rax], edx
	mov	edx, DWORD PTR -180[rax]
	lea	ecx, 0[0+rdx*4]
	or	ecx, DWORD PTR -176[rax]
	add	edx, 2
	and	edx, 3
	mov	DWORD PTR -88[rax], ecx
	lea	ecx, 0[0+rbx*4]
	or	edx, ecx
	mov	ecx, DWORD PTR -128[rax]
	mov	DWORD PTR -84[rax], edx
	mov	edx, DWORD PTR -120[rax]
	sar	ecx, 2
	sar	edx, 2
	sub	edx, ecx
	mov	ecx, DWORD PTR -124[rax]
	and	edx, 1023
	mov	DWORD PTR -112[rax], edx
	mov	edx, DWORD PTR -116[rax]
	sar	ecx, 2
	sar	edx, 2
	sub	edx, ecx
	and	edx, 1023
	mov	DWORD PTR -108[rax], edx
	cmp	rax, rdi
	jne	.L2661
	mov	rdi, QWORD PTR combined_color@GOTPCREL[rip]
	mov	edx, 16
	xor	esi, esi
	call	memfill@PLT
	mov	rdi, QWORD PTR prim_color@GOTPCREL[rip]
	mov	edx, 16
	xor	esi, esi
	call	memfill@PLT
	mov	rdi, QWORD PTR env_color@GOTPCREL[rip]
	mov	edx, 16
	xor	esi, esi
	call	memfill@PLT
	mov	rdi, QWORD PTR key_scale@GOTPCREL[rip]
	mov	edx, 16
	xor	esi, esi
	call	memfill@PLT
	mov	rdi, QWORD PTR key_center@GOTPCREL[rip]
	mov	edx, 16
	xor	esi, esi
	call	memfill@PLT
	mov	rax, QWORD PTR rdp_pipeline_crashed@GOTPCREL[rip]
	mov	rdi, QWORD PTR onetimewarnings@GOTPCREL[rip]
	mov	edx, 20
	xor	esi, esi
	mov	DWORD PTR [rax], 0
	call	memfill@PLT
	call	precalculate_everything@PLT
	mov	rax, QWORD PTR plim@GOTPCREL[rip]
	mov	rdx, QWORD PTR rdram_8@GOTPCREL[rip]
	mov	DWORD PTR [rax], 8388607
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	mov	DWORD PTR [rax], 4194303
	mov	rax, QWORD PTR idxlim32@GOTPCREL[rip]
	mov	DWORD PTR [rax], 2097151
	mov	rax, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rax, QWORD PTR 32[rax]
	mov	QWORD PTR [rdx], rax
	mov	rdx, QWORD PTR rdram_16@GOTPCREL[rip]
	mov	QWORD PTR [rdx], rax
	add	rsp, 8
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE558:
	.size	rdp_init, .-rdp_init
	.p2align 4,,15
	.globl	tclod_2cycle_current
	.type	tclod_2cycle_current, @function
tclod_2cycle_current:
.LFB648:
	.cfi_startproc
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	mov	r14d, edx
	push	r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	mov	r13d, ecx
	push	r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	push	rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	push	rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	sub	rsp, 32
	.cfi_def_cfa_offset 80
	mov	ebx, DWORD PTR [rdi]
	mov	ebp, DWORD PTR [rsi]
	test	ebx, 262144
	jne	.L2666
	test	ebx, 131072
	jne	.L2667
	mov	eax, ebx
	and	eax, 98304
	cmp	eax, 32768
	je	.L2666
	cmp	eax, 65536
	je	.L2667
	movzx	eax, bx
	test	ebp, 262144
	mov	DWORD PTR [rdi], eax
	je	.L2719
	.p2align 4,,10
	.p2align 3
.L2669:
	mov	DWORD PTR [rsi], 32767
.L2671:
	mov	r12, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 148[r12]
	test	eax, eax
	jne	.L2720
.L2665:
	add	rsp, 32
	.cfi_remember_state
	.cfi_def_cfa_offset 48
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
	.p2align 4,,10
	.p2align 3
.L2666:
	.cfi_restore_state
	mov	DWORD PTR [rdi], 32767
.L2668:
	test	ebp, 262144
	jne	.L2669
.L2719:
	test	ebp, 131072
	jne	.L2670
	mov	eax, ebp
	and	eax, 98304
	cmp	eax, 32768
	je	.L2669
	cmp	eax, 65536
	je	.L2670
	and	DWORD PTR [rsi], 65535
	jmp	.L2671
	.p2align 4,,10
	.p2align 3
.L2667:
	mov	DWORD PTR [rdi], 32768
	jmp	.L2668
	.p2align 4,,10
	.p2align 3
.L2670:
	mov	DWORD PTR [rsi], 32768
	jmp	.L2671
	.p2align 4,,10
	.p2align 3
.L2720:
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	edx, DWORD PTR 80[rsp]
	mov	rcx, rsp
	mov	edi, DWORD PTR [rax]
	mov	esi, DWORD PTR 4[rax]
	add	edx, DWORD PTR 8[rax]
	add	esi, r9d
	add	edi, r8d
	lea	r8, 16[rsp]
	sar	edi, 16
	sar	esi, 16
	sar	edx, 16
	mov	DWORD PTR [rsp], edi
	mov	DWORD PTR 16[rsp], esi
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	edx, ebx
	mov	esi, r14d
	mov	edi, ebp
	mov	eax, r13d
	sal	edx, 15
	sal	esi, 15
	sal	edi, 15
	sal	eax, 15
	sar	edx, 15
	sar	edi, 15
	sar	eax, 15
	sar	esi, 15
	sub	eax, edi
	sub	esi, edx
	mov	r8d, DWORD PTR [rsp]
	mov	r9d, DWORD PTR 16[rsp]
	jns	.L2673
	not	esi
	and	esi, 131071
.L2673:
	test	eax, 131072
	je	.L2674
	not	eax
	and	eax, 131071
.L2674:
	xor	ecx, ecx
	test	esi, esi
	cmovns	ecx, esi
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	ecx, eax
	and	ecx, 32767
	mov	esi, ecx
	or	esi, 16384
	test	eax, 114688
	mov	eax, r9d
	cmovne	ecx, esi
	mov	esi, r8d
	sal	eax, 15
	sal	esi, 15
	sar	eax, 15
	sar	esi, 15
	sub	eax, edi
	sub	esi, edx
	mov	edx, esi
	jns	.L2676
	not	edx
	and	edx, 131071
.L2676:
	test	eax, 131072
	je	.L2677
	not	eax
	and	eax, 131071
.L2677:
	cmp	edx, ecx
	cmovge	ecx, edx
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L2679
	mov	eax, r9d
	or	eax, r8d
	or	eax, r14d
	or	eax, r13d
	or	eax, ebp
	or	eax, ebx
	sar	eax, 17
	mov	ecx, eax
	shr	ecx
	or	ecx, eax
	and	ecx, 1
	jne	.L2679
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, edi
	cmovge	edi, edx
	mov	edx, edi
	lea	r9d, -32[rdi]
	sar	edx, 5
	movzx	edx, dl
	sar	r9d, 31
	test	edi, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	ebx, ecx
	jne	.L2721
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	mov	r11d, r9d
	mov	edx, r9d
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	edi, 3
	and	r11d, 1
	neg	esi
	mov	r10d, esi
	and	r10d, 1
	jmp	.L2681
	.p2align 4,,10
	.p2align 3
.L2679:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r11d, r11d
	mov	r10d, 1
	xor	edx, edx
	mov	edi, 262136
	xor	r9d, r9d
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	ebx, ecx
.L2681:
	mov	r8d, DWORD PTR 8[r12]
	sar	edi, cl
	mov	ecx, DWORD PTR 12[r12]
	mov	eax, edi
	mov	r14d, r8d
	or	r14d, ecx
	jne	.L2682
	mov	eax, edx
	not	eax
	and	eax, edi
	or	eax, esi
.L2682:
	and	edx, ecx
	mov	ebp, DWORD PTR 16[r12]
	movzx	eax, al
	sal	edx, 8
	or	eax, edx
	movzx	eax, ax
	test	ebp, ebp
	mov	DWORD PTR lod_frac[rip], eax
	je	.L2665
	test	r10d, r10d
	je	.L2683
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	ebx, DWORD PTR [rax]
.L2683:
	add	ebx, DWORD PTR 112[rsp]
	test	r8d, r8d
	jne	.L2684
	mov	rax, QWORD PTR 120[rsp]
	mov	DWORD PTR [rax], ebx
	mov	eax, DWORD PTR 12[r12]
	not	eax
	and	eax, r11d
	or	eax, r10d
	sub	ebx, eax
	lea	eax, 1[rbx]
	mov	rbx, QWORD PTR 128[rsp]
	mov	DWORD PTR [rbx], eax
	mov	rax, QWORD PTR 120[rsp]
.L2685:
	and	DWORD PTR [rax], 7
	mov	rax, QWORD PTR 128[rsp]
	and	DWORD PTR [rax], 7
	add	rsp, 32
	.cfi_remember_state
	.cfi_def_cfa_offset 48
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
	.p2align 4,,10
	.p2align 3
.L2684:
	.cfi_restore_state
	mov	eax, ebx
	mov	rdx, QWORD PTR 120[rsp]
	or	esi, r9d
	sub	eax, r11d
	and	esi, 1
	add	eax, 1
	sub	ebx, esi
	mov	DWORD PTR [rdx], eax
	lea	eax, 2[rbx]
	mov	rbx, QWORD PTR 128[rsp]
	mov	DWORD PTR [rbx], eax
	mov	rax, rdx
	jmp	.L2685
.L2721:
	mov	r11d, r9d
	sal	edi, 3
	mov	edx, r9d
	and	r11d, 1
	mov	r10d, 1
	or	esi, -1
	jmp	.L2681
	.cfi_endproc
.LFE648:
	.size	tclod_2cycle_current, .-tclod_2cycle_current
	.p2align 4,,15
	.globl	tclod_2cycle_current_simple
	.type	tclod_2cycle_current_simple, @function
tclod_2cycle_current_simple:
.LFB649:
	.cfi_startproc
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	push	r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	push	rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	push	rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	sub	rsp, 72
	.cfi_def_cfa_offset 112
	mov	ebx, DWORD PTR [rdi]
	mov	ebp, DWORD PTR [rsi]
	test	ebx, 262144
	jne	.L2723
	test	ebx, 131072
	jne	.L2724
	mov	eax, ebx
	and	eax, 98304
	cmp	eax, 32768
	je	.L2723
	cmp	eax, 65536
	je	.L2724
	movzx	eax, bx
	test	ebp, 262144
	mov	DWORD PTR [rdi], eax
	je	.L2776
	.p2align 4,,10
	.p2align 3
.L2726:
	mov	DWORD PTR [rsi], 32767
.L2728:
	mov	r12, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 148[r12]
	test	eax, eax
	jne	.L2777
.L2722:
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	rbp
	.cfi_def_cfa_offset 24
	pop	r12
	.cfi_def_cfa_offset 16
	pop	r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2723:
	.cfi_restore_state
	mov	DWORD PTR [rdi], 32767
.L2725:
	test	ebp, 262144
	jne	.L2726
.L2776:
	test	ebp, 131072
	jne	.L2727
	mov	eax, ebp
	and	eax, 98304
	cmp	eax, 32768
	je	.L2726
	cmp	eax, 65536
	je	.L2727
	and	DWORD PTR [rsi], 65535
	jmp	.L2728
	.p2align 4,,10
	.p2align 3
.L2724:
	mov	DWORD PTR [rdi], 32768
	jmp	.L2725
	.p2align 4,,10
	.p2align 3
.L2727:
	mov	DWORD PTR [rsi], 32768
	jmp	.L2728
	.p2align 4,,10
	.p2align 3
.L2777:
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	lea	edi, [rdx+r9]
	mov	esi, DWORD PTR 112[rsp]
	sar	edi, 16
	add	edx, DWORD PTR [rax]
	mov	r13d, DWORD PTR 8[rax]
	add	esi, ecx
	add	ecx, DWORD PTR 4[rax]
	sar	esi, 16
	mov	DWORD PTR 32[rsp], edi
	mov	DWORD PTR 48[rsp], esi
	add	r13d, r8d
	sar	edx, 16
	sar	r13d, 16
	mov	DWORD PTR [rsp], edx
	mov	edx, DWORD PTR 120[rsp]
	sar	ecx, 16
	mov	DWORD PTR 16[rsp], ecx
	lea	rcx, 32[rsp]
	add	edx, r8d
	lea	r8, 48[rsp]
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	lea	r8, 16[rsp]
	mov	edx, r13d
	mov	esi, DWORD PTR 16[rsp]
	mov	edi, DWORD PTR [rsp]
	mov	rcx, rsp
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r10d, DWORD PTR 48[rsp]
	mov	r11d, DWORD PTR 32[rsp]
	mov	edx, ebx
	mov	edi, ebp
	sal	edx, 15
	mov	r9d, DWORD PTR [rsp]
	sal	edi, 15
	sar	edx, 15
	mov	r8d, DWORD PTR 16[rsp]
	mov	esi, r11d
	mov	eax, r10d
	sar	edi, 15
	sal	esi, 15
	sal	eax, 15
	sar	eax, 15
	sar	esi, 15
	sub	eax, edi
	sub	esi, edx
	jns	.L2730
	not	esi
	and	esi, 131071
.L2730:
	test	eax, 131072
	je	.L2731
	not	eax
	and	eax, 131071
.L2731:
	xor	ecx, ecx
	test	esi, esi
	cmovns	ecx, esi
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	ecx, eax
	and	ecx, 32767
	mov	esi, ecx
	or	esi, 16384
	test	eax, 114688
	mov	eax, r8d
	cmovne	ecx, esi
	mov	esi, r9d
	sal	eax, 15
	sal	esi, 15
	sar	eax, 15
	sar	esi, 15
	sub	eax, edi
	sub	esi, edx
	mov	edx, esi
	jns	.L2733
	not	edx
	and	edx, 131071
.L2733:
	test	eax, 131072
	je	.L2734
	not	eax
	and	eax, 131071
.L2734:
	cmp	edx, ecx
	cmovge	ecx, edx
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L2736
	mov	eax, r11d
	or	eax, r10d
	or	eax, r9d
	or	eax, r8d
	or	eax, ebp
	or	eax, ebx
	sar	eax, 17
	mov	ecx, eax
	shr	ecx
	or	ecx, eax
	and	ecx, 1
	jne	.L2736
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, edi
	cmovge	edi, edx
	mov	edx, edi
	lea	r9d, -32[rdi]
	sar	edx, 5
	movzx	edx, dl
	sar	r9d, 31
	test	edi, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	ebx, ecx
	jne	.L2778
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	mov	r11d, r9d
	mov	edx, r9d
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	edi, 3
	and	r11d, 1
	neg	esi
	mov	r10d, esi
	and	r10d, 1
	jmp	.L2738
	.p2align 4,,10
	.p2align 3
.L2736:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r11d, r11d
	mov	r10d, 1
	xor	edx, edx
	mov	edi, 262136
	xor	r9d, r9d
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	ebx, ecx
.L2738:
	mov	r8d, DWORD PTR 8[r12]
	sar	edi, cl
	mov	ecx, DWORD PTR 12[r12]
	mov	eax, edi
	mov	ebp, r8d
	or	ebp, ecx
	jne	.L2739
	mov	eax, edx
	not	eax
	and	eax, edi
	or	eax, esi
.L2739:
	and	edx, ecx
	movzx	eax, al
	sal	edx, 8
	or	eax, edx
	movzx	eax, ax
	mov	DWORD PTR lod_frac[rip], eax
	mov	eax, DWORD PTR 16[r12]
	test	eax, eax
	je	.L2722
	test	r10d, r10d
	je	.L2740
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	ebx, DWORD PTR [rax]
.L2740:
	add	ebx, DWORD PTR 128[rsp]
	test	r8d, r8d
	jne	.L2741
	mov	rax, QWORD PTR 136[rsp]
	mov	DWORD PTR [rax], ebx
	mov	eax, DWORD PTR 12[r12]
	not	eax
	and	eax, r11d
	or	eax, r10d
	sub	ebx, eax
	lea	eax, 1[rbx]
	mov	rbx, QWORD PTR 144[rsp]
	mov	DWORD PTR [rbx], eax
	mov	rax, QWORD PTR 136[rsp]
.L2742:
	and	DWORD PTR [rax], 7
	mov	rax, QWORD PTR 144[rsp]
	and	DWORD PTR [rax], 7
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	rbp
	.cfi_def_cfa_offset 24
	pop	r12
	.cfi_def_cfa_offset 16
	pop	r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2741:
	.cfi_restore_state
	mov	eax, ebx
	mov	rdi, QWORD PTR 136[rsp]
	or	esi, r9d
	sub	eax, r11d
	and	esi, 1
	add	eax, 1
	sub	ebx, esi
	mov	DWORD PTR [rdi], eax
	lea	eax, 2[rbx]
	mov	rbx, QWORD PTR 144[rsp]
	mov	DWORD PTR [rbx], eax
	mov	rax, rdi
	jmp	.L2742
.L2778:
	mov	r11d, r9d
	sal	edi, 3
	mov	edx, r9d
	and	r11d, 1
	mov	r10d, 1
	or	esi, -1
	jmp	.L2738
	.cfi_endproc
.LFE649:
	.size	tclod_2cycle_current_simple, .-tclod_2cycle_current_simple
	.p2align 4,,15
	.globl	tclod_2cycle_current_notexel1
	.type	tclod_2cycle_current_notexel1, @function
tclod_2cycle_current_notexel1:
.LFB650:
	.cfi_startproc
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	push	r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	push	rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	push	rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	sub	rsp, 72
	.cfi_def_cfa_offset 112
	mov	ebx, DWORD PTR [rdi]
	mov	ebp, DWORD PTR [rsi]
	test	ebx, 262144
	jne	.L2780
	test	ebx, 131072
	jne	.L2781
	mov	eax, ebx
	and	eax, 98304
	cmp	eax, 32768
	je	.L2780
	cmp	eax, 65536
	je	.L2781
	movzx	eax, bx
	test	ebp, 262144
	mov	DWORD PTR [rdi], eax
	je	.L2831
	.p2align 4,,10
	.p2align 3
.L2783:
	mov	DWORD PTR [rsi], 32767
.L2785:
	mov	r12, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 148[r12]
	test	eax, eax
	jne	.L2832
.L2779:
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	rbp
	.cfi_def_cfa_offset 24
	pop	r12
	.cfi_def_cfa_offset 16
	pop	r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2780:
	.cfi_restore_state
	mov	DWORD PTR [rdi], 32767
.L2782:
	test	ebp, 262144
	jne	.L2783
.L2831:
	test	ebp, 131072
	jne	.L2784
	mov	eax, ebp
	and	eax, 98304
	cmp	eax, 32768
	je	.L2783
	cmp	eax, 65536
	je	.L2784
	and	DWORD PTR [rsi], 65535
	jmp	.L2785
	.p2align 4,,10
	.p2align 3
.L2781:
	mov	DWORD PTR [rdi], 32768
	jmp	.L2782
	.p2align 4,,10
	.p2align 3
.L2784:
	mov	DWORD PTR [rsi], 32768
	jmp	.L2785
	.p2align 4,,10
	.p2align 3
.L2832:
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	lea	edi, [rdx+r9]
	mov	esi, DWORD PTR 112[rsp]
	sar	edi, 16
	add	edx, DWORD PTR [rax]
	mov	r13d, DWORD PTR 8[rax]
	add	esi, ecx
	add	ecx, DWORD PTR 4[rax]
	sar	esi, 16
	mov	DWORD PTR 32[rsp], edi
	mov	DWORD PTR 48[rsp], esi
	add	r13d, r8d
	sar	edx, 16
	sar	r13d, 16
	mov	DWORD PTR [rsp], edx
	mov	edx, DWORD PTR 120[rsp]
	sar	ecx, 16
	mov	DWORD PTR 16[rsp], ecx
	lea	rcx, 32[rsp]
	add	edx, r8d
	lea	r8, 48[rsp]
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	lea	r8, 16[rsp]
	mov	edx, r13d
	mov	esi, DWORD PTR 16[rsp]
	mov	edi, DWORD PTR [rsp]
	mov	rcx, rsp
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r10d, DWORD PTR 48[rsp]
	mov	r11d, DWORD PTR 32[rsp]
	mov	edx, ebx
	mov	edi, ebp
	sal	edx, 15
	mov	r9d, DWORD PTR [rsp]
	sal	edi, 15
	sar	edx, 15
	mov	r8d, DWORD PTR 16[rsp]
	mov	esi, r11d
	mov	eax, r10d
	sar	edi, 15
	sal	esi, 15
	sal	eax, 15
	sar	eax, 15
	sar	esi, 15
	sub	eax, edi
	sub	esi, edx
	jns	.L2787
	not	esi
	and	esi, 131071
.L2787:
	test	eax, 131072
	je	.L2788
	not	eax
	and	eax, 131071
.L2788:
	xor	ecx, ecx
	test	esi, esi
	cmovns	ecx, esi
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	ecx, eax
	and	ecx, 32767
	mov	esi, ecx
	or	esi, 16384
	test	eax, 114688
	mov	eax, r8d
	cmovne	ecx, esi
	mov	esi, r9d
	sal	eax, 15
	sal	esi, 15
	sar	eax, 15
	sar	esi, 15
	sub	eax, edi
	sub	esi, edx
	mov	edx, esi
	jns	.L2790
	not	edx
	and	edx, 131071
.L2790:
	test	eax, 131072
	je	.L2791
	not	eax
	and	eax, 131071
.L2791:
	cmp	edx, ecx
	cmovge	ecx, edx
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L2793
	mov	eax, r11d
	or	eax, r10d
	or	eax, r9d
	or	eax, r8d
	or	eax, ebp
	or	eax, ebx
	sar	eax, 17
	mov	ecx, eax
	shr	ecx
	or	ecx, eax
	and	ecx, 1
	jne	.L2793
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, edi
	cmovge	edi, edx
	mov	edx, edi
	lea	r11d, -32[rdi]
	sar	edx, 5
	movzx	edx, dl
	sar	r11d, 31
	test	edi, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	r9d, ecx
	jne	.L2833
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	mov	edx, r11d
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	edi, 3
	and	r11d, 1
	neg	esi
	mov	r10d, esi
	and	r10d, 1
	jmp	.L2795
	.p2align 4,,10
	.p2align 3
.L2793:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r11d, r11d
	mov	r10d, 1
	xor	edx, edx
	mov	edi, 262136
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	r9d, ecx
.L2795:
	mov	r8d, DWORD PTR 8[r12]
	sar	edi, cl
	mov	ecx, DWORD PTR 12[r12]
	mov	eax, edi
	mov	ebx, r8d
	or	ebx, ecx
	jne	.L2796
	mov	eax, edx
	not	eax
	and	eax, edi
	or	eax, esi
.L2796:
	and	edx, ecx
	movzx	eax, al
	sal	edx, 8
	or	eax, edx
	movzx	eax, ax
	mov	DWORD PTR lod_frac[rip], eax
	mov	eax, DWORD PTR 16[r12]
	test	eax, eax
	je	.L2779
	test	r10d, r10d
	je	.L2797
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	r9d, DWORD PTR [rax]
.L2797:
	mov	eax, DWORD PTR 128[rsp]
	mov	edx, r11d
	not	edx
	and	edx, r8d
	add	eax, edx
	mov	rdx, QWORD PTR 136[rsp]
	add	eax, r9d
	and	eax, 7
	mov	DWORD PTR [rdx], eax
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	rbp
	.cfi_def_cfa_offset 24
	pop	r12
	.cfi_def_cfa_offset 16
	pop	r13
	.cfi_def_cfa_offset 8
	ret
.L2833:
	.cfi_restore_state
	mov	edx, r11d
	sal	edi, 3
	and	r11d, 1
	mov	r10d, 1
	or	esi, -1
	jmp	.L2795
	.cfi_endproc
.LFE650:
	.size	tclod_2cycle_current_notexel1, .-tclod_2cycle_current_notexel1
	.p2align 4,,15
	.globl	tclod_2cycle_next
	.type	tclod_2cycle_next, @function
tclod_2cycle_next:
.LFB651:
	.cfi_startproc
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	push	r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	push	rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	push	rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	sub	rsp, 72
	.cfi_def_cfa_offset 112
	mov	ebp, DWORD PTR [rdi]
	mov	r12d, DWORD PTR [rsi]
	test	ebp, 262144
	jne	.L2835
	test	ebp, 131072
	jne	.L2836
	mov	eax, ebp
	and	eax, 98304
	cmp	eax, 32768
	je	.L2835
	cmp	eax, 65536
	je	.L2836
	movzx	eax, bp
	test	r12d, 262144
	mov	DWORD PTR [rdi], eax
	je	.L2889
	.p2align 4,,10
	.p2align 3
.L2838:
	mov	DWORD PTR [rsi], 32767
.L2840:
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	esi, DWORD PTR 148[rbx]
	test	esi, esi
	jne	.L2890
.L2834:
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	rbp
	.cfi_def_cfa_offset 24
	pop	r12
	.cfi_def_cfa_offset 16
	pop	r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2835:
	.cfi_restore_state
	mov	DWORD PTR [rdi], 32767
.L2837:
	test	r12d, 262144
	jne	.L2838
.L2889:
	test	r12d, 131072
	jne	.L2839
	mov	eax, r12d
	and	eax, 98304
	cmp	eax, 32768
	je	.L2838
	cmp	eax, 65536
	je	.L2839
	and	DWORD PTR [rsi], 65535
	jmp	.L2840
	.p2align 4,,10
	.p2align 3
.L2836:
	mov	DWORD PTR [rdi], 32768
	jmp	.L2837
	.p2align 4,,10
	.p2align 3
.L2839:
	mov	DWORD PTR [rsi], 32768
	jmp	.L2840
	.p2align 4,,10
	.p2align 3
.L2890:
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	lea	edi, [rdx+r9]
	mov	esi, DWORD PTR 112[rsp]
	sar	edi, 16
	add	edx, DWORD PTR [rax]
	mov	r13d, DWORD PTR 8[rax]
	add	esi, ecx
	add	ecx, DWORD PTR 4[rax]
	sar	esi, 16
	mov	DWORD PTR [rsp], edi
	mov	DWORD PTR 16[rsp], esi
	add	r13d, r8d
	sar	edx, 16
	sar	r13d, 16
	mov	DWORD PTR 32[rsp], edx
	mov	edx, DWORD PTR 120[rsp]
	sar	ecx, 16
	mov	DWORD PTR 48[rsp], ecx
	mov	rcx, rsp
	add	edx, r8d
	lea	r8, 16[rsp]
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	lea	r8, 48[rsp]
	mov	edx, r13d
	mov	esi, DWORD PTR 48[rsp]
	mov	edi, DWORD PTR 32[rsp]
	lea	rcx, 32[rsp]
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r10d, DWORD PTR 16[rsp]
	mov	r11d, DWORD PTR [rsp]
	mov	edx, ebp
	mov	edi, r12d
	sal	edx, 15
	mov	r9d, DWORD PTR 32[rsp]
	sal	edi, 15
	sar	edx, 15
	mov	r8d, DWORD PTR 48[rsp]
	mov	esi, r11d
	mov	eax, r10d
	sar	edi, 15
	sal	esi, 15
	sal	eax, 15
	sar	eax, 15
	sar	esi, 15
	sub	eax, edi
	sub	esi, edx
	jns	.L2842
	not	esi
	and	esi, 131071
.L2842:
	test	eax, 131072
	je	.L2843
	not	eax
	and	eax, 131071
.L2843:
	xor	ecx, ecx
	test	esi, esi
	cmovns	ecx, esi
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	ecx, eax
	and	ecx, 32767
	mov	esi, ecx
	or	esi, 16384
	test	eax, 114688
	mov	eax, r8d
	cmovne	ecx, esi
	mov	esi, r9d
	sal	eax, 15
	sal	esi, 15
	sar	eax, 15
	sar	esi, 15
	sub	eax, edi
	sub	esi, edx
	mov	edx, esi
	jns	.L2845
	not	edx
	and	edx, 131071
.L2845:
	test	eax, 131072
	je	.L2846
	not	eax
	and	eax, 131071
.L2846:
	cmp	edx, ecx
	cmovge	ecx, edx
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L2848
	mov	eax, r11d
	or	eax, r10d
	or	eax, r9d
	or	eax, r8d
	or	eax, r12d
	or	eax, ebp
	sar	eax, 17
	mov	ecx, eax
	shr	ecx
	or	ecx, eax
	and	ecx, 1
	jne	.L2848
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	cmovl	edx, eax
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	mov	ecx, edx
	lea	edi, -32[rdx]
	sar	ecx, 5
	movzx	ecx, cl
	sar	edi, 31
	test	dh, 96
	mov	ecx, DWORD PTR [rax+rcx*4]
	mov	r8d, ecx
	jne	.L2891
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	edx, 3
	neg	esi
	jmp	.L2850
	.p2align 4,,10
	.p2align 3
.L2848:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	mov	edx, 262136
	xor	edi, edi
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	r8d, ecx
.L2850:
	mov	rax, QWORD PTR 152[rsp]
	sar	edx, cl
	mov	DWORD PTR [rax], edx
	mov	eax, DWORD PTR 8[rbx]
	or	eax, DWORD PTR 12[rbx]
	je	.L2892
.L2851:
	mov	rax, QWORD PTR 152[rsp]
	movzx	edx, dl
	mov	rcx, QWORD PTR 152[rsp]
	mov	DWORD PTR [rax], edx
	mov	eax, DWORD PTR 12[rbx]
	and	eax, edi
	sal	eax, 8
	or	eax, edx
	mov	DWORD PTR [rcx], eax
	mov	edx, DWORD PTR 16[rbx]
	test	edx, edx
	je	.L2834
	test	esi, esi
	je	.L2852
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	r8d, DWORD PTR [rax]
.L2852:
	mov	eax, DWORD PTR 8[rbx]
	add	r8d, DWORD PTR 128[rsp]
	test	eax, eax
	jne	.L2853
	mov	rax, QWORD PTR 136[rsp]
	mov	DWORD PTR [rax], r8d
	mov	eax, DWORD PTR 12[rbx]
	mov	rbx, QWORD PTR 144[rsp]
	not	eax
	and	eax, edi
	or	eax, esi
	sub	r8d, eax
	lea	eax, 1[r8]
	mov	DWORD PTR [rbx], eax
.L2854:
	mov	rax, QWORD PTR 136[rsp]
	and	DWORD PTR [rax], 7
	mov	rax, QWORD PTR 144[rsp]
	and	DWORD PTR [rax], 7
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	rbp
	.cfi_def_cfa_offset 24
	pop	r12
	.cfi_def_cfa_offset 16
	pop	r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2892:
	.cfi_restore_state
	mov	eax, edi
	not	eax
	and	edx, eax
	or	edx, esi
	jmp	.L2851
	.p2align 4,,10
	.p2align 3
.L2853:
	mov	eax, r8d
	mov	rbx, QWORD PTR 136[rsp]
	or	esi, edi
	sub	eax, edi
	sub	r8d, esi
	add	eax, 1
	mov	DWORD PTR [rbx], eax
	mov	rbx, QWORD PTR 144[rsp]
	lea	eax, 2[r8]
	mov	DWORD PTR [rbx], eax
	jmp	.L2854
.L2891:
	sal	edx, 3
	or	esi, -1
	jmp	.L2850
	.cfi_endproc
.LFE651:
	.size	tclod_2cycle_next, .-tclod_2cycle_next
	.p2align 4,,15
	.globl	tclod_1cycle_current
	.type	tclod_1cycle_current, @function
tclod_1cycle_current:
.LFB652:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	mov	r12d, edx
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	mov	ebp, ecx
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	sub	rsp, 32
	.cfi_def_cfa_offset 64
	mov	eax, DWORD PTR [rdi]
	mov	r10d, DWORD PTR [rsi]
	test	eax, 262144
	jne	.L2894
	test	eax, 131072
	jne	.L2895
	mov	edx, eax
	and	edx, 98304
	cmp	edx, 32768
	je	.L2894
	cmp	edx, 65536
	je	.L2895
	and	eax, 65535
	test	r10d, 262144
	mov	DWORD PTR [rdi], eax
	je	.L2946
	.p2align 4,,10
	.p2align 3
.L2897:
	mov	DWORD PTR [rsi], 32767
.L2899:
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r10d, DWORD PTR 148[rbx]
	test	r10d, r10d
	je	.L2893
	mov	eax, DWORD PTR 96[rsp]
	add	eax, 1
	cdqe
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	edi, DWORD PTR 12[rax]
	test	edi, edi
	jne	.L2947
.L2901:
	mov	eax, DWORD PTR 64[rsp]
	mov	esi, DWORD PTR 88[rsp]
	lea	edx, [rax+rsi*2]
	mov	eax, DWORD PTR 72[rsp]
	sar	edx, 16
	lea	edi, [r8+rax*2]
	mov	eax, DWORD PTR 80[rsp]
	sar	edi, 16
	lea	esi, [r9+rax*2]
	mov	DWORD PTR [rsp], edi
	sar	esi, 16
	mov	DWORD PTR 16[rsp], esi
.L2906:
	mov	rcx, rsp
	lea	r8, 16[rsp]
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	edi, DWORD PTR 16[rsp]
	mov	r8d, DWORD PTR [rsp]
	mov	edx, r12d
	mov	esi, ebp
	sal	edx, 15
	sal	esi, 15
	sar	edx, 15
	mov	ecx, r8d
	mov	eax, edi
	sar	esi, 15
	sal	ecx, 15
	sal	eax, 15
	sar	eax, 15
	sar	ecx, 15
	sub	eax, esi
	sub	ecx, edx
	jns	.L2907
	not	ecx
	and	ecx, 131071
.L2907:
	test	eax, 131072
	je	.L2908
	not	eax
	and	eax, 131071
.L2908:
	xor	edx, edx
	test	ecx, ecx
	cmovns	edx, ecx
	cmp	edx, eax
	cmovge	eax, edx
	mov	edx, eax
	mov	ecx, eax
	and	edx, 32767
	mov	eax, edx
	or	ah, 64
	and	ecx, 114688
	cmovne	edx, eax
	test	dh, 64
	jne	.L2910
	mov	eax, r8d
	or	eax, edi
	or	eax, r12d
	or	eax, ebp
	sar	eax, 17
	mov	ecx, eax
	shr	ecx
	or	ecx, eax
	and	ecx, 1
	je	.L2948
.L2910:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r11d, r11d
	mov	r10d, 1
	xor	edx, edx
	mov	edi, 262136
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	r9d, ecx
.L2912:
	mov	r8d, DWORD PTR 8[rbx]
	sar	edi, cl
	mov	ecx, DWORD PTR 12[rbx]
	mov	eax, edi
	mov	ebp, r8d
	or	ebp, ecx
	jne	.L2913
	mov	eax, edx
	not	eax
	and	eax, edi
	or	eax, esi
.L2913:
	and	edx, ecx
	mov	edi, DWORD PTR 16[rbx]
	movzx	eax, al
	sal	edx, 8
	or	eax, edx
	movzx	eax, ax
	test	edi, edi
	mov	DWORD PTR lod_frac[rip], eax
	je	.L2893
	test	r10d, r10d
	je	.L2914
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	r9d, DWORD PTR [rax]
.L2914:
	mov	edx, r11d
	mov	eax, DWORD PTR 104[rsp]
	not	edx
	and	edx, r8d
	add	eax, edx
	mov	rdx, QWORD PTR 112[rsp]
	add	eax, r9d
	and	eax, 7
	mov	DWORD PTR [rdx], eax
.L2893:
	add	rsp, 32
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2894:
	.cfi_restore_state
	mov	DWORD PTR [rdi], 32767
.L2896:
	test	r10d, 262144
	jne	.L2897
.L2946:
	test	r10d, 131072
	jne	.L2898
	and	r10d, 98304
	cmp	r10d, 32768
	je	.L2897
	cmp	r10d, 65536
	je	.L2898
	and	DWORD PTR [rsi], 65535
	jmp	.L2899
	.p2align 4,,10
	.p2align 3
.L2895:
	mov	DWORD PTR [rdi], 32768
	jmp	.L2896
	.p2align 4,,10
	.p2align 3
.L2947:
	mov	rdi, QWORD PTR 120[rsp]
	mov	edx, DWORD PTR 4[rdi]
	test	edx, edx
	jne	.L2949
.L2902:
	mov	rax, QWORD PTR 120[rsp]
	mov	ecx, DWORD PTR 8[rax]
	test	ecx, ecx
	je	.L2904
	mov	r11d, DWORD PTR 20[rax]
	test	r11d, r11d
	jne	.L2905
.L2904:
	test	edx, edx
	je	.L2901
	mov	rax, QWORD PTR 120[rsp]
	mov	r10d, DWORD PTR 16[rax]
	test	r10d, r10d
	je	.L2901
.L2905:
	mov	edi, r8d
	mov	esi, r9d
	sub	edi, DWORD PTR 72[rsp]
	sub	esi, DWORD PTR 80[rsp]
	mov	edx, DWORD PTR 64[rsp]
	sub	edx, DWORD PTR 88[rsp]
	sar	edi, 16
	sar	esi, 16
	mov	DWORD PTR [rsp], edi
	sar	edx, 16
	mov	DWORD PTR 16[rsp], esi
	jmp	.L2906
	.p2align 4,,10
	.p2align 3
.L2898:
	mov	DWORD PTR [rsi], 32768
	jmp	.L2899
	.p2align 4,,10
	.p2align 3
.L2949:
	mov	esi, DWORD PTR 20[rdi]
	test	esi, esi
	je	.L2902
	mov	edi, DWORD PTR 72[rsp]
	mov	esi, DWORD PTR 80[rsp]
	add	edi, DWORD PTR 32[rax]
	add	esi, DWORD PTR 36[rax]
	mov	edx, DWORD PTR 88[rsp]
	add	edx, DWORD PTR 40[rax]
	sar	edi, 16
	sar	esi, 16
	mov	DWORD PTR [rsp], edi
	mov	DWORD PTR 16[rsp], esi
	sar	edx, 16
	jmp	.L2906
	.p2align 4,,10
	.p2align 3
.L2948:
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, edi
	cmovge	edi, edx
	mov	edx, edi
	lea	r11d, -32[rdi]
	sar	edx, 5
	movzx	edx, dl
	sar	r11d, 31
	test	edi, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	r9d, ecx
	jne	.L2950
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	mov	edx, r11d
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	edi, 3
	and	r11d, 1
	neg	esi
	mov	r10d, esi
	and	r10d, 1
	jmp	.L2912
.L2950:
	mov	edx, r11d
	sal	edi, 3
	and	r11d, 1
	mov	r10d, 1
	or	esi, -1
	jmp	.L2912
	.cfi_endproc
.LFE652:
	.size	tclod_1cycle_current, .-tclod_1cycle_current
	.p2align 4,,15
	.globl	tclod_1cycle_current_simple
	.type	tclod_1cycle_current_simple, @function
tclod_1cycle_current_simple:
.LFB653:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	sub	rsp, 72
	.cfi_def_cfa_offset 96
	mov	eax, DWORD PTR [rdi]
	mov	r10d, DWORD PTR [rsi]
	test	eax, 262144
	jne	.L2952
	test	eax, 131072
	jne	.L2953
	mov	r11d, eax
	and	r11d, 98304
	cmp	r11d, 32768
	je	.L2952
	cmp	r11d, 65536
	je	.L2953
	and	eax, 65535
	test	r10d, 262144
	mov	DWORD PTR [rdi], eax
	je	.L3006
	.p2align 4,,10
	.p2align 3
.L2955:
	mov	DWORD PTR [rsi], 32767
.L2957:
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r10d, DWORD PTR 148[rbx]
	test	r10d, r10d
	je	.L2951
	mov	eax, DWORD PTR 112[rsp]
	add	eax, 1
	cdqe
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	edi, DWORD PTR 12[rax]
	test	edi, edi
	jne	.L3007
	mov	esi, DWORD PTR 96[rsp]
	mov	eax, DWORD PTR 104[rsp]
	lea	edi, [rdx+r9]
	sar	edi, 16
	add	esi, ecx
	add	eax, r8d
	mov	DWORD PTR 32[rsp], edi
	sar	esi, 16
	sar	eax, 16
	mov	DWORD PTR 48[rsp], esi
.L3005:
	lea	edx, [rdx+r9*2]
	mov	r11d, DWORD PTR 104[rsp]
	sar	edx, 16
	mov	DWORD PTR [rsp], edx
	mov	edx, DWORD PTR 96[rsp]
	lea	ebp, [r8+r11*2]
	sar	ebp, 16
	lea	edx, [rcx+rdx*2]
	sar	edx, 16
	mov	DWORD PTR 16[rsp], edx
.L2965:
	mov	edx, eax
	lea	rcx, 32[rsp]
	lea	r8, 48[rsp]
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	rcx, rsp
	lea	r8, 16[rsp]
	mov	edx, ebp
	mov	esi, DWORD PTR 16[rsp]
	mov	edi, DWORD PTR [rsp]
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r9d, DWORD PTR 16[rsp]
	mov	r10d, DWORD PTR 48[rsp]
	mov	r8d, DWORD PTR [rsp]
	mov	edi, DWORD PTR 32[rsp]
	mov	eax, r9d
	mov	esi, r10d
	mov	ecx, r8d
	mov	edx, edi
	sal	eax, 15
	sal	ecx, 15
	sal	edx, 15
	sal	esi, 15
	sar	eax, 15
	sar	esi, 15
	sar	ecx, 15
	sar	edx, 15
	sub	eax, esi
	sub	ecx, edx
	jns	.L2966
	not	ecx
	and	ecx, 131071
.L2966:
	test	eax, 131072
	je	.L2967
	not	eax
	and	eax, 131071
.L2967:
	xor	edx, edx
	test	ecx, ecx
	cmovns	edx, ecx
	cmp	edx, eax
	cmovge	eax, edx
	mov	edx, eax
	mov	ecx, eax
	and	edx, 32767
	mov	eax, edx
	or	ah, 64
	and	ecx, 114688
	cmovne	edx, eax
	test	dh, 64
	jne	.L2969
	mov	eax, r10d
	or	eax, r9d
	or	eax, r8d
	or	eax, edi
	sar	eax, 17
	mov	ecx, eax
	shr	ecx
	or	ecx, eax
	and	ecx, 1
	je	.L3008
.L2969:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r11d, r11d
	mov	r10d, 1
	xor	edx, edx
	mov	edi, 262136
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	r9d, ecx
.L2971:
	mov	r8d, DWORD PTR 8[rbx]
	sar	edi, cl
	mov	ecx, DWORD PTR 12[rbx]
	mov	eax, edi
	mov	ebp, r8d
	or	ebp, ecx
	jne	.L2972
	mov	eax, edx
	not	eax
	and	eax, edi
	or	eax, esi
.L2972:
	and	edx, ecx
	mov	ebx, DWORD PTR 16[rbx]
	movzx	eax, al
	sal	edx, 8
	or	eax, edx
	movzx	eax, ax
	test	ebx, ebx
	mov	DWORD PTR lod_frac[rip], eax
	je	.L2951
	test	r10d, r10d
	je	.L2973
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	r9d, DWORD PTR [rax]
.L2973:
	mov	edx, r11d
	mov	eax, DWORD PTR 120[rsp]
	not	edx
	and	edx, r8d
	add	eax, edx
	mov	rdx, QWORD PTR 128[rsp]
	add	eax, r9d
	and	eax, 7
	mov	DWORD PTR [rdx], eax
.L2951:
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2952:
	.cfi_restore_state
	mov	DWORD PTR [rdi], 32767
.L2954:
	test	r10d, 262144
	jne	.L2955
.L3006:
	test	r10d, 131072
	jne	.L2956
	and	r10d, 98304
	cmp	r10d, 32768
	je	.L2955
	cmp	r10d, 65536
	je	.L2956
	and	DWORD PTR [rsi], 65535
	jmp	.L2957
	.p2align 4,,10
	.p2align 3
.L2953:
	mov	DWORD PTR [rdi], 32768
	jmp	.L2954
	.p2align 4,,10
	.p2align 3
.L3007:
	mov	rdi, QWORD PTR 136[rsp]
	mov	r10d, DWORD PTR 4[rdi]
	test	r10d, r10d
	jne	.L3009
.L2960:
	mov	r11, QWORD PTR 136[rsp]
	mov	eax, DWORD PTR 104[rsp]
	lea	edi, [rdx+r9]
	mov	esi, DWORD PTR 96[rsp]
	sar	edi, 16
	mov	ebp, DWORD PTR 8[r11]
	add	eax, r8d
	mov	DWORD PTR 32[rsp], edi
	add	esi, ecx
	sar	eax, 16
	sar	esi, 16
	test	ebp, ebp
	mov	DWORD PTR 48[rsp], esi
	je	.L2962
	mov	r11d, DWORD PTR 20[r11]
	test	r11d, r11d
	jne	.L2963
.L2962:
	test	r10d, r10d
	je	.L3005
	mov	r11, QWORD PTR 136[rsp]
	mov	ebp, DWORD PTR 16[r11]
	test	ebp, ebp
	je	.L3005
.L2963:
	sub	r8d, DWORD PTR 104[rsp]
	sub	ecx, DWORD PTR 96[rsp]
	sub	edx, r9d
	sar	edx, 16
	mov	DWORD PTR [rsp], edx
	mov	ebp, r8d
	sar	ecx, 16
	sar	ebp, 16
	mov	DWORD PTR 16[rsp], ecx
	jmp	.L2965
	.p2align 4,,10
	.p2align 3
.L2956:
	mov	DWORD PTR [rsi], 32768
	jmp	.L2957
	.p2align 4,,10
	.p2align 3
.L3009:
	mov	esi, DWORD PTR 20[rdi]
	test	esi, esi
	je	.L2960
	mov	edx, DWORD PTR 36[rax]
	mov	ebp, DWORD PTR 40[rax]
	mov	ecx, DWORD PTR 32[rax]
	mov	esi, edx
	add	edx, DWORD PTR 96[rsp]
	mov	eax, ebp
	add	ebp, DWORD PTR 104[rsp]
	mov	edi, ecx
	add	r9d, ecx
	sar	edi, 16
	sar	esi, 16
	sar	r9d, 16
	mov	DWORD PTR 32[rsp], edi
	mov	DWORD PTR 48[rsp], esi
	sar	eax, 16
	sar	edx, 16
	mov	DWORD PTR [rsp], r9d
	mov	DWORD PTR 16[rsp], edx
	sar	ebp, 16
	jmp	.L2965
	.p2align 4,,10
	.p2align 3
.L3008:
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, edi
	cmovge	edi, edx
	mov	edx, edi
	lea	r11d, -32[rdi]
	sar	edx, 5
	movzx	edx, dl
	sar	r11d, 31
	test	edi, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	r9d, ecx
	jne	.L3010
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	mov	edx, r11d
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	edi, 3
	and	r11d, 1
	neg	esi
	mov	r10d, esi
	and	r10d, 1
	jmp	.L2971
.L3010:
	mov	edx, r11d
	sal	edi, 3
	and	r11d, 1
	mov	r10d, 1
	or	esi, -1
	jmp	.L2971
	.cfi_endproc
.LFE653:
	.size	tclod_1cycle_current_simple, .-tclod_1cycle_current_simple
	.p2align 4,,15
	.globl	tclod_1cycle_next
	.type	tclod_1cycle_next, @function
tclod_1cycle_next:
.LFB654:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	sub	rsp, 64
	.cfi_def_cfa_offset 96
	mov	eax, DWORD PTR [rdi]
	mov	r10d, DWORD PTR [rsi]
	mov	rbp, QWORD PTR 144[rsp]
	test	eax, 262144
	jne	.L3012
	test	eax, 131072
	jne	.L3013
	mov	r11d, eax
	and	r11d, 98304
	cmp	r11d, 32768
	je	.L3012
	cmp	r11d, 65536
	je	.L3013
	and	eax, 65535
	test	r10d, 262144
	mov	DWORD PTR [rdi], eax
	je	.L3071
	.p2align 4,,10
	.p2align 3
.L3015:
	mov	DWORD PTR [rsi], 32767
.L3017:
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r12d, DWORD PTR 148[rbx]
	test	r12d, r12d
	je	.L3011
	mov	eax, DWORD PTR 112[rsp]
	add	eax, 1
	cdqe
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	r11d, DWORD PTR 12[rax]
	test	r11d, r11d
	jne	.L3072
	mov	esi, DWORD PTR 96[rsp]
	mov	eax, DWORD PTR 104[rsp]
	lea	edi, [rdx+r9]
	sar	edi, 16
	add	esi, ecx
	add	eax, r8d
	mov	DWORD PTR [rsp], edi
	sar	esi, 16
	sar	eax, 16
	mov	DWORD PTR 16[rsp], esi
.L3070:
	lea	edx, [rdx+r9*2]
	mov	r11d, DWORD PTR 104[rsp]
	sar	edx, 16
	mov	DWORD PTR 32[rsp], edx
	mov	edx, DWORD PTR 96[rsp]
	lea	r12d, [r8+r11*2]
	sar	r12d, 16
	lea	edx, [rcx+rdx*2]
	sar	edx, 16
	mov	DWORD PTR 48[rsp], edx
.L3026:
	mov	edx, eax
	mov	rcx, rsp
	lea	r8, 16[rsp]
	call	[QWORD PTR tcdiv_ptr[rip]]
	lea	rcx, 32[rsp]
	lea	r8, 48[rsp]
	mov	edx, r12d
	mov	esi, DWORD PTR 48[rsp]
	mov	edi, DWORD PTR 32[rsp]
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r9d, DWORD PTR 48[rsp]
	mov	r10d, DWORD PTR 16[rsp]
	mov	r8d, DWORD PTR 32[rsp]
	mov	edi, DWORD PTR [rsp]
	mov	eax, r9d
	mov	esi, r10d
	mov	ecx, r8d
	mov	edx, edi
	sal	eax, 15
	sal	ecx, 15
	sal	edx, 15
	sal	esi, 15
	sar	eax, 15
	sar	esi, 15
	sar	ecx, 15
	sar	edx, 15
	sub	eax, esi
	sub	ecx, edx
	jns	.L3028
	not	ecx
	and	ecx, 131071
.L3028:
	test	eax, 131072
	je	.L3029
	not	eax
	and	eax, 131071
.L3029:
	xor	edx, edx
	test	ecx, ecx
	cmovns	edx, ecx
	cmp	edx, eax
	cmovge	eax, edx
	mov	edx, eax
	mov	ecx, eax
	and	edx, 32767
	mov	eax, edx
	or	ah, 64
	and	ecx, 114688
	cmovne	edx, eax
	test	dh, 64
	jne	.L3031
	mov	eax, r10d
	or	eax, r9d
	or	eax, r8d
	or	eax, edi
	sar	eax, 17
	mov	ecx, eax
	shr	ecx
	or	ecx, eax
	and	ecx, 1
	je	.L3073
.L3031:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	mov	edx, 262136
	xor	edi, edi
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	r8d, ecx
.L3033:
	sar	edx, cl
	mov	DWORD PTR 0[rbp], edx
	mov	eax, DWORD PTR 8[rbx]
	or	eax, DWORD PTR 12[rbx]
	jne	.L3034
	mov	eax, edi
	not	eax
	and	edx, eax
	or	edx, esi
.L3034:
	movzx	edx, dl
	mov	DWORD PTR 0[rbp], edx
	mov	eax, DWORD PTR 12[rbx]
	and	eax, edi
	sal	eax, 8
	or	eax, edx
	mov	DWORD PTR 0[rbp], eax
	mov	r11d, DWORD PTR 16[rbx]
	test	r11d, r11d
	je	.L3011
	test	esi, esi
	je	.L3035
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	r8d, DWORD PTR [rax]
.L3035:
	not	edi
	and	edi, DWORD PTR 8[rbx]
	mov	rax, QWORD PTR 128[rsp]
	add	edi, DWORD PTR 120[rsp]
	add	edi, r8d
	and	edi, 7
	mov	DWORD PTR [rax], edi
.L3011:
	add	rsp, 64
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L3012:
	.cfi_restore_state
	mov	DWORD PTR [rdi], 32767
.L3014:
	test	r10d, 262144
	jne	.L3015
.L3071:
	test	r10d, 131072
	jne	.L3016
	and	r10d, 98304
	cmp	r10d, 32768
	je	.L3015
	cmp	r10d, 65536
	je	.L3016
	and	DWORD PTR [rsi], 65535
	jmp	.L3017
	.p2align 4,,10
	.p2align 3
.L3013:
	mov	DWORD PTR [rdi], 32768
	jmp	.L3014
	.p2align 4,,10
	.p2align 3
.L3072:
	mov	rdi, QWORD PTR 136[rsp]
	mov	r10d, DWORD PTR 12[rdi]
	test	r10d, r10d
	je	.L3074
	mov	r12d, DWORD PTR 24[rdi]
	test	r12d, r12d
	jne	.L3027
	mov	ecx, DWORD PTR 104[rsp]
	add	ecx, DWORD PTR 40[rax]
	mov	edi, DWORD PTR 32[rax]
	mov	esi, DWORD PTR 96[rsp]
	add	esi, DWORD PTR 36[rax]
	add	edi, r9d
	mov	eax, ecx
.L3068:
	mov	edx, DWORD PTR 96[rsp]
	mov	r12d, DWORD PTR 104[rsp]
	add	r9d, edi
	sar	r9d, 16
	sar	edi, 16
	mov	DWORD PTR 32[rsp], r9d
	mov	DWORD PTR [rsp], edi
	add	edx, esi
	add	r12d, eax
	sar	esi, 16
	sar	edx, 16
	sar	r12d, 16
	mov	DWORD PTR 16[rsp], esi
	mov	DWORD PTR 48[rsp], edx
	sar	eax, 16
	jmp	.L3026
	.p2align 4,,10
	.p2align 3
.L3016:
	mov	DWORD PTR [rsi], 32768
	jmp	.L3017
	.p2align 4,,10
	.p2align 3
.L3074:
	mov	r10d, DWORD PTR 4[rdi]
	test	r10d, r10d
	je	.L3021
	mov	esi, DWORD PTR 20[rdi]
	test	esi, esi
	jne	.L3022
.L3021:
	mov	r11, QWORD PTR 136[rsp]
	mov	eax, DWORD PTR 104[rsp]
	lea	edi, [rdx+r9]
	mov	esi, DWORD PTR 96[rsp]
	sar	edi, 16
	mov	r12d, DWORD PTR 8[r11]
	add	eax, r8d
	mov	DWORD PTR [rsp], edi
	add	esi, ecx
	sar	eax, 16
	sar	esi, 16
	test	r12d, r12d
	mov	DWORD PTR 16[rsp], esi
	jne	.L3075
.L3023:
	test	r10d, r10d
	je	.L3070
	mov	r11, QWORD PTR 136[rsp]
	mov	r10d, DWORD PTR 16[r11]
	test	r10d, r10d
	jne	.L3069
	jmp	.L3070
	.p2align 4,,10
	.p2align 3
.L3073:
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	cmovl	edx, eax
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	mov	ecx, edx
	lea	edi, -32[rdx]
	sar	ecx, 5
	movzx	ecx, cl
	sar	edi, 31
	test	dh, 96
	mov	ecx, DWORD PTR [rax+rcx*4]
	mov	r8d, ecx
	jne	.L3076
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	edx, 3
	neg	esi
	jmp	.L3033
	.p2align 4,,10
	.p2align 3
.L3027:
	mov	esi, DWORD PTR 96[rsp]
	mov	eax, DWORD PTR 104[rsp]
	lea	edi, [rdx+r9]
	sar	edi, 16
	add	esi, ecx
	add	eax, r8d
	mov	DWORD PTR [rsp], edi
	sar	esi, 16
	sar	eax, 16
	mov	DWORD PTR 16[rsp], esi
.L3069:
	sub	r8d, DWORD PTR 104[rsp]
	sub	ecx, DWORD PTR 96[rsp]
	sub	edx, r9d
	sar	edx, 16
	mov	DWORD PTR 32[rsp], edx
	mov	r12d, r8d
	sar	ecx, 16
	sar	r12d, 16
	mov	DWORD PTR 48[rsp], ecx
	jmp	.L3026
	.p2align 4,,10
	.p2align 3
.L3075:
	mov	r11d, DWORD PTR 20[r11]
	test	r11d, r11d
	jne	.L3069
	jmp	.L3023
	.p2align 4,,10
	.p2align 3
.L3022:
	mov	edi, DWORD PTR 32[rax]
	mov	esi, DWORD PTR 36[rax]
	mov	eax, DWORD PTR 40[rax]
	jmp	.L3068
.L3076:
	sal	edx, 3
	or	esi, -1
	jmp	.L3033
	.cfi_endproc
.LFE654:
	.size	tclod_1cycle_next, .-tclod_1cycle_next
	.p2align 4,,15
	.globl	render_spans_1cycle_complete
	.type	render_spans_1cycle_complete, @function
render_spans_1cycle_complete:
.LFB585:
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
	mov	ebx, edi
	sub	rsp, 616
	.cfi_def_cfa_offset 672
	mov	rax, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	test	ecx, ecx
	mov	DWORD PTR 364[rsp], ecx
	mov	DWORD PTR 348[rsp], esi
	mov	DWORD PTR 268[rsp], edx
	mov	DWORD PTR 432[rsp], edx
	mov	ecx, DWORD PTR [rax]
	mov	DWORD PTR 448[rsp], 7
	mov	DWORD PTR 464[rsp], 0
	mov	DWORD PTR 496[rsp], 0
	mov	DWORD PTR 512[rsp], 0
	mov	DWORD PTR 276[rsp], ecx
	je	.L3078
	mov	ecx, DWORD PTR 4[rax]
	mov	QWORD PTR 304[rsp], 1
	mov	DWORD PTR 300[rsp], 1
	mov	DWORD PTR 280[rsp], ecx
	mov	ecx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 284[rsp], ecx
	mov	DWORD PTR 288[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rax]
	mov	DWORD PTR 80[rsp], ecx
	mov	ecx, DWORD PTR 4[rax]
	mov	DWORD PTR 84[rsp], ecx
	mov	ecx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR 88[rsp], ecx
	mov	DWORD PTR 272[rsp], eax
.L3079:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r14d, DWORD PTR 132[rax]
	test	r14d, r14d
	jne	.L3080
	mov	rax, QWORD PTR spans_dzpix@GOTPCREL[rip]
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 296[rsp], eax
	mov	edi, eax
.L3081:
	call	dz_compress@PLT
	cmp	ebx, DWORD PTR 348[rsp]
	mov	DWORD PTR 292[rsp], eax
	jg	.L3077
	shr	eax, 2
	mov	ecx, DWORD PTR 88[rsp]
	mov	DWORD PTR 368[rsp], eax
	lea	eax, 1[rbx]
	mov	DWORD PTR 336[rsp], eax
	mov	eax, DWORD PTR 268[rsp]
	lea	edi, [rcx+rcx]
	mov	ecx, DWORD PTR 80[rsp]
	mov	DWORD PTR 352[rsp], edi
	mov	DWORD PTR 340[rsp], eax
	lea	rax, 532[rsp]
	lea	edi, [rcx+rcx]
	mov	ecx, DWORD PTR 84[rsp]
	mov	QWORD PTR 120[rsp], rax
	lea	rax, 528[rsp]
	mov	DWORD PTR 356[rsp], edi
	mov	QWORD PTR 128[rsp], rax
	lea	rax, 536[rsp]
	lea	edi, [rcx+rcx]
	mov	QWORD PTR 312[rsp], rax
	lea	rax, 576[rsp]
	mov	DWORD PTR 360[rsp], edi
	mov	QWORD PTR 320[rsp], rax
	.p2align 4,,10
	.p2align 3
.L3139:
	mov	eax, DWORD PTR 336[rsp]
	sub	eax, 1
	mov	DWORD PTR 168[rsp], eax
	cdqe
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	r13d, DWORD PTR 12[rax]
	test	r13d, r13d
	je	.L3182
	mov	ecx, DWORD PTR 4[rax]
	mov	esi, DWORD PTR 28[rax]
	mov	edx, DWORD PTR [rax]
	mov	ebx, DWORD PTR 8[rax]
	mov	DWORD PTR 172[rsp], ecx
	mov	ecx, DWORD PTR 16[rax]
	mov	DWORD PTR 104[rsp], esi
	mov	esi, DWORD PTR 36[rax]
	mov	DWORD PTR 92[rsp], ecx
	mov	ecx, DWORD PTR 20[rax]
	mov	DWORD PTR 180[rsp], esi
	mov	rsi, QWORD PTR other_modes@GOTPCREL[rip]
	mov	DWORD PTR 96[rsp], ecx
	mov	ecx, DWORD PTR 24[rax]
	mov	r12d, DWORD PTR 132[rsi]
	mov	DWORD PTR 100[rsp], ecx
	mov	ecx, DWORD PTR 32[rax]
	test	r12d, r12d
	mov	DWORD PTR 176[rsp], ecx
	mov	ecx, DWORD PTR 40[rax]
	mov	DWORD PTR 184[rsp], ecx
	jne	.L3085
	mov	eax, DWORD PTR 44[rax]
	mov	DWORD PTR 108[rsp], eax
.L3086:
	mov	rax, QWORD PTR fb_width@GOTPCREL[rip]
	mov	ecx, DWORD PTR 168[rsp]
	mov	ebp, DWORD PTR 364[rsp]
	imul	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 172[rsp]
	add	eax, ecx
	mov	ecx, eax
	mov	DWORD PTR 196[rsp], eax
	mov	rax, QWORD PTR zb_address@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	lea	eax, [rax+rcx*2]
	mov	r13d, eax
	and	r13d, 16777215
	shr	r13
	test	ebp, ebp
	jne	.L3087
	mov	ecx, DWORD PTR 172[rsp]
	mov	edi, DWORD PTR 168[rsp]
	mov	eax, ecx
	sub	ebx, ecx
	sub	eax, edx
	mov	DWORD PTR 64[rsp], eax
	call	compute_cvg_noflip@PLT
.L3088:
	mov	edx, DWORD PTR 64[rsp]
	xor	eax, eax
	cmp	edx, 7
	setg	al
	mov	DWORD PTR 596[rsp], eax
	xor	eax, eax
	cmp	edx, 7
	sete	al
	mov	DWORD PTR 592[rsp], eax
	xor	eax, eax
	cmp	edx, 6
	sete	al
	test	ebx, ebx
	mov	DWORD PTR 600[rsp], eax
	je	.L3089
	mov	eax, DWORD PTR 276[rsp]
	imul	eax, ebx
	add	DWORD PTR 92[rsp], eax
	mov	eax, DWORD PTR 280[rsp]
	imul	eax, ebx
	add	DWORD PTR 96[rsp], eax
	mov	eax, DWORD PTR 284[rsp]
	imul	eax, ebx
	add	DWORD PTR 100[rsp], eax
	mov	eax, DWORD PTR 288[rsp]
	imul	eax, ebx
	add	DWORD PTR 104[rsp], eax
	mov	eax, DWORD PTR 272[rsp]
	imul	eax, ebx
	add	DWORD PTR 108[rsp], eax
	mov	eax, DWORD PTR 80[rsp]
	imul	eax, ebx
	add	DWORD PTR 176[rsp], eax
	mov	eax, DWORD PTR 84[rsp]
	imul	eax, ebx
	add	DWORD PTR 180[rsp], eax
	imul	ebx, DWORD PTR 88[rsp]
	add	DWORD PTR 184[rsp], ebx
.L3089:
	mov	r11d, DWORD PTR 64[rsp]
	mov	DWORD PTR 576[rsp], 1
	test	r11d, r11d
	js	.L3182
	mov	eax, DWORD PTR 64[rsp]
	mov	r15d, DWORD PTR 88[rsp]
	xor	r12d, r12d
	add	r15d, DWORD PTR 184[rsp]
	mov	r14d, DWORD PTR 80[rsp]
	add	r14d, DWORD PTR 176[rsp]
	mov	ebp, DWORD PTR 172[rsp]
	lea	ebx, -1[rax]
	sub	eax, 2
	mov	DWORD PTR 76[rsp], 0
	mov	DWORD PTR 204[rsp], eax
	movsx	rax, DWORD PTR 336[rsp]
	mov	DWORD PTR 200[rsp], ebx
	mov	ebx, DWORD PTR 84[rsp]
	add	ebx, DWORD PTR 180[rsp]
	mov	DWORD PTR 72[rsp], 0
	mov	DWORD PTR 68[rsp], 0
	mov	DWORD PTR 344[rsp], eax
	lea	rax, [rax+rax*2]
	mov	DWORD PTR 60[rsp], ebx
	lea	rbx, 432[rsp]
	mov	QWORD PTR 328[rsp], rax
	mov	eax, r15d
	sal	QWORD PTR 328[rsp], 5
	mov	r15d, r14d
	mov	QWORD PTR 240[rsp], rbx
	lea	rbx, 480[rsp]
	mov	r14d, eax
	mov	QWORD PTR 208[rsp], rbx
	lea	rbx, 464[rsp]
	mov	QWORD PTR 256[rsp], rbx
	lea	rbx, 448[rsp]
	mov	QWORD PTR 248[rsp], rbx
	lea	rbx, 416[rsp]
	mov	QWORD PTR 112[rsp], rbx
	lea	rbx, 524[rsp]
	mov	QWORD PTR 216[rsp], rbx
	lea	rbx, 400[rsp]
	mov	QWORD PTR 232[rsp], rbx
	lea	rbx, 384[rsp]
	mov	QWORD PTR 224[rsp], rbx
	jmp	.L3137
	.p2align 4,,10
	.p2align 3
.L3184:
	mov	r10d, DWORD PTR 596[rsp]
	test	r10d, r10d
	je	.L3091
	mov	rax, QWORD PTR 328[rsp]
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	r9d, DWORD PTR 12[rax]
	test	r9d, r9d
	je	.L3091
	movsx	edi, WORD PTR 34[rax]
	movsx	esi, WORD PTR 38[rax]
	movsx	edx, WORD PTR 42[rax]
.L3093:
	mov	r8, QWORD PTR 120[rsp]
	mov	rcx, QWORD PTR 128[rsp]
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r8d, DWORD PTR 576[rsp]
	test	r8d, r8d
	jne	.L3094
	mov	rax, QWORD PTR texel1_color@GOTPCREL[rip]
	mov	rcx, QWORD PTR texel0_color@GOTPCREL[rip]
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rcx], rax
	mov	eax, DWORD PTR 536[rsp]
	mov	QWORD PTR 8[rcx], rdx
	mov	DWORD PTR lod_frac[rip], eax
.L3095:
	mov	eax, DWORD PTR 580[rsp]
	mov	ebx, DWORD PTR 168[rsp]
	mov	r8d, r14d
	mov	r9d, DWORD PTR 80[rsp]
	mov	ecx, DWORD PTR 60[rsp]
	mov	edx, r15d
	mov	rsi, QWORD PTR 120[rsp]
	mov	rdi, QWORD PTR 128[rsp]
	mov	DWORD PTR 588[rsp], eax
	mov	eax, DWORD PTR 584[rsp]
	mov	DWORD PTR 16[rsp], ebx
	mov	DWORD PTR 580[rsp], eax
	xor	eax, eax
	cmp	r12d, DWORD PTR 204[rsp]
	sete	al
	mov	DWORD PTR 584[rsp], eax
	mov	rax, QWORD PTR 312[rsp]
	mov	QWORD PTR 48[rsp], rax
	mov	rax, QWORD PTR 320[rsp]
	mov	QWORD PTR 40[rsp], rax
	mov	rax, QWORD PTR 240[rsp]
	mov	QWORD PTR 32[rsp], rax
	mov	eax, DWORD PTR 268[rsp]
	mov	DWORD PTR 24[rsp], eax
	mov	eax, DWORD PTR 88[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	eax, DWORD PTR 84[rsp]
	mov	DWORD PTR [rsp], eax
	call	tclod_1cycle_next@PLT
	mov	rsi, QWORD PTR texel1_color@GOTPCREL[rip]
	mov	r8d, DWORD PTR 432[rsp]
	xor	r9d, r9d
	mov	ecx, DWORD PTR 532[rsp]
	mov	edx, DWORD PTR 528[rsp]
	mov	rdi, rsi
	call	texture_pipeline_cycle@PLT
	mov	eax, DWORD PTR 416[rsp]
	movzx	esi, BYTE PTR 266[rsp]
	movzx	edi, BYTE PTR 164[rsp]
	mov	r9d, DWORD PTR 152[rsp]
	mov	r8d, DWORD PTR 144[rsp]
	mov	ecx, DWORD PTR 136[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	rax, QWORD PTR 208[rsp]
	mov	edx, DWORD PTR 160[rsp]
	mov	QWORD PTR [rsp], rax
	call	rgbaz_correct_clip@PLT
	mov	rcx, QWORD PTR 256[rsp]
	mov	rdx, QWORD PTR 248[rsp]
	mov	esi, ebx
	mov	edi, ebp
	call	[QWORD PTR get_dither_noise_ptr[rip]]
	mov	rsi, QWORD PTR 112[rsp]
	mov	edi, DWORD PTR 464[rsp]
	call	combiner_1cycle@PLT
	mov	ebx, DWORD PTR 196[rsp]
	sub	ebx, DWORD PTR 172[rsp]
	mov	rdx, QWORD PTR fbread1_ptr@GOTPCREL[rip]
	mov	rsi, QWORD PTR 216[rsp]
	add	ebx, ebp
	mov	edi, ebx
	call	[QWORD PTR [rdx]]
	mov	eax, DWORD PTR 524[rsp]
	mov	r9, QWORD PTR 232[rsp]
	mov	edi, r13d
	mov	r8, QWORD PTR 224[rsp]
	mov	ecx, DWORD PTR 292[rsp]
	mov	edx, DWORD PTR 296[rsp]
	mov	esi, DWORD PTR 480[rsp]
	mov	DWORD PTR 8[rsp], eax
	mov	rax, QWORD PTR 112[rsp]
	mov	DWORD PTR 160[rsp], r13d
	mov	QWORD PTR [rsp], rax
	call	z_compare@PLT
	test	eax, eax
	jne	.L3183
.L3121:
	add	r13, QWORD PTR 304[rsp]
	mov	eax, DWORD PTR 276[rsp]
	add	r12d, 1
	add	DWORD PTR 92[rsp], eax
	mov	ecx, DWORD PTR 80[rsp]
	mov	eax, DWORD PTR 280[rsp]
	add	DWORD PTR 96[rsp], eax
	mov	eax, DWORD PTR 284[rsp]
	add	DWORD PTR 100[rsp], eax
	mov	eax, DWORD PTR 288[rsp]
	and	r13d, 8388607
	add	r15d, ecx
	add	DWORD PTR 104[rsp], eax
	mov	eax, DWORD PTR 272[rsp]
	add	DWORD PTR 108[rsp], eax
	mov	eax, DWORD PTR 88[rsp]
	mov	edi, DWORD PTR 84[rsp]
	add	ebp, DWORD PTR 300[rsp]
	add	DWORD PTR 68[rsp], eax
	add	r14d, eax
	add	DWORD PTR 72[rsp], ecx
	add	DWORD PTR 76[rsp], edi
	add	DWORD PTR 60[rsp], edi
	cmp	DWORD PTR 64[rsp], r12d
	jl	.L3084
.L3137:
	mov	eax, DWORD PTR 76[rsp]
	add	eax, DWORD PTR 180[rsp]
	xor	edx, edx
	mov	ebx, DWORD PTR 72[rsp]
	add	ebx, DWORD PTR 176[rsp]
	mov	rcx, QWORD PTR cvgbuf@GOTPCREL[rip]
	mov	DWORD PTR 188[rsp], eax
	mov	eax, DWORD PTR 68[rsp]
	add	eax, DWORD PTR 184[rsp]
	mov	DWORD PTR 192[rsp], eax
	mov	eax, DWORD PTR 92[rsp]
	sar	eax, 14
	mov	DWORD PTR 160[rsp], eax
	mov	eax, DWORD PTR 96[rsp]
	sar	eax, 14
	mov	DWORD PTR 136[rsp], eax
	mov	eax, DWORD PTR 100[rsp]
	sar	eax, 14
	mov	DWORD PTR 144[rsp], eax
	mov	eax, DWORD PTR 104[rsp]
	sar	eax, 14
	mov	DWORD PTR 152[rsp], eax
	mov	eax, DWORD PTR 108[rsp]
	shr	eax, 10
	cmp	r12d, DWORD PTR 64[rsp]
	mov	DWORD PTR 480[rsp], eax
	sete	dl
	xor	eax, eax
	cmp	r12d, DWORD PTR 200[rsp]
	mov	DWORD PTR 580[rsp], edx
	sete	al
	test	edx, edx
	mov	DWORD PTR 584[rsp], eax
	movsx	rax, ebp
	movzx	eax, BYTE PTR [rcx+rax]
	mov	rcx, QWORD PTR cvarray@GOTPCREL[rip]
	lea	rax, [rcx+rax*4]
	movzx	esi, BYTE PTR 1[rax]
	movzx	ecx, BYTE PTR 2[rax]
	mov	BYTE PTR 267[rsp], sil
	movzx	esi, BYTE PTR 3[rax]
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR 164[rsp], cl
	mov	BYTE PTR 266[rsp], sil
	mov	DWORD PTR 416[rsp], eax
	jne	.L3184
.L3091:
	mov	esi, DWORD PTR 60[rsp]
	mov	edx, r14d
	mov	edi, r15d
	sar	edx, 16
	sar	edi, 16
	sar	esi, 16
	jmp	.L3093
	.p2align 4,,10
	.p2align 3
.L3183:
	mov	r11, QWORD PTR other_modes@GOTPCREL[rip]
	mov	rax, QWORD PTR pixel_color@GOTPCREL[rip]
	mov	edx, DWORD PTR 416[rsp]
	mov	edi, DWORD PTR 400[rsp]
	mov	esi, DWORD PTR 384[rsp]
	mov	ecx, DWORD PTR 448[rsp]
	mov	r9d, DWORD PTR 140[r11]
	mov	eax, DWORD PTR 12[rax]
	test	r9d, r9d
	jne	.L3122
.L3127:
	mov	r10, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r8d, DWORD PTR 128[r10]
	test	r8d, r8d
	je	.L3185
	test	edx, edx
	setne	dl
.L3129:
	test	dl, dl
	je	.L3121
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r8d, DWORD PTR 112[rdx]
	test	r8d, r8d
	je	.L3130
	test	edi, edi
	jne	.L3130
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 540[rsp], eax
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 544[rsp], eax
	mov	rax, QWORD PTR blender2a_b@GOTPCREL[rip]
.L3181:
	mov	rax, QWORD PTR [rax]
	lea	r8, 560[rsp]
	lea	r9, 544[rsp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 560[rsp], eax
	lea	rax, 540[rsp]
.L3135:
	mov	rdx, r8
	mov	rsi, r9
	mov	rdi, rax
	call	[QWORD PTR rgb_dither_ptr[rip]]
	mov	eax, DWORD PTR 524[rsp]
	mov	r9d, DWORD PTR 416[rsp]
	mov	edi, ebx
	mov	r8d, DWORD PTR 384[rsp]
	mov	ecx, DWORD PTR 560[rsp]
	mov	edx, DWORD PTR 544[rsp]
	mov	esi, DWORD PTR 540[rsp]
	mov	DWORD PTR [rsp], eax
	mov	rax, QWORD PTR fbwrite_ptr@GOTPCREL[rip]
	call	[QWORD PTR [rax]]
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 120[rax]
	test	eax, eax
	je	.L3121
	mov	edx, DWORD PTR 480[rsp]
	mov	rax, QWORD PTR z_com_table@GOTPCREL[rip]
	mov	ebx, DWORD PTR 160[rsp]
	and	edx, 262143
	movzx	edx, WORD PTR [rax+rdx*2]
	mov	rax, QWORD PTR idxlim16@GOTPCREL[rip]
	cmp	ebx, DWORD PTR [rax]
	ja	.L3121
	mov	rax, QWORD PTR rdram_16@GOTPCREL[rip]
	or	dx, WORD PTR 368[rsp]
	mov	ecx, ebx
	xor	ecx, 1
	mov	rax, QWORD PTR [rax]
	mov	WORD PTR [rax+rcx*2], dx
	movzx	edx, BYTE PTR 292[rsp]
	mov	eax, ebx
	mov	rcx, QWORD PTR hidden_bits@GOTPCREL[rip]
	and	edx, 3
	mov	BYTE PTR [rcx+rax], dl
	jmp	.L3121
	.p2align 4,,10
	.p2align 3
.L3094:
	mov	edx, DWORD PTR 192[rsp]
	mov	esi, DWORD PTR 188[rsp]
	sar	ebx, 16
	mov	edi, ebx
	lea	rcx, 496[rsp]
	lea	r8, 512[rsp]
	sar	esi, 16
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	eax, DWORD PTR 496[rsp]
	mov	ebx, DWORD PTR 532[rsp]
	mov	r10d, DWORD PTR 528[rsp]
	mov	esi, DWORD PTR 512[rsp]
	test	eax, 262144
	jne	.L3096
	test	eax, 131072
	jne	.L3097
	mov	edx, eax
	and	edx, 98304
	cmp	edx, 32768
	je	.L3096
	cmp	edx, 65536
	je	.L3097
	and	eax, 65535
	mov	DWORD PTR 496[rsp], eax
.L3098:
	test	esi, 262144
	jne	.L3099
.L3187:
	test	esi, 131072
	jne	.L3100
	mov	eax, esi
	and	eax, 98304
	cmp	eax, 32768
	je	.L3099
	cmp	eax, 65536
	je	.L3100
	movzx	esi, si
	mov	DWORD PTR 512[rsp], esi
	.p2align 4,,10
	.p2align 3
.L3101:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edi, DWORD PTR 148[rax]
	test	edi, edi
	je	.L3119
	mov	rax, QWORD PTR 328[rsp]
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	esi, DWORD PTR 12[rax]
	test	esi, esi
	je	.L3103
	mov	edx, DWORD PTR 580[rsp]
	test	edx, edx
	je	.L3104
	mov	ecx, DWORD PTR 596[rsp]
	test	ecx, ecx
	je	.L3104
	mov	edi, DWORD PTR 80[rsp]
	mov	esi, DWORD PTR 84[rsp]
	add	edi, DWORD PTR 32[rax]
	add	esi, DWORD PTR 36[rax]
	mov	edx, DWORD PTR 88[rsp]
	add	edx, DWORD PTR 40[rax]
	sar	edi, 16
	sar	esi, 16
	mov	DWORD PTR 544[rsp], edi
	mov	DWORD PTR 560[rsp], esi
	sar	edx, 16
	.p2align 4,,10
	.p2align 3
.L3109:
	lea	r9, 544[rsp]
	mov	DWORD PTR 188[rsp], r10d
	lea	r8, 560[rsp]
	mov	rcx, r9
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	edi, DWORD PTR 560[rsp]
	mov	esi, DWORD PTR 544[rsp]
	mov	r8d, ebx
	mov	r10d, DWORD PTR 188[rsp]
	sal	r8d, 15
	sar	r8d, 15
	mov	edx, esi
	mov	eax, edi
	mov	ecx, r10d
	sal	edx, 15
	sal	eax, 15
	sal	ecx, 15
	sar	eax, 15
	sar	edx, 15
	sar	ecx, 15
	sub	eax, r8d
	sub	edx, ecx
	jns	.L3110
	not	edx
	and	edx, 131071
.L3110:
	test	eax, 131072
	je	.L3111
	not	eax
	and	eax, 131071
.L3111:
	xor	ecx, ecx
	test	edx, edx
	cmovns	ecx, edx
	cmp	ecx, eax
	cmovge	eax, ecx
	mov	edx, eax
	and	edx, 32767
	mov	ecx, edx
	or	ch, 64
	test	eax, 114688
	cmovne	edx, ecx
	test	dh, 64
	jne	.L3113
	or	ebx, r10d
	or	ebx, edi
	or	ebx, esi
	sar	ebx, 17
	mov	eax, ebx
	shr	eax
	or	eax, ebx
	test	al, 1
	jne	.L3113
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	r11d, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, r11d
	cmovge	r11d, edx
	mov	edx, r11d
	lea	r9d, -32[r11]
	sar	edx, 5
	movzx	edx, dl
	sar	r9d, 31
	test	r11d, 24576
	mov	ecx, DWORD PTR [rax+rdx*4]
	mov	edi, ecx
	jne	.L3186
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	esi, esi
	mov	r10d, r9d
	cmp	ecx, DWORD PTR [rax]
	setae	sil
	sal	r11d, 3
	and	r9d, 1
	neg	esi
	mov	r8d, esi
	and	r8d, 1
.L3115:
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	sar	r11d, cl
	mov	eax, r11d
	mov	ecx, DWORD PTR 8[rbx]
	mov	edx, DWORD PTR 12[rbx]
	mov	ebx, ecx
	or	ebx, edx
	jne	.L3116
	mov	eax, r10d
	not	eax
	and	eax, r11d
	or	eax, esi
.L3116:
	and	edx, r10d
	movzx	eax, al
	sal	edx, 8
	or	eax, edx
	movzx	eax, ax
	mov	DWORD PTR lod_frac[rip], eax
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	r10d, DWORD PTR 16[rax]
	test	r10d, r10d
	je	.L3180
	test	r8d, r8d
	je	.L3118
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	edi, DWORD PTR [rax]
.L3118:
	not	r9d
	and	r9d, ecx
	add	r9d, DWORD PTR 268[rsp]
	lea	eax, [r9+rdi]
	mov	DWORD PTR 340[rsp], eax
	and	DWORD PTR 340[rsp], 7
.L3180:
	mov	esi, DWORD PTR 512[rsp]
.L3119:
	mov	edx, DWORD PTR 340[rsp]
	mov	edi, DWORD PTR 496[rsp]
	call	texture_pipeline_cycle.constprop.9
	mov	DWORD PTR 576[rsp], 0
	jmp	.L3095
	.p2align 4,,10
	.p2align 3
.L3182:
	mov	eax, DWORD PTR 336[rsp]
	mov	DWORD PTR 344[rsp], eax
.L3084:
	add	DWORD PTR 336[rsp], 1
	mov	eax, DWORD PTR 344[rsp]
	cmp	DWORD PTR 348[rsp], eax
	jge	.L3139
.L3077:
	add	rsp, 616
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
.L3096:
	.cfi_restore_state
	test	esi, 262144
	mov	DWORD PTR 496[rsp], 32767
	je	.L3187
.L3099:
	mov	DWORD PTR 512[rsp], 32767
	mov	esi, 32767
	jmp	.L3101
	.p2align 4,,10
	.p2align 3
.L3113:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r9d, r9d
	mov	r8d, 1
	xor	r10d, r10d
	mov	r11d, 262136
	mov	esi, -1
	mov	ecx, DWORD PTR 1020[rax]
	mov	edi, ecx
	jmp	.L3115
	.p2align 4,,10
	.p2align 3
.L3106:
	test	edx, edx
	je	.L3103
	mov	r11d, DWORD PTR 592[rsp]
	test	r11d, r11d
	jne	.L3107
	.p2align 4,,10
	.p2align 3
.L3103:
	mov	edi, DWORD PTR 176[rsp]
	mov	esi, DWORD PTR 180[rsp]
	add	edi, DWORD PTR 356[rsp]
	add	esi, DWORD PTR 360[rsp]
	mov	edx, DWORD PTR 184[rsp]
	add	edi, DWORD PTR 72[rsp]
	add	edx, DWORD PTR 352[rsp]
	add	esi, DWORD PTR 76[rsp]
	add	edx, DWORD PTR 68[rsp]
	sar	edi, 16
	sar	esi, 16
	mov	DWORD PTR 544[rsp], edi
	sar	edx, 16
	mov	DWORD PTR 560[rsp], esi
	jmp	.L3109
	.p2align 4,,10
	.p2align 3
.L3185:
	cmp	BYTE PTR 267[rsp], 0
	setne	dl
	jmp	.L3129
	.p2align 4,,10
	.p2align 3
.L3097:
	mov	DWORD PTR 496[rsp], 32768
	jmp	.L3098
	.p2align 4,,10
	.p2align 3
.L3122:
	mov	r11d, DWORD PTR 136[r11]
	test	r11d, r11d
	jne	.L3125
	mov	r8, QWORD PTR blend_color@GOTPCREL[rip]
	mov	r8d, DWORD PTR 12[r8]
.L3126:
	cmp	eax, r8d
	jl	.L3121
	jmp	.L3127
	.p2align 4,,10
	.p2align 3
.L3130:
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edx, DWORD PTR 152[rdx]
	test	edx, edx
	je	.L3132
	cmp	eax, 254
	jg	.L3133
.L3132:
	test	esi, esi
	jne	.L3134
.L3133:
	mov	rax, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 540[rsp], eax
	mov	rax, QWORD PTR blender1a_g@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 544[rsp], eax
	mov	rax, QWORD PTR blender1a_b@GOTPCREL[rip]
	jmp	.L3181
	.p2align 4,,10
	.p2align 3
.L3100:
	mov	DWORD PTR 512[rsp], 32768
	mov	esi, 32768
	jmp	.L3101
	.p2align 4,,10
	.p2align 3
.L3104:
	mov	eax, DWORD PTR 584[rsp]
	test	eax, eax
	je	.L3106
	mov	eax, DWORD PTR 596[rsp]
	test	eax, eax
	je	.L3106
.L3107:
	mov	edi, DWORD PTR 176[rsp]
	mov	esi, DWORD PTR 180[rsp]
	sub	edi, DWORD PTR 80[rsp]
	sub	esi, DWORD PTR 84[rsp]
	mov	edx, DWORD PTR 184[rsp]
	add	edi, DWORD PTR 72[rsp]
	sub	edx, DWORD PTR 88[rsp]
	add	esi, DWORD PTR 76[rsp]
	add	edx, DWORD PTR 68[rsp]
	sar	edi, 16
	sar	esi, 16
	mov	DWORD PTR 544[rsp], edi
	sar	edx, 16
	mov	DWORD PTR 560[rsp], esi
	jmp	.L3109
	.p2align 4,,10
	.p2align 3
.L3087:
	mov	eax, DWORD PTR 172[rsp]
	mov	edi, DWORD PTR 168[rsp]
	sub	edx, eax
	sub	eax, ebx
	mov	DWORD PTR 64[rsp], edx
	mov	ebx, eax
	call	compute_cvg_flip@PLT
	jmp	.L3088
	.p2align 4,,10
	.p2align 3
.L3085:
	mov	rax, QWORD PTR primitive_z@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 108[rsp], eax
	jmp	.L3086
	.p2align 4,,10
	.p2align 3
.L3125:
	mov	r9, QWORD PTR iseed@GOTPCREL[rip]
	mov	r10d, DWORD PTR [r9]
	imul	r8d, r10d, 214013
	add	r8d, 2531011
	mov	DWORD PTR [r9], r8d
	sar	r8d, 16
	movzx	r8d, r8b
	jmp	.L3126
	.p2align 4,,10
	.p2align 3
.L3134:
	mov	rax, QWORD PTR blender1b_a@GOTPCREL[rip]
	mov	rdx, QWORD PTR inv_pixel_color@GOTPCREL[rip]
	lea	r8, 560[rsp]
	lea	r9, 544[rsp]
	mov	DWORD PTR 164[rsp], ecx
	mov	QWORD PTR 152[rsp], r8
	mov	rax, QWORD PTR [rax]
	mov	rsi, r9
	mov	QWORD PTR 144[rsp], r9
	mov	eax, DWORD PTR [rax]
	not	eax
	and	eax, 255
	mov	DWORD PTR 12[rdx], eax
	lea	rax, 540[rsp]
	mov	rdx, r8
	mov	rdi, rax
	mov	QWORD PTR 136[rsp], rax
	call	blender_equation_cycle0@PLT
	mov	rax, QWORD PTR 136[rsp]
	mov	r9, QWORD PTR 144[rsp]
	mov	r8, QWORD PTR 152[rsp]
	mov	ecx, DWORD PTR 164[rsp]
	jmp	.L3135
.L3080:
	mov	rax, QWORD PTR primitive_delta_z@GOTPCREL[rip]
	mov	DWORD PTR 272[rsp], 0
	movzx	eax, WORD PTR [rax]
	mov	DWORD PTR 296[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	edi, DWORD PTR 296[rsp]
	mov	DWORD PTR 12[rax], 0
	mov	rax, QWORD PTR spans_cdz@GOTPCREL[rip]
	mov	DWORD PTR [rax], 0
	jmp	.L3081
.L3078:
	mov	ecx, DWORD PTR 4[rax]
	neg	DWORD PTR 276[rsp]
	mov	DWORD PTR 280[rsp], ecx
	mov	ecx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 280[rsp]
	mov	DWORD PTR 284[rsp], ecx
	neg	DWORD PTR 284[rsp]
	mov	DWORD PTR 288[rsp], eax
	mov	rax, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	neg	DWORD PTR 288[rsp]
	mov	ecx, DWORD PTR [rax]
	mov	DWORD PTR 80[rsp], ecx
	mov	ecx, DWORD PTR 4[rax]
	neg	DWORD PTR 80[rsp]
	mov	DWORD PTR 84[rsp], ecx
	mov	ecx, DWORD PTR 8[rax]
	mov	eax, DWORD PTR 12[rax]
	neg	DWORD PTR 84[rsp]
	mov	DWORD PTR 88[rsp], ecx
	neg	DWORD PTR 88[rsp]
	mov	DWORD PTR 272[rsp], eax
	mov	rax, -1
	neg	DWORD PTR 272[rsp]
	mov	QWORD PTR 304[rsp], rax
	mov	DWORD PTR 300[rsp], eax
	jmp	.L3079
.L3186:
	mov	r10d, r9d
	sal	r11d, 3
	and	r9d, 1
	mov	r8d, 1
	mov	esi, -1
	jmp	.L3115
	.cfi_endproc
.LFE585:
	.size	render_spans_1cycle_complete, .-render_spans_1cycle_complete
	.p2align 4,,15
	.globl	tclod_copy
	.type	tclod_copy, @function
tclod_copy:
.LFB655:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	ebp, r8d
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	sub	rsp, 72
	.cfi_def_cfa_offset 96
	mov	eax, DWORD PTR [rdi]
	mov	r10d, DWORD PTR [rsi]
	test	eax, 262144
	jne	.L3189
	test	eax, 131072
	jne	.L3190
	mov	r8d, eax
	and	r8d, 98304
	cmp	r8d, 32768
	je	.L3189
	cmp	r8d, 65536
	je	.L3190
	and	eax, 65535
	test	r10d, 262144
	mov	DWORD PTR [rdi], eax
	je	.L3226
	.p2align 4,,10
	.p2align 3
.L3192:
	mov	DWORD PTR [rsi], 32767
.L3194:
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 16[rbx]
	test	eax, eax
	jne	.L3227
.L3188:
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L3189:
	.cfi_restore_state
	mov	DWORD PTR [rdi], 32767
.L3191:
	test	r10d, 262144
	jne	.L3192
.L3226:
	test	r10d, 131072
	jne	.L3193
	and	r10d, 98304
	cmp	r10d, 32768
	je	.L3192
	cmp	r10d, 65536
	je	.L3193
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	and	DWORD PTR [rsi], 65535
	mov	eax, DWORD PTR 16[rbx]
	test	eax, eax
	je	.L3188
	.p2align 4,,10
	.p2align 3
.L3227:
	lea	eax, [rdx+r9*2]
	mov	esi, DWORD PTR 96[rsp]
	lea	edi, [rdx+r9]
	mov	edx, DWORD PTR 104[rsp]
	lea	r8, 16[rsp]
	sar	eax, 16
	sar	edi, 16
	mov	DWORD PTR 32[rsp], eax
	mov	eax, DWORD PTR 96[rsp]
	add	esi, ecx
	sar	esi, 16
	add	edx, ebp
	mov	DWORD PTR [rsp], edi
	sar	edx, 16
	mov	DWORD PTR 16[rsp], esi
	lea	eax, [rcx+rax*2]
	mov	rcx, rsp
	sar	eax, 16
	mov	DWORD PTR 48[rsp], eax
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	eax, DWORD PTR 104[rsp]
	lea	rcx, 32[rsp]
	lea	r8, 48[rsp]
	mov	esi, DWORD PTR 48[rsp]
	mov	edi, DWORD PTR 32[rsp]
	lea	edx, 0[rbp+rax*2]
	sar	edx, 16
	call	[QWORD PTR tcdiv_ptr[rip]]
	mov	r9d, DWORD PTR 48[rsp]
	mov	r10d, DWORD PTR 16[rsp]
	mov	r8d, DWORD PTR 32[rsp]
	mov	edi, DWORD PTR [rsp]
	mov	eax, r9d
	mov	esi, r10d
	mov	ecx, r8d
	mov	edx, edi
	sal	eax, 15
	sal	ecx, 15
	sal	edx, 15
	sal	esi, 15
	sar	eax, 15
	sar	esi, 15
	sar	ecx, 15
	sar	edx, 15
	sub	eax, esi
	sub	ecx, edx
	jns	.L3196
	not	ecx
	and	ecx, 131071
.L3196:
	test	eax, 131072
	je	.L3197
	not	eax
	and	eax, 131071
.L3197:
	xor	edx, edx
	test	ecx, ecx
	cmovns	edx, ecx
	cmp	edx, eax
	cmovge	eax, edx
	mov	edx, eax
	mov	ecx, eax
	and	edx, 32767
	mov	eax, edx
	or	ah, 64
	and	ecx, 114688
	cmovne	edx, eax
	test	dh, 64
	jne	.L3199
	mov	eax, r10d
	or	eax, r9d
	or	eax, r8d
	or	eax, edi
	sar	eax, 17
	mov	ecx, eax
	shr	ecx
	or	ecx, eax
	and	ecx, 1
	jne	.L3199
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	edx, ecx
	cmovge	ecx, edx
	lea	edx, -32[rcx]
	mov	esi, ecx
	sar	esi, 5
	shr	edx, 31
	movzx	esi, sil
	and	ch, 96
	mov	eax, DWORD PTR [rax+rsi*4]
	jne	.L3228
	mov	rcx, QWORD PTR max_level@GOTPCREL[rip]
	not	edx
	mov	ecx, DWORD PTR [rcx]
	cmp	eax, ecx
	cmovae	eax, ecx
	jmp	.L3204
	.p2align 4,,10
	.p2align 3
.L3190:
	mov	DWORD PTR [rdi], 32768
	jmp	.L3191
	.p2align 4,,10
	.p2align 3
.L3193:
	mov	DWORD PTR [rsi], 32768
	jmp	.L3194
	.p2align 4,,10
	.p2align 3
.L3199:
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	mov	edx, -1
	mov	eax, DWORD PTR [rax]
.L3204:
	and	edx, DWORD PTR 8[rbx]
	add	eax, DWORD PTR 112[rsp]
	add	eax, edx
	mov	rdx, QWORD PTR 120[rsp]
	and	eax, 7
	mov	DWORD PTR [rdx], eax
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.L3228:
	.cfi_restore_state
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	not	edx
	mov	eax, DWORD PTR [rax]
	jmp	.L3204
	.cfi_endproc
.LFE655:
	.size	tclod_copy, .-tclod_copy
	.p2align 4,,15
	.globl	get_texel1_1cycle
	.type	get_texel1_1cycle, @function
get_texel1_1cycle:
.LFB656:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	r10, QWORD PTR 40[rsp]
	mov	r11, rdi
	mov	rbx, rsi
	mov	eax, DWORD PTR 24[rsp]
	mov	esi, DWORD PTR 16[rsp]
	mov	edi, DWORD PTR 32[rsp]
	cmp	DWORD PTR 4[r10], 0
	je	.L3230
	mov	r10d, DWORD PTR 20[r10]
	test	r10d, r10d
	je	.L3230
	add	edi, 1
	movsx	rdi, edi
	lea	r10, [rdi+rdi*2]
	sal	r10, 5
	add	r10, QWORD PTR span@GOTPCREL[rip]
	mov	edi, DWORD PTR 12[r10]
	test	edi, edi
	je	.L3230
	movsx	edi, WORD PTR 34[r10]
	movsx	esi, WORD PTR 38[r10]
	movsx	eax, WORD PTR 42[r10]
	jmp	.L3232
	.p2align 4,,10
	.p2align 3
.L3230:
	lea	edi, [rdx+r9]
	add	eax, r8d
	add	esi, ecx
	sar	eax, 16
	sar	esi, 16
	sar	edi, 16
.L3232:
	mov	r8, rbx
	mov	edx, eax
	mov	rcx, r11
	pop	rbx
	.cfi_def_cfa_offset 8
	mov	rax, QWORD PTR tcdiv_ptr[rip]
	jmp	rax
	.cfi_endproc
.LFE656:
	.size	get_texel1_1cycle, .-get_texel1_1cycle
	.p2align 4,,15
	.globl	get_nexttexel0_2cycle
	.type	get_nexttexel0_2cycle, @function
get_nexttexel0_2cycle:
.LFB657:
	.cfi_startproc
	add	r8d, DWORD PTR 16[rsp]
	mov	eax, ecx
	add	eax, DWORD PTR 8[rsp]
	mov	r11, rdi
	lea	edi, [rdx+r9]
	mov	rcx, r11
	sar	edi, 16
	mov	r10d, r8d
	sar	eax, 16
	mov	r8, rsi
	sar	r10d, 16
	mov	esi, eax
	mov	rax, QWORD PTR tcdiv_ptr[rip]
	mov	edx, r10d
	jmp	rax
	.cfi_endproc
.LFE657:
	.size	get_nexttexel0_2cycle, .-get_nexttexel0_2cycle
	.p2align 4,,15
	.globl	tclod_4x17_to_15
	.type	tclod_4x17_to_15, @function
tclod_4x17_to_15:
.LFB658:
	.cfi_startproc
	sal	esi, 15
	sal	edi, 15
	sal	ecx, 15
	sal	edx, 15
	sar	ecx, 15
	sar	esi, 15
	sar	edx, 15
	sar	edi, 15
	sub	ecx, edx
	sub	esi, edi
	jns	.L3236
	not	esi
	and	esi, 131071
.L3236:
	test	ecx, 131072
	je	.L3237
	not	ecx
	and	ecx, 131071
.L3237:
	cmp	esi, r8d
	cmovl	esi, r8d
	cmp	esi, ecx
	cmovge	ecx, esi
	mov	eax, ecx
	and	eax, 32767
	and	ecx, 114688
	je	.L3246
	or	ah, 64
.L3246:
	mov	DWORD PTR [r9], eax
	ret
	.cfi_endproc
.LFE658:
	.size	tclod_4x17_to_15, .-tclod_4x17_to_15
	.p2align 4,,15
	.globl	tclod_tcclamp
	.type	tclod_tcclamp, @function
tclod_tcclamp:
.LFB659:
	.cfi_startproc
	mov	eax, DWORD PTR [rdi]
	mov	edx, DWORD PTR [rsi]
	test	eax, 262144
	jne	.L3248
	test	eax, 131072
	jne	.L3249
	mov	ecx, eax
	and	ecx, 98304
	cmp	ecx, 32768
	je	.L3248
	cmp	ecx, 65536
	je	.L3249
	and	eax, 65535
	test	edx, 262144
	mov	DWORD PTR [rdi], eax
	je	.L3266
	.p2align 4,,10
	.p2align 3
.L3251:
	mov	DWORD PTR [rsi], 32767
	ret
	.p2align 4,,10
	.p2align 3
.L3248:
	mov	DWORD PTR [rdi], 32767
.L3250:
	test	edx, 262144
	jne	.L3251
.L3266:
	test	edx, 131072
	jne	.L3252
	and	edx, 98304
	cmp	edx, 32768
	je	.L3251
	cmp	edx, 65536
	je	.L3252
	and	DWORD PTR [rsi], 65535
	ret
	.p2align 4,,10
	.p2align 3
.L3249:
	mov	DWORD PTR [rdi], 32768
	jmp	.L3250
	.p2align 4,,10
	.p2align 3
.L3252:
	mov	DWORD PTR [rsi], 32768
	ret
	.cfi_endproc
.LFE659:
	.size	tclod_tcclamp, .-tclod_tcclamp
	.p2align 4,,15
	.globl	lodfrac_lodtile_signals
	.type	lodfrac_lodtile_signals, @function
lodfrac_lodtile_signals:
.LFB660:
	.cfi_startproc
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	test	esi, 16384
	push	r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	mov	r12, rcx
	push	rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	push	rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	jne	.L3268
	test	edi, edi
	je	.L3274
.L3268:
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	xor	r13d, r13d
	mov	ebp, 1
	xor	r11d, r11d
	mov	ebx, 262136
	mov	r9d, -1
	mov	ecx, DWORD PTR 1020[rax]
.L3270:
	mov	r10, QWORD PTR other_modes@GOTPCREL[rip]
	sar	ebx, cl
	mov	eax, ebx
	mov	esi, DWORD PTR 12[r10]
	mov	edi, esi
	or	edi, DWORD PTR 8[r10]
	jne	.L3271
	mov	eax, r11d
	not	eax
	and	eax, ebx
	or	eax, r9d
.L3271:
	mov	DWORD PTR [r8], ebp
	mov	DWORD PTR [rdx], ecx
	mov	edx, r11d
	and	edx, esi
	movzx	eax, al
	mov	DWORD PTR [r12], r13d
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	sal	edx, 8
	pop	rbp
	.cfi_def_cfa_offset 24
	or	eax, edx
	movzx	eax, ax
	pop	r12
	.cfi_def_cfa_offset 16
	mov	DWORD PTR lod_frac[rip], eax
	pop	r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L3274:
	.cfi_restore_state
	mov	rax, QWORD PTR min_level@GOTPCREL[rip]
	mov	ebx, DWORD PTR [rax]
	mov	rax, QWORD PTR log2table@GOTPCREL[rip]
	cmp	esi, ebx
	cmovge	ebx, esi
	lea	r13d, -32[rbx]
	mov	ecx, ebx
	sar	ecx, 5
	sar	r13d, 31
	movzx	ecx, cl
	test	bh, 96
	mov	ecx, DWORD PTR [rax+rcx*4]
	jne	.L3275
	mov	rax, QWORD PTR max_level@GOTPCREL[rip]
	xor	r9d, r9d
	mov	r11d, r13d
	cmp	ecx, DWORD PTR [rax]
	setae	r9b
	sal	ebx, 3
	and	r13d, 1
	neg	r9d
	mov	ebp, r9d
	and	ebp, 1
	jmp	.L3270
.L3275:
	mov	r11d, r13d
	sal	ebx, 3
	and	r13d, 1
	mov	ebp, 1
	or	r9d, -1
	jmp	.L3270
	.cfi_endproc
.LFE660:
	.size	lodfrac_lodtile_signals, .-lodfrac_lodtile_signals
	.section	.rodata
	.align 16
	.type	magic_matrix, @object
	.size	magic_matrix, 16
magic_matrix:
	.byte	0
	.byte	6
	.byte	1
	.byte	7
	.byte	4
	.byte	2
	.byte	5
	.byte	3
	.byte	3
	.byte	5
	.byte	2
	.byte	4
	.byte	7
	.byte	1
	.byte	6
	.byte	0
	.align 16
	.type	bayer_matrix, @object
	.size	bayer_matrix, 16
bayer_matrix:
	.byte	0
	.byte	4
	.byte	1
	.byte	5
	.byte	4
	.byte	0
	.byte	5
	.byte	1
	.byte	3
	.byte	7
	.byte	2
	.byte	6
	.byte	7
	.byte	3
	.byte	6
	.byte	2
	.globl	SaveLoaded
	.bss
	.align 4
	.type	SaveLoaded, @object
	.size	SaveLoaded, 4
SaveLoaded:
	.zero	4
	.globl	command_counter
	.align 4
	.type	command_counter, @object
	.size	command_counter, 4
command_counter:
	.zero	4
	.comm	cvarray,1024,32
	.comm	clamp_s_diff,32,32
	.comm	clamp_t_diff,32,32
	.comm	bldiv_hwaccurate_table,32768,32
	.comm	tcdiv_table,131072,32
	.comm	log2table,1024,32
	.comm	ge_two_table,512,32
	.comm	special_9bit_exttable,2048,32
	.comm	special_9bit_clamptable,2048,32
	.comm	maskbits_table,64,32
	.comm	replicated_rgba,32,32
	.comm	z_complete_dec_table,65536,32
	.comm	z_com_table,524288,32
	.comm	render_spans_2cycle_ptr,8,8
	.comm	render_spans_1cycle_ptr,8,8
	.local	tcdiv_ptr
	.comm	tcdiv_ptr,8,16
	.local	rgb_dither_ptr
	.comm	rgb_dither_ptr,8,16
	.local	get_dither_noise_ptr
	.comm	get_dither_noise_ptr,8,16
	.section	.data.rel.ro,"aw",@progbits
	.align 16
	.type	tcdiv_func, @object
	.size	tcdiv_func, 16
tcdiv_func:
	.quad	tcdiv_nopersp
	.quad	tcdiv_persp
	.globl	z_dec_table
	.data
	.align 32
	.type	z_dec_table, @object
	.size	z_dec_table, 64
z_dec_table:
	.long	6
	.long	0
	.long	5
	.long	131072
	.long	4
	.long	196608
	.long	3
	.long	229376
	.long	2
	.long	245760
	.long	1
	.long	253952
	.long	0
	.long	258048
	.long	0
	.long	260096
	.globl	debugcolor
	.bss
	.align 4
	.type	debugcolor, @object
	.size	debugcolor, 4
debugcolor:
	.zero	4
	.globl	DebugMode2
	.align 4
	.type	DebugMode2, @object
	.size	DebugMode2, 4
DebugMode2:
	.zero	4
	.globl	DebugMode
	.align 4
	.type	DebugMode, @object
	.size	DebugMode, 4
DebugMode:
	.zero	4
	.local	lod_frac
	.comm	lod_frac,4,16
	.comm	TMEM,4096,32
	.globl	oldscyl
	.align 4
	.type	oldscyl, @object
	.size	oldscyl, 4
oldscyl:
	.zero	4
	.comm	pre_memory_color,16,16
	.comm	memory_color,16,16
	.comm	blended_pixel_color,16,16
	.comm	inv_pixel_color,16,16
	.comm	pixel_color,16,16
	.data
	.align 4
	.type	blenderone, @object
	.size	blenderone, 4
blenderone:
	.long	255
	.comm	keyalpha,4,4
	.local	zero_color
	.comm	zero_color,4,4
	.align 4
	.type	one_color, @object
	.size	one_color, 4
one_color:
	.long	256
	.local	noise
	.comm	noise,4,16
	.comm	shade_color,16,16
	.comm	nexttexel_color,16,16
	.comm	texel1_color,16,16
	.comm	texel0_color,16,16
	.comm	combined_color,16,16
	.comm	spans_d_stwz_dy,16,16
	.comm	spans_cdz,4,4
	.comm	spans_cd_rgba,16,16
	.comm	spans_d_rgba_dy,16,16
	.comm	spans_dzpix,2,2
	.comm	spans_d_stwz,16,16
	.comm	spans_d_rgba,16,16
	.comm	cvgbuf,1024,32
	.comm	span,98304,32
	.globl	iseed
	.align 16
	.type	iseed, @object
	.size	iseed, 4
iseed:
	.long	1
	.globl	pastblshiftb
	.bss
	.align 16
	.type	pastblshiftb, @object
	.size	pastblshiftb, 4
pastblshiftb:
	.zero	4
	.globl	pastblshifta
	.align 16
	.type	pastblshifta, @object
	.size	pastblshifta, 4
pastblshifta:
	.zero	4
	.globl	blshiftb
	.align 16
	.type	blshiftb, @object
	.size	blshiftb, 4
blshiftb:
	.zero	4
	.globl	blshifta
	.align 16
	.type	blshifta, @object
	.size	blshifta, 4
blshifta:
	.zero	4
	.globl	double_stretch
	.align 4
	.type	double_stretch, @object
	.size	double_stretch, 4
double_stretch:
	.zero	4
	.globl	oldsomething
	.align 4
	.type	oldsomething, @object
	.size	oldsomething, 4
oldsomething:
	.zero	4
	.globl	oldhstart
	.align 4
	.type	oldhstart, @object
	.size	oldhstart, 4
oldhstart:
	.zero	4
	.globl	old_vi_origin
	.align 4
	.type	old_vi_origin, @object
	.size	old_vi_origin, 4
old_vi_origin:
	.zero	4
	.comm	rdp_exec,8,8
	.globl	fbfill_func
	.section	.data.rel,"aw",@progbits
	.align 32
	.type	fbfill_func, @object
	.size	fbfill_func, 32
fbfill_func:
	.quad	fbfill_4
	.quad	fbfill_8
	.quad	fbfill_16
	.quad	fbfill_32
	.globl	fbwrite_func
	.align 32
	.type	fbwrite_func, @object
	.size	fbwrite_func, 32
fbwrite_func:
	.quad	fbwrite_4
	.quad	fbwrite_8
	.quad	fbwrite_16
	.quad	fbwrite_32
	.globl	fbread2_func
	.align 32
	.type	fbread2_func, @object
	.size	fbread2_func, 32
fbread2_func:
	.quad	fbread2_4
	.quad	fbread2_8
	.quad	fbread2_16
	.quad	fbread2_32
	.globl	fbread_func
	.align 32
	.type	fbread_func, @object
	.size	fbread_func, 32
fbread_func:
	.quad	fbread_4
	.quad	fbread_8
	.quad	fbread_16
	.quad	fbread_32
	.comm	fbfill_ptr,8,8
	.comm	fbwrite_ptr,8,8
	.comm	fbread2_ptr,8,8
	.comm	fbread1_ptr,8,8
	.globl	clip
	.data
	.align 16
	.type	clip, @object
	.size	clip, 16
clip:
	.long	0
	.long	0
	.long	8192
	.long	8192
	.comm	z64gl_command,4,4
	.comm	rdp_pipeline_crashed,4,4
	.comm	env_color,16,16
	.comm	prim_color,16,16
	.comm	blend_color,16,16
	.comm	fog_color,16,16
	.comm	key_center,16,16
	.comm	key_scale,16,16
	.comm	key_width,16,16
	.comm	other_modes,172,32
	.comm	tile,800,32
	.comm	k_YUV_RGB,24,16
	.comm	blender2b_a,16,16
	.comm	blender2a_b,16,16
	.comm	blender2a_g,16,16
	.comm	blender2a_r,16,16
	.comm	blender1b_a,16,16
	.comm	blender1a_b,16,16
	.comm	blender1a_g,16,16
	.comm	blender1a_r,16,16
	.comm	combiner_alphaadd,16,16
	.comm	combiner_alphamul,16,16
	.comm	combiner_alphasub_b,16,16
	.comm	combiner_alphasub_a,16,16
	.comm	combiner_rgbadd_b,16,16
	.comm	combiner_rgbadd_g,16,16
	.comm	combiner_rgbadd_r,16,16
	.comm	combiner_rgbmul_b,16,16
	.comm	combiner_rgbmul_g,16,16
	.comm	combiner_rgbmul_r,16,16
	.comm	combiner_rgbsub_b_b,16,16
	.comm	combiner_rgbsub_b_g,16,16
	.comm	combiner_rgbsub_b_r,16,16
	.comm	combiner_rgbsub_a_b,16,16
	.comm	combiner_rgbsub_a_g,16,16
	.comm	combiner_rgbsub_a_r,16,16
	.comm	fill_color,4,4
	.comm	primitive_delta_z,2,2
	.comm	primitive_z,4,4
	.comm	primitive_lod_frac,4,4
	.comm	min_level,4,4
	.comm	max_level,4,4
	.comm	zb_address,4,4
	.comm	fb_address,4,4
	.comm	fb_width,4,4
	.comm	fb_size,4,4
	.comm	fb_format,4,4
	.comm	ti_address,4,4
	.comm	ti_width,4,4
	.comm	ti_size,4,4
	.comm	ti_format,4,4
	.comm	sckeepodd,4,4
	.comm	scfield,4,4
	.globl	norm_slope_table
	.section	.rodata
	.align 32
	.type	norm_slope_table, @object
	.size	norm_slope_table, 256
norm_slope_table:
	.long	3843
	.long	3851
	.long	3857
	.long	3865
	.long	3872
	.long	3877
	.long	3885
	.long	3890
	.long	3895
	.long	3901
	.long	3906
	.long	3911
	.long	3916
	.long	3920
	.long	3925
	.long	3929
	.long	3933
	.long	3938
	.long	3940
	.long	3945
	.long	3948
	.long	3952
	.long	3955
	.long	3958
	.long	3961
	.long	3964
	.long	3967
	.long	3970
	.long	3972
	.long	3975
	.long	3978
	.long	3980
	.long	3982
	.long	3985
	.long	3987
	.long	3989
	.long	3991
	.long	3993
	.long	3995
	.long	3997
	.long	3999
	.long	4001
	.long	4003
	.long	4004
	.long	4006
	.long	4008
	.long	4009
	.long	4010
	.long	4012
	.long	4014
	.long	4015
	.long	4016
	.long	4018
	.long	4019
	.long	4021
	.long	4021
	.long	4023
	.long	4024
	.long	4025
	.long	4026
	.long	4028
	.long	4028
	.long	4030
	.long	4030
	.globl	norm_point_table
	.align 32
	.type	norm_point_table, @object
	.size	norm_point_table, 256
norm_point_table:
	.long	16384
	.long	16132
	.long	15888
	.long	15650
	.long	15420
	.long	15197
	.long	14979
	.long	14769
	.long	14564
	.long	14364
	.long	14170
	.long	13981
	.long	13797
	.long	13618
	.long	13443
	.long	13273
	.long	13107
	.long	12945
	.long	12788
	.long	12633
	.long	12483
	.long	12336
	.long	12193
	.long	12053
	.long	11916
	.long	11782
	.long	11651
	.long	11523
	.long	11398
	.long	11275
	.long	11155
	.long	11038
	.long	10923
	.long	10810
	.long	10700
	.long	10592
	.long	10486
	.long	10382
	.long	10280
	.long	10180
	.long	10082
	.long	9986
	.long	9892
	.long	9800
	.long	9709
	.long	9620
	.long	9533
	.long	9447
	.long	9362
	.long	9279
	.long	9198
	.long	9118
	.long	9039
	.long	8962
	.long	8886
	.long	8812
	.long	8738
	.long	8666
	.long	8595
	.long	8525
	.long	8456
	.long	8389
	.long	8322
	.long	8257
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.long	511
	.long	511
	.long	511
	.long	511
	.align 16
.LC3:
	.byte	0
	.byte	0
	.byte	1
	.byte	0
	.byte	2
	.byte	0
	.byte	1
	.byte	0
	.byte	3
	.byte	0
	.byte	1
	.byte	0
	.byte	2
	.byte	0
	.byte	1
	.byte	0
	.align 16
.LC4:
	.byte	0
	.byte	3
	.byte	2
	.byte	2
	.byte	1
	.byte	1
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.align 16
.LC5:
	.long	0
	.long	1
	.long	2
	.long	3
	.align 16
.LC6:
	.long	4
	.long	5
	.long	6
	.long	7
	.align 16
.LC7:
	.long	8
	.long	9
	.long	10
	.long	11
	.align 16
.LC8:
	.long	12
	.long	13
	.long	14
	.long	15
	.align 16
.LC9:
	.long	16
	.long	17
	.long	18
	.long	19
	.align 16
.LC10:
	.long	20
	.long	21
	.long	22
	.long	23
	.align 16
.LC11:
	.long	24
	.long	25
	.long	26
	.long	27
	.align 16
.LC12:
	.long	28
	.long	29
	.long	30
	.long	31
	.align 16
.LC13:
	.long	4
	.long	4
	.long	4
	.long	4
	.align 16
.LC14:
	.long	384
	.long	384
	.long	384
	.long	384
	.align 16
.LC15:
	.long	-512
	.long	-512
	.long	-512
	.long	-512
	.ident	"GCC: (GNU) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
