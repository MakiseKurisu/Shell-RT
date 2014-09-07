		.386
		.model flat, stdcall
		.code
Address	macro	Register,Tag
		call	@F
@@:		pop	Register
		sub	Register,$-1-Tag
		endm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		jmp	code_segment
reloc_segment:
Kernel32	dd	0	;dd 75e50000,75e6a669,75e6980c,75e77f64
LoadLibraryA	dd	0
GetProcAddress	dd	0

const_segment:
User32	db	"User32.dll",0
MessageBoxA	db	"MessageBoxA",0
ExitProcess	db	"ExitProcess",0

code_segment:
		Address	ecx,User32
		push	ecx
		Address	ecx,LoadLibraryA
		call	dword ptr [ecx]
		
		Address	ecx,MessageBoxA
		push	ecx
		push	eax
		Address	ecx,GetProcAddress
		call	dword ptr [ecx]
		
		push	0
		push	0
		Address	ecx,MessageBoxA
		push	ecx
		push	0
		call	eax
		
		Address	ecx,ExitProcess
		push	ecx
		Address	ecx,Kernel32
		push	[ecx]
		Address	ecx,GetProcAddress
		call	dword ptr [ecx]
		
		push	0
		call	eax
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start