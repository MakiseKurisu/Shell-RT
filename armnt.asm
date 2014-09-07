		area	.text, code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		b	code_segment
reloc_segment
Kernel32	dcd	0
LoadLibraryA	dcd	0
GetProcAddress	dcd	0
ExitProcess	dcd	0

const_segment
MessageBoxA	dcb	"MessageBoxA",0

code_segment
		ldr	r0,=Kernel32
		ldr	r0,[r0]
		ldr	r1,=MessageBoxA
		blx	GetProcAddress

		mov	r4,r0
		mov	r0,0
		mov	r1,r0
		ldr	r2,=MessageBoxA
		mov	r3,r0
		blx	r4

		blx	ExitProcess
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end