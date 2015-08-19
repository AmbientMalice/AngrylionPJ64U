	.file	"rdp.c"
	.intel_syntax noprefix
	.text
	.p2align 4,,15
	.type	noop, @function
noop:
.LFB553:
	.cfi_startproc
	rep ret
	.cfi_endproc
.LFE553:
	.size	noop, .-noop
	.p2align 4,,15
	.type	sync_load, @function
sync_load:
.LFB564:
	.cfi_startproc
	rep ret
	.cfi_endproc
.LFE564:
	.size	sync_load, .-sync_load
	.p2align 4,,15
	.type	sync_pipe, @function
sync_pipe:
.LFB565:
	.cfi_startproc
	rep ret
	.cfi_endproc
.LFE565:
	.size	sync_pipe, .-sync_pipe
	.p2align 4,,15
	.type	sync_tile, @function
sync_tile:
.LFB566:
	.cfi_startproc
	rep ret
	.cfi_endproc
.LFE566:
	.size	sync_tile, .-sync_tile
	.p2align 4,,15
	.type	sync_full, @function
sync_full:
.LFB567:
	.cfi_startproc
	mov	rax, QWORD PTR z64gl_command@GOTPCREL[rip]
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rdx, QWORD PTR 56[rax]
	mov	rax, QWORD PTR 240[rax]
	or	DWORD PTR [rdx], 32
	jmp	rax
	.cfi_endproc
.LFE567:
	.size	sync_full, .-sync_full
	.p2align 4,,15
	.type	set_key_gb, @function
set_key_gb:
.LFB568:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip]
	mov	rcx, QWORD PTR key_width@GOTPCREL[rip]
	mov	esi, DWORD PTR [rax+rdx*8]
	mov	eax, esi
	and	esi, 4095
	and	eax, 16773120
	mov	DWORD PTR 8[rcx], esi
	mov	rsi, QWORD PTR key_center@GOTPCREL[rip]
	shr	eax, 12
	mov	DWORD PTR 4[rcx], eax
	lea	rax, cmd_data[rip+4]
	mov	rcx, QWORD PTR key_scale@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax+rdx*8]
	mov	edx, eax
	shr	edx, 24
	mov	DWORD PTR 4[rsi], edx
	mov	edx, eax
	and	edx, 16711680
	shr	edx, 16
	mov	DWORD PTR 4[rcx], edx
	movzx	edx, ah
	and	eax, 255
	mov	DWORD PTR 8[rsi], edx
	mov	DWORD PTR 8[rcx], eax
	ret
	.cfi_endproc
.LFE568:
	.size	set_key_gb, .-set_key_gb
	.p2align 4,,15
	.type	set_key_r, @function
set_key_r:
.LFB569:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip+4]
	mov	rcx, QWORD PTR key_width@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax+rdx*8]
	mov	edx, eax
	and	edx, 268369920
	shr	edx, 16
	mov	DWORD PTR [rcx], edx
	mov	rdx, QWORD PTR key_center@GOTPCREL[rip]
	movzx	ecx, ah
	and	eax, 255
	mov	DWORD PTR [rdx], ecx
	mov	rdx, QWORD PTR key_scale@GOTPCREL[rip]
	mov	DWORD PTR [rdx], eax
	ret
	.cfi_endproc
.LFE569:
	.size	set_key_r, .-set_key_r
	.p2align 4,,15
	.type	set_convert, @function
set_convert:
.LFB570:
	.cfi_startproc
	movsx	rax, DWORD PTR cmd_cur[rip]
	lea	rdx, cmd_data[rip]
	lea	rcx, cmd_data[rip+4]
	mov	edx, DWORD PTR [rdx+rax*8]
	mov	eax, DWORD PTR [rcx+rax*8]
	sal	rdx, 32
	or	rdx, rax
	mov	rax, QWORD PTR k_YUV_RGB@GOTPCREL[rip]
	mov	r8, rdx
	mov	rdi, rdx
	mov	rsi, rdx
	mov	rcx, rdx
	shr	r8, 18
	mov	r9, rdx
	shr	rdi, 45
	and	edx, 511
	shr	rsi, 36
	shr	rcx, 27
	and	r8d, 511
	and	edi, 511
	and	esi, 511
	and	ecx, 511
	mov	DWORD PTR 20[rax], edx
	mov	edx, r8d
	sal	edi, 23
	sal	esi, 23
	sal	ecx, 23
	sal	edx, 23
	sar	edi, 23
	sar	esi, 23
	sar	ecx, 23
	sar	edx, 23
	shr	r9, 9
	lea	edi, 1[rdi+rdi]
	lea	esi, 1[rsi+rsi]
	lea	ecx, 1[rcx+rcx]
	lea	edx, 1[rdx+rdx]
	and	r9d, 511
	mov	DWORD PTR 16[rax], r9d
	mov	DWORD PTR [rax], edi
	mov	DWORD PTR 4[rax], esi
	mov	DWORD PTR 8[rax], ecx
	mov	DWORD PTR 12[rax], edx
	ret
	.cfi_endproc
.LFE570:
	.size	set_convert, .-set_convert
	.p2align 4,,15
	.type	set_scissor, @function
set_scissor:
.LFB571:
	.cfi_startproc
	movsx	rcx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip]
	mov	esi, DWORD PTR [rax+rcx*8]
	mov	rax, QWORD PTR clip@GOTPCREL[rip]
	mov	edx, esi
	and	esi, 4095
	and	edx, 16773120
	mov	DWORD PTR 12[rax], esi
	mov	rsi, QWORD PTR scfield@GOTPCREL[rip]
	shr	edx, 12
	mov	DWORD PTR 8[rax], edx
	lea	rdx, cmd_data[rip+4]
	mov	edx, DWORD PTR [rdx+rcx*8]
	mov	ecx, edx
	and	ecx, 33554432
	shr	ecx, 25
	mov	DWORD PTR [rsi], ecx
	mov	ecx, edx
	mov	rsi, QWORD PTR sckeepodd@GOTPCREL[rip]
	and	ecx, 16777216
	shr	ecx, 24
	mov	DWORD PTR [rsi], ecx
	mov	ecx, edx
	and	edx, 4095
	and	ecx, 16773120
	mov	DWORD PTR 4[rax], edx
	shr	ecx, 12
	mov	DWORD PTR [rax], ecx
	ret
	.cfi_endproc
.LFE571:
	.size	set_scissor, .-set_scissor
	.p2align 4,,15
	.type	set_prim_depth, @function
set_prim_depth:
.LFB572:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip+4]
	mov	eax, DWORD PTR [rax+rdx*8]
	mov	rdx, QWORD PTR primitive_delta_z@GOTPCREL[rip]
	mov	WORD PTR [rdx], ax
	mov	rdx, QWORD PTR primitive_z@GOTPCREL[rip]
	and	eax, 2147418112
	mov	DWORD PTR [rdx], eax
	ret
	.cfi_endproc
.LFE572:
	.size	set_prim_depth, .-set_prim_depth
	.p2align 4,,15
	.type	set_fill_color, @function
set_fill_color:
.LFB580:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip+4]
	mov	edx, DWORD PTR [rax+rdx*8]
	mov	rax, QWORD PTR fill_color@GOTPCREL[rip]
	mov	DWORD PTR [rax], edx
	ret
	.cfi_endproc
.LFE580:
	.size	set_fill_color, .-set_fill_color
	.p2align 4,,15
	.type	set_fog_color, @function
set_fog_color:
.LFB581:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip+4]
	mov	edx, DWORD PTR [rax+rdx*8]
	mov	rax, QWORD PTR fog_color@GOTPCREL[rip]
	mov	ecx, edx
	shr	ecx, 24
	mov	DWORD PTR [rax], ecx
	mov	ecx, edx
	and	ecx, 16711680
	shr	ecx, 16
	mov	DWORD PTR 4[rax], ecx
	movzx	ecx, dh
	and	edx, 255
	mov	DWORD PTR 8[rax], ecx
	mov	DWORD PTR 12[rax], edx
	ret
	.cfi_endproc
.LFE581:
	.size	set_fog_color, .-set_fog_color
	.p2align 4,,15
	.type	set_blend_color, @function
set_blend_color:
.LFB582:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip+4]
	mov	edx, DWORD PTR [rax+rdx*8]
	mov	rax, QWORD PTR blend_color@GOTPCREL[rip]
	mov	ecx, edx
	shr	ecx, 24
	mov	DWORD PTR [rax], ecx
	mov	ecx, edx
	and	ecx, 16711680
	shr	ecx, 16
	mov	DWORD PTR 4[rax], ecx
	movzx	ecx, dh
	and	edx, 255
	mov	DWORD PTR 8[rax], ecx
	mov	DWORD PTR 12[rax], edx
	ret
	.cfi_endproc
.LFE582:
	.size	set_blend_color, .-set_blend_color
	.p2align 4,,15
	.type	set_prim_color, @function
set_prim_color:
.LFB583:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip]
	mov	rsi, QWORD PTR min_level@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rax+rdx*8]
	mov	eax, ecx
	and	ecx, 255
	and	eax, 7936
	shr	eax, 8
	mov	DWORD PTR [rsi], eax
	mov	rax, QWORD PTR primitive_lod_frac@GOTPCREL[rip]
	mov	DWORD PTR [rax], ecx
	lea	rax, cmd_data[rip+4]
	mov	edx, DWORD PTR [rax+rdx*8]
	mov	rax, QWORD PTR prim_color@GOTPCREL[rip]
	mov	ecx, edx
	shr	ecx, 24
	mov	DWORD PTR [rax], ecx
	mov	ecx, edx
	and	ecx, 16711680
	shr	ecx, 16
	mov	DWORD PTR 4[rax], ecx
	movzx	ecx, dh
	and	edx, 255
	mov	DWORD PTR 8[rax], ecx
	mov	DWORD PTR 12[rax], edx
	ret
	.cfi_endproc
.LFE583:
	.size	set_prim_color, .-set_prim_color
	.p2align 4,,15
	.type	set_env_color, @function
set_env_color:
.LFB584:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip+4]
	mov	edx, DWORD PTR [rax+rdx*8]
	mov	rax, QWORD PTR env_color@GOTPCREL[rip]
	mov	ecx, edx
	shr	ecx, 24
	mov	DWORD PTR [rax], ecx
	mov	ecx, edx
	and	ecx, 16711680
	shr	ecx, 16
	mov	DWORD PTR 4[rax], ecx
	movzx	ecx, dh
	and	edx, 255
	mov	DWORD PTR 8[rax], ecx
	mov	DWORD PTR 12[rax], edx
	ret
	.cfi_endproc
.LFE584:
	.size	set_env_color, .-set_env_color
	.p2align 4,,15
	.type	set_texture_image, @function
set_texture_image:
.LFB586:
	.cfi_startproc
	movsx	rcx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip]
	mov	rsi, QWORD PTR ti_format@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax+rcx*8]
	mov	edx, eax
	and	edx, 14680064
	shr	edx, 21
	mov	DWORD PTR [rsi], edx
	mov	edx, eax
	mov	rsi, QWORD PTR ti_size@GOTPCREL[rip]
	and	edx, 1572864
	and	eax, 1023
	shr	edx, 19
	add	eax, 1
	mov	DWORD PTR [rsi], edx
	lea	rdx, cmd_data[rip+4]
	mov	edx, DWORD PTR [rdx+rcx*8]
	mov	rcx, QWORD PTR ti_address@GOTPCREL[rip]
	and	edx, 67108863
	mov	DWORD PTR [rcx], edx
	mov	rdx, QWORD PTR ti_width@GOTPCREL[rip]
	mov	DWORD PTR [rdx], eax
	ret
	.cfi_endproc
.LFE586:
	.size	set_texture_image, .-set_texture_image
	.p2align 4,,15
	.type	set_mask_image, @function
set_mask_image:
.LFB587:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip+4]
	mov	eax, DWORD PTR [rax+rdx*8]
	mov	rdx, QWORD PTR zb_address@GOTPCREL[rip]
	and	eax, 67108863
	mov	DWORD PTR [rdx], eax
	ret
	.cfi_endproc
.LFE587:
	.size	set_mask_image, .-set_mask_image
	.p2align 4,,15
	.type	set_color_image, @function
set_color_image:
.LFB588:
	.cfi_startproc
	movsx	rcx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip]
	mov	rsi, QWORD PTR fb_format@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax+rcx*8]
	mov	edx, eax
	and	edx, 14680064
	shr	edx, 21
	mov	DWORD PTR [rsi], edx
	mov	edx, eax
	mov	rsi, QWORD PTR fb_size@GOTPCREL[rip]
	and	edx, 1572864
	and	eax, 1023
	shr	edx, 19
	add	eax, 1
	mov	DWORD PTR [rsi], edx
	lea	rdx, cmd_data[rip+4]
	mov	edx, DWORD PTR [rdx+rcx*8]
	mov	rcx, QWORD PTR fb_address@GOTPCREL[rip]
	and	edx, 67108863
	mov	DWORD PTR [rcx], edx
	mov	rdx, QWORD PTR fb_width@GOTPCREL[rip]
	mov	DWORD PTR [rdx], eax
	ret
	.cfi_endproc
.LFE588:
	.size	set_color_image, .-set_color_image
	.p2align 4,,15
	.type	invalid, @function
invalid:
.LFB552:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip]
	lea	rdi, invalid_command[rip]
	mov	eax, DWORD PTR [rax+rdx*8]
	and	eax, 1056964608
	mov	edx, eax
	shr	eax, 27
	or	eax, 48
	shr	edx, 24
	mov	BYTE PTR invalid_command[rip], al
	mov	eax, edx
	and	eax, 7
	or	eax, 48
	mov	BYTE PTR invalid_command[rip+1], al
	jmp	DisplayError@PLT
	.cfi_endproc
.LFE552:
	.size	invalid, .-invalid
	.p2align 4,,15
	.type	set_combine, @function
set_combine:
.LFB585:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	lea	rdx, cmd_data[rip]
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
	movsx	rax, DWORD PTR cmd_cur[rip]
	mov	r15, QWORD PTR combiner_rgbsub_a_b@GOTPCREL[rip]
	mov	r14, QWORD PTR combiner_rgbsub_a_g@GOTPCREL[rip]
	mov	rdi, QWORD PTR combiner_rgbsub_a_r@GOTPCREL[rip]
	mov	ebp, DWORD PTR [rdx+rax*8]
	lea	rdx, cmd_data[rip+4]
	mov	rsi, r14
	mov	ebx, DWORD PTR [rdx+rax*8]
	mov	rdx, r15
	mov	ecx, ebp
	and	ecx, 15728640
	shr	ecx, 20
	call	SET_SUBA_RGB_INPUT@PLT
	mov	rdx, QWORD PTR combiner_rgbsub_b_b@GOTPCREL[rip]
	mov	rsi, QWORD PTR combiner_rgbsub_b_g@GOTPCREL[rip]
	mov	ecx, ebx
	mov	rdi, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	shr	ecx, 28
	call	SET_SUBB_RGB_INPUT@PLT
	mov	ecx, ebp
	mov	rdx, QWORD PTR combiner_rgbmul_b@GOTPCREL[rip]
	mov	rsi, QWORD PTR combiner_rgbmul_g@GOTPCREL[rip]
	mov	rdi, QWORD PTR combiner_rgbmul_r@GOTPCREL[rip]
	and	ecx, 1015808
	shr	ecx, 15
	call	SET_MUL_RGB_INPUT@PLT
	mov	rdx, QWORD PTR combiner_rgbadd_b@GOTPCREL[rip]
	mov	ecx, ebx
	mov	rsi, QWORD PTR combiner_rgbadd_g@GOTPCREL[rip]
	mov	rdi, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	and	ecx, 229376
	shr	ecx, 15
	call	SET_ADD_RGB_INPUT@PLT
	mov	esi, ebp
	mov	rdi, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	and	esi, 28672
	shr	esi, 12
	call	SET_SUB_ALPHA_INPUT@PLT
	mov	esi, ebx
	mov	rdi, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	and	esi, 28672
	shr	esi, 12
	call	SET_SUB_ALPHA_INPUT@PLT
	mov	r13, QWORD PTR combiner_alphamul@GOTPCREL[rip]
	mov	esi, ebp
	and	esi, 3584
	shr	esi, 9
	mov	rdi, r13
	call	SET_MUL_ALPHA_INPUT@PLT
	mov	r12, QWORD PTR combiner_alphaadd@GOTPCREL[rip]
	mov	esi, ebx
	and	esi, 3584
	shr	esi, 9
	mov	rdi, r12
	call	SET_SUB_ALPHA_INPUT@PLT
	mov	rax, QWORD PTR combiner_rgbsub_a_r@GOTPCREL[rip]
	mov	ecx, ebp
	lea	rdx, 8[r15]
	lea	rsi, 8[r14]
	and	ecx, 480
	shr	ecx, 5
	lea	rdi, 8[rax]
	call	SET_SUBA_RGB_INPUT@PLT
	mov	rax, QWORD PTR combiner_rgbsub_b_b@GOTPCREL[rip]
	mov	ecx, ebx
	and	ecx, 251658240
	shr	ecx, 24
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR combiner_rgbsub_b_g@GOTPCREL[rip]
	lea	rsi, 8[rax]
	mov	rax, QWORD PTR combiner_rgbsub_b_r@GOTPCREL[rip]
	lea	rdi, 8[rax]
	call	SET_SUBB_RGB_INPUT@PLT
	mov	rax, QWORD PTR combiner_rgbmul_b@GOTPCREL[rip]
	mov	ecx, ebp
	and	ecx, 31
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR combiner_rgbmul_g@GOTPCREL[rip]
	lea	rsi, 8[rax]
	mov	rax, QWORD PTR combiner_rgbmul_r@GOTPCREL[rip]
	lea	rdi, 8[rax]
	call	SET_MUL_RGB_INPUT@PLT
	mov	rax, QWORD PTR combiner_rgbadd_b@GOTPCREL[rip]
	mov	ecx, ebx
	and	ecx, 448
	shr	ecx, 6
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR combiner_rgbadd_g@GOTPCREL[rip]
	lea	rsi, 8[rax]
	mov	rax, QWORD PTR combiner_rgbadd_r@GOTPCREL[rip]
	lea	rdi, 8[rax]
	call	SET_ADD_RGB_INPUT@PLT
	mov	rax, QWORD PTR combiner_alphasub_a@GOTPCREL[rip]
	mov	esi, ebx
	and	esi, 14680064
	shr	esi, 21
	lea	rdi, 8[rax]
	call	SET_SUB_ALPHA_INPUT@PLT
	mov	rax, QWORD PTR combiner_alphasub_b@GOTPCREL[rip]
	mov	esi, ebx
	and	esi, 56
	shr	esi, 3
	lea	rdi, 8[rax]
	call	SET_SUB_ALPHA_INPUT@PLT
	mov	esi, ebx
	lea	rdi, 8[r13]
	and	ebx, 7
	and	esi, 1835008
	shr	esi, 18
	call	SET_MUL_ALPHA_INPUT@PLT
	lea	rdi, 8[r12]
	mov	esi, ebx
	call	SET_SUB_ALPHA_INPUT@PLT
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	DWORD PTR 144[rax], 1
	add	rsp, 8
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
.LFE585:
	.size	set_combine, .-set_combine
	.p2align 4,,15
	.type	render_spans, @function
render_spans:
.LFB592:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	sub	rsp, 24
	.cfi_def_cfa_offset 48
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	eax, DWORD PTR 144[rbx]
	mov	ebp, DWORD PTR [rbx]
	test	eax, eax
	jne	.L30
.L23:
	mov	rax, QWORD PTR fb_size@GOTPCREL[rip]
	mov	r8, QWORD PTR fbread_func@GOTPCREL[rip]
	test	bpl, 2
	movsx	rax, DWORD PTR [rax]
	mov	r9, QWORD PTR [r8+rax*8]
	mov	r8, QWORD PTR fbread1_ptr@GOTPCREL[rip]
	mov	QWORD PTR [r8], r9
	mov	r8, QWORD PTR fbread2_func@GOTPCREL[rip]
	mov	r9, QWORD PTR [r8+rax*8]
	mov	r8, QWORD PTR fbread2_ptr@GOTPCREL[rip]
	mov	QWORD PTR [r8], r9
	mov	r8, QWORD PTR fbwrite_func@GOTPCREL[rip]
	mov	r8, QWORD PTR [r8+rax*8]
	mov	rax, QWORD PTR fbwrite_ptr@GOTPCREL[rip]
	mov	QWORD PTR [rax], r8
	je	.L24
	and	ebp, 1
	je	.L25
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	mov	edx, ecx
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	jmp	render_spans_fill@PLT
	.p2align 4,,10
	.p2align 3
.L24:
	.cfi_restore_state
	and	ebp, 1
	jne	.L31
	mov	rax, QWORD PTR render_spans_1cycle_ptr@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	jmp	rax
	.p2align 4,,10
	.p2align 3
.L25:
	.cfi_restore_state
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	jmp	render_spans_copy@PLT
	.p2align 4,,10
	.p2align 3
.L30:
	.cfi_restore_state
	mov	DWORD PTR 12[rsp], ecx
	mov	DWORD PTR 8[rsp], edx
	mov	DWORD PTR 4[rsp], esi
	mov	DWORD PTR [rsp], edi
	call	deduce_derivatives@PLT
	mov	DWORD PTR 144[rbx], 0
	mov	ecx, DWORD PTR 12[rsp]
	mov	edx, DWORD PTR 8[rsp]
	mov	esi, DWORD PTR 4[rsp]
	mov	edi, DWORD PTR [rsp]
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L31:
	mov	rax, QWORD PTR render_spans_2cycle_ptr@GOTPCREL[rip]
	mov	rax, QWORD PTR [rax]
	add	rsp, 24
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	jmp	rax
	.cfi_endproc
.LFE592:
	.size	render_spans, .-render_spans
	.p2align 4,,15
	.type	set_tile, @function
set_tile:
.LFB578:
	.cfi_startproc
	movsx	rdx, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip]
	mov	rsi, QWORD PTR tile@GOTPCREL[rip]
	lea	rax, [rax+rdx*8]
	mov	edx, DWORD PTR 4[rax]
	mov	ecx, DWORD PTR [rax]
	mov	edi, edx
	and	edi, 117440512
	shr	edi, 24
	movsx	rax, edi
	lea	rax, [rax+rax*4]
	lea	rax, [rax+rax*4]
	lea	rax, [rsi+rax*4]
	mov	esi, ecx
	and	esi, 14680064
	shr	esi, 21
	mov	DWORD PTR [rax], esi
	mov	esi, ecx
	and	esi, 1572864
	shr	esi, 19
	mov	DWORD PTR 4[rax], esi
	mov	esi, ecx
	and	ecx, 511
	mov	DWORD PTR 12[rax], ecx
	mov	ecx, edx
	and	esi, 261632
	and	ecx, 15728640
	shr	esi, 9
	shr	ecx, 20
	mov	DWORD PTR 8[rax], esi
	mov	DWORD PTR 16[rax], ecx
	mov	ecx, edx
	and	ecx, 524288
	shr	ecx, 19
	mov	DWORD PTR 20[rax], ecx
	mov	ecx, edx
	and	ecx, 262144
	shr	ecx, 18
	mov	DWORD PTR 24[rax], ecx
	mov	ecx, edx
	and	ecx, 245760
	shr	ecx, 14
	mov	DWORD PTR 36[rax], ecx
	mov	ecx, edx
	and	ecx, 15360
	shr	ecx, 10
	mov	DWORD PTR 40[rax], ecx
	mov	ecx, edx
	and	ecx, 512
	shr	ecx, 9
	mov	DWORD PTR 28[rax], ecx
	mov	ecx, edx
	and	ecx, 256
	shr	ecx, 8
	mov	DWORD PTR 32[rax], ecx
	mov	ecx, edx
	and	edx, 15
	and	ecx, 240
	mov	DWORD PTR 48[rax], edx
	shr	ecx, 4
	mov	DWORD PTR 44[rax], ecx
	jmp	calculate_tile_derivs@PLT
	.cfi_endproc
.LFE578:
	.size	set_tile, .-set_tile
	.p2align 4,,15
	.type	load_tile, @function
load_tile:
.LFB577:
	.cfi_startproc
	movsx	rax, DWORD PTR cmd_cur[rip]
	lea	rdx, cmd_data[rip+4]
	mov	esi, DWORD PTR [rdx+rax*8]
	lea	rdx, cmd_data[rip]
	mov	edi, DWORD PTR [rdx+rax*8]
	jmp	tile_tlut_common_cs_decoder@PLT
	.cfi_endproc
.LFE577:
	.size	load_tile, .-load_tile
	.p2align 4,,15
	.type	load_tlut, @function
load_tlut:
.LFB576:
	.cfi_startproc
	movsx	rax, DWORD PTR cmd_cur[rip]
	lea	rdx, cmd_data[rip+4]
	mov	esi, DWORD PTR [rdx+rax*8]
	lea	rdx, cmd_data[rip]
	mov	edi, DWORD PTR [rdx+rax*8]
	jmp	tile_tlut_common_cs_decoder@PLT
	.cfi_endproc
.LFE576:
	.size	load_tlut, .-load_tlut
	.p2align 4,,15
	.type	set_tile_size, @function
set_tile_size:
.LFB574:
	.cfi_startproc
	movsx	rax, DWORD PTR cmd_cur[rip]
	lea	rdx, cmd_data[rip]
	mov	r8, QWORD PTR tile@GOTPCREL[rip]
	mov	esi, DWORD PTR [rdx+rax*8]
	lea	rdx, cmd_data[rip+4]
	mov	edx, DWORD PTR [rdx+rax*8]
	mov	ecx, esi
	and	esi, 4095
	and	ecx, 16773120
	mov	edi, edx
	shr	ecx, 12
	and	edi, 117440512
	shr	edi, 24
	movsx	rax, edi
	lea	rax, [rax+rax*4]
	lea	rax, [rax+rax*4]
	lea	rax, [r8+rax*4]
	mov	DWORD PTR 52[rax], ecx
	mov	ecx, edx
	and	edx, 4095
	and	ecx, 16773120
	mov	DWORD PTR 56[rax], esi
	mov	DWORD PTR 64[rax], edx
	shr	ecx, 12
	mov	DWORD PTR 60[rax], ecx
	jmp	calculate_clamp_diffs@PLT
	.cfi_endproc
.LFE574:
	.size	set_tile_size, .-set_tile_size
	.p2align 4,,15
	.type	load_block, @function
load_block:
.LFB575:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	lea	rdx, cmd_data[rip]
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
	sub	rsp, 56
	.cfi_def_cfa_offset 112
	movsx	rax, DWORD PTR cmd_cur[rip]
	mov	r9, QWORD PTR tile@GOTPCREL[rip]
	mov	r13d, DWORD PTR [rdx+rax*8]
	lea	rdx, cmd_data[rip+4]
	mov	r14d, DWORD PTR [rdx+rax*8]
	mov	ebx, r13d
	mov	r15d, r13d
	and	ebx, 16773120
	and	r15d, 4095
	mov	ebp, r14d
	mov	r12d, r14d
	shr	ebx, 12
	and	ebp, 117440512
	and	r12d, 16773120
	and	r14d, 4095
	shr	ebp, 24
	shr	r12d, 12
	movsx	rax, ebp
	mov	edi, ebp
	sal	ebp, 16
	lea	rax, [rax+rax*4]
	lea	rdx, [rax+rax*4]
	lea	rdx, [r9+rdx*4]
	mov	DWORD PTR 52[rdx], ebx
	mov	DWORD PTR 56[rdx], r15d
	sal	r15d, 3
	mov	DWORD PTR 60[rdx], r12d
	mov	DWORD PTR 64[rdx], r14d
	sal	r12d, 16
	call	calculate_clamp_diffs@PLT
	mov	edx, r13d
	mov	eax, r13d
	mov	rdi, rsp
	and	edx, 1023
	and	eax, -16777216
	mov	DWORD PTR 8[rsp], r12d
	sal	edx, 2
	or	eax, 8388608
	mov	DWORD PTR 16[rsp], r12d
	mov	ecx, edx
	or	eax, ebp
	mov	DWORD PTR 32[rsp], 32
	or	ecx, 3
	mov	DWORD PTR 36[rsp], 32
	or	eax, ecx
	mov	DWORD PTR [rsp], eax
	mov	eax, ecx
	sal	eax, 16
	or	eax, edx
	mov	edx, r14d
	mov	DWORD PTR 4[rsp], eax
	mov	eax, ebx
	sar	edx, 8
	sal	eax, 16
	sal	ebx, 19
	mov	DWORD PTR 12[rsp], eax
	mov	eax, r14d
	or	ebx, r15d
	sal	eax, 8
	mov	DWORD PTR 20[rsp], ebx
	and	eax, 65535
	mov	DWORD PTR 24[rsp], eax
	mov	rax, QWORD PTR ti_size@GOTPCREL[rip]
	mov	ecx, DWORD PTR [rax]
	mov	eax, 128
	sar	eax, cl
	sal	eax, 16
	or	edx, eax
	mov	DWORD PTR 28[rsp], edx
	call	edgewalker_for_loads@PLT
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
.LFE575:
	.size	load_block, .-load_block
	.p2align 4,,15
	.type	set_other_modes, @function
set_other_modes:
.LFB573:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	lea	rax, cmd_data[rip]
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
	movsx	rdx, DWORD PTR cmd_cur[rip]
	mov	rbx, QWORD PTR other_modes@GOTPCREL[rip]
	lea	rax, [rax+rdx*8]
	mov	ecx, DWORD PTR [rax]
	mov	edx, DWORD PTR 4[rax]
	mov	esi, ecx
	mov	edi, edx
	and	esi, 3145728
	shr	edi, 30
	shr	esi, 20
	mov	DWORD PTR 60[rbx], edi
	mov	DWORD PTR [rbx], esi
	mov	esi, ecx
	shr	esi, 19
	and	esi, 1
	mov	DWORD PTR 4[rbx], esi
	mov	esi, ecx
	shr	esi, 18
	and	esi, 1
	mov	DWORD PTR 8[rbx], esi
	mov	esi, ecx
	shr	esi, 17
	and	esi, 1
	mov	DWORD PTR 12[rbx], esi
	mov	esi, ecx
	shr	esi, 16
	and	esi, 1
	mov	DWORD PTR 16[rbx], esi
	mov	esi, ecx
	shr	esi, 15
	and	esi, 1
	mov	DWORD PTR 20[rbx], esi
	mov	esi, ecx
	shr	esi, 14
	and	esi, 1
	mov	DWORD PTR 24[rbx], esi
	mov	esi, ecx
	shr	esi, 13
	and	esi, 1
	mov	DWORD PTR 28[rbx], esi
	mov	esi, ecx
	shr	esi, 12
	and	esi, 1
	mov	DWORD PTR 32[rbx], esi
	mov	esi, ecx
	shr	esi, 11
	and	esi, 1
	mov	DWORD PTR 36[rbx], esi
	mov	esi, ecx
	shr	esi, 10
	and	esi, 1
	mov	DWORD PTR 40[rbx], esi
	mov	esi, ecx
	shr	esi, 9
	and	esi, 1
	mov	DWORD PTR 44[rbx], esi
	mov	esi, ecx
	shr	esi, 8
	and	esi, 1
	mov	DWORD PTR 48[rbx], esi
	mov	esi, ecx
	and	ecx, 48
	shr	ecx, 4
	and	esi, 192
	shr	esi, 6
	mov	DWORD PTR 56[rbx], ecx
	mov	ecx, edx
	mov	DWORD PTR 52[rbx], esi
	and	ecx, 805306368
	mov	esi, edx
	shr	ecx, 28
	and	esi, 50331648
	shr	esi, 24
	mov	DWORD PTR 64[rbx], ecx
	mov	ecx, edx
	mov	DWORD PTR 72[rbx], esi
	mov	esi, edx
	and	ecx, 201326592
	and	esi, 12582912
	shr	ecx, 26
	shr	esi, 22
	mov	DWORD PTR 68[rbx], ecx
	mov	DWORD PTR 76[rbx], esi
	mov	esi, edx
	and	esi, 3145728
	shr	esi, 20
	mov	DWORD PTR 80[rbx], esi
	mov	esi, edx
	and	esi, 786432
	shr	esi, 18
	mov	DWORD PTR 84[rbx], esi
	mov	esi, edx
	and	esi, 196608
	shr	esi, 16
	mov	DWORD PTR 88[rbx], esi
	mov	esi, edx
	mov	r15, QWORD PTR blender1b_a@GOTPCREL[rip]
	shr	esi, 14
	mov	r14, QWORD PTR blender1a_b@GOTPCREL[rip]
	mov	r13, QWORD PTR blender1a_g@GOTPCREL[rip]
	and	esi, 1
	mov	r12, QWORD PTR blender1a_r@GOTPCREL[rip]
	mov	DWORD PTR 92[rbx], esi
	mov	esi, edx
	mov	r9, r15
	shr	esi, 13
	mov	r8, r14
	and	esi, 1
	mov	DWORD PTR 96[rbx], esi
	mov	esi, edx
	shr	esi, 12
	and	esi, 1
	mov	DWORD PTR 100[rbx], esi
	mov	esi, edx
	and	esi, 3072
	shr	esi, 10
	mov	DWORD PTR 104[rbx], esi
	mov	esi, edx
	and	esi, 768
	shr	esi, 8
	mov	DWORD PTR 108[rbx], esi
	mov	esi, edx
	shr	esi, 7
	and	esi, 1
	mov	DWORD PTR 112[rbx], esi
	mov	esi, edx
	shr	esi, 6
	and	esi, 1
	mov	DWORD PTR 116[rbx], esi
	mov	esi, edx
	shr	esi, 5
	and	esi, 1
	mov	DWORD PTR 120[rbx], esi
	mov	esi, edx
	shr	esi, 4
	and	esi, 1
	mov	DWORD PTR 124[rbx], esi
	mov	esi, edx
	shr	esi, 3
	and	esi, 1
	mov	DWORD PTR 128[rbx], esi
	mov	esi, edx
	shr	esi, 2
	and	esi, 1
	mov	DWORD PTR 132[rbx], esi
	mov	esi, edx
	and	edx, 1
	shr	esi
	mov	DWORD PTR 140[rbx], edx
	mov	rdx, r12
	and	esi, 1
	mov	DWORD PTR 136[rbx], esi
	mov	DWORD PTR 8[rsp], ecx
	xor	esi, esi
	mov	DWORD PTR [rsp], edi
	mov	rcx, r13
	xor	edi, edi
	call	SET_BLENDER_INPUT@PLT
	mov	edx, DWORD PTR 84[rbx]
	mov	rbp, QWORD PTR blender2b_a@GOTPCREL[rip]
	mov	esi, 1
	mov	r8, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	rcx, QWORD PTR blender2a_g@GOTPCREL[rip]
	xor	edi, edi
	mov	DWORD PTR 8[rsp], edx
	mov	edx, DWORD PTR 76[rbx]
	mov	r9, rbp
	mov	DWORD PTR [rsp], edx
	mov	rdx, QWORD PTR blender2a_r@GOTPCREL[rip]
	call	SET_BLENDER_INPUT@PLT
	mov	edx, DWORD PTR 72[rbx]
	lea	r9, 8[r15]
	lea	r8, 8[r14]
	lea	rcx, 8[r13]
	xor	esi, esi
	mov	edi, 1
	mov	DWORD PTR 8[rsp], edx
	mov	edx, DWORD PTR 64[rbx]
	mov	DWORD PTR [rsp], edx
	lea	rdx, 8[r12]
	call	SET_BLENDER_INPUT@PLT
	mov	rax, QWORD PTR blender2a_b@GOTPCREL[rip]
	mov	edx, DWORD PTR 88[rbx]
	lea	r9, 8[rbp]
	mov	esi, 1
	mov	edi, 1
	lea	r8, 8[rax]
	mov	rax, QWORD PTR blender2a_g@GOTPCREL[rip]
	mov	DWORD PTR 8[rsp], edx
	mov	edx, DWORD PTR 80[rbx]
	lea	rcx, 8[rax]
	mov	rax, QWORD PTR blender2a_r@GOTPCREL[rip]
	mov	DWORD PTR [rsp], edx
	lea	rdx, 8[rax]
	call	SET_BLENDER_INPUT@PLT
	mov	DWORD PTR 144[rbx], 1
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
.LFE573:
	.size	set_other_modes, .-set_other_modes
	.p2align 4,,15
	.type	fill_rect, @function
fill_rect:
.LFB579:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r9, QWORD PTR clip@GOTPCREL[rip]
	lea	rdx, cmd_data[rip]
	mov	r8, QWORD PTR other_modes@GOTPCREL[rip]
	lea	rdi, cmd_data[rip+4]
	mov	r11d, 1
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pxor	xmm0, xmm0
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
	mov	eax, DWORD PTR [r9]
	mov	r8d, DWORD PTR [r8]
	add	eax, eax
	mov	DWORD PTR -52[rsp], eax
	mov	eax, DWORD PTR 8[r9]
	sal	r8d, 30
	sar	r8d, 31
	and	r8d, 3
	lea	esi, [rax+rax]
	movsx	rax, DWORD PTR cmd_cur[rip]
	mov	ecx, DWORD PTR [rdx+rax*8]
	mov	eax, DWORD PTR [rdi+rax*8]
	mov	edx, ecx
	and	ecx, 4095
	mov	edi, eax
	or	r8d, ecx
	mov	rcx, QWORD PTR max_level@GOTPCREL[rip]
	and	edx, 16773120
	and	edi, 16773120
	mov	r10d, eax
	and	r10d, 4095
	mov	DWORD PTR [rcx], 0
	lea	ecx, 0[0+rdx*4]
	shr	edx, 14
	sal	edx, 16
	movzx	ecx, cx
	or	ecx, edx
	lea	edx, 0[0+rdi*4]
	shr	edi, 14
	sal	edi, 16
	movzx	edx, dx
	or	edx, edi
	mov	rdi, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	movdqu	XMMWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	movdqu	XMMWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR spans_d_rgba_dy@GOTPCREL[rip]
	movdqu	XMMWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	movdqu	XMMWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR spans_cd_rgba@GOTPCREL[rip]
	movdqu	XMMWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR spans_cdz@GOTPCREL[rip]
	mov	DWORD PTR [rdi], 0
	mov	rdi, QWORD PTR spans_dzpix@GOTPCREL[rip]
	mov	WORD PTR [rdi], r11w
	mov	edi, DWORD PTR 4[r9]
	cmp	r8d, edi
	cmovle	edi, r8d
	sar	r8d, 2
	and	eax, 4092
	mov	ebx, edi
	or	ebx, 3
	mov	r11d, ebx
	sar	r11d, 2
	cmp	r8d, r11d
	jle	.L42
	mov	r14d, edi
	add	ebx, 4
	sar	r14d, 2
	mov	DWORD PTR -20[rsp], r14d
.L43:
	mov	r8d, DWORD PTR 12[r9]
	cmp	r10d, r8d
	cmovge	r8d, r10d
	cmp	ebx, eax
	mov	DWORD PTR -56[rsp], r8d
	jl	.L52
	mov	ebp, edx
	mov	r10d, ecx
	mov	r15d, r8d
	and	ebp, -2
	shr	r10d, 13
	and	r15d, -4
	mov	r9d, ebp
	sar	ebp, 16
	mov	r8d, r10d
	mov	DWORD PTR -24[rsp], ebp
	mov	rbp, QWORD PTR sckeepodd@GOTPCREL[rip]
	sar	r9d, 13
	sub	r8d, esi
	mov	r11d, r9d
	mov	DWORD PTR -76[rsp], r15d
	sub	r11d, esi
	shr	r8d, 31
	add	ebx, 1
	mov	r14d, DWORD PTR 0[rbp]
	mov	rbp, QWORD PTR scfield@GOTPCREL[rip]
	shr	r11d, 31
	mov	r15d, r8d
	mov	DWORD PTR -72[rsp], ebx
	and	r15d, r11d
	pxor	xmm0, xmm0
	mov	DWORD PTR -44[rsp], r15d
	mov	r15d, DWORD PTR 0[rbp]
	mov	ebp, eax
	sub	ebp, edi
	test	r11d, r11d
	mov	r11d, DWORD PTR -52[rsp]
	cmovne	r9d, esi
	mov	edi, ebp
	mov	DWORD PTR -16[rsp], r14d
	mov	ebx, r9d
	shr	r9d, 13
	mov	DWORD PTR -12[rsp], r15d
	and	ebx, 8191
	and	r9d, 1
	mov	r14d, DWORD PTR maxxmx.22063[rip]
	mov	DWORD PTR -48[rsp], ebx
	sub	ebx, r11d
	mov	r15d, DWORD PTR minxhx.22064[rip]
	mov	DWORD PTR -64[rsp], ebx
	not	DWORD PTR -64[rsp]
	not	edi
	shr	DWORD PTR -64[rsp], 31
	mov	ebp, 1
	or	DWORD PTR -64[rsp], r9d
	test	r8d, r8d
	cmove	esi, r10d
	or	ecx, 134217728
	or	edx, 134217728
	mov	ebx, esi
	shr	esi, 13
	and	ebx, 8191
	and	esi, 1
	mov	DWORD PTR -40[rsp], ebx
	sub	ebx, r11d
	mov	r11d, 1
	mov	DWORD PTR -60[rsp], ebx
	not	DWORD PTR -60[rsp]
	mov	ebx, 1
	shr	DWORD PTR -60[rsp], 31
	mov	DWORD PTR -32[rsp], ecx
	or	DWORD PTR -60[rsp], esi
	mov	esi, DWORD PTR -60[rsp]
	and	esi, DWORD PTR -64[rsp]
	mov	DWORD PTR -36[rsp], esi
	mov	DWORD PTR -28[rsp], edx
	jmp	.L53
	.p2align 4,,10
	.p2align 3
.L60:
	lea	rdx, [r8+r8*2]
	mov	ecx, DWORD PTR -24[rsp]
	sal	rdx, 5
	movdqa	XMMWORD PTR 16[rsi+rdx], xmm0
	mov	DWORD PTR 8[rsi+rdx], ecx
	movdqa	XMMWORD PTR 32[rsi+rdx], xmm0
.L45:
	add	eax, 1
	sub	edi, 1
	cmp	eax, DWORD PTR -72[rsp]
	je	.L59
.L53:
	cmp	eax, DWORD PTR -76[rsp]
	jl	.L45
	mov	ecx, eax
	sub	ecx, DWORD PTR -56[rsp]
	mov	esi, eax
	mov	r10d, eax
	sar	esi, 2
	mov	DWORD PTR -68[rsp], esi
	or	ecx, edi
	shr	ecx, 31
	and	r10d, 3
	jne	.L46
	mov	r15d, 4095
	xor	r14d, r14d
	mov	ebp, 1
	mov	ebx, 1
	mov	r11d, 1
.L46:
	mov	r12d, DWORD PTR -64[rsp]
	mov	r13d, DWORD PTR -52[rsp]
	movsx	rdx, r10d
	movsx	r8, DWORD PTR -68[rsp]
	mov	rsi, QWORD PTR span@GOTPCREL[rip]
	test	r12d, r12d
	mov	r12d, r13d
	cmove	r12d, DWORD PTR -48[rsp]
	lea	r9, [r8+r8*2]
	lea	r9, [rdx+r9*8]
	mov	edx, r12d
	and	edx, 8191
	mov	DWORD PTR 48[rsi+r9*4], edx
	mov	edx, DWORD PTR -60[rsp]
	test	edx, edx
	cmove	r13d, DWORD PTR -40[rsp]
	and	r11d, DWORD PTR -36[rsp]
	and	ebx, DWORD PTR -44[rsp]
	mov	edx, r13d
	and	edx, 8191
	mov	DWORD PTR 64[rsi+r9*4], edx
	mov	edx, DWORD PTR -28[rsp]
	cmp	DWORD PTR -32[rsp], edx
	setl	dl
	movzx	edx, dl
	or	edx, ecx
	and	ebp, edx
	test	edx, edx
	mov	DWORD PTR 80[rsi+r9*4], edx
	jne	.L49
	sar	r13d, 3
	and	r13d, 4095
	cmp	r13d, r14d
	cmovge	r14d, r13d
	sar	r12d, 3
	and	r12d, 4095
	cmp	r12d, r15d
	cmovle	r15d, r12d
.L49:
	test	r10d, r10d
	je	.L60
	cmp	r10d, 3
	jne	.L45
	lea	rdx, [r8+r8*2]
	mov	ecx, DWORD PTR -68[rsp]
	xor	ecx, DWORD PTR -16[rsp]
	and	ecx, DWORD PTR -12[rsp]
	add	eax, 1
	sub	edi, 1
	sal	rdx, 5
	add	rsi, rdx
	mov	edx, ebx
	or	edx, ebp
	mov	DWORD PTR [rsi], r14d
	mov	DWORD PTR 4[rsi], r15d
	or	edx, ecx
	or	edx, r11d
	xor	edx, 1
	cmp	eax, DWORD PTR -72[rsp]
	mov	DWORD PTR 12[rsi], edx
	jne	.L53
	.p2align 4,,10
	.p2align 3
.L59:
	mov	DWORD PTR maxxmx.22063[rip], r14d
	mov	DWORD PTR minxhx.22064[rip], r15d
.L52:
	mov	edi, DWORD PTR -56[rsp]
	mov	esi, DWORD PTR -20[rsp]
	mov	ecx, 1
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
	sar	edi, 2
	xor	edx, edx
	jmp	render_spans
	.p2align 4,,10
	.p2align 3
.L42:
	.cfi_restore_state
	mov	r15d, edi
	sar	r15d, 2
	cmp	r15d, 1022
	mov	DWORD PTR -20[rsp], r15d
	ja	.L43
	lea	r8d, 1[r15]
	movsx	r8, r8d
	lea	r8, [r8+r8*2]
	sal	r8, 5
	add	r8, QWORD PTR span@GOTPCREL[rip]
	mov	DWORD PTR 12[r8], 0
	jmp	.L43
	.cfi_endproc
.LFE579:
	.size	fill_rect, .-fill_rect
	.p2align 4,,15
	.type	draw_triangle, @function
draw_triangle:
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
	sub	rsp, 328
	.cfi_def_cfa_offset 384
	mov	rax, QWORD PTR clip@GOTPCREL[rip]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 72[rsp], eax
	mov	rax, QWORD PTR clip@GOTPCREL[rip]
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR 76[rsp], eax
	movzx	eax, BYTE PTR triangle_count.22157[rip]
	lea	ecx, 1[rax]
	mov	BYTE PTR triangle_count.22157[rip], cl
	mov	rcx, QWORD PTR cfg@GOTPCREL[rip]
	cmp	al, BYTE PTR 15[rcx]
	jb	.L61
	mov	eax, DWORD PTR cmd_cur[rip]
	lea	rcx, cmd_data[rip]
	lea	r14, cmd_data[rip+4]
	mov	r11, QWORD PTR max_level@GOTPCREL[rip]
	mov	BYTE PTR triangle_count.22157[rip], 0
	mov	QWORD PTR 112[rsp], 0
	mov	QWORD PTR 120[rsp], 0
	movsx	r9, eax
	mov	QWORD PTR 64[rsp], 0
	mov	QWORD PTR 128[rsp], 0
	mov	r8d, DWORD PTR [rcx+r9*8]
	mov	QWORD PTR 136[rsp], 0
	mov	QWORD PTR 144[rsp], 0
	mov	QWORD PTR 88[rsp], 0
	mov	QWORD PTR 152[rsp], 0
	mov	ebx, r8d
	mov	r10d, r8d
	and	ebx, 8388608
	and	r10d, 3670016
	mov	DWORD PTR 104[rsp], ebx
	mov	ebx, r8d
	sal	r8d, 18
	mov	DWORD PTR 20[rsp], r8d
	mov	r8d, DWORD PTR [r14+r9*8]
	and	ebx, 458752
	mov	DWORD PTR 108[rsp], ebx
	shr	r10d, 19
	shr	DWORD PTR 104[rsp], 23
	shr	DWORD PTR 108[rsp], 16
	mov	DWORD PTR [r11], r10d
	lea	ebx, 0[0+r8*4]
	sal	r8d, 18
	sar	DWORD PTR 20[rsp], 18
	mov	DWORD PTR 32[rsp], r8d
	lea	r8d, 1[rax]
	movsx	r8, r8d
	mov	DWORD PTR 24[rsp], ebx
	mov	ebx, DWORD PTR [rcx+r8*8]
	sar	DWORD PTR 24[rsp], 18
	sar	DWORD PTR 32[rsp], 18
	mov	DWORD PTR 36[rsp], ebx
	sal	DWORD PTR 36[rsp], 4
	sar	DWORD PTR 36[rsp], 4
	mov	r8d, DWORD PTR [r14+r8*8]
	lea	ebx, 0[0+r8*4]
	lea	r8d, 2[rax]
	movsx	r8, r8d
	mov	DWORD PTR 52[rsp], ebx
	sar	DWORD PTR 52[rsp], 2
	mov	r13d, DWORD PTR [rcx+r8*8]
	mov	r8d, DWORD PTR [r14+r8*8]
	lea	ebx, 0[0+r8*4]
	lea	r8d, 3[rax]
	sal	r13d, 4
	sar	r13d, 4
	movsx	r8, r8d
	mov	DWORD PTR 28[rsp], ebx
	sar	DWORD PTR 28[rsp], 2
	mov	r15d, DWORD PTR [rcx+r8*8]
	mov	r8d, DWORD PTR [r14+r8*8]
	lea	ebx, 0[0+r8*4]
	sal	r15d, 4
	sar	r15d, 4
	mov	DWORD PTR 48[rsp], ebx
	sar	DWORD PTR 48[rsp], 2
	test	edi, edi
	je	.L94
	lea	edi, 8[rax]
	lea	r12d, 4[rax]
	lea	ebx, 5[rax]
	lea	ebp, 6[rax]
	lea	r11d, 7[rax]
	lea	r8d, 9[rax]
	lea	r9d, 10[rax]
	add	eax, 11
	movsx	r12, r12d
	cdqe
	movsx	rbx, ebx
	movsx	rbp, ebp
	pshufw	mm0, QWORD PTR [rcx+rax*8], 177
	movsx	r11, r11d
	movsx	r10, edi
	movsx	r8, r8d
	movsx	r9, r9d
	pshufw	mm5, QWORD PTR [rcx+r12*8], 177
	pshufw	mm6, QWORD PTR [rcx+rbp*8], 177
	pshufw	mm3, QWORD PTR [rcx+rbx*8], 177
	mov	eax, edi
	pshufw	mm4, QWORD PTR [rcx+r11*8], 177
	pshufw	mm1, QWORD PTR [rcx+r10*8], 177
	movq	QWORD PTR 8[rsp], mm0
	pshufw	mm2, QWORD PTR [rcx+r9*8], 177
	pshufw	mm7, QWORD PTR [rcx+r8*8], 177
.L63:
	movq	mm0, mm6
	punpcklwd	mm6, mm5
	test	esi, esi
	lea	edi, -8[rax]
	punpckhwd	mm0, mm5
	movq	mm5, mm4
	movq	QWORD PTR 192[rsp], mm6
	punpcklwd	mm4, mm3
	movq	QWORD PTR 40[rsp], mm0
	punpckhwd	mm5, mm3
	movq	mm3, mm2
	movq	mm0, QWORD PTR 8[rsp]
	punpcklwd	mm2, mm1
	mov	rbx, QWORD PTR 40[rsp]
	punpckhwd	mm3, mm1
	movq	QWORD PTR 56[rsp], mm5
	movq	mm1, mm0
	punpcklwd	mm0, mm7
	movq	QWORD PTR 40[rsp], mm4
	mov	QWORD PTR 200[rsp], rbx
	movq	QWORD PTR 216[rsp], mm3
	punpckhwd	mm1, mm7
	movq	QWORD PTR 208[rsp], mm2
	movq	QWORD PTR 96[rsp], mm0
	movq	QWORD PTR 8[rsp], mm1
	jne	.L64
.L65:
	lea	esi, -16[rax]
	test	edx, edx
	mov	eax, edi
	pxor	mm0, mm0
	mov	QWORD PTR 80[rsp], 0
	pxor	mm2, mm2
	mov	edi, esi
	pxor	mm1, mm1
	pxor	mm4, mm4
	pxor	mm3, mm3
	pxor	mm6, mm6
	pxor	mm5, mm5
	jne	.L66
.L127:
	mov	rax, QWORD PTR 64[rsp]
	shr	rax, 48
	mov	rbx, rax
	mov	rax, QWORD PTR 88[rsp]
	shr	rax, 48
	mov	rbp, rax
	mov	eax, edi
.L67:
	mov	rcx, QWORD PTR 40[rsp]
	mov	rsi, QWORD PTR 56[rsp]
	movq	mm7, mm6
	punpcklwd	mm6, mm5
	mov	rdx, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	punpckhwd	mm7, mm5
	movq	mm5, mm4
	punpcklwd	mm4, mm3
	mov	r9d, ecx
	mov	edi, esi
	sar	rcx, 32
	sar	rsi, 32
	and	r9d, -32
	movq	QWORD PTR 88[rsp], mm4
	mov	QWORD PTR 112[rsp], rcx
	mov	r12, QWORD PTR 88[rsp]
	mov	r8d, ecx
	mov	ecx, esi
	and	edi, -32
	and	r8d, -32
	and	ecx, -32
	mov	DWORD PTR [rdx], r9d
	mov	DWORD PTR 4[rdx], r8d
	mov	DWORD PTR 8[rdx], edi
	punpckhwd	mm5, mm3
	mov	DWORD PTR 12[rdx], ecx
	mov	rdx, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	movq	mm3, mm2
	mov	QWORD PTR 120[rsp], rsi
	mov	esi, r12d
	movq	QWORD PTR 64[rsp], mm5
	and	esi, -32
	mov	QWORD PTR 136[rsp], r12
	movq	QWORD PTR 232[rsp], mm7
	mov	DWORD PTR [rdx], esi
	mov	rsi, r12
	punpckhwd	mm3, mm1
	mov	r12, QWORD PTR 64[rsp]
	sar	rsi, 32
	punpcklwd	mm2, mm1
	mov	QWORD PTR 128[rsp], rsi
	and	esi, -32
	movq	mm7, QWORD PTR 80[rsp]
	mov	DWORD PTR 4[rdx], esi
	movq	mm1, mm0
	movq	QWORD PTR 224[rsp], mm6
	mov	esi, r12d
	sar	r12, 32
	punpcklwd	mm0, mm7
	and	esi, -32
	mov	DWORD PTR 12[rdx], r12d
	punpckhwd	mm1, mm7
	mov	DWORD PTR 8[rdx], esi
	mov	rdx, QWORD PTR 96[rsp]
	movq	QWORD PTR 248[rsp], mm3
	movq	QWORD PTR 80[rsp], mm1
	mov	r10, QWORD PTR 80[rsp]
	sal	r9d, 5
	movq	QWORD PTR 80[rsp], mm0
	mov	r11, QWORD PTR 80[rsp]
	sal	r8d, 5
	mov	rsi, rdx
	sal	rdx, 37
	movq	QWORD PTR 240[rsp], mm2
	sar	rsi, 32
	sar	rdx, 51
	sal	edi, 5
	mov	QWORD PTR 80[rsp], rsi
	sal	ecx, 5
	sar	edi, 19
	mov	rsi, QWORD PTR 8[rsp]
	sar	ecx, 19
	sar	r9d, 19
	sar	r8d, 19
	sar	rsi, 32
	mov	QWORD PTR 88[rsp], rsi
	mov	rsi, QWORD PTR spans_d_rgba_dy@GOTPCREL[rip]
	mov	DWORD PTR [rsi], edx
	mov	edx, DWORD PTR 80[rsp]
	sar	edx, 14
	sal	edx, 19
	sar	edx, 19
	mov	DWORD PTR 4[rsi], edx
	mov	rdx, QWORD PTR 8[rsp]
	sal	rdx, 37
	sar	rdx, 51
	mov	DWORD PTR 8[rsi], edx
	mov	edx, DWORD PTR 88[rsp]
	sar	edx, 14
	sal	edx, 19
	sar	edx, 19
	mov	DWORD PTR 12[rsi], edx
	mov	rdx, QWORD PTR spans_cd_rgba@GOTPCREL[rip]
	mov	rsi, r10
	mov	DWORD PTR [rdx], r9d
	mov	DWORD PTR 8[rdx], edi
	mov	rdi, r11
	mov	DWORD PTR 12[rdx], ecx
	mov	DWORD PTR 4[rdx], r8d
	mov	ecx, r12d
	mov	rdx, QWORD PTR spans_cdz@GOTPCREL[rip]
	sar	ecx, 10
	mov	DWORD PTR [rdx], ecx
	mov	rdx, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	mov	ecx, r11d
	and	ecx, -32768
	sar	rdi, 32
	sar	rsi, 32
	mov	DWORD PTR [rdx], ecx
	mov	ecx, edi
	and	ecx, -32768
	mov	DWORD PTR 4[rdx], ecx
	mov	ecx, r10d
	and	ecx, -32768
	mov	DWORD PTR 8[rdx], ecx
	mov	ecx, esi
	sar	ecx, 10
	mov	DWORD PTR 12[rdx], ecx
	mov	edx, ebp
	mov	ecx, ebx
	sar	dx, 15
	sar	cx, 15
	xor	ecx, ebx
	xor	edx, ebp
	add	edx, ecx
	mov	ecx, edx
	and	cx, -16384
	je	.L121
	mov	ecx, -32768
.L68:
	sub	eax, 6
	mov	rdx, QWORD PTR spans_dzpix@GOTPCREL[rip]
	cdqe
	mov	eax, DWORD PTR [r14+rax*8]
	mov	WORD PTR [rdx], cx
	shr	eax, 31
	cmp	DWORD PTR 104[rsp], eax
	je	.L71
	pxor	xmm0, xmm0
	movdqa	XMMWORD PTR 288[rsp], xmm0
	movdqa	XMMWORD PTR 304[rsp], xmm0
.L72:
	mov	rdx, QWORD PTR other_modes@GOTPCREL[rip]
	cmp	DWORD PTR [rdx], 2
	je	.L122
	movd	xmm6, DWORD PTR 120[rsp]
	mov	DWORD PTR 8[rsp], r12d
	movd	xmm1, DWORD PTR 56[rsp]
	movd	xmm0, DWORD PTR 40[rsp]
	movd	xmm7, DWORD PTR 112[rsp]
	punpckldq	xmm1, xmm6
	movd	xmm2, DWORD PTR 64[rsp]
	punpckldq	xmm0, xmm7
	movd	xmm4, DWORD PTR 8[rsp]
	movd	xmm6, DWORD PTR 128[rsp]
	punpckldq	xmm2, xmm4
	punpcklqdq	xmm0, xmm1
	movdqa	xmm1, XMMWORD PTR .LC1[rip]
	psrad	xmm0, 8
	pand	xmm0, xmm1
	movdqa	XMMWORD PTR 256[rsp], xmm0
	movd	xmm0, DWORD PTR 136[rsp]
	punpckldq	xmm0, xmm6
	punpcklqdq	xmm0, xmm2
	psrad	xmm0, 8
	pand	xmm0, xmm1
	movdqa	XMMWORD PTR 272[rsp], xmm0
.L74:
	cmp	DWORD PTR 104[rsp], eax
	mov	ecx, DWORD PTR 20[rsp]
	sete	al
	movzx	eax, al
	lea	eax, [rax+rax*2]
	mov	DWORD PTR 96[rsp], eax
	mov	rax, QWORD PTR clip@GOTPCREL[rip]
	mov	edi, DWORD PTR 4[rax]
	mov	eax, DWORD PTR 32[rsp]
	cmp	ecx, edi
	cmovs	edi, ecx
	sar	ecx, 2
	and	eax, -4
	mov	esi, edi
	or	esi, 3
	mov	edx, esi
	sar	edx, 2
	cmp	ecx, edx
	jle	.L77
	mov	ebx, edi
	add	esi, 4
	sar	ebx, 2
	mov	DWORD PTR 112[rsp], ebx
.L78:
	mov	rcx, QWORD PTR clip@GOTPCREL[rip]
	mov	ebx, DWORD PTR 32[rsp]
	mov	edx, DWORD PTR 12[rcx]
	mov	ecx, r15d
	cmp	ebx, edx
	cmovns	edx, ebx
	mov	ebx, DWORD PTR 48[rsp]
	and	ecx, -2
	mov	DWORD PTR 32[rsp], edx
	mov	edx, r13d
	mov	DWORD PTR 160[rsp], ecx
	and	edx, -2
	sar	ebx, 2
	mov	DWORD PTR 164[rsp], edx
	mov	DWORD PTR 20[rsp], ebx
	mov	ebx, DWORD PTR 28[rsp]
	and	DWORD PTR 20[rsp], -2
	sar	ebx, 2
	mov	DWORD PTR 28[rsp], ebx
	and	DWORD PTR 28[rsp], -2
	cmp	esi, eax
	jl	.L92
	mov	ebx, DWORD PTR 72[rsp]
	add	esi, 1
	mov	r13d, edx
	mov	edx, 1
	mov	r12d, ecx
	mov	ecx, r13d
	mov	DWORD PTR 72[rsp], edx
	add	ebx, ebx
	mov	DWORD PTR 48[rsp], ebx
	mov	ebx, DWORD PTR 76[rsp]
	mov	DWORD PTR 76[rsp], 1
	add	ebx, ebx
	mov	DWORD PTR 40[rsp], ebx
	mov	ebx, DWORD PTR 32[rsp]
	and	ebx, -4
	mov	DWORD PTR 56[rsp], ebx
	mov	ebx, DWORD PTR 52[rsp]
	mov	DWORD PTR 52[rsp], esi
	mov	esi, DWORD PTR 36[rsp]
	sar	ebx, 2
	mov	DWORD PTR 120[rsp], ebx
	mov	ebx, eax
	and	esi, -2
	sub	ebx, edi
	mov	DWORD PTR 128[rsp], esi
	mov	edi, 1
	mov	DWORD PTR 8[rsp], ebx
	mov	ebx, DWORD PTR 104[rsp]
	mov	r13d, edi
	and	DWORD PTR 120[rsp], -2
	not	DWORD PTR 8[rsp]
	sub	edx, ebx
	movsx	rsi, edx
	mov	QWORD PTR 80[rsp], rsi
	movsx	rsi, ebx
	mov	QWORD PTR 88[rsp], rsi
	jmp	.L93
	.p2align 4,,10
	.p2align 3
.L126:
	mov	r9d, eax
	sub	r9d, DWORD PTR 32[rsp]
	mov	ebx, eax
	or	r9d, DWORD PTR 8[rsp]
	sar	ebx, 2
	mov	DWORD PTR 36[rsp], ebx
	shr	r9d, 31
	test	esi, esi
	jne	.L83
	mov	DWORD PTR minmax.22230[rip+4], 0
	mov	DWORD PTR minmax.22230[rip], 4095
	mov	r13d, 1
	mov	DWORD PTR 72[rsp], 1
	mov	DWORD PTR 76[rsp], 1
.L83:
	mov	edi, ecx
	mov	r11d, ecx
	mov	r8d, DWORD PTR 40[rsp]
	and	edi, 16383
	sar	r11d, 13
	mov	r14d, ecx
	neg	edi
	mov	edx, r11d
	shr	r14d, 27
	shr	edi, 31
	and	edx, 8190
	and	r14d, 1
	or	edx, edi
	sub	edx, r8d
	shr	edx, 31
	or	edx, r14d
	mov	DWORD PTR 64[rsp], edx
	jne	.L84
	mov	r8d, r11d
	and	r8d, 16382
	or	r8d, edi
.L84:
	mov	edi, DWORD PTR 48[rsp]
	mov	ebx, r8d
	mov	r15d, r8d
	and	ebx, 8191
	movsx	r8, DWORD PTR 36[rsp]
	shr	r15d, 13
	mov	edx, ebx
	and	r15d, 1
	mov	r14, QWORD PTR span@GOTPCREL[rip]
	sub	edx, edi
	movsx	rbp, esi
	mov	r11d, DWORD PTR 40[rsp]
	not	edx
	mov	r10d, r12d
	shr	edx, 31
	or	r15d, edx
	lea	rdx, [r8+r8*2]
	cmovne	ebx, edi
	and	r15d, r13d
	mov	r13d, r12d
	lea	rdx, 12[rbp+rdx*8]
	mov	edi, ebx
	sar	r13d, 13
	and	edi, 8191
	shr	r10d, 27
	mov	DWORD PTR 180[rsp], ebx
	mov	DWORD PTR [r14+rdx*4], edi
	mov	edi, r12d
	mov	edx, r13d
	and	edi, 16383
	and	edx, 8190
	and	r10d, 1
	neg	edi
	shr	edi, 31
	or	edx, edi
	sub	edx, r11d
	shr	edx, 31
	or	edx, r10d
	jne	.L86
	mov	r11d, r13d
	and	r11d, 16382
	or	r11d, edi
.L86:
	mov	r13d, DWORD PTR 48[rsp]
	mov	r10d, r11d
	shr	r11d, 13
	and	r10d, 8191
	and	r11d, 1
	mov	edi, r10d
	sub	edi, r13d
	not	edi
	shr	edi, 31
	or	r11d, edi
	lea	rdi, [r8+r8*2]
	cmovne	r10d, r13d
	and	edx, DWORD PTR 64[rsp]
	and	r15d, r11d
	and	DWORD PTR 76[rsp], edx
	mov	rdx, QWORD PTR 80[rsp]
	lea	rdi, 0[rbp+rdi*8]
	mov	ebp, r10d
	mov	DWORD PTR 176[rsp], r10d
	mov	r13d, r15d
	and	ebp, 8191
	mov	r11d, DWORD PTR 160[rsp+rdx*4]
	mov	rdx, QWORD PTR 88[rsp]
	mov	DWORD PTR 64[r14+rdi*4], ebp
	and	r11d, 268419072
	mov	edx, DWORD PTR 160[rsp+rdx*4]
	xor	r11d, 134217728
	and	edx, 268419072
	xor	edx, 134217728
	cmp	r11d, edx
	setl	dl
	movzx	edx, dl
	or	edx, r9d
	and	DWORD PTR 72[rsp], edx
	test	edx, edx
	mov	DWORD PTR 80[r14+rdi*4], edx
	jne	.L88
	sar	ebx, 3
	sar	r10d, 3
	mov	edx, DWORD PTR minmax.22230[rip]
	and	ebx, 4095
	and	r10d, 4095
	mov	DWORD PTR 180[rsp], ebx
	mov	rbx, QWORD PTR 88[rsp]
	mov	DWORD PTR 176[rsp], r10d
	cmp	DWORD PTR 176[rsp+rbx*4], edx
	cmovle	edx, DWORD PTR 176[rsp+rbx*4]
	mov	rbx, QWORD PTR 80[rsp]
	mov	DWORD PTR minmax.22230[rip], edx
	mov	edx, DWORD PTR minmax.22230[rip+4]
	cmp	DWORD PTR 176[rsp+rbx*4], edx
	cmovge	edx, DWORD PTR 176[rsp+rbx*4]
	mov	DWORD PTR minmax.22230[rip+4], edx
.L88:
	cmp	DWORD PTR 96[rsp], esi
	je	.L123
.L89:
	cmp	esi, 3
	je	.L124
.L90:
	add	r12d, DWORD PTR 20[rsp]
	add	ecx, DWORD PTR 28[rsp]
	add	eax, 1
	sub	DWORD PTR 8[rsp], 1
	cmp	eax, DWORD PTR 52[rsp]
	mov	DWORD PTR 160[rsp], r12d
	mov	DWORD PTR 164[rsp], ecx
	je	.L92
.L93:
	mov	esi, eax
	and	esi, 3
	cmp	eax, DWORD PTR 24[rsp]
	je	.L125
.L81:
	cmp	eax, DWORD PTR 56[rsp]
	jge	.L126
	cmp	esi, 3
	jne	.L90
.L91:
	movdqa	xmm0, XMMWORD PTR 192[rsp]
	paddd	xmm0, XMMWORD PTR 208[rsp]
	movdqa	XMMWORD PTR 192[rsp], xmm0
	movdqa	xmm0, XMMWORD PTR 224[rsp]
	paddd	xmm0, XMMWORD PTR 240[rsp]
	movdqa	XMMWORD PTR 224[rsp], xmm0
	jmp	.L90
	.p2align 4,,10
	.p2align 3
.L92:
	mov	edi, DWORD PTR 32[rsp]
	mov	ecx, DWORD PTR 104[rsp]
	mov	edx, DWORD PTR 108[rsp]
	mov	esi, DWORD PTR 112[rsp]
	sar	edi, 2
	call	render_spans
	emms
.L61:
	add	rsp, 328
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
.L94:
	.cfi_restore_state
	mov	QWORD PTR 8[rsp], 0
	pxor	mm7, mm7
	pxor	mm2, mm2
	pxor	mm1, mm1
	pxor	mm4, mm4
	pxor	mm3, mm3
	pxor	mm6, mm6
	pxor	mm5, mm5
	jmp	.L63
	.p2align 4,,10
	.p2align 3
.L124:
	mov	rsi, QWORD PTR sckeepodd@GOTPCREL[rip]
	mov	ebx, DWORD PTR 36[rsp]
	mov	rdi, QWORD PTR scfield@GOTPCREL[rip]
	mov	edx, DWORD PTR 76[rsp]
	or	edx, DWORD PTR 72[rsp]
	xor	ebx, DWORD PTR [rsi]
	mov	esi, ebx
	and	esi, DWORD PTR [rdi]
	mov	rbx, QWORD PTR 88[rsp]
	lea	rdi, minmax.22230[rip]
	or	edx, esi
	lea	rsi, [r8+r8*2]
	mov	r8d, DWORD PTR [rdi+rbx*4]
	mov	rbx, QWORD PTR 80[rsp]
	or	edx, r13d
	sal	rsi, 5
	xor	edx, 1
	add	rsi, r14
	mov	edi, DWORD PTR [rdi+rbx*4]
	mov	DWORD PTR [rsi], r8d
	mov	DWORD PTR 12[rsi], edx
	mov	DWORD PTR 4[rsi], edi
	jmp	.L91
	.p2align 4,,10
	.p2align 3
.L123:
	movzx	ebx, ch
	movdqa	xmm0, XMMWORD PTR 256[rsp]
	mov	DWORD PTR 64[rsp], ebx
	lea	rdx, [r8+r8*2]
	mov	edi, ecx
	movd	xmm5, DWORD PTR 64[rsp]
	movdqa	xmm2, xmm0
	psrlq	xmm0, 32
	sal	rdx, 5
	sar	edi, 16
	pshufd	xmm1, xmm5, 0
	mov	DWORD PTR 8[r14+rdx], edi
	pmuludq	xmm2, xmm1
	pmuludq	xmm0, xmm1
	pshufd	xmm2, xmm2, 216
	pshufd	xmm0, xmm0, 216
	punpckldq	xmm2, xmm0
	movdqa	xmm0, XMMWORD PTR 192[rsp]
	psrld	xmm0, 9
	pslld	xmm0, 9
	paddd	xmm0, XMMWORD PTR 288[rsp]
	psubd	xmm0, xmm2
	psrld	xmm0, 10
	pslld	xmm0, 10
	movdqa	XMMWORD PTR 16[r14+rdx], xmm0
	movdqa	xmm0, XMMWORD PTR 272[rsp]
	movdqa	xmm2, xmm0
	psrlq	xmm0, 32
	pmuludq	xmm2, xmm1
	pmuludq	xmm1, xmm0
	pshufd	xmm2, xmm2, 216
	pshufd	xmm1, xmm1, 216
	movdqa	xmm0, XMMWORD PTR 224[rsp]
	psrld	xmm0, 9
	pslld	xmm0, 9
	paddd	xmm0, XMMWORD PTR 304[rsp]
	punpckldq	xmm2, xmm1
	psubd	xmm0, xmm2
	psrld	xmm0, 10
	pslld	xmm0, 10
	movdqa	XMMWORD PTR 32[r14+rdx], xmm0
	jmp	.L89
	.p2align 4,,10
	.p2align 3
.L64:
	lea	r12d, 4[rax]
	lea	ebp, 5[rax]
	lea	ebx, 6[rax]
	lea	r11d, 7[rax]
	lea	r10d, 8[rax]
	lea	r9d, 9[rax]
	movsx	r12, r12d
	movsx	rbp, ebp
	movsx	rbx, ebx
	pshufw	mm0, QWORD PTR [rcx+r12*8], 177
	movsx	r11, r11d
	movsx	r10, r10d
	movsx	r9, r9d
	lea	r8d, 10[rax]
	lea	esi, 11[rax]
	test	edx, edx
	movq	mm5, mm0
	movq	QWORD PTR 112[rsp], mm0
	pshufw	mm0, QWORD PTR [rcx+rbp*8], 177
	movsx	r8, r8d
	movsx	rsi, esi
	pshufw	mm7, QWORD PTR [rcx+rsi*8], 177
	movq	mm3, mm0
	movq	QWORD PTR 64[rsp], mm0
	pshufw	mm0, QWORD PTR [rcx+rbx*8], 177
	movq	QWORD PTR 152[rsp], mm7
	movq	mm6, mm0
	movq	QWORD PTR 120[rsp], mm0
	pshufw	mm0, QWORD PTR [rcx+r11*8], 177
	movq	mm4, mm0
	movq	QWORD PTR 128[rsp], mm0
	pshufw	mm0, QWORD PTR [rcx+r10*8], 177
	movq	mm1, mm0
	movq	QWORD PTR 136[rsp], mm0
	pshufw	mm0, QWORD PTR [rcx+r9*8], 177
	movq	QWORD PTR 80[rsp], mm0
	movq	QWORD PTR 88[rsp], mm0
	pshufw	mm0, QWORD PTR [rcx+r8*8], 177
	movq	mm2, mm0
	movq	QWORD PTR 144[rsp], mm0
	movq	mm0, mm7
	je	.L127
.L66:
	lea	esi, 12[rax]
	mov	r11, QWORD PTR 112[rsp]
	mov	r10, QWORD PTR 120[rsp]
	movabs	rdx, 281474976710655
	lea	ebp, 13[rax]
	mov	r9, QWORD PTR 64[rsp]
	movsx	rsi, esi
	mov	edi, DWORD PTR [rcx+rsi*8]
	mov	esi, DWORD PTR [r14+rsi*8]
	and	r11, rdx
	movsx	rbp, ebp
	and	r10, rdx
	and	r9, rdx
	mov	ecx, DWORD PTR [rcx+rbp*8]
	mov	r12d, DWORD PTR [r14+rbp*8]
	mov	r8d, edi
	mov	ebx, esi
	sal	rdi, 48
	shr	r8d, 16
	shr	ebx, 16
	or	r10, rdi
	sal	r8, 48
	mov	rdi, rbx
	sal	rsi, 48
	or	r11, r8
	mov	r8, QWORD PTR 128[rsp]
	sal	rdi, 48
	or	r9, rdi
	mov	rdi, QWORD PTR 136[rsp]
	mov	ebp, r12d
	shr	ebp, 16
	sal	r12, 48
	and	r8, rdx
	or	r8, rsi
	mov	esi, ecx
	and	rdi, rdx
	shr	esi, 16
	sal	rcx, 48
	sal	rsi, 48
	or	rdi, rsi
	mov	rsi, QWORD PTR 144[rsp]
	and	rsi, rdx
	or	rsi, rcx
	mov	rcx, rbp
	sal	rcx, 48
	mov	QWORD PTR 64[rsp], rcx
	mov	rcx, QWORD PTR 88[rsp]
	and	rcx, rdx
	or	rcx, QWORD PTR 64[rsp]
	mov	QWORD PTR 64[rsp], r11
	movq	mm5, QWORD PTR 64[rsp]
	and	rdx, QWORD PTR 152[rsp]
	mov	QWORD PTR 64[rsp], r10
	movq	mm6, QWORD PTR 64[rsp]
	mov	QWORD PTR 64[rsp], r9
	movq	mm3, QWORD PTR 64[rsp]
	mov	QWORD PTR 64[rsp], r8
	movq	mm4, QWORD PTR 64[rsp]
	mov	QWORD PTR 64[rsp], rdi
	or	rdx, r12
	movq	mm1, QWORD PTR 64[rsp]
	mov	QWORD PTR 64[rsp], rsi
	movq	mm2, QWORD PTR 64[rsp]
	mov	QWORD PTR 64[rsp], rdx
	mov	QWORD PTR 80[rsp], rcx
	movq	mm0, QWORD PTR 64[rsp]
	jmp	.L67
	.p2align 4,,10
	.p2align 3
.L77:
	mov	ecx, edi
	sar	ecx, 2
	cmp	ecx, 1022
	mov	DWORD PTR 112[rsp], ecx
	ja	.L78
	lea	edx, 1[rcx]
	movsx	rdx, edx
	lea	rdx, [rdx+rdx*2]
	sal	rdx, 5
	add	rdx, QWORD PTR span@GOTPCREL[rip]
	mov	DWORD PTR 12[rdx], 0
	jmp	.L78
	.p2align 4,,10
	.p2align 3
.L121:
	test	dx, dx
	je	.L96
	cmp	dx, 1
	je	.L97
	test	dh, 32
	jne	.L98
	test	dh, 16
	jne	.L99
	test	dh, 8
	.p2align 4,,2
	jne	.L100
	test	dh, 4
	.p2align 4,,2
	jne	.L101
	test	dh, 2
	.p2align 4,,2
	jne	.L102
	test	dh, 1
	.p2align 4,,2
	jne	.L103
	test	dl, -128
	.p2align 4,,2
	jne	.L104
	test	dl, 64
	.p2align 4,,2
	jne	.L105
	test	dl, 32
	.p2align 4,,2
	jne	.L106
	test	dl, 16
	.p2align 4,,2
	jne	.L107
	test	dl, 8
	.p2align 4,,2
	jne	.L108
	test	dl, 4
	.p2align 4,,2
	jne	.L109
	test	dl, 2
	.p2align 4,,2
	jne	.L110
	and	edx, 1
	.p2align 4,,2
	je	.L68
	mov	ecx, 1
	add	ecx, ecx
	jmp	.L68
	.p2align 4,,10
	.p2align 3
.L96:
	mov	ecx, 1
	jmp	.L68
	.p2align 4,,10
	.p2align 3
.L122:
	pxor	xmm0, xmm0
	movdqa	XMMWORD PTR 256[rsp], xmm0
	movdqa	XMMWORD PTR 272[rsp], xmm0
	jmp	.L74
	.p2align 4,,10
	.p2align 3
.L71:
	movd	xmm4, DWORD PTR 8[rsp]
	mov	DWORD PTR 8[rsp], r10d
	movd	xmm7, DWORD PTR 88[rsp]
	movd	xmm3, DWORD PTR 96[rsp]
	punpckldq	xmm4, xmm7
	movd	xmm7, DWORD PTR 80[rsp]
	movdqa	xmm1, XMMWORD PTR .LC0[rip]
	punpckldq	xmm3, xmm7
	movdqa	xmm2, XMMWORD PTR 208[rsp]
	punpcklqdq	xmm3, xmm4
	pand	xmm2, xmm1
	movdqa	xmm0, XMMWORD PTR 240[rsp]
	pand	xmm3, xmm1
	pand	xmm0, xmm1
	psubd	xmm2, xmm3
	movdqa	xmm3, xmm2
	psrad	xmm3, 2
	psubd	xmm2, xmm3
	movd	xmm3, DWORD PTR 8[rsp]
	mov	DWORD PTR 8[rsp], esi
	movd	xmm7, DWORD PTR 8[rsp]
	mov	DWORD PTR 8[rsp], r11d
	movdqa	XMMWORD PTR 288[rsp], xmm2
	punpckldq	xmm3, xmm7
	movd	xmm2, DWORD PTR 8[rsp]
	mov	DWORD PTR 8[rsp], edi
	movd	xmm5, DWORD PTR 8[rsp]
	punpckldq	xmm2, xmm5
	punpcklqdq	xmm2, xmm3
	pand	xmm2, xmm1
	psubd	xmm0, xmm2
	movdqa	xmm1, xmm0
	psrad	xmm1, 2
	psubd	xmm0, xmm1
	movdqa	XMMWORD PTR 304[rsp], xmm0
	jmp	.L72
.L97:
	mov	ecx, 3
	jmp	.L68
.L105:
	mov	ecx, 64
	add	ecx, ecx
	jmp	.L68
.L98:
	mov	ecx, 8192
	add	ecx, ecx
	jmp	.L68
.L100:
	mov	ecx, 2048
	add	ecx, ecx
	jmp	.L68
.L99:
	mov	ecx, 4096
	add	ecx, ecx
	jmp	.L68
.L103:
	mov	ecx, 256
	add	ecx, ecx
	jmp	.L68
.L102:
	mov	ecx, 512
	add	ecx, ecx
	jmp	.L68
.L101:
	mov	ecx, 1024
	add	ecx, ecx
	jmp	.L68
.L104:
	mov	ecx, 128
	add	ecx, ecx
	jmp	.L68
.L106:
	mov	ecx, 32
	add	ecx, ecx
	jmp	.L68
.L110:
	mov	ecx, 2
	add	ecx, ecx
	jmp	.L68
.L109:
	mov	ecx, 4
	add	ecx, ecx
	jmp	.L68
.L108:
	mov	ecx, 8
	add	ecx, ecx
	jmp	.L68
.L107:
	mov	ecx, 16
	add	ecx, ecx
	jmp	.L68
.L125:
	mov	ebx, DWORD PTR 128[rsp]
	mov	DWORD PTR 160[rsp], ebx
	mov	r12d, ebx
	mov	ebx, DWORD PTR 120[rsp]
	mov	DWORD PTR 20[rsp], ebx
	jmp	.L81
	.cfi_endproc
.LFE590:
	.size	draw_triangle, .-draw_triangle
	.p2align 4,,15
	.type	tri_texshade_z, @function
tri_texshade_z:
.LFB561:
	.cfi_startproc
	mov	edx, 1
	mov	esi, 1
	mov	edi, 1
	jmp	draw_triangle
	.cfi_endproc
.LFE561:
	.size	tri_texshade_z, .-tri_texshade_z
	.p2align 4,,15
	.type	tri_texshade, @function
tri_texshade:
.LFB560:
	.cfi_startproc
	xor	edx, edx
	mov	esi, 1
	mov	edi, 1
	jmp	draw_triangle
	.cfi_endproc
.LFE560:
	.size	tri_texshade, .-tri_texshade
	.p2align 4,,15
	.type	tri_shade_z, @function
tri_shade_z:
.LFB559:
	.cfi_startproc
	mov	edx, 1
	xor	esi, esi
	mov	edi, 1
	jmp	draw_triangle
	.cfi_endproc
.LFE559:
	.size	tri_shade_z, .-tri_shade_z
	.p2align 4,,15
	.type	tri_shade, @function
tri_shade:
.LFB558:
	.cfi_startproc
	xor	edx, edx
	xor	esi, esi
	mov	edi, 1
	jmp	draw_triangle
	.cfi_endproc
.LFE558:
	.size	tri_shade, .-tri_shade
	.p2align 4,,15
	.type	tri_tex_z, @function
tri_tex_z:
.LFB557:
	.cfi_startproc
	mov	edx, 1
	mov	esi, 1
	xor	edi, edi
	jmp	draw_triangle
	.cfi_endproc
.LFE557:
	.size	tri_tex_z, .-tri_tex_z
	.p2align 4,,15
	.type	tri_tex, @function
tri_tex:
.LFB556:
	.cfi_startproc
	xor	edx, edx
	mov	esi, 1
	xor	edi, edi
	jmp	draw_triangle
	.cfi_endproc
.LFE556:
	.size	tri_tex, .-tri_tex
	.p2align 4,,15
	.type	tri_noshade_z, @function
tri_noshade_z:
.LFB555:
	.cfi_startproc
	mov	edx, 1
	xor	esi, esi
	xor	edi, edi
	jmp	draw_triangle
	.cfi_endproc
.LFE555:
	.size	tri_noshade_z, .-tri_noshade_z
	.p2align 4,,15
	.type	tri_noshade, @function
tri_noshade:
.LFB554:
	.cfi_startproc
	xor	edx, edx
	xor	esi, esi
	xor	edi, edi
	jmp	draw_triangle
	.cfi_endproc
.LFE554:
	.size	tri_noshade, .-tri_noshade
	.p2align 4,,15
	.type	draw_texture_rectangle, @function
draw_texture_rectangle:
.LFB589:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	sal	edx, 14
	sal	r8d, 14
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
	mov	rax, QWORD PTR clip@GOTPCREL[rip]
	sal	DWORD PTR 176[rsp], 16
	sal	DWORD PTR 184[rsp], 16
	mov	DWORD PTR 108[rsp], esi
	mov	r11d, DWORD PTR 192[rsp]
	mov	ebx, DWORD PTR [rax]
	mov	esi, DWORD PTR 200[rsp]
	add	ebx, ebx
	test	edi, edi
	mov	DWORD PTR 48[rsp], ebx
	mov	ebx, DWORD PTR 8[rax]
	lea	r10d, [rbx+rbx]
	mov	rbx, QWORD PTR max_level@GOTPCREL[rip]
	mov	DWORD PTR [rbx], 0
	je	.L137
	movsx	edi, si
	movsx	esi, r11w
	mov	DWORD PTR 80[rsp], 0
	mov	DWORD PTR 76[rsp], esi
	sal	DWORD PTR 76[rsp], 11
	xor	r11d, r11d
	sal	edi, 11
.L138:
	pxor	xmm0, xmm0
	mov	rsi, QWORD PTR spans_d_rgba@GOTPCREL[rip]
	mov	ebx, r11d
	and	ebx, -32
	movdqu	XMMWORD PTR [rsi], xmm0
	mov	rsi, QWORD PTR spans_d_stwz@GOTPCREL[rip]
	movdqa	XMMWORD PTR [rsp], xmm0
	movdqu	XMMWORD PTR [rsi], xmm0
	mov	DWORD PTR [rsi], ebx
	mov	ebx, edi
	and	ebx, -32
	mov	DWORD PTR 4[rsi], ebx
	mov	rsi, QWORD PTR spans_d_rgba_dy@GOTPCREL[rip]
	mov	ebx, DWORD PTR 76[rsp]
	movdqu	XMMWORD PTR [rsi], xmm0
	mov	rsi, QWORD PTR spans_cd_rgba@GOTPCREL[rip]
	and	ebx, -32768
	movdqu	XMMWORD PTR [rsi], xmm0
	mov	rsi, QWORD PTR spans_cdz@GOTPCREL[rip]
	mov	DWORD PTR [rsi], 0
	mov	rsi, QWORD PTR spans_d_stwz_dy@GOTPCREL[rip]
	movdqu	XMMWORD PTR [rsi], xmm0
	mov	DWORD PTR [rsi], ebx
	mov	ebx, DWORD PTR 80[rsp]
	and	ebx, -32768
	mov	DWORD PTR 4[rsi], ebx
	mov	rsi, QWORD PTR spans_dzpix@GOTPCREL[rip]
	mov	ebx, 1
	mov	WORD PTR [rsi], bx
	mov	rsi, QWORD PTR other_modes@GOTPCREL[rip]
	cmp	DWORD PTR [rsi], 2
	je	.L139
	sar	edi, 8
	sar	r11d, 8
	sal	rdi, 32
	or	r11, rdi
	mov	QWORD PTR [rsp], r11
.L139:
	mov	esi, DWORD PTR 4[rax]
	mov	eax, DWORD PTR 12[rax]
	cmp	ecx, esi
	cmovle	esi, ecx
	cmp	r9d, eax
	mov	edi, esi
	cmovge	eax, r9d
	sar	ecx, 2
	or	edi, 3
	mov	DWORD PTR 44[rsp], eax
	and	r9d, -4
	mov	eax, edi
	sar	eax, 2
	cmp	ecx, eax
	jle	.L140
	mov	eax, esi
	add	edi, 4
	sar	eax, 2
	mov	DWORD PTR 104[rsp], eax
.L141:
	mov	ebp, r8d
	sar	ebp, 8
	cmp	edi, r9d
	jl	.L154
	mov	eax, DWORD PTR 44[rsp]
	mov	ebx, r8d
	mov	r11d, edx
	sar	ebx, 13
	sar	r11d, 13
	mov	r12d, edx
	mov	ecx, ebx
	shr	r12d, 27
	add	edi, 1
	and	eax, -4
	and	ecx, 8190
	and	r12d, 1
	mov	DWORD PTR 28[rsp], eax
	mov	eax, r8d
	sub	ecx, r10d
	shr	eax, 27
	shr	ecx, 31
	and	ebx, 16382
	and	eax, 1
	mov	DWORD PTR 32[rsp], 0
	or	ecx, eax
	mov	eax, r11d
	and	r11d, 16382
	and	eax, 8190
	pxor	xmm0, xmm0
	sub	eax, r10d
	shr	eax, 31
	or	eax, r12d
	movzx	r12d, bpl
	mov	rbp, QWORD PTR [rsp]
	mov	r14d, eax
	and	r14d, ecx
	mov	DWORD PTR 64[rsp], r14d
	mov	r14d, r8d
	sar	rbp, 32
	sar	r14d, 16
	mov	DWORD PTR 84[rsp], r14d
	mov	r14d, DWORD PTR [rsp]
	mov	DWORD PTR [rsp], edi
	imul	r14d, r12d
	imul	r12d, ebp
	mov	rbp, QWORD PTR sckeepodd@GOTPCREL[rip]
	mov	DWORD PTR 88[rsp], r14d
	mov	r14d, DWORD PTR 0[rbp]
	mov	rbp, QWORD PTR scfield@GOTPCREL[rip]
	mov	DWORD PTR 92[rsp], r12d
	mov	DWORD PTR 96[rsp], r14d
	mov	r14d, DWORD PTR 0[rbp]
	mov	ebp, 1
	mov	DWORD PTR 100[rsp], r14d
	mov	r14d, r9d
	sub	r14d, esi
	test	ecx, ecx
	mov	ecx, DWORD PTR 48[rsp]
	cmovne	ebx, r10d
	mov	esi, r14d
	mov	edi, ebx
	shr	ebx, 13
	not	esi
	and	edi, 8191
	and	ebx, 1
	mov	DWORD PTR 60[rsp], edi
	sub	edi, ecx
	mov	DWORD PTR 36[rsp], edi
	not	DWORD PTR 36[rsp]
	shr	DWORD PTR 36[rsp], 31
	or	DWORD PTR 36[rsp], ebx
	test	eax, eax
	mov	ebx, 1
	cmove	r10d, r11d
	and	edx, 268419072
	and	r8d, 268419072
	mov	eax, r10d
	shr	r10d, 13
	mov	r11d, 1
	and	eax, 8191
	and	r10d, 1
	xor	r14d, r14d
	mov	DWORD PTR 68[rsp], eax
	sub	eax, ecx
	mov	DWORD PTR 40[rsp], eax
	not	DWORD PTR 40[rsp]
	shr	DWORD PTR 40[rsp], 31
	or	DWORD PTR 40[rsp], r10d
	mov	eax, DWORD PTR 40[rsp]
	and	eax, DWORD PTR 36[rsp]
	mov	DWORD PTR 72[rsp], eax
	mov	DWORD PTR 52[rsp], edx
	mov	DWORD PTR 56[rsp], r8d
	xor	DWORD PTR 52[rsp], 134217728
	xor	DWORD PTR 56[rsp], 134217728
	jmp	.L155
	.p2align 4,,10
	.p2align 3
.L160:
	mov	ecx, r9d
	sub	ecx, DWORD PTR 44[rsp]
	mov	r15d, r9d
	sar	r15d, 2
	or	ecx, esi
	shr	ecx, 31
	test	eax, eax
	jne	.L146
	mov	ebp, 1
	mov	ebx, 1
	mov	r11d, 1
	mov	r14d, 4095
	mov	DWORD PTR 32[rsp], 0
.L146:
	mov	r12d, DWORD PTR 36[rsp]
	mov	r13d, DWORD PTR 48[rsp]
	movsx	r8, r15d
	lea	r10, [r8+r8*2]
	mov	rdi, QWORD PTR span@GOTPCREL[rip]
	movsx	rdx, eax
	test	r12d, r12d
	mov	r12d, r13d
	cmove	r12d, DWORD PTR 60[rsp]
	lea	r10, [rdx+r10*8]
	mov	edx, r12d
	and	edx, 8191
	mov	DWORD PTR 48[rdi+r10*4], edx
	mov	edx, DWORD PTR 40[rsp]
	test	edx, edx
	cmove	r13d, DWORD PTR 68[rsp]
	and	r11d, DWORD PTR 72[rsp]
	and	ebx, DWORD PTR 64[rsp]
	mov	edx, r13d
	and	edx, 8191
	mov	DWORD PTR 64[rdi+r10*4], edx
	mov	edx, DWORD PTR 56[rsp]
	cmp	DWORD PTR 52[rsp], edx
	setl	dl
	movzx	edx, dl
	or	edx, ecx
	and	ebp, edx
	test	edx, edx
	mov	DWORD PTR 80[rdi+r10*4], edx
	jne	.L149
	mov	ecx, DWORD PTR 32[rsp]
	sar	r13d, 3
	and	r13d, 4095
	cmp	ecx, r13d
	cmovge	r13d, ecx
	sar	r12d, 3
	and	r12d, 4095
	mov	DWORD PTR 32[rsp], r13d
	cmp	r14d, r12d
	cmovg	r14d, r12d
.L149:
	test	eax, eax
	jne	.L150
	lea	rdx, [r8+r8*2]
	mov	ecx, DWORD PTR 84[rsp]
	sal	rdx, 5
	lea	rax, [rdi+rdx]
	mov	DWORD PTR 8[rax], ecx
	movdqa	XMMWORD PTR 16[rdi+rdx], xmm0
	mov	edx, DWORD PTR 176[rsp]
	sub	edx, DWORD PTR 88[rsp]
	mov	DWORD PTR 40[rax], 0
	mov	DWORD PTR 44[rax], 0
	and	edx, -1024
	mov	DWORD PTR 32[rax], edx
	mov	edx, DWORD PTR 184[rsp]
	sub	edx, DWORD PTR 92[rsp]
	and	edx, -1024
	mov	DWORD PTR 36[rax], edx
.L153:
	add	r9d, 1
	sub	esi, 1
	cmp	r9d, DWORD PTR [rsp]
	je	.L154
.L155:
	mov	eax, r9d
	and	eax, 3
	cmp	r9d, DWORD PTR 28[rsp]
	jge	.L160
	cmp	eax, 3
	jne	.L153
.L152:
	mov	eax, DWORD PTR 76[rsp]
	add	r9d, 1
	add	DWORD PTR 176[rsp], eax
	sub	esi, 1
	mov	eax, DWORD PTR 80[rsp]
	add	DWORD PTR 184[rsp], eax
	cmp	r9d, DWORD PTR [rsp]
	jne	.L155
.L154:
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	ecx, DWORD PTR 144[rax]
	test	ecx, ecx
	je	.L144
	call	deduce_derivatives@PLT
	mov	rax, QWORD PTR other_modes@GOTPCREL[rip]
	mov	DWORD PTR 144[rax], 0
.L144:
	mov	edi, DWORD PTR 44[rsp]
	mov	edx, DWORD PTR 108[rsp]
	mov	ecx, 1
	mov	esi, DWORD PTR 104[rsp]
	sar	edi, 2
	call	render_spans
	emms
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
.L150:
	.cfi_restore_state
	cmp	eax, 3
	jne	.L153
	lea	rax, [r8+r8*2]
	xor	r15d, DWORD PTR 96[rsp]
	and	r15d, DWORD PTR 100[rsp]
	sal	rax, 5
	add	rdi, rax
	mov	eax, DWORD PTR 32[rsp]
	mov	DWORD PTR 4[rdi], r14d
	mov	DWORD PTR [rdi], eax
	mov	eax, ebx
	or	eax, ebp
	or	eax, r15d
	or	eax, r11d
	xor	eax, 1
	mov	DWORD PTR 12[rdi], eax
	jmp	.L152
	.p2align 4,,10
	.p2align 3
.L140:
	mov	eax, esi
	sar	eax, 2
	cmp	eax, 1022
	mov	DWORD PTR 104[rsp], eax
	ja	.L141
	add	eax, 1
	cdqe
	lea	rax, [rax+rax*2]
	sal	rax, 5
	add	rax, QWORD PTR span@GOTPCREL[rip]
	mov	DWORD PTR 12[rax], 0
	jmp	.L141
	.p2align 4,,10
	.p2align 3
.L137:
	movsx	r11d, r11w
	movsx	esi, si
	xor	edi, edi
	mov	DWORD PTR 80[rsp], esi
	mov	DWORD PTR 76[rsp], 0
	sal	r11d, 11
	sal	DWORD PTR 80[rsp], 11
	jmp	.L138
	.cfi_endproc
.LFE589:
	.size	draw_texture_rectangle, .-draw_texture_rectangle
	.p2align 4,,15
	.type	tex_rect_flip, @function
tex_rect_flip:
.LFB563:
	.cfi_startproc
	sub	rsp, 40
	.cfi_def_cfa_offset 48
	mov	r10d, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip]
	lea	rdi, cmd_data[rip+4]
	movsx	rcx, r10d
	add	r10d, 1
	mov	r9d, DWORD PTR [rdi+rcx*8]
	mov	esi, DWORD PTR [rax+rcx*8]
	movsx	r10, r10d
	mov	rcx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edi, DWORD PTR [rdi+r10*8]
	mov	eax, DWORD PTR [rax+r10*8]
	mov	edx, esi
	and	esi, 4095
	mov	r8d, r9d
	mov	ecx, DWORD PTR [rcx]
	mov	r11d, esi
	movsx	r10d, di
	mov	esi, r9d
	sar	edi, 16
	and	edx, 16773120
	mov	DWORD PTR 16[rsp], edi
	and	esi, 117440512
	movzx	edi, ax
	sal	ecx, 30
	shr	eax, 16
	and	r8d, 16773120
	sar	ecx, 31
	mov	DWORD PTR 8[rsp], edi
	mov	DWORD PTR 24[rsp], r10d
	and	ecx, 3
	mov	DWORD PTR [rsp], eax
	shr	edx, 12
	shr	esi, 24
	or	ecx, r11d
	and	r9d, 4095
	shr	r8d, 12
	mov	edi, 1
	call	draw_texture_rectangle
	add	rsp, 40
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE563:
	.size	tex_rect_flip, .-tex_rect_flip
	.p2align 4,,15
	.type	tex_rect, @function
tex_rect:
.LFB562:
	.cfi_startproc
	sub	rsp, 40
	.cfi_def_cfa_offset 48
	mov	r10d, DWORD PTR cmd_cur[rip]
	lea	rax, cmd_data[rip]
	lea	rdi, cmd_data[rip+4]
	movsx	rcx, r10d
	add	r10d, 1
	mov	r9d, DWORD PTR [rdi+rcx*8]
	mov	esi, DWORD PTR [rax+rcx*8]
	movsx	r10, r10d
	mov	rcx, QWORD PTR other_modes@GOTPCREL[rip]
	mov	edi, DWORD PTR [rdi+r10*8]
	mov	eax, DWORD PTR [rax+r10*8]
	mov	edx, esi
	and	esi, 4095
	mov	r8d, r9d
	mov	ecx, DWORD PTR [rcx]
	mov	r11d, esi
	movsx	r10d, di
	mov	esi, r9d
	sar	edi, 16
	and	edx, 16773120
	mov	DWORD PTR 16[rsp], edi
	and	esi, 117440512
	movzx	edi, ax
	sal	ecx, 30
	shr	eax, 16
	and	r8d, 16773120
	sar	ecx, 31
	mov	DWORD PTR 8[rsp], edi
	mov	DWORD PTR 24[rsp], r10d
	and	ecx, 3
	mov	DWORD PTR [rsp], eax
	shr	edx, 12
	shr	esi, 24
	or	ecx, r11d
	and	r9d, 4095
	shr	r8d, 12
	xor	edi, edi
	call	draw_texture_rectangle
	add	rsp, 40
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE562:
	.size	tex_rect, .-tex_rect
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC3:
	.string	"ProcessRDPList\nOut of command cache memory."
	.align 8
.LC4:
	.string	"DRAM access violation overrides"
	.text
	.p2align 4,,15
	.globl	process_RDP_list
	.type	process_RDP_list, @function
process_RDP_list:
.LFB551:
	.cfi_startproc
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	mov	r14, QWORD PTR RCP_info_VI@GOTPCREL[rip]
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
	mov	rax, QWORD PTR 80[r14]
	mov	esi, DWORD PTR [rax]
	mov	rax, QWORD PTR 72[r14]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 88[r14]
	and	esi, 16777208
	mov	r9d, DWORD PTR [rax]
	and	ecx, 16777208
	mov	edi, ecx
	sub	edi, esi
	mov	edx, r9d
	and	edx, -3
	test	edi, edi
	mov	DWORD PTR [rax], edx
	jle	.L169
	mov	r8d, DWORD PTR cmd_ptr[rip]
	shr	edi, 3
	lea	eax, [r8+rdi]
	cdqe
	test	rax, -32768
	jne	.L188
	mov	edx, ecx
	lea	eax, -1[rdi]
	sub	rdx, 8
	shr	rdx, 3
	and	r9d, 1
	je	.L172
	movsx	rcx, eax
	movsx	rsi, r8d
	lea	rbx, cmd_data[rip]
	add	rcx, rsi
	mov	r9, QWORD PTR 40[r14]
	lea	rcx, [rbx+rcx*8]
	.p2align 4,,10
	.p2align 3
.L176:
	and	edx, 511
	sub	rcx, 8
	lea	esi, 0[0+rdx*8]
	sub	edx, 1
	mov	rsi, QWORD PTR [r9+rsi]
	mov	QWORD PTR 8[rcx], rsi
	sub	eax, 1
	jns	.L176
.L179:
	emms
	mov	rax, QWORD PTR rdp_pipeline_crashed@GOTPCREL[rip]
	add	edi, r8d
	mov	ebp, DWORD PTR [rax]
	mov	DWORD PTR cmd_ptr[rip], edi
	test	ebp, ebp
	jne	.L174
	mov	eax, DWORD PTR cmd_cur[rip]
	cmp	eax, edi
	jns	.L174
	movsx	rdx, eax
	lea	r12, DP_CMD_LEN_W[rip]
	sub	edi, eax
	movzx	edx, BYTE PTR 3[rbx+rdx*8]
	and	edx, 63
	mov	ebp, DWORD PTR [r12+rdx*4]
	cmp	edi, ebp
	js	.L181
	lea	r13, rdp_command_table[rip]
	jmp	.L183
	.p2align 4,,10
	.p2align 3
.L184:
	movsx	rdx, eax
	sub	ecx, eax
	movzx	edx, BYTE PTR 3[rbx+rdx*8]
	and	edx, 63
	mov	ebp, DWORD PTR [r12+rdx*4]
	cmp	ecx, ebp
	js	.L181
.L183:
	call	[QWORD PTR 0[r13+rdx*8]]
	mov	eax, DWORD PTR cmd_cur[rip]
	mov	ecx, DWORD PTR cmd_ptr[rip]
	add	eax, ebp
	cmp	eax, ecx
	mov	DWORD PTR cmd_cur[rip], eax
	js	.L184
.L174:
	mov	DWORD PTR cmd_ptr[rip], 0
	mov	DWORD PTR cmd_cur[rip], 0
.L181:
	mov	rax, QWORD PTR 72[r14]
	mov	rdx, QWORD PTR 64[r14]
	mov	rcx, QWORD PTR 80[r14]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rcx], eax
	mov	DWORD PTR [rdx], eax
.L169:
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
.L172:
	.cfi_restore_state
	mov	r9, QWORD PTR plim@GOTPCREL[rip]
	mov	r9d, DWORD PTR [r9]
	cmp	ecx, r9d
	ja	.L177
	cmp	esi, r9d
	ja	.L177
	movsx	rcx, eax
	movsx	rsi, r8d
	lea	rbx, cmd_data[rip]
	add	rcx, rsi
	mov	r9, QWORD PTR 32[r14]
	lea	rcx, [rbx+rcx*8]
	.p2align 4,,10
	.p2align 3
.L180:
	and	edx, 2097151
	sub	rcx, 8
	lea	esi, 0[0+rdx*8]
	sub	edx, 1
	mov	rsi, QWORD PTR [r9+rsi]
	mov	QWORD PTR 8[rcx], rsi
	sub	eax, 1
	jns	.L180
	jmp	.L179
	.p2align 4,,10
	.p2align 3
.L177:
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
	lea	rdi, .LC4[rip]
	jmp	DisplayError@PLT
	.p2align 4,,10
	.p2align 3
.L188:
	.cfi_restore_state
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
	lea	rdi, .LC3[rip]
	jmp	DisplayError@PLT
	.cfi_endproc
.LFE551:
	.size	process_RDP_list, .-process_RDP_list
	.p2align 4,,15
	.globl	mm_mullo_epi32_seh
	.type	mm_mullo_epi32_seh, @function
mm_mullo_epi32_seh:
.LFB593:
	.cfi_startproc
	movdqa	xmm2, xmm0
	pmuludq	xmm0, xmm1
	pshufd	xmm0, xmm0, 216
	psrlq	xmm2, 32
	pmuludq	xmm1, xmm2
	pshufd	xmm1, xmm1, 216
	punpckldq	xmm0, xmm1
	ret
	.cfi_endproc
.LFE593:
	.size	mm_mullo_epi32_seh, .-mm_mullo_epi32_seh
	.local	minmax.22230
	.comm	minmax.22230,8,16
	.local	triangle_count.22157
	.comm	triangle_count.22157,1,16
	.local	minxhx.22064
	.comm	minxhx.22064,4,16
	.local	maxxmx.22063
	.comm	maxxmx.22063,4,16
	.data
	.align 16
	.type	invalid_command, @object
	.size	invalid_command, 24
invalid_command:
	.string	"00\nDP reserved command."
	.section	.rodata
	.align 32
	.type	DP_CMD_LEN_W, @object
	.size	DP_CMD_LEN_W, 256
DP_CMD_LEN_W:
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	4
	.long	6
	.long	12
	.long	14
	.long	12
	.long	14
	.long	20
	.long	22
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	2
	.long	2
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.section	.data.rel.ro.local,"aw",@progbits
	.align 32
	.type	rdp_command_table, @object
	.size	rdp_command_table, 512
rdp_command_table:
	.quad	noop
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	tri_noshade
	.quad	tri_noshade_z
	.quad	tri_tex
	.quad	tri_tex_z
	.quad	tri_shade
	.quad	tri_shade_z
	.quad	tri_texshade
	.quad	tri_texshade_z
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	invalid
	.quad	tex_rect
	.quad	tex_rect_flip
	.quad	sync_load
	.quad	sync_pipe
	.quad	sync_tile
	.quad	sync_full
	.quad	set_key_gb
	.quad	set_key_r
	.quad	set_convert
	.quad	set_scissor
	.quad	set_prim_depth
	.quad	set_other_modes
	.quad	load_tlut
	.quad	invalid
	.quad	set_tile_size
	.quad	load_block
	.quad	load_tile
	.quad	set_tile
	.quad	fill_rect
	.quad	set_fill_color
	.quad	set_fog_color
	.quad	set_blend_color
	.quad	set_prim_color
	.quad	set_env_color
	.quad	set_combine
	.quad	set_texture_image
	.quad	set_mask_image
	.quad	set_color_image
	.local	cmd_data
	.comm	cmd_data,262144,32
	.local	cmd_ptr
	.comm	cmd_ptr,4,16
	.local	cmd_cur
	.comm	cmd_cur,4,16
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.long	-512
	.long	-512
	.long	-512
	.long	-512
	.align 16
.LC1:
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.ident	"GCC: (GNU) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
