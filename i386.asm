		.386
		.model flat, stdcall
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		jmp	code_segment
reloc_segment:
Kernel32	dd	0
LoadLibraryA	dd	0
GetProcAddress	dd	0
ExitProcess	dd	0

const_segment:
MessageBoxA	db	"MessageBoxA",0

code_segment:
		push	offset MessageBoxA
		push	Kernel32
		call	GetProcAddress
		
		push	0
		push	0
		push	offset MessageBoxA
		push	0
		call	eax
		
		call	ExitProcess
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end