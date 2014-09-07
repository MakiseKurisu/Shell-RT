		.386
		.model flat, stdcall
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		jmp	code_segment
reloc_segment:
Kernel32	dd	0	;dd 75e50000
LoadLibraryA	dd	0	;dd 75e6a669
GetProcAddress	dd	0	;dd 75e6980c

ExitProcess	dd	0	;dd 75e77f64

const_segment:
User32	db	"User32.dll",0
MessageBoxA	db	"MessageBoxA",0

code_segment:
		call	@F
@@:		pop	ecx
		sub	ecx,$-1-User32
		push	ecx
		call	[LoadLibraryA]
		
		call	@F
@@:		pop	ecx
		sub	ecx,$-1-MessageBoxA
		push	ecx
		push	eax
		call	[GetProcAddress]
		
		push	0
		push	0
		call	@F
@@:		pop	ecx
		sub	ecx,$-1-MessageBoxA
		push	ecx
		push	0
		call	eax
		
		push	0
		call	[ExitProcess]
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start