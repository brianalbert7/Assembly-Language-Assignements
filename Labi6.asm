TITLE Program Template			(main.asm)

; Program Description:		
; Author:					
; 							based on Kip Irvine's Template
; Date Created:				
; Last Modification Date:	

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

; (insert variables here - flush left)

.code
main PROC
	; (insert executable instructions here -- indented)

	call dumpRegs			; display registers
	exit					; exit to operating system
main ENDP

; (insert additional procedures here)

END main
