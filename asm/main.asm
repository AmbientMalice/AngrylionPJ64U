	.file	"main.c"
	.intel_syntax noprefix
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Screenshots directory too long."
.LC1:
	.string	"Screenshots directory is about to overflow."
	.text
	.globl	CaptureScreen
	.type	CaptureScreen, @function
CaptureScreen:
.LFB5:
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
	mov	rax, QWORD PTR cfg@GOTPCREL[rip]
	mov	sil, BYTE PTR 4[rax]
	xor	eax, eax
.L3:
	mov	dl, BYTE PTR [rdi+rax]
	mov	ebx, eax
	lea	r12, filepath[rip]
	test	dl, dl
	je	.L2
	mov	BYTE PTR [r12+rax], dl
	inc	rax
	cmp	rax, 256
	jne	.L3
	mov	ebx, 256
.L2:
	lea	eax, -1[rbx]
	cdqe
	mov	al, BYTE PTR [r12+rax]
	cmp	al, 92
	je	.L4
	cmp	al, 47
	je	.L4
	lea	rdx, filepath[rip]
	movsx	rax, ebx
	inc	ebx
	mov	BYTE PTR [rdx+rax], 47
.L4:
	cmp	ebx, 243
	jle	.L5
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	lea	rdi, .LC0[rip]
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
	jmp	DisplayError@PLT
.L5:
	.cfi_restore_state
	mov	rbp, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	xor	eax, eax
	and	sil, -3
	sete	al
	lea	r13, filepath[rip]
	mov	r14d, eax
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR 12[rsp], r14d
	movsx	edi, BYTE PTR 56[rax]
	call	safe_name@PLT
	movsx	rdx, ebx
	mov	BYTE PTR [r12+rdx], al
	mov	rax, QWORD PTR 24[rbp]
	movsx	edi, BYTE PTR 63[rax]
	call	safe_name@PLT
	lea	edx, 1[rbx]
	movsx	rdx, edx
	mov	BYTE PTR [r12+rdx], al
	mov	rax, QWORD PTR 24[rbp]
	movsx	edi, BYTE PTR 62[rax]
	call	safe_name@PLT
	lea	edx, 2[rbx]
	movsx	rdx, edx
	mov	BYTE PTR [r12+rdx], al
	mov	rax, QWORD PTR 24[rbp]
	movsx	edi, BYTE PTR 61[rax]
	call	safe_name@PLT
	lea	edx, 3[rbx]
	lea	esi, 9[rbx]
	test	r14d, r14d
	movsx	rdx, edx
	movsx	rsi, esi
	mov	BYTE PTR [r12+rdx], al
	lea	eax, 8[rbx]
	lea	edx, 10[rbx]
	cdqe
	mov	BYTE PTR [r12+rax], 46
	lea	eax, 11[rbx]
	je	.L6
	movsx	rdx, edx
	cdqe
	mov	BYTE PTR 0[r13+rsi], 100
	mov	BYTE PTR 0[r13+rdx], 105
	mov	BYTE PTR 0[r13+rax], 98
	jmp	.L7
.L6:
	movsx	rdx, edx
	cdqe
	mov	BYTE PTR 0[r13+rsi], 98
	mov	BYTE PTR 0[r13+rdx], 109
	mov	BYTE PTR 0[r13+rax], 112
.L7:
	lea	eax, 12[rbx]
	lea	r15d, 4[rbx]
	lea	r14d, 5[rbx]
	lea	r13d, 6[rbx]
	add	ebx, 7
	cdqe
	movsx	r15, r15d
	movsx	r14, r14d
	mov	BYTE PTR [r12+rax], 0
	movsx	r13, r13d
	movsx	rbx, ebx
.L10:
	cmp	WORD PTR count_[rip], 9999
	jne	.L8
	lea	rdi, .LC1[rip]
	call	DisplayError@PLT
.L8:
	movsx	eax, WORD PTR count_[rip]
	mov	esi, 10000
	mov	r8d, 100
	inc	eax
	cdq
	idiv	esi
	mov	esi, 1000
	mov	edi, edx
	mov	WORD PTR count_[rip], dx
	mov	eax, edx
	sar	dx, 15
	idiv	si
	mov	esi, 10
	mov	edx, eax
	sar	dx, 15
	idiv	si
	mov	eax, edi
	add	edx, 48
	mov	BYTE PTR [r12+r15], dl
	mov	edx, edi
	sar	dx, 15
	idiv	r8w
	mov	edx, eax
	sar	dx, 15
	idiv	si
	mov	eax, edi
	add	edx, 48
	mov	BYTE PTR [r12+r14], dl
	mov	edx, edi
	lea	rdi, filepath[rip]
	sar	dx, 15
	idiv	si
	mov	r8d, edx
	mov	edx, eax
	sar	dx, 15
	add	r8d, 48
	idiv	si
	add	edx, 48
	mov	BYTE PTR [r12+r13], dl
	mov	BYTE PTR [r12+rbx], r8b
	call	file_exists@PLT
	test	eax, eax
	jne	.L10
	cmp	DWORD PTR 12[rsp], 0
	je	.L11
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	lea	rdi, filepath[rip]
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
	jmp	capture_screen_to_file@PLT
.L11:
	.cfi_restore_state
	mov	rax, QWORD PTR 128[rbp]
	lea	rdi, filepath[rip]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR capture_FB_to_file@GOTPCREL[rip]
	and	edx, 1
	mov	rax, QWORD PTR [rax+rdx*8]
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
	jmp	rax
	.cfi_endproc
.LFE5:
	.size	CaptureScreen, .-CaptureScreen
	.section	.rodata.str1.1
.LC2:
	.string	"Invalid resolution control setting."
	.text
	.globl	ChangeWindow
	.type	ChangeWindow, @function
ChangeWindow:
.LFB6:
	.cfi_startproc
	sub	rsp, 24
	.cfi_def_cfa_offset 32
	mov	rax, QWORD PTR is_full_screen@GOTPCREL[rip]
	mov	DWORD PTR 8[rsp], 0
	mov	DWORD PTR 12[rsp], 0
	cmp	DWORD PTR [rax], 0
	jne	.L25
	lea	rdi, 8[rsp]
	mov	DWORD PTR [rax], 1
	call	get_screen_size@PLT
	jmp	.L26
.L25:
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR cfg@GOTPCREL[rip]
	cmp	BYTE PTR 4[rax], 2
	jbe	.L26
	lea	rdi, .LC2[rip]
	call	DisplayError@PLT
.L26:
	mov	rax, QWORD PTR video_sync@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
	add	rsp, 24
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6:
	.size	ChangeWindow, .-ChangeWindow
	.globl	CloseDLL
	.type	CloseDLL, @function
CloseDLL:
.LFB7:
	.cfi_startproc
	jmp	SDL_Quit@PLT
	.cfi_endproc
.LFE7:
	.size	CloseDLL, .-CloseDLL
	.globl	DrawScreen
	.type	DrawScreen, @function
DrawScreen:
.LFB8:
	.cfi_startproc
	ret
	.cfi_endproc
.LFE8:
	.size	DrawScreen, .-DrawScreen
	.globl	GetDllInfo
	.type	GetDllInfo, @function
GetDllInfo:
.LFB9:
	.cfi_startproc
	mov	WORD PTR [rdi], 259
	mov	WORD PTR 2[rdi], 2
	xor	eax, eax
	mov	DWORD PTR 104[rdi], 1
	mov	DWORD PTR 108[rdi], 1
.L33:
	lea	rdx, DLL_name[rip]
	mov	dl, BYTE PTR [rdx+rax]
	mov	BYTE PTR 4[rdi+rax], dl
	inc	rax
	cmp	rax, 32
	jne	.L33
	ret
	.cfi_endproc
.LFE9:
	.size	GetDllInfo, .-GetDllInfo
	.globl	InitiateGFX
	.type	InitiateGFX, @function
InitiateGFX:
.LFB10:
	.cfi_startproc
	mov	rax, QWORD PTR emulation_running@GOTPCREL[rip]
	mov	rdi, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	lea	rsi, 8[rsp]
	mov	ecx, 62
	rep movsd
	mov	DWORD PTR [rax], 0
	mov	eax, 1
	ret
	.cfi_endproc
.LFE10:
	.size	InitiateGFX, .-InitiateGFX
	.globl	MoveScreen
	.type	MoveScreen, @function
MoveScreen:
.LFB11:
	.cfi_startproc
	cmp	DWORD PTR xpos_old.19536[rip], edi
	jne	.L36
	cmp	DWORD PTR ypos_old.19537[rip], esi
	je	.L35
.L36:
	mov	rax, QWORD PTR video_sync@GOTPCREL[rip]
	mov	DWORD PTR xpos_old.19536[rip], edi
	mov	DWORD PTR ypos_old.19537[rip], esi
	mov	DWORD PTR [rax], 1
.L35:
	ret
	.cfi_endproc
.LFE11:
	.size	MoveScreen, .-MoveScreen
	.section	.rodata.str1.1
.LC3:
	.string	"Unidentified microcode."
	.text
	.globl	ProcessDList
	.type	ProcessDList, @function
ProcessDList:
.LFB12:
	.cfi_startproc
	lea	rdi, .LC3[rip]
	jmp	DisplayError@PLT
	.cfi_endproc
.LFE12:
	.size	ProcessDList, .-ProcessDList
	.globl	ProcessRDPList
	.type	ProcessRDPList, @function
ProcessRDPList:
.LFB13:
	.cfi_startproc
	jmp	process_RDP_list@PLT
	.cfi_endproc
.LFE13:
	.size	ProcessRDPList, .-ProcessRDPList
	.section	.rodata.str1.1
.LC4:
	.string	"RDP_CONF.BIN"
	.text
	.globl	RomClosed
	.type	RomClosed, @function
RomClosed:
.LFB14:
	.cfi_startproc
	push	rax
	.cfi_def_cfa_offset 16
	mov	rax, QWORD PTR emulation_running@GOTPCREL[rip]
	lea	rdi, .LC4[rip]
	mov	rsi, QWORD PTR cfg@GOTPCREL[rip]
	mov	edx, 32
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR SaveLoaded@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
	mov	rax, QWORD PTR command_counter@GOTPCREL[rip]
	mov	DWORD PTR [rax], 0
	call	file_out@PLT
	pop	rdx
	.cfi_def_cfa_offset 8
	jmp	CloseDLL@PLT
	.cfi_endproc
.LFE14:
	.size	RomClosed, .-RomClosed
	.section	.rodata.str1.1
.LC5:
	.string	"Could not open `RDP_CONF.BIN'."
	.text
	.globl	RomOpen
	.type	RomOpen, @function
RomOpen:
.LFB15:
	.cfi_startproc
	push	rsi
	.cfi_def_cfa_offset 16
	call	rdp_init@PLT
	mov	rax, QWORD PTR emulation_running@GOTPCREL[rip]
	mov	rsi, QWORD PTR cfg@GOTPCREL[rip]
	lea	rdi, .LC4[rip]
	mov	edx, 32
	mov	DWORD PTR [rax], 1
	mov	rax, QWORD PTR video_sync@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
	mov	rax, QWORD PTR pitchindwords@GOTPCREL[rip]
	mov	DWORD PTR [rax], 640
	call	file_in@PLT
	test	eax, eax
	jne	.L43
	lea	rdi, .LC5[rip]
	call	DisplayError@PLT
.L43:
	mov	esi, 480
	mov	edi, 640
	call	screen_resize@PLT
	mov	rax, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rdi, QWORD PTR [rax]
	call	init_GL_context@PLT
	mov	ecx, 480
	xor	esi, esi
	xor	edi, edi
	mov	edx, 640
	call	glViewport@PLT
	mov	rax, QWORD PTR stdout@GOTPCREL[rip]
	mov	edi, 10
	mov	rsi, QWORD PTR [rax]
	pop	rcx
	.cfi_def_cfa_offset 8
	jmp	fputc@PLT
	.cfi_endproc
.LFE15:
	.size	RomOpen, .-RomOpen
	.globl	UpdateScreen
	.type	UpdateScreen, @function
UpdateScreen:
.LFB17:
	.cfi_startproc
	mov	rdx, QWORD PTR cfg@GOTPCREL[rip]
	mov	al, BYTE PTR called_count[rip]
	cmp	al, BYTE PTR 14[rdx]
	jae	.L46
	inc	eax
	mov	BYTE PTR called_count[rip], al
	ret
.L46:
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, QWORD PTR emulation_running@GOTPCREL[rip]
	mov	BYTE PTR called_count[rip], 0
	cmp	DWORD PTR [rbx], 0
	je	.L45
	mov	rax, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rdi, QWORD PTR [rax]
	call	maintain_context@PLT
	cmp	DWORD PTR [rbx], 0
	je	.L45
	call	rdp_update@PLT
	mov	rdx, QWORD PTR thread_stage@GOTPCREL[rip]
	mov	ebx, eax
	cmp	DWORD PTR [rdx], 0
	jne	.L50
	lea	rdi, filepath[rip]
	mov	DWORD PTR [rdx], 1
	call	capture_screen_to_file@PLT
.L50:
	test	ebx, ebx
	jne	.L45
	pop	rbx
	.cfi_remember_state
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	jmp	swap_buffers@PLT
.L45:
	.cfi_restore_state
	pop	rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE17:
	.size	UpdateScreen, .-UpdateScreen
	.globl	ShowCFB
	.type	ShowCFB, @function
ShowCFB:
.LFB16:
	.cfi_startproc
	jmp	UpdateScreen@PLT
	.cfi_endproc
.LFE16:
	.size	ShowCFB, .-ShowCFB
	.section	.rodata.str1.1
.LC6:
	.string	"New VI_CONTROL_REG:  0x00000000"
	.text
	.globl	ViStatusChanged
	.type	ViStatusChanged, @function
ViStatusChanged:
.LFB18:
	.cfi_startproc
	sub	rsp, 40
	.cfi_def_cfa_offset 48
	mov	rax, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	lea	rsi, .LC6[rip]
	mov	rdi, rsp
	mov	ecx, 8
	rep movsd
	mov	rax, QWORD PTR 128[rax]
	mov	rdi, rsp
	mov	esi, DWORD PTR [rax]
	lea	rax, digits[rip]
	mov	edx, esi
	and	esi, 15
	mov	rcx, rdx
	shr	rcx, 28
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 23[rsp], cl
	mov	rcx, rdx
	shr	rcx, 24
	and	ecx, 15
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 24[rsp], cl
	mov	rcx, rdx
	shr	rcx, 20
	and	ecx, 15
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 25[rsp], cl
	mov	rcx, rdx
	shr	rcx, 16
	and	ecx, 15
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 26[rsp], cl
	mov	rcx, rdx
	shr	rcx, 12
	and	ecx, 15
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 27[rsp], cl
	mov	rcx, rdx
	shr	rdx, 4
	shr	rcx, 8
	and	edx, 15
	and	ecx, 15
	mov	dl, BYTE PTR [rax+rdx]
	mov	cl, BYTE PTR [rax+rcx]
	mov	al, BYTE PTR [rax+rsi]
	mov	BYTE PTR 29[rsp], dl
	mov	BYTE PTR 30[rsp], al
	mov	BYTE PTR 28[rsp], cl
	call	DisplayInStatusPanel@PLT
	mov	rax, QWORD PTR video_sync@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
	add	rsp, 40
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE18:
	.size	ViStatusChanged, .-ViStatusChanged
	.section	.rodata.str1.1
.LC8:
	.string	"Failed to clear screen."
.LC7:
	.string	"New VI_H_WIDTH_REG:  0x00000000"
	.text
	.globl	ViWidthChanged
	.type	ViWidthChanged, @function
ViWidthChanged:
.LFB19:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	lea	rsi, .LC7[rip]
	mov	ecx, 8
	sub	rsp, 32
	.cfi_def_cfa_offset 48
	mov	rbx, QWORD PTR RCP_info_VI@GOTPCREL[rip]
	mov	rdi, rsp
	rep movsd
	mov	rax, QWORD PTR 144[rbx]
	mov	rdi, rsp
	mov	esi, DWORD PTR [rax]
	lea	rax, digits[rip]
	mov	edx, esi
	and	esi, 15
	mov	rcx, rdx
	shr	rcx, 28
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 23[rsp], cl
	mov	rcx, rdx
	shr	rcx, 24
	and	ecx, 15
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 24[rsp], cl
	mov	rcx, rdx
	shr	rcx, 20
	and	ecx, 15
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 25[rsp], cl
	mov	rcx, rdx
	shr	rcx, 16
	and	ecx, 15
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 26[rsp], cl
	mov	rcx, rdx
	shr	rcx, 12
	and	ecx, 15
	mov	cl, BYTE PTR [rax+rcx]
	mov	BYTE PTR 27[rsp], cl
	mov	rcx, rdx
	shr	rdx, 4
	shr	rcx, 8
	and	edx, 15
	and	ecx, 15
	mov	dl, BYTE PTR [rax+rdx]
	mov	cl, BYTE PTR [rax+rcx]
	mov	al, BYTE PTR [rax+rsi]
	mov	BYTE PTR 29[rsp], dl
	mov	BYTE PTR 30[rsp], al
	mov	BYTE PTR 28[rsp], cl
	call	DisplayInStatusPanel@PLT
	mov	rax, QWORD PTR emulation_running@GOTPCREL[rip]
	cmp	DWORD PTR [rax], 0
	je	.L55
	mov	rdi, QWORD PTR [rbx]
	call	maintain_context@PLT
	mov	edi, 16384
	call	glClear@PLT
	call	glGetError@PLT
	test	eax, eax
	je	.L57
	lea	rdi, .LC8[rip]
	mov	esi, eax
	call	DisplayGLError@PLT
.L57:
	mov	rax, QWORD PTR video_sync@GOTPCREL[rip]
	mov	DWORD PTR [rax], 1
.L55:
	add	rsp, 32
	.cfi_def_cfa_offset 16
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE19:
	.size	ViWidthChanged, .-ViWidthChanged
	.globl	ReadScreen
	.type	ReadScreen, @function
ReadScreen:
.LFB20:
	.cfi_startproc
	ret
	.cfi_endproc
.LFE20:
	.size	ReadScreen, .-ReadScreen
	.local	ypos_old.19537
	.comm	ypos_old.19537,4,4
	.local	xpos_old.19536
	.comm	xpos_old.19536,4,4
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
	.local	called_count
	.comm	called_count,1,1
	.align 16
	.type	DLL_name, @object
	.size	DLL_name, 32
DLL_name:
	.string	"angrylion's RDP with OpenGL 1.5"
	.data
	.align 2
	.type	count_, @object
	.size	count_, 2
count_:
	.value	-1
	.local	filepath
	.comm	filepath,256,16
	.globl	is_full_screen
	.bss
	.align 4
	.type	is_full_screen, @object
	.size	is_full_screen, 4
is_full_screen:
	.zero	4
	.comm	RCP_info_VI,248,16
	.globl	zeldainfo
	.align 8
	.type	zeldainfo, @object
	.size	zeldainfo, 8
zeldainfo:
	.zero	8
	.globl	emulation_running
	.align 4
	.type	emulation_running, @object
	.size	emulation_running, 4
emulation_running:
	.zero	4
	.comm	pitchindwords,4,4
	.ident	"GCC: (GNU) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
