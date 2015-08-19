	.file	"context.c"
	.intel_syntax noprefix
	.text
	.type	my_glColorfv, @function
my_glColorfv:
.LFB9:
	.cfi_startproc
	xor	eax, eax
.L3:
	lea	rdx, my_glColor[rip]
	movss	xmm0, DWORD PTR [rdi+rax]
	movss	DWORD PTR [rdx+rax], xmm0
	add	rax, 4
	cmp	rax, 16
	jne	.L3
	movss	xmm0, DWORD PTR [rdi]
	movss	DWORD PTR my_glColor[rip+16], xmm0
	movss	xmm0, DWORD PTR 4[rdi]
	movss	DWORD PTR my_glColor[rip+20], xmm0
	movss	xmm0, DWORD PTR 8[rdi]
	movss	DWORD PTR my_glColor[rip+24], xmm0
	movss	xmm0, DWORD PTR 12[rdi]
	movss	DWORD PTR my_glColor[rip+28], xmm0
	movss	xmm0, DWORD PTR [rdi]
	movss	DWORD PTR my_glColor[rip+32], xmm0
	movss	xmm0, DWORD PTR 4[rdi]
	movss	DWORD PTR my_glColor[rip+36], xmm0
	movss	xmm0, DWORD PTR 8[rdi]
	movss	DWORD PTR my_glColor[rip+40], xmm0
	movss	xmm0, DWORD PTR 12[rdi]
	movss	DWORD PTR my_glColor[rip+44], xmm0
	movss	xmm0, DWORD PTR [rdi]
	movss	DWORD PTR my_glColor[rip+48], xmm0
	movss	xmm0, DWORD PTR 4[rdi]
	movss	DWORD PTR my_glColor[rip+52], xmm0
	movss	xmm0, DWORD PTR 8[rdi]
	movss	DWORD PTR my_glColor[rip+56], xmm0
	movss	xmm0, DWORD PTR 12[rdi]
	movss	DWORD PTR my_glColor[rip+60], xmm0
	ret
	.cfi_endproc
.LFE9:
	.size	my_glColorfv, .-my_glColorfv
	.type	my_glRectfv, @function
my_glRectfv:
.LFB10:
	.cfi_startproc
	sub	rsp, 56
	.cfi_def_cfa_offset 64
	movss	xmm3, DWORD PTR [rdi]
	mov	BYTE PTR 10[rsp], 3
	movss	xmm0, DWORD PTR 4[rdi]
	mov	edi, 32884
	mov	BYTE PTR 11[rsp], 0
	movss	xmm1, DWORD PTR [rsi]
	mov	BYTE PTR 12[rsp], 1
	movss	xmm2, DWORD PTR 4[rsi]
	mov	BYTE PTR 13[rsp], 3
	movss	DWORD PTR 16[rsp], xmm3
	mov	BYTE PTR 14[rsp], 2
	mov	BYTE PTR 15[rsp], 1
	movss	DWORD PTR 20[rsp], xmm0
	movss	DWORD PTR 32[rsp], xmm1
	movss	DWORD PTR 36[rsp], xmm2
	movss	DWORD PTR 40[rsp], xmm3
	movss	DWORD PTR 44[rsp], xmm2
	movss	DWORD PTR 24[rsp], xmm1
	movss	DWORD PTR 28[rsp], xmm0
	call	glEnableClientState@PLT
	mov	edi, 32886
	call	glEnableClientState@PLT
	lea	rcx, 16[rsp]
	xor	edx, edx
	mov	esi, 5126
	mov	edi, 2
	call	glVertexPointer@PLT
	lea	rcx, my_glColor[rip]
	xor	edx, edx
	mov	esi, 5126
	mov	edi, 4
	call	glColorPointer@PLT
	lea	rcx, 10[rsp]
	mov	edx, 5121
	mov	esi, 6
	mov	edi, 4
	call	glDrawElements@PLT
	mov	edi, 32884
	call	glDisableClientState@PLT
	mov	edi, 32886
	call	glDisableClientState@PLT
	add	rsp, 56
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE10:
	.size	my_glRectfv, .-my_glRectfv
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%s\n%s\n\n"
	.text
	.globl	DisplayGLError
	.type	DisplayGLError, @function
DisplayGLError:
.LFB5:
	.cfi_startproc
	test	esi, esi
	jne	.L8
	jmp	puts@PLT
.L8:
	sub	esi, 1279
	mov	eax, 7
	mov	rcx, rdi
	cmp	esi, 8
	cmovae	esi, eax
	lea	rax, GL_errors[rip]
	movsx	rsi, esi
	mov	rdx, QWORD PTR [rax+rsi*8]
	mov	rax, QWORD PTR stderr@GOTPCREL[rip]
	lea	rsi, .LC0[rip]
	mov	rdi, QWORD PTR [rax]
	xor	eax, eax
	jmp	fprintf@PLT
	.cfi_endproc
.LFE5:
	.size	DisplayGLError, .-DisplayGLError
	.section	.rodata.str1.1
.LC1:
	.string	"Failed to sync commands."
	.text
	.globl	swap_buffers
	.type	swap_buffers, @function
swap_buffers:
.LFB8:
	.cfi_startproc
	push	rcx
	.cfi_def_cfa_offset 16
	mov	rax, QWORD PTR double_buffering@GOTPCREL[rip]
	cmp	BYTE PTR [rax], 0
	je	.L12
	call	SDL_GL_SwapBuffers@PLT
	mov	edi, 17664
	jmp	.L18
.L12:
	call	glFlush@PLT
	mov	edi, 16384
.L18:
	call	glClear@PLT
	call	glGetError@PLT
	test	eax, eax
	mov	edx, 1
	je	.L14
	lea	rdi, .LC1[rip]
	mov	esi, eax
	call	DisplayGLError@PLT
	xor	edx, edx
.L14:
	mov	eax, edx
	pop	rdx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE8:
	.size	swap_buffers, .-swap_buffers
	.section	.rodata.str1.1
.LC2:
	.string	"glGetStringi"
.LC3:
	.string	"glGetString"
	.text
	.globl	is_extension_present
	.type	is_extension_present, @function
is_extension_present:
.LFB13:
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
	mov	rbx, rdi
	mov	edi, 7939
	sub	rsp, 16
	.cfi_def_cfa_offset 48
	call	glGetString@PLT
	mov	r12, rax
	call	glGetError@PLT
	test	eax, eax
	mov	ebp, eax
	jne	.L20
	test	r12, r12
	je	.L20
	mov	rax, r12
	xor	edx, edx
	jmp	.L21
.L20:
	lea	rdi, .LC2[rip]
	call	glXGetProcAddress@PLT
	mov	r12, QWORD PTR xglGetStringi@GOTPCREL[rip]
	test	rax, rax
	mov	QWORD PTR [r12], rax
	je	.L22
	cmp	ebp, 1280
	je	.L23
.L22:
	lea	rdi, .LC3[rip]
	mov	esi, ebp
	call	DisplayGLError@PLT
	jmp	.L40
.L23:
	lea	rsi, 12[rsp]
	mov	edi, 33309
	xor	ebp, ebp
	call	glGetIntegerv@PLT
.L25:
	cmp	ebp, DWORD PTR 12[rsp]
	jge	.L40
	mov	esi, ebp
	mov	edi, 7939
	call	[QWORD PTR [r12]]
	xor	edx, edx
.L26:
	movzx	ecx, BYTE PTR [rax+rdx]
	test	cl, cl
	je	.L27
	movsx	esi, BYTE PTR [rbx+rdx]
	inc	rdx
	cmp	esi, ecx
	jne	.L28
	jmp	.L26
.L27:
	cmp	BYTE PTR [rbx+rdx], 0
	je	.L35
.L28:
	inc	ebp
	jmp	.L25
.L32:
	movsx	rsi, edx
	movsx	esi, BYTE PTR [rbx+rsi]
	cmp	ecx, esi
	jne	.L34
	inc	edx
	movsx	rcx, edx
	cmp	BYTE PTR [rbx+rcx], 0
	je	.L41
.L31:
	inc	rax
.L21:
	movzx	ecx, BYTE PTR [rax]
	test	cl, cl
	jne	.L32
	jmp	.L40
.L41:
	test	BYTE PTR 1[rax], -33
	je	.L35
.L34:
	xor	edx, edx
	jmp	.L31
.L40:
	xor	eax, eax
	jmp	.L30
.L35:
	mov	al, 1
.L30:
	add	rsp, 16
	.cfi_def_cfa_offset 32
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE13:
	.size	is_extension_present, .-is_extension_present
	.section	.rodata.str1.1
.LC4:
	.string	"GL_EXT_bgra"
.LC5:
	.string	"GL_ARB_vertex_program"
.LC6:
	.string	"glVertexAttribPointerARB"
.LC7:
	.string	"glEnableVertexAttribArrayARB"
.LC8:
	.string	"glDisableVertexAttribArrayARB"
.LC9:
	.string	"GL_ARB_vertex_buffer_object"
.LC10:
	.string	"GL_ARB_pixel_buffer_object"
.LC11:
	.string	"glGenBuffersARB"
.LC12:
	.string	"glBindBufferARB"
.LC13:
	.string	"glBufferDataARB"
.LC14:
	.string	"glDeleteBuffersARB"
.LC15:
	.string	"glMapBufferARB"
.LC16:
	.string	"glUnmapBufferARB"
.LC17:
	.string	"glGetStringiARB"
	.text
	.globl	map_extensions
	.type	map_extensions, @function
map_extensions:
.LFB14:
	.cfi_startproc
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	lea	rdi, .LC4[rip]
	push	r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	push	rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	push	rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	sub	rsp, 24
	.cfi_def_cfa_offset 64
	mov	r13, QWORD PTR support_GDI_bitmap@GOTPCREL[rip]
	mov	rbp, QWORD PTR support_buffer_objects@GOTPCREL[rip]
	mov	rbx, QWORD PTR support_pixel_DMAs@GOTPCREL[rip]
	mov	r12, QWORD PTR support_vertex_program@GOTPCREL[rip]
	mov	BYTE PTR 0[r13], 0
	mov	BYTE PTR 0[rbp], 0
	mov	BYTE PTR [rbx], 0
	mov	BYTE PTR [r12], 0
	call	is_extension_present@PLT
	test	al, al
	mov	BYTE PTR 0[r13], al
	jne	.L43
	mov	WORD PTR 14[rsp], 0
	mov	BYTE PTR 14[rsp], 1
	movsx	eax, WORD PTR 14[rsp]
	sal	eax, 8
	test	ax, ax
	mov	WORD PTR 14[rsp], ax
	je	.L43
	lea	rdi, .LC4[rip]
	call	DisplayError@PLT
.L43:
	lea	rdi, .LC5[rip]
	call	is_extension_present@PLT
	test	al, al
	mov	BYTE PTR [r12], al
	jne	.L45
	lea	rdi, .LC5[rip]
	call	DisplayWarning@PLT
.L45:
	lea	rdi, .LC6[rip]
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglVertexAttribPointer@GOTPCREL[rip]
	lea	rdi, .LC7[rip]
	mov	QWORD PTR [rdx], rax
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglEnableVertexAttribArray@GOTPCREL[rip]
	lea	rdi, .LC8[rip]
	mov	QWORD PTR [rdx], rax
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglDisableVertexAttribArray@GOTPCREL[rip]
	lea	rdi, .LC9[rip]
	mov	QWORD PTR [rdx], rax
	call	is_extension_present@PLT
	lea	rdi, .LC10[rip]
	mov	BYTE PTR 0[rbp], al
	call	is_extension_present@PLT
	lea	rdi, .LC11[rip]
	mov	BYTE PTR [rbx], al
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglGenBuffers@GOTPCREL[rip]
	lea	rdi, .LC12[rip]
	mov	QWORD PTR [rdx], rax
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglBindBuffer@GOTPCREL[rip]
	lea	rdi, .LC13[rip]
	mov	QWORD PTR [rdx], rax
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglBufferData@GOTPCREL[rip]
	lea	rdi, .LC14[rip]
	mov	QWORD PTR [rdx], rax
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglDeleteBuffers@GOTPCREL[rip]
	lea	rdi, .LC15[rip]
	mov	QWORD PTR [rdx], rax
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglMapBuffer@GOTPCREL[rip]
	lea	rdi, .LC16[rip]
	mov	QWORD PTR [rdx], rax
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglUnmapBuffer@GOTPCREL[rip]
	lea	rdi, .LC17[rip]
	mov	QWORD PTR [rdx], rax
	call	glXGetProcAddress@PLT
	mov	rdx, QWORD PTR xglGetStringi@GOTPCREL[rip]
	mov	QWORD PTR [rdx], rax
	add	rsp, 24
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
	.cfi_endproc
.LFE14:
	.size	map_extensions, .-map_extensions
	.section	.rodata.str1.1
.LC18:
	.string	"failed SDL_INIT_VIDEO:  %s\n"
.LC19:
	.string	"%i x %i, %u-bit\n"
.LC20:
	.string	"failed SetVideoMode:  %s\n"
.LC21:
	.string	"Warning:  Double-buffered context in SDL plugin."
.LC22:
	.string	"Iconoclast's OpenGL"
.LC24:
	.string	"GL_VENDOR    :  %s\n"
.LC25:
	.string	"GL_RENDERER  :  %s\n"
.LC26:
	.string	"GL_VERSION   :  %s\n"
.LC27:
	.string	"GL_EXTENSIONS:  "
.LC28:
	.string	"    %s\n"
.LC32:
	.string	"Waiting for video input..."
.LC47:
	.string	"Failed to draw bars test pattern."
.LC48:
	.string	"Swapping buffers seems to fail."
.LC49:
	.string	"Failed to test OpenGL context."
.LC23:
	.string	"GL_MAX_TEXTURE_SIZE:  000"
	.text
	.globl	init_GL_context
	.type	init_GL_context, @function
init_GL_context:
.LFB7:
	.cfi_startproc
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	mov	edi, 32
	push	r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	push	rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	push	rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	sub	rsp, 56
	.cfi_def_cfa_offset 96
	call	SDL_InitSubSystem@PLT
	test	eax, eax
	jns	.L48
	call	SDL_GetError@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR stderr@GOTPCREL[rip]
	lea	rsi, .LC18[rip]
	mov	rdi, QWORD PTR [rax]
	xor	eax, eax
	call	fprintf@PLT
	call	SDL_Quit@PLT
.L48:
	call	SDL_GetVideoInfo@PLT
	mov	rdx, QWORD PTR video_info@GOTPCREL[rip]
	mov	esi, DWORD PTR 16[rax]
	mov	rdi, QWORD PTR SDL_desktop@GOTPCREL[rip]
	mov	QWORD PTR [rdx], rax
	mov	edx, DWORD PTR 20[rax]
	mov	rax, QWORD PTR 8[rax]
	mov	DWORD PTR [rdi], esi
	mov	DWORD PTR 4[rdi], edx
	movzx	ecx, BYTE PTR 8[rax]
	xor	eax, eax
	mov	DWORD PTR 8[rdi], ecx
	lea	rdi, .LC19[rip]
	call	printf@PLT
	xor	edi, edi
	mov	esi, 5
	call	SDL_GL_SetAttribute@PLT
	mov	esi, 5
	mov	edi, 1
	call	SDL_GL_SetAttribute@PLT
	mov	esi, 5
	mov	edi, 2
	call	SDL_GL_SetAttribute@PLT
	xor	esi, esi
	mov	edi, 5
	call	SDL_GL_SetAttribute@PLT
	xor	edx, edx
	mov	ecx, 18
	mov	esi, 480
	mov	edi, 640
	call	SDL_SetVideoMode@PLT
	mov	rdx, QWORD PTR video_surface@GOTPCREL[rip]
	test	rax, rax
	mov	QWORD PTR [rdx], rax
	jne	.L49
	call	SDL_GetError@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR stderr@GOTPCREL[rip]
	lea	rsi, .LC20[rip]
	mov	rdi, QWORD PTR [rax]
	xor	eax, eax
	call	fprintf@PLT
	call	SDL_Quit@PLT
.L49:
	lea	rsi, 16[rsp]
	mov	edi, 5
	mov	DWORD PTR 16[rsp], 0
	call	SDL_GL_GetAttribute@PLT
	cmp	DWORD PTR 16[rsp], 1
	mov	rdx, QWORD PTR double_buffering@GOTPCREL[rip]
	sete	al
	test	al, al
	mov	BYTE PTR [rdx], al
	je	.L50
	lea	rdi, .LC21[rip]
	call	puts@PLT
.L50:
	lea	rdi, .LC22[rip]
	xor	esi, esi
	lea	rbx, 20[rsp]
	call	SDL_WM_SetCaption@PLT
	lea	rsi, 12[rsp]
	mov	edi, 3379
	call	glGetIntegerv@PLT
	mov	r8d, DWORD PTR 12[rsp]
	cmp	r8d, 1023
	jg	.L51
	mov	rdi, rbx
	lea	rsi, .LC23[rip]
	mov	ecx, 26
	rep movsb
	mov	eax, r8d
	mov	rdi, rbx
	cdq
	mov	cl, 100
	idiv	ecx
	mov	cl, 10
	cdq
	idiv	ecx
	mov	eax, r8d
	add	edx, 48
	mov	BYTE PTR 42[rsp], dl
	cdq
	idiv	ecx
	mov	esi, edx
	cdq
	idiv	ecx
	add	esi, 48
	mov	BYTE PTR 44[rsp], sil
	add	edx, 48
	mov	BYTE PTR 43[rsp], dl
	call	DisplayError@PLT
	jmp	.L71
.L51:
	call	map_extensions@PLT
	mov	edi, 7936
	call	glGetString@PLT
	mov	r13, QWORD PTR vendor@GOTPCREL[rip]
	mov	edi, 7937
	mov	QWORD PTR 0[r13], rax
	call	glGetString@PLT
	mov	r12, QWORD PTR renderer@GOTPCREL[rip]
	mov	edi, 7938
	mov	QWORD PTR [r12], rax
	call	glGetString@PLT
	mov	rbp, QWORD PTR version@GOTPCREL[rip]
	mov	rsi, QWORD PTR 0[r13]
	lea	rdi, .LC24[rip]
	mov	QWORD PTR 0[rbp], rax
	xor	eax, eax
	call	printf@PLT
	mov	rsi, QWORD PTR [r12]
	lea	rdi, .LC25[rip]
	xor	eax, eax
	call	printf@PLT
	mov	rsi, QWORD PTR 0[rbp]
	lea	rdi, .LC26[rip]
	xor	eax, eax
	call	printf@PLT
	lea	rdi, .LC27[rip]
	call	puts@PLT
	mov	rax, QWORD PTR support_GDI_bitmap@GOTPCREL[rip]
	cmp	BYTE PTR [rax], 0
	je	.L53
	lea	rsi, .LC4[rip]
	lea	rdi, .LC28[rip]
	xor	eax, eax
	call	printf@PLT
.L53:
	mov	rax, QWORD PTR support_buffer_objects@GOTPCREL[rip]
	cmp	BYTE PTR [rax], 0
	je	.L54
	lea	rsi, .LC9[rip]
	lea	rdi, .LC28[rip]
	xor	eax, eax
	call	printf@PLT
.L54:
	mov	rax, QWORD PTR support_vertex_program@GOTPCREL[rip]
	cmp	BYTE PTR [rax], 0
	je	.L55
	lea	rsi, .LC5[rip]
	lea	rdi, .LC28[rip]
	xor	eax, eax
	call	printf@PLT
.L55:
	mov	rax, QWORD PTR support_pixel_DMAs@GOTPCREL[rip]
	cmp	BYTE PTR [rax], 0
	je	.L56
	lea	rsi, .LC10[rip]
	lea	rdi, .LC28[rip]
	xor	eax, eax
	call	printf@PLT
.L56:
	mov	edi, 10
	lea	r12, colors[rip+112]
	lea	rbp, colors[rip]
	call	putchar@PLT
	mov	rsi, QWORD PTR viewport@GOTPCREL[rip]
	mov	edi, 2978
	call	glGetIntegerv@PLT
	mov	esi, 4353
	mov	edi, 3156
	call	glHint@PLT
	mov	esi, 4353
	mov	edi, 3152
	call	glHint@PLT
	movss	xmm0, DWORD PTR .LC29[rip]
	call	glLineWidth@PLT
	mov	esi, 4353
	mov	edi, 3154
	call	glHint@PLT
	mov	esi, 4353
	mov	edi, 3153
	call	glHint@PLT
	mov	esi, 4353
	mov	edi, 3155
	call	glHint@PLT
	mov	edi, 3042
	call	glDisable@PLT
	mov	edi, 2929
	call	glDisable@PLT
	mov	edi, 3089
	call	glDisable@PLT
	mov	edi, 2884
	call	glDisable@PLT
	xor	ecx, ecx
	mov	edx, 1
	mov	esi, 1
	mov	edi, 1
	call	glColorMask@PLT
	xor	edi, edi
	call	glDepthMask@PLT
	xor	edi, edi
	call	glStencilMask@PLT
	xor	esi, esi
	mov	edi, 1
	call	glBlendFunc@PLT
	mov	edi, 519
	call	glDepthFunc@PLT
	or	edx, -1
	xor	esi, esi
	mov	edi, 519
	call	glStencilFunc@PLT
	mov	edi, 1029
	call	glCullFace@PLT
	mov	edi, 2305
	call	glFrontFace@PLT
	mov	ecx, 479
	xor	esi, esi
	xor	edi, edi
	mov	edx, 639
	call	glScissor@PLT
	mov	edx, 7680
	mov	esi, 5386
	xor	edi, edi
	call	glStencilOp@PLT
	xorps	xmm3, xmm3
	movaps	xmm2, xmm3
	movaps	xmm1, xmm3
	movaps	xmm0, xmm3
	call	glClearColor@PLT
	xorps	xmm0, xmm0
	call	glClearDepth@PLT
	xor	edi, edi
	call	glClearStencil@PLT
	lea	rdi, .LC32[rip]
	call	DisplayInStatusPanel@PLT
	call	glFinish@PLT
	movss	xmm2, DWORD PTR .LC33[rip]
	movaps	xmm1, xmm2
	movaps	xmm0, xmm2
	movss	xmm3, DWORD PTR .LC29[rip]
	call	glClearColor@PLT
	mov	edi, 16384
	call	glClear@PLT
	mov	DWORD PTR 20[rsp], 0xbf800000
	mov	DWORD PTR 24[rsp], 0xbeaaaaaa
	mov	DWORD PTR 28[rsp], 0xbf36db6e
	mov	DWORD PTR 32[rsp], 0x3f800000
.L58:
	mov	rdi, rbp
	add	rbp, 16
	call	my_glColorfv
	lea	rsi, 8[rbx]
	mov	rdi, rbx
	call	my_glRectfv
	movss	xmm0, DWORD PTR .LC37[rip]
	cmp	rbp, r12
	addss	xmm0, DWORD PTR 20[rsp]
	movss	DWORD PTR 20[rsp], xmm0
	movss	xmm0, DWORD PTR .LC37[rip]
	addss	xmm0, DWORD PTR 28[rsp]
	movss	DWORD PTR 28[rsp], xmm0
	jne	.L58
	lea	r12, colors[rip+96]
	lea	r13, colors[rip-32]
	mov	DWORD PTR 20[rsp], 0xbf800000
	mov	DWORD PTR 24[rsp], 0xbf000000
	mov	DWORD PTR 28[rsp], 0xbf36db6e
	mov	DWORD PTR 32[rsp], 0xbeaaaaaa
.L60:
	lea	rbp, 8[rbx]
	mov	rdi, r12
	sub	r12, 32
	call	my_glColorfv
	mov	rsi, rbp
	mov	rdi, rbx
	call	my_glRectfv
	movss	xmm0, DWORD PTR .LC39[rip]
	cmp	r12, r13
	addss	xmm0, DWORD PTR 20[rsp]
	movss	DWORD PTR 20[rsp], xmm0
	movss	xmm0, DWORD PTR .LC39[rip]
	addss	xmm0, DWORD PTR 28[rsp]
	movss	DWORD PTR 28[rsp], xmm0
	jne	.L60
	lea	rdi, my_glColor[rip]
	mov	DWORD PTR my_glColor[rip], 0x00000000
	mov	DWORD PTR my_glColor[rip+4], 0x3e000000
	mov	DWORD PTR my_glColor[rip+8], 0x3e970a3d
	mov	DWORD PTR my_glColor[rip+12], 0x3f800000
	call	my_glColorfv
	mov	rsi, rbp
	mov	rdi, rbx
	mov	DWORD PTR 20[rsp], 0xbf800000
	mov	DWORD PTR 24[rsp], 0xbf800000
	mov	DWORD PTR 28[rsp], 0xbf249249
	mov	DWORD PTR 32[rsp], 0xbf000000
	call	my_glRectfv
	movss	xmm0, DWORD PTR .LC43[rip]
	lea	rdi, my_glColor[rip]
	movss	xmm1, DWORD PTR 20[rsp]
	mov	DWORD PTR my_glColor[rip], 0x3e47ae14
	addss	xmm1, xmm0
	mov	DWORD PTR my_glColor[rip+4], 0x00000000
	mov	DWORD PTR my_glColor[rip+8], 0x3ed47ae1
	addss	xmm0, DWORD PTR 28[rsp]
	mov	DWORD PTR my_glColor[rip+12], 0x3f800000
	movss	DWORD PTR 20[rsp], xmm1
	movss	DWORD PTR 28[rsp], xmm0
	call	my_glColorfv
	mov	rsi, rbp
	mov	rdi, rbx
	call	my_glRectfv
	movss	xmm1, DWORD PTR .LC46[rip]
	lea	rdi, my_glColor[rip]
	movss	xmm0, DWORD PTR 20[rsp]
	mov	DWORD PTR my_glColor[rip], 0x3f800000
	subss	xmm0, xmm1
	mov	DWORD PTR my_glColor[rip+4], 0x3f800000
	mov	DWORD PTR my_glColor[rip+8], 0x3f800000
	mov	DWORD PTR my_glColor[rip+12], 0x3f800000
	movss	DWORD PTR 20[rsp], xmm0
	movss	xmm0, DWORD PTR 28[rsp]
	subss	xmm0, xmm1
	movss	DWORD PTR 28[rsp], xmm0
	call	my_glColorfv
	mov	rsi, rbp
	mov	rdi, rbx
	call	my_glRectfv
	call	glGetError@PLT
	test	eax, eax
	je	.L61
	lea	rdi, .LC47[rip]
	mov	esi, eax
	call	DisplayGLError@PLT
.L61:
	xorps	xmm3, xmm3
	movaps	xmm2, xmm3
	movaps	xmm1, xmm3
	movaps	xmm0, xmm3
	call	glClearColor@PLT
	call	swap_buffers@PLT
	test	eax, eax
	mov	DWORD PTR 16[rsp], eax
	jne	.L62
	lea	rdi, .LC48[rip]
	call	DisplayError@PLT
.L62:
	call	glGetError@PLT
	test	eax, eax
	je	.L63
	lea	rdi, .LC49[rip]
	mov	esi, eax
	call	DisplayGLError@PLT
.L71:
	xor	eax, eax
	jmp	.L52
.L63:
	xor	esi, esi
	xor	edi, edi
	call	reform_image_canvas@PLT
	mov	eax, 1
.L52:
	add	rsp, 56
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
	.cfi_endproc
.LFE7:
	.size	init_GL_context, .-init_GL_context
	.section	.rodata.str1.1
.LC50:
	.string	"Had to re-initialize GL context."
	.text
	.globl	maintain_context
	.type	maintain_context, @function
maintain_context:
.LFB11:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	mov	rbx, rdi
	push	r10
	.cfi_def_cfa_offset 32
	call	glXGetCurrentContext@PLT
	mov	rbp, rax
	call	glXGetCurrentDrawable@PLT
	test	rax, rax
	je	.L73
	test	rbp, rbp
	jne	.L72
.L73:
	lea	rdi, .LC50[rip]
	call	DisplayWarning@PLT
.L75:
	mov	rdi, rbx
	call	init_GL_context@PLT
	test	eax, eax
	je	.L75
.L72:
	pop	r9
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE11:
	.size	maintain_context, .-maintain_context
	.section	.rodata.str1.1
.LC51:
	.string	"Failed to rebound 2-D texture image."
	.text
	.globl	rebound_screen_texture
	.type	rebound_screen_texture, @function
rebound_screen_texture:
.LFB15:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r15d, esi
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
	mov	rbp, r12
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 40
	.cfi_def_cfa_offset 96
	mov	rbx, QWORD PTR name_tex@GOTPCREL[rip]
	mov	edi, DWORD PTR [rbx]
	call	glIsTexture@PLT
	mov	r13, QWORD PTR support_buffer_objects@GOTPCREL[rip]
	mov	r14b, al
	cmp	BYTE PTR 0[r13], 0
	je	.L78
	mov	rax, QWORD PTR xglBindBuffer@GOTPCREL[rip]
	xor	esi, esi
	mov	edi, 34962
	xor	ebp, ebp
	call	[QWORD PTR [rax]]
	mov	rax, QWORD PTR xglDeleteBuffers@GOTPCREL[rip]
	mov	rsi, QWORD PTR name_buf@GOTPCREL[rip]
	mov	edi, 2
	call	[QWORD PTR [rax]]
.L78:
	mov	rax, QWORD PTR support_pixel_DMAs@GOTPCREL[rip]
	cmp	BYTE PTR [rax], 0
	je	.L79
	mov	rax, QWORD PTR xglBindBuffer@GOTPCREL[rip]
	xor	esi, esi
	mov	edi, 35052
	call	[QWORD PTR [rax]]
.L79:
	cmp	BYTE PTR 0[r13], 0
	je	.L80
	mov	r13, QWORD PTR name_buf@GOTPCREL[rip]
	mov	rax, QWORD PTR xglGenBuffers@GOTPCREL[rip]
	mov	edi, 2
	mov	rsi, r13
	call	[QWORD PTR [rax]]
	mov	rax, QWORD PTR xglBindBuffer@GOTPCREL[rip]
	mov	esi, DWORD PTR 4[r13]
	mov	edi, 34962
	call	[QWORD PTR [rax]]
	mov	rax, QWORD PTR xglBufferData@GOTPCREL[rip]
	mov	ecx, 35044
	mov	rdx, r12
	mov	esi, 64
	mov	edi, 34962
	call	[QWORD PTR [rax]]
.L80:
	cmp	r15d, 1
	mov	esi, 10241
	mov	edi, 3553
	sbb	r12d, r12d
	add	r12d, 9729
	mov	edx, r12d
	call	glTexParameteri@PLT
	mov	edx, r12d
	mov	esi, 10240
	mov	edi, 3553
	call	glTexParameteri@PLT
	test	r14b, r14b
	jne	.L82
	mov	edi, 3553
	call	glEnable@PLT
	mov	rsi, rbx
	mov	edi, 1
	call	glDeleteTextures@PLT
	mov	rsi, rbx
	mov	edi, 1
	call	glGenTextures@PLT
	mov	esi, DWORD PTR [rbx]
	mov	edi, 3553
	call	glBindTexture@PLT
.L82:
	xor	r9d, r9d
	xor	esi, esi
	mov	QWORD PTR 16[rsp], 0
	mov	DWORD PTR 8[rsp], 5121
	mov	DWORD PTR [rsp], 32993
	mov	r8d, 1024
	mov	ecx, 1024
	mov	edx, 4
	mov	edi, 3553
	call	glTexImage2D@PLT
	mov	rax, QWORD PTR support_pixel_DMAs@GOTPCREL[rip]
	cmp	BYTE PTR [rax], 0
	je	.L83
	mov	rax, QWORD PTR name_buf@GOTPCREL[rip]
	mov	edi, 35052
	mov	esi, DWORD PTR [rax]
	mov	rax, QWORD PTR xglBindBuffer@GOTPCREL[rip]
	call	[QWORD PTR [rax]]
	mov	rax, QWORD PTR xglBufferData@GOTPCREL[rip]
	mov	ecx, 35040
	xor	edx, edx
	mov	esi, 4194304
	mov	edi, 35052
	call	[QWORD PTR [rax]]
.L83:
	mov	edi, 32884
	call	glEnableClientState@PLT
	mov	edi, 32888
	call	glEnableClientState@PLT
	lea	rcx, 8[rbp]
	mov	edx, 16
	mov	esi, 5126
	mov	edi, 2
	call	glVertexPointer@PLT
	mov	rcx, rbp
	mov	edx, 16
	mov	esi, 5126
	mov	edi, 2
	call	glTexCoordPointer@PLT
	call	glGetError@PLT
	test	eax, eax
	je	.L77
	add	rsp, 40
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	lea	rdi, .LC51[rip]
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
.L77:
	.cfi_restore_state
	add	rsp, 40
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
.LFE15:
	.size	rebound_screen_texture, .-rebound_screen_texture
	.section	.rodata.str1.1
.LC52:
	.string	"GL_NO_ERROR"
.LC53:
	.string	"GL_INVALID_ENUM"
.LC54:
	.string	"GL_INVALID_VALUE"
.LC55:
	.string	"GL_INVALID_OPERATION"
.LC56:
	.string	"GL_STACK_OVERFLOW"
.LC57:
	.string	"GL_STACK_UNDERFLOW"
.LC58:
	.string	"GL_OUT_OF_MEMORY"
.LC59:
	.string	"GL_UNKNOWN_ERROR"
	.section	.data.rel.ro.local,"aw",@progbits
	.align 16
	.type	GL_errors, @object
	.size	GL_errors, 64
GL_errors:
	.quad	.LC52
	.quad	.LC53
	.quad	.LC54
	.quad	.LC55
	.quad	.LC56
	.quad	.LC57
	.quad	.LC58
	.quad	.LC59
	.comm	xglUnmapBuffer,8,8
	.comm	xglMapBuffer,8,8
	.comm	xglBufferData,8,8
	.comm	xglBindBuffer,8,8
	.comm	xglDeleteBuffers,8,8
	.comm	xglGenBuffers,8,8
	.comm	xglDisableVertexAttribArray,8,8
	.comm	xglEnableVertexAttribArray,8,8
	.comm	xglVertexAttribPointer,8,8
	.comm	xglGetStringi,8,8
	.comm	support_vertex_program,1,1
	.comm	support_pixel_DMAs,1,1
	.comm	support_buffer_objects,1,1
	.comm	support_GDI_bitmap,1,1
	.comm	double_buffering,1,1
	.comm	frame_buffer_draw_list,4,4
	.comm	name_tex,4,4
	.comm	name_buf,8,8
	.section	.rodata
	.align 16
	.type	colors, @object
	.size	colors, 128
colors:
	.long	1061158912
	.long	1061158912
	.long	1061158912
	.long	1065353216
	.long	1061158912
	.long	1061158912
	.long	0
	.long	1065353216
	.long	0
	.long	1061158912
	.long	1061158912
	.long	1065353216
	.long	0
	.long	1061158912
	.long	0
	.long	1065353216
	.long	1061158912
	.long	0
	.long	1061158912
	.long	1065353216
	.long	1061158912
	.long	0
	.long	0
	.long	1065353216
	.long	0
	.long	0
	.long	1061158912
	.long	1065353216
	.long	0
	.long	0
	.long	0
	.long	1065353216
	.data
	.align 16
	.type	my_glColor, @object
	.size	my_glColor, 64
my_glColor:
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.zero	48
	.comm	SDL_desktop,12,8
	.comm	video_info,8,8
	.comm	video_surface,8,8
	.comm	GLX_context,8,8
	.comm	GLX_window,8,8
	.comm	GLX_display,8,8
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC29:
	.long	1065353216
	.align 4
.LC33:
	.long	1033476506
	.align 4
.LC37:
	.long	1049774373
	.align 4
.LC39:
	.long	1058162981
	.align 4
.LC43:
	.long	1060559726
	.align 4
.LC46:
	.long	1052171118
	.ident	"GCC: (GNU) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
