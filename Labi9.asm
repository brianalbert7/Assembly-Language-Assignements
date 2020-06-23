TITLE Program Template			(main.asm)

; Program Description:		Lab for Irvine Ch 9
; Author:					Stephen Brower [ you put your name on line 147]
; 							based on Kip Irvine's Template
; Date Created:				10/30/2019 ( using demo2DarrayProcV3.asm as starting point)
; Last Modification Date:	

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

; (insert variables here - flush left)
MAX_ROWS = 10			; constant for num rows
MAX_COLS = 10			; constant for num cols
my2DArray dword MAX_ROWS * MAX_COLS dup(0)		; creates 2-d array
spaceStr byte " ",0		; for displaying a space
displayHeader byte "Contents of my2DArray:",0		; string to display before report

.code
main PROC
	; (insert executable instructions here -- indented)
	call randomize						; stir the pot

										; at this point my2DArray is full of 0s
	mov ecx, MAX_ROWS * MAX_COLS		;
	mov esi, offset my2DArray			;
L1:
	mov eax, 100						; load EAX for generating random
	call randomRange					; EAX now has 0..99
	add eax, 100						; EAX now has 100..199
	mov [esi], eax						; store random# to memory
	add esi, 4
	Loop L1

										; call proc to display array
	call displayMy2DArray
	call CRLF

										; test getter

										; upper left
	mov eax, 0							; load eax with row
	mov ebx, 0							; load ebx with col

	push eax							; hold on to row
	push ebx							; hold on to col
	call getElementFromArray
	pop ebx								; get back ebx
	pop eax								; get back eax

	call displayCoordsAndValue			; displays eax,ebx=ecx

	mov eax, 9
	call writeChar						; \t
	call writeChar						; \t
	call writeChar						; \t
	call writeChar						; \t

										; upper right
	mov eax, 0							; load eax with row
	mov ebx, MAX_COLS-1					; load ebx with col

	push eax							; hold on to row
	push ebx							; hold on to col
	call getElementFromArray
	pop ebx								; get back ebx
	pop eax								; get back eax

	call displayCoordsAndValue			; displays eax,ebx=ecx

	call crlf							; \n

	mov eax, 9
	call writeChar
	call writeChar
										; approximate middle
	mov eax, MAX_ROWS/2					; load eax with row
	mov ebx, MAX_COLS/2					; load ebx with col

	push eax							; hold on to row
	push ebx							; hold on to col
	call getElementFromArray
	pop ebx								; get back ebx
	pop eax								; get back eax

	call displayCoordsAndValue			; displays eax,ebx=ecx

	call crlf							; \n

										; lower left
	mov eax, MAX_ROWS-1					; load eax with row
	mov ebx, 0							; load ebx with col

	push eax							; hold on to row
	push ebx							; hold on to col
	call getElementFromArray
	pop ebx								; get back ebx
	pop eax								; get back eax

	call displayCoordsAndValue			; displays eax,ebx=ecx

	mov eax, 9
	call writeChar						; \t
	call writeChar						; \t
	call writeChar						; \t
	call writeChar						; \t


										; lower right
	mov eax, MAX_ROWS-1					; load eax with row
	mov ebx, MAX_COLS-1					; load ebx with col

	push eax							; hold on to row
	push ebx							; hold on to col
	call getElementFromArray
	pop ebx								; get back ebx
	pop eax								; get back eax

	call displayCoordsAndValue			; displays eax,ebx=ecx

	call crlf							; \n



	; call dumpRegs						; display registers
	exit								; exit to operating system
main ENDP

; (insert additional procedures here)



		; =============================================
		; getElementFromArray procedure expects 2 parameters
		;	eax row
		;	ebx col
		; returns 1 parameter
		;	ecx value
		;
		; logically this will be like:  ecx=my2DArray[eax,ebx]
        ;
        ; proc assumes that MAX_ROWS, MAX_COLS, and my2DArray are declared
		;
		; this proc written by: Brian Albert
        ;
getElementFromArray PROC 
     
     mov edx, 0               ; prepare for mul

     push ebx                 ; put ebx the col on the stack

     mov ebx, MAX_COLS*4      ; calculate the number of bytes in a row

     mul ebx                  ; eax is now row*MAX_COLS*4 which is the total bytes before the current row
     mov edi, eax             ; put byte offset into edi

     pop eax                  ; put ebx on eax

     mov ebx, 4               ; load ebx with 4 for size of element (integer)
     mul ebx                  ; eax is now the byte offset in the current row
     add edi, eax             ; edi is now the byte offset from the beginning of the array to this element row, col

     mov ecx, my2DArray[edi]  ; put array value into ecx

	ret
getElementFromArray ENDP

		; =============================================
		; displayCoordsAndValue displays eax,ebx=ecx
		;		
displayCoordsAndValue PROC
	call padOnLeft
	call writeDec						; display row

	mov al,','							; display ,
	call writeChar

	mov eax, ebx						; load eax with col from EBX
	call padOnLeft
	call writeDec						; display col

	mov al,'='							; display =
	call writeChar

	mov eax, ecx						; load ecx with value from ECX
	call writeDec						; display value
	ret
displayCoordsAndValue ENDP

		; =============================================
		; displayMy2DArray procedure expects no parameters
		;		
displayMy2DArray PROC uses edx edi ecx eax

	call crlf							; blank line
	mov edx, offset displayHeader		; load edx with address of header
	call writestring					; display header
	call crlf							; move to beginning of next line

	mov eax, ' '
	call writeChar						; display space
	call writeChar						; display space
	call writeChar						; display space
	call writeChar						; display space
	call writeChar						; display space

	mov ecx, MAX_COLS					; load ECX with # of cols
	mov eax, 0							; initialize EAX to 0 -- for this loop, EAX is col#
displayColHeaders:
	call padOnLeft
	call writeDec						; display col header
	push eax							; back up col#
	mov eax, ' '						; display space
	call writeChar
	pop eax								; restore col#
	inc eax								; inc col#
	loop displayColHeaders				; repeat
	call crlf							; \n

	mov edi, 0							; load edi with 0 offset

	mov ecx, MAX_ROWS					; load ecx with number of rows so we can loop through rows

displayRow:								; top of outerloop on rows

										; display row#
	mov eax, MAX_ROWS					; load EAX with MAX_ROWS
	sub eax, ecx						; subtract ECX to get row number
	call padOnLeft						; pad to line up
	call writeDec						; display row#
	mov eax, ':'						; display :
	call writeChar

	push ecx							; preserve ecx from outloop to use innerloop

	mov ecx, MAX_COLS					; load ecx with number of cols so we can loop through cols

displayCol:								; top of innerloop on cols
	mov eax, my2DArray[edi]				; move element from array to eax for display
	call padOnLeft						; pad with spaces

										; for debugging purposes show . instead of 0
    cmp eax, 0
	jne displayDec
	push eax						; preserve EAX
	mov al, '.'						; display .
	call writeChar
	pop eax							; restore EAX
	jmp skipDisplayDec
displayDec:
	call writedec					; display element

skipDisplayDec:

	mov edx, offset spaceStr			; display a space
	call writestring

	add edi,4							; advance dsi to next element

	loop displayCol						; bottom of innerloop (loop on cols)

	call crlf							; now that a row has been displayed, move to beginning of next line for next row

	pop ecx								; restore ecx for outerloop on rows

	loop displayRow						; bottom of outerloop (loop on rows)

	ret									; done with this method
displayMy2DArray ENDP

		; =============================================
		; padOnLeft procedure expects 1 parameters
		;		eax with value to pad
		;		
padOnLeft PROC uses edx

    cmp eax, 1000						; compare eax to 1000
	jae maxedOut						; if eax >= 1000 - no need to further pad

										; < 1000 display space
	mov edx, offset spaceStr			; display space
	call writestring

nextDigit100:
	cmp eax, 100						; compare eax to 100
    jae maxedOut						; if eax >= 100 no need to further pad

										; < 100 display space
	mov edx, offset spaceStr			; display space
	call writestring

nextDigit10:
    cmp eax, 10							; compare eax to 10
	jae maxedOut						; if eax >= 10 no need to further pad

										; < 10 display space
	mov edx, offset spaceStr			; display space
	call writestring

maxedOut:		    
	ret
padOnLeft ENDP

END main
