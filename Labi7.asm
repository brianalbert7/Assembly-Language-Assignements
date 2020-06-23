TITLE Lab 7			(main.asm)

; Program Description:		Lab 7 - SHELL
; Author:					Stephen Brower
; Edited by Brian Albert
; Date Created:				10/12/2016
; Last Modification Date:	10/9/2019 - added call to procedure for displaying arrays neatly


INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

; (insert variables here - flush left)
											; later we will see STRUC to group fields
operand1 SDWORD 8, 6,7,5,3,-10,89			; set of first operands
operand2 SDWORD 3,-2,6,7,2,  3,10			; set of second operands

sum SDWORD LENGTHOF operand1 DUP(0)			; to hold sum ( operand1 + operand2 )
difference SDWORD LENGTHOF operand1 DUP(0)	; to hold difference ( operand1 - operand2 )

product SDWORD LENGTHOF operand1 DUP(0)		; to hold product ( operand1 x operand2 )
quotient SDWORD LENGTHOF operand1 DUP(0)	; to hold quotient ( operand1 / operand2 )
remainder SDWORD LENGTHOF operand1 DUP(0)	; to hold remainder ( operand1 % operand2 )

operand1Label BYTE "Operand 1:",0			; label for displaying the operand1 array
operand2Label BYTE "Operand 2:",0			; label for displaying the operand2 array
sumLabel BYTE "Sum:",0						; label for displaying the sum array
differenceLabel BYTE "Difference:",0		; label for displaying the difference array
productLabel BYTE "Product:",0				; label for displaying the product array
quotientLabel BYTE "Quotient:",0			; label for displaying the quotient array
remainderLabel BYTE "Remainder:",0			; label for displaying the remainder array

.code
main PROC
	; (insert executable instructions here -- indented)

	MOV EDI,0
	MOV ECX, LENGTHOF operand1		; assumed operand1 and operand2 same size
topLoop:
	MOV EAX, operand1[EDI]			; load eax with operand1
	ADD EAX, operand2[EDI]			; add to EAX operand2

	MOV sum[EDI], EAX				; stick the sum in the sum array

	MOV EAX, operand1[EDI]			; load eax with operand1
	SUB EAX, operand2[EDI]			; subtract from EAX operand2

	MOV difference[EDI], EAX		; stick the difference in the sum array

	; Start of code for lab

	MOV EAX, operand1[EDI]        ; load EAX with operand1
	MOV EBX, operand2[EDI]        ; load EBX with operand2         
	iMul EBX                      ; EAX * EBX
	MOV product[EDI], EAX         ; load product with EAX
	MOV EAX, operand1[EDI]        ; load EAX with operand1
     CDQ                           ; prepares edx:eax for iDiv
     iDiv EBX                      ; EAX/EBX
     MOV quotient[EDI], EAX        ; load EBX with quotient
     MOV remainder[EDI], EDX       ; load EDX with remainder

	; End of code for lab
	
	
	ADD EDI, 4						; advance to next set of elements

	LOOP topLoop

	; use CALL displaySignedIntArray to display the operand array, and the sum, difference, product, quotient, and remainder arrays (that's 7 calls)

									; dump the operand1 array
	mov edx, offset operand1Label	; load edx with address of label
	mov esi, offset operand1		; address of array
	mov ecx, lengthof operand1		; length of array
	call displaySignedIntArray

									; dump the operand2 array
	mov edx, offset operand2Label	; load edx with address of label
	mov esi, offset operand2		; address of array
	mov ecx, lengthof operand2		; length of array
	call displaySignedIntArray

									; dump the sum array
	mov edx, offset sumLabel		; load edx with address of label
	mov esi, offset sum				; address of array
	mov ecx, lengthof sum			; length of array
	call displaySignedIntArray

									; dump the difference array
	mov edx, offset differenceLabel	; load edx with address of label
	mov esi, offset difference		; address of array
	mov ecx, lengthof difference	; length of array
	call displaySignedIntArray

									; dump the product array
	mov edx, offset productLabel	; load edx with address of label
	mov esi, offset product			; address of array
	mov ecx, lengthof product		; length of array
	call displaySignedIntArray

									; dump the quotient array
	mov edx, offset quotientLabel	; load edx with address of label
	mov esi, offset quotient		; address of array
	mov ecx, lengthof quotient		; length of array
	call displaySignedIntArray

									; dump the remainder array
	mov edx, offset remainderLabel	; load edx with address of label
	mov esi, offset remainder		; address of array
	mov ecx, lengthof remainder		; length of array
	call displaySignedIntArray

	exit							; exit to operating system
main ENDP

; (insert additional procedures here)


displaySignedIntArray PROC uses edi edx eax
	call crlf							; \n
	call writeString					; print array label
	call crlf							; \n
topLoop:
	mov eax, [esi]						; load element from array to EAX
	cmp eax, 0							; compare to 0
	jl signedPrint						; if it's negative, go to signedPrint
										; it's positive (treat as unsigned)
	call paddOnLeft						; display spaces on left to lign up data
	call writeDec						; display unsigned int
	jmp writeSpace						; go to delimeter

signedPrint:
	call paddOnLeftNeg					; display spaces on left to lign up data
	call writeInt						; display signed int

writeSpace:
	mov eax, ' '						; load eax with char to display
	call writeChar						; display char

	add esi, 4							; advance to next element
	loop topLoop	
	call crlf							; \n
	ret
displaySignedIntArray ENDP



paddOnLeft PROC
										; since + numbers don't have sign, display space
	push eax							; put # on stack
	mov eax, ' '						; load eax with char to display
	call writeChar						; display char
	pop eax								; get # from top of stack
	cmp eax, 10							; comapre to 10
	jl displayTen						; if < 10 display a space for less than 10
	jmp check100						; go to next position
displayTen:
	push eax							; put # on stack
	mov eax, ' '						; load eax with char to display
	call writeChar						; display char
	pop eax								; get # from top of stack
check100:
	cmp eax, 100						; compare to 100
	jl displayHundred					; if < 100 display a space for < 100
	jmp check1000						; go to next place
displayHundred:
	push eax							; put # on stack
	mov eax, ' '						; load eax with char to display
	call writeChar						; display char
	pop eax								; get # from top of stack

check1000:								; enough for now
	ret
paddOnLeft ENDP



paddOnLeftNeg PROC
	cmp eax, -10						; compare to -10
	jg displayTenNeg					; if > -10 display a space for > -10
	jmp check100Neg						; go to next digit
displayTenNeg:
	push eax							; put # on stack
	mov eax, ' '						; load eax with char to display
	call writeChar						; display char
	pop eax								; get # from top of stack
check100Neg:
	cmp eax, -100						; compare to -100
	jg displayHundredNeg				; if > -100 display a space for > -100
	jmp check1000Neg					; go to next digit
displayHundredNeg:
	push eax							; put # on stack
	mov eax, ' '						; load eax with char to display
	call writeChar						; display char
	pop eax								; get # from top of stack

check1000Neg:							; enough for now
	ret
paddOnLeftNeg ENDP
END main	