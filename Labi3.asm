TITLE Program Template			(main.asm)

; Program Description:		Lab for Irvine Ch 4
; Author:					Brian Albert
; 							based on Kip Irvine's Template
; Date Created:				9/19/2019
; Last Modification Date:	

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

; (insert variables here - flush left)

startingInventory DWORD 132			; value for the beginning inventory
endingInventory DWORD ?				; value of inventory to be determined
								; daily # of items sold 
numberItemsSoldByDayForPeriod DWORD 8, 6, 7, 5, 3, 0, 9

.code
main PROC
	; (insert executable instructions here -- indented)
     mov eax,0                                         ; clears eax
     mov ebx,0                                         ; clears ebx
     mov ecx,0                                         ; clears ecx
     mov edx,0                                         ; clears edx

     mov edi,OFFSET numberItemsSoldByDayForPeriod      ; address of numberItemsSoldByDayForPeriod
     mov ecx,LENGTHOF numberItemsSoldByDayForPeriod    ; loop counter
     mov edx,0                                         ; zero the accumulator

L1:                                                    ; loop to find the sum of numberItemsSoldByDayForPeriod array
     add edx,[edi]                                     ; adds an integer
     add edi,TYPE numberItemsSoldByDayForPeriod        ; point to the next integer
     Loop L1                                           ; repeat until ecx = 0

     mov ebx, startingInventory                        ; loads the starting inventory into ebx
     sub ebx, edx                                      ; subtracts edx from ebx
     mov endingInventory, ebx                          ; loads ebx amount into endingInventory
     mov eax, endingInventory                          ; loads the endingInventory value into eax

	call dumpRegs			; display registers
	exit					; exit to operating system
main ENDP

; (insert additional procedures here)

END main
