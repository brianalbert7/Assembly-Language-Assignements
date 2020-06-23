TITLE Program Template			(main.asm)

; Program Description:		Lab for Irvine Ch 8 - Starting Point
; Author:					Starting Point:  Stephen Brower ( based on a Java lab by Tony Gaddis )
; 							based on Kip Irvine's Template
; Date Created:				10/23/2019
; Last Modification Date:	     10/24/2019

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

; (insert variables here - flush left)
signToDisplay1 BYTE "No parking!",0	; message to display multiple times using procedure receiving registers as parms
signToDisplay2 BYTE "No smoking!",0	; message to display multiple times using procuedre using stack as parms
byeMessage BYTE "Bye bye!",0		; farewell message

.code
main PROC
	; (insert executable instructions here -- indented)

	mov ecx, 3						; load ECX with number of times to display sign
	mov edx, offset signToDisplay1	; load EDX with offset of message to display
	call signUsingRegisters			; call method to display sign multiple times
	call CRLF						; \n

	push 7							; push number of times to display to stack
	push offset signToDisplay2		; push offset of message to display
	call signUsingStack				; call method to display sign multiple times
       
	call CRLF						; \n
	mov edx, offset byeMessage		; load EDX with farewell message to display
	CALL writeString				; display string
	call CRLF						; \n

	exit							; exit to operating system
main ENDP

; (insert additional procedures here)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; signUsingRegisters displays a sign multiple times
; Input:  EDX - offset of string to display
;         ECX - number of times to display String
signUsingRegisters PROC

L1:
	CALL writeString				; display string
	CALL CRLF						; \n
	Loop L1

	ret
signUsingRegisters ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; signUsingStack displays a sign multiple times
;
; author of this procedure: Brian Albert
;
; Input:  EDX - offset of string to display
;         ECX - number of times to display String
signUsingStack PROC USES ECX EDX EBP

	MOV EBP, ESP					; make EBP a copy of stack pointer ESP
	MOV ECX, [ebp+20]				; load ECX with # of times to display sign
	MOV EDX, [ebp+16]	               ; load EDX with message to display
L2:
	CALL writeString				; display string
	CALL CRLF						; \n
	Loop L2

	ret 8
signUsingStack ENDP

END main
